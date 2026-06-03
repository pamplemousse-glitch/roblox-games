-- VarsityLetterman — R15 retrofit (polish A). Letterman jacket, "S" patch, football.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "VarsityLetterman"
local SKIN    = Color3.fromRGB(240, 210, 175)
local JACKET  = Color3.fromRGB(40, 70, 130)
local SLEEVE  = Color3.fromRGB(245, 245, 240)
local PANTS   = Color3.fromRGB(70, 70, 80)
local HAIR_BR = Color3.fromRGB(80, 50, 30)
local DARK    = Color3.fromRGB(30, 30, 35)
local GOLD    = Color3.fromRGB(220, 180, 60)
local FOOTBL  = Color3.fromRGB(140, 80, 40)

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
	-- Letterman has navy jacket (torso) + cream sleeves (arms). Use leftArm/rightArm tint.
	local rig = AB.r15Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin     = SKIN,
		shirt    = JACKET,
		pants    = PANTS,
		leftArm  = SLEEVE,
		rightArm = SLEEVE,
	})
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Varsity "S" patch
		local patch = weldTo(rig, hrp, "Patch", Vector3.new(1.0, 1.2, 0.1), SLEEVE, CFrame.new(-0.3, 0, 0.55))
		AB.billboard(patch, "S", Vector2.new(60, 80), 0)
		-- Gold button strip
		weldTo(rig, hrp, "ButtonStrip", Vector3.new(0.1, 2.2, 0.08), GOLD, CFrame.new(0.4, 0, 0.57))
		for i, y in {-0.6, 0, 0.6} do
			weldTo(rig, hrp, "Button_" .. i, Vector3.new(0.12, 0.12, 0.12), GOLD, CFrame.new(0.4, y, 0.65), Enum.PartType.Ball)
		end
		-- Cream collar + gold trim
		weldTo(rig, hrp, "Collar",     Vector3.new(2.1, 0.3, 1.05), SLEEVE, CFrame.new(0, 1.2, 0))
		weldTo(rig, hrp, "CollarTrim", Vector3.new(2.15, 0.1, 1.1), GOLD,  CFrame.new(0, 1.35, 0))
		-- Cream waistband + gold trim
		weldTo(rig, hrp, "Waistband",  Vector3.new(2.15, 0.3, 1.05), SLEEVE, CFrame.new(0, -1.2, 0))
		weldTo(rig, hrp, "WaistTrim",  Vector3.new(2.2, 0.1, 1.1), GOLD,  CFrame.new(0, -1.35, 0))
	end
	-- Gold sleeve cuffs on each LowerArm
	local rLowerArm = rig:FindFirstChild("RightLowerArm") :: BasePart
	local lLowerArm = rig:FindFirstChild("LeftLowerArm") :: BasePart
	if rLowerArm then weldTo(rig, rLowerArm, "CuffR", Vector3.new(1.05, 0.2, 1.05), GOLD, CFrame.new(0, -0.6, 0)) end
	if lLowerArm then weldTo(rig, lLowerArm, "CuffL", Vector3.new(1.05, 0.2, 1.05), GOLD, CFrame.new(0, -0.6, 0)) end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Slicked side-part hair
		weldTo(rig, head, "Hair",      Vector3.new(1.45, 1.45, 1.45), HAIR_BR, CFrame.new(0, 0.4, -0.1), Enum.PartType.Ball)
		weldTo(rig, head, "HairFront", Vector3.new(1.3, 0.4, 0.3), HAIR_BR, CFrame.new(0, 0.8, 0.5))
		weldTo(rig, head, "Part",      Vector3.new(0.05, 0.2, 1.4), Color3.fromRGB(50, 30, 20), CFrame.new(-0.5, 1.0, 0))
		-- Eyes + smile + teeth
		weldTo(rig, head, "EyeL",  Vector3.new(0.13, 0.13, 0.13), DARK, CFrame.new(-0.3, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR",  Vector3.new(0.13, 0.13, 0.13), DARK, CFrame.new( 0.3, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Smile", Vector3.new(0.7, 0.1, 0.1), DARK, CFrame.new(0, -0.4, 0.55))
		weldTo(rig, head, "Tooth1", Vector3.new(0.07, 0.07, 0.07), SLEEVE, CFrame.new(-0.15, -0.35, 0.55), Enum.PartType.Ball)
		weldTo(rig, head, "Tooth2", Vector3.new(0.07, 0.07, 0.07), SLEEVE, CFrame.new( 0.15, -0.35, 0.55), Enum.PartType.Ball)
	end
	-- Football in right hand
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "Football", Vector3.new(0.7, 0.7, 0.7), FOOTBL, CFrame.new(0, -0.3, 0.6), Enum.PartType.Ball)
		for i, y in {-0.1, 0, 0.1} do
			weldTo(rig, rHand, "FootballLace" .. i, Vector3.new(0.4, 0.1, 0.1), SLEEVE, CFrame.new(0, -0.3 + y, 0.85))
		end
	end
	AB.r15NameTag(rig, "VarsityLetterman")
	return rig
end
