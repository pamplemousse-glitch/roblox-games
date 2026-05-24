local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config          = require(game.ReplicatedStorage.Common.Config)
local DataManager     = require(script.Parent.DataManager)
local CaveManager     = require(script.Parent.CaveManager)
local MushroomManager = require(script.Parent.MushroomManager)
local AuraSystem      = require(script.Parent.AuraSystem)
local PlotManager      = require(script.Parent.PlotManager)
local AnalyticsManager = require(script.Parent.AnalyticsManager)
local JournalManager   = require(script.Parent.JournalManager)

local Remotes         = ReplicatedStorage:WaitForChild("Remotes")
local PurchaseUpgrade = Remotes:WaitForChild("PurchaseUpgrade")
local UnlockSpecies   = Remotes:WaitForChild("UnlockSpecies")
local Sporulate       = Remotes:WaitForChild("Sporulate")
local SyncData        = Remotes:WaitForChild("SyncData")
local ShowcaseUpdated = Remotes:WaitForChild("ShowcaseUpdated")
local ArrangeSwap     = Remotes:WaitForChild("ArrangeSwap")

local function syncPlayer(player: Player)
	local data = DataManager.get(player)
	if data then
		SyncData:FireClient(player, data)
	end
end

local function broadcastShowcase(player: Player, data: table)
	CaveManager.update(player, data)
	ShowcaseUpdated:FireAllClients(CaveManager.getAll())
end

-- Initial sync on join (DataManager loads async so we poll)
Players.PlayerAdded:Connect(function(player: Player)
	local data
	for _ = 1, 20 do
		data = DataManager.get(player)
		if data then break end
		task.wait(0.5)
	end
	if data then
		SyncData:FireClient(player, data)
		CaveManager.update(player, data)
	end
end)

-- Upgrade purchase: PurchaseUpgrade(upgradeName: string)
PurchaseUpgrade.OnServerEvent:Connect(function(player: Player, upgradeName: unknown)
	if type(upgradeName) ~= "string" then return end
	if not Config.UPGRADES[upgradeName] then return end

	local data = DataManager.get(player)
	if not data then return end

	local level = data.upgrades[upgradeName] or 0
	if level >= 20 then return end

	local cost = Config.getUpgradeCost(upgradeName, level + 1)
	if data.spores < cost then return end

	data.spores -= cost
	data.upgrades[upgradeName] = level + 1
	DataManager.save(player)
	syncPlayer(player)
	AnalyticsManager.onUpgradePurchase(player, upgradeName, level + 1, data.spores)
end)

-- Species unlock: UnlockSpecies(speciesId: string)
UnlockSpecies.OnServerEvent:Connect(function(player: Player, speciesId: unknown)
	if type(speciesId) ~= "string" then return end

	local species = Config.SPECIES_BY_ID[speciesId]
	if not species then return end

	local data = DataManager.get(player)
	if not data then return end

	for _, id in ipairs(data.ownedSpecies) do
		if id == speciesId then return end
	end

	if data.spores < species.unlockCost then return end

	data.spores -= species.unlockCost
	table.insert(data.ownedSpecies, speciesId)
	data.totalMushroomsGrown = (data.totalMushroomsGrown or 0) + 1
	DataManager.save(player)
	syncPlayer(player)
	broadcastShowcase(player, data)
	AnalyticsManager.onSpeciesUnlock(player, speciesId, species.tier, species.unlockCost, data.spores)

	-- Spawn mushroom model and recalculate aura
	MushroomManager.spawnOne(player, speciesId, 0)
	AuraSystem.update(player, data)

	-- Journal discovery
	JournalManager.discover(player, speciesId)
end)

-- Prestige / Sporulate — client sends vault selections as second arg
Sporulate.OnServerEvent:Connect(function(player: Player, vaultSelections: { string }?)
	local data = DataManager.get(player)
	if not data then return end

	local nextLevel = data.prestigeLevel + 1
	local requirement = Config.PRESTIGE_REQUIREMENTS[nextLevel]
	if not requirement then return end
	if data.lifetimeSpores < requirement then return end

	-- Validate vault selections against owned species
	local maxSlots = (Config.VAULT_SLOTS_BY_PRESTIGE[nextLevel] or 0) + (data.vaultSlots or 0)
	local vaultData = {}
	if type(vaultSelections) == "table" then
		local seen = {}
		for _, id in ipairs(vaultSelections) do
			if #vaultData >= maxSlots then break end
			if type(id) ~= "string" or id == "button" or seen[id] then continue end
			for _, ownedId in ipairs(data.ownedSpecies) do
				if ownedId == id then
					table.insert(vaultData, { id = id, mutations = data.mutations[id] or 0 })
					seen[id] = true
					break
				end
			end
		end
	end

	local prevLifetimeSpores = data.lifetimeSpores
	data.peakSpores = math.max(data.peakSpores or 0, data.lifetimeSpores)

	-- Full reset
	data.spores         = 0
	data.lifetimeSpores = 0
	data.ownedSpecies   = { "button" }
	data.mutations      = {}
	data.upgrades       = { Fertilizer = 0, Lighting = 0, Humidity = 0 }
	data.prestigeLevel  = nextLevel
	data.vault          = vaultData

	-- Restore vaulted species with their mutations intact
	for _, entry in ipairs(vaultData) do
		table.insert(data.ownedSpecies, entry.id)
		if entry.mutations > 0 then
			data.mutations[entry.id] = entry.mutations
		end
	end

	DataManager.save(player)
	syncPlayer(player)
	broadcastShowcase(player, data)

	-- Rebuild mushroom models for the new run (species reset + vault restored)
	local plot = PlotManager.getPlot(player)
	if plot then
		MushroomManager.despawnAll(plot)
		MushroomManager.spawnAll(player, data)
	end
	AuraSystem.update(player, data)
	AnalyticsManager.onPrestige(player, nextLevel, prevLifetimeSpores, #vaultData)
end)

-- Arrange swap: ArrangeSwap(speciesIdA, targetRootSpotName)
ArrangeSwap.OnServerEvent:Connect(function(player: Player, speciesIdA: unknown, targetRootSpotName: unknown)
	if type(speciesIdA) ~= "string" or type(targetRootSpotName) ~= "string" then return end
	local data = DataManager.get(player)
	if not data then return end
	local owns = false
	for _, id in ipairs(data.ownedSpecies) do
		if id == speciesIdA then owns = true break end
	end
	if not owns then return end
	MushroomManager.swapMushroom(player, speciesIdA, targetRootSpotName)
end)
