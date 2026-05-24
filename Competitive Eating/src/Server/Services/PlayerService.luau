local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common       = ReplicatedStorage.Common
local DataManager  = require(script.Parent.DataManager)

local PlayerService = {}

local remotes: { [string]: RemoteEvent } = {}

function PlayerService.init(remotesFolder: Folder)
	remotes.StatsUpdate = remotesFolder:WaitForChild("StatsUpdate") :: RemoteEvent

	Players.PlayerAdded:Connect(PlayerService._onJoin)
	Players.PlayerRemoving:Connect(PlayerService._onLeave)

	for _, player in Players:GetPlayers() do
		task.spawn(PlayerService._onJoin, player)
	end
end

function PlayerService._onJoin(player: Player)
	local data = DataManager.load(player)
	remotes.StatsUpdate:FireClient(player, data.stats, data.coins, data.highestTier)
end

function PlayerService._onLeave(player: Player)
	DataManager.unload(player)
end

-- Returns whether the player has unlocked the given tier (1-based)
function PlayerService.hasTierUnlocked(player: Player, tier: number): boolean
	local data = DataManager.get(player)
	if not data then return false end
	return data.highestTier >= tier
end

function PlayerService.updateHighestTier(player: Player, tier: number)
	local data = DataManager.get(player)
	if not data then return end
	if tier > data.highestTier then
		data.highestTier = tier
		DataManager.markDirty(player)
	end
end

return PlayerService
