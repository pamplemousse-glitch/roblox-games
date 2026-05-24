-- Shared Luau type definitions. Import via require(Common.Types).

local Types = {}

export type StatName = "StomachCapacity" | "JawSpeed" | "SwallowRate" | "Focus"

export type PlayerStats = {
	StomachCapacity : number,  -- upgrade level 0–50
	JawSpeed        : number,
	SwallowRate     : number,
	Focus           : number,
}

export type PlayerData = {
	coins         : number,
	totalWins     : number,
	contestsPlayed: number,
	stats         : PlayerStats,
	highestTier   : number,
	winStreak     : number,
	lastWinDate   : string,     -- "YYYY-MM-DD"
	firstContestDone : boolean,
	version       : number,
}

-- Per-player state during an active contest
export type ContestantState = {
	userId      : number,
	isNpc       : boolean,
	npcName     : string?,
	fillValue   : number,   -- 0.0 – 1.0+
	biteCount   : number,
	isDqd       : boolean,
	lastBiteTime: number,   -- tick()
	difficulty  : number?,  -- NPC only
	isPaused    : boolean?, -- NPC only
	pauseUntil  : number?,  -- NPC only: tick() timestamp
}

export type ArenaState =
	"Idle"
	| "Queuing"
	| "Countdown"
	| "Active"
	| "Results"

export type Arena = {
	id            : number,
	tier          : number,
	state         : ArenaState,
	contestants   : { ContestantState },
	currentFood   : string,
	phaseStartTime: number,   -- tick() when current phase started
	results       : { {userId: number?, npcName: string?, bites: number, place: number} }?,
}

-- Sent server → client each 0.5s during active contest
export type FillSnapshot = {
	arenaId   : number,
	fill      : { [string]: number },   -- userId (string) → fillValue
	bites     : { [string]: number },
	timeLeft  : number,
}

-- Client → server: result of one skill-check attempt
export type SkillCheckResult = {
	arenaId   : number,
	biteIndex : number,
	hit       : boolean,
	alignment : number,   -- 0.0–1.0, where in the arc the needle was
	isGreat   : boolean,
}

-- Server → client: parameters for rendering the next skill check
export type SkillCheckParams = {
	arenaId     : number,
	food        : string,
	needleSpeed : number,   -- degrees/sec
	arcWidth    : number,   -- degrees
	arcStart    : number,   -- degrees from 12-o'clock, randomised
	duration    : number,   -- seconds until ring expires
	biteIndex   : number,   -- for client ordering
}

return Types
