-- ChurroVendor — R15 retrofit (polish A): cream shirt + jeans + yellow paper hat,
-- holds a paper bag of churros. Frying cart with neon hot-oil glow rides beside.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME        = "ChurroVendor"
local SKIN        = Color3.fromRGB(210, 165, 130)
local CREAM       = Color3.fromRGB(245, 230, 200)
local JEANS_BLUE  = Color3.fromRGB(50, 80, 140)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local BLACK       = Color3.fromRGB(30, 25, 25)
local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local WOOD_LIGHT  = Color3.fromRGB(150, 110, 70)
local AGAVE_TEAL  = Color3.fromRGB(43, 140, 156)
local ORANGE_GLOW = Color3.fromRGB(255, 140, 50)
local BROWN_SUGAR = Color3.fromRGB(140, 90, 50)
local WHITE       = Color3.fromRGB(245, 240, 235)
local MOUTH_PINK  = Color3.fromRGB(160, 80, 70)

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
		shirt = CREAM,
		pants = JEANS_BLUE,
	})

	-- Cream apron with shoulder straps
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		weldTo(rig, hrp, "Apron",       Vector3.new(1.9, 1.95, 0.1),  CREAM, CFrame.new(0, 0, 0.6))
		weldTo(rig, hrp, "ApronStrap_L",Vector3.new(0.2, 0.5, 0.1),   CREAM, CFrame.new(-0.6, 1.2, 0.6))
		weldTo(rig, hrp, "ApronStrap_R",Vector3.new(0.2, 0.5, 0.1),   CREAM, CFrame.new( 0.6, 1.2, 0.6))
	end

	-- Face: eyes + black mustache + smile
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "Eye_L",    Vector3.new(0.18, 0.18, 0.18), BLACK,      CFrame.new(-0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Eye_R",    Vector3.new(0.18, 0.18, 0.18), BLACK,      CFrame.new( 0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Mustache", Vector3.new(1.0, 0.22, 0.2),   BLACK,      CFrame.new(0, -0.35, 0.45))
		weldTo(rig, head, "Mouth",    Vector3.new(0.6, 0.1, 0.12),   MOUTH_PINK, CFrame.new(0, -0.55, 0.45))
		-- Yellow paper hat: crown cylinder + flat brim disc
		weldTo(rig, head, "PaperHatCrown", Vector3.new(0.7, 1.9, 1.9), FIESTA_YEL,
			CFrame.new(0, 1.6, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, head, "PaperHatBrim",  Vector3.new(0.12, 2.4, 2.4), FIESTA_YEL,
			CFrame.new(0, 0.75, 0)  * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
	end

	-- Paper bag of churros held in right hand. Right hand local Y=-1.2, +1.2 shift.
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "PaperBag", Vector3.new(0.9, 1.0, 0.7), CREAM, CFrame.new(0, 0.4, 0))
		-- Four churro sticks poking out, with brown sugar tips
		for i = 1, 4 do
			local xOff = (i - 2.5) * 0.18
			weldTo(rig, rHand, "Churro_" .. i, Vector3.new(1.2, 0.18, 0.18), FIESTA_YEL,
				CFrame.new(xOff, 1.4, 0)  * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
			weldTo(rig, rHand, "ChurroSugar_" .. i, Vector3.new(0.1, 0.1, 0.1), BROWN_SUGAR,
				CFrame.new(xOff, 1.6, 0), Enum.PartType.Ball)
		end
	end

	-- CHURRO CART beside vendor at +3.5x. Welded to HRP so it rides with the rig.
	if hrp then
		weldTo(rig, hrp, "CartBody", Vector3.new(3, 2.4, 2.2), WOOD_DARK,
			CFrame.new(3.5, -0.8, 0))
		weldTo(rig, hrp, "CartTop",  Vector3.new(3.1, 0.15, 2.3), WOOD_LIGHT,
			CFrame.new(3.5, 0.5, 0))
		weldTo(rig, hrp, "FryerPot", Vector3.new(0.8, 1.6, 1.6), AGAVE_TEAL,
			CFrame.new(3.5, 1.0, 0)  * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		local oil = weldTo(rig, hrp, "FryerOil", Vector3.new(0.3, 1.3, 1.3), ORANGE_GLOW,
			CFrame.new(3.5, 1.25, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		oil.Material = Enum.Material.Neon
		local pl = Instance.new("PointLight")
		pl.Color = ORANGE_GLOW; pl.Brightness = 2; pl.Range = 8
		pl.Parent = oil
		weldTo(rig, hrp, "CartWheel_L", Vector3.new(0.3, 1.0, 1.0), BLACK,
			CFrame.new(3.5, -1.9, -0.95) * CFrame.Angles(0, math.rad(90), math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, hrp, "CartWheel_R", Vector3.new(0.3, 1.0, 1.0), BLACK,
			CFrame.new(3.5, -1.9,  0.95) * CFrame.Angles(0, math.rad(90), math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, hrp, "CanopyPole_L", Vector3.new(0.15, 2.4, 0.15), WOOD_DARK,
			CFrame.new(2.2, 1.8, 0))
		weldTo(rig, hrp, "CanopyPole_R", Vector3.new(0.15, 2.4, 0.15), WOOD_DARK,
			CFrame.new(4.8, 1.8, 0))
		-- Striped yellow + white awning
		for i = 1, 5 do
			local stripeColor = (i % 2 == 0) and FIESTA_YEL or WHITE
			weldTo(rig, hrp, "AwningStripe_" .. i, Vector3.new(3.4, 0.15, 0.45), stripeColor,
				CFrame.new(3.5, 2.9, -0.9 + (i - 1) * 0.45))
		end
		-- "CHURROS" neon yellow letter blocks on cart front signage
		for i = 1, 4 do
			local letter = weldTo(rig, hrp, "SignLetter_" .. i, Vector3.new(0.4, 0.5, 0.1), FIESTA_YEL,
				CFrame.new(3.5 + (i - 2.5) * 0.55, -0.5, 1.15))
			letter.Material = Enum.Material.Neon
		end
	end

	AB.r15NameTag(rig, "Don Churros")
	return rig
end
