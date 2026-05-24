-- MerchantManager: manages the rotating Spore Merchant stock.
-- Refreshes every MERCHANT_REFRESH_INTERVAL seconds.
-- Picks one species per tier slot (Common/Uncommon/Rare/Epic) the server
-- doesn't know if players own yet — clients filter "OWNED" display-side.
-- Broadcasts MerchantStock to all clients on each rotation.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config           = require(game.ReplicatedStorage.Common.Config)
local AnalyticsManager = require(script.Parent.AnalyticsManager)

local MerchantManager = {}

-- ─── STATE ────────────────────────────────────────────────────────────────────

-- currentStock: array of { id, name, tier, sporesPerSec, cost, originalCost }
local currentStock: { any } = {}
local nextRefreshAt: number = 0

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

-- Build a tier → species list lookup once at startup
local SPECIES_BY_TIER: { [string]: { any } } = {}
for _, sp in ipairs(Config.SPECIES) do
	if not SPECIES_BY_TIER[sp.tier] then
		SPECIES_BY_TIER[sp.tier] = {}
	end
	table.insert(SPECIES_BY_TIER[sp.tier], sp)
end

local function pickStock(): { any }
	local stock = {}
	for _, tier in ipairs(Config.MERCHANT_TIER_SLOTS) do
		local pool = SPECIES_BY_TIER[tier]
		if pool and #pool > 0 then
			local sp          = pool[math.random(#pool)]
			local discount    = Config.MERCHANT_DISCOUNTS[tier] or 1
			local discounted  = math.max(1, math.floor(sp.unlockCost * discount))
			table.insert(stock, {
				id           = sp.id,
				name         = sp.name,
				tier         = tier,
				sporesPerSec = sp.sporesPerSec,
				originalCost = sp.unlockCost,
				cost         = discounted,
			})
		end
	end
	return stock
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

function MerchantManager.getStock(): { any }
	return currentStock
end

function MerchantManager.getNextRefreshAt(): number
	return nextRefreshAt
end

-- Call this to rotate and broadcast to all clients
function MerchantManager.refresh(MerchantStockRemote: RemoteEvent)
	currentStock  = pickStock()
	nextRefreshAt = os.time() + Config.MERCHANT_REFRESH_INTERVAL
	MerchantStockRemote:FireAllClients({
		stock         = currentStock,
		nextRefreshAt = nextRefreshAt,
	})
end

-- Validate and process a merchant purchase request from a client
function MerchantManager.handlePurchase(
	player:       Player,
	speciesId:    unknown,
	DataManager:  any,
	SyncData:     RemoteEvent,
	ShowcaseUpdated: RemoteEvent,
	CaveManager:  any,
	MushroomManager: any,
	AuraSystem:   any
)
	if type(speciesId) ~= "string" then return end

	-- Find the item in the current stock
	local stockItem = nil
	for _, item in ipairs(currentStock) do
		if item.id == speciesId then
			stockItem = item
			break
		end
	end
	if not stockItem then return end   -- item not in current rotation

	local data = DataManager.get(player)
	if not data then return end

	-- Check not already owned
	for _, id in ipairs(data.ownedSpecies) do
		if id == speciesId then return end
	end

	-- Check affordable at discounted cost
	if data.spores < stockItem.cost then return end

	-- Apply purchase
	data.spores -= stockItem.cost
	table.insert(data.ownedSpecies, speciesId)
	DataManager.save(player)
	SyncData:FireClient(player, data)
	CaveManager.update(player, data)
	ShowcaseUpdated:FireAllClients(CaveManager.getAll())
	MushroomManager.spawnOne(player, speciesId, 0)
	AuraSystem.update(player, data)
	AnalyticsManager.onMerchantPurchase(player, speciesId, stockItem.tier, stockItem.cost, data.spores)
end

return MerchantManager
