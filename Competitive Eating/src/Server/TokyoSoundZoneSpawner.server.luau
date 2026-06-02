-- TokyoSoundZoneSpawner: spawn invisible workspace Parts that define Tokyo
-- Town's ambient sound zones. The client (TokyoSoundZoneClient) watches
-- these Parts and lerps Sound.Volume on enter/exit.
--
-- One district-wide zone for the looping Tokyo bed (street chatter + taiko
-- + neon hum), plus per-building micro-zones for slurps, sake clinks, oil
-- sizzle. Coords mirror the AssetManifest layout used by AssetSpawner so
-- the zones line up with where the buildings actually spawn at runtime.
--
-- Zones live in workspace.TokyoSoundZones (not under Districts), so the
-- AssetSpawner :ClearAllChildren() pass at session start does not wipe them.

local CollectionService = game:GetService("CollectionService")

local ROOT_NAME = "TokyoSoundZones"
local DISTRICT_TAG = "TokyoSoundZone_District"
local MICRO_TAG    = "TokyoSoundZone_Micro"

-- District zone covers the whole Tokyo Town footprint (same as
-- TokyoAtmosphereZone — the district sound bed is co-extensive with the
-- atmosphere tint).
local DISTRICT_CENTER = Vector3.new(905, 45, 110)
local DISTRICT_SIZE   = Vector3.new(290, 120, 220)

-- Micro-zones: hand-tuned around each hero building's manifest position.
-- Size is generous on Y so 2nd-floor windows are inside; XZ is wider than
-- the building to give a brief overlap that the fade hides.
local MICRO_ZONES = {
	{ name = "DaikonRamen",    center = Vector3.new(815, 20, 108), size = Vector3.new(56, 50, 50) },
	{ name = "SushiDaiko",     center = Vector3.new(852, 20, 122), size = Vector3.new(60, 50, 44) },
	{ name = "IzakayaLantern", center = Vector3.new(895, 20, 115), size = Vector3.new(50, 50, 50) },
	{ name = "TakoyakiCart",   center = Vector3.new(872, 12, 62),  size = Vector3.new(36, 30, 36) },
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

-- Re-spawn cleanly each server start (matches TokyoZoneSpawner pattern).
local existing = workspace:FindFirstChild(ROOT_NAME)
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name   = ROOT_NAME
root.Parent = workspace

makeZone(root, "District", DISTRICT_CENTER, DISTRICT_SIZE, DISTRICT_TAG)

for _, z in MICRO_ZONES do
	makeZone(root, z.name, z.center, z.size, MICRO_TAG)
end

print(string.format("[TokyoSoundZoneSpawner] %d zones spawned under workspace.%s", 1 + #MICRO_ZONES, ROOT_NAME))
