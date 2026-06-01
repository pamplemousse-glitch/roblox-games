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
	"'Jaws' Beasley McGraw", "Tsunami Tyler", "MIKI", "Lil' Stuff",
	"The Mouth Mason", "Doc", "Bigtop Bob", "Mrs. Pickles",
}

-- Per-NPC personality data — catchphrases + signature tells.
-- Tells = predictable difficulty curve a good player can exploit.
-- ContestService fires the catchphrase at countdown; tell drives NpcService.tick variance.
-- familiarLines fire when player has met NPC ≥ NPC_FAMILIAR_THRESHOLD times.
-- rivalLines fire at ≥ NPC_RIVAL_THRESHOLD encounters. See NpcMemoryService.
Constants.NPC_CHARACTERS = {
	["'Jaws' Beasley McGraw"] = {
		catchphrase = "Don't blink, kid. I never do.",
		tell        = "steady",        -- consistent pace, no panic spikes
		winLine     = "Just like old times.",
		loseLine    = "...lucky.",
		familiarLines = {
			"You're still showing up. I respect that.",
			"Same dance, different day, kid.",
			"Back for another round, huh?",
		},
		rivalLines = {
			"You and me again. Let's settle this for real.",
			"I've been waiting for you to come back.",
			"Every contest with you is a chapter, kid.",
		},
	},
	["Tsunami Tyler"] = {
		catchphrase = "Hope you brought a bib.",
		tell        = "fast_early",    -- huge head start, fades in last 30s
		winLine     = "SURF'S UP, BABY!",
		loseLine    = "I peaked too early...",
		familiarLines = {
			"Oh hey, you're back! Hope you brought floaties this time.",
			"Round whatever, baby! Let's GO!",
			"You again? Cool, cool, cool.",
		},
		rivalLines = {
			"We're basically nemeses at this point, dude.",
			"You're my white whale. Or hot dog. Whatever.",
			"This rivalry has GOT to end today!",
		},
	},
	["MIKI"] = {
		catchphrase = "...",            -- silent menace
		tell        = "late_surge",    -- quiet until last 20s, then explodes
		winLine     = "[smiles]",
		loseLine    = "[silent shrug]",
		familiarLines = {
			"[recognizes you]",
			"[nods slightly]",
			"...you.",
		},
		rivalLines = {
			"[stares longer than usual]",
			"[locks eyes]",
			"...again.",
		},
	},
	["Lil' Stuff"] = {
		catchphrase = "Heh heh, watch me go!",
		tell        = "consistent",    -- steady mid-range eater
		winLine     = "DID YOU SEE THAT?! DID YOU?!",
		loseLine    = "Aww, beans.",
		familiarLines = {
			"Hey! You came back to watch me eat again?!",
			"I remember you! You're the one!",
			"Yay, my buddy's back!",
		},
		rivalLines = {
			"You and me, FOREVER!",
			"You're like my eating partner now, sorta!",
			"Mom said you'd come back!",
		},
	},
	["The Mouth Mason"] = {
		catchphrase = "Shall we begin?",
		tell        = "calm_strong",   -- methodical, high baseline
		winLine     = "Quite satisfactory.",
		loseLine    = "Well played.",
		familiarLines = {
			"A familiar face. Welcome back.",
			"We meet once more.",
			"Ah. You return.",
		},
		rivalLines = {
			"My old friend. Shall we?",
			"You are persistent. I admire that.",
			"Few have crossed plates with me this often.",
		},
	},
	["Doc"] = {
		catchphrase = "Anatomically, this should be impossible.",
		tell        = "scientific",    -- predictable bursts every 15s
		winLine     = "Just as my calculations predicted.",
		loseLine    = "Fascinating. Back to the lab.",
		familiarLines = {
			"Subject returns. Adjusting hypothesis.",
			"Recurring contestant: noted in journal.",
			"You again. The data thickens.",
		},
		rivalLines = {
			"You have become a control group, fascinatingly.",
			"We are now a longitudinal study, you and I.",
			"My paper on you is nearly publishable.",
		},
	},
	["Bigtop Bob"] = {
		catchphrase = "STEP RIGHT UP! WATCH ME EAT!",
		tell        = "theatrical",    -- big swings, big pauses
		winLine     = "AND THE CROWD GOES WILD!",
		loseLine    = "...the show must go on.",
		familiarLines = {
			"AND OUR RETURNING CHALLENGER!",
			"BACK FOR THE ENCORE, FOLKS!",
			"GIVE 'EM A HAND, THEY'VE EARNED IT!",
		},
		rivalLines = {
			"OUR ETERNAL DUEL CONTINUES!",
			"THIS IS BECOMING A LEGEND, FOLKS!",
			"THE RIVALRY OF THE CENTURY, LIVE!",
		},
	},
	["Mrs. Pickles"] = {
		catchphrase = "Oh dearie, don't go easy on me.",
		tell        = "deceptive",     -- slow start, terrifying finish
		winLine     = "Sweet potato pie, that was a treat!",
		loseLine    = "Bless your heart, dear.",
		familiarLines = {
			"Oh dearie, you're back again!",
			"Bless your heart for returning, sugar.",
			"Land sakes, look who it is.",
		},
		rivalLines = {
			"Sugar, we've done this dance a few times now.",
			"Oh sweetie, I know your tells by heart.",
			"You and me are practically family, dear.",
		},
	},
}

-- Encounter thresholds — see NpcMemoryService.pickDialogLine.
-- Counts represent PRIOR encounters: threshold=2 means 3rd meeting triggers familiar.
Constants.NPC_FAMILIAR_THRESHOLD = 2
Constants.NPC_RIVAL_THRESHOLD    = 9

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

-- ── Cosmetics shop items ──────────────────────────────────────────────────────
-- id: must match the Accessory name in ServerStorage.Cosmetics
-- currency: "coins" | "tickets" (Carnival Tickets from mini-games)
Constants.COSMETICS = {
    { id = "Hat_HotDog",    label = "Hot Dog Hat",           price = 150,  currency = "coins",   category = "hat" },
    { id = "Hat_Donut",     label = "Donut Ring Crown",      price = 120,  currency = "coins",   category = "hat" },
    { id = "Hat_Pizza",     label = "Pizza Slice Hat",        price = 130,  currency = "coins",   category = "hat" },
    { id = "Belt_Champion", label = "Eating Champion Belt",   price = 500,  currency = "coins",   category = "belt",
      unlockCondition = "winStreak >= 3" },  -- shown only after 3-win streak
}

-- ── Food props (used in contest/shop visuals) ─────────────────────────────────
-- Names match Workspace.FoodProps children
Constants.FOOD_PROPS = {
    "FoodProp_HotDog",
    "FoodProp_Burger",
    "FoodProp_Pizza",
    "FoodProp_Donut",
    "FoodProp_IceCream",
}

-- ── Tournament arc: Road to The Bear ──────────────────────────────────────────
-- 4-stage multi-week storyline. Each stage has objectives the player completes
-- through normal contest play. Completing every objective in a stage grants the
-- reward and unlocks the next stage. Stage 4 grants the "Bear-Bound" title and
-- triggers the placeholder "BEAR PREVIEW (coming soon)" cutscene — the real
-- Bear boss fight is deferred to a later content drop.
--
-- Objective counters are stored in playerData.tournamentProgress.objectives.
-- Objective kinds:
--   "tierWin"  -> win a contest at the given tier
--   "beatNpc"  -> finish a contest ahead of the named NPC (any tier)

Constants.TOURNAMENT_ARC_NAME = "Road to The Bear"

Constants.TOURNAMENT_STAGES = {
    {
        id          = 1,
        name        = "Boardwalk Rookie",
        description = "Cut your teeth at the Local Diner.",
        objectives  = {
            { key = "stage1_tier1_wins",    kind = "tierWin", tier = 1,           target = 5, label = "Win 5 Tier 1 contests" },
            { key = "stage1_beat_lilstuff", kind = "beatNpc", npc = "Lil' Stuff", target = 1, label = "Beat Lil' Stuff once" },
        },
        reward = { cosmeticId = "Hat_PierRookie",        title = "Boardwalk Rookie" },
    },
    {
        id          = 2,
        name        = "Regional Threat",
        description = "Make a name on the Regional Fairground circuit.",
        objectives  = {
            { key = "stage2_tier2_wins",   kind = "tierWin", tier = 2,                 target = 3, label = "Win 3 Tier 2 contests" },
            { key = "stage2_beat_tsunami", kind = "beatNpc", npc = "Tsunami Tyler",    target = 1, label = "Beat Tsunami Tyler once" },
        },
        reward = { cosmeticId = "Hat_RegionalThreat",    title = "Regional Threat" },
    },
    {
        id          = 3,
        name        = "National Contender",
        description = "Take the National Stadium by storm.",
        objectives  = {
            { key = "stage3_tier3_wins", kind = "tierWin", tier = 3,     target = 3, label = "Win 3 Tier 3 contests" },
            { key = "stage3_beat_miki",  kind = "beatNpc", npc = "MIKI", target = 1, label = "Beat MIKI once" },
        },
        reward = { cosmeticId = "Hat_NationalContender", title = "National Contender" },
    },
    {
        id          = 4,
        name        = "Bear-Bound",
        description = "World Championship gauntlet. The Bear is watching.",
        objectives  = {
            { key = "stage4_tier4_wins", kind = "tierWin", tier = 4,                          target = 2, label = "Win 2 Tier 4 contests" },
            { key = "stage4_beat_jaws",  kind = "beatNpc", npc = "'Jaws' Beasley McGraw",     target = 1, label = "Beat 'Jaws' Beasley McGraw once" },
        },
        -- Stage 4 grants the title only. The placeholder "BEAR PREVIEW
        -- (coming soon)" cutscene is triggered via the bearPreview flag on
        -- TournamentProgressUpdate. The real Bear boss fight is deferred.
        reward = { title = "Bear-Bound", bearPreview = true },
    },
}

return Constants
