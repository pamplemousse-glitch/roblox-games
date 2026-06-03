-- RollerSkatingWaitress — R15 retrofit (polish A). Red uniform, white apron, tray of burgers.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "RollerSkatingWaitress"
local SKIN    = Color3.fromRGB(235, 200, 170)
local UNIFORM = Color3.fromRGB(255, 48, 48)
local APRON   = Color3.fromRGB(255, 245, 232)
local CHROME  = Color3.fromRGB(176, 176, 176)
local DARK    = Color3.fromRGB(30, 30, 35)
local HAIR_BL = Color3.fromRGB(220, 200, 130)
local WHITE   = Color3.fromRGB(245, 245, 240)

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
		shirt = UNIFORM,
		pants = SKIN,  -- bare legs / tights
	})
	-- Roller skates on each foot
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	for _, foot in {lFoot, rFoot} do
		if foot then
			weldTo(rig, foot, "Skate",    Vector3.new(0.8, 0.5, 1.3), WHITE, CFrame.new(0, -0.1, 0.1))
			weldTo(rig, foot, "SkateTrim", Vector3.new(0.85, 0.2, 1.35), UNIFORM, CFrame.new(0, 0.05, 0.1))
			-- 4 wheels per skate
			for w = 0, 3 do
				local wx = ((w % 2 == 0) and -0.25 or 0.25)
				local wz = 0.1 + ((w < 2) and -0.4 or 0.4)
				weldTo(rig, foot, "Wheel_" .. w, Vector3.new(0.25, 0.4, 0.4), DARK,
					CFrame.new(wx, -0.4, wz) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
			end
		end
	end
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Red flared skirt + white hem
		weldTo(rig, hrp, "Skirt", Vector3.new(2.2, 1.3, 1.5), UNIFORM, CFrame.new(0, -1.6, 0))
		weldTo(rig, hrp, "Hem",   Vector3.new(2.3, 0.2, 1.6), WHITE, CFrame.new(0, -2.2, 0))
		-- White apron + strap
		weldTo(rig, hrp, "Apron",     Vector3.new(1.5, 1.8, 0.05), APRON, CFrame.new(0, 0, 0.55))
		weldTo(rig, hrp, "AprStrap",  Vector3.new(0.3, 0.8, 0.1), WHITE, CFrame.new(0, 1.1, 0.55))
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- 50s blonde flip
		weldTo(rig, head, "Hair",      Vector3.new(1.45, 1.45, 1.45), HAIR_BL, CFrame.new(0, 0.3, -0.1), Enum.PartType.Ball)
		weldTo(rig, head, "HairBangs", Vector3.new(1.4, 0.5, 0.3), HAIR_BL, CFrame.new(0, 0.6, 0.5))
		weldTo(rig, head, "HairCurlL", Vector3.new(0.6, 0.6, 0.6), HAIR_BL, CFrame.new(-1.3, -0.3, -0.2), Enum.PartType.Ball)
		weldTo(rig, head, "HairCurlR", Vector3.new(0.6, 0.6, 0.6), HAIR_BL, CFrame.new( 1.3, -0.3, -0.2), Enum.PartType.Ball)
		-- Eyes + lips
		weldTo(rig, head, "EyeL", Vector3.new(0.15, 0.15, 0.15), DARK, CFrame.new(-0.3, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR", Vector3.new(0.15, 0.15, 0.15), DARK, CFrame.new( 0.3, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Lips", Vector3.new(0.4, 0.1, 0.05), UNIFORM, CFrame.new(0, -0.35, 0.55))
	end
	-- Pillbox red hat
	AB.r15Hat(rig, Vector3.new(0.9, 0.3, 0.9), UNIFORM, 1.3, "Cap", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(0.7, 0.3, 0.7), UNIFORM, 1.6, "CapTop", Enum.PartType.Cylinder)
	-- Tray of burgers + shake in right hand (raised)
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "Tray", Vector3.new(2.5, 0.2, 2.5), CHROME, CFrame.new(0, 0.3, 0), Enum.PartType.Cylinder)
		weldTo(rig, rHand, "TrayBurger1", Vector3.new(0.5, 0.7, 0.7), AB.colors.bunTan, CFrame.new(-0.4, 0.7, 0), Enum.PartType.Cylinder)
		weldTo(rig, rHand, "TrayBurger2", Vector3.new(0.5, 0.7, 0.7), AB.colors.bunTan, CFrame.new( 0.4, 0.7, 0), Enum.PartType.Cylinder)
		weldTo(rig, rHand, "TrayShake", Vector3.new(1.2, 0.5, 0.5), WHITE, CFrame.new(0, 1.0, 0.2), Enum.PartType.Cylinder)
		weldTo(rig, rHand, "TrayCherry", Vector3.new(0.4, 0.4, 0.4), UNIFORM, CFrame.new(0, 1.7, 0.2), Enum.PartType.Ball)
	end
	AB.r15NameTag(rig, "RollerSkatingWaitress")
	return rig
end
