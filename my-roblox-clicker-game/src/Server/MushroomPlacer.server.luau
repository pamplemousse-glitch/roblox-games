local Players = game:GetService("Players")

local DataManager    = require(script.Parent.DataManager)
local PlotManager    = require(script.Parent.PlotManager)
local MushroomManager = require(script.Parent.MushroomManager)
local AuraSystem     = require(script.Parent.AuraSystem)

Players.PlayerAdded:Connect(function(player: Player)
	-- Wait for DataManager to load player data
	local data
	for _ = 1, 20 do
		data = DataManager.get(player)
		if data then break end
		task.wait(0.5)
	end
	if not data then return end

	-- Retry up to 3 seconds to allow CaveInstancer time to create additional plots
	local plot
	for _ = 1, 6 do
		plot = PlotManager.assign(player)
		if plot then break end
		task.wait(0.5)
	end
	if not plot then
		warn("[MushroomPlacer] No free plot for", player.Name, "— add more Plot_N folders to workspace.Plots")
		return
	end

	-- Track lifetime mushrooms grown (for The Deep gate: 500 required)
	-- Only count species player didn't have credited yet (persisted in totalMushroomsGrown)
	local currentOwned = #(data.ownedSpecies or {})
	local credited = data.totalMushroomsGrown or 0
	if currentOwned > credited then
		data.totalMushroomsGrown = currentOwned
	end

	MushroomManager.spawnAll(player, data)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	local plot = PlotManager.getPlot(player)
	if plot then
		MushroomManager.despawnAll(plot)
	end
	AuraSystem.remove(player)
	PlotManager.release(player)
end)
