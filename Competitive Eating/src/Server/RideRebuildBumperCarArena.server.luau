-- RideRebuildBumperCarArena
-- Frank's Fairground ride-rebuild: BumperCarArena → "Marshmallow Bumpers".
-- Cocoa-drink themed arena, decorative only (no live bumper physics in v1.0).
--
-- Contract (per docs/RIDE_REBUILD_PLAYBOOK.md §11):
--   * No mcp__Roblox_Studio__* calls (orchestrator owns Studio).
--   * No RideController edits — BumperCarArena has no entry in any of its tables,
--     and no named-part contract. Decorative only.
--   * Pure primitives via AssetBuilder.
--   * Idempotent rebuild (TokyoGround pattern): clone old → ServerStorage,
--     ClearAllChildren on the same Model, rebuild children, re-pivot.
--   * Footprint = 2× original (read live from current model bbox; no hardcoded coords).
--
-- Visual brief:
--   * Floor = cocoa-drink surface (rich brown circular disc).
--   * Walls = cocoa-cup ceramic (white short cylindrical perimeter).
--   * 6-8 bumper cars = giant marshmallows (white squashed spheres), each with
--     a single rider Seat on top.

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AB = require(ReplicatedStorage.Common.AssetBuilder)

local RIDE_NAME       = "BumperCarArena"
local BACKUP_NAME     = RIDE_NAME .. "_PreFood_2026-06-03"
local SCALE           = 2          -- 2× footprint per playbook
local CAR_COUNT       = 7          -- 6-8 cars per playbook (pick middle)

-- Marshmallow / cocoa palette (not yet in AssetBuilder.colors — inline so this
-- module stays self-contained; promote to Palettes.luau when that file lands).
local COCOA_DRINK     = Color3.fromRGB( 70,  40,  20)  -- rich brown floor
local COCOA_FOAM      = Color3.fromRGB(225, 200, 165)  -- pale cream foam ring
local CUP_CERAMIC     = Color3.fromRGB(245, 240, 232)  -- off-white porcelain wall
local CUP_RIM_GOLD    = Color3.fromRGB(195, 155,  70)  -- antique gold cup rim
local MARSHMALLOW     = Color3.fromRGB(252, 248, 240)  -- soft white
local MARSHMALLOW_TAN = Color3.fromRGB(228, 215, 188)  -- toasted accent

task.wait(1)   -- let other rebuild scripts settle this server tick

local m = workspace:FindFirstChild(RIDE_NAME)
if not m then
	warn(string.format("[RideRebuild] %s missing in workspace; skipping rebuild", RIDE_NAME))
	return
end

-- Capture original world pivot so we can restore it after the rebuild.
local originalPivot: CFrame = m:GetPivot()

-- Measure original footprint (so 2× is honest, not hardcoded).
-- GetBoundingBox returns CFrame + Size in world space.
local _origCF, origSize = m:GetBoundingBox()
local origFootprint = math.max(origSize.X, origSize.Z, 1)   -- guard against 0

-- 2× the larger of X/Z, but clamp to sane carnival values so a corrupt empty
-- model can't produce a 4096-stud arena.
local arenaDiameter = math.clamp(origFootprint * SCALE, 60, 240)

-- Back up existing children (clone, then clear the live model in place so
-- anything in the data model that references workspace.BumperCarArena keeps
-- its handle).
local clone = m:Clone()
clone.Name = BACKUP_NAME
clone.Parent = ServerStorage

m:ClearAllChildren()
m.PrimaryPart = nil

-- ── Build the cocoa-cup arena ───────────────────────────────────────────────
-- Local origin: the new contents are built around CFrame.new() (centred on the
-- model's local origin Y=0). At the end we PivotTo(originalPivot), which puts
-- the cup centre at the same world location the original arena occupied.

local FLOOR_THICK = 1.5
local WALL_HEIGHT = 9
local WALL_THICK  = 2.5
local FOAM_THICK  = 0.4

-- 1. Cocoa-drink floor (cylindrical disc, slightly recessed so the foam ring
--    reads as the surface of the drink and the walls read as the cup interior).
local floorY = -FLOOR_THICK / 2
AB.cylinder(
	arenaDiameter,
	FLOOR_THICK,
	COCOA_DRINK,
	CFrame.new(0, floorY, 0),
	m,
	"ArenaFloor"
)

-- 2. Foam ring — thin pale ring at the drink's surface, hugging the inside of
--    the cup. Realised as a slightly-larger cylinder underneath the floor disc
--    so its 0.4-stud rim peeks out as a foam edge.
AB.cylinder(
	arenaDiameter - 2,
	FOAM_THICK,
	COCOA_FOAM,
	CFrame.new(0, 0.1, 0),
	m,
	"FoamRing"
)

-- 3. Cup wall — white ceramic perimeter, built as 24 short box segments arranged
--    in a circle. A single tall cylinder would look like a soup can; segments
--    plus the gold rim cap above read as a ceramic cup wall.
local SEGMENTS = 24
local wallRadius = arenaDiameter / 2 + WALL_THICK / 2
local segChord = (math.pi * arenaDiameter) / SEGMENTS + 0.5   -- overlap to hide seams

AB.circleArrange(CFrame.new(0, WALL_HEIGHT / 2, 0), wallRadius, SEGMENTS, m, function(i, cf, _angleDeg)
	-- Each segment is a tall thin box; its local +Z faces radially OUTWARD
	-- thanks to circleArrange's yaw. Width along X (tangential), thickness Z.
	return AB.block(
		Vector3.new(segChord, WALL_HEIGHT, WALL_THICK),
		CUP_CERAMIC,
		cf,
		m,
		string.format("CupWall_%d", i)
	)
end)

-- 4. Gold rim cap — sits atop the wall ring like the gilded lip of a mug.
local rimY = WALL_HEIGHT + 0.5
AB.circleArrange(CFrame.new(0, rimY, 0), wallRadius, SEGMENTS, m, function(i, cf, _angleDeg)
	return AB.block(
		Vector3.new(segChord, 1, WALL_THICK + 0.4),
		CUP_RIM_GOLD,
		cf,
		m,
		string.format("CupRim_%d", i)
	)
end)

-- 5. Boarding entry — gap in wall + a short ramp at one cardinal direction so a
--    player on foot can step in. Replace 2 adjacent wall segments with a low
--    "door" sill and tint a chocolate-shaving threshold.
local function despawnSegments(prefix: string, indices: { number })
	for _, i in ipairs(indices) do
		local seg = m:FindFirstChild(string.format(prefix, i))
		if seg then seg:Destroy() end
	end
end
despawnSegments("CupWall_%d", { 1, 2 })
despawnSegments("CupRim_%d",  { 1, 2 })

local doorRadius = wallRadius + 1
local doorCF = CFrame.new(doorRadius, 0.5, 0)   -- entry at +X (segment indices 1..2 are near angle 0)
AB.block(
	Vector3.new(8, 1, WALL_THICK + 2),
	COCOA_FOAM,
	doorCF,
	m,
	"EntryRamp"
)
AB.block(
	Vector3.new(8, 0.3, WALL_THICK + 2),
	CUP_RIM_GOLD,
	doorCF * CFrame.new(0, 0.65, 0),
	m,
	"EntryRampTrim"
)

-- ── Marshmallow bumper cars ─────────────────────────────────────────────────
-- Each car is:
--   * a squashed white sphere (the marshmallow body) anchored on the floor
--   * a thin tan top "toasted" cap so it reads as marshmallow not as a snowball
--   * a Seat on top for the rider
-- Cars are scattered around the arena interior on a smaller-radius ring so they
-- look populated but aren't clipping the wall.

local MARSH_DIAMETER = 9
local MARSH_SQUASH   = 0.55          -- vertical scale on the sphere
local MARSH_BODY_Y   = MARSH_DIAMETER * MARSH_SQUASH / 2  -- sit on floor
local carRingR       = math.max(arenaDiameter / 2 - MARSH_DIAMETER - 4, 6)

for i = 1, CAR_COUNT do
	local angle = ((i - 1) / CAR_COUNT) * math.pi * 2
	-- Stagger every other car closer to centre so it doesn't look like a clock face.
	local r = carRingR * (i % 2 == 0 and 0.55 or 1.0)
	local x = math.cos(angle) * r
	local z = math.sin(angle) * r
	local yaw = -math.deg(angle) + 90   -- face roughly tangential

	local carModel = AB.model(string.format("MarshmallowCar_%d", i), m)

	-- Body: build as a Ball, then squash via Size (sphere primitive ignores
	-- non-uniform Size visually but the underlying Part respects it; the
	-- result is a squashed sphere that reads as a fat marshmallow).
	local body = AB.sphere(
		MARSH_DIAMETER,
		MARSHMALLOW,
		CFrame.new(x, MARSH_BODY_Y, z) * CFrame.Angles(0, math.rad(yaw), 0),
		carModel,
		"Body"
	)
	body.Size = Vector3.new(MARSH_DIAMETER, MARSH_DIAMETER * MARSH_SQUASH, MARSH_DIAMETER)

	-- Toasted-tan cap — small disc on top so the marshmallow reads "fluffy"
	-- rather than "snowball".
	AB.cylinder(
		MARSH_DIAMETER - 2.5,
		0.6,
		MARSHMALLOW_TAN,
		CFrame.new(x, MARSH_BODY_Y + MARSH_DIAMETER * MARSH_SQUASH / 2 + 0.1, z),
		carModel,
		"ToastedCap"
	)

	-- Skirt — small foam-coloured ring around the base to hide the body's
	-- waterline where it meets the cocoa floor.
	AB.cylinder(
		MARSH_DIAMETER + 0.4,
		0.4,
		COCOA_FOAM,
		CFrame.new(x, 0.25, z),
		carModel,
		"BumperSkirt"
	)

	-- Rider Seat — perched on top of the marshmallow. Seat is a real Roblox
	-- Seat instance so a player walking up can sit on it; decorative-only ride
	-- means no physics propulsion, just a perch.
	local seat = Instance.new("Seat")
	seat.Name        = "Seat"
	seat.Size        = Vector3.new(3, 0.6, 3)
	seat.Color       = MARSHMALLOW_TAN
	seat.Material    = Enum.Material.SmoothPlastic
	seat.TopSurface  = Enum.SurfaceType.Smooth
	seat.BottomSurface = Enum.SurfaceType.Smooth
	seat.Anchored    = true   -- decorative ride; anchored stops the car drifting
	seat.CanCollide  = true
	seat.CFrame      = CFrame.new(x, MARSH_BODY_Y + MARSH_DIAMETER * MARSH_SQUASH / 2 + 0.7, z)
		* CFrame.Angles(0, math.rad(yaw), 0)
	seat.Parent      = carModel

	carModel.PrimaryPart = body
	AB.weldAll(carModel)
end

-- ── Finish up ───────────────────────────────────────────────────────────────

-- PrimaryPart on the root model = the floor disc (the most central anchored
-- part; lets RideController / any future spinner code use a canonical handle).
local arenaFloor = m:FindFirstChild("ArenaFloor")
if arenaFloor and arenaFloor:IsA("BasePart") then
	m.PrimaryPart = arenaFloor
end

AB.weldAll(m)
m:PivotTo(originalPivot)

print(string.format(
	"[RideRebuild] %s rebuilt as Marshmallow Bumpers — arena Ø %d, %d cars",
	RIDE_NAME, arenaDiameter, CAR_COUNT
))
