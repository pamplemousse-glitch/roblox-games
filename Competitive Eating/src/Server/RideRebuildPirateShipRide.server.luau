-- RideRebuildPirateShipRide → BANANA BOAT (2× footprint).
-- Pendulum mechanic preserved: PrimaryPart=Body, 6 Seat_1..Seat_6 kept.
-- A-frame + axle + hull spine tagged "Structural" so partCentroid() ignores
-- decorative banana segments, ripe spots, sail, peel.
-- New pivotY (~56) documented in RIDE_PirateShipRide_INTEGRATION.md.

local ServerStorage    = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AB = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetBuilder"))

task.wait(1) -- let other rebuild scripts land too

local ship = workspace:FindFirstChild("PirateShipRide") :: Model?
if not ship then
	warn("[RideRebuildPirateShipRide] workspace.PirateShipRide missing — skipping")
	return
end

-- ── 1. Back up the pre-food ride ─────────────────────────────────────────────
local originalPivot = ship:GetPivot()
do
	local clone = ship:Clone()
	clone.Name = "PirateShipRide_PreFood_2026-06-03"
	clone.Parent = ServerStorage
end
ship:ClearAllChildren()
ship.PrimaryPart = nil

-- ── 2. Palette (banana + tropical accents) ──────────────────────────────────
local C = {
	bananaYellow  = Color3.fromRGB(248, 220, 60),
	bananaShade   = Color3.fromRGB(225, 195, 35),
	bananaTip     = Color3.fromRGB(120, 90, 30),
	ripeSpot      = Color3.fromRGB(95, 60, 25),
	peelGreen     = Color3.fromRGB(80, 165, 60),
	leafGreen     = Color3.fromRGB(60, 140, 50),
	leafDark      = Color3.fromRGB(40, 105, 35),
	gold          = Color3.fromRGB(220, 180, 60),
	mastBrown     = Color3.fromRGB(120, 75, 35),
	frameWood     = Color3.fromRGB(85, 55, 30),
	seatRed       = Color3.fromRGB(180, 35, 45),
}

-- World layout. Original ship at world position ≈ (-80, 0, 0) per
-- FranksStringLights. We rebuild around the model origin and PivotTo at the
-- end, so coordinates here are LOCAL to ship.
-- 2× footprint horizontal, but axle stays at ~28 stud so the boat hangs
-- close to the ground instead of suspended at Y=56+. Visible to player
-- without binoculars.
local HULL_LENGTH   = 50    -- X (long axis)
local HULL_WIDTH    = 12    -- Z
local HULL_HEIGHT   = 6     -- Y
local SEGMENTS      = 9     -- segmented blocks → faint curve
local AXLE_Y        = 28    -- mechanical axle world-Y MUST match RideController pivotY
local DECK_Y        = 6     -- top of hull

local shipCF = CFrame.new(originalPivot.Position)

-- Helper: a small ripe-spot stuck to hull side.
local function ripeSpot(parent: Instance, x: number, y: number, zSide: number)
	local p = AB.part({
		size  = Vector3.new(1.2, 1.2, 0.4),
		color = C.ripeSpot,
		cf    = shipCF * CFrame.new(x, y, zSide),
		shape = Enum.PartType.Ball,
		name  = "RipeSpot",
		canCollide = false,
	}, parent)
	p.Size = Vector3.new(math.random(20, 40)/10, math.random(15, 30)/10, 0.4)
end

-- ── 3. Hull: curved banana via 9 segmented blocks ───────────────────────────
-- Curve: Y = baseY + sag * sin(t*pi). Banana sags slightly in the middle.
local HULL_SAG = 4
local function buildHull()
	for i = 1, SEGMENTS do
		local t        = (i - 1) / (SEGMENTS - 1)            -- 0..1
		local centerT  = t - 0.5                              -- -0.5..0.5
		local x        = centerT * HULL_LENGTH
		-- Banana droops at the ends, peaks in the middle.
		local ySag     = -HULL_SAG * math.cos(centerT * math.pi)
		-- Banana tapers at both ends.
		local taper    = 1 - 0.55 * (math.abs(centerT) * 2)^2
		local segLen   = HULL_LENGTH / SEGMENTS
		local segH     = HULL_HEIGHT * taper
		local segW     = HULL_WIDTH  * taper

		local isEnd = (i == 1 or i == SEGMENTS)
		local segCol = isEnd and C.bananaTip or (i % 2 == 0 and C.bananaShade or C.bananaYellow)

		local seg = AB.part({
			size = Vector3.new(segLen + 0.4, segH, segW),
			color = segCol,
			cf   = shipCF * CFrame.new(x, ySag, 0),
			name = "HullSeg_" .. i,
		}, ship)
		seg:AddTag("Structural")

		-- Decorative ripe spots on a few mid segments (untagged).
		if i >= 3 and i <= 7 and i % 2 == 1 then
			ripeSpot(ship, x, ySag + 1, segW / 2 + 0.1)
			ripeSpot(ship, x + 1.5, ySag, -segW / 2 - 0.1)
		end
	end
end
buildHull()

-- ── 4. "Body" — the canonical PrimaryPart spine of the banana ───────────────
-- Thin invisible spar running the hull length at deck height. Used by
-- pendulum animator (RideController sets baseCF at axle, then pivots).
local body = AB.part({
	size = Vector3.new(HULL_LENGTH - 2, 1, HULL_WIDTH - 2),
	color = C.bananaYellow,
	cf    = shipCF * CFrame.new(0, DECK_Y - 2, 0),
	name  = "Body",
	transparency = 1,
	canCollide = false,
}, ship)
body:AddTag("Structural")
ship.PrimaryPart = body

-- ── 5. Peeled stern: open peel curling up at the back ───────────────────────
local function peelStrip(xBase: number, zSide: number, name: string)
	for i = 1, 4 do
		local up = i * 1.5
		local out = i * 0.7 * (zSide > 0 and 1 or -1)
		AB.part({
			size = Vector3.new(2.5, 4, 1.6),
			color = (i % 2 == 0) and C.bananaYellow or C.peelGreen,
			cf = shipCF * CFrame.new(xBase + i * 1.2, DECK_Y - 1 + up, zSide + out)
				* CFrame.Angles(0, 0, math.rad(zSide > 0 and 15 or -15) * i),
			name = name .. "_" .. i,
		}, ship)
	end
end
peelStrip( HULL_LENGTH / 2 - 4,  HULL_WIDTH / 2 - 1, "PeelR")
peelStrip( HULL_LENGTH / 2 - 4, -HULL_WIDTH / 2 + 1, "PeelL")
peelStrip( HULL_LENGTH / 2 - 6,  0,                 "PeelCenter")

-- ── 6. Mast + palm-leaf sail ────────────────────────────────────────────────
local mastBase = shipCF * CFrame.new(0, DECK_Y, 0)
AB.cylinder(2, 28, C.mastBrown, mastBase * CFrame.new(0, 14, 0), ship, "Mast")

-- Palm fronds: 6 elongated wedges in a star pattern at the top.
for i = 1, 6 do
	local angle = (i - 1) * (math.pi * 2 / 6)
	local len = 14
	local frondCF = mastBase * CFrame.new(0, 26, 0)
		* CFrame.Angles(0, angle, 0)
		* CFrame.new(0, 0, -len / 2)
		* CFrame.Angles(math.rad(-15), 0, 0)
	AB.part({
		size = Vector3.new(7, 0.6, len),
		color = i % 2 == 0 and C.leafGreen or C.leafDark,
		cf    = frondCF,
		name  = "Frond_" .. i,
	}, ship)
end

-- Coconut cluster at the mast crown.
for i = 1, 3 do
	local a = (i - 1) * math.pi * 2 / 3
	AB.sphere(2.4, C.frameWood,
		mastBase * CFrame.new(math.cos(a) * 1.4, 25, math.sin(a) * 1.4),
		ship, "Coconut_" .. i)
end

-- ── 7. Gold trim along hull rim ─────────────────────────────────────────────
for i = -1, 1, 2 do
	AB.part({
		size = Vector3.new(HULL_LENGTH - 4, 0.6, 0.8),
		color = C.gold,
		cf    = shipCF * CFrame.new(0, DECK_Y - 0.8, i * (HULL_WIDTH / 2 + 0.2)),
		material = Enum.Material.Metal,
		reflectance = 0.3,
		name  = "GoldTrim_" .. (i == 1 and "R" or "L"),
	}, ship)
end
AB.part({
	size = Vector3.new(HULL_LENGTH - 6, 0.3, HULL_WIDTH - 4),
	color = C.gold,
	cf    = shipCF * CFrame.new(0, DECK_Y - 0.2, 0),
	material = Enum.Material.Metal,
	reflectance = 0.25,
	name  = "DeckTrim",
}, ship)

-- ── 8. 6 Seats along the deck, named Seat_1..Seat_6 ─────────────────────────
local SEAT_SPACING = (HULL_LENGTH - 14) / 5
for i = 1, 6 do
	local x = -(HULL_LENGTH - 14) / 2 + (i - 1) * SEAT_SPACING
	local seat = Instance.new("Seat")
	seat.Name        = "Seat_" .. i
	seat.Size        = Vector3.new(3, 1, 4)
	seat.Color       = C.seatRed
	seat.Material    = Enum.Material.SmoothPlastic
	seat.Anchored    = true
	seat.CanCollide  = true
	seat.CFrame      = shipCF * CFrame.new(x, DECK_Y + 0.5, 0)
	seat.Parent      = ship

	-- Seat back so riders read as seated, not floating.
	AB.part({
		size = Vector3.new(0.8, 3, 4),
		color = C.frameWood,
		cf    = shipCF * CFrame.new(x - 1.6, DECK_Y + 2, 0),
		name  = "SeatBack_" .. i,
	}, ship)
end

-- ── 9. Two swing arms (axle → hull) ─────────────────────────────────────────
for _, side in {-1, 1} do
	local armLen = AXLE_Y - DECK_Y
	local arm = AB.part({
		size = Vector3.new(1.2, armLen, 1.2),
		color = C.frameWood,
		cf    = shipCF * CFrame.new(0, DECK_Y + armLen / 2, side * (HULL_WIDTH / 2 - 1)),
		name  = "SwingArm_" .. (side == 1 and "R" or "L"),
	}, ship)
	arm:AddTag("Structural")
end

-- ── 10. Axle bar at the top of the swing arms ───────────────────────────────
local axle = AB.part({
	size = Vector3.new(1.4, 1.4, HULL_WIDTH + 4),
	color = C.gold,
	cf    = shipCF * CFrame.new(0, AXLE_Y, 0),
	material = Enum.Material.Metal,
	reflectance = 0.4,
	name  = "Axle",
}, ship)
axle:AddTag("Structural")

-- ── 11. A-frame static supports (tagged Structural) ─────────────────────────
-- Two A-frame triangles, fore and aft, each meeting at the axle ends.
local A_FRAME_BASE     = 28                   -- foot spread along Z
local A_FRAME_OFFSET_X = HULL_LENGTH / 2 + 8  -- forward / aft offset

local function aFrame(xPos: number, label: string)
	for _, side in {-1, 1} do
		local footZ = side * (A_FRAME_BASE / 2)
		-- Compute angled leg from foot up to axle midpoint.
		local foot  = Vector3.new(xPos, 0, footZ)
		local top   = Vector3.new(xPos, AXLE_Y, 0)
		local mid   = (foot + top) / 2
		local diff  = top - foot
		local len   = diff.Magnitude
		-- Build leg as a long block; orient by lookAt from foot toward top.
		local cf = CFrame.lookAt(mid, mid + diff.Unit) * CFrame.Angles(math.rad(90), 0, 0)
		local leg = AB.part({
			size = Vector3.new(1.8, len, 1.8),
			color = C.frameWood,
			cf    = shipCF * cf,
			material = Enum.Material.Wood,
			name  = "AFrame_" .. label .. "_" .. (side == 1 and "R" or "L"),
		}, ship)
		leg:AddTag("Structural")
	end
	-- Horizontal crossbeam between feet for rigidity.
	AB.part({
		size = Vector3.new(2, 1.4, A_FRAME_BASE),
		color = C.frameWood,
		cf    = shipCF * CFrame.new(xPos, 1, 0),
		material = Enum.Material.Wood,
		name  = "AFrame_" .. label .. "_Base",
	}, ship):AddTag("Structural")
end

aFrame( A_FRAME_OFFSET_X, "Fore")
aFrame(-A_FRAME_OFFSET_X, "Aft")

-- ── 12. Weld + restore pivot ────────────────────────────────────────────────
AB.weldAll(ship)
ship:PivotTo(originalPivot)

print(string.format(
	"[RideRebuildPirateShipRide] Rebuilt as Banana Boat — %d parts, PrimaryPart=Body, pivotY target ≈ %d",
	#ship:GetDescendants(), AXLE_Y))
