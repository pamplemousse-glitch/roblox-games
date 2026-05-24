-- TendingManager.luau
-- Each tend slot press pays a direct spore burst based on that species' production.
-- 10-min cooldown per slot. No passive multiplier — tending IS the income.

local Config      = require(game.ReplicatedStorage.Common.Config)
local DataManager = require(script.Parent.DataManager)

local TendingManager = {}

-- How many seconds of that mushroom's production each slot press pays out.
local TEND_PAYOUT_SECS = 300  -- 5 minutes worth per slot action

-- Attempts to tend a slot. Returns spores earned (0 if on cooldown or invalid).
function TendingManager.tendSlot(player: Player, speciesId: string, slotType: string): number
	local data = DataManager.get(player)
	if not data then return 0 end

	data.tendingBonuses = data.tendingBonuses or {}
	data.tendingBonuses[speciesId] = data.tendingBonuses[speciesId] or {}

	local lastTime = data.tendingBonuses[speciesId][slotType] or 0
	if os.time() - lastTime < Config.TENDING_DURATION then return 0 end

	data.tendingBonuses[speciesId][slotType] = os.time()

	local species = Config.SPECIES_BY_ID[speciesId]
	if not species then DataManager.save(player); return 0 end

	local mutCount     = data.mutations[speciesId] or 0
	local mutBonus     = mutCount > 0
		and Config.MUTATION_MULTIPLIERS[species.tier] ^ mutCount
		or 1
	local prestigeMult = Config.PRESTIGE_MULTIPLIERS[data.prestigeLevel] or 1

	local payout = math.floor(species.sporesPerSec * TEND_PAYOUT_SECS * mutBonus * prestigeMult)

	data.spores         += payout
	data.lifetimeSpores += payout
	if data.lifetimeSpores > (data.peakSpores or 0) then
		data.peakSpores = data.lifetimeSpores
	end

	DataManager.save(player)
	return payout
end

-- Returns the full tending timestamp table for client sync.
function TendingManager.getSlotState(player: Player): table
	local data = DataManager.get(player)
	if not data then return {} end
	return data.tendingBonuses or {}
end

return TendingManager
