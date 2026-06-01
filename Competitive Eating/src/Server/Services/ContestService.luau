-- Core arena state machine: Queuing → Countdown → Active → Results → loop.
-- Three arenas run in parallel, staggered by ARENA_STAGGER seconds.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common        = ReplicatedStorage.Common
local Constants     = require(Common.Constants)
local Utils         = require(Common.Utils)
local Types         = require(Common.Types)
local DataManager      = require(script.Parent.DataManager)
local NpcService       = require(script.Parent.NpcService)
local NpcMemoryService = require(script.Parent.NpcMemoryService)

local ContestService = {}

-- ── State ─────────────────────────────────────────────────────────────────────

local arenas: { Types.Arena } = {}

-- Pending skill-check ring per userId: { biteIndex, expiresAt, result? }
type RingState = { biteIndex: number, expiresAt: number, result: Types.SkillCheckResult? }
local pendingRings: { [number]: RingState } = {}

-- userId → arenaId (for fast lookup during SkillCheckResult)
local playerArena: { [number]: number } = {}

local remotes: { [string]: RemoteEvent } = {}

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function getArena(id: number): Types.Arena?
	for _, a in arenas do
		if a.id == id then return a end
	end
	return nil
end

local function findContestant(arena: Types.Arena, userId: number): Types.ContestantState?
	for _, c in arena.contestants do
		if c.userId == userId then return c end
	end
	return nil
end

local function humanCount(arena: Types.Arena): number
	local n = 0
	for _, c in arena.contestants do
		if not c.isNpc then n += 1 end
	end
	return n
end

local function pickFood(tier: number): string
	local pool = Constants.TIER_FOODS[tier] or Constants.TIER_FOODS[1]
	return pool[math.random(#pool)]
end

local function allDqd(arena: Types.Arena): boolean
	for _, c in arena.contestants do
		if not c.isDqd then return false end
	end
	return true
end

-- ── Fill replication ──────────────────────────────────────────────────────────

local function broadcastFill(arena: Types.Arena, timeLeft: number)
	local fill:  { [string]: number } = {}
	local bites: { [string]: number } = {}

	for _, c in arena.contestants do
		local key = c.isNpc and ("npc_" .. (c.npcName or "")) or tostring(c.userId)
		fill[key]  = c.fillValue
		bites[key] = c.biteCount
	end

	local snapshot: Types.FillSnapshot = {
		arenaId  = arena.id,
		fill     = fill,
		bites    = bites,
		timeLeft = timeLeft,
	}

	for _, c in arena.contestants do
		if not c.isNpc then
			local player = Players:GetPlayerByUserId(c.userId)
			if player then
				remotes.FillUpdate:FireClient(player, snapshot)
			end
		end
	end
end

-- ── Skill-check ring loop (per player, runs during Active) ────────────────────

local function playerRingLoop(player: Player, arena: Types.Arena, contestant: Types.ContestantState)
	local data    = DataManager.get(player)
	if not data then return end

	local biteIndex = 0

	while arena.state == "Active" and not contestant.isDqd do
		biteIndex += 1

		-- Build ring params
		local isOnboarding = not data.firstContestDone
		local nSpeed = Utils.needleSpeed(data.stats.JawSpeed)
		local aWidth = Utils.arcWidth(data.stats.Focus)

		if isOnboarding and data.contestsPlayed == 0 then
			aWidth = aWidth * (1 + Constants.ONBOARDING_FIRST_CONTEST_FILL_ASSIST)
		end

		local params: Types.SkillCheckParams = {
			arenaId     = arena.id,
			food        = arena.currentFood,
			needleSpeed = nSpeed,
			arcWidth    = aWidth,
			arcStart    = Utils.randomArcStart(aWidth),
			duration    = Constants.RING_DURATION,
			biteIndex   = biteIndex,
		}

		pendingRings[player.UserId] = {
			biteIndex = biteIndex,
			expiresAt = tick() + Constants.RING_DURATION + 0.15,
			result    = nil,
		}

		remotes.SkillCheckStart:FireClient(player, params)

		-- Wait for ring window to close
		task.wait(Constants.RING_DURATION + 0.15)

		local ring = pendingRings[player.UserId]
		local wasMiss = true

		if ring and ring.biteIndex == biteIndex then
			-- No response arrived — treat as miss
			pendingRings[player.UserId] = nil
		elseif ring == nil then
			-- Result was already processed and cleared
			wasMiss = false
		end

		if wasMiss then
			task.wait(Constants.RING_MISS_COOLDOWN)
		end
	end
end

-- ── SkillCheckResult handler ─────────────────────────────────────────────────

-- Per-userId anti-cheat: track recent bite times to detect impossible speeds
local lastBiteAt: { [number]: number } = {}
local biteBurstWindow: { [number]: { number } } = {}

local function antiCheatPassed(userId: number, biteIndex: number): boolean
	local now = tick()

	-- Floor: human reaction time minimum (sub-100ms = bot/script)
	-- The ring is shown for RING_DURATION (1.5s); a fire within 100ms of start
	-- is almost certainly automated. We track the time the ring became active
	-- via pendingRings[userId].expiresAt - (RING_DURATION + grace).
	-- Simpler practical check here: cap consecutive bite rate.

	-- Rolling-window: max 12 bites in any 6-second span (already very generous —
	-- normal optimal play is ~1 bite/sec at best).
	local burst = biteBurstWindow[userId] or {}
	-- Drop stale entries
	local i = 1
	while i <= #burst do
		if burst[i] < now - 6 then table.remove(burst, i) else i += 1 end
	end
	if #burst >= 12 then
		warn("[AntiCheat] " .. userId .. " exceeded bite-rate cap (12/6s)")
		return false
	end
	table.insert(burst, now)
	biteBurstWindow[userId] = burst

	-- Floor: minimum 80ms between consecutive bite results
	local last = lastBiteAt[userId]
	if last and now - last < 0.08 then
		warn("[AntiCheat] " .. userId .. " sub-80ms bite interval")
		return false
	end
	lastBiteAt[userId] = now

	return true
end

local function onSkillCheckResult(player: Player, result: any)
	if type(result) ~= "table" then return end

	local userId = player.UserId
	local ring   = pendingRings[userId]
	if not ring then return end
	if ring.biteIndex ~= result.biteIndex then return end
	if tick() > ring.expiresAt then return end

	-- Anti-cheat: validate before crediting the bite
	if not antiCheatPassed(userId, result.biteIndex) then
		pendingRings[userId] = nil
		return
	end

	pendingRings[userId] = nil -- consume

	local arenaId = playerArena[userId]
	if not arenaId then return end

	local arena = getArena(arenaId)
	if not arena or arena.state ~= "Active" then return end

	local contestant = findContestant(arena, userId)
	if not contestant or contestant.isDqd then return end

	if result.hit == true then
		local data    = DataManager.get(player)
		local align   = math.clamp(tonumber(result.alignment) or 0, 0, 1)
		local isGreat = result.isGreat == true

		local fillAmt = Utils.fillPerBite(data.stats.StomachCapacity, align, isGreat)
		contestant.fillValue   = contestant.fillValue + fillAmt
		contestant.biteCount   = contestant.biteCount + 1
		contestant.lastBiteTime = tick()

		if contestant.fillValue >= Constants.FILL_OVERFLOW then
			contestant.isDqd    = true
			contestant.fillValue = Constants.FILL_OVERFLOW
		end
	end
end

-- ── Results & reward ──────────────────────────────────────────────────────────

local function resolveResults(arena: Types.Arena)
	-- Sort by bites desc, DQd contestants go last
	local sorted = table.clone(arena.contestants)
	table.sort(sorted, function(a, b)
		if a.isDqd ~= b.isDqd then return not a.isDqd end
		return a.biteCount > b.biteCount
	end)

	local results = {}
	for place, c in sorted do
		table.insert(results, {
			userId  = not c.isNpc and c.userId or nil,
			npcName = c.npcName,
			bites   = c.biteCount,
			place   = place,
		})
	end
	arena.results = results

	-- Award coins to human players
	for _, entry in results do
		if not entry.userId then continue end
		local player = Players:GetPlayerByUserId(entry.userId)
		if not player then continue end

		local data     = DataManager.get(player)
		if not data then continue end

		local streak   = data.winStreak or 0
		local streakMult = Utils.streakMultiplier(streak)
		local baseCoins  = Constants.COIN_BY_PLACE[entry.place] or Constants.COIN_PARTICIPATION
		local coins      = math.floor(baseCoins * streakMult)

		-- Pity Pit: last-place finisher gets a small consolation bonus on top.
		-- Reframes "you got rekt" as "tried hard, here's a token". State fair 8th-place tradition.
		-- Worst player experience fixed without making losses too rewarding.
		local isLastPlace = (entry.place == Constants.SEATS_PER_ARENA)
		if isLastPlace then
			coins = coins + 15  -- pity pit consolation
		end

		DataManager.addCoins(player, coins)
		DataManager.recordContest(player)

		if entry.place == 1 then
			DataManager.recordWin(player)
		else
			DataManager.recordLoss(player)
		end

		-- Record this player's encounter with every NPC in the contest.
		-- Per-pairing outcome: "win" if player placed ahead of that NPC, else "loss".
		-- Drives familiar/rival catchphrase escalation on future contests.
		for _, opponent in results do
			if opponent.npcName then
				local outcome = (entry.place < opponent.place) and "win" or "loss"
				DataManager.recordNpcEncounter(player, opponent.npcName, outcome)
			end
		end

		local updatedData = DataManager.get(player)
		remotes.StatsUpdate:FireClient(player, updatedData.stats, updatedData.coins, updatedData.highestTier)
		remotes.ShowResults:FireClient(player, results, coins)
	end
end

-- ── Phase runners ─────────────────────────────────────────────────────────────

local function runQueuing(arena: Types.Arena)
	arena.state          = "Queuing"
	arena.contestants    = {}
	arena.results        = nil
	arena.currentFood    = pickFood(arena.tier)
	arena.phaseStartTime = tick()

	local deadline       = tick() + Constants.QUEUE_DURATION
	local lastBroadcast  = 0  -- re-broadcast every 3s so late-joining clients catch up

	local function broadcastQueuing()
		lastBroadcast = tick()
		local timeLeft    = math.max(0, math.floor(deadline - tick()))
		local seatsTaken  = #arena.contestants
		for _, player in Players:GetPlayers() do
			remotes.ContestPhaseChanged:FireClient(player, arena.id, "Queuing", arena.tier, arena.currentFood, nil, seatsTaken, timeLeft)
		end
	end

	broadcastQueuing()

	-- Backfill NPCs at T-10s
	local backfillAt = deadline - Constants.NPC_BACKFILL_TIME
	while tick() < deadline do
		task.wait(0.5)
		if tick() - lastBroadcast >= 3 then
			broadcastQueuing()
		end
		if tick() >= backfillAt and #arena.contestants < Constants.SEATS_PER_ARENA then
			NpcService.assign(arena)
		end
		if #arena.contestants >= Constants.SEATS_PER_ARENA then break end
	end

	-- Always fill remaining seats with NPCs before starting
	NpcService.assign(arena)
end

local function runCountdown(arena: Types.Arena)
	arena.state          = "Countdown"
	arena.phaseStartTime = tick()

	local intro = Constants.SHEA_INTROS[math.random(#Constants.SHEA_INTROS)]

	for _, c in arena.contestants do
		if not c.isNpc then
			local player = Players:GetPlayerByUserId(c.userId)
			if player then
				-- Resolve each NPC's catchphrase against this player's history.
				-- 1st-2nd meeting → catchphrase; 3rd+ → familiar; 10th+ → rival.
				local npcDialogLines: { [string]: string } = {}
				for _, other in arena.contestants do
					if other.isNpc and other.npcName then
						local line = NpcMemoryService.pickDialogLine(player, other.npcName, "intro")
						if line then
							npcDialogLines[other.npcName] = line
						end
					end
				end
				-- 8th positional slot — additive to existing payload (slots 6-7 unused for Countdown).
				remotes.ContestPhaseChanged:FireClient(player, arena.id, "Countdown", arena.tier, arena.currentFood, intro, nil, nil, npcDialogLines)
			end
		end
	end

	task.wait(Constants.COUNTDOWN_DURATION)
end

local function runActive(arena: Types.Arena)
	arena.state          = "Active"
	arena.phaseStartTime = tick()
	local endTime        = tick() + Constants.CONTEST_DURATION

	-- Register players to this arena
	for _, c in arena.contestants do
		if not c.isNpc then
			playerArena[c.userId] = arena.id
			local player = Players:GetPlayerByUserId(c.userId)
			if player then
				remotes.ContestPhaseChanged:FireClient(player, arena.id, "Active")
				task.spawn(playerRingLoop, player, arena, c)
			end
		end
	end

	-- Active tick loop
	local lastFillRepl = tick()
	local lastTick     = tick()

	while tick() < endTime and not allDqd(arena) do
		local now = tick()
		local dt  = now - lastTick
		lastTick  = now

		-- Drain fill meters (SwallowRate stat)
		for _, c in arena.contestants do
			if c.isDqd then continue end
			local drainAmt: number
			if c.isNpc then
				drainAmt = Constants.FILL_DRAIN_BASE * dt
			else
				local data = DataManager.get(Players:GetPlayerByUserId(c.userId))
				if data then
					drainAmt = Utils.drainRate(data.stats.SwallowRate) * dt
				else
					drainAmt = Constants.FILL_DRAIN_BASE * dt
				end
			end
			c.fillValue = math.max(0, c.fillValue - drainAmt)
		end

		-- Tick NPCs
		NpcService.tick(arena, dt)

		-- Replicate fill snapshot
		if now - lastFillRepl >= Constants.FILL_REPLICATE_INTERVAL then
			lastFillRepl = now
			broadcastFill(arena, endTime - now)
		end

		task.wait(0.05)
	end

	arena.state = "Results"

	-- Unregister
	for _, c in arena.contestants do
		if not c.isNpc then
			playerArena[c.userId] = nil
			pendingRings[c.userId] = nil
		end
	end
end

local function runResults(arena: Types.Arena)
	arena.state          = "Results"
	arena.phaseStartTime = tick()

	resolveResults(arena)

	local outro = Constants.SHEA_RESULTS[math.random(#Constants.SHEA_RESULTS)]
	for _, c in arena.contestants do
		if not c.isNpc then
			local player = Players:GetPlayerByUserId(c.userId)
			if player then
				remotes.ContestPhaseChanged:FireClient(player, arena.id, "Results", nil, nil, outro)
			end
		end
	end

	task.wait(Constants.RESULTS_DURATION)

	-- Remove contestants from arena
	for _, c in arena.contestants do
		if not c.isNpc then
			local player = Players:GetPlayerByUserId(c.userId)
			if player then
				remotes.ContestPhaseChanged:FireClient(player, arena.id, "Idle")
			end
		end
	end
end

-- ── Arena main loop ───────────────────────────────────────────────────────────

local function arenaLoop(arena: Types.Arena)
	while true do
		runQueuing(arena)
		runCountdown(arena)
		runActive(arena)
		runResults(arena)
	end
end

-- ── JoinQueue / LeaveQueue ────────────────────────────────────────────────────

local function onJoinQueue(player: Player, requestedArenaId: any)
	-- Prevent double-joining
	if playerArena[player.UserId] then return end

	-- Find the queuing arena (prefer requested, else first available)
	local target: Types.Arena? = nil
	if type(requestedArenaId) == "number" then
		local a = getArena(requestedArenaId)
		if a and a.state == "Queuing" and #a.contestants < Constants.SEATS_PER_ARENA then
			target = a
		end
	end
	if not target then
		for _, a in arenas do
			if a.state == "Queuing" and #a.contestants < Constants.SEATS_PER_ARENA then
				target = a
				break
			end
		end
	end

	if not target then return end

	local contestant: Types.ContestantState = {
		userId       = player.UserId,
		isNpc        = false,
		npcName      = nil,
		fillValue    = 0,
		biteCount    = 0,
		isDqd        = false,
		lastBiteTime = tick(),
	}
	table.insert(target.contestants, contestant)
	playerArena[player.UserId] = target.id

	remotes.ContestPhaseChanged:FireClient(player, target.id, "Queuing", target.tier, target.currentFood)
end

local function onLeaveQueue(player: Player)
	local arenaId = playerArena[player.UserId]
	if not arenaId then return end

	local arena = getArena(arenaId)
	if not arena or arena.state ~= "Queuing" then return end

	for i, c in arena.contestants do
		if c.userId == player.UserId then
			table.remove(arena.contestants, i)
			break
		end
	end
	playerArena[player.UserId] = nil
end

-- ── Init ──────────────────────────────────────────────────────────────────────

function ContestService.init(remotesFolder: Folder)
	remotes.SkillCheckStart    = remotesFolder:WaitForChild("SkillCheckStart")    :: RemoteEvent
	remotes.SkillCheckResult   = remotesFolder:WaitForChild("SkillCheckResult")   :: RemoteEvent
	remotes.FillUpdate         = remotesFolder:WaitForChild("FillUpdate")         :: RemoteEvent
	remotes.ContestPhaseChanged = remotesFolder:WaitForChild("ContestPhaseChanged") :: RemoteEvent
	remotes.ShowResults        = remotesFolder:WaitForChild("ShowResults")        :: RemoteEvent
	remotes.StatsUpdate        = remotesFolder:WaitForChild("StatsUpdate")        :: RemoteEvent
	remotes.JoinQueue          = remotesFolder:WaitForChild("JoinQueue")          :: RemoteEvent
	remotes.LeaveQueue         = remotesFolder:WaitForChild("LeaveQueue")         :: RemoteEvent

	remotes.SkillCheckResult.OnServerEvent:Connect(onSkillCheckResult)
	remotes.JoinQueue.OnServerEvent:Connect(onJoinQueue)
	remotes.LeaveQueue.OnServerEvent:Connect(onLeaveQueue)

	-- Remove leaving players from active arenas
	Players.PlayerRemoving:Connect(function(player: Player)
		local arenaId = playerArena[player.UserId]
		if arenaId then
			local arena = getArena(arenaId)
			if arena then
				local c = findContestant(arena, player.UserId)
				if c then c.isDqd = true end
			end
			playerArena[player.UserId] = nil
		end
		pendingRings[player.UserId] = nil
	end)

	-- Initialise arenas with staggered starts
	for i = 1, Constants.ARENA_COUNT do
		local arena: Types.Arena = {
			id             = i,
			tier           = 1,
			state          = "Idle",
			contestants    = {},
			currentFood    = pickFood(1),
			phaseStartTime = tick(),
			results        = nil,
		}
		table.insert(arenas, arena)

		task.spawn(function()
			task.wait((i - 1) * Constants.ARENA_STAGGER)
			arenaLoop(arena)
		end)
	end
end

-- ── Public accessors (for other services) ────────────────────────────────────

function ContestService.getArenas(): { Types.Arena }
	return arenas
end

function ContestService.getPlayerArenaId(userId: number): number?
	return playerArena[userId]
end

return ContestService
