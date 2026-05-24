-- MoleFishing.server.luau
-- ProximityPrompt (E) at each MoleHole → random bite timer → FishingBite fires →
-- client reel mini-game → FishingResult arrives → loot granted server-side.
-- One player per hole at a time. Underground Spring halves the bite timer.
-- All validation and loot happen server-side; client result must arrive within 15s.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config         = require(game.ReplicatedStorage.Common.Config)
local DataManager    = require(script.Parent.DataManager)
local WeatherState   = require(script.Parent.WeatherState)
local PetManager     = require(script.Parent.PetManager)
local JournalManager = require(script.Parent.JournalManager)

local Remotes       = ReplicatedStorage:WaitForChild("Remotes")
local FishingBite   = Remotes:WaitForChild("FishingBite")
local FishingResult = Remotes:WaitForChild("FishingResult")
local UpdateSpores  = Remotes:WaitForChild("UpdateSpores")
local LootGranted   = Remotes:WaitForChild("LootGranted")

local BITE_MIN            = 3    -- seconds min before a bite
local BITE_MAX            = 8    -- seconds max before a bite
local RESULT_TIMEOUT      = 15   -- seconds server waits for FishingResult after FishingBite
local SPORE_MIN           = 500
local SPORE_MAX           = 2000
local FRAGMENTS_TO_UNLOCK = 10   -- fragments of one species needed to auto-unlock it

-- ─── STATE ───────────────────────────────────────────────────────────────────

local holeLocks    = {}   -- [hole BasePart] = true while in use
local pendingFishers = {}  -- [userId] = { hole, biteAt, depth }

-- ─── LOOT HELPERS ────────────────────────────────────────────────────────────

local function getUnownedSpecies(data: table): { string }
	local unowned  = {}
	local ownedSet = {}
	for _, id in ipairs(data.ownedSpecies) do ownedSet[id] = true end
	for _, sp in ipairs(Config.SPECIES) do
		if not ownedSet[sp.id] then
			table.insert(unowned, sp.id)
		end
	end
	return unowned
end

local function getLockedEpicMythic(data: table): { string }
	local locked   = {}
	local ownedSet = {}
	for _, id in ipairs(data.ownedSpecies) do ownedSet[id] = true end
	for _, sp in ipairs(Config.SPECIES) do
		if (sp.tier == "Epic" or sp.tier == "Mythic") and not ownedSet[sp.id] then
			table.insert(locked, sp.id)
		end
	end
	return locked
end

local function grantFragment(player: Player, data: table, speciesId: string)
	data.fragments = data.fragments or {}
	data.fragments[speciesId] = (data.fragments[speciesId] or 0) + 1
	local count = data.fragments[speciesId]

	if count >= FRAGMENTS_TO_UNLOCK then
		local alreadyOwned = false
		for _, id in ipairs(data.ownedSpecies) do
			if id == speciesId then alreadyOwned = true; break end
		end
		if not alreadyOwned then
			table.insert(data.ownedSpecies, speciesId)
			data.fragments[speciesId] = nil
			count = FRAGMENTS_TO_UNLOCK
				-- Journal discovery on auto-unlock
				JournalManager.discover(player, speciesId)
		end
	end

	DataManager.save(player)
	LootGranted:FireClient(player, {
		type      = "fragment",
		speciesId = speciesId,
		count     = count,
		needed    = FRAGMENTS_TO_UNLOCK,
	})
end

local function rollLoot(player: Player, data: table, depth: number)
	if depth == 1 then
		local amount = math.random(SPORE_MIN, SPORE_MAX)
		data.spores         += amount
		data.lifetimeSpores += amount
		DataManager.save(player)
		UpdateSpores:FireClient(player, data.spores, data.lifetimeSpores, 0)
		LootGranted:FireClient(player, { type = "spores", amount = amount })

	elseif depth == 2 then
		local unowned = getUnownedSpecies(data)
		if #unowned == 0 then
			local amount = math.random(SPORE_MIN * 4, SPORE_MAX * 4)
			data.spores         += amount
			data.lifetimeSpores += amount
			DataManager.save(player)
			UpdateSpores:FireClient(player, data.spores, data.lifetimeSpores, 0)
			LootGranted:FireClient(player, { type = "spores", amount = amount })
		else
			grantFragment(player, data, unowned[math.random(1, #unowned)])
		end

	elseif depth == 3 then
		-- Mole pet catch chance (checked before regular loot)
		if math.random() < Config.MOLE_CATCH_CHANCE then
			local petId = PetManager.addPet(player, "mole", "common")
			local PetCaught = Remotes:FindFirstChild("PetCaught")
			local PetState  = Remotes:FindFirstChild("PetState")
			if PetCaught then LootGranted:FireClient(player, { type = "pet", species = "mole", petId = petId }) end
			if PetState   then PetState:FireClient(player, PetManager.getOwned(player)) end
			return
		end
		if math.random() < 0.70 then
			data.catalysts = (data.catalysts or 0) + 1
			DataManager.save(player)
			LootGranted:FireClient(player, { type = "catalyst", count = data.catalysts })
		else
			local locked = getLockedEpicMythic(data)
			if #locked == 0 then
				data.catalysts = (data.catalysts or 0) + 1
				DataManager.save(player)
				LootGranted:FireClient(player, { type = "catalyst", count = data.catalysts })
			else
				grantFragment(player, data, locked[math.random(1, #locked)])
			end
		end
	end
end

-- ─── RESULT HANDLER ──────────────────────────────────────────────────────────

FishingResult.OnServerEvent:Connect(function(player, passed)
	if type(passed) ~= "boolean" then return end  -- reject non-boolean; exploit guard

	local pending = pendingFishers[player.UserId]
	if not pending then return end

	local elapsed = os.time() - pending.biteAt
	if elapsed > RESULT_TIMEOUT then
		holeLocks[pending.hole]       = nil
		pendingFishers[player.UserId] = nil
		return
	end

	-- Must spend at least 2s in the green zone before a win is possible
	if passed and elapsed < 2 then
		holeLocks[pending.hole]       = nil
		pendingFishers[player.UserId] = nil
		return
	end

	if passed then
		local data = DataManager.get(player)
		if data then rollLoot(player, data, pending.depth) end
	end

	holeLocks[pending.hole]       = nil
	pendingFishers[player.UserId] = nil
end)

Players.PlayerRemoving:Connect(function(player)
	local pending = pendingFishers[player.UserId]
	if pending then
		holeLocks[pending.hole]       = nil
		pendingFishers[player.UserId] = nil
	end
end)

-- ─── HOLE SETUP ──────────────────────────────────────────────────────────────

local function setupHole(hole: BasePart)
	local prompt = hole:FindFirstChildWhichIsA("ProximityPrompt")
	if not prompt then return end

	local depth = hole:GetAttribute("HoleDepth") or 1

	prompt.Triggered:Connect(function(player)
		if holeLocks[hole] then return end
		if pendingFishers[player.UserId] then return end

		holeLocks[hole] = true

		local biteTime = math.random(BITE_MIN, BITE_MAX)
		if WeatherState.currentEvent == "Underground Spring" then
			biteTime = math.max(1, math.floor(biteTime / 2))
		end

		task.wait(biteTime)

		if player.Parent == nil then
			holeLocks[hole] = nil
			return
		end

		local biteAt = os.time()
		pendingFishers[player.UserId] = { hole = hole, biteAt = biteAt, depth = depth }
		FishingBite:FireClient(player, biteAt, depth)

		-- Auto-cleanup if client never responds
		task.delay(RESULT_TIMEOUT, function()
			local p = pendingFishers[player.UserId]
			if p and p.biteAt == biteAt then
				holeLocks[hole]               = nil
				pendingFishers[player.UserId] = nil
			end
		end)
	end)
end

-- ─── FIND MOLE HOLES ON STARTUP ──────────────────────────────────────────────

task.spawn(function()
	task.wait(4)
	local found = 0
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name:match("^MoleHole_") then
			setupHole(obj)
			found += 1
		end
	end
	if found == 0 then
		warn("[MoleFishing] No MoleHole_ parts found — check Phase 1 world setup")
	end
end)

-- Wire mole holes added after startup (supports dynamically cloned cave instances)
workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("BasePart") and obj.Name:match("^MoleHole_") then
		setupHole(obj)
	end
end)
