-- PitMasterApron — R15 retrofit (polish A)
-- Cream apron with sauce stains, brown shirt, white chef hat, leather
-- gloves, red towel over the shoulder. Pitmaster signature preserved.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME   = "PitMasterApron"
local SKIN   = Color3.fromRGB(215, 165, 125)
local SHIRT  = Color3.fromRGB(85, 65, 50)
local PANTS  = Color3.fromRGB(55, 40, 30)
local BOOT   = Color3.fromRGB(45, 28, 18)
local APRON  = Color3.fromRGB(240, 235, 215)
local HAT    = Color3.fromRGB(240, 235, 215)
local SAUCE  = Color3.fromRGB(140, 35, 30)
local GLOVE  = Color3.fromRGB(28, 24, 22)
local TOWEL  = Color3.fromRGB(220, 60, 60)
local HAIR   = Color3.fromRGB(35, 25, 20)

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
	local rig = AB.r15Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = SKIN,
		shirt = SHIRT,
		pants = PANTS,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Cream apron over the front + straps
		weldTo(rig, hrp, "Apron",       Vector3.new(1.85, 2.2, 0.12), APRON, CFrame.new(0, -0.05, 0.6))
		weldTo(rig, hrp, "ApronStrapL", Vector3.new(0.3, 0.95, 0.05), APRON, CFrame.new(-0.5, 1.1, 0.6))
		weldTo(rig, hrp, "ApronStrapR", Vector3.new(0.3, 0.95, 0.05), APRON, CFrame.new( 0.5, 1.1, 0.6))
		-- Sauce stains
		weldTo(rig, hrp, "Sauce_1", Vector3.new(0.5, 0.5, 0.5), SAUCE, CFrame.new(-0.45, 0.0, 0.66), Enum.PartType.Ball)
		weldTo(rig, hrp, "Sauce_2", Vector3.new(0.5, 0.5, 0.5), SAUCE, CFrame.new( 0.4, -0.5, 0.66), Enum.PartType.Ball)
		weldTo(rig, hrp, "Sauce_3", Vector3.new(0.45, 0.45, 0.45), SAUCE, CFrame.new( 0.0,  0.5, 0.66), Enum.PartType.Ball)
		-- Red towel draped over the right shoulder
		weldTo(rig, hrp, "Towel", Vector3.new(0.5, 1.6, 1.2), TOWEL, CFrame.new(0.95, 1.0, 0) * CFrame.Angles(0, 0, math.rad(20)))
	end

	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "EyeL", Vector3.new(0.22, 0.22, 0.22), Color3.new(0, 0, 0), CFrame.new(-0.4, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR", Vector3.new(0.22, 0.22, 0.22), Color3.new(0, 0, 0), CFrame.new( 0.4, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Mouth", Vector3.new(1.2, 0.28, 0.25), Color3.new(0, 0, 0), CFrame.new(0, -0.3, 0.5))
	end

	-- Dark hair fringe + chef hat (band + puffy top)
	AB.r15Hat(rig, Vector3.new(2.15, 0.3, 2.15), HAIR, 0.55, "Hair")
	AB.r15Hat(rig, Vector3.new(2.3, 0.6, 2.3), HAT, 0.95, "HatBand", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.7, 1.6, 2.7), HAT, 2.1, "HatPoof", Enum.PartType.Ball)

	-- Boots welded to feet
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if lFoot then weldTo(rig, lFoot, "BootL", Vector3.new(1.3, 0.55, 1.6), BOOT, CFrame.new(0, -0.08, 0.1)) end
	if rFoot then weldTo(rig, rFoot, "BootR", Vector3.new(1.3, 0.55, 1.6), BOOT, CFrame.new(0, -0.08, 0.1)) end

	-- Leather gloves on the hands
	local lHand = rig:FindFirstChild("LeftHand") :: BasePart
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if lHand then weldTo(rig, lHand, "GloveL", Vector3.new(1.1, 0.6, 1.1), GLOVE, CFrame.new(0, -0.15, 0)) end
	if rHand then weldTo(rig, rHand, "GloveR", Vector3.new(1.1, 0.6, 1.1), GLOVE, CFrame.new(0, -0.15, 0)) end

	AB.r15NameTag(rig, "Pit Master")
	return rig
end
