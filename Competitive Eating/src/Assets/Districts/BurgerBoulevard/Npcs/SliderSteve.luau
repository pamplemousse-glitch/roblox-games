-- SliderSteve — R15 retrofit (polish A). Teal bowling shirt, brown pants, mustache, stocky.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "SliderSteve"
local SKIN       = Color3.fromRGB(225, 185, 145)
local SHIRT      = Color3.fromRGB(127, 202, 194)
local SHIRT_TRIM = Color3.fromRGB(255, 245, 232)
local PANTS      = Color3.fromRGB(80, 60, 50)
local HAIR       = Color3.fromRGB(160, 120, 80)
local BELT       = Color3.fromRGB(50, 35, 25)
local DARK       = Color3.fromRGB(20, 20, 20)

local function weldTo(parent: Model, base: BasePart, name: string, size: Vector3, color: Color3, offset: CFrame, shape: Enum.PartType?): Part
	local p = Instance.new("Part")
	p.Name = name; p.Size = size; p.Color = color
	p.Material = Enum.Material.SmoothPlastic
	p.Anchored = true; p.CanCollide = false
	p.CFrame = base.CFrame * offset
	if shape then p.Shape = shape end
	p.Parent = parent
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
		-- Belt
		weldTo(rig, hrp, "Belt",        Vector3.new(2.1, 0.3, 1.05), BELT, CFrame.new(0, -1.1, 0))
		-- Vertical white stripe (bowling shirt)
		weldTo(rig, hrp, "FrontStripe", Vector3.new(0.5, 2.2, 0.05), SHIRT_TRIM, CFrame.new(0, 0, 0.55))
		-- 3 buttons
		for i, y in {0.6, 0, -0.6} do
			weldTo(rig, hrp, "Button_" .. i, Vector3.new(0.13, 0.13, 0.13), Color3.fromRGB(40, 40, 50),
				CFrame.new(0, y, 0.58), Enum.PartType.Ball)
		end
		-- "Steve" name patch on chest
		weldTo(rig, hrp, "NamePatch",   Vector3.new(0.9, 0.5, 0.05), SHIRT_TRIM, CFrame.new(-0.7, 0.5, 0.56))
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Receding hairline (thin layer on top)
		weldTo(rig, head, "Hair",     Vector3.new(1.5, 0.4, 1.3), HAIR, CFrame.new(0, 0.55, -0.1))
		-- Signature mustache
		weldTo(rig, head, "Mustache", Vector3.new(1.0, 0.18, 0.15), HAIR, CFrame.new(0, -0.2, 0.55))
		-- Eyes
		weldTo(rig, head, "EyeL",     Vector3.new(0.13, 0.13, 0.13), DARK, CFrame.new(-0.32, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR",     Vector3.new(0.13, 0.13, 0.13), DARK, CFrame.new( 0.32, 0.1, 0.5), Enum.PartType.Ball)
	end
	AB.r15NameTag(rig, "Slider Steve")
	return rig
end
