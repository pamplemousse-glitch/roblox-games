-- Marie — French pâtissière. R6 rig with pink-trimmed cream uniform + chef hat.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME  = "Marie"
local CREAM = Color3.fromRGB(255, 240, 220)
local PINK  = Color3.fromRGB(255, 200, 214)
local DEEP  = Color3.fromRGB(232, 130, 165)
local HAIR  = Color3.fromRGB(80, 45, 30)

local function weldTo(parent: Model, base: BasePart, name: string, size: Vector3, color: Color3, offset: CFrame): Part
	local p = Instance.new("Part")
	p.Name        = name
	p.Size        = size
	p.Color       = color
	p.Material    = Enum.Material.SmoothPlastic
	p.Anchored    = true
	p.CanCollide  = false
	p.CFrame      = base.CFrame * offset
	p.Parent      = parent
	local w = Instance.new("WeldConstraint"); w.Part0 = base; w.Part1 = p; w.Parent = p
	return p
end

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = Color3.fromRGB(245, 215, 185),
		shirt = CREAM,
		pants = Color3.fromRGB(60, 55, 70),
	})
	local torso = rig:FindFirstChild("Torso") :: BasePart
	if torso then
		weldTo(rig, torso, "Apron",     Vector3.new(1.8, 1.9, 0.1), PINK, CFrame.new(0, 0, 0.6))
		weldTo(rig, torso, "ApronTie",  Vector3.new(2.05, 0.25, 1.05), PINK, CFrame.new(0, -0.7, 0))
		weldTo(rig, torso, "Bow",       Vector3.new(0.9, 0.3, 0.25), DEEP, CFrame.new(0, -0.7, 0.65))
	end
	AB.r6Hat(rig, Vector3.new(2.1, 0.6, 1.1), HAIR,  0.55, "Hair")
	AB.r6Hat(rig, Vector3.new(1.4, 0.3, 1.4), CREAM, 1.05, "ChefBand")
	AB.r6Hat(rig, Vector3.new(1.8, 1.4, 1.8), CREAM, 1.95, "ChefPuff", Enum.PartType.Ball)
	AB.r6NameTag(rig, NAME)
	return rig
end
