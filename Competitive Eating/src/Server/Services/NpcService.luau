-- Manages NPC contestant simulation inside a running arena.
-- Called by ContestService — not standalone.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common     = ReplicatedStorage.Common
local Constants  = require(Common.Constants)
local Utils      = require(Common.Utils)
local Types      = require(Common.Types)

local NpcService = {}

-- ── Assignment ────────────────────────────────────────────────────────────────

-- Fill empty arena seats with NPCs scaled to the arena's tier.
function NpcService.assign(arena: Types.Arena)
	local seated = #arena.contestants
	local needed = Constants.SEATS_PER_ARENA - seated
	if needed <= 0 then return end

	-- Pick difficulty pool based on tier
	local diffPool: { number }
	if arena.tier == 1 then
		diffPool = {
			Constants.NPC_DIFFICULTY.Rookie,
			Constants.NPC_DIFFICULTY.Rookie,
			Constants.NPC_DIFFICULTY.Veteran,
		}
	elseif arena.tier == 2 then
		diffPool = {
			Constants.NPC_DIFFICULTY.Veteran,
			Constants.NPC_DIFFICULTY.Veteran,
			Constants.NPC_DIFFICULTY.Elite,
		}
	else
		diffPool = {
			Constants.NPC_DIFFICULTY.Elite,
			Constants.NPC_DIFFICULTY.Elite,
			Constants.NPC_DIFFICULTY.Elite,
		}
	end

	local usedNames: { [string]: boolean } = {}
	for _, c in arena.contestants do
		if c.npcName then usedNames[c.npcName] = true end
	end

	for i = 1, needed do
		local difficulty = diffPool[((i - 1) % #diffPool) + 1]

		-- Pick an unused NPC name
		local name = "Challenger"
		for _, n in Constants.NPC_NAMES do
			if not usedNames[n] then
				name = n
				usedNames[n] = true
				break
			end
		end

		local contestant: Types.ContestantState = {
			userId       = 0,
			isNpc        = true,
			npcName      = name,
			fillValue    = 0,
			biteCount    = 0,
			isDqd        = false,
			lastBiteTime = tick(),
			difficulty   = difficulty,
			isPaused     = false,
			pauseUntil   = 0,
		}
		table.insert(arena.contestants, contestant)
	end
end

-- ── Tick ──────────────────────────────────────────────────────────────────────

-- Advance NPC fill meters by dt seconds. Returns true if any NPC was DQ'd this tick.
function NpcService.tick(arena: Types.Arena, dt: number): boolean
	local anyDqd = false

	for _, c in arena.contestants do
		if not c.isNpc or c.isDqd then continue end

		local now = tick()

		-- Handle pause
		if c.isPaused then
			if now >= (c.pauseUntil or 0) then
				c.isPaused = false
			else
				continue
			end
		end

		-- Random pause trigger
		if math.random() < Constants.NPC_PAUSE_CHANCE * dt then
			c.isPaused   = true
			c.pauseUntil = now + Constants.NPC_PAUSE_DURATION
			continue
		end

		-- Advance fill
		local fillRate = Utils.npcFillRate(c.difficulty or 1)
		c.fillValue    = c.fillValue + fillRate * dt
		c.biteCount    = math.floor(c.fillValue / Constants.FILL_PER_BITE_BASE)
		c.lastBiteTime = now

		if c.fillValue >= Constants.FILL_OVERFLOW then
			c.isDqd     = true
			c.fillValue = Constants.FILL_OVERFLOW
			anyDqd      = true
		end
	end

	return anyDqd
end

return NpcService
