-- Handles all 5 carnival mini-games server-side.
-- Validates all input, enforces cooldowns, awards tickets and stat XP.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common      = ReplicatedStorage.Common
local Constants   = require(Common.Constants)
local DataManager = require(script.Parent.DataManager)

local MiniGameService = {}

local remotes: { [string]: RemoteEvent } = {}

local COOLDOWN: { [string]: number } = {
	RingToss    = 30,
	HighStriker = 60,
	DuckPond    = 45,
	BalloonDart = 45,
	SkeeBall    = 30,
}

local ALL_GAMES = { "RingToss", "HighStriker", "DuckPond", "BalloonDart", "SkeeBall" }

local START_RATE_LIMIT = 2
local THROWS_PER_RING  = 3
local THROW_TIMEOUT    = 13

-- ── Per-player state ──────────────────────────────────────────────────────────

type ThrowQuality = "perfect" | "good" | "miss"

type RingSession = {
	throwIndex : number,
	results    : { ThrowQuality },
	deadline   : number,
}

type StrikerSession = {
	targetZone : number,
	deadline   : number,
}

type SimpleSession = {
	gameType : string,
	deadline : number,
}

type PlayerState = {
	lastStart  : number,
	cooldowns  : { [string]: number },
	ring       : RingSession?,
	striker    : StrikerSession?,
	simple     : SimpleSession?,
}

local state: { [number]: PlayerState } = {}

local function getState(player: Player): PlayerState
	local uid = player.UserId
	if not state[uid] then
		state[uid] = { lastStart = 0, cooldowns = {}, ring = nil, striker = nil, simple = nil }
	end
	return state[uid]
end

local function clearSessions(ps: PlayerState)
	ps.ring    = nil
	ps.striker = nil
	ps.simple  = nil
end

-- ── Helpers ───────────────────────────────────────────────────────────────────

-- v1 currency unification: tickets are gone, mini-games pay coins (research recommendation).
-- Conversion: previous ticket amount * 2.5 = coin amount. Keeps mini-games "filler" tier
-- (5-15 coins/win) vs contests (15-60 coins/place).
local function awardCoinsFromMinigame(player: Player, ticketEquivalent: number): number
	local coins = math.floor(ticketEquivalent * 2.5)
	DataManager.addCoins(player, coins)
	remotes.AddTickets:FireClient(player, coins)  -- remote keeps name; payload now represents coins
	return coins
end

local function sendResult(player: Player, gameType: string, won: boolean, coins: number, message: string)
	remotes.MiniGameResult:FireClient(player, {
		gameType = gameType,
		won      = won,
		coins    = coins,   -- renamed from `tickets` for v1 currency drop
		message  = message,
	})
end

local function focusLevelFor(player: Player): number
	local data = DataManager.get(player)
	return (data and data.stats and data.stats.Focus) or 0
end

-- ── Ring Toss ─────────────────────────────────────────────────────────────────

local function startRingToss(player: Player)
	local ps = getState(player)
	clearSessions(ps)
	ps.ring = { throwIndex = 1, results = {}, deadline = tick() + THROW_TIMEOUT }

	remotes.MiniGameChallenge:FireClient(player, {
		gameType    = "RingToss",
		throwIndex  = 1,
		totalThrows = THROWS_PER_RING,
		focusHint   = focusLevelFor(player),
	})
end

local function onRingThrow(player: Player, payload: any)
	local ps      = getState(player)
	local session = ps.ring
	if not session then return end
	if payload.throwIndex ~= session.throwIndex then return end
	if tick() > session.deadline then
		clearSessions(ps)
		sendResult(player, "RingToss", false, 0, "Too slow! Try again.")
		return
	end

	local quality: ThrowQuality = "miss"
	if payload.hitQuality == "perfect" or payload.hitQuality == "good" or payload.hitQuality == "miss" then
		quality = payload.hitQuality
	end
	table.insert(session.results, quality)

	local done = #session.results
	if done < THROWS_PER_RING then
		session.throwIndex = done + 1
		session.deadline   = tick() + THROW_TIMEOUT
		remotes.MiniGameChallenge:FireClient(player, {
			gameType    = "RingToss",
			throwIndex  = session.throwIndex,
			totalThrows = THROWS_PER_RING,
			focusHint   = focusLevelFor(player),
		})
		return
	end

	local perfects, goods = 0, 0
	for _, q in session.results do
		if q == "perfect" then perfects += 1 elseif q == "good" then goods += 1 end
	end
	clearSessions(ps)
	ps.cooldowns["RingToss"] = tick()

	if perfects == THROWS_PER_RING then
		awardCoinsFromMinigame(player, 5)
		DataManager.addStatXp(player, "Focus", 1)
		sendResult(player, "RingToss", true, 12, "JACKPOT! Perfect throws!")
	elseif (perfects + goods) >= 2 then
		awardCoinsFromMinigame(player, 2)
		DataManager.addStatXp(player, "Focus", 1)
		sendResult(player, "RingToss", true, 5, "Nice! You win!")
	else
		sendResult(player, "RingToss", false, 0, "Better luck next time!")
	end
end

-- ── High Striker ──────────────────────────────────────────────────────────────

-- Build a carnival hammer Tool and give it to the player
local function giveHammer(player: Player): Tool?
	local char = player.Character
	if not char then return nil end

	-- Remove existing carnival hammer if any
	for _, t in player.Backpack:GetChildren() do if t.Name == "CarnivalHammer" then t:Destroy() end end
	for _, t in char:GetChildren() do if t.Name == "CarnivalHammer" then t:Destroy() end end

	local tool = Instance.new("Tool")
	tool.Name = "CarnivalHammer"
	tool.RequiresHandle = true
	tool.CanBeDropped = false

	-- Handle (mallet head + handle)
	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(0.5, 4, 0.5)
	handle.Color = Color3.fromRGB(120, 80, 40)
	handle.Material = Enum.Material.Wood
	handle.TopSurface = Enum.SurfaceType.Smooth
	handle.BottomSurface = Enum.SurfaceType.Smooth
	handle.Parent = tool

	-- Mallet head (welded onto handle)
	local head = Instance.new("Part")
	head.Name = "MalletHead"
	head.Size = Vector3.new(2, 1.5, 1.5)
	head.Color = Color3.fromRGB(200, 30, 30)
	head.Material = Enum.Material.SmoothPlastic
	head.Position = handle.Position + Vector3.new(0, 2, 0)
	head.Parent = tool
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = handle
	weld.Part1 = head
	weld.Parent = handle

	tool.Parent = char
	return tool
end

local function removeHammer(player: Player)
	for _, t in player.Backpack:GetChildren() do if t.Name == "CarnivalHammer" then t:Destroy() end end
	local char = player.Character
	if char then
		for _, t in char:GetChildren() do if t.Name == "CarnivalHammer" then t:Destroy() end end
	end
end

local function startHighStriker(player: Player)
	local ps = getState(player)
	clearSessions(ps)
	local target = math.random() * 0.8 + 0.1
	ps.striker = { targetZone = target, deadline = tick() + 12 }
	giveHammer(player)   -- hand the player a hammer Tool
	remotes.MiniGameChallenge:FireClient(player, {
		gameType   = "HighStriker",
		targetZone = target,
	})
end

local function onStrikerThrow(player: Player, payload: any)
	local ps      = getState(player)
	local session = ps.striker
	if not session then return end
	if tick() > session.deadline then
		clearSessions(ps)
		sendResult(player, "HighStriker", false, 0, "Too slow! Try again.")
		return
	end
	if type(payload.power) ~= "number" then clearSessions(ps); return end

	local power = math.clamp(payload.power, 0, 1)
	local diff  = math.abs(power - session.targetZone)
	clearSessions(ps)
	ps.cooldowns["HighStriker"] = tick()
	removeHammer(player)

	if diff <= 0.05 then
		awardCoinsFromMinigame(player, 5)
		DataManager.addStatXp(player, "JawSpeed", 1)
		sendResult(player, "HighStriker", true, 12, "JACKPOT! Perfect strike!")
	elseif diff <= 0.15 then
		awardCoinsFromMinigame(player, 2)
		DataManager.addStatXp(player, "JawSpeed", 1)
		sendResult(player, "HighStriker", true, 5, "Good hit! You win!")
	else
		sendResult(player, "HighStriker", false, 0, "Missed the zone. Try again!")
	end
end

-- ── Duck Pond ─────────────────────────────────────────────────────────────────

local function startDuckPond(player: Player)
	local ps = getState(player)
	clearSessions(ps)
	ps.simple = { gameType = "DuckPond", deadline = tick() + 20 }
	remotes.MiniGameChallenge:FireClient(player, {
		gameType   = "DuckPond",
		shots      = 5,
		duckCount  = 6,
		seed       = math.random(1, 9999),
	})
end

local function onDuckPondResult(player: Player, payload: any)
	local ps      = getState(player)
	local session = ps.simple
	if not session or session.gameType ~= "DuckPond" then return end
	if tick() > session.deadline then
		clearSessions(ps)
		sendResult(player, "DuckPond", false, 0, "Too slow! Try again.")
		return
	end

	local hits = math.floor(tonumber(payload.hits) or 0)
	hits = math.clamp(hits, 0, 5)
	clearSessions(ps)
	ps.cooldowns["DuckPond"] = tick()

	if hits >= 4 then
		awardCoinsFromMinigame(player, 5)
		sendResult(player, "DuckPond", true, 12, "Sharpshooter! " .. hits .. "/5 ducks!")
	elseif hits >= 2 then
		awardCoinsFromMinigame(player, 2)
		sendResult(player, "DuckPond", true, 5, hits .. "/5 ducks! Nice shot!")
	else
		sendResult(player, "DuckPond", false, 0, hits .. "/5. Keep practicing!")
	end
end

-- ── Balloon Dart ─────────────────────────────────────────────────────────────

local function startBalloonDart(player: Player)
	local ps = getState(player)
	clearSessions(ps)
	ps.simple = { gameType = "BalloonDart", deadline = tick() + 25 }
	remotes.MiniGameChallenge:FireClient(player, {
		gameType     = "BalloonDart",
		darts        = 3,
		balloonCount = 12,
		seed         = math.random(1, 9999),
	})
end

local function onBalloonDartResult(player: Player, payload: any)
	local ps      = getState(player)
	local session = ps.simple
	if not session or session.gameType ~= "BalloonDart" then return end
	if tick() > session.deadline then
		clearSessions(ps)
		sendResult(player, "BalloonDart", false, 0, "Too slow! Try again.")
		return
	end

	local hits = math.floor(tonumber(payload.hits) or 0)
	hits = math.clamp(hits, 0, 3)
	clearSessions(ps)
	ps.cooldowns["BalloonDart"] = tick()

	if hits == 3 then
		awardCoinsFromMinigame(player, 5)
		DataManager.addStatXp(player, "Focus", 1)
		sendResult(player, "BalloonDart", true, 12, "BULLSEYE! All 3 balloons!")
	elseif hits == 2 then
		awardCoinsFromMinigame(player, 3)
		sendResult(player, "BalloonDart", true, 7, "2/3 balloons! Sharp aim!")
	elseif hits == 1 then
		awardCoinsFromMinigame(player, 1)
		sendResult(player, "BalloonDart", true, 2, "1/3. At least you hit one!")
	else
		sendResult(player, "BalloonDart", false, 0, "No hits. Try again!")
	end
end

-- ── Skee-Ball ────────────────────────────────────────────────────────────────

local function startSkeeBall(player: Player)
	local ps = getState(player)
	clearSessions(ps)
	ps.simple = { gameType = "SkeeBall", deadline = tick() + 30 }
	remotes.MiniGameChallenge:FireClient(player, {
		gameType = "SkeeBall",
		balls    = 3,
	})
end

local function onSkeeBallResult(player: Player, payload: any)
	local ps      = getState(player)
	local session = ps.simple
	if not session or session.gameType ~= "SkeeBall" then return end
	if tick() > session.deadline then
		clearSessions(ps)
		sendResult(player, "SkeeBall", false, 0, "Too slow! Try again.")
		return
	end

	local score = math.floor(tonumber(payload.score) or 0)
	score = math.clamp(score, 0, 9)  -- max 3 balls × 3pts
	clearSessions(ps)
	ps.cooldowns["SkeeBall"] = tick()

	if score >= 7 then
		awardCoinsFromMinigame(player, 5)
		DataManager.addStatXp(player, "SwallowRate", 1)
		sendResult(player, "SkeeBall", true, 12, "INCREDIBLE! " .. score .. " pts!")
	elseif score >= 4 then
		awardCoinsFromMinigame(player, 2)
		sendResult(player, "SkeeBall", true, 5, score .. " pts. Nice rolls!")
	else
		sendResult(player, "SkeeBall", false, 0, score .. " pts. Keep rolling!")
	end
end

-- ── Remote handler: StartMiniGame ─────────────────────────────────────────────

local function onStartMiniGame(player: Player, payload: any)
	if type(payload) ~= "table" then return end
	local ps  = getState(player)
	local now = tick()
	if now - ps.lastStart < START_RATE_LIMIT then return end
	ps.lastStart = now

	local gameType = payload.gameType
	local valid = false
	for _, g in ALL_GAMES do
		if g == gameType then valid = true; break end
	end
	if not valid then return end

	local lastPlay = ps.cooldowns[gameType] or 0
	if now - lastPlay < (COOLDOWN[gameType] or 30) then
		local remaining = math.ceil((COOLDOWN[gameType] or 30) - (now - lastPlay))
		sendResult(player, gameType, false, 0, "Come back in " .. remaining .. "s!")
		return
	end

	if gameType == "RingToss"    then startRingToss(player)
	elseif gameType == "HighStriker" then startHighStriker(player)
	elseif gameType == "DuckPond"    then startDuckPond(player)
	elseif gameType == "BalloonDart" then startBalloonDart(player)
	elseif gameType == "SkeeBall"    then startSkeeBall(player)
	end
end

-- ── Remote handler: MiniGameThrow (result from client) ───────────────────────

local function onMiniGameThrow(player: Player, payload: any)
	if type(payload) ~= "table" then return end
	local gt = payload.gameType
	if gt == "RingToss"    then onRingThrow(player, payload)
	elseif gt == "HighStriker" then onStrikerThrow(player, payload)
	elseif gt == "DuckPond"    then onDuckPondResult(player, payload)
	elseif gt == "BalloonDart" then onBalloonDartResult(player, payload)
	elseif gt == "SkeeBall"    then onSkeeBallResult(player, payload)
	end
end

-- ── Init ─────────────────────────────────────────────────────────────────────

function MiniGameService.init(remotesFolder: Folder)
	remotes.StartMiniGame     = remotesFolder:WaitForChild("StartMiniGame")     :: RemoteEvent
	remotes.MiniGameChallenge = remotesFolder:WaitForChild("MiniGameChallenge") :: RemoteEvent
	remotes.MiniGameThrow     = remotesFolder:WaitForChild("MiniGameThrow")     :: RemoteEvent
	remotes.MiniGameResult    = remotesFolder:WaitForChild("MiniGameResult")    :: RemoteEvent
	remotes.AddTickets        = remotesFolder:WaitForChild("AddTickets")        :: RemoteEvent

	remotes.StartMiniGame.OnServerEvent:Connect(function(player, payload)
		onStartMiniGame(player, payload)
	end)
	remotes.MiniGameThrow.OnServerEvent:Connect(function(player, payload)
		onMiniGameThrow(player, payload)
	end)
	Players.PlayerRemoving:Connect(function(player)
		state[player.UserId] = nil
	end)


end

return MiniGameService
