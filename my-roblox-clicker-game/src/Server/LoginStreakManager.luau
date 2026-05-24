-- LoginStreakManager.luau
-- Handles login streak reward claims.
-- On PlayerAdded: sends streak data to the client so it can show the popup.
-- On ClaimStreakReward: validates the claim, grants the reward, saves.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config           = require(ReplicatedStorage.Common.Config)
local DataManager      = require(script.Parent.DataManager)
local AnalyticsManager = require(script.Parent.AnalyticsManager)

local LoginStreakManager = {}

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function utcDay(): number
	return math.floor(os.time() / 86400)
end

-- Maps loginStreak → 1-7 reward index (repeating 7-day cycle)
local function getRewardIndex(streak: number): number
	local idx = streak % 7
	return idx == 0 and 7 or idx
end

-- Find a random species of the given tier the player doesn't own yet
local function pickFreeSpecies(data: table, tier: string): string?
	local candidates = {}
	for _, species in ipairs(Config.SPECIES) do
		if species.tier ~= tier then continue end
		local owned = false
		for _, id in ipairs(data.ownedSpecies) do
			if id == species.id then owned = true; break end
		end
		if not owned then
			table.insert(candidates, species.id)
		end
	end
	if #candidates == 0 then return nil end
	return candidates[math.random(#candidates)]
end

-- ─── SEND STREAK DATA TO CLIENT ──────────────────────────────────────────────

function LoginStreakManager.sendToPlayer(player: Player, LoginStreakData: RemoteEvent)
	local data = DataManager.get(player)
	if not data then return end

	local today       = utcDay()
	local rewardIndex = getRewardIndex(data.loginStreak)
	local reward      = Config.STREAK_REWARDS[rewardIndex]
	local canClaim    = data.streakRewardDayClaimed ~= today

	LoginStreakData:FireClient(player, {
		streak     = data.loginStreak,
		longest    = data.longestStreak,
		rewardDay  = rewardIndex,
		rewardLabel= reward.label,
		canClaim   = canClaim,
	})
end

-- ─── CLAIM HANDLER ───────────────────────────────────────────────────────────

function LoginStreakManager.handleClaim(player: Player, SyncData: RemoteEvent)
	local data = DataManager.get(player)
	if not data then return end

	local today = utcDay()
	if data.streakRewardDayClaimed == today then return end  -- already claimed today

	local rewardIndex = getRewardIndex(data.loginStreak)
	local reward      = Config.STREAK_REWARDS[rewardIndex]

	-- Grant spores
	if (reward.spores or 0) > 0 then
		data.spores        += reward.spores
		data.lifetimeSpores += reward.spores
	end

	-- Grant free species (by tier)
	if reward.species then
		local speciesId = pickFreeSpecies(data, reward.species:sub(1,1):upper() .. reward.species:sub(2))
		if speciesId then
			table.insert(data.ownedSpecies, speciesId)
		end
	end

	-- Grant upgrade level
	if reward.upgrade then
		local upg = data.upgrades[reward.upgrade] or 0
		if upg < 20 then
			data.upgrades[reward.upgrade] = upg + 1
		end
	end

	data.streakRewardDayClaimed = today

	DataManager.save(player)
	SyncData:FireClient(player, data)
	AnalyticsManager.onStreakClaimed(player, rewardIndex, reward.label, reward.spores or 0, data.spores)
end

-- ─── WIRE UP (called by LoginStreakLoop) ─────────────────────────────────────

function LoginStreakManager.init(LoginStreakData: RemoteEvent, ClaimStreakReward: RemoteEvent, SyncData: RemoteEvent)

	-- Send streak popup data when a player's data finishes loading
	Players.PlayerAdded:Connect(function(player)
		-- Poll until data is ready (DataManager loads async)
		task.spawn(function()
			local data
			for _ = 1, 20 do
				data = DataManager.get(player)
				if data then break end
				task.wait(0.5)
			end
			if data then
				LoginStreakManager.sendToPlayer(player, LoginStreakData)
			end
		end)
	end)

	ClaimStreakReward.OnServerEvent:Connect(function(player)
		LoginStreakManager.handleClaim(player, SyncData)
	end)

end

return LoginStreakManager
