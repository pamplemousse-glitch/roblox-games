-- RideRebuildTiltAWhirl: rebuild workspace.TiltAWhirl as a CLASSIC Tilt-A-Whirl
-- for Frank's Fairground (Belle-Époque pass).
--
-- Contract (BELLE_EPOQUE_RIDE_PLAYBOOK.md §6 TiltAWhirl):
--   - Spin ride; RideController.SPIN_RIDES TiltAWhirl rps=0.75 unchanged.
--   - RideController.getSeats() reads direct Seat children — preserve
--     Seat_1..Seat_6 as direct children of m.
--   - PrimaryPart = invisible identity PivotAnchor (MANDATORY pattern; using
--     an AB.cylinder as PrimaryPart bakes a 90° Z-rotation that breaks PivotTo).
--   - ~56-stud single circular deck (NOT stacked pancakes), gentle undulation,
--     6 burgundy + ivory tilt cars facing inward (backrest + gold trim),
--     striped burgundy/ivory perimeter fence.
-- Idempotent: backs up old children to ServerStorage, ClearAllChildren so
-- RideController's FindFirstChild("TiltAWhirl") still resolves.

local ServerStorage     = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AB                = require(ReplicatedStorage.Common.AssetBuilder)

task.wait(1)  -- let peer rebuild scripts settle

local m = workspace:FindFirstChild("TiltAWhirl") :: Model?
if not m then
	warn("[RideRebuildTiltAWhirl] workspace.TiltAWhirl not found — skipping rebuild.")
	return
end

-- ── 1. Capture original pivot + back up old model ────────────────────────────
local originalPivot = m:GetPivot()
local backup = m:Clone()
backup.Name   = "TiltAWhirl_PreBelleEpoque_2026-06-03"
backup.Parent = ServerStorage
m:ClearAllChildren()
m.PrimaryPart = nil

-- ── 2. Belle-Époque palette (matches playbook palette table) ─────────────────
local BURGUNDY     = Color3.fromRGB(130,  30,  50)
local IVORY        = Color3.fromRGB(245, 235, 205)
local ANTIQUE_GOLD = Color3.fromRGB(200, 160,  80)
local DEEP_WOOD    = Color3.fromRGB(110,  75,  45)
local WROUGHT_IRON = Color3.fromRGB( 40,  35,  40)

-- ── 3. Geometry ──────────────────────────────────────────────────────────────
local PLATFORM_DIAM     = 56            -- single circular deck
local PLATFORM_HEIGHT   = 3
local UNDULATION_COUNT  = 8
local UNDULATION_RISE   = 1.2
local UNDULATION_RADIUS = 17
local FENCE_RADIUS      = PLATFORM_DIAM * 0.5 + 1.5
local FENCE_POSTS       = 16
local FENCE_HEIGHT      = 5
local FENCE_RAIL_Y      = FENCE_HEIGHT * 0.6
local CAR_COUNT         = 6
local CAR_RADIUS        = 18

local originCF = CFrame.new(0, 0, 0)

-- ── 4. PivotAnchor FIRST (mandatory pattern) ─────────────────────────────────
local pivotAnchor = AB.part({
	size = Vector3.new(0.1, 0.1, 0.1), color = Color3.new(1, 1, 1),
	cf = originCF, canCollide = false, transparency = 1, name = "PivotAnchor",
}, m)
m.PrimaryPart = pivotAnchor

-- ── 5. Foundation pad (static decorative apron under the spinning deck) ──────
local pad = AB.cylinder(PLATFORM_DIAM + 4, 1.4, DEEP_WOOD,
	originCF * CFrame.new(0, -0.7, 0), m, "Foundation")
pad.Material = Enum.Material.WoodPlanks

local padRim = AB.cylinder(PLATFORM_DIAM + 4.6, 0.6, ANTIQUE_GOLD,
	originCF * CFrame.new(0, -0.1, 0), m, "FoundationRim")
padRim.Material = Enum.Material.Metal
padRim.Reflectance = 0.15

-- ── 6. Main spinning deck (single disc — NOT stacked) ────────────────────────
local deckY = PLATFORM_HEIGHT * 0.5 + 0.6
local deck = AB.cylinder(PLATFORM_DIAM, PLATFORM_HEIGHT, IVORY,
	originCF * CFrame.new(0, deckY, 0), m, "Body")
deck.Material = Enum.Material.WoodPlanks

local deckRim = AB.cylinder(PLATFORM_DIAM + 0.4, PLATFORM_HEIGHT * 0.55, BURGUNDY,
	originCF * CFrame.new(0, deckY, 0), m, "BodyRim")
deckRim.Material = Enum.Material.WoodPlanks

local deckGold = AB.cylinder(PLATFORM_DIAM + 0.6, 0.4, ANTIQUE_GOLD,
	originCF * CFrame.new(0, deckY + PLATFORM_HEIGHT * 0.5 - 0.2, 0), m, "BodyTrim")
deckGold.Material   = Enum.Material.Metal
deckGold.Reflectance = 0.2

local deckTopY = deckY + PLATFORM_HEIGHT * 0.5

-- ── 7. Gentle undulation — low bumps under each car arc for the wave deck ────
for i = 1, UNDULATION_COUNT do
	local angRad = ((i - 0.5) / UNDULATION_COUNT) * 2 * math.pi
	local x = math.cos(angRad) * UNDULATION_RADIUS
	local z = math.sin(angRad) * UNDULATION_RADIUS
	local bump = AB.cylinder(7, UNDULATION_RISE, IVORY,
		originCF * CFrame.new(x, deckTopY + UNDULATION_RISE * 0.5, z),
		m, "DeckUndulation_" .. i)
	bump.Material = Enum.Material.WoodPlanks
	local cap = AB.cylinder(5.5, 0.3, BURGUNDY,
		originCF * CFrame.new(x, deckTopY + UNDULATION_RISE + 0.15, z),
		m, "DeckUndulationCap_" .. i)
	cap.Material = Enum.Material.WoodPlanks
end

-- ── 8. Central hub + gold spire ──────────────────────────────────────────────
local hub = AB.cylinder(8, 2.2, BURGUNDY,
	originCF * CFrame.new(0, deckTopY + 1.1, 0), m, "CenterHub")
hub.Material = Enum.Material.WoodPlanks

local hubBand = AB.cylinder(8.4, 0.5, ANTIQUE_GOLD,
	originCF * CFrame.new(0, deckTopY + 2.0, 0), m, "CenterHubBand")
hubBand.Material = Enum.Material.Metal
hubBand.Reflectance = 0.2

local spire = AB.part({
	size = Vector3.new(0.6, 3.2, 0.6), color = ANTIQUE_GOLD,
	material = Enum.Material.Metal,
	cf = originCF * CFrame.new(0, deckTopY + 2.2 + 1.6, 0), name = "CenterSpire",
}, m)
spire.Reflectance = 0.25

local spireTip = AB.sphere(1.1, ANTIQUE_GOLD,
	originCF * CFrame.new(0, deckTopY + 2.2 + 3.5, 0), m, "CenterSpireTip")
spireTip.Material = Enum.Material.Metal
spireTip.Reflectance = 0.3

-- ── 9. Tilt cars + Seats (Seats must be direct children of m) ────────────────
for i = 1, CAR_COUNT do
	local angRad = ((i - 1) / CAR_COUNT) * 2 * math.pi
	local cx = math.cos(angRad) * CAR_RADIUS
	local cz = math.sin(angRad) * CAR_RADIUS
	local carBaseY = deckTopY + 0.4

	-- Burgundy bowl shell
	local shell = AB.cylinder(8, 2.0, BURGUNDY,
		originCF * CFrame.new(cx, carBaseY + 1.0, cz), m, "CarShell_" .. i)
	shell.Material = Enum.Material.WoodPlanks

	-- Ivory inner disc
	local shellInner = AB.cylinder(6.8, 0.4, IVORY,
		originCF * CFrame.new(cx, carBaseY + 1.95, cz), m, "CarShellInner_" .. i)
	shellInner.Material = Enum.Material.WoodPlanks

	-- Gold trim ring on the rim
	local shellTrim = AB.cylinder(8.2, 0.35, ANTIQUE_GOLD,
		originCF * CFrame.new(cx, carBaseY + 1.85, cz), m, "CarTrim_" .. i)
	shellTrim.Material = Enum.Material.Metal
	shellTrim.Reflectance = 0.2

	-- Backrest behind seat (faces outward; rider sits facing center)
	local outwardX = math.cos(angRad)
	local outwardZ = math.sin(angRad)
	local backrestCenter = Vector3.new(
		cx + outwardX * 2.4, carBaseY + 2.6, cz + outwardZ * 2.4)
	local backrestYaw = -angRad
	local backrest = AB.block(Vector3.new(5.5, 2.8, 0.6), BURGUNDY,
		originCF * CFrame.new(backrestCenter) * CFrame.Angles(0, backrestYaw, 0),
		m, "CarBackrest_" .. i)
	backrest.Material = Enum.Material.WoodPlanks

	-- Ivory inset panel
	local backrestPanel = AB.block(Vector3.new(4.5, 2.0, 0.2), IVORY,
		originCF
			* CFrame.new(backrestCenter
				+ Vector3.new(-outwardX * 0.35, 0, -outwardZ * 0.35))
			* CFrame.Angles(0, backrestYaw, 0),
		m, "CarBackrestPanel_" .. i)
	backrestPanel.Material = Enum.Material.WoodPlanks

	-- Gold cap atop the backrest
	local backrestCap = AB.block(Vector3.new(5.6, 0.35, 0.7), ANTIQUE_GOLD,
		originCF * CFrame.new(backrestCenter + Vector3.new(0, 1.5, 0))
			* CFrame.Angles(0, backrestYaw, 0),
		m, "CarBackrestCap_" .. i)
	backrestCap.Material = Enum.Material.Metal
	backrestCap.Reflectance = 0.2

	-- Seat — direct child of m, faces inward toward platform center.
	local seat = Instance.new("Seat")
	seat.Name          = "Seat_" .. i
	seat.Size          = Vector3.new(3.2, 0.5, 2.5)
	seat.Color         = IVORY
	seat.Material      = Enum.Material.SmoothPlastic
	seat.Anchored      = true
	seat.CanCollide    = true
	seat.TopSurface    = Enum.SurfaceType.Smooth
	seat.BottomSurface = Enum.SurfaceType.Smooth
	local seatPos = Vector3.new(cx, carBaseY + 2.2, cz)
	seat.CFrame = originCF * CFrame.lookAt(seatPos, Vector3.new(0, seatPos.Y, 0))
	seat.Parent = m
end

-- ── 10. Perimeter fence — alternating burgundy/ivory striped posts + rails ───
for i = 1, FENCE_POSTS do
	local angRad = ((i - 1) / FENCE_POSTS) * 2 * math.pi
	local x = math.cos(angRad) * FENCE_RADIUS
	local z = math.sin(angRad) * FENCE_RADIUS
	local stripeColor = (i % 2 == 1) and BURGUNDY or IVORY
	AB.part({
		size = Vector3.new(0.8, FENCE_HEIGHT, 0.8), color = stripeColor,
		material = Enum.Material.WoodPlanks,
		cf = originCF * CFrame.new(x, FENCE_HEIGHT * 0.5 - 0.6, z),
		name = "FencePost_" .. i,
	}, m)
	local finial = AB.sphere(1.0, ANTIQUE_GOLD,
		originCF * CFrame.new(x, FENCE_HEIGHT - 0.6 + 0.2, z),
		m, "FencePostFinial_" .. i)
	finial.Material = Enum.Material.Metal
	finial.Reflectance = 0.2
end

-- Rails — short segment between adjacent posts hugging the circle.
for i = 1, FENCE_POSTS do
	local a1 = ((i - 1) / FENCE_POSTS) * 2 * math.pi
	local a2 = (i / FENCE_POSTS) * 2 * math.pi
	local x1, z1 = math.cos(a1) * FENCE_RADIUS, math.sin(a1) * FENCE_RADIUS
	local x2, z2 = math.cos(a2) * FENCE_RADIUS, math.sin(a2) * FENCE_RADIUS
	local midX, midZ = (x1 + x2) * 0.5, (z1 + z2) * 0.5
	local segLen = math.sqrt((x2 - x1) ^ 2 + (z2 - z1) ^ 2)
	local segYaw = math.atan2(z2 - z1, x2 - x1)
	local railColor = (i % 2 == 1) and IVORY or BURGUNDY
	local rail = AB.block(Vector3.new(segLen + 0.1, 0.4, 0.3), railColor,
		originCF * CFrame.new(midX, FENCE_RAIL_Y, midZ) * CFrame.Angles(0, -segYaw, 0),
		m, "FenceRail_" .. i)
	rail.Material = Enum.Material.WoodPlanks
	local railLow = AB.block(Vector3.new(segLen + 0.1, 0.3, 0.25), WROUGHT_IRON,
		originCF * CFrame.new(midX, FENCE_RAIL_Y - 1.6, midZ) * CFrame.Angles(0, -segYaw, 0),
		m, "FenceRailLow_" .. i)
	railLow.Material = Enum.Material.Metal
end

-- ── 11. Finalize ─────────────────────────────────────────────────────────────
AB.weldAll(m)
m:PivotTo(originalPivot)

print(("[RideRebuildTiltAWhirl] rebuilt — %d descendants (Classic Tilt-A-Whirl, %d cars, %d fence posts)")
	:format(#m:GetDescendants(), CAR_COUNT, FENCE_POSTS))
