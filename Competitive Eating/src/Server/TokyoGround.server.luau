-- TokyoGround: ground slab + visible street + sidewalks under the Tokyo
-- district. The relayout placed buildings at X=700-1100, Z=30-220 but Frank's
-- Fairground baseplate doesn't extend that far east — players were falling
-- through because there was no Anchored CanCollide part to land on.
--
-- Three parts (cheapest possible; replaces nothing the V2 build authored):
--   1. Ground slab (slate stone) at Y=0, full district footprint
--   2. Visible "street" strip running E-W along Z=100, asphalt-dark
--   3. Sidewalk strips on either side of the street (cobblestone)

local TOKYO_CENTER_X = 920
local TOKYO_CENTER_Z = 125
local FOOTPRINT_X    = 500   -- covers X=670..1170
local FOOTPRINT_Z    = 260   -- covers Z=-5..255

local STREET_Z_CENTER = 100
local STREET_WIDTH    = 30   -- Z=85..115
local SIDEWALK_WIDTH  = 8    -- Z=77..85 (south) and Z=115..123 (north)

local function makePart(name: string, size: Vector3, pos: Vector3, color: Color3, material: Enum.Material, parent: Instance)
	local p = Instance.new("Part")
	p.Name        = name
	p.Size        = size
	p.Position    = pos
	p.Anchored    = true
	p.CanCollide  = true
	p.CanQuery    = true
	p.Color       = color
	p.Material    = material
	p.TopSurface  = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent      = parent
	return p
end

-- Park under workspace.TokyoGround so AssetSpawner's `Districts:ClearAllChildren`
-- doesn't wipe it on each server start.
local existing = workspace:FindFirstChild("TokyoGround")
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name   = "TokyoGround"
root.Parent = workspace

-- 1. Base slab — slate-grey stone, sits Y = -1 to 0 so building foundations
--    (which sit at Y=0.2 thin slab) land flush on top.
makePart(
	"BaseSlab",
	Vector3.new(FOOTPRINT_X, 2, FOOTPRINT_Z),
	Vector3.new(TOKYO_CENTER_X, -1, TOKYO_CENTER_Z),
	Color3.fromRGB(140, 135, 125),  -- pale slate
	Enum.Material.Slate,
	root
)

-- 2. Street — darker asphalt strip along Z=85..115, slightly raised so it
--    reads as a road instead of blending into the slab.
makePart(
	"Street",
	Vector3.new(FOOTPRINT_X, 0.2, STREET_WIDTH),
	Vector3.new(TOKYO_CENTER_X, 0.05, STREET_Z_CENTER),
	Color3.fromRGB(60, 55, 50),  -- dark asphalt
	Enum.Material.Asphalt,
	root
)

-- 3. Sidewalks — cobblestone strips north and south of the street.
makePart(
	"SidewalkSouth",
	Vector3.new(FOOTPRINT_X, 0.3, SIDEWALK_WIDTH),
	Vector3.new(TOKYO_CENTER_X, 0.1, STREET_Z_CENTER - STREET_WIDTH/2 - SIDEWALK_WIDTH/2),
	Color3.fromRGB(180, 175, 165),  -- light cobble
	Enum.Material.Cobblestone,
	root
)
makePart(
	"SidewalkNorth",
	Vector3.new(FOOTPRINT_X, 0.3, SIDEWALK_WIDTH),
	Vector3.new(TOKYO_CENTER_X, 0.1, STREET_Z_CENTER + STREET_WIDTH/2 + SIDEWALK_WIDTH/2),
	Color3.fromRGB(180, 175, 165),
	Enum.Material.Cobblestone,
	root
)

print(string.format(
	"[TokyoGround] spawned: slab=%dx%d@Y=-1, street=%dx%d@Z=%d, sidewalks=2x%d-wide",
	FOOTPRINT_X, FOOTPRINT_Z, FOOTPRINT_X, STREET_WIDTH, STREET_Z_CENTER, SIDEWALK_WIDTH
))
