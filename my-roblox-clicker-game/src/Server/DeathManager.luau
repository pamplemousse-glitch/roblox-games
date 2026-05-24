-- DeathManager.luau
-- Handles player death: teleport to Hub, apply Spore Debt, fire PetsRetreat.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config      = require(game.ReplicatedStorage.Common.Config)
local DataManager = require(script.Parent.DataManager)

local DeathManager = {}

local HUB_SPAWN = Vector3.new(0, 4, 408)

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

-- Called when a player dies. Teleports to Hub, adds spore debt, notifies client.
function DeathManager.onPlayerDied(player: Player)
	local data = DataManager.get(player)
	if not data then return end

	-- Add spore debt stacks (capped at max)
	data.sporeDebt = math.min(
		(data.sporeDebt or 0) + Config.SPORE_DEBT_STACKS,
		Config.SPORE_DEBT_MAX_STACKS
	)

	-- Reset HP
	data.playerHP    = Config.PLAYER_MAX_HP
	data.maxPlayerHP = Config.PLAYER_MAX_HP

	DataManager.save(player)

	-- Teleport to Hub
	local char = player.Character
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = CFrame.new(HUB_SPAWN)
		end
	end

	-- Notify client to hide active pet models
	local Remotes      = ReplicatedStorage:FindFirstChild("Remotes")
	local PetsRetreat  = Remotes and Remotes:FindFirstChild("PetsRetreat")
	local HPUpdate     = Remotes and Remotes:FindFirstChild("HPUpdate")

	if PetsRetreat then PetsRetreat:FireClient(player) end
	if HPUpdate    then HPUpdate:FireClient(player, data.playerHP, data.maxPlayerHP) end
end

-- Applies spore debt reduction to earned spores. Decrements debt.
-- Returns the (possibly reduced) earned value.
function DeathManager.applyDebtPenalty(player: Player, earned: number): number
	local data = DataManager.get(player)
	if not data or (data.sporeDebt or 0) <= 0 then return earned end

	local reduced       = math.floor(earned * (1 - Config.SPORE_DEBT_PENALTY))
	data.sporeDebt      = math.max(0, (data.sporeDebt or 0) - 1)
	return reduced
end

return DeathManager
