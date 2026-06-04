--!strict
-- RideRebuildDropTower: rebuilds workspace.DropTower as the Belle-Époque
-- "Classic Drop Tower" — ivory + antique_gold structural lattice with burgundy
-- accents and an open burgundy/ivory ring-gondola carriage.
--
-- HARD CONTRACT (RideController.luau buildDropTower, lines 180-237):
--   * workspace.DropTower stays a Model — ClearAllChildren only, never destroy.
--   * Runtime children (DropGondola, DropSeat_1..6, 8 anonymous railing posts)
--     held by Lua refs in dropData — detach to scratch before clear, restore.
--   * Preserved RideController constants: DROP_CX=155, DROP_CZ=-175, DROP_Y_MIN=7.
--
-- SCALE: tower TOP_Y = 40 (was ~110 food-shape, ~50 stock). Per playbook §9.
--
-- INTEGRATION FLAG: DROP_Y_MAX is 50 in RideController but tower cap is at
-- Y=40 — gondola would punch through. Recommend orchestrator reduce
-- DROP_Y_MAX → 33. See docs/handoffs/RIDE_DropTower_INTEGRATION.md.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage     = game:GetService("ServerStorage")
local AB = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetBuilder"))

local DROP_CX, DROP_CZ = 155, -175
local TOP_Y    = 40
local R_BOT    = 11
local R_TOP    = 8
local CORNERS  = 4
local ROWS     = 6
local PAD_R    = 22

local IVORY        = Color3.fromRGB(245, 235, 205)
local GOLD         = Color3.fromRGB(200, 160,  80)
local BURGUNDY     = Color3.fromRGB(130,  30,  50)
local IRON         = Color3.fromRGB( 40,  35,  40)
local CREAM        = Color3.fromRGB(230, 215, 180)
local CRIMSON_GLOW = Color3.fromRGB(220,  60,  70)
local PAD_STONE    = Color3.fromRGB(180, 175, 165)

task.wait(1)

local m = workspace:FindFirstChild("DropTower") :: Model?
if not m then warn("[RideRebuildDropTower] workspace.DropTower missing"); return end

-- 1) Backup
do
	local clone = m:Clone()
	clone.Name = "DropTower_PreBelleEpoque_2026-06-03"
	clone.Parent = ServerStorage
end

-- 2) Detach RideController-built runtime parts before clear
local scratch = Instance.new("Folder"); scratch.Name = "DropTowerRuntimeScratch"; scratch.Parent = ServerStorage
local gondola: BasePart? = m:FindFirstChild("DropGondola") :: BasePart?
local seats: { Seat } = {}
local railings: { BasePart } = {}
if gondola then gondola.Parent = scratch end
for _, ch in m:GetChildren() do
	if ch:IsA("Seat") and ch.Name:match("^DropSeat_") then
		ch.Parent = scratch; table.insert(seats, ch :: Seat)
	end
end
for _, ch in m:GetChildren() do
	if ch:IsA("BasePart") and ch.Size == Vector3.new(0.3, 2, 0.3) then
		ch.Parent = scratch; table.insert(railings, ch)
	end
end

m:ClearAllChildren()
m.PrimaryPart = nil

-- 3) Identity-rotation PivotAnchor (MANDATORY per playbook §5)
local pivotAnchor = AB.part({
	size = Vector3.new(0.1, 0.1, 0.1), color = Color3.new(1,1,1),
	cf = CFrame.new(DROP_CX, 0, DROP_CZ), canCollide = false,
	transparency = 1, name = "PivotAnchor",
}, m)
m.PrimaryPart = pivotAnchor

local function lerp(a: number, b: number, t: number): number return a + (b - a) * t end

local function cornerXZ(idx: number, radius: number): (number, number)
	local a = (idx - 1) / CORNERS * math.pi * 2 + math.rad(45)
	return DROP_CX + math.cos(a) * radius, DROP_CZ + math.sin(a) * radius
end

local function setMat(p: BasePart, mat: Enum.Material): BasePart p.Material = mat; return p end

-- Aligned-block CFrame between p1 and p2 (X dim → tangent, Y dim → along dir,
-- Z dim → bitangent). Uses an explicit up-vector to avoid CFrame.lookAt
-- degenerating when `dir` is nearly parallel to world up.
local function alignedCF(p1: Vector3, p2: Vector3): (CFrame, number)
	local mid = (p1 + p2) / 2
	local len = (p2 - p1).Magnitude
	if len < 1e-3 then return CFrame.new(mid), 0 end
	local dir = (p2 - p1) / len
	local refUp = (math.abs(dir.Y) > 0.9) and Vector3.new(1, 0, 0) or Vector3.new(0, 1, 0)
	local right = dir:Cross(refUp).Unit
	local up    = right:Cross(dir).Unit
	-- Construct CFrame with columns: right(X), dir(Y), up(Z-ish)
	return CFrame.fromMatrix(mid, right, dir, up), len
end

-- Ground pad + burgundy trim ring
setMat(AB.cylinder(PAD_R * 2, 1.2, PAD_STONE,
	CFrame.new(DROP_CX, 0.1, DROP_CZ), m, "Pad"), Enum.Material.Slate)
for i = 1, 16 do
	local a = (i - 1) / 16 * math.pi * 2
	local px, pz = DROP_CX + math.cos(a) * (PAD_R - 0.5), DROP_CZ + math.sin(a) * (PAD_R - 0.5)
	setMat(AB.block(Vector3.new(2, 0.8, 5), BURGUNDY,
		CFrame.new(px, 0.6, pz) * CFrame.Angles(0, -a, 0), m, "PadTrim"),
		Enum.Material.SmoothPlastic)
end

-- 4 ivory marble corner masts with gold caps
for c = 1, CORNERS do
	local xb, zb = cornerXZ(c, R_BOT)
	local xt, zt = cornerXZ(c, R_TOP)
	local cf, len = alignedCF(Vector3.new(xb, 1, zb), Vector3.new(xt, TOP_Y - 1, zt))
	setMat(AB.block(Vector3.new(1.4, len, 1.4), IVORY, cf, m, "Mast" .. c),
		Enum.Material.Marble)
	setMat(AB.block(Vector3.new(2.2, 1.6, 2.2), GOLD,
		CFrame.new(xb, 1.8, zb), m, "MastBase" .. c), Enum.Material.Metal)
	setMat(AB.block(Vector3.new(2.2, 1.6, 2.2), GOLD,
		CFrame.new(xt, TOP_Y - 1.2, zt), m, "MastCap" .. c), Enum.Material.Metal)
end

-- Horizontal lattice braces (alternating gold/ivory)
for row = 0, ROWS - 1 do
	local t = row / (ROWS - 1)
	local y = lerp(4, TOP_Y - 2, t)
	local r = lerp(R_BOT, R_TOP, t)
	local col = (row % 2 == 0) and GOLD or IVORY
	local mat: Enum.Material = (row % 2 == 0) and Enum.Material.Metal or Enum.Material.Marble
	for c = 1, CORNERS do
		local x1, z1 = cornerXZ(c, r)
		local x2, z2 = cornerXZ((c % CORNERS) + 1, r)
		local cf, segLen = alignedCF(Vector3.new(x1, y, z1), Vector3.new(x2, y, z2))
		setMat(AB.block(Vector3.new(0.8, segLen, 0.8), col, cf,
			m, "Brace" .. row .. "_" .. c), mat)
	end
end

-- Wrought_iron X-bracing (decorative diagonals per face)
local function buildDiag(name: string, x1: number, y1: number, z1: number,
		x2: number, y2: number, z2: number)
	local cf, len = alignedCF(Vector3.new(x1, y1, z1), Vector3.new(x2, y2, z2))
	setMat(AB.block(Vector3.new(0.5, len, 0.5), IRON, cf, m, name),
		Enum.Material.Metal)
end
for c = 1, CORNERS do
	local nxt = (c % CORNERS) + 1
	local bx1, bz1 = cornerXZ(c,   R_BOT)
	local tx2, tz2 = cornerXZ(nxt, R_TOP)
	buildDiag("Diag" .. c .. "A", bx1, 4, bz1, tx2, TOP_Y - 2, tz2)
	local tx1, tz1 = cornerXZ(c,   R_TOP)
	local bx2, bz2 = cornerXZ(nxt, R_BOT)
	buildDiag("Diag" .. c .. "B", tx1, TOP_Y - 2, tz1, bx2, 4, bz2)
end

-- Burgundy mid-height banners between masts
for c = 1, CORNERS do
	local nxt = (c % CORNERS) + 1
	local r = lerp(R_BOT, R_TOP, 0.5)
	local x1, z1 = cornerXZ(c, r); local x2, z2 = cornerXZ(nxt, r)
	-- Banner spans 60% of face width, centered, hanging from mid-height
	local p1 = Vector3.new(x1, TOP_Y / 2, z1)
	local p2 = Vector3.new(x2, TOP_Y / 2, z2)
	local mid = (p1 + p2) / 2
	local dir = (p2 - p1).Unit
	local refUp = Vector3.new(0, 1, 0)
	local right = dir:Cross(refUp).Unit
	local up    = right:Cross(dir).Unit
	local cf = CFrame.fromMatrix(mid, dir, up, right)
	local fullLen = (p2 - p1).Magnitude
	setMat(AB.block(Vector3.new(fullLen * 0.6, 5, 0.3), BURGUNDY, cf,
		m, "Banner" .. c), Enum.Material.Fabric)
end

-- Tower crown: gold disc + dome + finial + crimson_glow orb
setMat(AB.cylinder(R_TOP * 2.2, 1.4, GOLD,
	CFrame.new(DROP_CX, TOP_Y - 0.5, DROP_CZ), m, "CrownPlate"), Enum.Material.Metal)
setMat(AB.sphere(8, GOLD,
	CFrame.new(DROP_CX, TOP_Y + 2.5, DROP_CZ), m, "CrownDome"), Enum.Material.Metal)
setMat(AB.cylinder(0.6, 5, GOLD,
	CFrame.new(DROP_CX, TOP_Y + 8, DROP_CZ), m, "Finial"), Enum.Material.Metal)
local orb = AB.sphere(2.2, CRIMSON_GLOW,
	CFrame.new(DROP_CX, TOP_Y + 11, DROP_CZ), m, "FinialOrb")
orb.Material = Enum.Material.Neon; orb.Reflectance = 0.2

-- Wrought_iron boarding fence, gapped on south for DropBoardZone access
for i = 1, 12 do
	local a = (i - 1) / 12 * math.pi * 2
	if math.sin(a) > -0.7 then
		local px, pz = DROP_CX + math.cos(a) * (PAD_R - 1.2), DROP_CZ + math.sin(a) * (PAD_R - 1.2)
		setMat(AB.block(Vector3.new(0.4, 3, 0.4), IRON,
			CFrame.new(px, 1.7, pz), m, "FencePost"), Enum.Material.Metal)
		setMat(AB.sphere(0.9, CREAM,
			CFrame.new(px, 3.6, pz), m, "FenceCap"), Enum.Material.Marble)
	end
end

-- Restore runtime parts
if gondola then gondola.Parent = m end
for _, s in seats do s.Parent = m end
for _, r in railings do r.Parent = m end
scratch:Destroy()

-- Gondola re-skin: in-place recolor of runtime parts (RideController only
-- updates CFrame each frame, not Color/Material — so the recolor sticks)
if gondola then
	gondola.Color = BURGUNDY; gondola.Material = Enum.Material.SmoothPlastic
end
for _, s in seats do s.Color = IVORY; s.Material = Enum.Material.Marble end
for _, r in railings do r.Color = GOLD; r.Material = Enum.Material.Metal end

-- Decorative adorn welded to gondola (unanchored, Massless, follows via WeldConstraint)
local function addAdorn(name: string, size: Vector3, off: Vector3, color: Color3,
		mat: Enum.Material, shape: Enum.PartType?, rotZ: number?): Part
	assert(gondola, "gondola required")
	local p = Instance.new("Part")
	p.Name = name; p.Size = size; p.Color = color; p.Material = mat
	p.Anchored = false; p.CanCollide = false; p.Massless = true
	p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	local cf = gondola.CFrame * CFrame.new(off)
	if rotZ then cf = cf * CFrame.Angles(0, 0, rotZ) end
	p.CFrame = cf; p.Parent = m
	local w = Instance.new("WeldConstraint"); w.Part0 = gondola; w.Part1 = p; w.Parent = p
	return p
end

if gondola then
	-- Ivory rim band around carriage edge
	for i = 1, 12 do
		local a = (i - 1) / 12 * math.pi * 2
		addAdorn("GondRim" .. i, Vector3.new(0.6, 0.6, 2.2),
			Vector3.new(math.cos(a) * 6.3, 0.6, math.sin(a) * 6.3),
			IVORY, Enum.Material.Marble)
	end
	-- Gold center hub
	addAdorn("GondHub", Vector3.new(2.6, 1.2, 2.6), Vector3.new(0, 0.85, 0),
		GOLD, Enum.Material.Metal, Enum.PartType.Cylinder, math.rad(90))
	-- Burgundy underskirt (decorative depth; clears Y=0 pad at DROP_Y_MIN=7)
	addAdorn("GondSkirt", Vector3.new(12, 1.2, 12), Vector3.new(0, -1.4, 0),
		BURGUNDY, Enum.Material.SmoothPlastic, Enum.PartType.Cylinder, math.rad(90))
end

print(("[RideRebuildDropTower] Classic Drop Tower built: %d descendants, tower top Y=%d")
	:format(#m:GetDescendants(), TOP_Y))
