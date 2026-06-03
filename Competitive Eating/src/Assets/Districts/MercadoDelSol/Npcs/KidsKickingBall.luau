-- KidsKickingBall — R15 retrofit (polish A): two kid-scale R15 rigs (Pablo green
-- + Marco teal jerseys) under one Model with a soccer ball between them.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME        = "KidsKickingBall"
local SKIN        = Color3.fromRGB(210, 165, 130)
local PAPEL_GREEN = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL  = Color3.fromRGB(43, 140, 156)
local HAIR_BLACK  = Color3.fromRGB(40, 30, 25)
local BLACK       = Color3.fromRGB(30, 25, 25)
local WHITE       = Color3.fromRGB(245, 240, 235)
local DUST_TAN    = Color3.fromRGB(220, 195, 160)
local MOUTH_PINK  = Color3.fromRGB(160, 80, 70)

local function weldTo(parent: Model, base: BasePart, name: string, size: Vector3, color: Color3, offset: CFrame, shape: Enum.PartType?): Part
	local p = Instance.new("Part")
	p.Name = name; p.Size = size; p.Color = color
	p.Material = Enum.Material.SmoothPlastic
	p.Anchored = true; p.CanCollide = false
	p.CFrame   = base.CFrame * offset
	if shape then p.Shape = shape end
	p.Parent   = parent
	local w = Instance.new("WeldConstraint"); w.Part0 = base; w.Part1 = p; w.Parent = p
	return p
end

local function kidFace(rig: Model, mouthSize: Vector3, mouthColor: Color3)
	local head = rig:FindFirstChild("Head") :: BasePart
	if not head then return end
	weldTo(rig, head, "Eye_L", Vector3.new(0.15, 0.15, 0.15), BLACK, CFrame.new(-0.28, 0.1, 0.5), Enum.PartType.Ball)
	weldTo(rig, head, "Eye_R", Vector3.new(0.15, 0.15, 0.15), BLACK, CFrame.new( 0.28, 0.1, 0.5), Enum.PartType.Ball)
	weldTo(rig, head, "Mouth", mouthSize, mouthColor, CFrame.new(0, -0.35, 0.5))
end

local function shrinkKid(rig: Model, scale: number)
	local humanoid = rig:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	for _, prop in {"BodyDepthScale", "BodyHeightScale", "BodyWidthScale", "HeadScale"} do
		local v = humanoid:FindFirstChild(prop)
		if not v then
			v = Instance.new("NumberValue")
			v.Name = prop
			v.Parent = humanoid
		end
		v.Value = scale
	end
end

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- ── Pablo (green jersey, x = -2) — mid-kick posture ──────────────────
	local pabloCF = originCF * CFrame.new(-2, 0, 0)
	local pablo = AB.r15Rig(model, pabloCF * CFrame.new(0, -3, 0), "Pablo", {
		skin  = SKIN,
		shirt = PAPEL_GREEN,
		pants = BLACK,
	})
	shrinkKid(pablo, 0.75)
	kidFace(pablo, Vector3.new(0.3, 0.18, 0.12), BLACK)  -- mid-yell open mouth
	AB.r15Hat(pablo, Vector3.new(1.55, 1.55, 1.55), HAIR_BLACK, 0.2, "Hair", Enum.PartType.Ball)

	-- ── Marco (teal jersey, x = +2) — leaning back ───────────────────────
	local marcoCF = originCF * CFrame.new(2, 0, 0)
	local marco = AB.r15Rig(model, marcoCF * CFrame.new(0, -3, 0), "Marco", {
		skin  = SKIN,
		shirt = AGAVE_TEAL,
		pants = BLACK,
	})
	shrinkKid(marco, 0.75)
	kidFace(marco, Vector3.new(0.4, 0.12, 0.12), MOUTH_PINK)
	AB.r15Hat(marco, Vector3.new(1.55, 1.55, 1.55), HAIR_BLACK, 0.2, "Hair", Enum.PartType.Ball)

	-- ── Soccer ball at the center ────────────────────────────────────────
	-- Parented loose to the model (not welded to a rig) so it sits at the play spot.
	local ball = AB.sphere(0.8, WHITE, originCF * CFrame.new(0, -2.6, 0.5), model, "SoccerBall")
	-- Classic pentagon pattern (5+ black dots)
	local pentagonOffsets = {
		Vector3.new(0,    -2.6, 0.85),
		Vector3.new(0.35, -2.4, 0.55),
		Vector3.new(-0.35,-2.4, 0.55),
		Vector3.new(0.35, -2.8, 0.55),
		Vector3.new(-0.35,-2.8, 0.55),
		Vector3.new(0,    -2.3, 0.3),
	}
	for i, off in pentagonOffsets do
		local dot = AB.block(Vector3.new(0.2, 0.2, 0.05), BLACK,
			originCF * CFrame.new(off.X, off.Y, off.Z), model, "BallPentagon_" .. i)
		AB.weld(ball, dot)
	end

	-- Dust kick effect near Pablo's right foot
	for i = 1, 3 do
		AB.sphere(0.25 - i * 0.05, DUST_TAN,
			originCF * CFrame.new(-1.5 + i * 0.3, -2.4 + i * 0.15, 1.5 + i * 0.2),
			model, "Dust_" .. i)
	end

	-- Nametag above Pablo
	local pabloHead = pablo:FindFirstChild("Head") :: BasePart
	if pabloHead then AB.billboard(pabloHead, "Pablo & Marco", Vector2.new(220, 36), 3.0) end

	return model
end
