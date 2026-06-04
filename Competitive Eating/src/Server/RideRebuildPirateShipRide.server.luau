-- RideRebuildPirateShipRide → CLASSIC BELLE-ÉPOQUE PIRATE GALLEON.
-- Replaces the food-shape Banana Boat. Pendulum mechanic preserved:
--   PrimaryPart = invisible identity-rotation PivotAnchor (NEVER a cylinder).
--   6 Seat_1..Seat_6 along the deck. "Body" kept as named structural hull part.
--   Axle world-Y=28 → matches RideController.PENDULUM_RIDES.PirateShipRide.pivotY.
-- Hull / keel / Body / mast / swing arms / axle / A-frame tagged "Structural"
-- so partCentroid() ignores decorative trim/sails/figurehead.

local ServerStorage     = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AB = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetBuilder"))

task.wait(1)

local ship = workspace:FindFirstChild("PirateShipRide") :: Model?
if not ship then
	warn("[RideRebuildPirateShipRide] workspace.PirateShipRide missing — skipping")
	return
end

-- ── 1. Back up the pre-Belle-Époque ride ────────────────────────────────────
local originalPivot = ship:GetPivot()
do
	local clone = ship:Clone()
	clone.Name   = "PirateShipRide_PreBelleEpoque_2026-06-03"
	clone.Parent = ServerStorage
end
ship:ClearAllChildren()
ship.PrimaryPart = nil

-- ── 2. Belle-Époque palette ─────────────────────────────────────────────────
local C = {
	burgundy    = Color3.fromRGB(130, 30, 50),
	ivory       = Color3.fromRGB(245, 235, 205),
	gold        = Color3.fromRGB(200, 160, 80),
	deepWood    = Color3.fromRGB(110, 75, 45),
	iron        = Color3.fromRGB(40, 35, 40),
	cream       = Color3.fromRGB(230, 215, 180),
	crimsonGlow = Color3.fromRGB(220, 60, 70),
}

-- ── 3. PivotAnchor FIRST (mandatory pattern) ────────────────────────────────
local pivotAnchor = AB.part({
	size = Vector3.new(0.1, 0.1, 0.1), color = Color3.new(1, 1, 1),
	cf = CFrame.new(0, 0, 0), canCollide = false, transparency = 1,
	name = "PivotAnchor",
}, ship)
ship.PrimaryPart = pivotAnchor

local O = CFrame.new(0, 0, 0)

-- ── 4. Dimensions ───────────────────────────────────────────────────────────
local HULL_LENGTH = 50
local HULL_WIDTH  = 14
local HULL_HEIGHT = 7
local DECK_Y      = 6
local AXLE_Y      = 28   -- matches controller pivotY

-- ── 5. Hull (tapered planked galleon, structural) ───────────────────────────
local SEGMENTS = 9
for i = 1, SEGMENTS do
	local t       = (i - 1) / (SEGMENTS - 1)
	local centerT = t - 0.5
	local x       = centerT * HULL_LENGTH
	local sternFavor = 1 - 0.55 * (math.max(centerT, 0) * 2) ^ 1.6
	local bowFavor   = 1 - 0.40 * (math.max(-centerT, 0) * 2) ^ 1.6
	local taper      = math.min(sternFavor, bowFavor)
	local segLen     = HULL_LENGTH / SEGMENTS + 0.5
	local segH       = HULL_HEIGHT * taper
	local segW       = HULL_WIDTH  * taper
	local color      = (i % 2 == 0) and C.deepWood or C.burgundy
	local seg = AB.part({
		size = Vector3.new(segLen, segH, segW), color = color,
		material = Enum.Material.WoodPlanks,
		cf = O * CFrame.new(x, segH / 2, 0), name = "HullSeg_" .. i,
	}, ship)
	seg:AddTag("Structural")
end

local keel = AB.part({
	size = Vector3.new(HULL_LENGTH + 2, 1.2, 2.2), color = C.deepWood,
	material = Enum.Material.Wood, cf = O * CFrame.new(0, -0.4, 0), name = "Keel",
}, ship)
keel:AddTag("Structural")

AB.part({
	size = Vector3.new(HULL_LENGTH - 4, 0.5, HULL_WIDTH - 2.5), color = C.cream,
	material = Enum.Material.WoodPlanks, cf = O * CFrame.new(0, DECK_Y, 0), name = "Deck",
}, ship)

-- ── 6. "Body" — named structural hull part (NOT PrimaryPart) ────────────────
local body = AB.part({
	size = Vector3.new(HULL_LENGTH - 4, 1, HULL_WIDTH - 4), color = C.burgundy,
	cf = O * CFrame.new(0, DECK_Y - 1.5, 0), name = "Body",
	transparency = 1, canCollide = false,
}, ship)
body:AddTag("Structural")

-- ── 7. Bow figurehead + stern castle + lantern ──────────────────────────────
AB.part({ size = Vector3.new(8, 1.2, 1.2), color = C.deepWood,
	material = Enum.Material.Wood, cf = O * CFrame.new(HULL_LENGTH / 2 + 3, DECK_Y + 1, 0),
	name = "Bowsprit" }, ship)
AB.part({ size = Vector3.new(2.2, 3, 2.2), color = C.ivory,
	material = Enum.Material.Marble, cf = O * CFrame.new(HULL_LENGTH / 2 + 1.4, DECK_Y + 0.5, 0),
	name = "FigureheadBody" }, ship)
AB.sphere(2, C.ivory, O * CFrame.new(HULL_LENGTH / 2 + 1.4, DECK_Y + 2.6, 0), ship, "FigureheadHead")
AB.part({ size = Vector3.new(1.2, 0.6, 2.4), color = C.gold,
	material = Enum.Material.Metal, reflectance = 0.3,
	cf = O * CFrame.new(HULL_LENGTH / 2 + 1.4, DECK_Y + 3.4, 0), name = "FigureheadCrown" }, ship)

AB.part({ size = Vector3.new(8, 4, HULL_WIDTH - 4), color = C.burgundy,
	material = Enum.Material.WoodPlanks,
	cf = O * CFrame.new(-HULL_LENGTH / 2 + 4, DECK_Y + 2, 0), name = "SternCastle" }, ship)
AB.part({ size = Vector3.new(1.5, 2, 1.5), color = C.gold,
	material = Enum.Material.Metal,
	cf = O * CFrame.new(-HULL_LENGTH / 2 + 2, DECK_Y + 5.5, 0), name = "SternLantern" }, ship)
AB.glow(AB.part({
	size = Vector3.new(0.8, 1, 0.8), color = C.crimsonGlow, material = Enum.Material.Neon,
	cf = O * CFrame.new(-HULL_LENGTH / 2 + 2, DECK_Y + 5.5, 0),
	name = "SternLanternGlow", canCollide = false,
}, ship), C.crimsonGlow, 2)

-- ── 8. Gold rim + railing posts ─────────────────────────────────────────────
for _, side in {-1, 1} do
	AB.part({ size = Vector3.new(HULL_LENGTH - 4, 0.5, 0.7), color = C.gold,
		material = Enum.Material.Metal, reflectance = 0.3,
		cf = O * CFrame.new(0, DECK_Y + 0.4, side * (HULL_WIDTH / 2 - 1)),
		name = "GoldRim_" .. (side == 1 and "R" or "L") }, ship)
	for k = -3, 3 do
		AB.part({ size = Vector3.new(0.4, 1.6, 0.4), color = C.deepWood,
			cf = O * CFrame.new(k * 6, DECK_Y + 1.2, side * (HULL_WIDTH / 2 - 1)),
			name = "RailPost" }, ship)
	end
end

-- ── 9. Mast + sail + crow's nest + burgundy pennant ─────────────────────────
local MAST_BASE_Y = DECK_Y + 0.5
local MAST_H      = 22
local mast = AB.part({
	size = Vector3.new(1.6, MAST_H, 1.6), color = C.deepWood,
	material = Enum.Material.Wood,
	cf = O * CFrame.new(0, MAST_BASE_Y + MAST_H / 2, 0), name = "Mast",
}, ship)
mast:AddTag("Structural")

AB.part({ size = Vector3.new(18, 0.8, 0.8), color = C.deepWood,
	material = Enum.Material.Wood,
	cf = O * CFrame.new(0, MAST_BASE_Y + MAST_H * 0.65, 0), name = "Yardarm" }, ship)

local SAIL_W, SAIL_H = 16, 10
local sailCY = MAST_BASE_Y + MAST_H * 0.45
for i = 1, 3 do
	local stripe = (i == 2) and C.burgundy or C.ivory
	AB.part({ size = Vector3.new(SAIL_W, SAIL_H / 3, 0.3), color = stripe,
		material = Enum.Material.Fabric,
		cf = O * CFrame.new(0, sailCY + (i - 2) * (SAIL_H / 3), 0.6),
		name = "Sail_" .. i }, ship)
end

AB.cylinder(4, 1.2, C.cream, O * CFrame.new(0, MAST_BASE_Y + MAST_H - 1, 0), ship, "CrowsNest")
AB.part({ size = Vector3.new(0.3, 1.6, 5), color = C.burgundy,
	material = Enum.Material.Fabric,
	cf = O * CFrame.new(0, MAST_BASE_Y + MAST_H + 1, 2.5), name = "Pennant" }, ship)
AB.part({ size = Vector3.new(0.3, 0.4, 1.5), color = C.gold,
	material = Enum.Material.Metal,
	cf = O * CFrame.new(0, MAST_BASE_Y + MAST_H + 2, 0.75), name = "PennantPole" }, ship)

-- ── 10. Six Seat_1..Seat_6 (RideController contract) ───────────────────────
local SEAT_SPAN    = HULL_LENGTH - 18
local SEAT_SPACING = SEAT_SPAN / 5
for i = 1, 6 do
	local x = -SEAT_SPAN / 2 + (i - 1) * SEAT_SPACING
	local seat = Instance.new("Seat")
	seat.Name = "Seat_" .. i
	seat.Size = Vector3.new(3, 1, 4)
	seat.Color = C.deepWood
	seat.Material = Enum.Material.WoodPlanks
	seat.Anchored = true
	seat.CanCollide = true
	seat.CFrame = O * CFrame.new(x, DECK_Y + 0.8, 0)
	seat.Parent = ship

	AB.part({ size = Vector3.new(0.8, 3, 4), color = C.ivory,
		material = Enum.Material.WoodPlanks,
		cf = O * CFrame.new(x - 1.6, DECK_Y + 2.4, 0), name = "SeatBack_" .. i }, ship)
	AB.part({ size = Vector3.new(0.9, 0.4, 4), color = C.gold,
		material = Enum.Material.Metal, reflectance = 0.3,
		cf = O * CFrame.new(x - 1.6, DECK_Y + 3.9, 0), name = "SeatTrim_" .. i }, ship)
end

-- ── 11. Swing arms (deck → axle) ────────────────────────────────────────────
for _, side in {-1, 1} do
	local armLen = AXLE_Y - DECK_Y
	local arm = AB.part({
		size = Vector3.new(1.4, armLen, 1.4), color = C.iron,
		material = Enum.Material.Metal,
		cf = O * CFrame.new(0, DECK_Y + armLen / 2, side * (HULL_WIDTH / 2 - 1)),
		name = "SwingArm_" .. (side == 1 and "R" or "L"),
	}, ship)
	arm:AddTag("Structural")
end

-- ── 12. Axle ────────────────────────────────────────────────────────────────
local axle = AB.part({
	size = Vector3.new(1.6, 1.6, HULL_WIDTH + 6), color = C.gold,
	material = Enum.Material.Metal, reflectance = 0.4,
	cf = O * CFrame.new(0, AXLE_Y, 0), name = "Axle",
}, ship)
axle:AddTag("Structural")

-- ── 13. A-frame supports fore + aft ─────────────────────────────────────────
local A_FRAME_BASE     = 30
local A_FRAME_OFFSET_X = HULL_LENGTH / 2 + 9

local function aFrame(xPos: number, label: string)
	for _, side in {-1, 1} do
		local footZ = side * (A_FRAME_BASE / 2)
		local foot  = Vector3.new(xPos, 0, footZ)
		local top   = Vector3.new(xPos, AXLE_Y, 0)
		local mid   = (foot + top) / 2
		local diff  = top - foot
		local len   = diff.Magnitude
		local cf    = CFrame.lookAt(mid, mid + diff.Unit) * CFrame.Angles(math.rad(90), 0, 0)
		local leg = AB.part({
			size = Vector3.new(2, len, 2), color = C.deepWood,
			material = Enum.Material.Wood, cf = O * cf,
			name = "AFrame_" .. label .. "_" .. (side == 1 and "R" or "L"),
		}, ship)
		leg:AddTag("Structural")
		AB.part({ size = Vector3.new(2.4, 0.6, 2.4), color = C.gold,
			material = Enum.Material.Metal, reflectance = 0.3,
			cf = O * CFrame.new(xPos, AXLE_Y - 0.6, footZ * 0.05),
			name = "AFrameRivet_" .. label }, ship)
	end
	local base = AB.part({
		size = Vector3.new(2.4, 1.6, A_FRAME_BASE + 2), color = C.deepWood,
		material = Enum.Material.Wood,
		cf = O * CFrame.new(xPos, 0.8, 0),
		name = "AFrame_" .. label .. "_Base",
	}, ship)
	base:AddTag("Structural")
end
aFrame( A_FRAME_OFFSET_X, "Fore")
aFrame(-A_FRAME_OFFSET_X, "Aft")

-- ── 14. Weld + restore pivot ────────────────────────────────────────────────
AB.weldAll(ship)
ship:PivotTo(originalPivot)

print(string.format(
	"[RideRebuildPirateShipRide] Rebuilt as Belle-Époque Galleon — %d parts, PrimaryPart=PivotAnchor, axleY=%d",
	#ship:GetDescendants(), AXLE_Y))
