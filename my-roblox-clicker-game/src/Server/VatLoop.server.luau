-- VatLoop.server.luau
-- Wires BrewPotion, UsePotion remotes and sends VatState on join.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataManager = require(script.Parent.DataManager)
local VatManager  = require(script.Parent.VatManager)

local Remotes    = ReplicatedStorage:WaitForChild("Remotes")
local BrewPotion = Remotes:WaitForChild("BrewPotion")
local UsePotion  = Remotes:WaitForChild("UsePotion")

BrewPotion.OnServerEvent:Connect(function(player: Player, recipeId: unknown)
	if type(recipeId) ~= "string" then return end
	VatManager.brew(player, recipeId)
end)

UsePotion.OnServerEvent:Connect(function(player: Player, potionId: unknown)
	if type(potionId) ~= "string" then return end
	VatManager.usePotion(player, potionId)
end)

-- Send VatState on join
Players.PlayerAdded:Connect(function(player: Player)
	task.spawn(function()
		task.wait(3)
		VatManager.syncPlayer(player)
	end)
end)
