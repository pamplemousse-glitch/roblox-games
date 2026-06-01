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

return AssetBuilder
