-- PetFollower.client.luau
-- Spawns simple glowing sphere parts that lerp toward the local player
-- for each active pet. Responds to PetState remote syncs.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Remotes     = ReplicatedStorage:WaitForChild("Remotes")
local PetState    = Remotes:WaitForChild("PetState")

local PET_COLORS = {
	mole     = { part = Color3.fromRGB(110, 80,  55),  light = Color3.fromRGB(160, 120, 80)  },
	cricket  = { part = Color3.fromRGB(55,  120, 55),  light = Color3.fromRGB(90,  190, 90)  },
	bat      = { part = Color3.fromRGB(90,  45,  130), light = Color3.fromRGB(150, 90,  210) },
	glowworm = { part = Color3.fromRGB(55,  190, 210), light = Color3.fromRGB(80,  210, 255) },
	axolotl  = { part = Color3.fromRGB(220, 130, 180), light = Color3.fromRGB(255, 160, 210) },
}

-- Offsets from character HRP (slot 1 = left, slot 2 = right)
local PET_OFFSETS = {
	Vector3.new(-2.8, -1.2, -2),
	Vector3.new( 2.8, -1.2, -2),
}

local petParts = {}  -- list of {part}

local function clearPets()
	for _, entry in ipairs(petParts) do
		if entry.part and entry.part.Parent then
			entry.part:Destroy()
		end
	end
	petParts = {}
end

local function spawnPetPart(species: string, slotIndex: number)
	local colors = PET_COLORS[species] or PET_COLORS.mole

	local part = Instance.new("Part")
	part.Name       = "PetFollower_" .. species
	part.Shape      = Enum.PartType.Ball
	part.Size       = Vector3.new(1.4, 1.4, 1.4)
	part.Anchored   = true
	part.CanCollide = false
	part.CastShadow = false
	part.Material   = Enum.Material.SmoothPlastic
	part.Color      = colors.part

	local light = Instance.new("PointLight")
	light.Brightness = 0.7
	light.Range      = 7
	light.Color      = colors.light
	light.Parent     = part

	-- Start at a reasonable position to avoid a pop-in from origin
	local char = LocalPlayer.Character
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if hrp then
		part.Position = hrp.Position + (PET_OFFSETS[slotIndex] or PET_OFFSETS[1])
	end

	part.Parent = workspace
	table.insert(petParts, { part = part, slot = slotIndex })
end

-- PetState sends { owned = [{id, species, variant, hp}...], active = [petId...] }
PetState.OnClientEvent:Connect(function(petData)
	clearPets()
	if not petData then return end

	local ownedMap = {}
	for _, pet in ipairs(petData.owned or {}) do
		ownedMap[pet.id] = pet
	end

	for i, petId in ipairs(petData.active or {}) do
		local pet = ownedMap[petId]
		if pet then
			spawnPetPart(pet.species or "mole", i)
		end
	end
end)

-- Destroy pet parts when character dies/resets
LocalPlayer.CharacterRemoving:Connect(clearPets)

-- Lerp pet spheres toward character each frame
RunService.Heartbeat:Connect(function()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	for _, entry in ipairs(petParts) do
		if entry.part and entry.part.Parent then
			local offset = PET_OFFSETS[entry.slot] or PET_OFFSETS[1]
			local target = hrp.CFrame:PointToWorldSpace(offset)
			entry.part.Position = entry.part.Position:Lerp(target, 0.12)
		end
	end
end)
