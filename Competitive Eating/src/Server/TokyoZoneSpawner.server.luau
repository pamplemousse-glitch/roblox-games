-- TokyoZoneSpawner: spawns an invisible workspace Part that defines Tokyo
-- Town's atmosphere region. The client (TokyoAtmosphereClient) watches this
-- Part and lerps Lighting.Atmosphere when LocalPlayer enters/exits.
--
-- Bounding box derived from AssetManifest Tokyo entries (X 770..1040,
-- Z 10..210). Y is generous to catch lanterns + rooftops + ground NPCs.

local CollectionService = game:GetService("CollectionService")

local ZONE_NAME = "TokyoAtmosphereZone"
local ZONE_TAG  = "TokyoAtmosphereZone"

local CENTER = Vector3.new(905, 45, 110)
local SIZE   = Vector3.new(290, 120, 220)

local existing = workspace:FindFirstChild(ZONE_NAME)
if existing then existing:Destroy() end

local zone = Instance.new("Part")
zone.Name         = ZONE_NAME
zone.Anchored     = true
zone.CanCollide   = false
zone.CanQuery     = false
zone.CanTouch     = false
zone.Transparency = 1
zone.Size         = SIZE
zone.CFrame       = CFrame.new(CENTER)
zone.Parent       = workspace

CollectionService:AddTag(zone, ZONE_TAG)

print(string.format("[TokyoZoneSpawner] %s spawned at %s size=%s", ZONE_NAME, tostring(CENTER), tostring(SIZE)))
