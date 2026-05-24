-- MerchantLoop: drives the Spore Merchant rotation timer and
-- handles PurchaseMerchant RemoteEvent from clients.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config          = require(game.ReplicatedStorage.Common.Config)
local DataManager     = require(script.Parent.DataManager)
local CaveManager     = require(script.Parent.CaveManager)
local MushroomManager = require(script.Parent.MushroomManager)
local AuraSystem      = require(script.Parent.AuraSystem)
local MerchantManager = require(script.Parent.MerchantManager)

local Remotes           = ReplicatedStorage:WaitForChild("Remotes")
local MerchantStock     = Remotes:WaitForChild("MerchantStock")
local PurchaseMerchant  = Remotes:WaitForChild("PurchaseMerchant")
local SyncData          = Remotes:WaitForChild("SyncData")
local ShowcaseUpdated   = Remotes:WaitForChild("ShowcaseUpdated")

-- ── Initial stock on server start ─────────────────────────────────────────────
MerchantManager.refresh(MerchantStock)

-- ── Rotation loop ─────────────────────────────────────────────────────────────
task.spawn(function()
	while true do
		task.wait(Config.MERCHANT_REFRESH_INTERVAL)
		MerchantManager.refresh(MerchantStock)
	end
end)

-- ── Purchase handler ──────────────────────────────────────────────────────────
PurchaseMerchant.OnServerEvent:Connect(function(player: Player, speciesId: unknown)
	MerchantManager.handlePurchase(
		player, speciesId,
		DataManager, SyncData, ShowcaseUpdated,
		CaveManager, MushroomManager, AuraSystem
	)
end)
