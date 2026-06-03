-- RideRebuildMiniTrain: rebuild workspace.MiniTrain as a Hot Dog Train.
-- v1.0 static prop (no RideController coupling). Oval track ~110×150 stud
-- (2× current). Engine = grilled hot dog with mustard smokestack; 2 bun cars.
-- Follows RIDE_REBUILD_PLAYBOOK universal contract (clone→clear→build→weld→pivot).

local ServerStorage    = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AB = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetBuilder"))

task.wait(1) -- let peer rebuild scripts settle

local m = workspace:FindFirstChild("MiniTrain")
if not m then
	warn("[RideRebuildMiniTrain] workspace.MiniTrain not found — skipping rebuild")
	return
end

local originalPivot = m:GetPivot()

local backup = m:Clone()
backup.Name = "MiniTrain_PreFood_2026-06-03"
backup.Parent = ServerStorage

m:ClearAllChildren()
m.PrimaryPart = nil

-- ── Palette ─────────────────────────────────────────────────────────────────
local C = AB.colors
local SAUSAGE      = Color3.fromRGB(150, 75, 45)    -- grilled hot dog brown-red
local SAUSAGE_DARK = Color3.fromRGB(110, 55, 35)    -- grill char
local BUN_TAN      = C.bunTan
local BUN_LIGHT    = Color3.fromRGB(240, 200, 145)
local MUSTARD      = C.mustard
local KETCHUP      = C.ketchup
local IRON         = Color3.fromRGB(70, 70, 80)
local IRON_DARK    = Color3.fromRGB(45, 45, 55)
local TIE_WOOD     = C.deepWood
local GRILL_MARK   = Color3.fromRGB(180, 130, 70)
local STEAM_WHITE  = Color3.fromRGB(245, 240, 235)

-- ── Track geometry (oval, built in local space; PivotTo applied at end) ────
local TRACK_RX = 55      -- X radius (half of 110)
local TRACK_RZ = 75      -- Z radius (half of 150)
local TIE_COUNT = 40
local TIE_LEN   = 8      -- tie length along track-normal direction
local TIE_W     = 1.4    -- tie width along travel direction
local TIE_H     = 0.6
local RAIL_H    = 0.5
local RAIL_W    = 0.4
local RAIL_GAUGE = 5     -- distance between rails
local TIE_Y     = 0.3

local function ovalPos(theta: number): Vector3
	return Vector3.new(math.cos(theta) * TRACK_RX, 0, math.sin(theta) * TRACK_RZ)
end

local function ovalTangent(theta: number): Vector3
	return Vector3.new(-math.sin(theta) * TRACK_RX, 0, math.cos(theta) * TRACK_RZ).Unit
end

-- Track-center anchor — PrimaryPart so PivotTo lands track-center at originalPivot.
local anchor = AB.part({
	size = Vector3.new(2, 0.2, 2),
	color = Color3.fromRGB(80, 80, 80),
	cf = CFrame.new(0, -0.5, 0),
	name = "TrackCenter",
	transparency = 1,
	canCollide = false,
}, m)

local trackFolder = Instance.new("Folder")
trackFolder.Name = "Track"
trackFolder.Parent = m

-- Wooden ties (one per segment).
for i = 1, TIE_COUNT do
	local theta = (i / TIE_COUNT) * math.pi * 2
	local pos = ovalPos(theta) + Vector3.new(0, TIE_Y, 0)
	local tangent = ovalTangent(theta)
	-- Orient tie so its long axis is perpendicular to travel direction.
	local look = Vector3.new(-tangent.Z, 0, tangent.X) -- 90° rotated tangent
	local cf = CFrame.lookAt(pos, pos + look)
	AB.block(Vector3.new(TIE_W, TIE_H, TIE_LEN), TIE_WOOD, cf, trackFolder, "Tie_" .. i)
end

-- Iron rails (inner + outer) — segmented blocks following the ellipse.
local RAIL_SEGS = 48
for i = 1, RAIL_SEGS do
	local t0 = ((i - 1) / RAIL_SEGS) * math.pi * 2
	local t1 = (i        / RAIL_SEGS) * math.pi * 2
	local p0 = ovalPos(t0)
	local p1 = ovalPos(t1)
	local mid = (p0 + p1) / 2
	local segLen = (p1 - p0).Magnitude + 0.3 -- overlap so no gaps
	local tangent = (p1 - p0).Unit
	local normal = Vector3.new(-tangent.Z, 0, tangent.X)
	for _, side in ipairs({-1, 1}) do
		local pos = mid + normal * (side * RAIL_GAUGE / 2) + Vector3.new(0, TIE_Y + TIE_H/2 + RAIL_H/2, 0)
		local cf = CFrame.lookAt(pos, pos + tangent)
		AB.block(Vector3.new(RAIL_W, RAIL_H, segLen), IRON, cf, trackFolder, "Rail_" .. i .. "_" .. (side == -1 and "L" or "R"))
	end
end

-- ── Engine: grilled hot dog with mustard smokestack ────────────────────────
local ENGINE_THETA = -math.pi / 2 -- south point of ellipse
local enginePos = ovalPos(ENGINE_THETA) + Vector3.new(0, TIE_Y + TIE_H/2 + RAIL_H + 2.5, 0)
local engineCF = CFrame.lookAt(enginePos, enginePos + ovalTangent(ENGINE_THETA))

local engine = Instance.new("Model")
engine.Name = "Engine"
engine.Parent = m

-- Sausage body — cylinder lying along travel direction (+Z of engineCF).
-- Native Roblox Cylinder long-axis is +X; rotate 90° about Y so X → Z.
local SAUSAGE_LEN = 18
local SAUSAGE_DIA = 5
local body = AB.part({
	size = Vector3.new(SAUSAGE_LEN, SAUSAGE_DIA, SAUSAGE_DIA),
	color = SAUSAGE,
	cf = engineCF * CFrame.Angles(0, math.rad(90), 0),
	shape = Enum.PartType.Cylinder,
	name = "Body",
}, engine)
engine.PrimaryPart = body

-- Rounded sausage ends (spheres at each cap).
AB.sphere(SAUSAGE_DIA, SAUSAGE, engineCF * CFrame.new(0, 0,  SAUSAGE_LEN/2), engine, "BodyEndFront")
AB.sphere(SAUSAGE_DIA, SAUSAGE, engineCF * CFrame.new(0, 0, -SAUSAGE_LEN/2), engine, "BodyEndRear")

-- Mustard zigzag stripes across the top.
for i = 1, 5 do
	local zOff = -SAUSAGE_LEN/2 + (i - 0.5) * (SAUSAGE_LEN / 5)
	local sign = (i % 2 == 0) and 1 or -1
	AB.block(Vector3.new(1.4, 0.5, 2.6), MUSTARD,
		engineCF * CFrame.new(0.6 * sign, SAUSAGE_DIA/2 - 0.1, zOff) * CFrame.Angles(0, math.rad(20 * sign), 0),
		engine, "MustardStripe_" .. i)
end

-- Grill marks — dark stripes on the underside.
for i = 1, 4 do
	AB.block(Vector3.new(SAUSAGE_DIA * 0.9, 0.2, 0.6), SAUSAGE_DARK,
		engineCF * CFrame.new(0, -SAUSAGE_DIA/2 + 0.2, -SAUSAGE_LEN/2 + i * (SAUSAGE_LEN / 5)),
		engine, "GrillMark_" .. i)
end

-- Mustard smokestack — yellow cylinder rising from the front-top of the dog.
local STACK_DIA = 2.4
local STACK_HEIGHT = 6
local stackPos = engineCF * CFrame.new(0, SAUSAGE_DIA/2 + STACK_HEIGHT/2, SAUSAGE_LEN/2 - 3)
AB.cylinder(STACK_DIA, STACK_HEIGHT, MUSTARD, stackPos, engine, "Smokestack")
-- Stack cap rim.
AB.cylinder(STACK_DIA * 1.2, 0.6, SAUSAGE_DARK,
	engineCF * CFrame.new(0, SAUSAGE_DIA/2 + STACK_HEIGHT - 0.3, SAUSAGE_LEN/2 - 3),
	engine, "SmokestackRim")
-- Frozen steam puff above stack.
AB.sphere(3.5, STEAM_WHITE,
	engineCF * CFrame.new(0, SAUSAGE_DIA/2 + STACK_HEIGHT + 1.5, SAUSAGE_LEN/2 - 3),
	engine, "SteamPuff")

-- Cowcatcher front nub (ketchup-bottle red).
AB.block(Vector3.new(SAUSAGE_DIA * 0.6, 1.2, 1.5), KETCHUP,
	engineCF * CFrame.new(0, -SAUSAGE_DIA/2 + 0.8, SAUSAGE_LEN/2 + 1.2),
	engine, "Cowcatcher")

-- Engine wheels — 4 dark iron discs along the underside (axle ±X of engineCF).
local function wheel(parent: Instance, cf: CFrame, dia: number, thickness: number, n: string)
	AB.part({
		size = Vector3.new(thickness, dia, dia),
		color = IRON_DARK,
		cf = cf,
		shape = Enum.PartType.Cylinder,
		name = n,
	}, parent)
end
for i = 1, 4 do
	local zOff = -SAUSAGE_LEN/2 + 2.5 + (i - 1) * 4.5
	for _, side in ipairs({-1, 1}) do
		wheel(engine,
			engineCF * CFrame.new(side * 2.2, -SAUSAGE_DIA/2 - 0.4, zOff),
			2.4, 0.6,
			"EngineWheel_" .. i .. (side == -1 and "L" or "R"))
	end
end

-- ── Passenger cars: 2 buns ─────────────────────────────────────────────────
local CAR_LEN = 12
local CAR_W   = 5
local CAR_H   = 3.5
local CAR_SPACING = 5 -- gap between consecutive units

local function buildBunCar(carIndex: number)
	-- Approximate arc-length placement: step theta back from the engine using
	-- mean ellipse radius. Good enough for a static-prop visual queue.
	local arcOff = SAUSAGE_LEN/2 + CAR_SPACING + (carIndex - 0.5) * (CAR_LEN + CAR_SPACING)
	local avgR   = (TRACK_RX + TRACK_RZ) / 2
	local theta  = ENGINE_THETA - (arcOff / avgR)
	local pos = ovalPos(theta) + Vector3.new(0, TIE_Y + TIE_H/2 + RAIL_H + CAR_H/2 + 0.5, 0)
	local tangent = ovalTangent(theta)
	local cf = CFrame.lookAt(pos, pos + tangent)

	local car = Instance.new("Model")
	car.Name = "BunCar_" .. carIndex
	car.Parent = m

	-- Bun body — puffy block + sphere ends.
	local bunBody = AB.block(Vector3.new(CAR_W, CAR_H, CAR_LEN), BUN_TAN, cf, car, "BunBody")
	car.PrimaryPart = bunBody
	AB.sphere(CAR_W, BUN_TAN, cf * CFrame.new(0, 0,  CAR_LEN/2), car, "BunEndFront")
	AB.sphere(CAR_W, BUN_TAN, cf * CFrame.new(0, 0, -CAR_LEN/2), car, "BunEndRear")

	-- Lighter top crown + toasted grill stripes.
	AB.block(Vector3.new(CAR_W * 0.9, 0.8, CAR_LEN * 0.95), BUN_LIGHT,
		cf * CFrame.new(0, CAR_H/2 + 0.2, 0), car, "BunCrown")
	for i = 1, 4 do
		AB.block(Vector3.new(CAR_W * 0.85, 0.3, 0.5), GRILL_MARK,
			cf * CFrame.new(0, CAR_H/2 + 0.6, -CAR_LEN/2 + i * (CAR_LEN / 5)),
			car, "BunGrillMark_" .. i)
	end

	-- 2 seats per car — Seat instances let players sit on the static prop.
	for s = 1, 2 do
		local seat = Instance.new("Seat")
		seat.Name = "Seat_" .. s
		seat.Size = Vector3.new(2, 0.6, 2)
		seat.Color = SAUSAGE
		seat.Material = Enum.Material.SmoothPlastic
		seat.Anchored = true
		seat.TopSurface = Enum.SurfaceType.Smooth
		seat.BottomSurface = Enum.SurfaceType.Smooth
		seat.CFrame = cf * CFrame.new(0, CAR_H/2 + 0.5, -CAR_LEN/2 + s * (CAR_LEN / 3))
		seat.Parent = car
	end

	-- Wheels — 4 dark iron discs.
	for i = 1, 4 do
		local zOff = -CAR_LEN/2 + 2 + (i - 1) * 2.7
		for _, side in ipairs({-1, 1}) do
			wheel(car,
				cf * CFrame.new(side * (CAR_W/2 - 0.2), -CAR_H/2 - 0.4, zOff),
				2.2, 0.5,
				"CarWheel_" .. i .. (side == -1 and "L" or "R"))
		end
	end

	return car
end

buildBunCar(1)
buildBunCar(2)

-- ── Finalize ───────────────────────────────────────────────────────────────
-- AB.weldAll on m welds every BasePart descendant (incl. those in sub-Models
-- like Engine, BunCar_*) to the anchor PrimaryPart. One pass is sufficient.
m.PrimaryPart = anchor
AB.weldAll(m)
m:PivotTo(originalPivot)

print(string.format("[RideRebuildMiniTrain] rebuilt — %d descendants", #m:GetDescendants()))
