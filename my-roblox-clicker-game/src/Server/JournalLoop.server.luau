-- JournalLoop.server.luau
-- Boots JournalManager and syncs journal on player join.

local Players = game:GetService("Players")

local DataManager    = require(script.Parent.DataManager)
local JournalManager = require(script.Parent.JournalManager)

Players.PlayerAdded:Connect(function(player: Player)
	task.wait(3)
	local data = DataManager.get(player)
	if data then
		JournalManager.syncPlayer(player)
	end
end)
