-- BbqZoneSpawner: spawns an invisible workspace Part that defines BBQ
-- Holler's atmosphere region. The client (BbqAtmosphereClient) watches
-- this Part and lerps the smoky golden-hour Lighting preset when
-- LocalPlayer enters/exits.
--
-- Mirrors DonutZoneSpawner: read AssetManifest at boot and derive the
-- footprint from every entry whose module path starts with
-- "Assets.Districts.BbqHoller." — so the zone tracks any future manifest
-- moves with zero edit churn.
--
-- Idempotent: an existing BbqAtmosphereZone is destroyed and recreated.

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ZONE_NAME       = "BbqAtmosphereZone"
local ZONE_TAG        = "BbqAtmosphereZone"
local MODULE_PREFIX   = "Assets.Districts.BbqHoller."
local XZ_MARGIN       = 40    -- studs of slack around the manifest footprint
local Y_CENTER        = 45    -- world Y midline (rooftop / chimney average)
local Y_SIZE          = 140   -- spans ground up to water tower / chimney tops

local manifestModule = ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetManifest")
local manifest       = require(manifestModule)
if typeof(manifest) ~= "table" then
	warn("[BbqZoneSpawner] manifest is not a table")
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
	warn("[BbqZoneSpawner] no BBQ Holler manifest entries found; zone not created")
	return
end

local centerX = (minX + maxX) * 0.5
local centerZ = (minZ + maxZ) * 0.5
local sizeX   = (maxX - minX) + XZ_MARGIN * 2
local sizeZ   = (maxZ - minZ) + XZ_MARGIN * 2

local existing = workspace:FindFirstChild(ZONE_NAME)
if existing then existing:Destroy() end

local zone = Instance.new("Part")
zone.Name         = ZONE_NAME
zone.Anchored     = true
zone.CanCollide   = false
zone.CanQuery     = false
zone.CanTouch     = false
zone.Transparency = 1
zone.Size         = Vector3.new(sizeX, Y_SIZE, sizeZ)
zone.CFrame       = CFrame.new(centerX, Y_CENTER, centerZ)
zone.Parent       = workspace

CollectionService:AddTag(zone, ZONE_TAG)

print(string.format(
	"[BbqZoneSpawner] %s spawned (entries=%d) center=(%d, %d, %d) size=(%d, %d, %d)",
	ZONE_NAME, count, centerX, Y_CENTER, centerZ, sizeX, Y_SIZE, sizeZ
))
