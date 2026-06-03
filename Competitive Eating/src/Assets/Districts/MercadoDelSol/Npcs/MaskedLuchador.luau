-- MaskedLuchador — R15 retrofit (polish A): pink/teal luchador mask + singlet,
-- gold belt, teal cape, raised fist victory pose.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "MaskedLuchador"
local SKIN_MED   = Color3.fromRGB(210, 165, 130)
local AGAVE_TEAL = Color3.fromRGB(43, 140, 156)
local BOUG_PINK  = Color3.fromRGB(220, 80, 140)
local FIESTA_YEL = Color3.fromRGB(255, 184, 52)
local GOLD_DEEP  = Color3.fromRGB(230, 200, 80)
local BLACK      = Color3.fromRGB(30, 25, 25)
local WHITE      = Color3.fromRGB(245, 240, 235)

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
	-- Mask hides the face entirely — head/arms colored pink.
	local rig = AB.r15Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = SKIN_MED,
		shirt = AGAVE_TEAL,
		pants = AGAVE_TEAL,
		head  = BOUG_PINK,
	})

	-- Singlet detail: belt across waist, cape on back, lightning bolt on chest
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		weldTo(rig, hrp, "Belt",            Vector3.new(2.2, 0.5, 1.1), FIESTA_YEL, CFrame.new(0, -1.0, 0))
		weldTo(rig, hrp, "BeltBuckle",      Vector3.new(0.8, 0.5, 0.15), GOLD_DEEP, CFrame.new(0, -1.0, 0.6))
		weldTo(rig, hrp, "BeltBuckleInner", Vector3.new(0.6, 0.4, 0.1),  FIESTA_YEL, CFrame.new(0, -1.0, 0.68))
		-- Cape on back
		weldTo(rig, hrp, "Cape",     Vector3.new(2.6, 3.0, 0.15), AGAVE_TEAL, CFrame.new(0, 0.5, -0.7))
		weldTo(rig, hrp, "CapeTrim", Vector3.new(2.7, 0.3, 0.18), BOUG_PINK,  CFrame.new(0, -1.0, -0.7))
		weldTo(rig, hrp, "CapeClasp",Vector3.new(0.35, 0.35, 0.35), FIESTA_YEL, CFrame.new(0, 1.6, -0.6), Enum.PartType.Ball)
		-- Lightning bolt detail on chest
		weldTo(rig, hrp, "BoltSeg1", Vector3.new(0.4, 0.6, 0.12), FIESTA_YEL, CFrame.new(-0.3, 0.6, 0.55) * CFrame.Angles(0, 0, math.rad(20)))
		weldTo(rig, hrp, "BoltSeg2", Vector3.new(0.4, 0.6, 0.12), FIESTA_YEL, CFrame.new(0.05, 0.0, 0.55) * CFrame.Angles(0, 0, math.rad(-25)))
		weldTo(rig, hrp, "BoltSeg3", Vector3.new(0.4, 0.6, 0.12), FIESTA_YEL, CFrame.new(0.35, -0.6, 0.55) * CFrame.Angles(0, 0, math.rad(20)))
		-- Glowing belt gem
		local gem = weldTo(rig, hrp, "BeltGem", Vector3.new(0.35, 0.35, 0.35), BOUG_PINK,
			CFrame.new(0, -1.0, 0.72), Enum.PartType.Ball)
		gem.Material = Enum.Material.Neon
		local pl = Instance.new("PointLight")
		pl.Color = BOUG_PINK; pl.Brightness = 1.4; pl.Range = 6
		pl.Parent = gem
	end

	-- Mask: yellow stripes + white flame accent + dark eye holes + mouth hole + laces.
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "MaskStripeTop", Vector3.new(1.85, 0.3, 0.15),  FIESTA_YEL, CFrame.new(0, 0.45, 0.48))
		weldTo(rig, head, "MaskStripeBot", Vector3.new(1.85, 0.25, 0.15), FIESTA_YEL, CFrame.new(0, -0.55, 0.48))
		weldTo(rig, head, "MaskFlame",     Vector3.new(0.4, 0.7, 0.15),   WHITE,      CFrame.new(0, 0.6, 0.58))
		weldTo(rig, head, "EyeHole_L",     Vector3.new(0.4, 0.25, 0.1),   BLACK,      CFrame.new(-0.4, 0.1, 0.58))
		weldTo(rig, head, "EyeHole_R",     Vector3.new(0.4, 0.25, 0.1),   BLACK,      CFrame.new( 0.4, 0.1, 0.58))
		weldTo(rig, head, "MouthHole",     Vector3.new(0.6, 0.18, 0.1),   BLACK,      CFrame.new(0, -0.35, 0.58))
		for i = 1, 3 do
			weldTo(rig, head, "MaskLace_" .. i, Vector3.new(0.8, 0.1, 0.12), WHITE,
				CFrame.new(0, -0.5 + i * 0.4, -0.55))
		end
	end

	-- Wristband on raised arm and grounded arm
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	local lHand = rig:FindFirstChild("LeftHand")  :: BasePart
	if rHand then
		weldTo(rig, rHand, "WristbandR", Vector3.new(0.4, 1.15, 1.15), FIESTA_YEL,
			CFrame.new(0, 0.3, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
	end
	if lHand then
		weldTo(rig, lHand, "WristbandL", Vector3.new(0.4, 1.15, 1.15), FIESTA_YEL,
			CFrame.new(0, 0.3, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
	end

	AB.r15NameTag(rig, "El Rayo Loco")
	return rig
end
