-- RideRebuildDropTower: rebuilds workspace.DropTower as a Sundae Drop tower.
--
-- Shape: inverted ice cream cone — wide waffle-cone shell at base tapering up
-- to a narrow neck, topped with a white ice-cream scoop and a cherry. The
-- runtime gondola (built by RideController.buildDropTower at server start)
-- travels vertically up the hollow central axis from Y=DROP_Y_MIN(7) to
-- Y=DROP_Y_MAX(50). The static cone shell sits OUTSIDE that travel column.
--
-- Cherry re-skin: we cannot edit RideController, but we CAN add extra parts
-- welded to the existing DropGondola disc so the carriage reads as a cherry.
-- Welded UNanchored parts ride the anchored gondola's CFrame updates.
--
-- 2× scale: original tower was ~50 studs tall; this build reaches ~110 studs
-- (cone shell to Y=68, scoop to Y=92, cherry to Y=104).
--
-- See docs/handoffs/RIDE_DropTower_INTEGRATION.md for orchestrator notes.

local ServerStorage   = game:GetService("ServerStorage")
local AB              = require(game:GetService("ReplicatedStorage"):WaitForChild("Common"):WaitForChild("AssetBuilder"))

-- ── Hardcoded RideController constants we must respect ──────────────────────
-- Mirrored from RideController.luau lines 41-42 — DO NOT diverge.
-- Gondola is 13-stud diameter (6.5 radius), travels Y=7→Y=50. Cone shell
-- must keep inner radius > 8 from DROP_CX/DROP_CZ along the full travel.
local DROP_CX, DROP_CZ = 155, -175    -- tower center XZ
local DROP_Y_MAX       = 50           -- gondola Y at top of travel (~50.75)

-- ── Cone geometry (scoop above DROP_Y_MAX so gondola doesn't clip) ──────────
local CONE_BASE_Y      = 1            -- bottom Y of cone shell
local CONE_TOP_Y       = DROP_Y_MAX + 18  -- 68: top above DROP_Y_MAX+gondola disc
local CONE_BASE_R      = 30           -- outer radius at base
local CONE_TOP_R       = 13           -- outer radius at top
local CONE_SEGMENTS    = 12           -- ring of vertical wedge slats
local CONE_LAYERS      = 12           -- vertical slat layers
local SCOOP_Y          = 78           -- center Y of scoop sphere
local SCOOP_R          = 16
local CHERRY_Y         = SCOOP_Y + SCOOP_R + 4

-- ── Palette ─────────────────────────────────────────────────────────────────
local WAFFLE_TAN       = Color3.fromRGB(205, 150, 85)
local WAFFLE_DARK      = Color3.fromRGB(150, 100, 55)
local SCOOP_WHITE      = Color3.fromRGB(248, 240, 225)
local CHERRY_RED       = Color3.fromRGB(195, 30, 40)
local CHERRY_GLOSS     = Color3.fromRGB(235, 70, 75)
local STEM_GREEN       = Color3.fromRGB(80, 130, 60)
local SPRINKLE_PINK    = Color3.fromRGB(240, 130, 170)
local SPRINKLE_BLUE    = Color3.fromRGB(120, 170, 230)
local SPRINKLE_YELLOW  = Color3.fromRGB(245, 215, 90)

task.wait(1)  -- let other rebuild scripts and RideController.init land

local m = workspace:FindFirstChild("DropTower") :: Model?
if not m then warn("[RideRebuildDropTower] workspace.DropTower missing"); return end

-- 1. Backup the entire current state (incl. runtime gondola+seats) for safety
local backup = m:Clone()
backup.Name = "DropTower_PreFood_2026-06-03"
backup.Parent = ServerStorage

-- 2. Detach runtime-built named parts so ClearAllChildren doesn't kill them.
--    buildDropTower captures these via Lua refs in dropData; destroying them
--    breaks the ride. Reparent them to a scratch folder during the clear.
local scratch = Instance.new("Folder")
scratch.Name = "DropTowerRuntimeScratch"
scratch.Parent = ServerStorage

local gondola: BasePart? = m:FindFirstChild("DropGondola") :: BasePart?
local seats: { Seat } = {}
local railings: { BasePart } = {}

if gondola then gondola.Parent = scratch end
for _, ch in m:GetChildren() do
	if ch:IsA("Seat") and ch.Name:match("^DropSeat_") then
		ch.Parent = scratch
		table.insert(seats, ch :: Seat)
	end
end
-- 8 anonymous railing posts created by buildDropTower — exact Size 0.3×2×0.3
for _, ch in m:GetChildren() do
	if ch:IsA("BasePart") and ch.Size == Vector3.new(0.3, 2, 0.3) then
		ch.Parent = scratch
		table.insert(railings, ch)
	end
end

-- 3. Clear the rest (old static authored decoration)
m:ClearAllChildren()
m.PrimaryPart = nil

-- ── Build static cone shell (waffle-pattern wedges in a vertical ring) ──────
local cone = AB.model("ConeShell", m)

local function lerp(a: number, b: number, t: number): number return a + (b - a) * t end

for layer = 0, CONE_LAYERS - 1 do
	local t0 = layer / CONE_LAYERS
	local t1 = (layer + 1) / CONE_LAYERS
	local yMid = lerp(CONE_BASE_Y, CONE_TOP_Y, (t0 + t1) * 0.5)
	local rMid = lerp(CONE_BASE_R, CONE_TOP_R, (t0 + t1) * 0.5)
	local h    = (CONE_TOP_Y - CONE_BASE_Y) / CONE_LAYERS + 0.4  -- slight overlap to hide seams
	-- Waffle stripe: alternate light/dark per layer for that wafer-pattern look
	local stripeColor = (layer % 2 == 0) and WAFFLE_TAN or WAFFLE_DARK

	for seg = 1, CONE_SEGMENTS do
		local a = (seg - 1) / CONE_SEGMENTS * math.pi * 2
		local px = DROP_CX + math.cos(a) * rMid
		local pz = DROP_CZ + math.sin(a) * rMid
		-- Tangential block — thickness in radial direction, width along tangent
		local segW = (2 * math.pi * rMid) / CONE_SEGMENTS + 0.3
		local cf   = CFrame.new(px, yMid, pz) * CFrame.Angles(0, -a, 0)
		local slat = AB.block(Vector3.new(2.2, h, segW), stripeColor, cf, cone, "Slat")
		slat.Material = Enum.Material.Sand
	end
end

-- Waffle cross-grid: thin dark vertical ribs every 3rd segment, every other layer
for seg = 1, CONE_SEGMENTS, 3 do
	local a = (seg - 1) / CONE_SEGMENTS * math.pi * 2
	local rTop  = lerp(CONE_BASE_R, CONE_TOP_R, 1) - 0.5
	local rBot  = lerp(CONE_BASE_R, CONE_TOP_R, 0) - 0.5
	-- 4 rib parts down the cone, color = dark
	for i = 0, 3 do
		local tt = i / 3
		local y  = lerp(CONE_BASE_Y + 4, CONE_TOP_Y - 4, tt)
		local r  = lerp(rBot, rTop, tt)
		local px = DROP_CX + math.cos(a) * r
		local pz = DROP_CZ + math.sin(a) * r
		local cf = CFrame.new(px, y, pz) * CFrame.Angles(0, -a, 0)
		AB.block(Vector3.new(0.4, 6, 0.4), WAFFLE_DARK, cf, cone, "WaffleRib")
	end
end

-- ── Cone base — fat tan ring of foundation ─────────────────────────────────
local baseRing = AB.model("BaseRing", m)
local baseRingR = CONE_BASE_R + 2
for seg = 1, 16 do
	local a = (seg - 1) / 16 * math.pi * 2
	local px = DROP_CX + math.cos(a) * baseRingR
	local pz = DROP_CZ + math.sin(a) * baseRingR
	local cf = CFrame.new(px, 0.5, pz) * CFrame.Angles(0, -a, 0)
	AB.block(Vector3.new(4, 2, 12), WAFFLE_DARK, cf, baseRing, "BaseRing")
end

-- Ground disc under the tower (concrete pad so the cone doesn't float on grass)
local pad = AB.cylinder(CONE_BASE_R * 2.4, 1, Color3.fromRGB(180, 175, 165),
	CFrame.new(DROP_CX, 0, DROP_CZ), m, "Pad")
pad.Material = Enum.Material.Concrete

-- ── Scoop crown — white ice cream sphere on top of cone ─────────────────────
local scoop = AB.sphere(SCOOP_R * 2, SCOOP_WHITE, CFrame.new(DROP_CX, SCOOP_Y, DROP_CZ), m, "Scoop")
scoop.Material = Enum.Material.SmoothPlastic
-- Second scoop bump for two-scoop look
local scoop2 = AB.sphere(SCOOP_R * 1.4, SCOOP_WHITE,
	CFrame.new(DROP_CX + 5, SCOOP_Y + 6, DROP_CZ - 3), m, "Scoop2")
scoop2.Material = Enum.Material.SmoothPlastic

-- Sprinkles on the scoop — small tilted cylinders dotted around the top hemisphere
local sprinkleColors = {SPRINKLE_PINK, SPRINKLE_BLUE, SPRINKLE_YELLOW, CHERRY_RED, STEM_GREEN}
for i = 1, 24 do
	local a = i / 24 * math.pi * 2 + math.random() * 0.4
	local elev = math.random() * 0.7 + 0.2     -- upper hemisphere only
	local r = SCOOP_R * math.sqrt(1 - elev*elev)
	local sx = DROP_CX + math.cos(a) * r
	local sz = DROP_CZ + math.sin(a) * r
	local sy = SCOOP_Y + elev * SCOOP_R
	local cf = CFrame.new(sx, sy, sz)
		* CFrame.Angles(math.random() * 2, math.random() * 2, math.random() * 2)
	local c  = sprinkleColors[((i - 1) % #sprinkleColors) + 1]
	AB.cylinder(0.5, 1.6, c, cf, m, "Sprinkle")
end

-- ── Cherry on top — red sphere + green stem ─────────────────────────────────
local cherryTop = AB.sphere(6, CHERRY_RED, CFrame.new(DROP_CX, CHERRY_Y, DROP_CZ), m, "CherryTop")
cherryTop.Material = Enum.Material.SmoothPlastic
cherryTop.Reflectance = 0.15
-- AB.cylinder spec: size=(height, diameter, diameter) then *CFrame.Angles(0,0,90°)
-- That rotation makes the X-axis (cylinder length) point along world +Y → stands up
local stemTop = AB.cylinder(0.8, 5, STEM_GREEN,
	CFrame.new(DROP_CX, CHERRY_Y + 4.5, DROP_CZ), m, "CherryStem")

-- ── Restore runtime parts to the model ──────────────────────────────────────
if gondola then gondola.Parent = m end
for _, s in seats do s.Parent = m end
for _, r in railings do r.Parent = m end
scratch:Destroy()

-- ── Cherry re-skin the gondola: add welded unanchored decoration ────────────
-- The gondola is anchored and CFrame-driven by RideController. WeldConstraint
-- between anchored Part0 and unanchored Part1 makes Part1 follow Part0.
if gondola then
	local function addCherryAdorn(name: string, size: Vector3, localOffset: Vector3, color: Color3, shape: Enum.PartType?)
		local p = Instance.new("Part")
		p.Name = name
		p.Size = size
		p.Color = color
		p.Material = Enum.Material.SmoothPlastic
		p.TopSurface = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
		p.Anchored = false        -- must be false for weld-follow to work
		p.CanCollide = false      -- decorative only
		p.Massless = true
		p.CFrame = gondola.CFrame * CFrame.new(localOffset)
		if shape then p.Shape = shape end
		p.Parent = m
		local w = Instance.new("WeldConstraint")
		w.Part0 = gondola
		w.Part1 = p
		w.Parent = p
		return p
	end
	-- Big red cherry body bulges DOWN below the gondola disc. Size 11 so
	-- bottom sits ~5.5 below gondola; at rest (gondola Y=7) cherry bottom Y=1.5
	-- — clears the Y=0 pad without clipping.
	addCherryAdorn("CherryBody", Vector3.new(11, 11, 11), Vector3.new(0, -5.5, 0),
		CHERRY_RED, Enum.PartType.Ball).Reflectance = 0.1
	-- Cherry highlight gloss patch
	addCherryAdorn("CherryGloss", Vector3.new(3, 3, 3), Vector3.new(-2.5, -2.5, -2.5),
		CHERRY_GLOSS, Enum.PartType.Ball)
	-- Green stem rising above the gondola. PartType.Cylinder length is along X,
	-- so use Size=(length, dia, dia) and rotate Z by 90° to stand it vertical.
	local stem = Instance.new("Part")
	stem.Name = "CherryStem"
	stem.Size = Vector3.new(7, 1.2, 1.2)
	stem.Color = STEM_GREEN
	stem.Material = Enum.Material.SmoothPlastic
	stem.Shape = Enum.PartType.Cylinder
	stem.Anchored = false; stem.CanCollide = false; stem.Massless = true
	stem.CFrame = gondola.CFrame * CFrame.new(0, 4, 0) * CFrame.Angles(0, 0, math.rad(90))
	stem.Parent = m
	local sw = Instance.new("WeldConstraint"); sw.Part0 = gondola; sw.Part1 = stem; sw.Parent = stem
	-- Tiny leaf next to the stem
	addCherryAdorn("CherryLeaf", Vector3.new(3, 0.4, 1.6), Vector3.new(1.2, 6, 0),
		STEM_GREEN)
end

-- ── Set PrimaryPart ─────────────────────────────────────────────────────────
-- `pad` is an AB.cylinder (X-aligned shape rotated 90° around Z to lie flat).
-- Using that as PrimaryPart breaks PivotTo — it un-rotates the whole model.
-- Use an invisible identity-rotation anchor at world (DROP_CX, 0, DROP_CZ)
-- instead.
local pivotAnchor = AB.part({
	size         = Vector3.new(0.1, 0.1, 0.1),
	color        = Color3.new(1, 1, 1),
	cf           = CFrame.new(DROP_CX, 0, DROP_CZ),
	canCollide   = false,
	transparency = 1,
	name         = "PivotAnchor",
}, m)
m.PrimaryPart = pivotAnchor

-- ── Weld static cone parts into one rigid model (skip runtime parts) ────────
-- We weld only the children of `cone` and `baseRing`, plus scoop/sprinkles/
-- cherryTop/stemTop. Skip DropGondola/seats/railings — they're driven by code.
local function weldChildrenTo(root: BasePart, container: Instance)
	for _, d in container:GetDescendants() do
		if d:IsA("BasePart") and d ~= root then
			local w = Instance.new("WeldConstraint")
			w.Part0 = root; w.Part1 = d; w.Parent = root
		end
	end
end
weldChildrenTo(pad, cone)
weldChildrenTo(pad, baseRing)
local staticSingletons = {scoop, scoop2, cherryTop, stemTop}
for _, p in staticSingletons do
	local w = Instance.new("WeldConstraint"); w.Part0 = pad; w.Part1 = p; w.Parent = pad
end
-- sprinkles (children of m, named "Sprinkle")
for _, ch in m:GetChildren() do
	if ch:IsA("BasePart") and ch.Name == "Sprinkle" then
		local w = Instance.new("WeldConstraint"); w.Part0 = pad; w.Part1 = ch; w.Parent = pad
	end
end

print(string.format("[RideRebuildDropTower] Sundae Drop built: %d parts", #m:GetDescendants()))
