-- RideRebuildTeacupRide.server.luau
-- Rebuilds workspace.TeacupRide as **Classic Spinning Teacups** for Frank's
-- Fairground (Belle-Époque). Replaces the food-shape donut build per
-- BELLE_EPOQUE_RIDE_PLAYBOOK.md §5.
--
-- Mechanic preserved: SPIN_RIDES TeacupRide rps=0.55 (RideController spins
-- the model around partCentroid). No constant updates needed.
-- Named-part contract: Model "TeacupRide" + 8 Seat children at cup centers.
-- Aesthetic: 8 fluted porcelain teacups (burgundy + ivory + antique_gold) on
-- a ~60-stud platter with a center teapot decoration. Pure primitives.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage     = game:GetService("ServerStorage")
local AB = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetBuilder"))

task.wait(1)

local m = workspace:FindFirstChild("TeacupRide") :: Model?
if not m then
	warn("[RideRebuildTeacupRide] workspace.TeacupRide not found — skipping rebuild.")
	return
end

local originalPivot = m:GetPivot()

do
	local backup = m:Clone()
	backup.Name   = "TeacupRide_PreBelleEpoque_2026-06-03"
	backup.Parent = ServerStorage
end

m:ClearAllChildren()
m.PrimaryPart = nil

-- ── Belle-Époque palette (per playbook) ──────────────────────────────────────
local C = {
	burgundy      = Color3.fromRGB(130, 30, 50),
	ivory         = Color3.fromRGB(245, 235, 205),
	antique_gold  = Color3.fromRGB(200, 160, 80),
	deep_wood     = Color3.fromRGB(110, 75, 45),
	floral_pink   = Color3.fromRGB(220, 110, 130),
	floral_leaf   = Color3.fromRGB(90, 130, 70),
	tea_amber     = Color3.fromRGB(160, 90, 50),
}

-- ── Dimensions ───────────────────────────────────────────────────────────────
local PLATTER_RADIUS    = 30        -- ~60-stud platter (2× of original 30)
local PLATTER_THICKNESS = 1.5
local PLATTER_RIM_SEG   = 32
local NUM_CUPS          = 8
local CUP_RING_RADIUS   = 19
local CUP_OUTER_R       = 4.4
local CUP_BOTTOM_R      = 3.2
local CUP_HEIGHT        = 5.5
local CUP_FLUTES        = 12

-- ── PivotAnchor (MANDATORY: identity-rotation 0.1³ part as PrimaryPart) ──────
-- AB.cylinder bakes a 90° Z rotation; using it as PrimaryPart breaks PivotTo.
local pivotAnchor = AB.part({
	size         = Vector3.new(0.1, 0.1, 0.1),
	color        = Color3.new(1, 1, 1),
	cf           = CFrame.new(0, 0, 0),
	canCollide   = false,
	transparency = 1,
	name         = "PivotAnchor",
}, m)
m.PrimaryPart = pivotAnchor

-- ── Platter (burgundy disc with ivory rim + gold filigree band) ──────────────
local platterY = -PLATTER_THICKNESS / 2
local platter = AB.cylinder(
	PLATTER_RADIUS * 2, PLATTER_THICKNESS, C.burgundy,
	CFrame.new(0, platterY, 0), m, "Platter"
)

for i = 1, PLATTER_RIM_SEG do
	local a = (i - 1) / PLATTER_RIM_SEG * math.pi * 2
	-- Ivory rim
	local rimLen = 2 * PLATTER_RADIUS * math.tan(math.pi / PLATTER_RIM_SEG)
	AB.block(
		Vector3.new(rimLen, 1.2, 1),
		C.ivory,
		CFrame.new(math.cos(a) * PLATTER_RADIUS, platterY + PLATTER_THICKNESS/2 + 0.15, math.sin(a) * PLATTER_RADIUS)
			* CFrame.Angles(0, -a + math.pi/2, 0),
		m, "PlatterRim_" .. i
	)
	-- Antique-gold filigree band inside rim
	local r2 = PLATTER_RADIUS - 2.2
	local goldLen = 2 * r2 * math.tan(math.pi / PLATTER_RIM_SEG)
	AB.block(
		Vector3.new(goldLen, 0.5, 0.6),
		C.antique_gold,
		CFrame.new(math.cos(a) * r2, platterY + PLATTER_THICKNESS/2 + 0.4, math.sin(a) * r2)
			* CFrame.Angles(0, -a + math.pi/2, 0),
		m, "PlatterGold_" .. i
	)
end

-- Pedestal foot + base disc
AB.cylinder(PLATTER_RADIUS * 0.7, 6, C.deep_wood,
	CFrame.new(0, -PLATTER_THICKNESS - 3, 0), m, "PlatterFoot")
AB.cylinder(PLATTER_RADIUS * 0.9, 2, C.antique_gold,
	CFrame.new(0, -PLATTER_THICKNESS - 7, 0), m, "PlatterBase")

-- ── Teacup builder ───────────────────────────────────────────────────────────
-- Fluted porcelain cup at cupCF. Backrest faces -Z local (toward platter
-- center); rider sits looking outward past the handle.
local function buildCup(idx: number, cupCF: CFrame)
	-- Saucer (ivory + gold trim)
	AB.cylinder(CUP_OUTER_R * 2.2, 0.4, C.ivory, cupCF * CFrame.new(0, 0.2, 0),
		m, string.format("Cup%d_Saucer", idx))
	AB.cylinder(CUP_OUTER_R * 2.0, 0.2, C.antique_gold, cupCF * CFrame.new(0, 0.5, 0),
		m, string.format("Cup%d_SaucerTrim", idx))
	-- Cup base (narrower foot)
	AB.cylinder(CUP_BOTTOM_R * 2, 0.6, C.ivory, cupCF * CFrame.new(0, 0.9, 0),
		m, string.format("Cup%d_Base", idx))

	local tilt = math.atan2(CUP_OUTER_R - CUP_BOTTOM_R, CUP_HEIGHT)
	local midR = (CUP_OUTER_R + CUP_BOTTOM_R) / 2

	for f = 1, CUP_FLUTES do
		local a = (f - 1) / CUP_FLUTES * math.pi * 2
		local cosA, sinA = math.cos(a), math.sin(a)
		local rot = CFrame.Angles(0, -a + math.pi/2, 0)

		-- Fluted side panel (tilted outward, top wider than base)
		local fluteLen = 2 * midR * math.tan(math.pi / CUP_FLUTES) + 0.2
		AB.block(
			Vector3.new(fluteLen, CUP_HEIGHT, 0.6),
			C.ivory,
			cupCF * CFrame.new(cosA * midR, CUP_HEIGHT/2 + 1.0, sinA * midR)
				* rot * CFrame.Angles(tilt, 0, 0),
			m, string.format("Cup%d_Flute_%d", idx, f)
		)
		-- Burgundy top rim
		local rimLen = 2 * CUP_OUTER_R * math.tan(math.pi / CUP_FLUTES) + 0.2
		AB.block(
			Vector3.new(rimLen, 0.8, 0.5),
			C.burgundy,
			cupCF * CFrame.new(cosA * CUP_OUTER_R, CUP_HEIGHT + 0.9, sinA * CUP_OUTER_R) * rot,
			m, string.format("Cup%d_Rim_%d", idx, f)
		)
		-- Antique-gold mid-cup filigree
		local goldR = midR + 0.1
		local goldLen = 2 * goldR * math.tan(math.pi / CUP_FLUTES) + 0.1
		AB.block(
			Vector3.new(goldLen, 0.35, 0.35),
			C.antique_gold,
			cupCF * CFrame.new(math.cos(a) * goldR, CUP_HEIGHT/2 + 0.9, math.sin(a) * goldR) * rot,
			m, string.format("Cup%d_Gold_%d", idx, f)
		)
	end

	-- Amber "tea" surface
	AB.cylinder(CUP_OUTER_R * 1.7, 0.2, C.tea_amber,
		cupCF * CFrame.new(0, CUP_HEIGHT + 0.4, 0), m, string.format("Cup%d_Tea", idx))

	-- Porcelain handle (3-segment arch on +X side)
	for h = 1, 3 do
		local t = (h - 1) / 2
		local ang = math.rad(-60 + t * 120)
		AB.block(
			Vector3.new(0.5, 1.0, 0.5),
			C.ivory,
			cupCF * CFrame.new(CUP_OUTER_R + 1.0 + math.cos(ang) * 0.8,
				CUP_HEIGHT/2 + 1.4 + math.sin(ang) * 1.8, 0)
				* CFrame.Angles(0, 0, ang),
			m, string.format("Cup%d_Handle_%d", idx, h)
		)
	end

	-- Backrest (ivory panel on -Z side, with burgundy trim + floral motif)
	AB.block(Vector3.new(5.0, 3.5, 0.5), C.ivory,
		cupCF * CFrame.new(0, CUP_HEIGHT + 2.5, -CUP_OUTER_R + 0.3),
		m, string.format("Cup%d_Backrest", idx))
	AB.block(Vector3.new(5.2, 0.5, 0.6), C.burgundy,
		cupCF * CFrame.new(0, CUP_HEIGHT + 4.3, -CUP_OUTER_R + 0.3),
		m, string.format("Cup%d_BackrestTrim", idx))
	AB.sphere(1.4, C.floral_pink,
		cupCF * CFrame.new(0, CUP_HEIGHT + 2.8, -CUP_OUTER_R + 0.05),
		m, string.format("Cup%d_Floral", idx))
	AB.block(Vector3.new(1.0, 0.4, 0.4), C.floral_leaf,
		cupCF * CFrame.new(-1.2, CUP_HEIGHT + 2.5, -CUP_OUTER_R + 0.05)
			* CFrame.Angles(0, 0, math.rad(30)),
		m, string.format("Cup%d_Leaf_L", idx))
	AB.block(Vector3.new(1.0, 0.4, 0.4), C.floral_leaf,
		cupCF * CFrame.new(1.2, CUP_HEIGHT + 2.5, -CUP_OUTER_R + 0.05)
			* CFrame.Angles(0, 0, math.rad(-30)),
		m, string.format("Cup%d_Leaf_R", idx))

	-- Seat at cup center (rider perches just above the tea surface)
	local seat = Instance.new("Seat")
	seat.Name           = "Seat"
	seat.Size           = Vector3.new(4, 1, 4)
	seat.Color          = C.tea_amber
	seat.Material       = Enum.Material.SmoothPlastic
	seat.Anchored       = true
	seat.CanCollide     = true
	seat.TopSurface     = Enum.SurfaceType.Smooth
	seat.BottomSurface  = Enum.SurfaceType.Smooth
	seat.CFrame         = cupCF * CFrame.new(0, CUP_HEIGHT + 0.6, 0)
	seat.Parent         = m
end

-- ── Build 8 cups around the platter ──────────────────────────────────────────
-- Rotate each so backrest (-Z local) faces platter center → rider faces outward.
for i = 1, NUM_CUPS do
	local angle = (i - 1) / NUM_CUPS * math.pi * 2
	local cupCF = CFrame.new(math.cos(angle) * CUP_RING_RADIUS, 0, math.sin(angle) * CUP_RING_RADIUS)
		* CFrame.Angles(0, -angle + math.pi/2 + math.pi, 0)
	buildCup(i, cupCF)
end

-- ── Center decoration: porcelain teapot on raised dais ───────────────────────
do
	AB.cylinder(10,   1.2, C.burgundy,     CFrame.new(0, 0.6, 0), m, "TeapotDais")
	AB.cylinder(10.4, 0.4, C.antique_gold, CFrame.new(0, 1.2, 0), m, "TeapotDaisTrim")

	-- Teapot body: squashed ivory sphere
	local body = AB.sphere(7, C.ivory, CFrame.new(0, 4.5, 0), m, "TeapotBody")
	body.Size = Vector3.new(7, 5.5, 7)

	-- Burgundy waist band (16-segment ring)
	for i = 1, 16 do
		local a = (i - 1) / 16 * math.pi * 2
		local len = 2 * 3.6 * math.tan(math.pi / 16) + 0.1
		AB.block(Vector3.new(len, 0.6, 0.5), C.burgundy,
			CFrame.new(math.cos(a) * 3.6, 4.5, math.sin(a) * 3.6)
				* CFrame.Angles(0, -a + math.pi/2, 0),
			m, "TeapotBand_" .. i)
	end

	-- Floral motif
	AB.sphere(2, C.floral_pink, CFrame.new(0, 4.5, 3.5), m, "TeapotFloral")
	AB.block(Vector3.new(1.2, 0.4, 0.4), C.floral_leaf,
		CFrame.new(-1.5, 4.2, 3.3) * CFrame.Angles(0, 0, math.rad(30)), m, "TeapotLeaf_L")
	AB.block(Vector3.new(1.2, 0.4, 0.4), C.floral_leaf,
		CFrame.new(1.5, 4.2, 3.3) * CFrame.Angles(0, 0, math.rad(-30)), m, "TeapotLeaf_R")

	-- Spout (3-segment arch) + handle (3-segment arch)
	for h = 1, 3 do
		local t = (h - 1) / 2
		local sAng = math.rad(-30 + t * 60)
		AB.block(Vector3.new(0.8, 1.4, 0.8), C.ivory,
			CFrame.new(3.8 + math.cos(sAng) * 1.8, 5.0 + math.sin(sAng) * 1.8, 0)
				* CFrame.Angles(0, 0, sAng - math.rad(90)),
			m, "TeapotSpout_" .. h)
		local hAng = math.rad(-60 + t * 120)
		AB.block(Vector3.new(0.6, 1.2, 0.6), C.ivory,
			CFrame.new(-(3.8 + math.cos(hAng) * 0.8), 5.0 + math.sin(hAng) * 1.8, 0)
				* CFrame.Angles(0, 0, -hAng),
			m, "TeapotHandle_" .. h)
	end

	-- Lid + knob
	AB.cylinder(5.5, 0.6, C.ivory,        CFrame.new(0, 7.4, 0), m, "TeapotLid")
	AB.cylinder(5.5, 0.3, C.antique_gold, CFrame.new(0, 7.7, 0), m, "TeapotLidTrim")
	AB.sphere(1.2, C.burgundy,            CFrame.new(0, 8.2, 0), m, "TeapotKnob")
end

-- ── Structural tagging (platter + one flute per cup → 8-fold symmetric ring)
-- Decoration (teapot, florals) must NOT poison the centroid.
platter:AddTag("Structural")
for i = 1, NUM_CUPS do
	local flute = m:FindFirstChild(string.format("Cup%d_Flute_1", i))
	if flute then (flute :: BasePart):AddTag("Structural") end
end

AB.weldAll(m)
m:PivotTo(originalPivot)

local partCount = 0
for _, d in m:GetDescendants() do
	if d:IsA("BasePart") then partCount += 1 end
end

print(string.format(
	"[RideRebuildTeacupRide] Classic Teacups rebuilt: %d parts, %d seats, platter r=%d",
	partCount, NUM_CUPS, PLATTER_RADIUS
))
