-- Server entry point. Creates all RemoteEvents, then inits services.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ── Create RemoteEvents ───────────────────────────────────────────────────────

local remotesFolder = Instance.new("Folder")
remotesFolder.Name  = "Remotes"
remotesFolder.Parent = ReplicatedStorage

local remoteNames = {
	-- Skill check
	"SkillCheckStart",      -- server → client
	"SkillCheckResult",     -- client → server
	-- Fill meter
	"FillUpdate",           -- server → client
	-- Contest lifecycle
	"ContestPhaseChanged",  -- server → client
	"ShowResults",          -- server → client
	-- Queue
	"JoinQueue",            -- client → server
	"LeaveQueue",           -- client → server
	-- Shop / stats
	"PurchaseUpgrade",      -- client → server
	"StatsUpdate",          -- server → client
	-- Mini-games
	"StartMiniGame",        -- client → server
	"MiniGameChallenge",    -- server → client
	"MiniGameThrow",        -- client → server
	"MiniGameResult",       -- server → client
	-- Vendors
	"OpenShop",             -- server → client
	"OpenPrizeBooth",       -- server → client
	-- Tickets
	"AddTickets",           -- server → client
	-- Cosmetics
	"BuyCosmetic",          -- client → server
	"EquipCosmetic",        -- client → server
	"CosmeticBought",       -- server → client
	-- Coaster
	"CoasterFade",          -- server → client  (true = fade-in, false = fade-out)
	-- Friend Vault
	"DepositToVault",       -- bidirectional: client→server requests deposit; server→client confirms (success, newBalance, newCoins)
	"WithdrawFromVault",    -- bidirectional: same shape as DepositToVault
}

for _, name in remoteNames do
	local re      = Instance.new("RemoteEvent")
	re.Name       = name
	re.Parent     = remotesFolder
end

-- ── Init services ────────────────────────────────────────────────────────────

local Services = script.Parent.Services

local DataManager      = require(Services.DataManager)
local PlayerService    = require(Services.PlayerService)
local UpgradeService   = require(Services.UpgradeService)
local ContestService   = require(Services.ContestService)
local MiniGameService    = require(Services.MiniGameService)
local NpcVendorService   = require(Services.NpcVendorService)
local CosmeticsService   = require(Services.CosmeticsService)
local MonetizationService = require(Services.MonetizationService)
local RideController     = require(Services.RideController)
local FriendVaultService = require(Services.FriendVaultService)

DataManager.init()
PlayerService.init(remotesFolder)
MonetizationService.init()
UpgradeService.init(remotesFolder)
ContestService.init(remotesFolder)
MiniGameService.init(remotesFolder)
NpcVendorService.init(remotesFolder)
CosmeticsService.init(remotesFolder)
RideController.init(remotesFolder)
FriendVaultService.init(remotesFolder)
