-- PizzaSoundZoneSpawner: spawn invisible workspace Parts that define Pizza
-- Plaza's ambient sound zones. The client (PizzaSoundZoneClient) watches
-- these Parts and lerps Sound.Volume on enter/exit.
--
-- One district-wide zone for the looping Italian café bed (accordion +
-- chatter + distant Vespa pad), plus per-building micro-zones for Tony's,
-- Mamma Carmela's, Vinny's, Romeo's gelato, Sal's calzone cart, and the
-- Trevi Fountain landmark. District AABB is derived from AssetManifest the
-- same way PizzaZoneSpawner derives PizzaAtmosphereZone — so the sound bed
-- and the atmosphere tint stay co-extensive without two hardcoded coord tables.
--
-- Zones live in workspace.PizzaSoundZones (not under Districts), so the
-- AssetSpawner :ClearAllChildren() pass at session start does not wipe them.

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ROOT_NAME     = "PizzaSoundZones"
local DISTRICT_TAG  = "PizzaSoundZone_District"
local MICRO_TAG     = "PizzaSoundZone_Micro"
local MODULE_PREFIX = "Assets.Districts.PizzaPlaza."
local XZ_MARGIN     = 40   -- same as PizzaZoneSpawner so both AABBs match
local Y_CENTER      = 45
local Y_SIZE        = 120

-- Micro-zones cover hero buildings + the Trevi Fountain landmark. Each
-- center is DERIVED from the manifest at runtime so the zones follow whatever
-- the current Pizza Plaza layout is. zKey is only needed when multiple
-- manifest entries share the same module string (none do today, but the
-- field is kept for symmetry with DonutSoundZoneSpawner).
type MicroSpec = {
	name:       string,
	moduleHint: string,
	zKey:       number?,
	yOffset:    number,
	size:       Vector3,
}

local MICRO_SPECS: { MicroSpec } = {
	-- Tony's Pizzeria — hero oven building.
	{ name = "TonysPizzeria",         moduleHint = "Buildings.TonysPizzeria",         yOffset = 20, size = Vector3.new(56, 50, 50) },
	-- Mamma Carmela's Trattoria — sit-down restaurant.
	{ name = "MammaCarmelasTrattoria",moduleHint = "Buildings.MammaCarmelasTrattoria", yOffset = 20, size = Vector3.new(56, 50, 50) },
	-- Vinny's Slice Shop — quick-service counter.
	{ name = "VinnysSliceShop",       moduleHint = "Buildings.VinnysSliceShop",       yOffset = 20, size = Vector3.new(50, 50, 50) },
	-- Romeo's Gelato Stand — small kiosk.
	{ name = "RomeosGelatoStand",     moduleHint = "Buildings.RomeosGelatoStand",     yOffset = 15, size = Vector3.new(40, 40, 40) },
	-- Sal's Calzone Cart — street cart.
	{ name = "SalsCalzoneCart",       moduleHint = "Buildings.SalsCalzoneCart",       yOffset = 12, size = Vector3.new(36, 30, 36) },
	-- Trevi Fountain landmark — sculpture, hero landing zone.
	{ name = "TreviFountain",         moduleHint = "Landmarks.TreviFountain",         yOffset = 15, size = Vector3.new(48, 40, 48) },
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

-- Derive district AABB from manifest, identical formula to PizzaZoneSpawner.
local manifestModule = ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetManifest")
local manifest       = require(manifestModule)
if typeof(manifest) ~= "table" then
	warn("[PizzaSoundZoneSpawner] manifest is not a table")
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
	warn("[PizzaSoundZoneSpawner] no Pizza Plaza manifest entries found; zones not created")
	return
end

local districtCenter = Vector3.new((minX + maxX) * 0.5, Y_CENTER, (minZ + maxZ) * 0.5)
local districtSize   = Vector3.new((maxX - minX) + XZ_MARGIN * 2, Y_SIZE, (maxZ - minZ) + XZ_MARGIN * 2)

-- Re-spawn cleanly each server start (matches Donut / Tokyo zone patterns).
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
		warn(string.format("[PizzaSoundZoneSpawner] no manifest match for %s (hint=%s); skipping",
			spec.name, spec.moduleHint))
		continue
	end
	local center = Vector3.new(pos.X, spec.yOffset, pos.Z)
	makeZone(root, spec.name, center, spec.size, MICRO_TAG)
	microSpawned += 1
end

print(string.format(
	"[PizzaSoundZoneSpawner] %d zones spawned under workspace.%s (district center=(%d,%d,%d) size=(%d,%d,%d))",
	1 + microSpawned, ROOT_NAME,
	districtCenter.X, districtCenter.Y, districtCenter.Z,
	districtSize.X,   districtSize.Y,   districtSize.Z
))
