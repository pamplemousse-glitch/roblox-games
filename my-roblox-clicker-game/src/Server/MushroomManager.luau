local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotManager = require(script.Parent.PlotManager)
local AuraSystem  = require(script.Parent.AuraSystem)
local Config      = require(game.ReplicatedStorage.Common.Config)

local MushroomManager = {}

local MODELS_FOLDER = ReplicatedStorage:WaitForChild("MushroomModels", 10)

local TIER_GLOW = {
	Common   = Color3.fromRGB(255, 250, 200),
	Uncommon = Color3.fromRGB(100, 255, 150),
	Rare     = Color3.fromRGB(100, 150, 255),
	Epic     = Color3.fromRGB(200, 100, 255),
	Mythic   = Color3.fromRGB(255, 215, 50),
}

-- ─── VISUALS ─────────────────────────────────────────────────────────────────

local function applyVisuals(model: Model, species: table, mutCount: number)
	local cap  = model:FindFirstChild("Cap")
	local glow = model:FindFirstChild("GlowLight", true) -- recursive: GlowLight lives inside Cap
	if not (cap and glow) then return end

	local color = TIER_GLOW[species.tier] or Color3.new(1, 1, 1)

	if mutCount >= 1 then
		glow.Brightness = 1 + mutCount
		glow.Range      = 8 + mutCount * 6
		glow.Color      = color
		cap.Color       = color
	end

	if mutCount >= 2 then
		if not cap:FindFirstChildOfClass("ParticleEmitter") then
			local pe = Instance.new("ParticleEmitter")
			pe.Color       = ColorSequence.new(color)
			pe.Size        = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.2),
				NumberSequenceKeypoint.new(1, 0),
			})
			pe.Lifetime    = NumberRange.new(1, 2.5)
			pe.Rate        = mutCount >= 3 and 15 or 5
			pe.SpreadAngle = Vector2.new(25, 25)
			pe.Parent      = cap
		end
	end

	if mutCount >= 3 then
		if not cap:GetAttribute("Scaled") then
			cap.Size = cap.Size * 1.4
			cap:SetAttribute("Scaled", true)
		end
		if not model:FindFirstChild("AuraLight") then
			local a = Instance.new("PointLight")
			a.Name       = "AuraLight"
			a.Brightness = 2
			a.Range      = 35
			a.Color      = color
			a.Parent     = cap
		end
	end
end

-- ─── ROOT SPREAD (floor-level mycelium tendrils) ─────────────────────────────

local TENDRIL_COUNT = 7

local function clearTendrils(rootSpot: BasePart)
	for _, child in ipairs(rootSpot:GetChildren()) do
		if child.Name == "RootTendril" then child:Destroy() end
	end
end

local function spawnTendrils(rootSpot: BasePart, color: Color3)
	clearTendrils(rootSpot)
	local floorY    = rootSpot.Position.Y - rootSpot.Size.Y / 2
	local spreadY   = floorY + 0.05
	local rx, rz    = rootSpot.Position.X, rootSpot.Position.Z
	local glowColor = Color3.new(color.R * 0.45, color.G * 0.45, color.B * 0.45)

	for i = 1, TENDRIL_COUNT do
		local baseAngle = (i - 1) * (math.pi * 2 / TENDRIL_COUNT)
		local angle  = baseAngle + (math.random() - 0.5) * 0.9
		local length = 1.5 + math.random() * 3.0   -- 1.5–4.5 studs
		local width  = 0.12 + math.random() * 0.38  -- 0.12–0.5 studs
		local dx, dz = math.cos(angle), math.sin(angle)

		local cx = rx + dx * length / 2
		local cz = rz + dz * length / 2

		local t = Instance.new("Part")
		t.Name        = "RootTendril"
		t.Size        = Vector3.new(width, 0.08, length)
		t.Anchored    = true
		t.CanCollide  = false
		t.CastShadow  = false
		t.Material    = Enum.Material.Neon
		t.Color       = glowColor
		t.CFrame      = CFrame.lookAt(
			Vector3.new(cx, spreadY, cz),
			Vector3.new(rx + dx * length, spreadY, rz + dz * length)
		)
		t.Parent = rootSpot
	end
end

local function setRootGlow(rootSpot: BasePart, color: Color3?)
	rootSpot.Transparency = 1        -- hide the pedestal completely
	rootSpot.CanCollide   = false
	local glow = rootSpot:FindFirstChild("RootGlow")
	if color then
		spawnTendrils(rootSpot, color)
		if glow and glow:IsA("PointLight") then
			glow.Color = color; glow.Enabled = true
		end
	else
		clearTendrils(rootSpot)
		if glow and glow:IsA("PointLight") then glow.Enabled = false end
	end
end

-- ─── ROOT SPOT OCCUPANCY ─────────────────────────────────────────────────────

local function occupiedRootSpots(plot: Folder): { [string]: boolean }
	local taken = {}
	for _, child in ipairs(plot:GetChildren()) do
		if child:IsA("Model") then
			local pname = child:GetAttribute("RootSpotName")
			if pname then taken[pname] = true end
		end
	end
	return taken
end

local function findFreeRootSpot(plot: Folder): BasePart?
	local taken = occupiedRootSpots(plot)
	for _, spot in ipairs(PlotManager.getRootSpots(plot)) do
		if not taken[spot.Name] then return spot end
	end
	return nil
end

-- ─── SPAWN / DESPAWN ─────────────────────────────────────────────────────────

local function spawnOne(plot: Folder, speciesId: string, mutCount: number): Model?
	if not MODELS_FOLDER then return nil end
	local template = MODELS_FOLDER:FindFirstChild(speciesId)
	if not template then return nil end -- model not created in Studio yet

	local rootSpot = findFreeRootSpot(plot)
	if not rootSpot then return nil end  -- no free slots

	local model = template:Clone()
	model:SetAttribute("SpeciesId",    speciesId)
	model:SetAttribute("RootSpotName", rootSpot.Name)

	local root = model.PrimaryPart or model:FindFirstChild("Root")
	if root then
		-- Grow from floor surface, not top of pedestal
		local floorY = rootSpot.Position.Y - rootSpot.Size.Y / 2
		local topY   = floorY + root.Size.Y / 2
		model:SetPrimaryPartCFrame(CFrame.new(rootSpot.Position.X, topY, rootSpot.Position.Z))
	end
	-- Anchor every part so physics doesn't send the model flying
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = true
		end
	end
	model.Parent = plot

	local species = Config.SPECIES_BY_ID[speciesId]
	if species then
		applyVisuals(model, species, mutCount)
		setRootGlow(rootSpot, TIER_GLOW[species.tier])
	end

	return model
end

function MushroomManager.spawnAll(player: Player, data: table)
	local plot = PlotManager.getPlot(player)
	if not plot then return end

	-- Hide all root spots upfront so empty slots are invisible
	for _, spot in ipairs(PlotManager.getRootSpots(plot)) do
		setRootGlow(spot, nil)
	end

	-- Sort owned species rarest-first so they claim the best spots
	local sorted = {}
	local TIER_RANK = { Common=1, Uncommon=2, Rare=3, Epic=4, Mythic=5 }
	for _, id in ipairs(data.ownedSpecies) do
		local sp = Config.SPECIES_BY_ID[id]
		table.insert(sorted, { id = id, rank = sp and (TIER_RANK[sp.tier] or 0) or 0 })
	end
	table.sort(sorted, function(a, b) return a.rank > b.rank end)

	for _, entry in ipairs(sorted) do
		spawnOne(plot, entry.id, data.mutations[entry.id] or 0)
	end

	AuraSystem.update(player, data)
end

function MushroomManager.spawnOne(player: Player, speciesId: string, mutCount: number)
	local plot = PlotManager.getPlot(player)
	if not plot then return end
	spawnOne(plot, speciesId, mutCount)
end

function MushroomManager.despawnAll(plot: Folder)
	for _, child in ipairs(plot:GetChildren()) do
		if child:IsA("Model") and child:GetAttribute("SpeciesId") then
			child:Destroy()
		end
	end
	for _, spot in ipairs(PlotManager.getRootSpots(plot)) do
		setRootGlow(spot, nil)
	end
end

-- Move a single model to sit at floor level of a root spot
local function placeOnRootSpot(model: Model, rootSpot: BasePart)
	local root = model.PrimaryPart or model:FindFirstChild("Root")
	if not root then return end
	local floorY = rootSpot.Position.Y - rootSpot.Size.Y / 2
	local topY   = floorY + root.Size.Y / 2
	model:SetPrimaryPartCFrame(CFrame.new(rootSpot.Position.X, topY, rootSpot.Position.Z))
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then part.Anchored = true end
	end
end

-- Swap the root spot a mushroom sits on (or swap two mushrooms)
-- targetRootSpotName is the RootSpot_N name of the destination
function MushroomManager.swapMushroom(player: Player, speciesIdA: string, targetRootSpotName: string)
	if type(speciesIdA) ~= "string" or type(targetRootSpotName) ~= "string" then return end

	local plot = PlotManager.getPlot(player)
	if not plot then return end

	local spotB = plot:FindFirstChild(targetRootSpotName)
	if not spotB or not spotB:IsA("BasePart") then return end

	local modelA: Model? = nil
	local modelB: Model? = nil  -- whatever is already on the target spot

	for _, child in ipairs(plot:GetChildren()) do
		if child:IsA("Model") then
			local sid = child:GetAttribute("SpeciesId")
			if sid == speciesIdA then
				modelA = child
			elseif child:GetAttribute("RootSpotName") == targetRootSpotName then
				modelB = child
			end
		end
	end

	if not modelA then return end

	local currentNameA = modelA:GetAttribute("RootSpotName")
	if currentNameA == targetRootSpotName then return end  -- already there

	local spotA = plot:FindFirstChild(currentNameA)
	if not spotA or not spotA:IsA("BasePart") then return end

	modelA:SetAttribute("RootSpotName", targetRootSpotName)
	placeOnRootSpot(modelA, spotB)

	local speciesA = Config.SPECIES_BY_ID[speciesIdA]
	setRootGlow(spotB, speciesA and TIER_GLOW[speciesA.tier])

	if modelB then
		modelB:SetAttribute("RootSpotName", currentNameA)
		placeOnRootSpot(modelB, spotA)
		local sidB    = modelB:GetAttribute("SpeciesId")
		local speciesB = sidB and Config.SPECIES_BY_ID[sidB]
		setRootGlow(spotA, speciesB and TIER_GLOW[speciesB.tier])
	else
		setRootGlow(spotA, nil)  -- spotA is now empty
	end
end

function MushroomManager.updateVisuals(player: Player, speciesId: string, mutCount: number)
	local plot = PlotManager.getPlot(player)
	if not plot then return end

	for _, child in ipairs(plot:GetChildren()) do
		if child:IsA("Model") and child:GetAttribute("SpeciesId") == speciesId then
			local species = Config.SPECIES_BY_ID[speciesId]
			if species then applyVisuals(child, species, mutCount) end
			break
		end
	end
end

return MushroomManager
