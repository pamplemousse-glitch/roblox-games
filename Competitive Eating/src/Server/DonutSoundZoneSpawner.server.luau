-- DonutSoundZoneSpawner: spawn invisible workspace Parts that define Donut
-- Dynasty's ambient sound zones. The client (DonutSoundZoneClient) watches
-- these Parts and lerps Sound.Volume on enter/exit.
--
-- One district-wide zone for the looping Donut bed (bakery oven hum + faint
-- music pad), plus per-building micro-zones for the door bell, glaze chimes,
-- and espresso steam. District AABB is derived from AssetManifest the same
-- way DonutZoneSpawner derives DonutAtmosphereZone — so the sound bed and
-- the atmosphere tint stay co-extensive without two hardcoded coord tables.
--
-- Zones live in workspace.DonutSoundZones (not under Districts), so the
-- AssetSpawner :ClearAllChildren() pass at session start does not wipe them.

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ROOT_NAME     = "DonutSoundZones"
local DISTRICT_TAG  = "DonutSoundZone_District"
local MICRO_TAG     = "DonutSoundZone_Micro"
local MODULE_PREFIX = "Assets.Districts.DonutDynasty."
local XZ_MARGIN     = 40   -- same as DonutZoneSpawner so both AABBs match
local Y_CENTER      = 45
local Y_SIZE        = 120

-- Micro-zones cover hero buildings. We DERIVE each center from the manifest
-- at runtime so the zones follow whatever the current Donut Dynasty layout
-- is — the V1 and V2 building rows have already been re-positioned more than
-- once and would silently drift apart from a hardcoded coord table here.
--
-- XZ "size" extends ~10 studs past each footprint so the 0.9s client fade
-- hides the transition. Y is generous so 2nd-floor / rooftop frosting are
-- inside. yOffset gives the AABB a sensible vertical midline since manifest
-- positions are ground-level.
type MicroSpec = {
	name:       string,        -- zone Part name (matches LayerConfig.name in client)
	moduleHint: string,        -- substring matched against manifest entry's `module`
	zKey:       number?,       -- when multiple modules match, prefer entry whose Z is closest to this
	yOffset:    number,        -- midpoint of the AABB above ground
	size:       Vector3,
}

local MICRO_SPECS: { MicroSpec } = {
	-- DonutShop (V1) — small storefront, footprint ~36×28.
	{ name = "DonutShop",         moduleHint = "Buildings.DonutShop",         yOffset = 20, size = Vector3.new(56, 50, 50) },
	-- SweetheartDonuts (V2) — hero bakery.
	{ name = "SweetheartDonuts",  moduleHint = "V2.Buildings.SweetheartDonuts", yOffset = 20, size = Vector3.new(56, 50, 50) },
	-- GlazeFountain V1 — Z≈100 row. There are two GlazeFountain entries (V1 and
	-- V2 share the module path), so we disambiguate by Z.
	{ name = "GlazeFountainV1",   moduleHint = "Buildings.GlazeFountain",     zKey = 100, yOffset = 15, size = Vector3.new(40, 40, 40) },
	-- GlazeFountain V2 — same module, Z≈45.
	{ name = "GlazeFountainV2",   moduleHint = "Buildings.GlazeFountain",     zKey = 45,  yOffset = 15, size = Vector3.new(40, 40, 40) },
	-- CoffeeKiosk (V1).
	{ name = "CoffeeKiosk",       moduleHint = "Buildings.CoffeeKiosk",       yOffset = 15, size = Vector3.new(44, 40, 44) },
	-- HotChocolateStand (V2) — cart, low Y.
	{ name = "HotChocolateStand", moduleHint = "V2.Props.HotChocolateStand",  yOffset = 12, size = Vector3.new(36, 30, 36) },
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

-- Derive district AABB from manifest, identical formula to DonutZoneSpawner.
local manifestModule = ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetManifest")
local manifest       = require(manifestModule)
if typeof(manifest) ~= "table" then
	warn("[DonutSoundZoneSpawner] manifest is not a table")
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
	warn("[DonutSoundZoneSpawner] no Donut Dynasty manifest entries found; zones not created")
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
local function findManifestPos(hint: string, zKey: number?): Vector3?
	local best: Vector3? = nil
	local bestZDelta = math.huge
	for _, e in ipairs(manifest) do
		if typeof(e) ~= "table" then continue end
		if typeof(e.module) ~= "string" then continue end
		if not e.module:find(hint, 1, true) then continue end
		if typeof(e.position) ~= "Vector3" then continue end
		if zKey == nil then
			return e.position
		end
		local d = math.abs(e.position.Z - zKey)
		if d < bestZDelta then
			best = e.position
			bestZDelta = d
		end
	end
	return best
end

local microSpawned = 0
for _, spec in MICRO_SPECS do
	local pos = findManifestPos(spec.moduleHint, spec.zKey)
	if not pos then
		warn(string.format("[DonutSoundZoneSpawner] no manifest match for %s (hint=%s); skipping",
			spec.name, spec.moduleHint))
		continue
	end
	local center = Vector3.new(pos.X, spec.yOffset, pos.Z)
	makeZone(root, spec.name, center, spec.size, MICRO_TAG)
	microSpawned += 1
end

print(string.format(
	"[DonutSoundZoneSpawner] %d zones spawned under workspace.%s (district center=(%d,%d,%d) size=(%d,%d,%d))",
	1 + microSpawned, ROOT_NAME,
	districtCenter.X, districtCenter.Y, districtCenter.Z,
	districtSize.X,   districtSize.Y,   districtSize.Z
))
