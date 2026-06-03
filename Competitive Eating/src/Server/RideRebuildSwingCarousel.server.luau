-- RideRebuildSwingCarousel: Cocktail Umbrella Swing rebuild for Frank's Fairground.
-- Replaces workspace.SwingCarousel with a 2×-footprint cocktail-umbrella swing
-- (striped paper canopy + 16 bendy-straw chairs) using AB primitives only.
--
-- Pattern (per RIDE_REBUILD_PLAYBOOK.md "Universal contract"):
--   1. Wait briefly for the workspace to settle.
--   2. Bail (warn, no error) if Workspace.SwingCarousel doesn't exist.
--   3. Clone original into ServerStorage as a backup.
--   4. ClearAllChildren on the model (preserve the Model instance — RideController
--      and SPIN_RIDES read it by name on init).
--   5. Build the new umbrella swing under it at the original pivot, 2× footprint.
--   6. Preserve ChairGroup_1..ChairGroup_16 (each a Model containing one Seat,
--      one Chain* part, and decorative parts) — read by RideController swing-out.
--   7. PrimaryPart = CenterMast (preserved from previous build; weldAll uses it).
--   8. PivotTo(originalPivot) so the ride stays where it was.

local ServerStorage = game:GetService("ServerStorage")
local AB            = require(game.ReplicatedStorage.Common.AssetBuilder)

task.wait(1)

local m = workspace:FindFirstChild("SwingCarousel")
if not m or not m:IsA("Model") then
	warn("[RideRebuildSwingCarousel] workspace.SwingCarousel not found — skipping")
	return
end

local originalPivot = m:GetPivot()

-- 1. Back up the existing model (idempotent: replace prior backup if present).
local prior = ServerStorage:FindFirstChild("SwingCarousel_PreFood_2026-06-03")
if prior then prior:Destroy() end
local backup  = m:Clone()
backup.Name   = "SwingCarousel_PreFood_2026-06-03"
backup.Parent = ServerStorage

-- 2. Clear children (preserve the Model itself).
m:ClearAllChildren()
m.PrimaryPart = nil

-- ── Palette (cocktail umbrella + bendy straws) ──────────────────────────────
local C = {
	paperRed   = Color3.fromRGB(210, 60, 60),    -- striped canopy wedge
	paperCream = Color3.fromRGB(245, 230, 200),  -- striped canopy wedge
	stem       = Color3.fromRGB(230, 215, 175),  -- paper umbrella stem (tan)
	tip        = Color3.fromRGB(220, 70, 70),    -- canopy apex bead
	goldRim    = Color3.fromRGB(220, 180, 60),   -- decorative gold accents
	chainSilver= Color3.fromRGB(170, 170, 175),  -- chain ribbon
	strawYellow= Color3.fromRGB(245, 220, 70),
	strawPink  = Color3.fromRGB(245, 130, 175),
	strawBlue  = Color3.fromRGB(85, 165, 230),
	strawCream = Color3.fromRGB(245, 235, 215),
	seatTan    = Color3.fromRGB(195, 160, 110),  -- bun-coloured seat pad
}

-- ── Footprint sizing (2× the original Wave-Swinger build) ───────────────────
local MAST_HEIGHT     = 44      -- was ~22
local MAST_DIAMETER   = 4.5     -- was ~2
local CANOPY_RIM_R    = 24      -- was ~11
local CANOPY_APEX_Y   = MAST_HEIGHT          -- 44
local CANOPY_RIM_Y    = MAST_HEIGHT - 16     -- 28
local CHAIR_RADIUS    = 22      -- chairs hang just inside the rim
local CHAIR_HANG_Y    = 14      -- top-of-chair Y (below the rim)
local CHAIN_TOP_Y     = CANOPY_RIM_Y - 1     -- where the chain meets the rim underside
local NUM_PANELS      = 16
local NUM_CHAIRS      = 16

-- Local origin for the rebuild — everything is built around (0,0,0) then the
-- whole model is pivoted to originalPivot at the end so the ride lands where
-- it sat in the .rbxl.
local O = CFrame.new(0, 0, 0)

-- ── 1. Center mast (the umbrella stem) ──────────────────────────────────────
-- PrimaryPart MUST be a stable named part the rest of the model welds to.
-- Previous build used "CenterMast" — preserve that name so any tooling /
-- handoffs continue to find it.
local mast = AB.cylinder(
	MAST_DIAMETER, MAST_HEIGHT, C.stem,
	O * CFrame.new(0, MAST_HEIGHT / 2, 0),
	m, "CenterMast"
)
mast:AddTag("Structural")    -- anchors partCentroid even with decorative chairs
m.PrimaryPart = mast

-- Stem gold bands every ~10 studs for paper-umbrella detail.
for i, y in { 8, 18, 28 } do
	local band = AB.cylinder(MAST_DIAMETER + 0.4, 0.8, C.goldRim,
		O * CFrame.new(0, y, 0), m, "StemBand_" .. i)
	band:AddTag("Structural")
end

-- Apex bead — the little red tip on a real cocktail umbrella.
AB.sphere(2.2, C.tip, O * CFrame.new(0, CANOPY_APEX_Y + 1.2, 0), m, "ApexBead")

-- ── 2. Conical striped canopy (16 alternating wedge panels) ─────────────────
-- Each "panel" is a thin tilted block fanning out from the apex down to the rim.
-- 16 panels makes a clean stripe pattern (8 red + 8 cream alternating).
local PANEL_LEN  = math.sqrt((CANOPY_APEX_Y - CANOPY_RIM_Y)^2 + CANOPY_RIM_R^2) -- ~28.8
local PANEL_TILT = math.atan2(CANOPY_RIM_R, CANOPY_APEX_Y - CANOPY_RIM_Y)
for i = 1, NUM_PANELS do
	local yaw      = (i - 1) / NUM_PANELS * math.pi * 2
	local midR     = CANOPY_RIM_R * 0.5
	local midY     = (CANOPY_APEX_Y + CANOPY_RIM_Y) * 0.5
	local panelCF  = O
		* CFrame.new(midR * math.cos(yaw), midY, midR * math.sin(yaw))
		* CFrame.Angles(0, -yaw, 0)
		* CFrame.Angles(0, 0, PANEL_TILT)
	local col = (i % 2 == 1) and C.paperRed or C.paperCream
	-- Wedge width: 2 * pi * r / 16 ≈ 9.4 studs at the rim.
	local panel = AB.block(
		Vector3.new(PANEL_LEN, 0.3, 2 * math.pi * CANOPY_RIM_R / NUM_PANELS),
		col, panelCF, m, "CanopyPanel_" .. i
	)
	panel:AddTag("Structural")
end

-- Canopy underside ring (cream) — hides the seam between panels, helps the
-- silhouette read as a solid umbrella from below.
for i = 1, NUM_PANELS do
	local yaw    = (i - 1) / NUM_PANELS * math.pi * 2 + (math.pi / NUM_PANELS)
	local segCF  = O
		* CFrame.new(CANOPY_RIM_R * math.cos(yaw), CANOPY_RIM_Y - 0.4, CANOPY_RIM_R * math.sin(yaw))
		* CFrame.Angles(0, -yaw, 0)
	AB.block(Vector3.new(1.2, 0.6, 2 * math.pi * CANOPY_RIM_R / NUM_PANELS),
		C.paperCream, segCF, m, "CanopyRim_" .. i)
end

-- Gold rim ring on the rim's outer edge for a touch of belle-époque sparkle.
for i = 1, NUM_PANELS do
	local yaw    = (i - 1) / NUM_PANELS * math.pi * 2 + (math.pi / NUM_PANELS)
	local segCF  = O
		* CFrame.new((CANOPY_RIM_R + 0.4) * math.cos(yaw), CANOPY_RIM_Y - 0.1, (CANOPY_RIM_R + 0.4) * math.sin(yaw))
		* CFrame.Angles(0, -yaw, 0)
	AB.block(Vector3.new(0.4, 0.4, 2 * math.pi * CANOPY_RIM_R / NUM_PANELS),
		C.goldRim, segCF, m, "GoldRim_" .. i)
end

-- ── 3. 16 chair groups (bendy straws) ───────────────────────────────────────
-- Each ChairGroup_i Model contains:
--   • Chain_i        — silver rod from canopy rim down to chair top
--   • StrawVert_i    — vertical straw segment (the "leg" of the bendy straw)
--   • StrawBend_i    — diagonal segment forming the 90° bend
--   • StrawHoriz_i   — horizontal segment — this is also the seat plank shape
--   • SeatPad_i      — small bun-coloured pad on top of horizontal segment
--   • RiderSeat      — the actual Seat (RideController scans for `ch:IsA("Seat")`)
-- The first Chain* part feeds the swing-out chains list; other parts feed
-- the swing-out parts list (`ChairSwing.parts`).
local STRAW_COLORS = { C.strawYellow, C.strawPink, C.strawBlue, C.strawCream }
for i = 1, NUM_CHAIRS do
	local yaw   = (i - 1) / NUM_CHAIRS * math.pi * 2
	local cx    = CHAIR_RADIUS * math.cos(yaw)
	local cz    = CHAIR_RADIUS * math.sin(yaw)
	local group = AB.model("ChairGroup_" .. i, m)

	-- Chain ribbon: thin silver rod from the rim down to the top of the chair.
	local chainLen = CHAIN_TOP_Y - CHAIR_HANG_Y - 3
	local chainCF  = O * CFrame.new(cx, CHAIR_HANG_Y + 3 + chainLen / 2, cz)
	AB.block(Vector3.new(0.3, chainLen, 0.3), C.chainSilver, chainCF, group, "Chain_" .. i)

	-- Bendy-straw chair: striped paper umbrella sits above a coloured straw.
	local color = STRAW_COLORS[((i - 1) % #STRAW_COLORS) + 1]

	-- Vertical segment of the straw (hangs down).
	local vertCF = O * CFrame.new(cx, CHAIR_HANG_Y + 1.5, cz)
	AB.cylinder(1.0, 3.5, color, vertCF, group, "StrawVert_" .. i)

	-- 45° bend joining vertical to horizontal — sells the bendy-straw shape.
	-- Aim the bend outward (away from the mast) so the seat sits on a small
	-- shelf protruding outward.
	local outX, outZ = math.cos(yaw), math.sin(yaw)
	local bendCF = O
		* CFrame.new(cx + outX * 0.9, CHAIR_HANG_Y - 0.4, cz + outZ * 0.9)
		* CFrame.Angles(0, -yaw, 0)
		* CFrame.Angles(0, 0, math.rad(45))
	AB.cylinder(1.0, 2.6, color, bendCF, group, "StrawBend_" .. i)

	-- Horizontal seat plank (the bottom of the bendy straw).
	local seatX = cx + outX * 2.2
	local seatZ = cz + outZ * 2.2
	local seatY = CHAIR_HANG_Y - 1.4
	local horizCF = O * CFrame.new(seatX, seatY, seatZ) * CFrame.Angles(0, -yaw, 0)
	AB.cylinder(1.0, 3.2, color, horizCF, group, "StrawHoriz_" .. i)

	-- Bun-coloured seat pad sitting on top of the horizontal straw.
	local padCF = O * CFrame.new(seatX, seatY + 0.6, seatZ) * CFrame.Angles(0, -yaw, 0)
	AB.block(Vector3.new(2.6, 0.4, 1.8), C.seatTan, padCF, group, "SeatPad_" .. i)

	-- The actual Seat — must be a child of the ChairGroup so RideController's
	-- swing-out scanner finds it via `ch:IsA("Seat")`.
	local seat = Instance.new("Seat")
	seat.Name        = "RiderSeat"
	seat.Size        = Vector3.new(2.4, 0.6, 1.6)
	seat.Color       = C.seatTan
	seat.Material    = Enum.Material.SmoothPlastic
	seat.Anchored    = true
	seat.CanCollide  = true
	seat.TopSurface  = Enum.SurfaceType.Smooth
	seat.BottomSurface = Enum.SurfaceType.Smooth
	seat.CFrame      = O * CFrame.new(seatX, seatY + 1.0, seatZ) * CFrame.Angles(0, -yaw, 0)
	seat.Parent      = group

	-- Boarding prompt directly on the seat (mirrors the gallop-rider pattern in
	-- RideController; the spawned BoardZone path no-ops because Seats aren't
	-- direct children of the SwingCarousel Model).
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText            = "Board"
	prompt.ObjectText            = "Cocktail Swing"
	prompt.MaxActivationDistance = 8
	prompt.RequiresLineOfSight   = false
	prompt.Parent                = seat
end

-- ── 4. Weld + reposition ────────────────────────────────────────────────────
AB.weldAll(m)
m:PivotTo(originalPivot)

print(string.format("[RideRebuildSwingCarousel] Cocktail Umbrella Swing built (%d descendants, PrimaryPart=%s)",
	#m:GetDescendants(), m.PrimaryPart and m.PrimaryPart.Name or "nil"))
