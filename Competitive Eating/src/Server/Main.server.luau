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
}

for _, name in remoteNames do
	local re      = Instance.new("RemoteEvent")
	re.Name       = name
	re.Parent     = remotesFolder
end

-- ── Init services ────────────────────────────────────────────────────────────

local Services = script.Parent.Services

local DataManager    = require(Services.DataManager)
local PlayerService  = require(Services.PlayerService)
local UpgradeService = require(Services.UpgradeService)
local ContestService = require(Services.ContestService)

DataManager.init()
PlayerService.init(remotesFolder)
UpgradeService.init(remotesFolder)
ContestService.init(remotesFolder)
