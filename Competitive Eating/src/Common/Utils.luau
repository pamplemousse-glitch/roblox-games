local Constants = require(script.Parent.Constants)

local Utils = {}

-- Upgrade cost for moving from level (currentLevel) to (currentLevel + 1)
function Utils.upgradeCost(currentLevel: number): number
	return Constants.UPGRADE_COST_BASE * (currentLevel + 1) ^ 2
end

-- Stat level → multiplier (1.0 at L0, up to 4.0 at L50)
function Utils.statMultiplier(level: number): number
	return 1 + (level / Constants.STAT_MAX_LEVEL) * 3
end

-- Needle speed in degrees/sec given JawSpeed level
function Utils.needleSpeed(jawLevel: number): number
	local reduction = 1 - (jawLevel * Constants.JAWSPEED_NEEDLE_REDUCTION)
	return Constants.RING_SPEED_BASE * math.max(reduction, 0.45)
end

-- Arc width in degrees given Focus level
function Utils.arcWidth(focusLevel: number): number
	local expansion = 1 + (focusLevel * Constants.FOCUS_ARC_EXPANSION)
	return Constants.RING_ARC_BASE * math.min(expansion, 2.5)
end

-- Fill per bite given StomachCapacity level (capacity affects overflow threshold implicitly
-- by scaling how much each bite fills relative to the meter — higher capacity = smaller fill per bite)
function Utils.fillPerBite(capacityLevel: number, alignment: number, isGreat: boolean): number
	local capacityMult = 1 / Utils.statMultiplier(capacityLevel)
	local base = Constants.FILL_PER_BITE_BASE * capacityMult * alignment
	if isGreat then
		base = base * Constants.RING_GREAT_BONUS
	end
	return base
end

-- Drain rate per second given SwallowRate level
function Utils.drainRate(swallowLevel: number): number
	return Constants.FILL_DRAIN_BASE * Utils.statMultiplier(swallowLevel)
end

-- NPC simulated fill-per-second based on difficulty + variance
function Utils.npcFillRate(difficulty: number): number
	local variance = (math.random() * 2 - 1) * Constants.NPC_VARIANCE
	return (Constants.FILL_PER_BITE_BASE / Constants.RING_DURATION) * difficulty * (1 + variance)
end

-- Coin streak multiplier (1.0 base, +10% per win up to 5 wins = 1.5x)
function Utils.streakMultiplier(streak: number): number
	return 1 + math.min(streak, Constants.COIN_STREAK_MAX) * Constants.COIN_STREAK_BONUS
end

-- Pick a random arc start position that isn't too close to 0° (needle start)
function Utils.randomArcStart(arcWidth: number): number
	local minGap = 30  -- degrees away from 12-o'clock
	local maxStart = 360 - arcWidth - minGap
	return minGap + math.random() * (maxStart - minGap)
end

-- Today's date as "YYYY-MM-DD" for daily first-win tracking
function Utils.todayString(): string
	-- Roblox: os.date returns a table in Luau
	local d = os.date("*t") :: any
	return string.format("%04d-%02d-%02d", d.year, d.month, d.day)
end

-- Default player data
function Utils.defaultPlayerData(): any
	return {
		coins          = 0,
		carnivalTickets = 0,
		styleBucks     = 0,
		totalWins      = 0,
		contestsPlayed = 0,
		stats = {
			StomachCapacity = 0,
			JawSpeed        = 0,
			SwallowRate     = 0,
			Focus           = 0,
		},
		statXp           = {},
		highestTier      = 1,
		winStreak        = 0,
		lastWinDate      = "",
		firstContestDone = false,
		ownedCosmetics   = {},
		equippedCosmetics = {},
		npcEncounters    = {},
		cookbook         = {},
		cookbookCoinBonus = 0,
		friendVaultBalance = 0,
		tournamentProgress = {
			currentStage = 1,
			objectives   = {},
			arcComplete  = false,
		},
		version          = 1,
	}
end

-- Deep-clone a table (shallow is fine for our flat data schemas)
function Utils.shallowCopy(t: {[any]: any}): {[any]: any}
	local copy = {}
	for k, v in t do
		copy[k] = v
	end
	return copy
end

-- Clamp
function Utils.clamp(value: number, min: number, max: number): number
	return math.max(min, math.min(max, value))
end

return Utils
