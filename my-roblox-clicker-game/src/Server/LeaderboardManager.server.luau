-- Two leaderboard tracks broadcast to all clients every 60s:
--   All-time : OrderedDataStore  — persists across server restarts forever
--   Season   : MemoryStoreSortedMap — 30-day rolling window, shared across all live servers

local DataStoreService   = game:GetService("DataStoreService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

local DataManager = require(script.Parent.DataManager)
local CaveManager = require(script.Parent.CaveManager)

-- ─── ALL-TIME TRACK ───────────────────────────────────────────────────────────

local lbStore = DataStoreService:GetOrderedDataStore("FunGuy_PeakSpores_v1")

-- ─── SEASON TRACK ────────────────────────────────────────────────────────────
-- Season number increments every 30 days from Unix epoch.
-- Each season gets its own map; old entries expire via TTL so the map is
-- never explicitly "reset" — it just gets a new name.

local SEASON_DURATION  = 30 * 86400
local seasonNumber     = math.floor(os.time() / SEASON_DURATION)
local seasonMap        = MemoryStoreService:GetSortedMap("FunGuy_Season_v1_" .. seasonNumber)

-- Entries live until the end of the season + a 1-day buffer (capped at MemoryStore's 45-day max)
local SEASON_SCORE_TTL = math.min(
	math.max((seasonNumber + 1) * SEASON_DURATION - os.time() + 86400, 1),
	3888000
)

-- ─── REMOTES ─────────────────────────────────────────────────────────────────

local Remotes                  = ReplicatedStorage:WaitForChild("Remotes")
local LeaderboardUpdated       = Remotes:WaitForChild("LeaderboardUpdated")
local ShowcaseUpdated          = Remotes:WaitForChild("ShowcaseUpdated")
local SeasonLeaderboardUpdated = Remotes:WaitForChild("SeasonLeaderboardUpdated")

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function getName(userId: number): string
	for _, p in ipairs(Players:GetPlayers()) do
		if p.UserId == userId then return p.DisplayName end
	end
	local ok, name = pcall(function()
		return Players:GetNameFromUserIdAsync(userId)
	end)
	return (ok and name) or "Unknown"
end

-- ─── SAVE FUNCTIONS ──────────────────────────────────────────────────────────

local function saveAllTimeScore(player: Player)
	local data = DataManager.get(player)
	if not data or (data.peakSpores or 0) <= 0 then return end
	pcall(function()
		lbStore:UpdateAsync(tostring(player.UserId), function(old)
			return math.max(old or 0, data.peakSpores)
		end)
	end)
end

local function saveSeasonScore(player: Player)
	local data = DataManager.get(player)
	if not data or (data.peakSpores or 0) <= 0 then return end
	pcall(function()
		seasonMap:SetAsync(
			tostring(player.UserId),
			{ displayName = player.DisplayName, peakSpores = data.peakSpores },
			SEASON_SCORE_TTL,
			data.peakSpores  -- sort key drives ranking
		)
	end)
end

-- ─── BROADCAST: ALL-TIME ─────────────────────────────────────────────────────

local function broadcastAllTime()
	for _, player in ipairs(Players:GetPlayers()) do
		saveAllTimeScore(player)
	end

	local ok, pages = pcall(function()
		return lbStore:GetSortedAsync(false, 10)
	end)
	if not ok then return end

	local entries = {}
	for rank, entry in ipairs(pages:GetCurrentPage()) do
		local uid = tonumber(entry.key)
		table.insert(entries, {
			rank        = rank,
			userId      = uid,
			displayName = getName(uid),
			peakSpores  = entry.value,
		})
	end
	LeaderboardUpdated:FireAllClients(entries)
end

-- ─── BROADCAST: SEASON ───────────────────────────────────────────────────────

local function broadcastSeason()
	for _, player in ipairs(Players:GetPlayers()) do
		saveSeasonScore(player)
	end

	local ok, items = pcall(function()
		return seasonMap:GetRangeAsync(Enum.SortDirection.Descending, 10)
	end)
	if not ok or not items then return end

	local entries = {}
	for rank, item in ipairs(items) do
		local val = item.value or {}
		table.insert(entries, {
			rank        = rank,
			userId      = tonumber(item.key) or 0,
			displayName = val.displayName or "Unknown",
			peakSpores  = item.sortKey,
		})
	end
	SeasonLeaderboardUpdated:FireAllClients(entries)
end

-- ─── BROADCAST: SHOWCASES ────────────────────────────────────────────────────

local function broadcastShowcases()
	ShowcaseUpdated:FireAllClients(CaveManager.getAll())
end

-- ─── PLAYER EVENTS ───────────────────────────────────────────────────────────

Players.PlayerAdded:Connect(function(player: Player)
	task.wait(3) -- give DataManager time to load and sync
	CaveManager.update(player, DataManager.get(player) or { ownedSpecies = {}, prestigeLevel = 0 })
	LeaderboardUpdated:FireClient(player, {})
	SeasonLeaderboardUpdated:FireClient(player, {})
	broadcastShowcases()
end)

Players.PlayerRemoving:Connect(function(player: Player)
	local data = DataManager.get(player)
	if data and (data.peakSpores or 0) > 0 then
		saveAllTimeScore(player)
		saveSeasonScore(player)
	end
	CaveManager.remove(player)
	broadcastShowcases()
end)

-- ─── BROADCAST LOOP (60s) ────────────────────────────────────────────────────

task.spawn(function()
	task.wait(15) -- initial delay after server start
	while true do
		broadcastAllTime()
		broadcastSeason()
		broadcastShowcases()
		task.wait(60)
	end
end)
