-- JournalManager.luau
-- Tracks which mushroom species the player has discovered.
-- Fires JournalUpdated and MilestoneReached remotes on changes.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config      = require(game.ReplicatedStorage.Common.Config)
local DataManager = require(script.Parent.DataManager)

local JournalManager = {}

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function getJournalSize(data: table): number
	local n = 0
	for _ in pairs(data.journal or {}) do n += 1 end
	return n
end

local function fireJournalUpdated(player: Player, data: table)
	local Remotes        = ReplicatedStorage:FindFirstChild("Remotes")
	local JournalUpdated = Remotes and Remotes:FindFirstChild("JournalUpdated")
	if JournalUpdated then
		JournalUpdated:FireClient(player, data.journal or {})
	end
end

local function checkMilestones(player: Player, data: table, oldSize: number, newSize: number)
	local Remotes         = ReplicatedStorage:FindFirstChild("Remotes")
	local MilestoneReached = Remotes and Remotes:FindFirstChild("MilestoneReached")

	for count, reward in pairs(Config.JOURNAL_MILESTONE_REWARDS) do
		if oldSize < count and newSize >= count then
			-- Grant reward
			if reward.spores and reward.spores > 0 then
				data.spores         += reward.spores
				data.lifetimeSpores += reward.spores
				DataManager.save(player)
			end
			if MilestoneReached then
				MilestoneReached:FireClient(player, count, reward)
			end
		end
	end
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

-- Records a species discovery. Fires remotes if new.
function JournalManager.discover(player: Player, speciesId: string)
	if type(speciesId) ~= "string" then return end
	if not Config.SPECIES_BY_ID[speciesId] then return end

	local data = DataManager.get(player)
	if not data then return end

	data.journal = data.journal or {}
	if data.journal[speciesId] then return end  -- already discovered

	local oldSize = getJournalSize(data)
	data.journal[speciesId] = true
	local newSize = getJournalSize(data)

	DataManager.save(player)
	fireJournalUpdated(player, data)
	checkMilestones(player, data, oldSize, newSize)
end

-- Returns progress summary for a player.
function JournalManager.getProgress(player: Player): table
	local data = DataManager.get(player)
	if not data then return { discovered = {}, total = #Config.SPECIES } end

	return {
		discovered = data.journal or {},
		total      = #Config.SPECIES,
	}
end

-- Sync journal to client on join.
function JournalManager.syncPlayer(player: Player)
	local data = DataManager.get(player)
	if not data then return end
	fireJournalUpdated(player, data)
end

return JournalManager
