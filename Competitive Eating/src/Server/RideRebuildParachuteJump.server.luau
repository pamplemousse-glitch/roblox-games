--!strict
-- RideRebuildParachuteJump: idempotent food-shape rebuild for the
-- ParachuteJump ride → "Lollipop Drop". Central giant pretzel-twist tower with
-- 8 disc-lollipop "parachutes" rising and falling around it (red/white striped
-- discs on white sticks, with rider seats hanging below).
--
-- Hard contract preserved (RideController.luau lines 665-690, 895-921):
--   * workspace.ParachuteJump stays a Model (we ClearAllChildren, never destroy).
--   * For each chute idx 1..8, the per-frame loop translates every BasePart
--     whose name matches: ^Chute[A-Za-z]+<idx>$ | ^ChuteS<idx>_%d+$ | ^ChutFrame<idx>$
--     All chute-attached parts use those exact patterns. The central tower,
--     deco, and ground use names that do NOT match (no trailing digit) so they
--     stay static.
--   * Chutes are built at their TOP Y (183). RideController captures
--     originalPos = top, then offsets down by (TOP - BOTTOM = 176) studs.
--
-- Scale: 2× original footprint. Central tower ~200 studs tall, chutes orbit at
-- radius ~50 studs.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage     = game:GetService("ServerStorage")

local AB = require(ReplicatedStorage.Common.AssetBuilder)

local TOP_Y      = 183           -- must match PARACHUTE_TOP_Y
local BOTTOM_Y   = 7             -- must match PARACHUTE_BOTTOM_Y
local CHUTE_COUNT = 8
local CHUTE_ORBIT_R = 50         -- 2× original

local PRETZEL    = Color3.fromRGB(140,  90,  45)   -- darker pretzel brown
local PRETZEL_HI = Color3.fromRGB(180, 130,  70)   -- AB.colors.pretzelBrown
local SALT       = Color3.fromRGB(240, 235, 220)
local STICK      = Color3.fromRGB(250, 248, 240)
local LOLLI_RED  = Color3.fromRGB(220,  45,  55)
local LOLLI_WHT  = Color3.fromRGB(250, 245, 240)
local SEAT_COL   = Color3.fromRGB(80,  35,  35)
local GROUND     = Color3.fromRGB(230, 215, 200)

task.wait(1)

local m = workspace:FindFirstChild("ParachuteJump") :: Model?
if not m then
	warn("[RideRebuildParachuteJump] workspace.ParachuteJump missing — skipping rebuild")
	return
end

-- Capture original pivot before clearing so the new build lands in the same spot.
local originalPivot = m:GetPivot()

-- 1) Backup
do
	local clone = m:Clone()
	clone.Name  = "ParachuteJump_PreFood_2026-06-03"
	clone.Parent = ServerStorage
end

-- 2) Clear children (preserve the Model instance)
m:ClearAllChildren()
m.PrimaryPart = nil

local centerCF = CFrame.new(0, 0, 0)   -- build at origin, PivotTo at end

-- ── Ground pad (pastel candy-shop floor) ─────────────────────────────────────
local pad = AB.cylinder(140, 1.5, GROUND,
	centerCF * CFrame.new(0, BOTTOM_Y - 1, 0), m, "GroundPad")
pad.Material = Enum.Material.SmoothPlastic

-- Decorative sprinkle ring on the pad
for i = 1, 24 do
	local ang = (i / 24) * math.pi * 2
	local r   = 55
	local sx, sz = math.cos(ang) * r, math.sin(ang) * r
	local col = ({LOLLI_RED, LOLLI_WHT, Color3.fromRGB(255,200,80), Color3.fromRGB(120,200,120)})[((i - 1) % 4) + 1]
	AB.block(Vector3.new(2, 0.6, 0.8), col,
		centerCF * CFrame.new(sx, BOTTOM_Y - 0.1, sz) * CFrame.Angles(0, -ang, 0),
		m, "PadSprinkle")
end

-- ── Central pretzel-twist tower ──────────────────────────────────────────────
-- Tower: stacked "rope" rings — 3 thick cylinders per slice, rotated through
-- 360° to fake a braid. ~24 slices over ~200 studs.
local TOWER_BASE_Y   = BOTTOM_Y - 0.5
local TOWER_TOP_Y    = TOP_Y + 14
local TOWER_HEIGHT   = TOWER_TOP_Y - TOWER_BASE_Y         -- ~190
local SLICES         = 26
local SLICE_H        = TOWER_HEIGHT / SLICES
local BRAID_R        = 5.5
local BRAID_THICK    = 4.5

for s = 0, SLICES - 1 do
	local y = TOWER_BASE_Y + (s + 0.5) * SLICE_H
	-- 3 strands offset 120° each, slice angle advances → twisted braid look.
	local twist = math.rad(s * 28)
	for strand = 0, 2 do
		local ang = twist + math.rad(strand * 120)
		local x   = math.cos(ang) * BRAID_R
		local z   = math.sin(ang) * BRAID_R
		local col = (strand % 2 == 0) and PRETZEL or PRETZEL_HI
		local p = AB.cylinder(BRAID_THICK, BRAID_THICK + 0.5, col,
			centerCF * CFrame.new(x, y, z),
			m, "TowerBraid")
		p.Material = Enum.Material.SmoothPlastic
	end
end

-- Pretzel knots: oversized loops at base, middle, and top for "this is a pretzel" silhouette.
local function pretzelKnot(yPos: number, outerR: number, ringName: string)
	local segments = 18
	for i = 1, segments do
		local a = (i / segments) * math.pi * 2
		local x = math.cos(a) * outerR
		local z = math.sin(a) * outerR
		local p = AB.cylinder(6, 7, PRETZEL,
			centerCF * CFrame.new(x, yPos, z) * CFrame.Angles(0, -a, 0),
			m, ringName)
		p.Material = Enum.Material.SmoothPlastic
	end
end

pretzelKnot(TOWER_BASE_Y + 6,                12, "TowerKnotBase")
pretzelKnot(TOWER_BASE_Y + TOWER_HEIGHT/2,   11, "TowerKnotMid")
pretzelKnot(TOWER_TOP_Y - 6,                 14, "TowerKnotTop")

-- Salt sprinkles on the knots
for i = 1, 36 do
	local a = math.rad(i * 10 + 7)
	local r = (i % 3 == 0) and 14 or 12
	local y = TOWER_BASE_Y + 6 + ((i % 3) * 0.7)
	AB.sphere(0.9, SALT,
		centerCF * CFrame.new(math.cos(a) * r, y, math.sin(a) * r), m, "SaltGrainBase")
end
for i = 1, 28 do
	local a = math.rad(i * 13 + 4)
	AB.sphere(1.0, SALT,
		centerCF * CFrame.new(math.cos(a) * 16, TOWER_TOP_Y - 6 + ((i % 3) * 0.5), math.sin(a) * 16),
		m, "SaltGrainTop")
end

-- Top cap so the tower silhouette closes
local towerCap = AB.sphere(10, PRETZEL,
	centerCF * CFrame.new(0, TOWER_TOP_Y + 3, 0), m, "TowerCap")
towerCap.Material = Enum.Material.SmoothPlastic

-- Tower "core" sentinel — visible cylinder INSIDE the tower (not used as
-- PrimaryPart because AB.cylinder bakes a 90° Z rotation that would force
-- PivotTo to un-rotate the entire model). Use an invisible identity anchor
-- as PrimaryPart.
local towerCore = AB.cylinder(2, TOWER_HEIGHT, Color3.fromRGB(60, 30, 20),
	centerCF * CFrame.new(0, (TOWER_BASE_Y + TOWER_TOP_Y) / 2, 0), m, "TowerCore")
towerCore.Transparency = 1
towerCore.CanCollide   = false
local pivotAnchor = AB.part({
	size         = Vector3.new(0.1, 0.1, 0.1),
	color        = Color3.new(1, 1, 1),
	cf           = centerCF,
	canCollide   = false,
	transparency = 1,
	name         = "PivotAnchor",
}, m)
m.PrimaryPart = pivotAnchor

-- ── 8 lollipop chutes ───────────────────────────────────────────────────────
-- Each chute is a vertical assembly built at TOP position; RideController
-- captures top Y, then offsets each part down per frame.
--
-- Parts that move with chute idx (regex-matched):
--   ChuteBasket<idx>  → disc head (lollipop candy)
--   ChuteFrame<idx>   → stick (cylinder above the disc)
--   ChuteRider<idx>   → Seat hanging below the disc
--   ChuteS<idx>_1..6  → striping rings on the disc
--   ChuteD<idx>       → decorative dome on disc top
--
-- Anything NOT matching those patterns stays static (tower, ground, deco).

local function buildLollipop(idx: number)
	local ang = ((idx - 1) / CHUTE_COUNT) * math.pi * 2
	local cx, cz = math.cos(ang) * CHUTE_ORBIT_R, math.sin(ang) * CHUTE_ORBIT_R
	local discY  = TOP_Y                            -- top of cycle (disc center)
	-- Rider seat sits ON TOP of the disc (the lollipop is the platform).
	-- discY + disc-half-height (1.25) + seat-half-height (0.5) = +1.75
	local seatY  = discY + 2.5
	local stickY = discY + 11                       -- stick rises above seat/disc

	-- Disc head (the candy puck): big flat cylinder oriented horizontally.
	local disc = AB.part({
		size  = Vector3.new(2.5, 22, 22),           -- 22-stud diameter disc, 2.5 tall
		color = LOLLI_RED,
		cf    = centerCF * CFrame.new(cx, discY, cz),
		shape = Enum.PartType.Cylinder,
		name  = "ChuteBasket" .. idx,               -- regex match → moves with chute
	}, m)
	disc.Material = Enum.Material.SmoothPlastic
	-- Roblox cylinder shape extrudes along X; rotate so flat face points up.
	disc.CFrame = centerCF * CFrame.new(cx, discY, cz) * CFrame.Angles(0, 0, math.rad(90))

	-- Spiral stripes — nested rings on the disc face. Smaller rings sit
	-- progressively higher (0.2 stud each) so all are visible from above
	-- instead of being occluded by the outermost ring.
	for s = 1, 6 do
		local stripeR = 22 - (s - 1) * 3            -- outer→inner: 22, 19, 16, 13, 10, 7
		local col     = (s % 2 == 0) and LOLLI_WHT or LOLLI_RED
		local stripeY = discY + 1.3 + (s - 1) * 0.22
		local topStripe = AB.part({
			size  = Vector3.new(0.4, stripeR, stripeR),
			color = col,
			shape = Enum.PartType.Cylinder,
			name  = "ChuteS" .. idx .. "_" .. s,    -- regex match → moves
		}, m)
		topStripe.Material = Enum.Material.SmoothPlastic
		topStripe.CFrame = centerCF * CFrame.new(cx, stripeY, cz) * CFrame.Angles(0, 0, math.rad(90))
	end

	-- Dome on top center (the candy's glossy bubble)
	local dome = AB.sphere(7, LOLLI_RED,
		centerCF * CFrame.new(cx, discY + 3.5, cz), m, "ChuteD" .. idx)
	dome.Material    = Enum.Material.SmoothPlastic
	dome.Reflectance = 0.05

	-- Stick — white cylinder above the disc (looks like a lollipop handle
	-- pointing skyward, also reads as the "cable" connecting to the carriage above).
	local stick = AB.cylinder(2.4, 18, STICK,
		centerCF * CFrame.new(cx, stickY, cz),
		m, "ChuteFrame" .. idx)                     -- regex match → moves
	stick.Material = Enum.Material.SmoothPlastic

	-- Rider seat: sits on top face of the disc (the lollipop IS the carriage).
	-- Keeping the seat above the disc guarantees it stays above ground at the
	-- bottom of the fall cycle (disc bottom Y=5.75, seat Y=9.5 at bottom).
	local seat = Instance.new("Seat")
	seat.Name        = "ChuteRider" .. idx          -- regex match → moves
	seat.Size        = Vector3.new(4, 1, 4)
	seat.Color       = SEAT_COL
	seat.Material    = Enum.Material.SmoothPlastic
	seat.Anchored    = true
	seat.CanCollide  = true
	seat.CFrame      = centerCF * CFrame.new(cx, seatY, cz)
	seat.TopSurface  = Enum.SurfaceType.Smooth
	seat.Parent      = m

	-- Decorative "basket rim" hanging just below the disc — gives the
	-- parachute-basket silhouette without dropping the actual seat underground.
	-- Names use a different "Chute<word><idx>" pattern (ChuteRim<idx>) so they
	-- match the regex and translate with the chute.
	for r = 0, 3 do
		local ra = math.rad(r * 90)
		local rx, rz = math.cos(ra) * 9, math.sin(ra) * 9
		local rim = AB.block(
			Vector3.new(0.6, 4, 0.6),
			SEAT_COL,
			centerCF * CFrame.new(cx + rx, discY - 2.5, cz + rz),
			m,
			"ChuteRim" .. idx
		)
		rim.Material = Enum.Material.Fabric
	end
end

for i = 1, CHUTE_COUNT do
	buildLollipop(i)
end

-- ── Finalize ────────────────────────────────────────────────────────────────
AB.weldAll(m)
-- IMPORTANT: anchorAll happens at RideController init; weldAll attached
-- everything to towerCore, but each frame the chutes use Position assignment
-- so welds to anchored parts only matter for any non-chute deco. All parts
-- are anchored anyway (AB.part defaults). Welds are harmless safety.

m:PivotTo(originalPivot)

print(("[RideRebuildParachuteJump] Rebuilt %d-chute Lollipop Drop (%d descendants)"):format(
	CHUTE_COUNT, #m:GetDescendants()))
