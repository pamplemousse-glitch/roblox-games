-- RideRebuildTeacupRide.server.luau
-- Rebuilds workspace.TeacupRide as Donut Cups for Frank's Fairground.
--
-- Mechanic preserved: SPIN_RIDES TeacupRide rps=0.55 (RideController spins the
-- entire model around partCentroid). No constant updates needed.
--
-- Named-part contract preserved:
--   - Model name "TeacupRide" — kept (ClearAllChildren, not Destroy)
--   - Seat children — 8 anchored Seat instances at the centers of each donut
--     (RideController.getSeats() scans :GetChildren() for ClassName == "Seat")
--
-- Food shape: 8 giant donuts (50-stud diameter at 2× original cup scale),
-- arranged on a pastel-pink glaze platter. Each donut has a frosted top with
-- sprinkles and a sittable hole in the middle (Seat at center).
--
-- Aesthetic: pure Robloxy primitives via AssetBuilder. No external meshes.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage     = game:GetService("ServerStorage")

local AB = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetBuilder"))

-- ── Wait for other rebuild scripts ───────────────────────────────────────────
task.wait(1)

local m = workspace:FindFirstChild("TeacupRide") :: Model?
if not m then
	warn("[RideRebuildTeacupRide] workspace.TeacupRide not found — skipping rebuild.")
	return
end

-- ── Capture original world pivot so the ride stays where it sits ────────────
local originalPivot = m:GetPivot()

-- ── Back up the existing model ───────────────────────────────────────────────
do
	local backup = m:Clone()
	backup.Name   = "TeacupRide_PreFood_2026-06-03"
	backup.Parent = ServerStorage
end

-- ── Clear children but preserve the Model instance ───────────────────────────
m:ClearAllChildren()
m.PrimaryPart = nil

-- ── Color palette (donut shop pastels) ───────────────────────────────────────
local C = {
	dough            = Color3.fromRGB(220, 170, 110),   -- glazed donut base
	doughDark        = Color3.fromRGB(195, 145, 90),    -- shadow ring
	frostingPink     = Color3.fromRGB(255, 180, 200),   -- strawberry frosting
	frostingChoc     = Color3.fromRGB(110, 70, 40),     -- chocolate frosting
	frostingBlue     = Color3.fromRGB(140, 200, 230),   -- blueberry frosting
	frostingMatcha   = Color3.fromRGB(160, 210, 130),   -- matcha frosting
	platterPink      = Color3.fromRGB(250, 215, 225),   -- pastel pink display tray
	platterTrim      = Color3.fromRGB(220, 180, 195),   -- darker pink rim
	platterFoot      = Color3.fromRGB(230, 200, 215),   -- pedestal foot
	sprinkleA        = Color3.fromRGB(255, 100, 130),
	sprinkleB        = Color3.fromRGB(255, 220, 80),
	sprinkleC        = Color3.fromRGB(140, 200, 230),
	sprinkleD        = Color3.fromRGB(180, 100, 220),
	sprinkleE        = Color3.fromRGB(255, 255, 255),
	seatHole         = Color3.fromRGB(80, 50, 30),       -- visible hole shadow
}

local FROSTING_COLORS = {
	C.frostingPink, C.frostingChoc, C.frostingBlue, C.frostingMatcha,
	C.frostingPink, C.frostingChoc, C.frostingBlue, C.frostingMatcha,
}

local SPRINKLE_COLORS = { C.sprinkleA, C.sprinkleB, C.sprinkleC, C.sprinkleD, C.sprinkleE }

-- ── Dimensions ───────────────────────────────────────────────────────────────
-- Original TeacupRide was ~30 stud diameter. 2× = ~60 stud. The previous
-- DONUT_DIAMETER=50 + PLATTER_RADIUS=95 produced a 190-stud ride ≈ 6× the
-- original. Corrected here.
local DONUT_DIAMETER     = 14                              -- 2× of original ~7-stud cup
local DONUT_OUTER_R      = DONUT_DIAMETER / 2              -- 7
local DONUT_TUBE_R       = 2.5                             -- donut tube thickness radius
local DONUT_INNER_R      = DONUT_OUTER_R - DONUT_TUBE_R*2  -- 2 — hole radius
local DONUT_HEIGHT       = DONUT_TUBE_R * 2                -- 5 — donut total height

local DONUT_SEGMENTS     = 16   -- ring resolution per donut
local NUM_DONUTS         = 8

local PLATTER_RADIUS     = 30                              -- 2× of original ~15-stud platter
local DONUT_RING_RADIUS  = 20                              -- center distance of each donut
local PLATTER_THICKNESS  = 1.5
local PLATTER_TRIM_W     = 1

-- ── Build the platter (glaze display tray) ───────────────────────────────────
-- Y=0 in local space = top surface of platter. Donuts sit at Y = ~0.
local platterY = -PLATTER_THICKNESS / 2

local platter = AB.cylinder(
	PLATTER_RADIUS * 2, PLATTER_THICKNESS, C.platterPink,
	CFrame.new(0, platterY, 0),
	m, "Platter"
)
m.PrimaryPart = platter

-- Glossy rim around platter edge — 24-segment polygonal ring
local rimSegments = 24
for i = 1, rimSegments do
	local a = (i - 1) / rimSegments * math.pi * 2
	local chordLen = 2 * PLATTER_RADIUS * math.tan(math.pi / rimSegments)
	local cf = CFrame.new(
		math.cos(a) * PLATTER_RADIUS,
		platterY + PLATTER_THICKNESS / 2,
		math.sin(a) * PLATTER_RADIUS
	) * CFrame.Angles(0, -a + math.pi/2, 0)
	AB.block(Vector3.new(chordLen, 1.5, PLATTER_TRIM_W), C.platterTrim, cf, m, "PlatterTrim_" .. i)
end

-- Pedestal foot under the platter so it reads as a display tray, not a slab
local footHeight = 6
AB.cylinder(
	PLATTER_RADIUS * 0.7, footHeight, C.platterFoot,
	CFrame.new(0, -PLATTER_THICKNESS - footHeight / 2, 0),
	m, "PlatterFoot"
)
-- Base disc under foot
AB.cylinder(
	PLATTER_RADIUS * 0.9, 2, C.platterTrim,
	CFrame.new(0, -PLATTER_THICKNESS - footHeight - 1, 0),
	m, "PlatterBase"
)

-- ── Donut builder ────────────────────────────────────────────────────────────
-- Builds a single donut model centered at `donutCF` (local), parented to `m`.
-- Returns its Seat instance.
local function buildDonut(idx: number, donutCF: CFrame, frostingColor: Color3): Seat
	-- Dough ring: 16 box segments forming a torus silhouette
	local doughY = DONUT_HEIGHT / 2  -- bottom of donut sits at platter top (Y=0)
	for s = 1, DONUT_SEGMENTS do
		local a = (s - 1) / DONUT_SEGMENTS * math.pi * 2
		local chordLen = 2 * (DONUT_OUTER_R - DONUT_TUBE_R) * math.tan(math.pi / DONUT_SEGMENTS) + 2
		local segCF = donutCF * CFrame.new(
			math.cos(a) * (DONUT_OUTER_R - DONUT_TUBE_R),
			doughY,
			math.sin(a) * (DONUT_OUTER_R - DONUT_TUBE_R)
		) * CFrame.Angles(0, -a + math.pi/2, 0)
		AB.block(
			Vector3.new(chordLen, DONUT_HEIGHT, DONUT_TUBE_R * 2),
			C.dough, segCF, m, string.format("Donut%d_Dough_%d", idx, s)
		)
	end

	-- Frosting cap: a thinner ring of bright cylinders on top of the dough
	local frostingY = DONUT_HEIGHT + 1
	for s = 1, DONUT_SEGMENTS do
		local a = (s - 1) / DONUT_SEGMENTS * math.pi * 2
		local chordLen = 2 * (DONUT_OUTER_R - DONUT_TUBE_R) * math.tan(math.pi / DONUT_SEGMENTS) + 2
		local segCF = donutCF * CFrame.new(
			math.cos(a) * (DONUT_OUTER_R - DONUT_TUBE_R),
			frostingY,
			math.sin(a) * (DONUT_OUTER_R - DONUT_TUBE_R)
		) * CFrame.Angles(0, -a + math.pi/2, 0)
		AB.block(
			Vector3.new(chordLen, 2, DONUT_TUBE_R * 1.7),
			frostingColor, segCF, m, string.format("Donut%d_Frosting_%d", idx, s)
		)
	end

	-- Sprinkles (12 per donut) scattered on top of the frosting
	for sp = 1, 12 do
		local sa = math.random() * math.pi * 2
		local sr = (DONUT_OUTER_R - DONUT_TUBE_R) + (math.random() - 0.5) * (DONUT_TUBE_R * 1.2)
		local sprCF = donutCF * CFrame.new(
			math.cos(sa) * sr,
			frostingY + 1.5,
			math.sin(sa) * sr
		) * CFrame.Angles(0, math.random() * math.pi, 0)
		local sprColor = SPRINKLE_COLORS[((sp - 1) % #SPRINKLE_COLORS) + 1]
		AB.block(
			Vector3.new(2.2, 0.6, 0.7),
			sprColor, sprCF, m, string.format("Donut%d_Sprinkle_%d", idx, sp)
		)
	end

	-- Inner hole rim (darker dough ring) — purely visual, sits at base of hole
	AB.cylinder(
		DONUT_INNER_R * 2, 1, C.doughDark,
		donutCF * CFrame.new(0, 0.5, 0),
		m, string.format("Donut%d_HoleBase", idx)
	)

	-- ── Seat at the center hole (the rider sits IN the donut) ────────────────
	-- A Seat instance must be a child of the model for RideController.getSeats
	-- to find it. Anchored so spin is purely cosmetic; SeatWeld carries the rider.
	local seat = Instance.new("Seat")
	seat.Name        = "Seat"
	seat.Size        = Vector3.new(6, 1, 6)
	seat.Color       = C.dough
	seat.Material    = Enum.Material.SmoothPlastic
	seat.Anchored    = true
	seat.CanCollide  = true
	seat.TopSurface  = Enum.SurfaceType.Smooth
	seat.BottomSurface = Enum.SurfaceType.Smooth
	-- Place seat at the donut's center hole, top flush with frosting Y so the
	-- player perches in the middle of the donut ring.
	seat.CFrame      = donutCF * CFrame.new(0, DONUT_HEIGHT - 0.5, 0)
	seat.Parent      = m

	-- Tiny chocolate "filling" bump in the hole below seat for visual interest
	AB.sphere(
		DONUT_INNER_R * 1.4, C.frostingChoc,
		donutCF * CFrame.new(0, DONUT_HEIGHT * 0.4, 0),
		m, string.format("Donut%d_Filling", idx)
	)

	return seat
end

-- ── Build 8 donuts in a circle around the platter ────────────────────────────
math.randomseed(8675309)  -- deterministic sprinkle pattern across server restarts

for i = 1, NUM_DONUTS do
	local angle = (i - 1) / NUM_DONUTS * math.pi * 2
	local donutCF = CFrame.new(
		math.cos(angle) * DONUT_RING_RADIUS,
		0,
		math.sin(angle) * DONUT_RING_RADIUS
	) * CFrame.Angles(0, -angle, 0)
	buildDonut(i, donutCF, FROSTING_COLORS[i])
end

-- ── Center decoration: tall whipped-cream dollop at platter center ───────────
do
	-- Three stacked spheres of decreasing size — soft serve look
	AB.sphere(14, C.platterPink, CFrame.new(0, 9, 0), m, "CenterDollop_Base")
	AB.sphere(10, C.platterPink, CFrame.new(0, 18, 0), m, "CenterDollop_Mid")
	AB.sphere(7,  C.platterPink, CFrame.new(0, 25, 0), m, "CenterDollop_Top")
	-- Cherry on top
	AB.sphere(3.5, C.sprinkleA, CFrame.new(0, 30, 0), m, "CenterDollop_Cherry")
	-- Cherry stem
	AB.block(Vector3.new(0.4, 2.5, 0.4),
		Color3.fromRGB(80, 130, 60),
		CFrame.new(0, 32.5, 0),
		m, "CenterDollop_Stem")
end

-- ── Tag structural parts so partCentroid stays locked to ride center ─────────
-- The platter + 8 donuts are the load-bearing geometry; sprinkles/dollop are
-- decoration and must NOT poison the centroid.
platter:AddTag("Structural")
for i = 1, NUM_DONUTS do
	-- Tag at least one dough segment per donut so the centroid sees the 8-fold
	-- symmetric ring rather than just the platter center.
	local seg = m:FindFirstChild(string.format("Donut%d_Dough_1", i))
	if seg then (seg :: BasePart):AddTag("Structural") end
end

-- ── Weld everything to the PrimaryPart ───────────────────────────────────────
AB.weldAll(m)

-- ── Restore original world pivot ─────────────────────────────────────────────
m:PivotTo(originalPivot)

local partCount = 0
for _, d in m:GetDescendants() do
	if d:IsA("BasePart") then partCount += 1 end
end

print(string.format(
	"[RideRebuildTeacupRide] Donut Cups rebuilt: %d parts, 8 seats, platter r=%d, donut d=%d",
	partCount, PLATTER_RADIUS, DONUT_DIAMETER
))
