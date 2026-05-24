-- DataManager.luau
-- Player data persistence via ProfileStore (session locking, auto-reconcile,
-- automatic BindToClose handling, exponential backoff on DataStore errors).
-- Public API: DataManager.get(player), DataManager.save(player)

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProfileStore = require(ReplicatedStorage.Packages.ProfileStore)
local Config       = require(ReplicatedStorage.Common.Config)

-- ─── AUTO-SAVE INTERVAL ──────────────────────────────────────────────────────
-- Default is 300s. 180s is a good middle ground for our CCU range.
ProfileStore.SetConstant("AUTO_SAVE_PERIOD", 180)

-- ─── PROFILE TEMPLATE ────────────────────────────────────────────────────────
-- Every field and its default. profile:Reconcile() fills missing fields on load
-- so adding fields here = automatic schema migration for existing players.

local PROFILE_TEMPLATE = {
	-- ── Core game state ──────────────────────────────────────────────────────
	spores           = 0,
	lifetimeSpores   = 0,
	peakSpores       = 0,              -- all-time peak; never resets (leaderboard score)
	ownedSpecies     = { "button" },   -- start with Button Mushroom
	mutations        = {},             -- { [speciesId] = mutationCount }
	upgrades         = { Fertilizer = 0, Lighting = 0, Humidity = 0 },
	prestigeLevel    = 0,
	vault            = {},             -- { {id, mutations} } — survives prestige
	vaultSlots       = 0,             -- extra purchased vault slots
	lastSaveTime     = 0,             -- os.time() at last save (offline earnings calc)

	-- ── Legacy streak fields (kept for compatibility) ─────────────────────────
	loginStreak      = 0,
	lastLoginDay     = 0,

	-- ── Retention: session tracking ──────────────────────────────────────────
	lastLoginTimestamp   = 0,          -- os.time() set on PlayerAdded
	lastLogoutTimestamp  = 0,          -- os.time() set on PlayerRemoving
	totalSessions        = 0,          -- increments on each PlayerAdded
	totalPlaytimeSeconds = 0,          -- cumulative seconds in-game

	-- ── Retention: offline earnings ──────────────────────────────────────────
	offlineEarningsRate  = 0,          -- spores/sec snapshot saved on PlayerRemoving

	-- ── Retention: streak system ─────────────────────────────────────────────
	longestStreak        = 0,          -- all-time best login streak
	lastStreakDay        = 0,          -- reserved for alternative day tracking
	streakRewardDayClaimed = 0,        -- UTC day number of last streak reward claim

	-- ── Retention: daily quests ──────────────────────────────────────────────
	dailyQuestSeed        = 0,         -- deterministic seed for today's quest set
	dailyQuestsCompleted  = {},        -- { [questId] = count }
	lastDailyQuestReset   = 0,         -- os.time() of last quest reset

	-- ── Seasonal leaderboard ────────────────────────────────────────────────
	currentSeasonSpores  = 0,          -- spores earned this season (resets each season)
	seasonNumber         = 0,          -- which season the player last competed in

	-- ── Monetization ────────────────────────────────────────────────────────
	isVIP       = false,   -- active VIP subscription (checked via MarketplaceService)
	owns2xPass  = false,   -- 2× production game pass

	-- ── Mole fishing ────────────────────────────────────────────────────────
	fragments  = {},             -- { [speciesId] = fragmentCount }; 10 = auto-unlock
	catalysts  = 0,              -- mutation catalyst count (guarantees next mutation)

	-- ── Progression gates ───────────────────────────────────────────────────
	totalMushroomsGrown  = 0,   -- lifetime mushrooms placed; gate for The Deep (500)

	-- ── Mycelium Tending (Phase 5) ───────────────────────────────────────────
	tendingBonuses = {},         -- { [speciesId] = { water=0, nutrients=0, pollinate=0 } }

	-- ── Pets (Phase 6) ──────────────────────────────────────────────────────
	pets = {
		owned  = {},             -- { { id, species, variant, caughtAt } }
		active = {},             -- up to 2 pet ids
	},

	-- ── Deep / Combat (Phase 7-8) ────────────────────────────────────────────
	mobKills       = 0,
	deepUnlocked   = false,
	sporeDebt      = 0,
	playerHP       = 100,
	maxPlayerHP    = 100,
	weapons        = { "truffle_trowel", "spore_launcher" },
	equippedWeapon = "truffle_trowel",

	-- ── Vat / Ingredients (Phase 9) ──────────────────────────────────────────
	ingredients = {},            -- { [ingredientId] = count }
	brews       = {},            -- { [potionId] = count }

	-- ── Journal (Phase 10) ───────────────────────────────────────────────────
	journal = {},                -- { [speciesId] = true }

	-- ── Schema version ───────────────────────────────────────────────────────
	schemaVersion = 2,
}

-- ─── STORE ───────────────────────────────────────────────────────────────────

local Store    = ProfileStore.New("FunGuy_v1", PROFILE_TEMPLATE)
local profiles = {}  -- [Player] -> Profile

-- ─── OFFLINE EARNINGS ────────────────────────────────────────────────────────

local function applyOfflineSpores(data: table)
	local now     = os.time()
	local elapsed = now - data.lastSaveTime
	if elapsed <= 0 or data.lastSaveTime == 0 then return end

	local offlineCap    = Config.OFFLINE_CAP_SECONDS
		* (data.isVIP and Config.VIP_OFFLINE_CAP_MULT or 1)
	local cappedElapsed = math.min(elapsed, offlineCap)

	-- Prefer the saved rate (set by SporeLoop each tick on server)
	local sporesPerSec = data.offlineEarningsRate
	if sporesPerSec == 0 then
		-- Fallback: recalculate from static species data (no weather/aura offline)
		local prodMult    = Config.getProductionMultiplier(data.upgrades.Fertilizer, data.upgrades.Lighting)
		local prestigeMult = Config.PRESTIGE_MULTIPLIERS[data.prestigeLevel] or 1
		sporesPerSec = 0
		for _, id in ipairs(data.ownedSpecies) do
			local species = Config.SPECIES_BY_ID[id]
			if species then
				local mutCount = data.mutations[id] or 0
				local mutBonus = mutCount > 0
					and Config.MUTATION_MULTIPLIERS[species.tier] ^ mutCount
					or 1
				sporesPerSec += species.sporesPerSec * mutBonus
			end
		end
		sporesPerSec = sporesPerSec * prodMult * prestigeMult
	end

	local earned = math.floor(sporesPerSec * cappedElapsed)
	if earned > 0 then
		data.spores        += earned
		data.lifetimeSpores += earned
	end
end

-- ─── LOGIN STREAK ────────────────────────────────────────────────────────────

local function applyLoginStreak(data: table)
	local DAY = 86400
	local now = os.time()

	if data.lastLoginTimestamp == 0 then
		-- First ever login
		data.loginStreak = 1
	else
		local daysSince = math.floor((now - data.lastLoginTimestamp) / DAY)
		if daysSince == 1 then
			data.loginStreak += 1       -- consecutive day
		elseif daysSince > 1 then
			data.loginStreak = 1        -- streak broken, restart at 1
		end
		-- daysSince == 0: same calendar day, no change
	end

	data.longestStreak      = math.max(data.longestStreak, data.loginStreak)
	data.lastLoginTimestamp = now
	data.totalSessions      += 1
end

-- ─── LOAD PLAYER ─────────────────────────────────────────────────────────────

local function loadPlayer(player: Player)
	local key = "player_" .. player.UserId

	local profile = Store:StartSessionAsync(key, {
		Cancel = function()
			return player.Parent == nil  -- player left while loading
		end,
	})

	if profile == nil then
		-- Store is closing or player cancelled — kick so they can retry
		warn("[DataManager] Profile nil for", player.Name, "— kicking")
		player:Kick("[FunGuy] Your data could not be loaded. Please rejoin.")
		return
	end

	if player.Parent == nil then
		-- Player left before the session was acquired
		profile:EndSession()
		return
	end

	profile:Reconcile()
	profile:AddUserId(player.UserId)

	local data = profile.Data

	-- Apply offline earnings based on time since last save
	applyOfflineSpores(data)

	-- Update streak + session counters
	applyLoginStreak(data)

	-- Refresh the save timestamp
	data.lastSaveTime = os.time()

	-- If another server steals the session (rare on rejoin), kick the player
	profile.OnSessionEnd:Connect(function()
		profiles[player] = nil
		player:Kick("[FunGuy] Your session was reset. Please rejoin.")
	end)

	profiles[player] = profile
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

local DataManager = {}

--- Returns the live data table for a player, or nil if not yet loaded.
function DataManager.get(player: Player): table?
	local profile = profiles[player]
	return profile and profile.Data or nil
end

--- Force-saves the player's data immediately (use after purchases/prestige).
function DataManager.save(player: Player)
	local profile = profiles[player]
	if profile and profile:IsActive() then
		profile:Save()
	end
end

--- Called on PlayerRemoving: snapshots logout stats and ends the session.
function DataManager.remove(player: Player)
	local profile = profiles[player]
	if not profile then return end

	local data = profile.Data
	local now  = os.time()

	data.lastLogoutTimestamp  = now
	data.totalPlaytimeSeconds += math.floor(now - data.lastLoginTimestamp)
	data.lastSaveTime          = now
	-- offlineEarningsRate is kept as-is (last value written by SporeLoop each tick)

	profile:EndSession()
	profiles[player] = nil
end

-- ─── PLAYER EVENTS ───────────────────────────────────────────────────────────

-- NOTE: Roblox guarantees PlayerRemoving fires for all players before BindToClose,
-- so DataManager.remove covers normal disconnects and server shutdowns.
-- ProfileStore's own BindToClose handler waits for all EndSession calls to
-- complete before the server exits.

Players.PlayerAdded:Connect(function(player)
	task.spawn(loadPlayer, player)
end)

Players.PlayerRemoving:Connect(function(player)
	DataManager.remove(player)
end)

-- Catch-all for the rare case PlayerRemoving doesn't fire (Studio play-tests, etc.)
game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		DataManager.remove(player)
	end
end)

return DataManager
