-- DailyQuestManager.luau
-- Generates 3 deterministic daily quests per UTC day, tracks progress,
-- and validates reward claims.
--
-- Quest types currently tracked:
--   collectOrbs   → progress incremented by OrbCollected event
--   mutation      → progress incremented by MutationOccurred event
--   unlockSpecies → progress incremented by UnlockSpecies event
--   prestige      → progress incremented by Sporulate event

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config           = require(ReplicatedStorage.Common.Config)
local DataManager      = require(script.Parent.DataManager)
local AnalyticsManager = require(script.Parent.AnalyticsManager)

local DailyQuestManager = {}

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function utcDay(): number
	return math.floor(os.time() / 86400)
end

-- Deterministic quest selection: same seed + same day = same quests for everyone.
-- Returns a list of quest definitions (tables from Config.DAILY_QUEST_POOL).
local function generateQuests(seed: number): { table }
	local pool  = Config.DAILY_QUEST_POOL
	local count = Config.DAILY_QUEST_COUNT
	local rng   = Random.new(seed + utcDay())

	-- Shuffle a copy of the pool using the seeded RNG
	local shuffled = table.clone(pool)
	for i = #shuffled, 2, -1 do
		local j = rng:NextInteger(1, i)
		shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
	end

	local result = {}
	for i = 1, math.min(count, #shuffled) do
		table.insert(result, shuffled[i])
	end
	return result
end

-- Ensure player's quest data is fresh for today (reset at UTC midnight).
local function reconcileQuests(data: table)
	local today = utcDay()
	if data.lastDailyQuestReset == today then return end  -- already up to date

	-- Generate a stable seed for this player if they don't have one
	if data.dailyQuestSeed == 0 then
		data.dailyQuestSeed = math.random(1, 2^30)
	end

	data.dailyQuestsCompleted = {}
	data.lastDailyQuestReset  = today
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

--- Returns {quests, completed} for the player's current day.
--- quests     = list of quest definition tables
--- completed  = { [questId] = progress }
function DailyQuestManager.getForPlayer(player: Player)
	local data = DataManager.get(player)
	if not data then return nil end

	reconcileQuests(data)
	local quests = generateQuests(data.dailyQuestSeed)

	return {
		quests    = quests,
		completed = data.dailyQuestsCompleted,
	}
end

--- Sends quest data to a single player via the DailyQuestData remote.
function DailyQuestManager.sendToPlayer(player: Player, DailyQuestData: RemoteEvent)
	local payload = DailyQuestManager.getForPlayer(player)
	if payload then
		DailyQuestData:FireClient(player, payload)
	end
end

--- Records progress for a quest type. Called by event handlers in DailyQuestLoop.
--- questType: "collectOrbs" | "mutation" | "unlockSpecies" | "prestige"
--- amount: how much to increment (usually 1, or actual spore count for orbs)
function DailyQuestManager.recordProgress(player: Player, questType: string, amount: number,
	QuestProgress: RemoteEvent, DailyQuestData: RemoteEvent)

	local data = DataManager.get(player)
	if not data then return end

	reconcileQuests(data)
	local quests = generateQuests(data.dailyQuestSeed)

	local changed = false
	for _, quest in ipairs(quests) do
		if quest.type ~= questType then continue end
		local current = data.dailyQuestsCompleted[quest.id] or 0
		if current >= quest.amount then continue end  -- already complete

		local newCount = math.min(current + amount, quest.amount)
		data.dailyQuestsCompleted[quest.id] = newCount
		changed = true

		-- Notify client of incremental progress
		QuestProgress:FireClient(player, {
			questId  = quest.id,
			progress = newCount,
			goal     = quest.amount,
		})
	end

	if changed then
		DataManager.save(player)
	end
end

--- Validates and grants a completed quest reward.
function DailyQuestManager.claimReward(player: Player, questId: unknown,
	SyncData: RemoteEvent, DailyQuestData: RemoteEvent)

	if type(questId) ~= "string" then return end

	local data = DataManager.get(player)
	if not data then return end

	reconcileQuests(data)
	local quests = generateQuests(data.dailyQuestSeed)

	-- Find the quest
	local quest = nil
	for _, q in ipairs(quests) do
		if q.id == questId then quest = q; break end
	end
	if not quest then return end

	-- Check it's complete but not yet claimed
	-- We use a "claimed" key: questId .. "_claimed"
	local claimKey = questId .. "_claimed"
	if data.dailyQuestsCompleted[claimKey] then return end  -- already claimed

	local progress = data.dailyQuestsCompleted[quest.id] or 0
	if progress < quest.amount then return end  -- not complete yet

	-- Grant reward
	data.spores        += quest.reward
	data.lifetimeSpores += quest.reward
	data.dailyQuestsCompleted[claimKey] = true

	DataManager.save(player)
	SyncData:FireClient(player, data)
	DailyQuestManager.sendToPlayer(player, DailyQuestData)
	AnalyticsManager.onQuestClaimed(player, quest.id, quest.type, quest.reward, data.spores)
end

return DailyQuestManager
