-- PastryChef — R15 rig in cream uniform with pink kerchief + tall chef hat + gold buttons.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME  = "PastryChef"
local CREAM = Color3.fromRGB(255, 240, 220)
local PINK  = Color3.fromRGB(232, 130, 165)
local GOLD  = Color3.fromRGB(212, 168, 82)
local HAIR  = Color3.fromRGB(50, 30, 25)

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
		skin  = Color3.fromRGB(225, 195, 165),
		shirt = CREAM,
		pants = Color3.fromRGB(80, 70, 80),
	})
	-- Torso accessories ride on HumanoidRootPart so existing R6 Torso offsets work.
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Pink kerchief at neckline
		weldTo(rig, hrp, "Kerchief", Vector3.new(2.05, 0.35, 1.05), PINK, CFrame.new(0, 0.75, 0))
		-- Gold double-breasted buttons
		for i = 1, 3 do
			local y = 0.4 - (i - 1) * 0.5
			weldTo(rig, hrp, "BtnL_" .. i, Vector3.new(0.2, 0.2, 0.2), GOLD, CFrame.new(-0.32, y, 0.55), Enum.PartType.Ball)
			weldTo(rig, hrp, "BtnR_" .. i, Vector3.new(0.2, 0.2, 0.2), GOLD, CFrame.new( 0.32, y, 0.55), Enum.PartType.Ball)
		end
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "Mustache", Vector3.new(0.7, 0.15, 0.3), HAIR, CFrame.new(0, -0.18, 0.45))
	end
	AB.r15Hat(rig, Vector3.new(2.1, 0.4, 1.1), HAIR,  0.55, "Hair")
	-- Tall puffy chef hat
	AB.r15Hat(rig, Vector3.new(1.7, 0.35, 1.7), CREAM, 1.0, "HatBand")
	AB.r15Hat(rig, Vector3.new(1.6, 1.8, 1.6), CREAM, 2.05, "HatShaft", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.2, 1.7, 2.2), CREAM, 3.05, "HatPuff", Enum.PartType.Ball)
	AB.r15NameTag(rig, NAME)
	return rig
end
