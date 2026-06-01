-- v1 Monetization scaffolding.
--
-- Handles:
--   1. VIP / Champion / Showman game-pass ownership checks + benefits
--   2. Style Buck dev-product purchases via ProcessReceipt
--   3. Style Buck balance + spend (player data layer)
--
-- IDs are configured in MONETIZATION_CONFIG below. Antoine must:
--   - Create the gamepasses + dev products on roblox.com creator dashboard
--   - Paste the resulting numeric IDs into the config table
--
-- Until real IDs are set, the system is fully functional but no purchases will
-- complete (stubs print a warning). This lets us ship the gameplay flow first.

local Players              = game:GetService("Players")
local MarketplaceService   = game:GetService("MarketplaceService")
local ReplicatedStorage    = game:GetService("ReplicatedStorage")

local Common      = ReplicatedStorage:WaitForChild("Common")
local DataManager = require(script.Parent.DataManager)

local MonetizationService = {}

-- ============================================================
-- CONFIG — Antoine pastes real IDs here after creating on creator hub
-- ============================================================

local GAMEPASS_IDS = {
	VIP       = 0,  -- TODO: paste VIP Pass game pass ID (299 R$)
	CHAMPION  = 0,  -- TODO: Champion's Kit (599 R$)
	SHOWMAN   = 0,  -- TODO: Showman's Pass (199 R$)
}

-- DEV_PRODUCTS: each entry { id = ..., styleBucks = ..., displayPrice = ... }
local DEV_PRODUCTS: { [number]: { styleBucks: number } } = {
	-- TODO: paste real dev product IDs after creating them
	-- Format:  [productId] = { styleBucks = N }
	-- Example: [123456789] = { styleBucks = 100 }
	-- 99 R$  → 100 Style Bucks
	-- 299 R$ → 350 Style Bucks (bonus)
	-- 999 R$ → 1300 Style Bucks (bigger bonus)
	-- 2499 R$ → 3500 Style Bucks (best deal)
}

-- VIP benefits applied per session
local VIP_DAILY_BONUS_COINS = 200
local VIP_COIN_MULTIPLIER   = 1.10  -- 10% extra coins from all sources

-- ============================================================
-- VIP / Gamepass ownership
-- ============================================================

local ownsCache: { [number]: { [number]: boolean } } = {}  -- userId → passId → owned

local function ownsGamepass(player: Player, passId: number): boolean
	if passId <= 0 then return false end  -- ID not configured yet
	local uid = player.UserId
	ownsCache[uid] = ownsCache[uid] or {}
	if ownsCache[uid][passId] ~= nil then return ownsCache[uid][passId] end

	local ok, owned = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(uid, passId)
	end)
	ownsCache[uid][passId] = ok and owned or false
	return ownsCache[uid][passId]
end

function MonetizationService.hasVIP(player: Player): boolean
	return ownsGamepass(player, GAMEPASS_IDS.VIP)
end

function MonetizationService.hasChampion(player: Player): boolean
	return ownsGamepass(player, GAMEPASS_IDS.CHAMPION)
end

function MonetizationService.hasShowman(player: Player): boolean
	return ownsGamepass(player, GAMEPASS_IDS.SHOWMAN)
end

-- Apply VIP coin multiplier — call this when awarding coins from contests
function MonetizationService.applyCoinMultiplier(player: Player, base: number): number
	if MonetizationService.hasVIP(player) then
		return math.floor(base * VIP_COIN_MULTIPLIER)
	end
	return base
end

-- Daily VIP login bonus — call once per session on join
function MonetizationService.grantDailyVIPBonus(player: Player)
	if MonetizationService.hasVIP(player) then
		local data = DataManager.get(player)
		if not data then return end
		local today = os.date("%Y-%m-%d", os.time())
		if data.lastVIPBonusDate ~= today then
			data.lastVIPBonusDate = today
			DataManager.addCoins(player, VIP_DAILY_BONUS_COINS)
		end
	end
end

-- ============================================================
-- ProcessReceipt for Style Buck purchases
-- ============================================================

local function processReceipt(receiptInfo): Enum.ProductPurchaseDecision
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local productData = DEV_PRODUCTS[receiptInfo.ProductId]
	if not productData then
		-- Unknown product — refund (Roblox won't retry)
		warn("[Monetization] Unknown product ID:", receiptInfo.ProductId)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	-- Grant Style Bucks via DataManager — this MUST succeed or we refund
	local ok = pcall(function()
		DataManager.addStyleBucks(player, productData.styleBucks)
	end)

	if ok then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	else
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
end

-- ============================================================
-- Init
-- ============================================================

function MonetizationService.init()
	MarketplaceService.ProcessReceipt = processReceipt

	-- Clear cache on player leave
	Players.PlayerRemoving:Connect(function(player)
		ownsCache[player.UserId] = nil
	end)

	-- Grant VIP daily bonus on join (DataManager loads first via PlayerService)
	Players.PlayerAdded:Connect(function(player)
		-- Wait briefly for data to load
		task.delay(2, function()
			if player.Parent then
				MonetizationService.grantDailyVIPBonus(player)
			end
		end)
	end)
end

return MonetizationService
