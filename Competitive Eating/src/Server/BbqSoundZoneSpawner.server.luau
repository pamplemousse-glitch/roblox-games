-- BbqSoundZoneSpawner: spawn invisible workspace Parts that define BBQ
-- Holler's ambient sound zones. The client (BbqSoundZoneClient) watches
-- these Parts and lerps Sound.Volume on enter/exit.
--
-- One district-wide zone for the looping BBQ bed (country bluegrass banjo
-- + crackling fire + cicadas + distant cow lowing), plus per-building
-- micro-zones for the smokehouse, rib shack, brisket barn, BBQ truck, hay
-- barn, and giant pig statue. District AABB is derived from AssetManifest
-- the same way BbqZoneSpawner derives BbqAtmosphereZone — so the sound
-- bed and the atmosphere tint stay co-extensive.
--
-- Zones live in workspace.BbqSoundZones (not under Districts), so the
-- AssetSpawner :ClearAllChildren() pass at session start does not wipe them.

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ROOT_NAME     = "BbqSoundZones"
local DISTRICT_TAG  = "BbqSoundZone_District"
local MICRO_TAG     = "BbqSoundZone_Micro"
local MODULE_PREFIX = "Assets.Districts.BbqHoller."
local XZ_MARGIN     = 40
local Y_CENTER      = 45
local Y_SIZE        = 140

type MicroSpec = {
	name:       string,
	moduleHint: string,
	zKey:       number?,
	yOffset:    number,
	size:       Vector3,
}

local MICRO_SPECS: { MicroSpec } = {
	-- SmokehouseSmokyJoes — hero smokehouse, oak-smoke crackle bed.
	{ name = "SmokehouseSmokyJoes", moduleHint = "Buildings.SmokehouseSmokyJoes", yOffset = 20, size = Vector3.new(56, 50, 50) },
	-- RibShack — gritty rib-stall stinger + crowd murmur.
	{ name = "RibShack",            moduleHint = "Buildings.RibShack",            yOffset = 20, size = Vector3.new(56, 50, 50) },
	-- BrisketBarn — slow low fire bed.
	{ name = "BrisketBarn",         moduleHint = "Buildings.BrisketBarn",         yOffset = 20, size = Vector3.new(56, 50, 50) },
	-- PitBossBBQTruck — diesel idle + grill sizzle.
	{ name = "PitBossBBQTruck",     moduleHint = "Buildings.PitBossBBQTruck",     yOffset = 18, size = Vector3.new(50, 45, 50) },
	-- HayBarn — distant cicadas + wood creak.
	{ name = "HayBarn",             moduleHint = "Buildings.HayBarn",             yOffset = 22, size = Vector3.new(60, 55, 60) },
	-- GiantPigStatue landmark — small wide zone with a banjo pluck stinger.
	{ name = "GiantPigStatue",      moduleHint = "Landmarks.GiantPigStatue",      yOffset = 15, size = Vector3.new(48, 45, 48) },
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

-- Derive district AABB from manifest, identical formula to BbqZoneSpawner.
local manifestModule = ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetManifest")
local manifest       = require(manifestModule)
if typeof(manifest) ~= "table" then
	warn("[BbqSoundZoneSpawner] manifest is not a table")
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
	warn("[BbqSoundZoneSpawner] no BBQ Holler manifest entries found; zones not created")
	return
end

local districtCenter = Vector3.new((minX + maxX) * 0.5, Y_CENTER, (minZ + maxZ) * 0.5)
local districtSize   = Vector3.new((maxX - minX) + XZ_MARGIN * 2, Y_SIZE, (maxZ - minZ) + XZ_MARGIN * 2)

local existing = workspace:FindFirstChild(ROOT_NAME)
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name   = ROOT_NAME
root.Parent = workspace

makeZone(root, "District", districtCenter, districtSize, DISTRICT_TAG)

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
		warn(string.format("[BbqSoundZoneSpawner] no manifest match for %s (hint=%s); skipping",
			spec.name, spec.moduleHint))
		continue
	end
	local center = Vector3.new(pos.X, spec.yOffset, pos.Z)
	makeZone(root, spec.name, center, spec.size, MICRO_TAG)
	microSpawned += 1
end

print(string.format(
	"[BbqSoundZoneSpawner] %d zones spawned under workspace.%s (district center=(%d,%d,%d) size=(%d,%d,%d))",
	1 + microSpawned, ROOT_NAME,
	districtCenter.X, districtCenter.Y, districtCenter.Z,
	districtSize.X,   districtSize.Y,   districtSize.Z
))
