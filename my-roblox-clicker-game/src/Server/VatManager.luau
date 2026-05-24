-- VatManager.luau
-- Manages the Mycology Vat: brewing potions and potion effects.
-- Potion effects stored in activePotions table (module-level, not persisted across server restarts).

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config      = require(game.ReplicatedStorage.Common.Config)
local DataManager = require(script.Parent.DataManager)

local VatManager = {}

-- ─── STATE ────────────────────────────────────────────────────────────────────

-- [player] = { potionId, effect, expiresAt }
local activePotions: { [Player]: table } = {}

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function getRecipe(recipeId: string): table?
	for _, r in ipairs(Config.VAT_RECIPES) do
		if r.id == recipeId then return r end
	end
	return nil
end

local function fireVatState(player: Player)
	local Remotes   = ReplicatedStorage:FindFirstChild("Remotes")
	local VatState  = Remotes and Remotes:FindFirstChild("VatState")
	if not VatState then return end

	local data = DataManager.get(player)
	if not data then return end

	VatState:FireClient(player, {
		ingredients = data.ingredients or {},
		brews       = data.brews       or {},
	})
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

-- Returns true if the player has all required ingredients for the recipe.
function VatManager.canBrew(player: Player, recipeId: string): boolean
	local recipe = getRecipe(recipeId)
	if not recipe then return false end

	local data = DataManager.get(player)
	if not data then return false end

	local ingredients = data.ingredients or {}
	for ingredientId, needed in pairs(recipe.ingredients) do
		if (ingredients[ingredientId] or 0) < needed then return false end
	end
	return true
end

-- Brews a recipe. Consumes ingredients, adds potion to data.brews.
-- Returns true on success.
function VatManager.brew(player: Player, recipeId: string): boolean
	if not VatManager.canBrew(player, recipeId) then return false end

	local recipe = getRecipe(recipeId)
	if not recipe then return false end

	local data = DataManager.get(player)
	if not data then return false end

	-- Consume ingredients
	data.ingredients = data.ingredients or {}
	for ingredientId, needed in pairs(recipe.ingredients) do
		data.ingredients[ingredientId] = (data.ingredients[ingredientId] or 0) - needed
	end

	-- Add potion
	data.brews = data.brews or {}
	data.brews[recipe.output] = (data.brews[recipe.output] or 0) + recipe.outputCount

	DataManager.save(player)
	fireVatState(player)

	-- Notify client of brew
	local Remotes    = ReplicatedStorage:FindFirstChild("Remotes")
	local VatBrewed  = Remotes and Remotes:FindFirstChild("VatState")
	-- VatState fires above, which includes the brews update

	return true
end

-- Applies a potion effect for the player.
function VatManager.usePotion(player: Player, potionId: string): boolean
	local effect = Config.POTION_EFFECTS[potionId]
	if not effect then return false end

	local data = DataManager.get(player)
	if not data then return false end

	data.brews = data.brews or {}
	if (data.brews[potionId] or 0) <= 0 then return false end

	-- Consume potion
	data.brews[potionId] -= 1
	DataManager.save(player)

	-- Apply effect
	local expiresAt = os.time() + (effect.duration or 60)
	activePotions[player] = { potionId = potionId, effect = effect, expiresAt = expiresAt }

	fireVatState(player)
	return true
end

-- Returns the production multiplier from active vat potion (spore_surge).
function VatManager.getProductionMult(player: Player): number
	local entry = activePotions[player]
	if not entry then return 1 end
	if os.time() > entry.expiresAt then
		activePotions[player] = nil
		return 1
	end
	if entry.effect and entry.effect.type == "productionMult" then
		return entry.effect.value or 1
	end
	return 1
end

-- Sends VatState to a player on join.
function VatManager.syncPlayer(player: Player)
	fireVatState(player)
end

return VatManager
