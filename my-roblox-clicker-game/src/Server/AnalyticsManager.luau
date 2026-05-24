-- Server-side analytics via Roblox AnalyticsService.
-- Session tracking, mutations, and orb onboarding are self-subscribed here.
-- Economy / progression events are fired by callers via the public API so they
-- fire at the exact moment the event succeeds, with no RemoteEvent race conditions.
-- All AnalyticsService calls are pcall-wrapped — failures never affect gameplay.
--
-- Public API (called from other server modules):
--   AnalyticsManager.onUpgradePurchase(player, upgradeName, newLevel, balance)
--   AnalyticsManager.onSpeciesUnlock(player, speciesId, tier, cost, balance)
--   AnalyticsManager.onMerchantPurchase(player, speciesId, tier, cost, balance)
--   AnalyticsManager.onPrestige(player, newLevel, prevLifetimeSpores, vaultSize)
--   AnalyticsManager.onStreakClaimed(player, streakDay, label, rewardSpores, balance)
--   AnalyticsManager.onQuestClaimed(player, questId, questType, reward, balance)
--   AnalyticsManager.onCaveEvent(player, eventName)

local AnalyticsService = game:GetService("AnalyticsService")
local Players          = game:GetService("Players")

local Config          = require(game.ReplicatedStorage.Common.Config)
local DataManager     = require(script.Parent.DataManager)
local MutationHook    = require(script.Parent.MutationHook)
local SporeOrbManager = require(script.Parent.SporeOrbManager)

-- ─── WRAPPERS ─────────────────────────────────────────────────────────────────

local Sink   = Enum.AnalyticsEconomyFlowType.Sink
local Source = Enum.AnalyticsEconomyFlowType.Source

local function logEconomy(player, flowType, amount, balance, txType, sku, fields)
	pcall(AnalyticsService.LogEconomyEvent, AnalyticsService,
		player, flowType, "Spores", amount, balance, txType, sku, fields or {})
end

local function logCustom(player, eventName, value, fields)
	pcall(AnalyticsService.LogCustomEvent, AnalyticsService,
		player, eventName, value or 0, fields or {})
end

local function logOnboarding(player, step, stepName, fields)
	pcall(AnalyticsService.LogOnboardingFunnelStepEvent, AnalyticsService,
		player, step, stepName, fields or {})
end

local function logProgression(player, level)
	pcall(AnalyticsService.LogProgressionCompleteEvent, AnalyticsService,
		player, "Prestige", level, "Prestige_" .. level, {})
end

-- ─── SESSION CACHE ────────────────────────────────────────────────────────────
-- Snapshots key fields at session start so session_end can log them even after
-- DataManager has already cleared the profile during PlayerRemoving.

local sessionCache        = {}   -- [Player] → { startTime, loginStreak, prestigeLevel, totalSessions }
local orbFiredThisSession = {}   -- [Player] → bool

-- ─── ONBOARDING FUNNEL ───────────────────────────────────────────────────────
-- Steps 1–3 and 5 are inferred from stored data on each session start.
-- Roblox deduplicates LogOnboardingFunnelStepEvent by (player, step) server-side.
-- Step 4 (first orb) is tracked live via the SporeOrbManager callback below.

local function checkCompletedSteps(player, data)
	if data.totalSessions <= 1 then
		logOnboarding(player, 1, "first_join")
	end
	if #data.ownedSpecies >= 2 then
		logOnboarding(player, 2, "first_species_unlocked")
	end
	for _, lvl in pairs(data.upgrades) do
		if lvl >= 1 then
			logOnboarding(player, 3, "first_upgrade_purchased")
			break
		end
	end
	if data.prestigeLevel >= 1 then
		logOnboarding(player, 5, "first_prestige")
	end
end

-- ─── SESSION EVENTS (self-subscribed) ────────────────────────────────────────

Players.PlayerAdded:Connect(function(player)
	task.spawn(function()
		local data
		for _ = 1, 20 do
			data = DataManager.get(player)
			if data then break end
			task.wait(0.5)
		end
		if not data then return end

		sessionCache[player] = {
			startTime     = os.time(),
			loginStreak   = data.loginStreak,
			prestigeLevel = data.prestigeLevel,
			totalSessions = data.totalSessions,
		}

		logCustom(player, "session_start", data.totalSessions, {
			login_streak   = data.loginStreak,
			prestige_level = data.prestigeLevel,
			species_count  = #data.ownedSpecies,
		})

		checkCompletedSteps(player, data)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	local cached = sessionCache[player]
	sessionCache[player]        = nil
	orbFiredThisSession[player] = nil
	if not cached then return end

	logCustom(player, "session_end", os.time() - cached.startTime, {
		login_streak   = cached.loginStreak,
		prestige_level = cached.prestigeLevel,
		total_sessions = cached.totalSessions,
	})
end)

-- ─── MUTATIONS & ORBS (self-subscribed) ──────────────────────────────────────

MutationHook.onMutation(function(player)
	local d = DataManager.get(player)
	if not d then return end
	logCustom(player, "mutation_triggered", 1, {
		prestige_level = d.prestigeLevel,
		species_count  = #d.ownedSpecies,
	})
end)

SporeOrbManager.addOrbCallback(function(player, _value)
	if orbFiredThisSession[player] then return end
	orbFiredThisSession[player] = true
	logOnboarding(player, 4, "first_orb_collected")
end)

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

local AnalyticsManager = {}

-- PurchaseHandler: called after upgrade purchase succeeds.
function AnalyticsManager.onUpgradePurchase(player, upgradeName, newLevel, balance)
	logEconomy(player, Sink,
		Config.getUpgradeCost(upgradeName, newLevel),
		balance, "UpgradePurchase", upgradeName .. "_L" .. newLevel)
	logOnboarding(player, 3, "first_upgrade_purchased", { upgrade = upgradeName })
end

-- PurchaseHandler: called after species unlock (shop) succeeds.
function AnalyticsManager.onSpeciesUnlock(player, speciesId, tier, cost, balance)
	logEconomy(player, Sink, cost, balance, "SpeciesUnlock", speciesId)
	logOnboarding(player, 2, "first_species_unlocked", {
		species_id   = speciesId,
		species_tier = tier,
	})
end

-- MerchantManager: called after merchant purchase succeeds.
-- cost = stockItem.cost (already discounted by MerchantManager.pickStock).
function AnalyticsManager.onMerchantPurchase(player, speciesId, tier, cost, balance)
	logEconomy(player, Sink, cost, balance, "MerchantPurchase", speciesId)
end

-- PurchaseHandler: called after prestige (Sporulate) completes.
-- prevLifetimeSpores must be captured before data.lifetimeSpores is zeroed.
function AnalyticsManager.onPrestige(player, newLevel, prevLifetimeSpores, vaultSize)
	logCustom(player, "prestige", newLevel, {
		prestige_level           = newLevel,
		lifetime_spores_at_reset = prevLifetimeSpores,
		vault_species            = vaultSize,
	})
	logProgression(player, newLevel)
	logOnboarding(player, 5, "first_prestige")
end

-- LoginStreakManager: called after streak reward is granted.
function AnalyticsManager.onStreakClaimed(player, streakDay, rewardLabel, rewardSpores, balance)
	if rewardSpores > 0 then
		logEconomy(player, Source, rewardSpores, balance,
			"LoginStreakReward", "streak_day_" .. streakDay)
	end
	logCustom(player, "streak_reward_claimed", streakDay, {
		reward_day   = streakDay,
		reward_label = rewardLabel,
	})
end

-- DailyQuestManager: called after quest reward is granted.
function AnalyticsManager.onQuestClaimed(player, questId, questType, reward, balance)
	logEconomy(player, Source, reward, balance, "DailyQuestReward", questId)
	logCustom(player, "quest_reward_claimed", reward, {
		quest_id   = questId,
		quest_type = questType,
	})
end

-- SporeLoop: called for each online player when a cave event starts.
function AnalyticsManager.onCaveEvent(player, eventName)
	logCustom(player, "cave_event_start", 1, {
		event_name = eventName,
	})
end

return AnalyticsManager
