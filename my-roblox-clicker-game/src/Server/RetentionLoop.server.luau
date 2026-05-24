-- RetentionLoop.server.luau
-- Wires login streak and daily quest systems to RemoteEvents,
-- and records quest progress via server-side event hooks.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataManager        = require(script.Parent.DataManager)
local LoginStreakManager = require(script.Parent.LoginStreakManager)
local DailyQuestManager  = require(script.Parent.DailyQuestManager)
local SporeOrbManager    = require(script.Parent.SporeOrbManager)
local MutationHook       = require(script.Parent.MutationHook)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local LoginStreakData   = Remotes:WaitForChild("LoginStreakData")
local ClaimStreakReward = Remotes:WaitForChild("ClaimStreakReward")
local DailyQuestData   = Remotes:WaitForChild("DailyQuestData")
local QuestProgress    = Remotes:WaitForChild("QuestProgress")
local ClaimQuestReward = Remotes:WaitForChild("ClaimQuestReward")
local SyncData         = Remotes:WaitForChild("SyncData")
local UnlockSpecies    = Remotes:WaitForChild("UnlockSpecies")
local Sporulate        = Remotes:WaitForChild("Sporulate")

-- ─── LOGIN STREAK SYSTEM ─────────────────────────────────────────────────────

LoginStreakManager.init(LoginStreakData, ClaimStreakReward, SyncData)

-- ─── DAILY QUEST DATA ON JOIN ────────────────────────────────────────────────

Players.PlayerAdded:Connect(function(player)
	task.spawn(function()
		local data
		for _ = 1, 20 do
			data = DataManager.get(player)
			if data then break end
			task.wait(0.5)
		end
		if data then
			DailyQuestManager.sendToPlayer(player, DailyQuestData)
		end
	end)
end)

-- ─── CLAIM HANDLERS ──────────────────────────────────────────────────────────

ClaimQuestReward.OnServerEvent:Connect(function(player, questId)
	DailyQuestManager.claimReward(player, questId, SyncData, DailyQuestData)
end)

-- ─── QUEST PROGRESS: ORB COLLECTION ─────────────────────────────────────────
-- SporeOrbManager.addOrbCallback fires with (player, orbValue) on every collect.

SporeOrbManager.addOrbCallback(function(player: Player, value: number)
	DailyQuestManager.recordProgress(
		player, "collectOrbs", value, QuestProgress, DailyQuestData)
end)

-- ─── QUEST PROGRESS: MUTATIONS ───────────────────────────────────────────────
-- MutationHook.fire(player) is called by SporeLoop after each mutation.

MutationHook.onMutation(function(player: Player)
	DailyQuestManager.recordProgress(
		player, "mutation", 1, QuestProgress, DailyQuestData)
end)

-- ─── QUEST PROGRESS: SPECIES UNLOCKS ────────────────────────────────────────
-- Listen to UnlockSpecies after PurchaseHandler has processed it (task.defer).

UnlockSpecies.OnServerEvent:Connect(function(player: Player, speciesId)
	task.defer(function()
		local data = DataManager.get(player)
		if not data then return end
		for _, id in ipairs(data.ownedSpecies) do
			if id == speciesId then
				DailyQuestManager.recordProgress(
					player, "unlockSpecies", 1, QuestProgress, DailyQuestData)
				break
			end
		end
	end)
end)

-- ─── QUEST PROGRESS: PRESTIGE ────────────────────────────────────────────────
-- Sporulate handler in PurchaseHandler runs first; defer so prestigeLevel is updated.

Sporulate.OnServerEvent:Connect(function(player: Player)
	task.defer(function()
		local data = DataManager.get(player)
		if not data then return end
		-- Only count if prestige actually happened (level > 0)
		if data.prestigeLevel > 0 then
			DailyQuestManager.recordProgress(
				player, "prestige", 1, QuestProgress, DailyQuestData)
		end
	end)
end)
