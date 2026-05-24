-- All authoritative game constants. Import everywhere via require(Common.Constants).

local Constants = {}

-- ── Contest timing ──────────────────────────────────────────────────────────
Constants.QUEUE_DURATION      = 15   -- seconds players wait to fill seats
Constants.COUNTDOWN_DURATION  = 5    -- pre-contest George Shea intro
Constants.CONTEST_DURATION    = 90   -- active eating window
Constants.RESULTS_DURATION    = 15   -- leaderboard reveal + rewards
Constants.ARENA_COUNT         = 3
Constants.SEATS_PER_ARENA     = 4
-- Stagger so there's always a contest starting within 30s
Constants.ARENA_STAGGER       = 42   -- seconds between arena A/B/C start offsets

-- ── Economy ─────────────────────────────────────────────────────────────────
Constants.COIN_BY_PLACE       = { 60, 40, 25, 15 }
Constants.COIN_PARTICIPATION  = 10
Constants.COIN_FIRST_WIN_DAILY = 100
Constants.COIN_STREAK_BONUS   = 0.10  -- +10% per consecutive win, cap 50%
Constants.COIN_STREAK_MAX     = 5

-- ── Stats ────────────────────────────────────────────────────────────────────
Constants.STAT_NAMES = { "StomachCapacity", "JawSpeed", "SwallowRate", "Focus" }
Constants.STAT_MAX_LEVEL = 50
-- Cost formula: UPGRADE_COST_BASE * level^2
Constants.UPGRADE_COST_BASE = 50

Constants.STAT_DISPLAY = {
	StomachCapacity = "Stomach Capacity",
	JawSpeed        = "Jaw Speed",
	SwallowRate     = "Swallow Rate",
	Focus           = "Focus",
}

Constants.STAT_DESCRIPTIONS = {
	StomachCapacity = "How much you can eat before overflow",
	JawSpeed        = "Ring needle rotates slower — more time to react",
	SwallowRate     = "Fill meter drains faster, preventing overflow",
	Focus           = "Green zone on every ring is wider",
}

-- ── Fill meter ───────────────────────────────────────────────────────────────
Constants.FILL_CAUTION    = 0.75
Constants.FILL_DANGER     = 0.90
Constants.FILL_OVERFLOW   = 1.00

-- Base drain per second (Swallow Rate upgrades multiply this)
-- At 1x stat: ~45s to drain full meter — forces rhythm, not spam
Constants.FILL_DRAIN_BASE = 0.022

-- Base fill per perfect bite (Stomach Capacity modifies max before overflow)
Constants.FILL_PER_BITE_BASE = 0.065

Constants.FILL_REPLICATE_INTERVAL = 0.5  -- seconds between server → client updates

-- ── Skill check (Hot Dog Ring — primary mechanic) ────────────────────────────
Constants.RING_SPEED_BASE  = 240   -- degrees/sec needle rotation
Constants.RING_ARC_BASE    = 54    -- degrees of success arc
Constants.RING_DURATION    = 1.5   -- seconds the ring is shown

-- Stat multipliers on skill check parameters
-- JawSpeed:  each level slows needle by 0.8% (max 40% slower at L50)
-- Focus:     each level widens arc by 0.9% (max 45% wider at L50)
Constants.JAWSPEED_NEEDLE_REDUCTION   = 0.008
Constants.FOCUS_ARC_EXPANSION         = 0.009

-- Great zone (inner gold sliver) — multiplier on fill per bite
Constants.RING_GREAT_BONUS = 1.20
Constants.RING_GREAT_WIDTH = 10  -- degrees inside the center of the arc
Constants.RING_MISS_COOLDOWN = 0.3  -- seconds before next ring after a miss

-- ── NPC ──────────────────────────────────────────────────────────────────────
Constants.NPC_DIFFICULTY = {
	Rookie  = 0.60,
	Veteran = 0.85,
	Elite   = 1.00,
}
Constants.NPC_VARIANCE      = 0.20  -- ±20% random fill rate per tick
Constants.NPC_PAUSE_CHANCE  = 0.08  -- 8% chance to pause each tick (human feel)
Constants.NPC_PAUSE_DURATION = 0.8
Constants.NPC_BACKFILL_TIME = 10    -- seconds before contest start, fill empty seats

Constants.NPC_NAMES = {
	"Chomping Charlie", "Big Belly Beatrice", "Rapid Ray",
	"The Rookie", "Steady Susan", "Gut-Busting Greg",
}

-- ── Tiers ────────────────────────────────────────────────────────────────────
Constants.TIER_COUNT = 4
Constants.TIER_UNLOCK = {
	{ wins = 0,  coins = 0 },      -- Tier 1 — Local Diner (always unlocked)
	{ wins = 10, coins = 500 },    -- Tier 2 — Regional Fairground
	{ wins = 30, coins = 3000 },   -- Tier 3 — National Stadium
	{ wins = 75, coins = 15000 },  -- Tier 4 — World Championship
}

Constants.TIER_NAMES = {
	"Local Diner", "Regional Fairground", "National Stadium", "World Championship",
}

-- Foods per tier (MVP: Tier 1 only — Hot Dog ring mechanic for all)
Constants.TIER_FOODS = {
	{ "Hot Dog", "Hamburger", "Corn Dog", "Donut", "Chicken Wings" },
	{ "Ramen Bowl", "Gyoza Tray", "Pizza Slice", "Fried Chicken", "Taco Platter" },
	{ "Spray Cheese", "Butter Log", "Brain Taco", "Donut Holes", "Deep Dish Pizza" },
	{ "Nathan's Hot Dog", "Dragon Pepper Roll", "Steel Gyoza", "Double Smashburger", "Coney Dog Stack" },
}

-- ── George Shea announcer lines ──────────────────────────────────────────────
Constants.SHEA_INTROS = {
	"LADIES AND GENTLEMEN — the stomach of a HIPPOPOTAMUS in the body of a ROBLOX CHARACTER!",
	"She trained by consuming eleven pounds of watermelon daily. THE CROWD APPROVES.",
	"He has broken reality, and all of time pours down around us now at once, simultaneous and endless.",
	"Scientists cannot explain it. Philosophers will not try. THIS is competitive eating.",
	"What you are about to witness has never been witnessed. And yet here we are. AGAIN.",
	"The laws of physics have filed a complaint. It was dismissed. BEGIN.",
	"Three years ago she euthanized her doubt and filled the void with pure, ravenous appetite.",
	"Some call it hunger. He calls it Tuesday. LADIES AND GENTLEMEN — YOUR CHALLENGER!",
}

Constants.SHEA_RESULTS = {
	"HISTORIC. The records books are already being reprinted.",
	"The crowd will speak of this for GENERATIONS.",
	"That was either the greatest or second-greatest thing I have ever seen.",
	"Physics: violated. Dignity: intact. GLORY: achieved.",
}

-- ── Onboarding ───────────────────────────────────────────────────────────────
Constants.ONBOARDING_FIRST_CONTEST_FILL_ASSIST = 0.40  -- 40% wider green zone for new players
Constants.ONBOARDING_NPC_DIFFICULTY_OVERRIDE   = 0.50  -- easier NPCs for first contest
Constants.ONBOARDING_HIT_LABEL_BITES           = 3     -- show "HIT HERE" label for first N bites

-- ── DataStore ────────────────────────────────────────────────────────────────
Constants.DATASTORE_NAME     = "PlayerData_v1"
Constants.SAVE_INTERVAL      = 60    -- auto-save every 60 seconds
Constants.SESSION_LOCK_KEY   = "_lock"

return Constants
