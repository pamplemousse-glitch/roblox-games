-- SporeOrbLoop: wires SporeOrbManager into the player lifecycle.
-- Starts the orb-spawn loop when a player's data and plot are ready,
-- and cleans it up when the player leaves.

local Players = game:GetService("Players")

local DataManager    = require(script.Parent.DataManager)
local SporeOrbManager = require(script.Parent.SporeOrbManager)

Players.PlayerAdded:Connect(function(player: Player)
	-- Wait for DataManager to finish loading (same pattern as MushroomPlacer)
	for _ = 1, 20 do
		if DataManager.get(player) then break end
		task.wait(0.5)
	end
	-- Extra small delay so MushroomPlacer has assigned the plot first
	task.wait(0.5)
	SporeOrbManager.startForPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	SporeOrbManager.stopForPlayer(player)
end)
