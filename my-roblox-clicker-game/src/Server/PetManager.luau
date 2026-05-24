-- PetManager.luau
-- Manages pet ownership and active pets.
-- Pets are decorative companions with passive buffs (future expansion).

local DataManager = require(script.Parent.DataManager)

local PetManager = {}

local function generatePetId(): string
	return "pet_" .. os.time() .. "_" .. math.random(1000, 9999)
end

-- Adds a new pet to the player's owned list. Returns the new pet id.
function PetManager.addPet(player: Player, species: string, variant: string?): string
	local data = DataManager.get(player)
	if not data then return "" end

	data.pets = data.pets or { owned = {}, active = {} }
	data.pets.owned = data.pets.owned or {}

	local petId = generatePetId()
	table.insert(data.pets.owned, {
		id       = petId,
		species  = species,
		variant  = variant or "common",
		caughtAt = os.time(),
	})

	DataManager.save(player)
	return petId
end

-- Sets active pets for a player (max 2).
-- petIds is a list of pet id strings the player wants active.
function PetManager.setActive(player: Player, petIds: { string })
	local data = DataManager.get(player)
	if not data then return end

	data.pets        = data.pets or { owned = {}, active = {} }
	data.pets.active = data.pets.active or {}

	-- Build set of owned ids for fast validation
	local ownedIds = {}
	for _, pet in ipairs(data.pets.owned or {}) do
		ownedIds[pet.id] = true
	end

	-- Validate and cap at 2
	local validated = {}
	local seen      = {}
	for _, id in ipairs(petIds) do
		if type(id) == "string" and ownedIds[id] and not seen[id] and #validated < 2 then
			table.insert(validated, id)
			seen[id] = true
		end
	end

	data.pets.active = validated
	DataManager.save(player)
end

-- Returns the player's full pets data table.
function PetManager.getOwned(player: Player): table
	local data = DataManager.get(player)
	if not data then return {} end
	return data.pets or { owned = {}, active = {} }
end

return PetManager
