-- DonutDeliveryKid — R6 rig in cream uniform + mint cap + pink donut-box stack.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME  = "DonutDeliveryKid"
local CREAM = Color3.fromRGB(255, 240, 220)
local PINK  = Color3.fromRGB(255, 200, 214)
local DEEP  = Color3.fromRGB(232, 130, 165)
local MINT  = Color3.fromRGB(180, 230, 200)
local GOLD  = Color3.fromRGB(212, 168, 82)
local HAIR  = Color3.fromRGB(140, 80, 40)

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
		skin  = Color3.fromRGB(232, 195, 168),
		shirt = CREAM,
		pants = Color3.fromRGB(92, 57, 36),
	})
	local torso = rig:FindFirstChild("Torso") :: BasePart
	if torso then
		-- Pink belt
		weldTo(rig, torso, "Belt", Vector3.new(2.05, 0.3, 1.05), DEEP, CFrame.new(0, -0.85, 0))
		-- Stack of 3 pink donut boxes in front of torso
		for i = 1, 3 do
			local y = -0.6 + (i - 1) * 0.45
			weldTo(rig, torso, "Box_" .. i,    Vector3.new(2.0, 0.4, 1.4), PINK, CFrame.new(0, y, 1.2))
			weldTo(rig, torso, "Ribbon_" .. i, Vector3.new(2.05, 0.08, 0.3), DEEP, CFrame.new(0, y + 0.2, 1.2))
			weldTo(rig, torso, "Logo_" .. i,   Vector3.new(0.18, 0.18, 0.18), GOLD, CFrame.new(0.5, y + 0.22, 1.2), Enum.PartType.Ball)
		end
		-- Peek donut on top box
		weldTo(rig, torso, "PeekDonut", Vector3.new(0.5, 0.25, 0.5), PINK, CFrame.new(0, 0.4, 1.2), Enum.PartType.Cylinder)
	end
	-- Hair tuft
	AB.r6Hat(rig, Vector3.new(2.1, 0.35, 1.1), HAIR, 0.5, "Hair")
	-- Mint baseball-style cap (crown + peak + logo)
	AB.r6Hat(rig, Vector3.new(1.7, 0.6, 1.7), MINT, 1.0, "CapCrown")
	-- Peak (front brim)
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "CapPeak", Vector3.new(1.7, 0.15, 0.9), MINT, CFrame.new(0, 0.85, 0.7))
		weldTo(rig, head, "CapLogo", Vector3.new(0.45, 0.45, 0.1), PINK, CFrame.new(0, 1.05, 0.55), Enum.PartType.Cylinder)
	end
	AB.r6NameTag(rig, NAME)
	return rig
end
