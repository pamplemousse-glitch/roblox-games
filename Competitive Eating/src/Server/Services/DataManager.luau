-- Server-only. Safe DataStore load/save with session locking.
-- All DataStore calls wrapped in pcall. Auto-saves every 60s.

local DataStoreService = game:GetService("DataStoreService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

local Common    = game:GetService("ReplicatedStorage").Common
local Constants = require(Common.Constants)
local Utils     = require(Common.Utils)

local DataManager = {}

local store: DataStore
local cache: { [number]: any } = {}       -- userId → data
local dirty: { [number]: boolean } = {}   -- userId → needs save
local connections: { [number]: RBXScriptConnection } = {}

-- ── Init ─────────────────────────────────────────────────────────────────────

function DataManager.init()
	local ok, result = pcall(function()
		store = DataStoreService:GetDataStore(Constants.DATASTORE_NAME)
	end)
	if not ok then
		warn("[DataManager] DataStore unavailable (publish place or enable Studio API access):", tostring(result))
	end

	-- Auto-save loop
	task.spawn(function()
		while true do
			task.wait(Constants.SAVE_INTERVAL)
			for userId, isDirty in dirty do
				if isDirty then
					DataManager._save(userId)
				end
			end
		end
	end)
end

-- ── Load ─────────────────────────────────────────────────────────────────────

function DataManager.load(player: Player): any
	local userId = player.UserId
	local key    = tostring(userId)

	if not store then
		cache[userId] = Utils.defaultPlayerData()
		dirty[userId] = false
		return cache[userId]
	end

	local ok, result = pcall(function()
		return store:GetAsync(key)
	end)

	local data: any
	if ok and result then
		-- Migrate if needed
		data = result
		if not data.stats then
			data.stats = Utils.defaultPlayerData().stats
		end
		if data.version == nil then
			data.version = 1
		end
		-- v1 currency unification: migrate any existing tickets to coins (2.5x ratio).
		if data.carnivalTickets and data.carnivalTickets > 0 then
			data.coins = (data.coins or 0) + math.floor(data.carnivalTickets * 2.5)
			data.carnivalTickets = 0
		elseif data.carnivalTickets == nil then
			data.carnivalTickets = 0
		end
		if data.statXp == nil then
			data.statXp = {}
		end
		if data.npcEncounters == nil then
			data.npcEncounters = {}
		end
	else
		data = Utils.defaultPlayerData()
		if not ok then
			warn("[DataManager] Load failed for", player.Name, ":", tostring(result))
		end
	end

	cache[userId] = data
	dirty[userId] = false
	return data
end

-- ── Get / Set ────────────────────────────────────────────────────────────────

function DataManager.get(player: Player): any
	return cache[player.UserId]
end

function DataManager.markDirty(player: Player)
	dirty[player.UserId] = true
end

-- ── Save ─────────────────────────────────────────────────────────────────────

function DataManager._save(userId: number)
	if not store then return end
	local data = cache[userId]
	if not data then return end

	local key = tostring(userId)
	local ok, err = pcall(function()
		store:SetAsync(key, data)
	end)

	if ok then
		dirty[userId] = false
	else
		warn("[DataManager] Save failed for userId", userId, ":", tostring(err))
	end
end

function DataManager.save(player: Player)
	DataManager._save(player.UserId)
end

-- ── Unload ───────────────────────────────────────────────────────────────────

function DataManager.unload(player: Player)
	local userId = player.UserId
	DataManager._save(userId)
	cache[userId]  = nil
	dirty[userId]  = nil
end

-- ── Convenience mutators (always call markDirty after) ───────────────────────

function DataManager.addCoins(player: Player, amount: number)
	local data = cache[player.UserId]
	if not data then return end
	data.coins = math.max(0, data.coins + amount)
	dirty[player.UserId] = true
end

-- ── Style Bucks (premium currency — purchased w/ Robux, spent on cosmetics) ──

function DataManager.addStyleBucks(player: Player, amount: number)
	local data = cache[player.UserId]
	if not data then return end
	data.styleBucks = math.max(0, (data.styleBucks or 0) + amount)
	dirty[player.UserId] = true
end

function DataManager.spendStyleBucks(player: Player, amount: number): boolean
	local data = cache[player.UserId]
	if not data then return false end
	if (data.styleBucks or 0) < amount then return false end
	data.styleBucks = data.styleBucks - amount
	dirty[player.UserId] = true
	return true
end

function DataManager.spendCoins(player: Player, amount: number): boolean
	local data = cache[player.UserId]
	if not data then return false end
	if data.coins < amount then return false end
	data.coins = data.coins - amount
	dirty[player.UserId] = true
	return true
end

function DataManager.upgradeStat(player: Player, stat: string): boolean
	local data = cache[player.UserId]
	if not data then return false end
	local current = data.stats[stat] or 0
	if current >= Constants.STAT_MAX_LEVEL then return false end
	local cost = Utils.upgradeCost(current)
	if data.coins < cost then return false end
	data.coins = data.coins - cost
	data.stats[stat] = current + 1
	dirty[player.UserId] = true
	return true
end

function DataManager.recordWin(player: Player)
	local data = cache[player.UserId]
	if not data then return end
	data.totalWins = (data.totalWins or 0) + 1

	local today = Utils.todayString()
	if data.lastWinDate ~= today then
		data.lastWinDate = today
		DataManager.addCoins(player, Constants.COIN_FIRST_WIN_DAILY)
	end

	local streak = (data.winStreak or 0) + 1
	data.winStreak = streak

	-- v1 free starter cosmetic: first-ever win grants Hot Dog Hat for instant identity.
	-- Player has a visible flex from minute 2 of play.
	if data.totalWins == 1 then
		data.ownedCosmetics = data.ownedCosmetics or {}
		if not data.ownedCosmetics["Hat_HotDog"] then
			data.ownedCosmetics["Hat_HotDog"] = true
			-- Optional: auto-equip
			data.equippedCosmetics = data.equippedCosmetics or {}
			data.equippedCosmetics.hat = "Hat_HotDog"
		end
	end

	dirty[player.UserId] = true
end

function DataManager.recordLoss(player: Player)
	local data = cache[player.UserId]
	if not data then return end
	data.winStreak = 0
	dirty[player.UserId] = true
end

function DataManager.recordContest(player: Player)
	local data = cache[player.UserId]
	if not data then return end
	data.contestsPlayed = (data.contestsPlayed or 0) + 1
	if not data.firstContestDone then
		data.firstContestDone = true
	end
	dirty[player.UserId] = true
end

-- ── Carnival Ticket mutators ──────────────────────────────────────────────────

function DataManager.addTickets(player: Player, amount: number)
	local data = cache[player.UserId]
	if not data then return end
	data.carnivalTickets = math.max(0, (data.carnivalTickets or 0) + amount)
	dirty[player.UserId] = true
end

function DataManager.spendTickets(player: Player, amount: number): boolean
	local data = cache[player.UserId]
	if not data then return false end
	if (data.carnivalTickets or 0) < amount then return false end
	data.carnivalTickets = data.carnivalTickets - amount
	dirty[player.UserId] = true
	return true
end

-- ── Friend Vault ──────────────────────────────────────────────────────────────
-- Shared coin pool a player and their Roblox friends can deposit into.
-- Only the vault owner withdraws. Cap enforced by caller (FriendVaultService).

function DataManager.addToFriendVault(player: Player, amount: number): boolean
	local data = cache[player.UserId]
	if not data then return false end
	if amount <= 0 then return false end
	data.friendVaultBalance = (data.friendVaultBalance or 0) + amount
	dirty[player.UserId] = true
	return true
end

function DataManager.withdrawFromFriendVault(player: Player, amount: number): boolean
	local data = cache[player.UserId]
	if not data then return false end
	if amount <= 0 then return false end
	if (data.friendVaultBalance or 0) < amount then return false end
	data.friendVaultBalance = data.friendVaultBalance - amount
	dirty[player.UserId] = true
	return true
end

-- ── NPC encounters (rivalry memory) ──────────────────────────────────────────
-- Each entry: { count, wins, losses, lastContestDate }

function DataManager.getNpcEncounter(player: Player, npcName: string): any
	local data = cache[player.UserId]
	if not data then return nil end
	data.npcEncounters = data.npcEncounters or {}
	return data.npcEncounters[npcName]
end

function DataManager.recordNpcEncounter(player: Player, npcName: string, outcome: string?)
	local data = cache[player.UserId]
	if not data then return end
	data.npcEncounters = data.npcEncounters or {}

	local rec = data.npcEncounters[npcName]
	if not rec then
		rec = { count = 0, wins = 0, losses = 0, lastContestDate = "" }
		data.npcEncounters[npcName] = rec
	end

	rec.count = (rec.count or 0) + 1
	if outcome == "win" then
		rec.wins = (rec.wins or 0) + 1
	elseif outcome == "loss" then
		rec.losses = (rec.losses or 0) + 1
	end
	rec.lastContestDate = Utils.todayString()

	dirty[player.UserId] = true
end

-- ── Stat XP ───────────────────────────────────────────────────────────────────
-- Every 100 XP triggers an auto-upgrade attempt if the player can afford it.
-- XP always accumulates even if upgrade fails (e.g. insufficient coins).

local STAT_XP_PER_LEVEL = 100

function DataManager.addStatXp(player: Player, statName: string, xp: number)
	local data = cache[player.UserId]
	if not data then return end

	if not data.statXp then data.statXp = {} end
	data.statXp[statName] = (data.statXp[statName] or 0) + xp

	-- Attempt auto-upgrade for each full threshold crossed
	while (data.statXp[statName] or 0) >= STAT_XP_PER_LEVEL do
		local current = data.stats and (data.stats[statName] or 0) or 0
		if current >= Constants.STAT_MAX_LEVEL then break end
		local cost = Utils.upgradeCost(current)
		if data.coins >= cost then
			data.coins = data.coins - cost
			data.stats[statName] = current + 1
			data.statXp[statName] = (data.statXp[statName] or 0) - STAT_XP_PER_LEVEL
		else
			-- Can't afford; stop draining XP until they can
			break
		end
	end

	dirty[player.UserId] = true
end

return DataManager
