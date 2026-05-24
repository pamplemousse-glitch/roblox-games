local Config = {}

-- Prestige multiplier is applied on top of all spores/sec
Config.OFFLINE_CAP_SECONDS = 28800 -- 8 hours
Config.TICK_RATE = 1 -- seconds between spore accumulation ticks

Config.PRESTIGE_REQUIREMENTS = { 5e7, 5e8, 5e9, 5e10 } -- lifetime spores needed (balance: ~4-5h active for P1)
Config.PRESTIGE_MULTIPLIERS  = { 2, 5, 12, 30 }           -- cumulative multiplier at each level
Config.VAULT_SLOTS_BY_PRESTIGE = { 3, 6, 12, 20 }         -- slots unlocked at prestige 1/2/3/4

-- Upgrade tracks: 20 levels each
Config.UPGRADES = {
	Fertilizer = {
		baseCost = 200,
		costScaling = 1.8,
		effectPerLevel = 0.15, -- +15% spores/sec per level
	},
	Lighting = {
		baseCost = 500,
		costScaling = 1.6,
		effectPerLevel = 0.10,
	},
	Humidity = {
		baseCost = 1000,
		costScaling = 2.2,
		effectPerLevel = 0.05, -- +5% mutation chance per level
	},
}

-- Cave events (replaces old weather system)
-- Fire randomly every 10–15 min, last 3 min each, reward different playstyles.
Config.CAVE_EVENT_MIN_INTERVAL = 480   -- 8 min minimum between events (balance: more frequent early game)
Config.CAVE_EVENT_MAX_INTERVAL = 720   -- 12 min maximum between events
Config.CAVE_EVENT_DURATION     = 180   -- 3 min active duration

Config.CAVE_EVENTS = {
	{ name = "Mycelium Surge",       weight = 40 },  -- 2× orb spawn rate
	{ name = "Underground Spring",   weight = 35 },  -- highlights mole holes, halves bite timer
	{ name = "Bioluminescent Bloom", weight = 25 },  -- 3× mutation roll weight
}

Config.BLOOM_MUTATION_WEIGHT_MULT = 3  -- Bloom triples mutation tier weights

-- Species list — id, display name, tier, base spores/sec, unlock cost
Config.SPECIES = {
	-- Common (free to cheap)
	{ id = "button",        name = "Button Mushroom",    tier = "Common",   sporesPerSec = 1,    unlockCost = 0 },
	{ id = "oyster",        name = "Oyster Mushroom",    tier = "Common",   sporesPerSec = 2,    unlockCost = 100 },
	{ id = "shiitake",      name = "Shiitake",           tier = "Common",   sporesPerSec = 2,    unlockCost = 200 },
	{ id = "chanterelle",   name = "Chanterelle",        tier = "Common",   sporesPerSec = 3,    unlockCost = 300 },
	{ id = "portobello",    name = "Portobello",         tier = "Common",   sporesPerSec = 3,    unlockCost = 350 },
	{ id = "enoki",         name = "Enoki",              tier = "Common",   sporesPerSec = 3,    unlockCost = 400 },
	{ id = "maitake",       name = "Maitake",            tier = "Common",   sporesPerSec = 4,    unlockCost = 425 },
	{ id = "porcini",       name = "Porcini",            tier = "Common",   sporesPerSec = 4,    unlockCost = 440 },
	{ id = "morel",         name = "Morel",              tier = "Common",   sporesPerSec = 4,    unlockCost = 450 },
	{ id = "lionsmane",     name = "Lion's Mane",        tier = "Common",   sporesPerSec = 4,    unlockCost = 460 },
	{ id = "kingtrumpet",   name = "King Trumpet",       tier = "Common",   sporesPerSec = 5,    unlockCost = 480 },
	{ id = "cremini",       name = "Cremini",            tier = "Common",   sporesPerSec = 5,    unlockCost = 500 },

	-- Uncommon
	{ id = "henofwoods",    name = "Hen of the Woods",   tier = "Uncommon", sporesPerSec = 8,    unlockCost = 1000 },
	{ id = "blacktrumpet",  name = "Black Trumpet",      tier = "Uncommon", sporesPerSec = 10,   unlockCost = 2000 },
	{ id = "lobster",       name = "Lobster Mushroom",   tier = "Uncommon", sporesPerSec = 12,   unlockCost = 3500 },
	{ id = "coralfungus",   name = "Coral Fungus",       tier = "Uncommon", sporesPerSec = 13,   unlockCost = 5000 },
	{ id = "cauliflower",   name = "Cauliflower Fungus", tier = "Uncommon", sporesPerSec = 14,   unlockCost = 6000 },
	{ id = "chestnut",      name = "Chestnut Mushroom",  tier = "Uncommon", sporesPerSec = 15,   unlockCost = 7000 },
	{ id = "velvetpiop",    name = "Velvet Pioppino",    tier = "Uncommon", sporesPerSec = 17,   unlockCost = 8500 },
	{ id = "nameko",        name = "Nameko",             tier = "Uncommon", sporesPerSec = 20,   unlockCost = 10000 },

	-- Rare
	{ id = "matsutake",     name = "Matsutake",          tier = "Rare",     sporesPerSec = 30,   unlockCost = 25000 },
	{ id = "caesars",       name = "Caesar's Mushroom",  tier = "Rare",     sporesPerSec = 40,   unlockCost = 40000 },
	{ id = "saffronmilk",   name = "Saffron Milk Cap",   tier = "Rare",     sporesPerSec = 50,   unlockCost = 60000 },
	{ id = "indigomilk",    name = "Indigo Milk Cap",    tier = "Rare",     sporesPerSec = 60,   unlockCost = 90000 },
	{ id = "chickenwoods",  name = "Chicken of the Woods", tier = "Rare",   sporesPerSec = 70,   unlockCost = 110000 },
	{ id = "giantpuffball", name = "Giant Puffball",     tier = "Rare",     sporesPerSec = 75,   unlockCost = 130000 },
	{ id = "hedgehog",      name = "Hedgehog Mushroom",  tier = "Rare",     sporesPerSec = 80,   unlockCost = 150000 },
	{ id = "flyagaric",     name = "Amanita Muscaria",   tier = "Rare",     sporesPerSec = 90,   unlockCost = 175000 },

	-- Epic
	{ id = "ghostfungus",   name = "Ghost Fungus",       tier = "Epic",     sporesPerSec = 120,  unlockCost = 500000 },
	{ id = "bleedingtooth", name = "Bleeding Tooth",     tier = "Epic",     sporesPerSec = 175,  unlockCost = 800000 },
	{ id = "amethyst",      name = "Amethyst Deceiver",  tier = "Epic",     sporesPerSec = 225,  unlockCost = 1200000 },
	{ id = "violetweb",     name = "Violet Webcap",      tier = "Epic",     sporesPerSec = 270,  unlockCost = 1600000 },
	{ id = "biolumpanellus",name = "Bioluminescent Panellus", tier = "Epic", sporesPerSec = 300, unlockCost = 2000000 },

	-- Mythic
	{ id = "goldenteacher", name = "Golden Teacher",     tier = "Mythic",   sporesPerSec = 500,  unlockCost = 10000000 },
	{ id = "azuredragon",   name = "Azure Dragon Oyster", tier = "Mythic",  sporesPerSec = 900,  unlockCost = 50000000 },
	{ id = "starfire",      name = "Starfire Cap",        tier = "Mythic",  sporesPerSec = 1500, unlockCost = 100000000 },
}

-- Build a lookup table by id for fast access
Config.SPECIES_BY_ID = {}
for _, species in ipairs(Config.SPECIES) do
	Config.SPECIES_BY_ID[species.id] = species
end

-- Tier mutation multipliers
Config.MUTATION_MULTIPLIERS = {
	Common   = 1.5,
	Uncommon = 2.0,
	Rare     = 3.0,
	Epic     = 5.0,
	Mythic   = 10.0,
}

Config.MUTATION_BASE_CHANCE = 0.05      -- 5% base chance per qualifying weather event end
Config.MUTATION_HUMIDITY_BONUS = 0.0125 -- +1.25% per Humidity level (level 20 = 30% total)
Config.MAX_MUTATIONS_PER_SPECIES = 3
Config.MUTATION_TRIGGER_EVENTS = { "Bioluminescent Bloom" } -- only Bloom triggers mutations
Config.MUTATION_TIER_WEIGHTS = { Common=1, Uncommon=2, Rare=4, Epic=8, Mythic=16 }

-- Upgrade cost formula: baseCost * scaling ^ (level - 1)
function Config.getUpgradeCost(upgradeName: string, level: number): number
	local u = Config.UPGRADES[upgradeName]
	return math.floor(u.baseCost * u.costScaling ^ (level - 1))
end

-- Total spores/sec multiplier from upgrades (Fertilizer + Lighting stacked additively then applied)
function Config.getProductionMultiplier(fertLevel: number, lightLevel: number): number
	local bonus = 1
		+ Config.UPGRADES.Fertilizer.effectPerLevel * fertLevel
		+ Config.UPGRADES.Lighting.effectPerLevel * lightLevel
	return bonus
end

-- Mutation chance per qualifying weather event end
function Config.getMutationChance(humidLevel: number): number
	return Config.MUTATION_BASE_CHANCE + Config.MUTATION_HUMIDITY_BONUS * humidLevel
end

-- ─── MERCHANT ────────────────────────────────────────────────────────────────

Config.MERCHANT_REFRESH_INTERVAL = 360  -- 6 minutes between stock rotations

Config.MERCHANT_DISCOUNTS = {
	Common   = 0.80,
	Uncommon = 0.85,
	Rare     = 0.90,
	Epic     = 0.95,
	Mythic   = 1.00,
}

Config.MERCHANT_TIER_SLOTS = { "Common", "Uncommon", "Rare", "Epic" }

-- ─── MYCELIUM PULSE ──────────────────────────────────────────────────────────

Config.PULSE_PLAYER_THRESHOLD = 3    -- active players needed to trigger
Config.PULSE_ACTIVITY_WINDOW  = 60   -- seconds before a player goes "inactive"
Config.PULSE_INTERVAL         = 120  -- seconds between pulses while active
Config.PULSE_DURATION         = 60   -- seconds the boost lasts
Config.PULSE_BOOST            = 0.20 -- +20% spores/sec multiplier

-- ─── LOGIN STREAK REWARDS (7-day cycle, repeating) ───────────────────────────

Config.STREAK_REWARDS = {
	{ day = 1, spores = 500,   species = nil,         upgrade = nil,       label = "500 Spores" },
	{ day = 2, spores = 2000,  species = nil,         upgrade = nil,       label = "2K Spores" },
	{ day = 3, spores = 0,     species = "uncommon",  upgrade = nil,       label = "Free Uncommon" },
	{ day = 4, spores = 10000, species = nil,         upgrade = nil,       label = "10K Spores" },
	{ day = 5, spores = 0,     species = nil,         upgrade = "Humidity",label = "Humidity Upgrade" },
	{ day = 6, spores = 50000, species = nil,         upgrade = nil,       label = "50K Spores" },
	{ day = 7, spores = 100000,species = "rare",      upgrade = nil,       label = "Free Rare + 100K Spores" },
}
-- Which streak-day index maps to which reward (streak % 7, 0 = 7)
-- e.g. loginStreak 1 → day index 1, loginStreak 8 → day index 1, etc.

-- ─── DAILY QUESTS ────────────────────────────────────────────────────────────

-- Pool of possible quests; 3 are selected each UTC day via dailyQuestSeed
Config.DAILY_QUEST_POOL = {
	{ id = "orbs_10k",   type = "collectOrbs", amount = 10000, reward = 5000,   label = "Collect 10K spores via orbs" },
	{ id = "orbs_50k",   type = "collectOrbs", amount = 50000, reward = 20000,  label = "Collect 50K spores via orbs" },
	{ id = "orbs_100k",  type = "collectOrbs", amount = 100000,reward = 40000,  label = "Collect 100K spores via orbs" },
	{ id = "mutation_1", type = "mutation",    amount = 1,     reward = 20000,  label = "Trigger a weather mutation" },
	{ id = "mutation_3", type = "mutation",    amount = 3,     reward = 75000,  label = "Trigger 3 weather mutations" },
	{ id = "species_2",  type = "unlockSpecies", amount = 2,   reward = 15000,  label = "Unlock 2 new species" },
	{ id = "species_4",  type = "unlockSpecies", amount = 4,   reward = 35000,  label = "Unlock 4 new species" },
	{ id = "prestige_1", type = "prestige",    amount = 1,     reward = 500000, label = "Sporulate (Prestige)" },
}

Config.DAILY_QUEST_COUNT   = 3      -- quests generated per day
Config.DAILY_QUEST_RESET_HOUR = 0   -- UTC hour to reset quests (midnight UTC)

-- ─── TENDING ────────────────────────────────────────────────────────────────
Config.TENDING_DURATION        = 600   -- 10 min bonus active + refill time
Config.TENDING_WATER_MULT      = 1.25  -- ×1.25 spores/sec on that species
Config.TENDING_NUTRIENTS_MULT  = 1.15
Config.TENDING_POLLINATE_MULT  = 1.10

-- ─── PETS ────────────────────────────────────────────────────────────────────
Config.MOLE_CATCH_CHANCE      = 0.08  -- 8% on depth-3 fishing pass
Config.CRICKET_SPAWN_INTERVAL = 240   -- seconds between cricket spawns per player
Config.CRICKET_CATCH_CHANCE   = 0.15  -- 15% on ProximityPrompt trigger
Config.CRICKET_DESPAWN_TIME   = 120   -- cricket despawns if not caught in 2 min

-- ─── MOB / COMBAT ────────────────────────────────────────────────────────────
Config.MOB_SPAWN_INTERVAL = 45
Config.MOB_TYPES = {
	{ id = "cave_beetle",  hp = 60,  damage = 10, drops = { spores = {min=100, max=500} } },
	{ id = "blind_fish",   hp = 20,  damage = 5,  drops = { spores = {min=50,  max=200} } },
	{ id = "shadow_spore", hp = 40,  damage = 15, drops = { spores = {min=200, max=800} } },
	-- Cave event mobs (spawn in personal cave during events)
	{ id = "spore_beetle", hp = 30,  damage = 8,  drops = { spores = {min=50,  max=300} } },
	{ id = "cave_leech",   hp = 20,  damage = 12, drops = { spores = {min=30,  max=200} } },
}
Config.MOB_AGGRO_RADIUS = 15

Config.PLAYER_MAX_HP          = 100
Config.SPORE_DEBT_PENALTY     = 0.15   -- 15% reduction per debt harvest
Config.SPORE_DEBT_STACKS      = 3      -- harvests affected per death
Config.SPORE_DEBT_MAX_STACKS  = 9      -- max stacks

Config.WEAPONS = {
	{ id = "truffle_trowel", name = "Truffle Trowel",  damage = 25, cooldown = 0.8, range = 8,  tier = "basic" },
	{ id = "spore_launcher", name = "Spore Launcher",  damage = 15, cooldown = 0.4, range = 30, tier = "basic", isRanged = true },
	{ id = "flyagaric_flask", name = "Flyagaric Flask", damage = 8,  cooldown = 3.0, range = 15, tier = "basic", isDot = true, dotDuration = 5, dotTickDamage = 3 },
}

-- ─── VAT RECIPES ─────────────────────────────────────────────────────────────
Config.VAT_RECIPES = {
	{ id = "spore_surge",      name = "Spore Surge",     ingredients = { button=3, porcini=2 },            output = "spore_surge",      outputCount = 1 },
	{ id = "fogveil",          name = "Fogveil",          ingredients = { ghostfungus=2 },                  output = "fogveil",          outputCount = 1 },
	{ id = "deepblood",        name = "Deepblood",        ingredients = { violetweb=3, amethyst=2 },        output = "deepblood",        outputCount = 1 },
	{ id = "glow_elixir",      name = "Glow Elixir",      ingredients = { enoki=4 },                        output = "glow_elixir",      outputCount = 1 },
	{ id = "molten_mycelium",  name = "Molten Mycelium",  ingredients = { flyagaric=2 },                    output = "molten_mycelium",  outputCount = 1 },
	{ id = "rootbind_brew",    name = "Rootbind Brew",    ingredients = { morel=3, chanterelle=2 },         output = "rootbind_brew",    outputCount = 1 },
}

Config.POTION_EFFECTS = {
	spore_surge     = { type = "productionMult", value = 2.0, duration = 300 },
	fogveil         = { type = "mobInvisible",   duration = 180 },
	deepblood       = { type = "oneHitAbsorb",   duration = 600 },
	glow_elixir     = { type = "revealSpawns",   duration = 180 },
	molten_mycelium = { type = "weaponPoison",   value = 3, duration = 30 },
	rootbind_brew   = { type = "autoNet",        duration = 60 },
}

-- ─── JOURNAL ─────────────────────────────────────────────────────────────────
Config.JOURNAL_MILESTONE_REWARDS = {
	[5]  = { spores = 5000 },
	[10] = { spores = 25000 },
	[20] = { spores = 100000 },
	[35] = { spores = 500000 },
}

-- ─── MONETIZATION ────────────────────────────────────────────────────────────
-- Fill in real IDs before publishing. 0 = feature disabled (no API calls made).
Config.SUBSCRIPTION_VIP_ID  = 1839932280  -- VIP Pass
Config.GAME_PASS_2X_ID      = 1840974272  -- Mycelium Mayhem Pass (2× production)

Config.VIP_PASSIVE_MULT     = 1.20  -- +20% passive spores/sec for VIP subscribers
Config.VIP_OFFLINE_CAP_MULT = 2     -- VIP gets 2× the offline earnings cap
Config.MONETIZATION_GATE_SECONDS = 900  -- 15 min of playtime before upsells shown

return Config
