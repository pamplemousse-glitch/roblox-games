-- PizzaZoneSpawner: spawns an invisible workspace Part that defines Pizza
-- Plaza's atmosphere region. The client (PizzaAtmosphereClient) watches
-- this Part and lerps Lighting (ColorShift_Top / FogColor / FogStart /
-- FogEnd / Brightness) when the LocalPlayer enters/exits.
--
-- Mirrors DonutZoneSpawner: derives bbox from AssetManifest entries whose
-- module path starts with "Assets.Districts.PizzaPlaza." — so the zone
-- tracks any future manifest moves with zero edit churn.
--
-- Parked under workspace.PizzaAtmosphereZones (a Folder) so the AssetSpawner
-- :ClearAllChildren("Districts") pass at session start does not wipe it.
--
-- Idempotent: an existing PizzaAtmosphereZones folder is destroyed and
-- recreated, so re-running this script leaves exactly one zone.

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ROOT_NAME       = "PizzaAtmosphereZones"
local ZONE_NAME       = "PizzaAtmosphereZone"
local ZONE_TAG        = "PizzaAtmosphereZone"
local MODULE_PREFIX   = "Assets.Districts.PizzaPlaza."
local XZ_MARGIN       = 40    -- studs of slack around the manifest footprint
local Y_CENTER        = 45    -- world Y midline (rooftop average)
local Y_SIZE          = 120   -- spans ground up to fountain / tower tops

local manifestModule = ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetManifest")
local manifest       = require(manifestModule)
if typeof(manifest) ~= "table" then
	warn("[PizzaZoneSpawner] manifest is not a table")
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
	warn("[PizzaZoneSpawner] no Pizza Plaza manifest entries found; zone not created")
	return
end

local centerX = (minX + maxX) * 0.5
local centerZ = (minZ + maxZ) * 0.5
local sizeX   = (maxX - minX) + XZ_MARGIN * 2
local sizeZ   = (maxZ - minZ) + XZ_MARGIN * 2

-- Re-spawn cleanly each server start (matches Donut / Tokyo zone patterns).
local existing = workspace:FindFirstChild(ROOT_NAME)
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name   = ROOT_NAME
root.Parent = workspace

local zone = Instance.new("Part")
zone.Name         = ZONE_NAME
zone.Anchored     = true
zone.CanCollide   = false
zone.CanQuery     = false
zone.CanTouch     = false
zone.Transparency = 1
zone.Size         = Vector3.new(sizeX, Y_SIZE, sizeZ)
zone.CFrame       = CFrame.new(centerX, Y_CENTER, centerZ)
zone.Parent       = root

CollectionService:AddTag(zone, ZONE_TAG)

print(string.format(
	"[PizzaZoneSpawner] %s spawned under workspace.%s (entries=%d) center=(%d, %d, %d) size=(%d, %d, %d)",
	ZONE_NAME, ROOT_NAME, count, centerX, Y_CENTER, centerZ, sizeX, Y_SIZE, sizeZ
))
