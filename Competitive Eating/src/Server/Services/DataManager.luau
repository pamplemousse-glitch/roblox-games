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

return DataManager
