-- Lulu — sprinkle-loving young pâtissière. R6 rig with pink skirt + gold trim + pigtails.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME  = "Lulu"
local CREAM = Color3.fromRGB(255, 240, 220)
local PINK  = Color3.fromRGB(255, 200, 214)
local DEEP  = Color3.fromRGB(232, 130, 165)
local GOLD  = Color3.fromRGB(212, 168, 82)
local HAIR  = Color3.fromRGB(212, 168, 82)

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

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = Color3.fromRGB(250, 220, 195),
		shirt = CREAM,
		pants = PINK,   -- pink skirt/pants
	})
	local torso = rig:FindFirstChild("Torso") :: BasePart
	if torso then
		weldTo(rig, torso, "Apron",   Vector3.new(1.8, 1.9, 0.1), PINK,  CFrame.new(0, 0, 0.6))
		weldTo(rig, torso, "Belt",    Vector3.new(2.05, 0.25, 1.05), GOLD, CFrame.new(0, -0.85, 0))
		weldTo(rig, torso, "BowL",    Vector3.new(0.35, 0.35, 0.3), DEEP, CFrame.new(-0.4, -0.85, 0.65), Enum.PartType.Ball)
		weldTo(rig, torso, "BowR",    Vector3.new(0.35, 0.35, 0.3), DEEP, CFrame.new( 0.4, -0.85, 0.65), Enum.PartType.Ball)
	end
	-- Hair top
	AB.r6Hat(rig, Vector3.new(2.1, 0.6, 1.1), HAIR, 0.55, "HairTop")
	-- Pigtails on each side
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "PigtailL", Vector3.new(0.6, 0.6, 0.6), HAIR, CFrame.new(-1.0, 0.0, 0),  Enum.PartType.Ball)
		weldTo(rig, head, "PigtailR", Vector3.new(0.6, 0.6, 0.6), HAIR, CFrame.new( 1.0, 0.0, 0),  Enum.PartType.Ball)
		weldTo(rig, head, "PigStrL",  Vector3.new(0.35, 1.0, 0.35), HAIR, CFrame.new(-1.05, -0.6, 0))
		weldTo(rig, head, "PigStrR",  Vector3.new(0.35, 1.0, 0.35), HAIR, CFrame.new( 1.05, -0.6, 0))
		weldTo(rig, head, "BowPigL",  Vector3.new(0.3, 0.25, 0.3),  DEEP, CFrame.new(-1.0, 0.35, 0), Enum.PartType.Ball)
		weldTo(rig, head, "BowPigR",  Vector3.new(0.3, 0.25, 0.3),  DEEP, CFrame.new( 1.0, 0.35, 0), Enum.PartType.Ball)
	end
	AB.r6NameTag(rig, NAME)
	return rig
end
