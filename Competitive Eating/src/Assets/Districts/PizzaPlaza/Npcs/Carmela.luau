-- Carmela — R15 retrofit (polish A)
-- Mamma Carmela herself. Older Italian woman, floral red dress + white apron,
-- hair bun, wooden spoon in right hand, pot of sauce in left.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Carmela"
local SKIN    = Color3.fromRGB(240, 210, 175)
local DRESS   = Color3.fromRGB(150, 50, 50)
local APRON   = Color3.fromRGB(245, 240, 230)
local FLOWERS = Color3.fromRGB(240, 220, 80)
local HAIR    = Color3.fromRGB(160, 160, 165)
local POT_BLK = Color3.fromRGB(40, 40, 45)
local SAUCE_R = Color3.fromRGB(180, 40, 35)
local WD      = Color3.fromRGB(110, 75, 45)
local CHEEK_R = Color3.fromRGB(240, 160, 150)

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
		shirt = DRESS,
		pants = DRESS,  -- skirt also dress color
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- White apron + straps + pocket
		weldTo(rig, hrp, "Apron",       Vector3.new(1.85, 2.1, 0.12), APRON, CFrame.new(0, -0.1, 0.6))
		weldTo(rig, hrp, "ApronStrapL", Vector3.new(0.3, 1.0, 0.1), APRON, CFrame.new(-0.7, 1.15, 0.6))
		weldTo(rig, hrp, "ApronStrapR", Vector3.new(0.3, 1.0, 0.1), APRON, CFrame.new( 0.7, 1.15, 0.6))
		weldTo(rig, hrp, "ApronPocket", Vector3.new(0.55, 0.7, 0.1), Color3.fromRGB(220, 215, 200), CFrame.new(0.35, -0.4, 0.66))
		-- Yellow flower dots on dress (4 around apron edges)
		weldTo(rig, hrp, "Flower_1", Vector3.new(0.18, 0.18, 0.18), FLOWERS, CFrame.new(-0.85, 0.6, 0.55), Enum.PartType.Ball)
		weldTo(rig, hrp, "Flower_2", Vector3.new(0.18, 0.18, 0.18), FLOWERS, CFrame.new( 0.85, 0.7, 0.55), Enum.PartType.Ball)
		weldTo(rig, hrp, "Flower_3", Vector3.new(0.18, 0.18, 0.18), FLOWERS, CFrame.new(-0.85, -0.5, 0.55), Enum.PartType.Ball)
		weldTo(rig, hrp, "Flower_4", Vector3.new(0.18, 0.18, 0.18), FLOWERS, CFrame.new( 0.85, -0.4, 0.55), Enum.PartType.Ball)
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Rosy cheeks
		weldTo(rig, head, "CheekL", Vector3.new(0.3, 0.3, 0.3), CHEEK_R, CFrame.new(-0.55, -0.1, 0.45), Enum.PartType.Ball)
		weldTo(rig, head, "CheekR", Vector3.new(0.3, 0.3, 0.3), CHEEK_R, CFrame.new( 0.55, -0.1, 0.45), Enum.PartType.Ball)
		-- Closed smiling eyes + smile
		weldTo(rig, head, "EyeL",   Vector3.new(0.3, 0.05, 0.1), Color3.fromRGB(60, 40, 35), CFrame.new(-0.4, 0.2, 0.5))
		weldTo(rig, head, "EyeR",   Vector3.new(0.3, 0.05, 0.1), Color3.fromRGB(60, 40, 35), CFrame.new( 0.4, 0.2, 0.5))
		weldTo(rig, head, "Smile",  Vector3.new(0.6, 0.08, 0.1), Color3.fromRGB(140, 70, 70), CFrame.new(0, -0.4, 0.5))
	end
	-- Hair bun + grey side hair via r15Hat
	AB.r15Hat(rig, Vector3.new(1.9, 0.4, 1.5), HAIR,  0.45, "HairSides")
	AB.r15Hat(rig, Vector3.new(0.9, 0.9, 0.9), HAIR,  1.0, "Bun", Enum.PartType.Ball)

	-- Pot of sauce held in left hand (with steam) — R15 LeftHand local Y=-1.2
	local lHand = rig:FindFirstChild("LeftHand") :: BasePart
	if lHand then
		weldTo(rig, lHand, "Pot",        Vector3.new(1.6, 1.4, 1.6), POT_BLK, CFrame.new(0, -0.2, 0.8))
		weldTo(rig, lHand, "PotRim",     Vector3.new(1.7, 0.2, 1.7), Color3.fromRGB(60, 60, 65), CFrame.new(0, 0.5, 0.8))
		weldTo(rig, lHand, "Sauce",      Vector3.new(1.5, 0.25, 1.5), SAUCE_R, CFrame.new(0, 0.45, 0.8))
		weldTo(rig, lHand, "PotHandle",  Vector3.new(0.2, 0.6, 0.2), POT_BLK, CFrame.new(-1.0, -0.2, 0.8))
		local s1 = weldTo(rig, lHand, "Steam1", Vector3.new(0.65, 0.65, 0.65), Color3.fromRGB(240, 240, 240),
			CFrame.new(0, 1.3, 0.8), Enum.PartType.Ball); s1.Transparency = 0.55
		local s2 = weldTo(rig, lHand, "Steam2", Vector3.new(0.85, 0.85, 0.85), Color3.fromRGB(240, 240, 240),
			CFrame.new(0.15, 2.1, 0.85), Enum.PartType.Ball); s2.Transparency = 0.75
	end
	-- Wooden spoon in right hand
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "Spoon",     Vector3.new(0.2, 3, 0.2), WD,
			CFrame.new(0, 1.0, 0.8) * CFrame.Angles(math.rad(-30), 0, 0))
		weldTo(rig, rHand, "SpoonHead", Vector3.new(0.6, 0.4, 0.6), WD,
			CFrame.new(0, 2.3, 1.6) * CFrame.Angles(math.rad(-30), 0, 0))
		weldTo(rig, rHand, "SauceDrip", Vector3.new(0.25, 0.25, 0.25), SAUCE_R,
			CFrame.new(0, 2.4, 1.6) * CFrame.Angles(math.rad(-30), 0, 0), Enum.PartType.Ball)
	end

	AB.r15NameTag(rig, NAME)
	return rig
end
