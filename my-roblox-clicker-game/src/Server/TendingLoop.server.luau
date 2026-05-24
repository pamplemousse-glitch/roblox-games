-- TendingLoop.server.luau
-- Wires TendSlot RemoteEvent and sends initial TendingState on join.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataManager     = require(script.Parent.DataManager)
local TendingManager  = require(script.Parent.TendingManager)
local Config          = require(game.ReplicatedStorage.Common.Config)

local Remotes       = ReplicatedStorage:WaitForChild("Remotes")
local TendSlot      = Remotes:WaitForChild("TendSlot")
local TendingState  = Remotes:WaitForChild("TendingState")
local UpdateSpores  = Remotes:WaitForChild("UpdateSpores")

local VALID_SLOTS = { water = true, nutrients = true, pollinate = true }

TendSlot.OnServerEvent:Connect(function(player: Player, speciesId: unknown, slotType: unknown)
	if type(speciesId) ~= "string" then return end
	if type(slotType)  ~= "string" then return end
	if not VALID_SLOTS[slotType] then return end

	-- Validate species ownership
	local data = DataManager.get(player)
	if not data then return end

	local owned = false
	for _, id in ipairs(data.ownedSpecies) do
		if id == speciesId then owned = true; break end
	end
	if not owned then return end

	-- Validate species exists in Config
	if not Config.SPECIES_BY_ID[speciesId] then return end

	local payout = TendingManager.tendSlot(player, speciesId, slotType)
	if payout > 0 then
		local updatedData = DataManager.get(player)
		local sps = 0
		if updatedData then
			sps = updatedData.offlineEarningsRate or 0
			UpdateSpores:FireClient(player, updatedData.spores, updatedData.lifetimeSpores, sps)
		end
		TendingState:FireClient(player, TendingManager.getSlotState(player))
	end
end)

-- Send current tending state on join
Players.PlayerAdded:Connect(function(player: Player)
	task.spawn(function()
		task.wait(3)
		local data = DataManager.get(player)
		if data then
			TendingState:FireClient(player, TendingManager.getSlotState(player))
		end
	end)
end)
