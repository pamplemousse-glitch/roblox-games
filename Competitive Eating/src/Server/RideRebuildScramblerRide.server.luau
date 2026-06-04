-- RideRebuildScramblerRide: rebuilds workspace.ScramblerRide as a Belle-Époque
-- **Classic Scrambler** (burgundy + ivory + antique_gold). Replaces the prior
-- eggbeater food-shape build.
--
-- HARD contract preserved (see RideController.buildScrambler, ~line 430):
--
--   workspace.ScramblerRide                 -- outer Model (Seats live here)
--     PivotAnchor (Part)                    -- identity-rotation PrimaryPart
--     Generated (Folder)
--       ScramblerRide (Model)
--         BaseStructure (Model)             -- center hub; revolves with main
--         Mechanics (Model)
--           Arm_1..Arm_4 (Model)            -- spinner arms; counter-rotate
--
-- buildScrambler reads:
--   * `Generated/ScramblerRide/BaseStructure`  → one rigid body
--   * `Generated/ScramblerRide/Mechanics/<arm models>` → counter-rotating arms
--     (sorted by Name → Arm_1..Arm_4 gives deterministic order)
--   * Seats as DIRECT children of outer model (`getSeats` = :GetChildren())
--     → each seat is bound to its nearest arm group via Position match.
--
-- Aesthetic: classic carnival Scrambler. Burgundy + antique_gold center hub
-- with antique_gold rivets, ivory arms striped with crimson_glow neon, two
-- burgundy/ivory two-seater cars per arm with deep_wood backrests, surrounding
-- striped ring fence. PivotAnchor pattern (identity rotation) so PivotTo is
-- not corrupted by AB.cylinder's baked 90° Z rotation.

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
	clone.Name   = "ScramblerRide_PreBelleEpoque_2026-06-03"
	clone.Parent = ServerStorage
end

m:ClearAllChildren()
m.PrimaryPart = nil

-- ── Belle-Époque palette (playbook section 26-38) ────────────────────────────
local BURGUNDY     = Color3.fromRGB(130, 30, 50)
local IVORY        = Color3.fromRGB(245, 235, 205)
local ANTIQUE_GOLD = Color3.fromRGB(200, 160, 80)
local DEEP_WOOD    = Color3.fromRGB(110, 75, 45)
local WOOD_PLANK   = Color3.fromRGB(160, 110, 70)
local WROUGHT_IRON = Color3.fromRGB(40, 35, 40)
local CRIMSON_GLOW = Color3.fromRGB(220, 60, 70)

-- ── Dimensions (2× original footprint) ───────────────────────────────────────
local HUB_RADIUS  = 7          -- center hub radius
local HUB_HEIGHT  = 5
local ARM_COUNT   = 4
local ARM_LEN     = 28         -- hub edge → spinner center
local SPIN_RADIUS = 9          -- spinner platform radius (carries 2 cars)
local CARS_PER_ARM = 2
local CAR_HALF_W  = 3.0        -- car shell half-width
local CAR_HALF_L  = 3.6        -- car shell half-length
local CAR_HEIGHT  = 3.6
local FENCE_RAD   = ARM_LEN + SPIN_RADIUS + CAR_HALF_L + 6
local FENCE_SEGS  = 32
local FENCE_H     = 4

-- Build everything around CFrame.new(0,0,0); PivotTo at the end maps back to
-- world. Saves a baseCF.* multiply on every part and (critically) means the
-- PivotAnchor at local origin already has identity rotation.
local O = CFrame.new(0, 0, 0)

-- ── PivotAnchor (mandatory, identity rotation, see playbook rule 5) ─────────
local pivotAnchor = AB.part({
	size         = Vector3.new(0.1, 0.1, 0.1),
	color        = Color3.new(1, 1, 1),
	cf           = O,
	canCollide   = false,
	transparency = 1,
	name         = "PivotAnchor",
}, m)
m.PrimaryPart = pivotAnchor

-- ── Generated/ScramblerRide/{BaseStructure, Mechanics} ───────────────────────
local generated     = Instance.new("Folder")
generated.Name      = "Generated"
generated.Parent    = m
local inner         = AB.model("ScramblerRide", generated)
local baseStructure = AB.model("BaseStructure", inner)
local mechanics     = AB.model("Mechanics", inner)

-- ── Ring fence (decoration, lives on outer model) ────────────────────────────
do
	-- Burgundy decking
	AB.cylinder(FENCE_RAD * 2, 1, DEEP_WOOD,
		O * CFrame.new(0, 0.5, 0),
		m, "DeckFloor").Material = Enum.Material.Wood

	-- Striped fence segments (alternating burgundy / ivory)
	for i = 1, FENCE_SEGS do
		local a       = (i - 1) / FENCE_SEGS * math.pi * 2
		local x, z    = math.cos(a) * FENCE_RAD, math.sin(a) * FENCE_RAD
		local segLen  = FENCE_RAD * 2 * math.pi / FENCE_SEGS + 1
		local panel   = (i % 2 == 0) and BURGUNDY or IVORY
		local seg = AB.block(
			Vector3.new(0.6, FENCE_H, segLen),
			panel,
			O * CFrame.new(x, FENCE_H / 2 + 1, z) * CFrame.Angles(0, -a + math.rad(90), 0),
			m, "FencePanel_" .. i)
		seg.Material = Enum.Material.SmoothPlastic
	end

	-- Antique-gold cap rail running around the top of the fence
	local CAP_SEGS = 32
	for i = 1, CAP_SEGS do
		local a    = (i - 1) / CAP_SEGS * math.pi * 2
		local x, z = math.cos(a) * FENCE_RAD, math.sin(a) * FENCE_RAD
		local segLen = FENCE_RAD * 2 * math.pi / CAP_SEGS + 1
		local cap = AB.block(
			Vector3.new(0.8, 0.5, segLen),
			ANTIQUE_GOLD,
			O * CFrame.new(x, FENCE_H + 1.1, z) * CFrame.Angles(0, -a + math.rad(90), 0),
			m, "FenceCap_" .. i)
		cap.Material = Enum.Material.Metal
	end
end

-- ── BaseStructure: burgundy + antique_gold center hub ────────────────────────
do
	local DECK_TOP = 1.0
	local hubY     = DECK_TOP + HUB_HEIGHT / 2

	-- Wide plinth disc
	AB.cylinder(HUB_RADIUS * 2 + 6, 1.4, ANTIQUE_GOLD,
		O * CFrame.new(0, DECK_TOP + 0.7, 0),
		baseStructure, "HubPlinth").Material = Enum.Material.Metal

	-- Main burgundy hub barrel
	AB.cylinder(HUB_RADIUS * 2, HUB_HEIGHT, BURGUNDY,
		O * CFrame.new(0, hubY, 0),
		baseStructure, "HubBarrel").Material = Enum.Material.SmoothPlastic

	-- Antique-gold mid-band
	AB.cylinder(HUB_RADIUS * 2 + 0.6, 0.9, ANTIQUE_GOLD,
		O * CFrame.new(0, hubY, 0),
		baseStructure, "HubBand").Material = Enum.Material.Metal

	-- Decorative rivets around the band
	local RIVET_COUNT = 16
	for i = 1, RIVET_COUNT do
		local a    = (i - 1) / RIVET_COUNT * math.pi * 2
		local x, z = math.cos(a) * (HUB_RADIUS + 0.45), math.sin(a) * (HUB_RADIUS + 0.45)
		AB.sphere(0.55, ANTIQUE_GOLD,
			O * CFrame.new(x, hubY, z),
			baseStructure, "HubRivet_" .. i).Material = Enum.Material.Metal
	end

	-- Domed antique-gold cap
	AB.sphere(HUB_RADIUS * 1.8, ANTIQUE_GOLD,
		O * CFrame.new(0, hubY + HUB_HEIGHT / 2 + HUB_RADIUS * 0.35, 0),
		baseStructure, "HubDome").Material = Enum.Material.Metal

	-- Crimson finial
	local finial = AB.sphere(1.2, CRIMSON_GLOW,
		O * CFrame.new(0, hubY + HUB_HEIGHT / 2 + HUB_RADIUS * 1.05, 0),
		baseStructure, "HubFinial")
	AB.neon(finial); AB.glow(finial, CRIMSON_GLOW, 1.2)
end

-- ── Arm groups: 4 ivory arms with crimson-glow accent stripes ────────────────
local ARM_TOP_Y = 1.0 + HUB_HEIGHT * 0.55      -- arm sweep height above deck
local SEAT_Y    = ARM_TOP_Y + 0.5
local seatIndex = 0

for armIdx = 1, ARM_COUNT do
	local angle      = (armIdx - 1) / ARM_COUNT * math.pi * 2
	local cosA, sinA = math.cos(angle), math.sin(angle)
	local arm        = AB.model("Arm_" .. armIdx, mechanics)

	-- Spinner center (where the 2-car cluster pivots)
	local spinR   = HUB_RADIUS + ARM_LEN
	local spinPos = Vector3.new(cosA * spinR, ARM_TOP_Y, sinA * spinR)
	local spinDir = Vector3.new(cosA, 0, sinA)        -- outward from hub
	local spinPerp = Vector3.new(-sinA, 0, cosA)      -- tangent

	-- Ivory main arm beam (rectangular, length = ARM_LEN, thick)
	do
		local beamLen = ARM_LEN
		local beamMid = Vector3.new(cosA * (HUB_RADIUS + beamLen / 2), ARM_TOP_Y, sinA * (HUB_RADIUS + beamLen / 2))
		local beamCF  = CFrame.new(beamMid) * CFrame.Angles(0, -angle, 0)
		local beam = AB.block(
			Vector3.new(beamLen, 1.8, 2.4),
			IVORY,
			beamCF,
			arm, "ArmBeam_" .. armIdx)
		beam.Material = Enum.Material.SmoothPlastic

		-- Crimson-glow accent stripe (slightly above the beam centerline)
		local stripe = AB.block(
			Vector3.new(beamLen - 1, 0.35, 0.6),
			CRIMSON_GLOW,
			beamCF * CFrame.new(0, 0.6, 0),
			arm, "ArmStripe_" .. armIdx)
		AB.neon(stripe)

		-- Antique-gold collar at the hub end of the beam
		AB.block(
			Vector3.new(0.6, 2.2, 2.8),
			ANTIQUE_GOLD,
			beamCF * CFrame.new(-beamLen / 2 + 0.4, 0, 0),
			arm, "ArmHubCollar_" .. armIdx).Material = Enum.Material.Metal
	end

	-- Spinner disc at the arm tip (the carrier the cars ride on)
	AB.cylinder(SPIN_RADIUS * 2, 0.6, ANTIQUE_GOLD,
		CFrame.new(spinPos),
		arm, "SpinnerDisc_" .. armIdx).Material = Enum.Material.Metal

	-- Ivory rim around the spinner disc
	AB.cylinder(SPIN_RADIUS * 2 + 0.8, 0.4, IVORY,
		CFrame.new(spinPos + Vector3.new(0, 0.45, 0)),
		arm, "SpinnerRim_" .. armIdx).Material = Enum.Material.SmoothPlastic

	-- 2 cars on each spinner, offset along the spinner's tangent.
	for cIdx = 1, CARS_PER_ARM do
		local side    = (cIdx == 1) and 1 or -1
		local carCenter = spinPos + spinPerp * (SPIN_RADIUS * 0.55 * side)
		-- Car faces the spinner's tangential direction (perpendicular to arm)
		local facingYaw = angle + math.pi / 2 * side
		local carCF   = CFrame.new(carCenter) * CFrame.Angles(0, -facingYaw, 0)

		-- Burgundy lower shell
		AB.block(
			Vector3.new(CAR_HALF_W * 2, CAR_HEIGHT * 0.55, CAR_HALF_L * 2),
			BURGUNDY,
			carCF * CFrame.new(0, CAR_HEIGHT * 0.3, 0),
			arm, "CarHull_" .. armIdx .. "_" .. cIdx).Material = Enum.Material.SmoothPlastic

		-- Ivory upper band
		AB.block(
			Vector3.new(CAR_HALF_W * 2 + 0.2, 0.7, CAR_HALF_L * 2 + 0.2),
			IVORY,
			carCF * CFrame.new(0, CAR_HEIGHT * 0.6, 0),
			arm, "CarBand_" .. armIdx .. "_" .. cIdx).Material = Enum.Material.SmoothPlastic

		-- Antique-gold trim around the band
		AB.block(
			Vector3.new(CAR_HALF_W * 2 + 0.4, 0.18, CAR_HALF_L * 2 + 0.4),
			ANTIQUE_GOLD,
			carCF * CFrame.new(0, CAR_HEIGHT * 0.6 + 0.4, 0),
			arm, "CarTrim_" .. armIdx .. "_" .. cIdx).Material = Enum.Material.Metal

		-- Deep-wood backrest (behind seat, facing outward from spinner)
		local backOffset = -CAR_HALF_L + 0.4
		AB.block(
			Vector3.new(CAR_HALF_W * 1.8, CAR_HEIGHT * 0.95, 0.4),
			DEEP_WOOD,
			carCF * CFrame.new(0, CAR_HEIGHT * 0.6, backOffset),
			arm, "CarBackrest_" .. armIdx .. "_" .. cIdx).Material = Enum.Material.WoodPlanks

		-- Backrest top crown
		AB.block(
			Vector3.new(CAR_HALF_W * 1.9, 0.4, 0.5),
			ANTIQUE_GOLD,
			carCF * CFrame.new(0, CAR_HEIGHT * 1.05, backOffset),
			arm, "CarCrown_" .. armIdx .. "_" .. cIdx).Material = Enum.Material.Metal

		-- Wood-plank floor
		AB.block(
			Vector3.new(CAR_HALF_W * 1.9, 0.25, CAR_HALF_L * 1.9),
			WOOD_PLANK,
			carCF * CFrame.new(0, 0.2, 0),
			arm, "CarFloor_" .. armIdx .. "_" .. cIdx).Material = Enum.Material.WoodPlanks

		-- Wrought-iron safety bar across the front
		AB.cylinder(0.4, CAR_HALF_W * 1.8, WROUGHT_IRON,
			carCF * CFrame.new(0, CAR_HEIGHT * 0.55, CAR_HALF_L - 0.5)
				* CFrame.Angles(0, 0, math.rad(90)),
			arm, "CarSafetyBar_" .. armIdx .. "_" .. cIdx).Material = Enum.Material.Metal

		-- Seat (DIRECT child of outer model — buildScrambler binds it to the
		-- nearest arm via XZ proximity, so position matters).
		seatIndex += 1
		local seat = Instance.new("Seat")
		seat.Name        = "Seat_" .. seatIndex
		seat.Size        = Vector3.new(CAR_HALF_W * 1.6, 0.4, CAR_HALF_L * 1.4)
		seat.Color       = BURGUNDY
		seat.Material    = Enum.Material.SmoothPlastic
		seat.Anchored    = true
		seat.CanCollide  = true
		seat.TopSurface  = Enum.SurfaceType.Smooth
		seat.CFrame      = CFrame.new(carCenter.X, SEAT_Y, carCenter.Z)
		seat.Parent      = m
	end
end

-- ── Finalise: arm + base welds, restore world pivot ──────────────────────────
-- BaseStructure pivots as one rigid body.
do
	local root = baseStructure:FindFirstChildWhichIsA("BasePart")
	if root then
		baseStructure.PrimaryPart = root
		AB.weldAll(baseStructure)
	end
end

-- Each arm group welded rigidly so it rotates as one when its WorldPivot moves.
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
	"[RideRebuildScramblerRide] Classic Scrambler built: %d arms, %d seats, FENCE_RAD=%d",
	ARM_COUNT, seatIndex, FENCE_RAD))
