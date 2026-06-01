-- Cookbook collection meta.
-- Records every food eaten across contests and grants a permanent +1% coin
-- bonus per completed tier (5 of 5 foods). Caps at +4% with all 4 tiers full.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common      = ReplicatedStorage:WaitForChild("Common")
local Constants   = require(Common:WaitForChild("Constants"))
local Utils       = require(Common:WaitForChild("Utils"))
local DataManager = require(script.Parent.DataManager)

local CookbookService = {}

local remotes: { [string]: RemoteEvent } = {}

-- foodName -> tierIdx, built once from Constants.TIER_FOODS
local foodToTier: { [string]: number } = {}
for tierIdx, foods in Constants.TIER_FOODS do
	for _, food in foods do
		foodToTier[food] = tierIdx
	end
end

-- Each completed tier (5/5 foods) adds +1% to coin payouts. Recomputed from
-- scratch every unlock so the bonus stays consistent with current state — no
-- drift from incremental adds.
local function recomputeBonus(data: any)
	local bonus = 0
	for _, foods in Constants.TIER_FOODS do
		local complete = true
		for _, food in foods do
			if not (data.cookbook and data.cookbook[food]) then
				complete = false
				break
			end
		end
		if complete then
			bonus = bonus + 0.01
		end
	end
	data.cookbookCoinBonus = bonus
end

local function pushUpdate(player: Player)
	local data = DataManager.get(player)
	if not data then return end
	if not remotes.CookbookUpdate then return end
	remotes.CookbookUpdate:FireClient(player, data.cookbook or {}, data.cookbookCoinBonus or 0)
end

function CookbookService.recordContestFood(player: Player, foodName: string)
	if not player or not foodName then return end
	if not foodToTier[foodName] then return end  -- ignore unknown foods

	local data = DataManager.get(player)
	if not data then return end
	if not data.cookbook then data.cookbook = {} end

	local entry = data.cookbook[foodName]
	if entry then
		entry.timesEaten = (entry.timesEaten or 0) + 1
	else
		data.cookbook[foodName] = {
			firstEatenDate = Utils.todayString(),
			timesEaten     = 1,
		}
		recomputeBonus(data)
	end

	DataManager.markDirty(player)
	pushUpdate(player)
end

function CookbookService.getCoinBonus(player: Player): number
	local data = DataManager.get(player)
	if not data then return 0 end
	return data.cookbookCoinBonus or 0
end

local function waitForDataThenPush(player: Player)
	task.spawn(function()
		local tries = 0
		while not DataManager.get(player) and tries < 50 do
			task.wait(0.2)
			tries += 1
		end
		pushUpdate(player)
	end)
end

function CookbookService.init(remotesFolder: Folder)
	remotes.CookbookUpdate = remotesFolder:WaitForChild("CookbookUpdate") :: RemoteEvent

	Players.PlayerAdded:Connect(waitForDataThenPush)
	for _, player in Players:GetPlayers() do
		waitForDataThenPush(player)
	end
end

return CookbookService
