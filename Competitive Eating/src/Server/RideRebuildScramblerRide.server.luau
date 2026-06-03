-- RideRebuildScramblerRide: rebuilds workspace.ScramblerRide as an eggbeater
-- food-shape ride. Preserves the inner contract RideController.buildScrambler
-- (line 430) reads:
--
--   workspace.ScramblerRide                 -- outer Model (Seats live here)
--     Generated (Folder)
--       ScramblerRide (Model)               -- inner
--         BaseStructure (Model)             -- mixer base; revolves with main
--         Mechanics (Model)
--           Arm_1..Arm_4 (Model)            -- whisks; counter-rotate
--
-- Seats are DIRECT children of the outer model (getSeats reads :GetChildren()),
-- positioned near each egg so RideController's nearest-arm matching binds them
-- to the correct whisk. 2× scale: ~56-stud bowl radius, 30-stud whisks.

local ServerStorage  = game:GetService("ServerStorage")
local ReplicatedStor = game:GetService("ReplicatedStorage")
local AB = require(ReplicatedStor:WaitForChild("Common"):WaitForChild("AssetBuilder"))

task.wait(1)

local m = workspace:FindFirstChild("ScramblerRide") :: Model?
if not m then
	warn("[RideRebuildScramblerRide] workspace.ScramblerRide missing; skipping")
	return
end

local originalPivot = m:GetPivot()

do
	local clone = m:Clone()
	clone.Name   = "ScramblerRide_PreFood_2026-06-03"
	clone.Parent = ServerStorage
end

m:ClearAllChildren()
m.PrimaryPart = nil

-- ── Palette / dimensions (2× scale) ──────────────────────────────────────────
local CHROME_LIGHT = Color3.fromRGB(225, 225, 232)
local CHROME_DARK  = Color3.fromRGB(170, 172, 180)
local CHROME_BLACK = Color3.fromRGB(45, 45, 50)
local DIAL_RED     = Color3.fromRGB(200, 60, 50)
local WHISK_WHITE  = Color3.fromRGB(245, 245, 245)
local EGG_CREAM    = Color3.fromRGB(248, 235, 205)
local EGG_SHADOW   = Color3.fromRGB(220, 200, 165)
local YOLK         = Color3.fromRGB(255, 200, 80)
local BOWL_CERAMIC = Color3.fromRGB(240, 240, 235)
local BOWL_RIM     = Color3.fromRGB(210, 210, 200)

local HUB_RADIUS   = 8
local HUB_HEIGHT   = 6
local ARM_LEN      = 30
local ARM_COUNT    = 4
local EGGS_PER_ARM = 2
local EGG_RADIUS   = 4
local BOWL_RADIUS  = 56
local BOWL_RIM_H   = 5

local baseCF = originalPivot

-- ── Mixing-bowl arena floor ──────────────────────────────────────────────────
do
	-- Inner ceramic floor: a wide thin disc (Cylinder shape with height=1 —
	-- AB.cylinder Z-rotates so the round face ends up perpendicular to world Y).
	AB.cylinder(BOWL_RADIUS * 2 - 4, 1, BOWL_CERAMIC,
		baseCF * CFrame.new(0, 0.5, 0),
		m, "BowlFloor").Material = Enum.Material.Marble

	-- 24 rim segments forming the bowl wall.
	local SEGMENTS = 24
	for i = 1, SEGMENTS do
		local a = (i - 1) / SEGMENTS * math.pi * 2
		local x, z = math.cos(a) * BOWL_RADIUS, math.sin(a) * BOWL_RADIUS
		local seg = AB.block(
			Vector3.new(4, BOWL_RIM_H, BOWL_RADIUS * 2 * math.pi / SEGMENTS + 2),
			BOWL_RIM,
			baseCF * CFrame.new(x, BOWL_RIM_H / 2 + 0.5, z) * CFrame.Angles(0, -a + math.rad(90), 0),
			m, "BowlRim_" .. i)
		seg.Material = Enum.Material.Marble
	end
end

-- ── Generated/ScramblerRide/{BaseStructure, Mechanics} ───────────────────────
local generated     = AB.model("Generated", m)
local inner         = AB.model("ScramblerRide", generated)
local baseStructure = AB.model("BaseStructure", inner)
local mechanics     = AB.model("Mechanics", inner)

local hubCF = baseCF * CFrame.new(0, BOWL_RIM_H + HUB_HEIGHT / 2 + 0.5, 0)

-- Stand-mixer body
AB.cylinder(HUB_RADIUS * 2 + 4, 3, CHROME_DARK,
	baseCF * CFrame.new(0, BOWL_RIM_H + 2, 0),
	baseStructure, "MixerPlinth").Material = Enum.Material.Metal
AB.cylinder(HUB_RADIUS * 2, HUB_HEIGHT, CHROME_LIGHT,
	hubCF, baseStructure, "MixerBody").Material = Enum.Material.Metal
AB.sphere(HUB_RADIUS * 1.7, CHROME_LIGHT,
	hubCF * CFrame.new(0, HUB_HEIGHT / 2 + HUB_RADIUS * 0.4, 0),
	baseStructure, "MixerCap").Material = Enum.Material.Metal
AB.block(
	Vector3.new(HUB_RADIUS * 1.5, HUB_HEIGHT * 0.6, HUB_RADIUS * 2.6),
	CHROME_LIGHT,
	hubCF * CFrame.new(0, HUB_HEIGHT * 0.1, HUB_RADIUS * 0.6),
	baseStructure, "MotorHead").Material = Enum.Material.Metal

-- Speed dial: cylinder axis pointing horizontally outward (along world X).
AB.part({
	name  = "Dial",
	size  = Vector3.new(1.4, 5, 5),
	color = DIAL_RED, material = Enum.Material.SmoothPlastic,
	cf    = hubCF * CFrame.new(HUB_RADIUS * 1.05, 1, 0),
	shape = Enum.PartType.Cylinder,
}, baseStructure)
AB.sphere(2.4, CHROME_BLACK,
	hubCF * CFrame.new(HUB_RADIUS * 1.25, 1, 0),
	baseStructure, "DialKnob").Material = Enum.Material.Metal

-- Power button (neon glow accent)
local btn = AB.sphere(1.8, Color3.fromRGB(255, 80, 80),
	hubCF * CFrame.new(-HUB_RADIUS * 1.05, 0, 0),
	baseStructure, "PowerButton")
AB.neon(btn); AB.glow(btn, Color3.fromRGB(255, 100, 100), 1.2)

-- ── Whisk arms with egg cars at the tips ─────────────────────────────────────
-- Each arm pivots around its own centroid (mid-length). 6-segment curved rod
-- + 2 crossed hoops at the tip + 2 eggs on either side of the tip.

local ARM_Y         = BOWL_RIM_H + HUB_HEIGHT * 0.35
local ARM_TIP_DROP  = 2
local SEAT_Y        = ARM_Y - 1
local seatIndex     = 0

for armIdx = 1, ARM_COUNT do
	local angle      = (armIdx - 1) / ARM_COUNT * math.pi * 2
	local cosA, sinA = math.cos(angle), math.sin(angle)
	local arm        = AB.model("Arm_" .. armIdx, mechanics)

	-- Whisk rod: parabolic dip from hub edge to outer tip.
	local SEG = 6
	for s = 0, SEG - 1 do
		local t0, t1 = s / SEG, (s + 1) / SEG
		local r0, r1 = HUB_RADIUS * 0.85 + ARM_LEN * t0, HUB_RADIUS * 0.85 + ARM_LEN * t1
		local d0     = -ARM_TIP_DROP * (4 * t0 * (1 - t0))
		local d1     = -ARM_TIP_DROP * (4 * t1 * (1 - t1))
		local p0     = baseCF.Position + Vector3.new(cosA * r0, ARM_Y + d0, sinA * r0)
		local p1     = baseCF.Position + Vector3.new(cosA * r1, ARM_Y + d1, sinA * r1)
		local mid    = (p0 + p1) / 2
		local len    = (p1 - p0).Magnitude
		local seg = AB.part({
			name  = "WhiskRod_" .. armIdx .. "_" .. s,
			size  = Vector3.new(len + 0.3, 0.7, 0.7),
			color = WHISK_WHITE, material = Enum.Material.Metal,
			cf    = CFrame.new(mid, p1),
			shape = Enum.PartType.Cylinder,
		}, arm)
		seg.CFrame = CFrame.new(mid, p1) * CFrame.Angles(0, math.rad(90), 0)
	end

	-- Crossed whisk hoops at the tip.
	local tipR   = HUB_RADIUS * 0.85 + ARM_LEN
	local tipPos = baseCF.Position + Vector3.new(cosA * tipR, ARM_Y - ARM_TIP_DROP, sinA * tipR)
	for ring = 1, 2 do
		local hoopCF = CFrame.new(tipPos)
			* CFrame.Angles(0, angle, math.rad(45) * (ring == 1 and 1 or -1))
		local hoop = AB.part({
			name  = "WhiskHoop_" .. armIdx .. "_" .. ring,
			size  = Vector3.new(0.6, EGG_RADIUS * 2.6, EGG_RADIUS * 2.6),
			color = WHISK_WHITE, material = Enum.Material.Metal,
			cf    = hoopCF, shape = Enum.PartType.Cylinder,
		}, arm)
		hoop.Transparency = 0.15
	end

	-- 2 eggs offset perpendicular to the arm direction.
	local perp = Vector3.new(-sinA, 0, cosA)
	for eIdx = 1, EGGS_PER_ARM do
		local side   = (eIdx == 1) and 1 or -1
		local eggPos = tipPos + perp * (EGG_RADIUS * 1.1 * side)

		AB.part({
			name  = "Egg_" .. armIdx .. "_" .. eIdx,
			size  = Vector3.new(EGG_RADIUS * 1.9, EGG_RADIUS * 2.4, EGG_RADIUS * 1.9),
			color = EGG_CREAM, material = Enum.Material.SmoothPlastic,
			cf    = CFrame.new(eggPos), shape = Enum.PartType.Ball,
		}, arm)
		AB.part({
			name  = "EggShadow_" .. armIdx .. "_" .. eIdx,
			size  = Vector3.new(EGG_RADIUS * 1.5, EGG_RADIUS * 0.5, EGG_RADIUS * 1.5),
			color = EGG_SHADOW, material = Enum.Material.SmoothPlastic,
			cf    = CFrame.new(eggPos + Vector3.new(0, -EGG_RADIUS * 0.7, 0)),
			shape = Enum.PartType.Ball,
		}, arm)
		AB.part({
			name  = "EggYolk_" .. armIdx .. "_" .. eIdx,
			size  = Vector3.new(1.4, 1.4, 1.4),
			color = YOLK, material = Enum.Material.Neon,
			cf    = CFrame.new(eggPos + Vector3.new(0, EGG_RADIUS * 1.05, 0)),
			shape = Enum.PartType.Ball,
		}, arm)

		-- Seat for this egg (direct child of outer model).
		seatIndex += 1
		local seat = Instance.new("Seat")
		seat.Name        = "Seat_" .. seatIndex
		seat.Size        = Vector3.new(3, 1, 3)
		seat.Color       = EGG_CREAM
		seat.Material    = Enum.Material.SmoothPlastic
		seat.Anchored    = true
		seat.CanCollide  = true
		seat.TopSurface  = Enum.SurfaceType.Smooth
		seat.CFrame      = CFrame.new(eggPos.X, SEAT_Y + 0.5, eggPos.Z)
		seat.Parent      = m
	end
end

-- ── Finalise: PrimaryParts, welds, restore pivot ─────────────────────────────
do
	local anyPart: BasePart? = nil
	for _, d in m:GetDescendants() do
		if d:IsA("BasePart") then anyPart = d :: BasePart; break end
	end
	if anyPart then m.PrimaryPart = anyPart end
end

-- BaseStructure pivots as one body.
do
	local root = baseStructure:FindFirstChildWhichIsA("BasePart")
	if root then
		baseStructure.PrimaryPart = root
		AB.weldAll(baseStructure)
	end
end

-- Each arm group welded rigidly.
for _, arm in mechanics:GetChildren() do
	if arm:IsA("Model") then
		local root = arm:FindFirstChildWhichIsA("BasePart")
		if root then
			arm.PrimaryPart = root
			AB.weldAll(arm)
		end
	end
end

m:PivotTo(originalPivot)

print(string.format(
	"[RideRebuildScramblerRide] rebuilt as eggbeater: %d arms, %d seats",
	ARM_COUNT, seatIndex))
