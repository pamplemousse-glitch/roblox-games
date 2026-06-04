-- RideRebuildSwingCarousel: Belle-Époque Wave Swinger rebuild for Frank's Fairground.
-- Replaces workspace.SwingCarousel with a classic wave-swinger ride — a striped
-- conical canopy on a central spire with 16 chain-suspended wooden chairs.
--
-- Per BELLE_EPOQUE_RIDE_PLAYBOOK.md "4. SwingCarousel → Wave Swinger":
--   • Burgundy + ivory striped conical canopy (no cocktail umbrella aesthetic).
--   • Antique-gold spire + decorative bands.
--   • 16 wrought-iron chains suspending deep-wood seats with ivory backrests.
--
-- PROVEN CONSTANTS (do not change — verified by user playtest):
--   MAST_HEIGHT = 26, CANOPY_RIM_R = 18, CHAIR_RADIUS = 16, PivotTo Y offset -16.
--
-- Named-part contract preserved (read by RideController buildSpin / swing-out):
--   PivotAnchor (PrimaryPart, identity rotation)
--   ChairGroup_1..ChairGroup_16 (Model) — each contains:
--     Chain_<i>   — BasePart whose name starts "Chain" (fed into swing-out chains list)
--     <other parts> — fed into swing-out parts list (`ChairSwing.parts`)
--     RiderSeat   — Seat (RideController scans via `ch:IsA("Seat")`)

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
local BACKUP_NAME = "SwingCarousel_PreBelleEpoque_2026-06-03"
local prior = ServerStorage:FindFirstChild(BACKUP_NAME)
if prior then prior:Destroy() end
local backup  = m:Clone()
backup.Name   = BACKUP_NAME
backup.Parent = ServerStorage

-- Also keep prior food-shape backup if it still exists (don't shadow it).
m:ClearAllChildren()
m.PrimaryPart = nil

-- ── Belle-Époque palette ────────────────────────────────────────────────────
local C = {
	burgundy    = Color3.fromRGB(130,  30,  50),
	ivory       = Color3.fromRGB(245, 235, 205),
	antiqueGold = Color3.fromRGB(200, 160,  80),
	deepWood    = Color3.fromRGB(110,  75,  45),
	woodPlank   = Color3.fromRGB(160, 110,  70),
	wroughtIron = Color3.fromRGB( 40,  35,  40),
	cream       = Color3.fromRGB(230, 215, 180),
}

-- ── Footprint sizing (PROVEN — DO NOT CHANGE) ───────────────────────────────
local MAST_HEIGHT     = 26
local MAST_DIAMETER   = 3
local CANOPY_RIM_R    = 18
local CANOPY_APEX_Y   = MAST_HEIGHT          -- 26
local CANOPY_RIM_Y    = MAST_HEIGHT - 10     -- 16
local CHAIR_RADIUS    = 16      -- chairs hang just inside the rim
local CHAIR_HANG_Y    = 14      -- top-of-chair Y
local CHAIN_TOP_Y     = CANOPY_RIM_Y - 1     -- where chain meets rim underside
local NUM_PANELS      = 16
local NUM_CHAIRS      = 16

local O = CFrame.new(0, 0, 0)

-- ── 1. PivotAnchor (identity rotation, PrimaryPart) ─────────────────────────
-- MUST be a non-rotated part — using the rotated cylinder mast as PrimaryPart
-- would bake a 90° Z rotation that breaks final PivotTo (per playbook rule 5).
local anchor = AB.part({
	size         = Vector3.new(0.1, 0.1, 0.1),
	color        = Color3.new(1, 1, 1),
	cf           = O,
	canCollide   = false,
	transparency = 1,
	name         = "PivotAnchor",
}, m)
anchor:AddTag("Structural")
m.PrimaryPart = anchor

-- ── 2. Central spire (burgundy structural mast + gold finial) ───────────────
local mast = AB.cylinder(
	MAST_DIAMETER, MAST_HEIGHT, C.burgundy,
	O * CFrame.new(0, MAST_HEIGHT / 2, 0),
	m, "CenterMast"
)
mast:AddTag("Structural")

-- Antique-gold base flange (where the spire meets the ground decking).
AB.cylinder(MAST_DIAMETER + 3.5, 0.8, C.antiqueGold,
	O * CFrame.new(0, 0.4, 0), m, "BaseFlange"):AddTag("Structural")
AB.cylinder(MAST_DIAMETER + 5.5, 0.6, C.deepWood,
	O * CFrame.new(0, 0.1, 0), m, "BasePlinth"):AddTag("Structural")

-- Decorative gold rings along the mast.
for i, y in { 6, 14, 22 } do
	AB.cylinder(MAST_DIAMETER + 0.5, 0.7, C.antiqueGold,
		O * CFrame.new(0, y, 0), m, "MastBand_" .. i):AddTag("Structural")
end

-- Antique-gold spire above the canopy apex — the wave-swinger silhouette.
AB.cylinder(MAST_DIAMETER * 0.6, 4.0, C.antiqueGold,
	O * CFrame.new(0, CANOPY_APEX_Y + 2.0, 0), m, "SpireShaft"):AddTag("Structural")
AB.sphere(2.4, C.antiqueGold,
	O * CFrame.new(0, CANOPY_APEX_Y + 4.4, 0), m, "SpireBall")
AB.cylinder(0.5, 3.0, C.antiqueGold,
	O * CFrame.new(0, CANOPY_APEX_Y + 7.0, 0), m, "SpireFinial"):AddTag("Structural")
AB.sphere(1.0, C.burgundy,
	O * CFrame.new(0, CANOPY_APEX_Y + 8.7, 0), m, "FinialTip")

-- ── 3. Striped conical canopy (16 alternating burgundy + ivory panels) ──────
local PANEL_LEN  = math.sqrt((CANOPY_APEX_Y - CANOPY_RIM_Y)^2 + CANOPY_RIM_R^2)
local PANEL_TILT = -math.atan2(CANOPY_APEX_Y - CANOPY_RIM_Y, CANOPY_RIM_R)
local PANEL_WIDTH = 2 * math.pi * CANOPY_RIM_R / NUM_PANELS
for i = 1, NUM_PANELS do
	local yaw      = (i - 1) / NUM_PANELS * math.pi * 2
	local midR     = CANOPY_RIM_R * 0.5
	local midY     = (CANOPY_APEX_Y + CANOPY_RIM_Y) * 0.5
	local panelCF  = O
		* CFrame.new(midR * math.cos(yaw), midY, midR * math.sin(yaw))
		* CFrame.Angles(0, -yaw, 0)
		* CFrame.Angles(0, 0, PANEL_TILT)
	local col = (i % 2 == 1) and C.burgundy or C.ivory
	local panel = AB.block(
		Vector3.new(PANEL_LEN, 0.4, PANEL_WIDTH),
		col, panelCF, m, "CanopyPanel_" .. i
	)
	panel:AddTag("Structural")
end

-- Canopy underside ring (deep wood — reads as the canopy's wooden ribbing).
for i = 1, NUM_PANELS do
	local yaw    = (i - 1) / NUM_PANELS * math.pi * 2 + (math.pi / NUM_PANELS)
	local segCF  = O
		* CFrame.new(CANOPY_RIM_R * math.cos(yaw), CANOPY_RIM_Y - 0.5, CANOPY_RIM_R * math.sin(yaw))
		* CFrame.Angles(0, -yaw, 0)
	AB.block(Vector3.new(1.4, 0.5, PANEL_WIDTH),
		C.deepWood, segCF, m, "CanopyRim_" .. i)
end

-- Antique-gold trim ring along the outer rim edge.
for i = 1, NUM_PANELS do
	local yaw    = (i - 1) / NUM_PANELS * math.pi * 2 + (math.pi / NUM_PANELS)
	local segCF  = O
		* CFrame.new((CANOPY_RIM_R + 0.5) * math.cos(yaw), CANOPY_RIM_Y - 0.1, (CANOPY_RIM_R + 0.5) * math.sin(yaw))
		* CFrame.Angles(0, -yaw, 0)
	AB.block(Vector3.new(0.5, 0.5, PANEL_WIDTH),
		C.antiqueGold, segCF, m, "GoldRim_" .. i)
end

-- Decorative ivory pennants hanging between every other rim segment.
for i = 1, NUM_PANELS, 2 do
	local yaw    = (i - 1) / NUM_PANELS * math.pi * 2 + (math.pi / NUM_PANELS)
	local segCF  = O
		* CFrame.new((CANOPY_RIM_R + 0.2) * math.cos(yaw), CANOPY_RIM_Y - 1.6, (CANOPY_RIM_R + 0.2) * math.sin(yaw))
		* CFrame.Angles(0, -yaw, 0)
	AB.wedge(Vector3.new(0.2, 1.6, 2.0), C.ivory, segCF, m, "Pennant_" .. i)
end

-- ── 4. 16 chair groups (wrought-iron chain + deep-wood chair) ───────────────
-- Each ChairGroup_i Model contains:
--   • Chain_i      — wrought-iron suspension chain (name starts "Chain")
--   • SeatPlank_i  — deep-wood seat plank
--   • Backrest_i   — ivory backrest with burgundy trim
--   • SeatPad_i    — cream cushion
--   • RiderSeat    — invisible Seat (boarding target)
for i = 1, NUM_CHAIRS do
	local yaw   = (i - 1) / NUM_CHAIRS * math.pi * 2
	local cx    = CHAIR_RADIUS * math.cos(yaw)
	local cz    = CHAIR_RADIUS * math.sin(yaw)
	local group = AB.model("ChairGroup_" .. i, m)

	-- Wrought-iron chain from the rim down to chair top.
	local chainLen = CHAIN_TOP_Y - CHAIR_HANG_Y - 1
	local chainCF  = O * CFrame.new(cx, CHAIR_HANG_Y + 1 + chainLen / 2, cz)
	AB.block(Vector3.new(0.35, chainLen, 0.35), C.wroughtIron, chainCF, group, "Chain_" .. i)

	-- A second thinner chain a stud forward for visual depth.
	local chain2CF = O * CFrame.new(cx, CHAIR_HANG_Y + 1 + chainLen / 2, cz)
		* CFrame.Angles(0, -yaw, 0) * CFrame.new(0, 0, 0.6)
	AB.block(Vector3.new(0.25, chainLen, 0.25), C.wroughtIron, chain2CF, group, "ChainAux_" .. i)

	-- Chain hub at the rim (gold link plate where chain meets canopy underside).
	local hubCF = O * CFrame.new(cx, CHAIN_TOP_Y - 0.2, cz)
	AB.block(Vector3.new(1.0, 0.4, 1.0), C.antiqueGold, hubCF, group, "ChainHub_" .. i)

	-- Deep-wood seat plank (the chair seat itself).
	local seatY     = CHAIR_HANG_Y
	local plankCF   = O * CFrame.new(cx, seatY, cz) * CFrame.Angles(0, -yaw, 0)
	AB.block(Vector3.new(2.6, 0.5, 1.8), C.deepWood, plankCF, group, "SeatPlank_" .. i)

	-- Cream cushion on top of the plank.
	local cushCF = O * CFrame.new(cx, seatY + 0.4, cz) * CFrame.Angles(0, -yaw, 0)
	AB.block(Vector3.new(2.4, 0.3, 1.6), C.cream, cushCF, group, "SeatPad_" .. i)

	-- Ivory backrest (facing inward — the rider faces outward as the ride spins).
	local outX, outZ = math.cos(yaw), math.sin(yaw)
	local backX = cx + outX * (-0.9)   -- backrest sits behind rider (toward mast)
	local backZ = cz + outZ * (-0.9)
	local backCF = O * CFrame.new(backX, seatY + 1.4, backZ) * CFrame.Angles(0, -yaw, 0)
	AB.block(Vector3.new(0.4, 2.2, 1.8), C.ivory, backCF, group, "Backrest_" .. i)

	-- Burgundy trim cap on top of the backrest.
	local trimCF = O * CFrame.new(backX, seatY + 2.6, backZ) * CFrame.Angles(0, -yaw, 0)
	AB.block(Vector3.new(0.5, 0.25, 1.9), C.burgundy, trimCF, group, "BackrestTrim_" .. i)

	-- The actual Seat — child of ChairGroup so RideController finds it.
	local seat = Instance.new("Seat")
	seat.Name          = "RiderSeat"
	seat.Size          = Vector3.new(2.4, 0.6, 1.6)
	seat.Color         = C.deepWood
	seat.Material      = Enum.Material.SmoothPlastic
	seat.Anchored      = true
	seat.CanCollide    = true
	seat.TopSurface    = Enum.SurfaceType.Smooth
	seat.BottomSurface = Enum.SurfaceType.Smooth
	seat.Transparency  = 1   -- visual is the SeatPlank+SeatPad; Seat is the mount target
	seat.CFrame        = O * CFrame.new(cx, seatY + 0.7, cz) * CFrame.Angles(0, -yaw, 0)
	seat.Parent        = group

	-- Boarding prompt on the seat (mirrors gallop-rider pattern).
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText            = "Board"
	prompt.ObjectText            = "Wave Swinger"
	prompt.MaxActivationDistance = 8
	prompt.RequiresLineOfSight   = false
	prompt.Parent                = seat
end

-- ── 5. Weld + reposition ────────────────────────────────────────────────────
AB.weldAll(m)
-- PROVEN offset: originalPivot.Y was ~17.6 in the .rbxl; -16 lands base near ground.
m:PivotTo(originalPivot * CFrame.new(0, -16, 0))

print(string.format("[RideRebuildSwingCarousel] Belle-Époque Wave Swinger built (%d descendants, PrimaryPart=%s)",
	#m:GetDescendants(), m.PrimaryPart and m.PrimaryPart.Name or "nil"))
