-- VIPManager.luau
-- Checks and caches VIP subscription + 2× game pass status on player join.
-- Re-checks every 5 minutes so lapses/upgrades take effect mid-session.
-- Fires SyncData to the client after each check so the HUD badge stays in sync.

local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

local Config      = require(game.ReplicatedStorage.Common.Config)
local DataManager = require(script.Parent.DataManager)

local SyncData = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SyncData")

local VIPManager = {}

local REFRESH_INTERVAL = 300  -- re-check every 5 minutes

local function checkPlayer(player: Player)
	local data = DataManager.get(player)
	if not data then return end

	local changed = false

	-- 2× game pass (simpler, faster call)
	if Config.GAME_PASS_2X_ID ~= 0 then
		local ok, owns = pcall(MarketplaceService.UserOwnsGamePassAsync,
			MarketplaceService, player.UserId, Config.GAME_PASS_2X_ID)
		if ok and data.owns2xPass ~= owns then
			data.owns2xPass = owns
			changed = true
		end
	end

	-- VIP subscription
	if Config.SUBSCRIPTION_VIP_ID ~= 0 then
		local ok, status = pcall(MarketplaceService.GetUserSubscriptionStatusAsync,
			MarketplaceService, player, Config.SUBSCRIPTION_VIP_ID)
		if ok and status then
			local isVIP = status.IsSubscribed == true
			if data.isVIP ~= isVIP then
				data.isVIP = isVIP
				changed = true
			end
		end
	end

	if changed then
		DataManager.save(player)
		SyncData:FireClient(player, data)
	end
end

local function startRefreshLoop(player: Player)
	task.spawn(function()
		-- Wait for data to load (DataManager loads async on PlayerAdded)
		for _ = 1, 20 do
			if DataManager.get(player) then break end
			task.wait(0.5)
		end

		while player.Parent do
			checkPlayer(player)
			task.wait(REFRESH_INTERVAL)
		end
	end)
end

function VIPManager.init()
	Players.PlayerAdded:Connect(startRefreshLoop)

	-- Catch players already in game (Studio playtest scenario)
	for _, player in ipairs(Players:GetPlayers()) do
		startRefreshLoop(player)
	end
end

return VIPManager
