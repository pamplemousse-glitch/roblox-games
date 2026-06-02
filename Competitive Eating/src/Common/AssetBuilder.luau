-- AssetBuilder: shorthand library for building Roblox primitive-based assets.
-- Lets parallel sessions / asset modules be 80 lines instead of 300.
--
-- Convention: every asset module exports a function with signature
--   (parent: Instance, originCF: CFrame) -> Model
-- where originCF is the world-space anchor for the asset's local origin.

local AssetBuilder = {}

-- ── Shape primitives ─────────────────────────────────────────────────────────

type PartSpec = {
	size:           Vector3?,
	color:          Color3?,
	material:       Enum.Material?,
	cf:             CFrame?,
	name:           string?,
	transparency:   number?,
	reflectance:    number?,
	canCollide:     boolean?,
	anchored:       boolean?,
	shape:          Enum.PartType?,
}

function AssetBuilder.part(spec: PartSpec, parent: Instance?): Part
	local p = Instance.new("Part")
	p.Size                  = spec.size            or Vector3.new(1, 1, 1)
	p.Color                 = spec.color           or Color3.fromRGB(180, 180, 180)
	p.Material              = spec.material        or Enum.Material.SmoothPlastic
	p.CFrame                = spec.cf              or CFrame.new()
	p.Name                  = spec.name            or "Part"
	p.Transparency          = spec.transparency    or 0
	p.Reflectance           = spec.reflectance     or 0
	p.CanCollide            = spec.canCollide ~= false
	p.Anchored              = spec.anchored ~= false
	p.TopSurface            = Enum.SurfaceType.Smooth
	p.BottomSurface         = Enum.SurfaceType.Smooth
	if spec.shape then p.Shape = spec.shape end
	if parent then p.Parent = parent end
	return p
end

function AssetBuilder.block(size: Vector3, color: Color3, cf: CFrame, parent: Instance?, name: string?): Part
	return AssetBuilder.part({size=size, color=color, cf=cf, name=name}, parent)
end

function AssetBuilder.cylinder(diameter: number, height: number, color: Color3, cf: CFrame, parent: Instance?, name: string?): Part
	-- Roblox cylinders are oriented along X. We pass height as the X dimension
	-- and apply a 90-deg Z rotation so the cylinder stands "up" in world.
	return AssetBuilder.part({
		size  = Vector3.new(height, diameter, diameter),
		color = color,
		cf    = cf * CFrame.Angles(0, 0, math.rad(90)),
		shape = Enum.PartType.Cylinder,
		name  = name or "Cylinder",
	}, parent)
end

function AssetBuilder.sphere(diameter: number, color: Color3, cf: CFrame, parent: Instance?, name: string?): Part
	return AssetBuilder.part({
		size  = Vector3.new(diameter, diameter, diameter),
		color = color,
		cf    = cf,
		shape = Enum.PartType.Ball,
		name  = name or "Sphere",
	}, parent)
end

function AssetBuilder.wedge(size: Vector3, color: Color3, cf: CFrame, parent: Instance?, name: string?): WedgePart
	local w = Instance.new("WedgePart")
	w.Size      = size
	w.Color     = color
	w.Material  = Enum.Material.SmoothPlastic
	w.CFrame    = cf
	w.Name      = name or "Wedge"
	w.Anchored  = true
	w.CanCollide = true
	if parent then w.Parent = parent end
	return w
end

-- ── Model creation ───────────────────────────────────────────────────────────

function AssetBuilder.model(name: string, parent: Instance?): Model
	local m = Instance.new("Model")
	m.Name = name
	if parent then m.Parent = parent end
	return m
end

-- Set a model's primary part + pivot. Pass nil for primary to default to first BasePart.
function AssetBuilder.pivot(model: Model, primary: BasePart?)
	primary = primary or model:FindFirstChildWhichIsA("BasePart")
	if primary then model.PrimaryPart = primary end
end

-- ── Decorations ──────────────────────────────────────────────────────────────

function AssetBuilder.uiCorner(parent: Instance, radius: number?): UICorner
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 8)
	c.Parent       = parent
	return c
end

function AssetBuilder.glow(part: BasePart, color: Color3?, brightness: number?): PointLight
	local light = Instance.new("PointLight")
	light.Color      = color      or part.Color
	light.Brightness = brightness or 1.5
	light.Range      = 12
	light.Parent     = part
	return light
end

function AssetBuilder.neon(part: BasePart): BasePart
	part.Material    = Enum.Material.Neon
	return part
end

function AssetBuilder.billboard(parent: Instance, text: string, size: Vector2?, yOffset: number?): BillboardGui
	local gui = Instance.new("BillboardGui")
	gui.Name           = "NameTag"
	gui.Size           = UDim2.fromOffset((size and size.X) or 200, (size and size.Y) or 36)
	gui.StudsOffset    = Vector3.new(0, yOffset or 3, 0)
	gui.AlwaysOnTop    = true
	gui.Parent         = parent

	local label = Instance.new("TextLabel")
	label.Size              = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.TextColor3        = Color3.new(1, 1, 1)
	label.TextStrokeColor3  = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 0
	label.Font              = Enum.Font.GothamBold
	label.TextScaled        = true
	label.Text              = text
	label.Parent            = gui
	return gui
end

-- ── Welding ──────────────────────────────────────────────────────────────────

function AssetBuilder.weld(a: BasePart, b: BasePart): WeldConstraint
	local w = Instance.new("WeldConstraint")
	w.Part0  = a
	w.Part1  = b
	w.Parent = a
	return w
end

-- Weld all descendants of a model to its PrimaryPart.
function AssetBuilder.weldAll(model: Model)
	local root = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
	if not root then return end
	for _, d in model:GetDescendants() do
		if d:IsA("BasePart") and d ~= root then
			AssetBuilder.weld(root, d)
		end
	end
end

-- ── CFrame helpers ───────────────────────────────────────────────────────────

-- Relative CFrame from origin: x studs right, y up, z forward, optional yaw deg.
function AssetBuilder.offset(originCF: CFrame, x: number, y: number, z: number, yawDeg: number?): CFrame
	local rot = yawDeg and CFrame.Angles(0, math.rad(yawDeg), 0) or CFrame.new()
	return originCF * CFrame.new(x, y, z) * rot
end

-- ── Stack helper (for food piles, brick walls, etc.) ─────────────────────────

-- Stack `count` items vertically starting at originCF. Each item is built via
-- `factory(i, cf)` and parented to `parent`. Returns the list of created parts.
function AssetBuilder.vstack(originCF: CFrame, itemHeight: number, count: number, parent: Instance, factory: (i: number, cf: CFrame) -> BasePart): { BasePart }
	local out = {}
	for i = 1, count do
		local cf = originCF * CFrame.new(0, (i - 1) * itemHeight, 0)
		table.insert(out, factory(i, cf))
	end
	return out
end

-- Distribute `count` items in a circle of `radius` around originCF.
function AssetBuilder.circleArrange(originCF: CFrame, radius: number, count: number, parent: Instance, factory: (i: number, cf: CFrame, angleDeg: number) -> BasePart): { BasePart }
	local out = {}
	for i = 1, count do
		local angle = ((i - 1) / count) * 2 * math.pi
		local x     = radius * math.cos(angle)
		local z     = radius * math.sin(angle)
		local cf    = originCF * CFrame.new(x, 0, z) * CFrame.Angles(0, -angle, 0)
		table.insert(out, factory(i, cf, math.deg(angle)))
	end
	return out
end

-- ── Color palette helpers ────────────────────────────────────────────────────

AssetBuilder.colors = {
	bunTan          = Color3.fromRGB(220, 170, 110),
	mustard         = Color3.fromRGB(220, 175, 50),
	ketchup         = Color3.fromRGB(220, 50, 50),
	cheese          = Color3.fromRGB(255, 215, 80),
	burgerBrown     = Color3.fromRGB(140, 80, 40),
	lettuce         = Color3.fromRGB(120, 200, 90),
	tomato          = Color3.fromRGB(220, 60, 50),
	chocolate       = Color3.fromRGB(110, 60, 30),
	strawberry      = Color3.fromRGB(255, 100, 130),
	vanilla         = Color3.fromRGB(245, 230, 210),
	pizzaRed        = Color3.fromRGB(210, 50, 50),
	pizzaCrust      = Color3.fromRGB(220, 180, 100),
	pretzelBrown    = Color3.fromRGB(180, 130, 70),
	carnivalRed     = Color3.fromRGB(180, 30, 40),
	carnivalGold    = Color3.fromRGB(220, 180, 60),
	burgundy        = Color3.fromRGB(110, 30, 40),
	ivory           = Color3.fromRGB(230, 220, 195),
	deepWood        = Color3.fromRGB(80, 50, 30),
}

-- ── R6 NPC rig ───────────────────────────────────────────────────────────────
-- Builds a Roblox-standard R6 character (6 parts + Humanoid + Animator + 6
-- Motor6Ds) at originCF. originCF is the world-space pivot of the Torso center.
-- Parts are anchored so NPCs stand in place without physics; animations still
-- play through the Animator. Pass per-part colors to theme the NPC.

type RigColors = {
	head:     Color3?,
	torso:    Color3?,
	leftArm:  Color3?,
	rightArm: Color3?,
	leftLeg:  Color3?,
	rightLeg: Color3?,
	pants:    Color3?,   -- alias: colors both legs the same
	skin:     Color3?,   -- alias: colors head + both arms the same
	shirt:    Color3?,   -- alias: colors torso the same
}

function AssetBuilder.r6Rig(parent: Instance, originCF: CFrame, name: string, colors: RigColors): Model
	colors = colors or {}
	local skin     = colors.skin     or Color3.fromRGB(255, 220, 180)
	local shirt    = colors.shirt    or Color3.fromRGB(80, 80, 130)
	local pants    = colors.pants    or Color3.fromRGB(45, 45, 60)
	local cHead    = colors.head     or skin
	local cTorso   = colors.torso    or shirt
	local cLArm    = colors.leftArm  or skin
	local cRArm    = colors.rightArm or skin
	local cLLeg    = colors.leftLeg  or pants
	local cRLeg    = colors.rightLeg or pants

	local model = Instance.new("Model")
	model.Name   = name
	model.Parent = parent

	local function mkPart(pname: string, size: Vector3, color: Color3, localPos: Vector3): Part
		local p = Instance.new("Part")
		p.Name          = pname
		p.Size          = size
		p.Color         = color
		p.Material      = Enum.Material.SmoothPlastic
		p.TopSurface    = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
		p.Anchored      = true
		p.CanCollide    = pname ~= "HumanoidRootPart"
		p.Transparency  = pname == "HumanoidRootPart" and 1 or 0
		p.CFrame        = originCF * CFrame.new(localPos)
		p.Parent        = model
		return p
	end

	local hrp   = mkPart("HumanoidRootPart", Vector3.new(2, 2, 1), Color3.new(0.4, 0.4, 0.4), Vector3.new(0, 0, 0))
	local torso = mkPart("Torso",            Vector3.new(2, 2, 1), cTorso, Vector3.new(0, 0, 0))
	local head  = mkPart("Head",             Vector3.new(2, 1, 1), cHead,  Vector3.new(0, 1.5, 0))
	local lArm  = mkPart("Left Arm",         Vector3.new(1, 2, 1), cLArm,  Vector3.new(-1.5, 0, 0))
	local rArm  = mkPart("Right Arm",        Vector3.new(1, 2, 1), cRArm,  Vector3.new( 1.5, 0, 0))
	local lLeg  = mkPart("Left Leg",         Vector3.new(1, 2, 1), cLLeg,  Vector3.new(-0.5, -2, 0))
	local rLeg  = mkPart("Right Leg",        Vector3.new(1, 2, 1), cRLeg,  Vector3.new( 0.5, -2, 0))

	-- Mesh on head to round it (matches Roblox default R6 head)
	local headMesh = Instance.new("SpecialMesh")
	headMesh.MeshType = Enum.MeshType.Head
	headMesh.Scale    = Vector3.new(1.25, 1.25, 1.25)
	headMesh.Parent   = head

	local function motor(jointName: string, p0: BasePart, p1: BasePart, c0: CFrame, c1: CFrame, parentPart: BasePart)
		local m = Instance.new("Motor6D")
		m.Name   = jointName
		m.Part0  = p0
		m.Part1  = p1
		m.C0     = c0
		m.C1     = c1
		m.Parent = parentPart
		return m
	end

	local PI = math.pi
	motor("RootJoint", hrp, torso,
		CFrame.new(0,0,0) * CFrame.Angles(-PI/2, 0, PI),
		CFrame.new(0,0,0) * CFrame.Angles(-PI/2, 0, PI), hrp)
	motor("Neck", torso, head,
		CFrame.new(0,  1,   0) * CFrame.Angles(-PI/2, 0, PI),
		CFrame.new(0, -0.5, 0) * CFrame.Angles(-PI/2, 0, PI), torso)
	motor("Right Shoulder", torso, rArm,
		CFrame.new( 1,  0.5, 0) * CFrame.Angles(0,  PI/2, 0),
		CFrame.new(-0.5, 0.5, 0) * CFrame.Angles(0,  PI/2, 0), torso)
	motor("Left Shoulder", torso, lArm,
		CFrame.new(-1,  0.5, 0) * CFrame.Angles(0, -PI/2, 0),
		CFrame.new( 0.5, 0.5, 0) * CFrame.Angles(0, -PI/2, 0), torso)
	motor("Right Hip", torso, rLeg,
		CFrame.new(0.5, -1, 0) * CFrame.Angles(0,  PI/2, 0),
		CFrame.new(0,    1, 0) * CFrame.Angles(0,  PI/2, 0), torso)
	motor("Left Hip", torso, lLeg,
		CFrame.new(-0.5, -1, 0) * CFrame.Angles(0, -PI/2, 0),
		CFrame.new( 0,    1, 0) * CFrame.Angles(0, -PI/2, 0), torso)

	local humanoid = Instance.new("Humanoid")
	humanoid.RigType        = Enum.HumanoidRigType.R6
	humanoid.MaxHealth      = 100
	humanoid.Health         = 100
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoid.HealthDisplayType   = Enum.HumanoidHealthDisplayType.AlwaysOff
	humanoid.Parent         = model

	local animator = Instance.new("Animator")
	animator.Parent = humanoid

	model.PrimaryPart = hrp
	return model
end

-- Add a name BillboardGui above a rig's head.
function AssetBuilder.r6NameTag(model: Model, displayName: string)
	local head = model:FindFirstChild("Head")
	if not head then return end
	local bb = Instance.new("BillboardGui")
	bb.Name           = "NameTag"
	bb.Adornee        = head
	bb.Size           = UDim2.fromOffset(80, 16)
	bb.StudsOffset    = Vector3.new(0, 2.5, 0)
	bb.AlwaysOnTop    = false
	bb.MaxDistance    = 50
	bb.Parent         = head
	local lbl = Instance.new("TextLabel")
	lbl.Size           = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Text           = displayName
	lbl.TextColor3     = Color3.fromRGB(255, 255, 255)
	lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	lbl.TextStrokeTransparency = 0
	lbl.TextScaled     = false
	lbl.TextSize       = 12
	lbl.Font           = Enum.Font.GothamBold
	lbl.Parent         = bb
end

-- ── R15 NPC rig ──────────────────────────────────────────────────────────────
-- Builds an R15 character (16 parts including HRP + Humanoid + Animator + 15
-- Motor6Ds) at originCF. Same world convention as r6Rig: passing
-- `manifestCF * CFrame.new(0, -3, 0)` puts foot bottoms at the manifest's Y.
-- HipHeight = 2, all parts anchored. Joint NAMES match the Roblox R15
-- convention so default R15 animations (e.g. idle) play correctly.
--
-- Per-part colors honour the same RigColors table as r6Rig:
--   skin  → head + arms (all 6 arm segments)
--   shirt → upper + lower torso
--   pants → legs (all 6 leg segments)
-- The leftArm/rightArm/leftLeg/rightLeg aliases tint that whole limb chain
-- (upper + lower + hand/foot) the same way they tint a single R6 limb.

function AssetBuilder.r15Rig(parent: Instance, originCF: CFrame, name: string, colors: RigColors): Model
	colors = colors or {}
	local skin   = colors.skin     or Color3.fromRGB(255, 220, 180)
	local shirt  = colors.shirt    or Color3.fromRGB(80, 80, 130)
	local pants  = colors.pants    or Color3.fromRGB(45, 45, 60)
	local cHead  = colors.head     or skin
	local cTorso = colors.torso    or shirt
	local cLArm  = colors.leftArm  or skin
	local cRArm  = colors.rightArm or skin
	local cLLeg  = colors.leftLeg  or pants
	local cRLeg  = colors.rightLeg or pants

	local model = Instance.new("Model")
	model.Name   = name
	model.Parent = parent

	local function mkPart(pname: string, size: Vector3, color: Color3, localPos: Vector3): Part
		local p = Instance.new("Part")
		p.Name          = pname
		p.Size          = size
		p.Color         = color
		p.Material      = Enum.Material.SmoothPlastic
		p.TopSurface    = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
		p.Anchored      = true
		p.CanCollide    = pname ~= "HumanoidRootPart"
		p.Transparency  = pname == "HumanoidRootPart" and 1 or 0
		p.CFrame        = originCF * CFrame.new(localPos)
		p.Parent        = model
		return p
	end

	-- Vertical layout (Y, local): foot bottom at -3, head top at +2.9.
	-- Foot 0.4 → LowerLeg 1.4 → UpperLeg 1.2 → LowerTorso 0.5 → UpperTorso 1.2 → Head 1.0
	local hrp        = mkPart("HumanoidRootPart", Vector3.new(2, 2, 1),   Color3.new(0.4, 0.4, 0.4), Vector3.new(0, 0, 0))
	local lowerTorso = mkPart("LowerTorso",       Vector3.new(2, 0.5, 1), cTorso, Vector3.new(0, 0.25, 0))
	local upperTorso = mkPart("UpperTorso",       Vector3.new(2, 1.2, 1), cTorso, Vector3.new(0, 1.1, 0))
	local head       = mkPart("Head",             Vector3.new(2, 1, 1),   cHead,  Vector3.new(0, 2.3, 0))

	-- Arms hang from the UpperTorso shoulders.
	local rUpperArm = mkPart("RightUpperArm", Vector3.new(1, 1.4, 1), cRArm, Vector3.new( 1.5,  1.0,  0))
	local rLowerArm = mkPart("RightLowerArm", Vector3.new(1, 1.4, 1), cRArm, Vector3.new( 1.5, -0.3,  0))
	local rHand     = mkPart("RightHand",     Vector3.new(1, 0.4, 1), cRArm, Vector3.new( 1.5, -1.2,  0))
	local lUpperArm = mkPart("LeftUpperArm",  Vector3.new(1, 1.4, 1), cLArm, Vector3.new(-1.5,  1.0,  0))
	local lLowerArm = mkPart("LeftLowerArm",  Vector3.new(1, 1.4, 1), cLArm, Vector3.new(-1.5, -0.3,  0))
	local lHand     = mkPart("LeftHand",      Vector3.new(1, 0.4, 1), cLArm, Vector3.new(-1.5, -1.2,  0))

	-- Legs hang from the LowerTorso hips.
	local rUpperLeg = mkPart("RightUpperLeg", Vector3.new(1, 1.2, 1), cRLeg, Vector3.new( 0.5, -0.6,  0))
	local rLowerLeg = mkPart("RightLowerLeg", Vector3.new(1, 1.4, 1), cRLeg, Vector3.new( 0.5, -1.9,  0))
	local rFoot     = mkPart("RightFoot",     Vector3.new(1, 0.4, 1), cRLeg, Vector3.new( 0.5, -2.8,  0))
	local lUpperLeg = mkPart("LeftUpperLeg",  Vector3.new(1, 1.2, 1), cLLeg, Vector3.new(-0.5, -0.6,  0))
	local lLowerLeg = mkPart("LeftLowerLeg",  Vector3.new(1, 1.4, 1), cLLeg, Vector3.new(-0.5, -1.9,  0))
	local lFoot     = mkPart("LeftFoot",      Vector3.new(1, 0.4, 1), cLLeg, Vector3.new(-0.5, -2.8,  0))

	-- Mesh on head to round it (matches Roblox default head)
	local headMesh = Instance.new("SpecialMesh")
	headMesh.MeshType = Enum.MeshType.Head
	headMesh.Scale    = Vector3.new(1.25, 1.25, 1.25)
	headMesh.Parent   = head

	local function motor(jointName: string, p0: BasePart, p1: BasePart, c0: CFrame, c1: CFrame, parentPart: BasePart)
		local m = Instance.new("Motor6D")
		m.Name   = jointName
		m.Part0  = p0
		m.Part1  = p1
		m.C0     = c0
		m.C1     = c1
		m.Parent = parentPart
		return m
	end

	-- Torso column. Joints anchor at the seam between successive parts.
	motor("Root",  hrp,        lowerTorso, CFrame.new(0,  0,    0), CFrame.new(0,  0.25, 0), hrp)
	motor("Waist", lowerTorso, upperTorso, CFrame.new(0,  0.25, 0), CFrame.new(0, -0.6,  0), lowerTorso)
	motor("Neck",  upperTorso, head,       CFrame.new(0,  0.6,  0), CFrame.new(0, -0.5,  0), upperTorso)

	-- Arm chain: Shoulder/Elbow/Wrist pivot at the seam between segments.
	motor("RightShoulder", upperTorso, rUpperArm, CFrame.new( 1.0,  0.5, 0), CFrame.new(0,  0.7, 0), upperTorso)
	motor("RightElbow",    rUpperArm,  rLowerArm, CFrame.new(0,   -0.7, 0), CFrame.new(0,  0.7, 0), rUpperArm)
	motor("RightWrist",    rLowerArm,  rHand,     CFrame.new(0,   -0.7, 0), CFrame.new(0,  0.2, 0), rLowerArm)
	motor("LeftShoulder",  upperTorso, lUpperArm, CFrame.new(-1.0,  0.5, 0), CFrame.new(0,  0.7, 0), upperTorso)
	motor("LeftElbow",     lUpperArm,  lLowerArm, CFrame.new(0,   -0.7, 0), CFrame.new(0,  0.7, 0), lUpperArm)
	motor("LeftWrist",     lLowerArm,  lHand,     CFrame.new(0,   -0.7, 0), CFrame.new(0,  0.2, 0), lLowerArm)

	-- Leg chain: Hip/Knee/Ankle pivot at the seam between segments.
	motor("RightHip",   lowerTorso, rUpperLeg, CFrame.new( 0.5, -0.25, 0), CFrame.new(0,  0.6, 0), lowerTorso)
	motor("RightKnee",  rUpperLeg,  rLowerLeg, CFrame.new(0,   -0.6,  0), CFrame.new(0,  0.7, 0), rUpperLeg)
	motor("RightAnkle", rLowerLeg,  rFoot,     CFrame.new(0,   -0.7,  0), CFrame.new(0,  0.2, 0), rLowerLeg)
	motor("LeftHip",    lowerTorso, lUpperLeg, CFrame.new(-0.5, -0.25, 0), CFrame.new(0,  0.6, 0), lowerTorso)
	motor("LeftKnee",   lUpperLeg,  lLowerLeg, CFrame.new(0,   -0.6,  0), CFrame.new(0,  0.7, 0), lUpperLeg)
	motor("LeftAnkle",  lLowerLeg,  lFoot,     CFrame.new(0,   -0.7,  0), CFrame.new(0,  0.2, 0), lLowerLeg)

	local humanoid = Instance.new("Humanoid")
	humanoid.RigType             = Enum.HumanoidRigType.R15
	humanoid.MaxHealth           = 100
	humanoid.Health              = 100
	humanoid.HipHeight           = 2
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoid.HealthDisplayType   = Enum.HumanoidHealthDisplayType.AlwaysOff
	humanoid.Parent              = model

	local animator = Instance.new("Animator")
	animator.Parent = humanoid

	model.PrimaryPart = hrp
	return model
end

-- Add a single anchored part as a hat/accessory above the rig's head.
function AssetBuilder.r6Hat(model: Model, size: Vector3, color: Color3, yOffset: number, hatName: string?, shape: Enum.PartType?): Part?
	local head = model:FindFirstChild("Head")
	if not head then return nil end
	local p = Instance.new("Part")
	p.Name          = hatName or "Hat"
	p.Size          = size
	p.Color         = color
	p.Material      = Enum.Material.SmoothPlastic
	p.TopSurface    = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Anchored      = true
	p.CanCollide    = false
	p.CFrame        = head.CFrame * CFrame.new(0, yOffset, 0)
	if shape then p.Shape = shape end
	p.Parent        = model
	-- Weld so the hat moves with the head if the rig is ever moved.
	local w = Instance.new("WeldConstraint")
	w.Part0 = head
	w.Part1 = p
	w.Parent = p
	return p
end

-- r6Hat and r6NameTag both work by looking up the rig's "Head" child, which
-- is named the same in R6 and R15 rigs — so they are rig-agnostic. Expose
-- r15Hat / r15NameTag aliases so R15 callers read symmetrically.
AssetBuilder.r15Hat     = AssetBuilder.r6Hat
AssetBuilder.r15NameTag = AssetBuilder.r6NameTag

return AssetBuilder
