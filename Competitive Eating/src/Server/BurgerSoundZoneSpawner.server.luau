-- BurgerSoundZoneSpawner: spawn invisible workspace Parts that define Burger
-- Boulevard's ambient sound zones. The client (BurgerSoundZoneClient) watches
-- these Parts and lerps Sound.Volume on enter/exit.
--
-- One district-wide zone for the looping Burger bed (rock-n-roll jukebox loop
-- + V8 idle + sizzling grill + milkshake mixer hum), plus per-building
-- micro-zones for drive-in marquee, diner counter, slider grill, motel hum,
-- mixer, and the giant tower landmark. District AABB is derived from
-- AssetManifest the same way BurgerZoneSpawner derives BurgerAtmosphereZone
-- — so the sound bed and the atmosphere tint stay co-extensive without two
-- hardcoded coord tables.
--
-- Zones live in workspace.BurgerSoundZones (not under Districts), so the
-- AssetSpawner :ClearAllChildren() pass at session start does not wipe them.

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ROOT_NAME     = "BurgerSoundZones"
local DISTRICT_TAG  = "BurgerSoundZone_District"
local MICRO_TAG     = "BurgerSoundZone_Micro"
local MODULE_PREFIX = "Assets.Districts.BurgerBoulevard."
local XZ_MARGIN     = 40   -- same as BurgerZoneSpawner so both AABBs match
local Y_CENTER      = 45
local Y_SIZE        = 120

-- Micro-zones: tied to hero buildings + the GiantBurgerTower landmark. Each
-- center is derived at runtime from the live manifest entry whose `module`
-- contains the hint substring, so future manifest moves don't drift the
-- audio away from the building.
--
-- XZ size is generous so the 0.9s fade hides the transition; Y is wide
-- enough to capture rooftops. yOffset is the AABB's vertical midline above
-- ground.
type MicroSpec = {
	name:       string,        -- zone Part name (matches LayerConfig.name in client)
	moduleHint: string,        -- substring matched against manifest entry's `module`
	yOffset:    number,
	size:       Vector3,
}

local MICRO_SPECS: { MicroSpec } = {
	-- Smashville Drive-In — drive-thru hub, car horns + speaker chatter.
	{ name = "SmashvilleDriveIn", moduleHint = "Buildings.SmashvilleDriveIn", yOffset = 20, size = Vector3.new(60, 50, 50) },
	-- Big Beef Diner — counter chatter + sizzling grill behind the bar.
	{ name = "BigBeefDiner",      moduleHint = "Buildings.BigBeefDiner",      yOffset = 20, size = Vector3.new(56, 50, 50) },
	-- Slider Stop — focused grill flat-top + spatula taps.
	{ name = "SliderStop",        moduleHint = "Buildings.SliderStop",        yOffset = 20, size = Vector3.new(50, 50, 50) },
	-- CoolShake Mixer — milkshake mixer hum + ice-cream paddle whirr.
	{ name = "CoolShakeMixer",    moduleHint = "Buildings.CoolShakeMixer",    yOffset = 18, size = Vector3.new(50, 50, 50) },
	-- Neon Motel — distant traffic + vacancy buzz; quieter, calmer.
	{ name = "NeonMotel",         moduleHint = "Buildings.NeonMotel",         yOffset = 25, size = Vector3.new(60, 60, 60) },
	-- Giant Burger Tower — landmark monument, low rumble + sizzle bed.
	{ name = "GiantBurgerTower",  moduleHint = "Landmarks.GiantBurgerTower",  yOffset = 30, size = Vector3.new(60, 80, 60) },
}

local function makeZone(parent: Instance, name: string, center: Vector3, size: Vector3, tag: string): BasePart
	local p = Instance.new("Part")
	p.Name         = name
	p.Anchored     = true
	p.CanCollide   = false
	p.CanQuery     = false
	p.CanTouch     = false
	p.Transparency = 1
	p.Size         = size
	p.CFrame       = CFrame.new(center)
	p.Parent       = parent
	CollectionService:AddTag(p, tag)
	return p
end

-- Derive district AABB from manifest, identical formula to BurgerZoneSpawner.
local manifestModule = ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetManifest")
local manifest       = require(manifestModule)
if typeof(manifest) ~= "table" then
	warn("[BurgerSoundZoneSpawner] manifest is not a table")
	return
end

local minX, minZ =  math.huge,  math.huge
local maxX, maxZ = -math.huge, -math.huge
local count = 0
for _, e in ipairs(manifest) do
	if typeof(e) ~= "table" then continue end
	if typeof(e.module) ~= "string" then continue end
	if e.module:sub(1, #MODULE_PREFIX) ~= MODULE_PREFIX then continue end
	local p = e.position
	if typeof(p) ~= "Vector3" then continue end
	if p.X < minX then minX = p.X end
	if p.X > maxX then maxX = p.X end
	if p.Z < minZ then minZ = p.Z end
	if p.Z > maxZ then maxZ = p.Z end
	count += 1
end

if count == 0 then
	warn("[BurgerSoundZoneSpawner] no Burger Boulevard manifest entries found; zones not created")
	return
end

local districtCenter = Vector3.new((minX + maxX) * 0.5, Y_CENTER, (minZ + maxZ) * 0.5)
local districtSize   = Vector3.new((maxX - minX) + XZ_MARGIN * 2, Y_SIZE, (maxZ - minZ) + XZ_MARGIN * 2)

-- Re-spawn cleanly each server start (matches Tokyo / Donut zone patterns).
local existing = workspace:FindFirstChild(ROOT_NAME)
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name   = ROOT_NAME
root.Parent = workspace

makeZone(root, "District", districtCenter, districtSize, DISTRICT_TAG)

-- Resolve each micro-zone's center against the live manifest. Missing
-- buildings just skip with a warn — common during partial-content edits.
local function findManifestPos(hint: string): Vector3?
	for _, e in ipairs(manifest) do
		if typeof(e) ~= "table" then continue end
		if typeof(e.module) ~= "string" then continue end
		if not e.module:find(hint, 1, true) then continue end
		if typeof(e.position) ~= "Vector3" then continue end
		return e.position
	end
	return nil
end

local microSpawned = 0
for _, spec in MICRO_SPECS do
	local pos = findManifestPos(spec.moduleHint)
	if not pos then
		warn(string.format("[BurgerSoundZoneSpawner] no manifest match for %s (hint=%s); skipping",
			spec.name, spec.moduleHint))
		continue
	end
	local center = Vector3.new(pos.X, spec.yOffset, pos.Z)
	makeZone(root, spec.name, center, spec.size, MICRO_TAG)
	microSpawned += 1
end

print(string.format(
	"[BurgerSoundZoneSpawner] %d zones spawned under workspace.%s (district center=(%d,%d,%d) size=(%d,%d,%d))",
	1 + microSpawned, ROOT_NAME,
	districtCenter.X, districtCenter.Y, districtCenter.Z,
	districtSize.X,   districtSize.Y,   districtSize.Z
))
