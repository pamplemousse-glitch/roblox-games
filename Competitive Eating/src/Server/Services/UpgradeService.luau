local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common      = ReplicatedStorage.Common
local Constants   = require(Common.Constants)
local DataManager = require(script.Parent.DataManager)

local UpgradeService = {}

local remotes: { [string]: RemoteEvent } = {}
local cooldowns: { [number]: number } = {}

local COOLDOWN = 0.3

function UpgradeService.init(remotesFolder: Folder)
	remotes.PurchaseUpgrade = remotesFolder:WaitForChild("PurchaseUpgrade") :: RemoteEvent
	remotes.StatsUpdate     = remotesFolder:WaitForChild("StatsUpdate")     :: RemoteEvent

	remotes.PurchaseUpgrade.OnServerEvent:Connect(function(player: Player, statName: any)
		UpgradeService._onPurchase(player, statName)
	end)
end

function UpgradeService._onPurchase(player: Player, statName: any)
	local now    = tick()
	local userId = player.UserId

	if cooldowns[userId] and now - cooldowns[userId] < COOLDOWN then return end
	cooldowns[userId] = now

	if not table.find(Constants.STAT_NAMES, statName) then return end

	local ok = DataManager.upgradeStat(player, statName)
	if ok then
		local data = DataManager.get(player)
		remotes.StatsUpdate:FireClient(player, data.stats, data.coins, data.highestTier)
	end
end

return UpgradeService
