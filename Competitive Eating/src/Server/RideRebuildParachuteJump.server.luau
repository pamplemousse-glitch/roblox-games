--!strict
-- RideRebuildParachuteJump: Belle-Époque "Classic Parachute Drop" rebuild
-- replacing the prior Lollipop Drop food-shape. Tall central deep_wood +
-- antique_gold lattice tower (NOT a pretzel). 8 ivory parachute canopies with
-- burgundy stripes, each with a rider Seat hanging below.
--
-- HARD contract preserved (RideController.luau ~lines 685-711, 942-961):
--   * workspace.ParachuteJump stays a Model (ClearAllChildren, never destroy).
--   * For each chute idx 1..8, the per-frame loop translates every BasePart
--     whose name matches the regex (RideController.luau:700):
--       ^Chute[A-Za-z]+<idx>$    -- ChuteBasket<i>, ChuteFrame<i>, ChuteRider<i>,
--                                   ChuteD<i>, ChuteCanopy<i>, ChuteRope<i>, etc.
--       ^ChuteS<idx>_%d+$        -- ChuteS<i>_1..N stripes
--       ^ChutFrame<idx>$         -- legacy alias
--     Anything NOT matching those patterns (tower, ground, deco, PivotAnchor)
--     stays static.
--   * Chutes are built at their TOP Y (PARACHUTE_TOP_Y=183). RideController
--     captures originalPos = top, then offsets down by (TOP - BOTTOM = 176).
--
-- Scale: 2× horizontal footprint. TOP_Y / BOTTOM_Y preserved.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage     = game:GetService("ServerStorage")

local AB = require(ReplicatedStorage.Common.AssetBuilder)

-- ── Constants RideController depends on — DO NOT CHANGE ─────────────────────
local TOP_Y      = 183           -- must match PARACHUTE_TOP_Y
local BOTTOM_Y   = 7             -- must match PARACHUTE_BOTTOM_Y
local CHUTE_COUNT = 8
local CHUTE_ORBIT_R = 50         -- 2× horizontal of original 25

-- ── Belle-Époque palette ────────────────────────────────────────────────────
local DEEP_WOOD     = Color3.fromRGB( 80,  50,  30)   -- tower main timber
local DEEP_WOOD_HI  = Color3.fromRGB(105,  70,  45)   -- highlighted timber
local ANTIQUE_GOLD  = Color3.fromRGB(195, 155,  70)   -- lattice + rivets
local ANTIQUE_GOLD2 = Color3.fromRGB(225, 185,  90)   -- bright gold cap
local IVORY         = Color3.fromRGB(230, 220, 195)   -- canopy base
local BURGUNDY      = Color3.fromRGB(110,  30,  40)   -- canopy stripes + accents
local CRIMSON_GLOW  = Color3.fromRGB(170,  45,  55)   -- accent stripes
local SEAT_COL      = Color3.fromRGB( 70,  35,  35)   -- rider seat leather
local ROPE_COL      = Color3.fromRGB(160, 130,  90)   -- canopy ropes
local GROUND        = Color3.fromRGB(195, 180, 155)   -- packed dirt pad

task.wait(1)

local m = workspace:FindFirstChild("ParachuteJump") :: Model?
if not m then
	warn("[RideRebuildParachuteJump] workspace.ParachuteJump missing — skipping rebuild")
	return
end

-- Capture original pivot so the new build lands in the same spot.
local originalPivot = m:GetPivot()

-- 1) Backup
do
	local clone = m:Clone()
	clone.Name  = "ParachuteJump_PreClassic_2026-06-03"
	clone.Parent = ServerStorage
end

-- 2) Clear children (preserve the Model instance)
m:ClearAllChildren()
m.PrimaryPart = nil

local centerCF = CFrame.new(0, 0, 0)   -- build at origin, PivotTo at end

-- ── Ground pad (carnival packed earth) ──────────────────────────────────────
local pad = AB.cylinder(140, 1.5, GROUND,
	centerCF * CFrame.new(0, BOTTOM_Y - 1, 0), m, "GroundPad")
pad.Material = Enum.Material.Slate

-- Antique-gold ring inlay around the pad
for i = 1, 32 do
	local ang = (i / 32) * math.pi * 2
	local r   = 62
	local sx, sz = math.cos(ang) * r, math.sin(ang) * r
	local plaque = AB.block(Vector3.new(3, 0.3, 1.2),
		ANTIQUE_GOLD,
		centerCF * CFrame.new(sx, BOTTOM_Y - 0.1, sz) * CFrame.Angles(0, -ang, 0),
		m, "PadInlay")
	plaque.Material = Enum.Material.Metal
end

-- ── Central lattice tower (deep_wood + antique_gold) ────────────────────────
-- Belle-Époque ironwork-meets-timber lattice: 4 main corner posts plus diagonal
-- braces forming X-shapes between horizontal ring beams. Tower runs from
-- BOTTOM_Y - 0.5 up to TOP_Y + 14 (silhouette caps above the topmost canopy).

local TOWER_BASE_Y = BOTTOM_Y - 0.5
local TOWER_TOP_Y  = TOP_Y + 14
local TOWER_HEIGHT = TOWER_TOP_Y - TOWER_BASE_Y       -- ~190

local POST_R         = 12         -- corner-post radius from center axis
local POST_THICK     = 2.8
local RING_COUNT     = 9          -- horizontal ring beams (incl. base + top)
local RING_SPACING   = TOWER_HEIGHT / (RING_COUNT - 1)

-- 4 main corner posts (deep_wood, slight taper via stacked segments)
for corner = 0, 3 do
	local ang = math.rad(corner * 90 + 45)
	local cx, cz = math.cos(ang) * POST_R, math.sin(ang) * POST_R
	-- One tall cylinder; capped by sphere finials at base + top.
	local post = AB.cylinder(POST_THICK, TOWER_HEIGHT, DEEP_WOOD,
		centerCF * CFrame.new(cx, TOWER_BASE_Y + TOWER_HEIGHT / 2, cz),
		m, "TowerPost")
	post.Material = Enum.Material.Wood
	-- Gold base finial
	local finialB = AB.sphere(POST_THICK + 1, ANTIQUE_GOLD,
		centerCF * CFrame.new(cx, TOWER_BASE_Y + 0.5, cz), m, "TowerPostFinialBase")
	finialB.Material = Enum.Material.Metal
	-- Gold top finial
	local finialT = AB.sphere(POST_THICK + 1, ANTIQUE_GOLD2,
		centerCF * CFrame.new(cx, TOWER_TOP_Y - 0.5, cz), m, "TowerPostFinialTop")
	finialT.Material = Enum.Material.Metal
end

-- Horizontal ring beams (antique_gold) connecting the 4 posts, one per ring level.
for ringIdx = 0, RING_COUNT - 1 do
	local ringY = TOWER_BASE_Y + ringIdx * RING_SPACING
	for side = 0, 3 do
		local angA = math.rad(side * 90 + 45)
		local angB = math.rad((side + 1) * 90 + 45)
		local ax, az = math.cos(angA) * POST_R, math.sin(angA) * POST_R
		local bx, bz = math.cos(angB) * POST_R, math.sin(angB) * POST_R
		local midX, midZ = (ax + bx) / 2, (az + bz) / 2
		local span = math.sqrt((bx - ax) ^ 2 + (bz - az) ^ 2)
		local yaw = math.atan2(bz - az, bx - ax)
		local beam = AB.block(
			Vector3.new(span, 1.2, 1.2),
			ANTIQUE_GOLD,
			centerCF * CFrame.new(midX, ringY, midZ) * CFrame.Angles(0, -yaw, 0),
			m, "TowerRingBeam")
		beam.Material = Enum.Material.Metal
	end
end

-- Diagonal X-braces (deep_wood_hi) between each pair of ring beams on each face.
for ringIdx = 0, RING_COUNT - 2 do
	local yLo = TOWER_BASE_Y + ringIdx * RING_SPACING
	local yHi = yLo + RING_SPACING
	for side = 0, 3 do
		local angA = math.rad(side * 90 + 45)
		local angB = math.rad((side + 1) * 90 + 45)
		local ax, az = math.cos(angA) * POST_R, math.sin(angA) * POST_R
		local bx, bz = math.cos(angB) * POST_R, math.sin(angB) * POST_R
		-- Brace 1: bottom-A → top-B
		-- Brace 2: bottom-B → top-A
		local pairs_ = {
			{a = Vector3.new(ax, yLo, az), b = Vector3.new(bx, yHi, bz)},
			{a = Vector3.new(bx, yLo, bz), b = Vector3.new(ax, yHi, az)},
		}
		for _, pp in pairs_ do
			local mid = (pp.a + pp.b) / 2
			local delta = pp.b - pp.a
			local len = delta.Magnitude
			-- Orient: align block X to delta direction
			local lookAt = CFrame.lookAt(pp.a, pp.b)
			local cf = CFrame.new(mid) * lookAt.Rotation
				* CFrame.Angles(0, math.rad(90), 0)
			local brace = AB.block(
				Vector3.new(len, 0.7, 0.7),
				DEEP_WOOD_HI,
				centerCF * cf,
				m, "TowerBrace")
			brace.Material = Enum.Material.Wood
		end
	end
end

-- Gold rivet studs at each post/ring intersection (decor)
for ringIdx = 0, RING_COUNT - 1 do
	local ringY = TOWER_BASE_Y + ringIdx * RING_SPACING
	for corner = 0, 3 do
		local ang = math.rad(corner * 90 + 45)
		local cx, cz = math.cos(ang) * POST_R, math.sin(ang) * POST_R
		local rivet = AB.sphere(1.2, ANTIQUE_GOLD2,
			centerCF * CFrame.new(cx, ringY, cz), m, "TowerRivet")
		rivet.Material = Enum.Material.Metal
	end
end

-- Decorative top crown: gold finial sphere + spire
local crownBase = AB.cylinder(8, 2, ANTIQUE_GOLD,
	centerCF * CFrame.new(0, TOWER_TOP_Y + 1, 0), m, "TowerCrownBase")
crownBase.Material = Enum.Material.Metal

local crownBall = AB.sphere(6, ANTIQUE_GOLD2,
	centerCF * CFrame.new(0, TOWER_TOP_Y + 5, 0), m, "TowerCrownBall")
crownBall.Material    = Enum.Material.Metal
crownBall.Reflectance = 0.1

local crownSpire = AB.cylinder(0.8, 10, ANTIQUE_GOLD2,
	centerCF * CFrame.new(0, TOWER_TOP_Y + 12, 0), m, "TowerCrownSpire")
crownSpire.Material = Enum.Material.Metal
-- The cylinder builder bakes a 90°Z rotation that points X up; re-orient so the
-- spire is vertical (Y up). Match by setting CFrame after creation.
crownSpire.CFrame = centerCF * CFrame.new(0, TOWER_TOP_Y + 12, 0)

-- Invisible PivotAnchor at origin so PivotTo lands cleanly (no baked rotation).
local pivotAnchor = AB.part({
	size         = Vector3.new(0.1, 0.1, 0.1),
	color        = Color3.new(1, 1, 1),
	cf           = centerCF,
	canCollide   = false,
	transparency = 1,
	name         = "PivotAnchor",
}, m)
m.PrimaryPart = pivotAnchor

-- ── 8 parachute canopies + rider seats ──────────────────────────────────────
-- Built at TOP positions. RideController captures top Y, then per frame offsets
-- each part down by (TOP_Y - BOTTOM_Y) on the phase cycle.
--
-- Parts that move with chute idx (regex-matched):
--   ChuteCanopy<idx>     → ivory canopy dome (the parachute)
--   ChuteCrown<idx>      → small top vent disk (cap on canopy)
--   ChuteFrame<idx>      → vertical cable from canopy to seat (cylinder)
--   ChuteRider<idx>      → Seat hanging below canopy
--   ChuteBasket<idx>     → wooden seat-back / basket the rider sits in
--   ChuteRopeA/B/C/D<idx> → 4 suspension cords (canopy → basket corners)
--   ChuteS<idx>_1..N     → burgundy stripe panels on the canopy

local CANOPY_R       = 9            -- canopy half-width
local CANOPY_H       = 7            -- canopy dome height
local SEAT_DROP      = 14           -- distance from canopy bottom to seat top
local STRIPE_COUNT   = 8            -- burgundy stripe panels per canopy

local function buildChute(idx: number)
	local ang = ((idx - 1) / CHUTE_COUNT) * math.pi * 2
	local cx, cz = math.cos(ang) * CHUTE_ORBIT_R, math.sin(ang) * CHUTE_ORBIT_R

	-- Y positions at TOP of cycle
	local canopyY = TOP_Y                        -- canopy dome center
	local cableY  = canopyY - SEAT_DROP * 0.5    -- middle of cable
	local seatY   = canopyY - SEAT_DROP          -- rider seat
	local basketY = seatY - 1.2                  -- basket frame under seat

	-- Canopy dome (ivory hemisphere via flattened sphere)
	local canopy = AB.part({
		size  = Vector3.new(CANOPY_R * 2, CANOPY_H * 2, CANOPY_R * 2),
		color = IVORY,
		cf    = centerCF * CFrame.new(cx, canopyY, cz),
		shape = Enum.PartType.Ball,
		name  = "ChuteCanopy" .. idx,
	}, m)
	canopy.Material = Enum.Material.Fabric

	-- Top vent / crown disk
	local crown = AB.part({
		size  = Vector3.new(0.6, 4, 4),
		color = BURGUNDY,
		cf    = centerCF * CFrame.new(cx, canopyY + CANOPY_H * 0.85, cz)
			* CFrame.Angles(0, 0, math.rad(90)),
		shape = Enum.PartType.Cylinder,
		name  = "ChuteCrown" .. idx,
	}, m)
	crown.Material = Enum.Material.Fabric

	-- Burgundy stripe panels — radial slices around the canopy underside.
	-- Each stripe is a flat narrow block angled outward from the canopy axis.
	for s = 1, STRIPE_COUNT do
		local sa = ((s - 1) / STRIPE_COUNT) * math.pi * 2
		local sr = CANOPY_R * 0.78
		local sx, sz = math.cos(sa) * sr, math.sin(sa) * sr
		local stripeCol = (s % 2 == 0) and BURGUNDY or CRIMSON_GLOW
		local stripe = AB.block(
			Vector3.new(1.6, CANOPY_H * 1.1, 3.6),
			stripeCol,
			centerCF * CFrame.new(cx + sx, canopyY + 0.6, cz + sz)
				* CFrame.Angles(0, -sa, math.rad(12)),
			m,
			"ChuteS" .. idx .. "_" .. s)
		stripe.Material = Enum.Material.Fabric
	end

	-- Suspension cords: 4 ropes from canopy underside → basket corners
	local ROPE_R    = CANOPY_R * 0.55
	local ropeMidY  = (canopyY - CANOPY_H * 0.3 + basketY) / 2
	local ropeLen   = (canopyY - CANOPY_H * 0.3) - basketY
	local ropeSuffixes = {"A", "B", "C", "D"}
	for r = 0, 3 do
		local ra = math.rad(r * 90 + 45)
		local rx, rz = math.cos(ra) * ROPE_R, math.sin(ra) * ROPE_R
		-- Diagonal rope: from canopy edge inward to basket corner. Rendered
		-- as a thin vertical cylinder. Names use ChuteRope{A,B,C,D}<idx> so
		-- the RideController regex `^Chute[A-Za-z]+<idx>$` matches each one
		-- (the underscore-numeric suffix variant is reserved for ChuteS<i>_N).
		local rope = AB.cylinder(0.4, ropeLen, ROPE_COL,
			centerCF * CFrame.new(cx + rx, ropeMidY, cz + rz),
			m, "ChuteRope" .. ropeSuffixes[r + 1] .. idx)
		rope.Material = Enum.Material.Fabric
	end

	-- Central cable (the visible structural cable connecting to the lattice
	-- guide rail — preserves the ChuteFrame<idx> name the RideController reads).
	local cableLen = (canopyY - CANOPY_H * 0.3) - seatY
	local cable = AB.cylinder(0.6, cableLen, ANTIQUE_GOLD,
		centerCF * CFrame.new(cx, cableY, cz),
		m, "ChuteFrame" .. idx)
	cable.Material = Enum.Material.Metal

	-- Basket frame (deep_wood crate under the seat) — gives the rider a clear
	-- seat-platform silhouette below the canopy. Name uses ChuteBasket<idx>
	-- which is the original RideController-tracked name.
	local basket = AB.block(
		Vector3.new(5, 2.2, 5),
		DEEP_WOOD,
		centerCF * CFrame.new(cx, basketY, cz),
		m,
		"ChuteBasket" .. idx)
	basket.Material = Enum.Material.Wood

	-- Gold trim around basket rim
	for t = 0, 3 do
		local ta = math.rad(t * 90)
		local tx, tz = math.cos(ta) * 2.6, math.sin(ta) * 2.6
		local trim = AB.block(
			Vector3.new(5.2, 0.4, 0.5),
			ANTIQUE_GOLD,
			centerCF * CFrame.new(cx + tx, basketY + 1.05, cz + tz)
				* CFrame.Angles(0, -ta, 0),
			m,
			"ChuteBasketTrim" .. idx)
		trim.Material = Enum.Material.Metal
	end

	-- Rider seat
	local seat = Instance.new("Seat")
	seat.Name        = "ChuteRider" .. idx
	seat.Size        = Vector3.new(3.5, 1, 3.5)
	seat.Color       = SEAT_COL
	seat.Material    = Enum.Material.SmoothPlastic
	seat.Anchored    = true
	seat.CanCollide  = true
	seat.CFrame      = centerCF * CFrame.new(cx, seatY, cz)
	seat.TopSurface  = Enum.SurfaceType.Smooth
	seat.Parent      = m

	-- Tiny decorative finial above canopy crown (acts as a parachute "vent
	-- ribbon" indicator). Uses ChuteD<idx> pattern from prior contract.
	local finial = AB.sphere(1.6, ANTIQUE_GOLD2,
		centerCF * CFrame.new(cx, canopyY + CANOPY_H * 0.95 + 1, cz),
		m, "ChuteD" .. idx)
	finial.Material = Enum.Material.Metal
end

for i = 1, CHUTE_COUNT do
	buildChute(i)
end

-- ── Finalize ────────────────────────────────────────────────────────────────
AB.weldAll(m)
m:PivotTo(originalPivot)

print(("[RideRebuildParachuteJump] Rebuilt classic Parachute Drop (%d chutes, %d descendants)"):format(
	CHUTE_COUNT, #m:GetDescendants()))
