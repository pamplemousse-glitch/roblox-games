-- DeliveryBoyOnBike — R15 retrofit (polish A)
-- Paolo: kid on a red bicycle with a stack of pizza boxes in the front
-- basket. Bike is welded around the rider's HRP so the whole rig moves as one.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Paolo"
local SKIN    = Color3.fromRGB(240, 210, 175)
local SHIRT_R = Color3.fromRGB(200, 40, 40)
local SHIRT_W = Color3.fromRGB(245, 240, 230)
local PANTS   = Color3.fromRGB(40, 70, 100)
local HAIR    = Color3.fromRGB(60, 40, 35)
local CAP_R   = Color3.fromRGB(180, 30, 40)
local BIKE_R  = Color3.fromRGB(180, 30, 40)
local TIRE_BL = Color3.fromRGB(35, 30, 30)
local CHROME  = Color3.fromRGB(220, 220, 230)
local BASKET  = Color3.fromRGB(190, 140, 80)
local CARD    = Color3.fromRGB(170, 130, 80)
local DK_CARD = Color3.fromRGB(130, 100, 65)

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
		shirt = SHIRT_R,
		pants = PANTS,
	})

	-- BIKE: all parts welded to HRP so the bike rides with the character.
	-- Local Y on HRP ≈ 0 = rider waist; legs hang below to Y≈-2.
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- White stripe + "PIZZA" patch on chest
		weldTo(rig, hrp, "ChestStripe", Vector3.new(2.1, 0.4, 1.05), SHIRT_W, CFrame.new(0, 0.5, 0))
		weldTo(rig, hrp, "PizzaPatch",  Vector3.new(1.2, 0.55, 0.1), SHIRT_W, CFrame.new(0, -0.2, 0.55))

		-- Front + back wheels (under and ahead/behind rider)
		weldTo(rig, hrp, "FrontTire", Vector3.new(0.4, 2, 2), TIRE_BL,
			CFrame.new(0, -2.5, 2.5) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, hrp, "FrontRim",  Vector3.new(0.5, 1.6, 1.6), CHROME,
			CFrame.new(0, -2.5, 2.5) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, hrp, "BackTire",  Vector3.new(0.4, 2, 2), TIRE_BL,
			CFrame.new(0, -2.5, -2.5) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, hrp, "BackRim",   Vector3.new(0.5, 1.6, 1.6), CHROME,
			CFrame.new(0, -2.5, -2.5) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		-- Frame
		weldTo(rig, hrp, "TopTube",  Vector3.new(0.25, 0.25, 5), BIKE_R, CFrame.new(0, -1.5, 0))
		weldTo(rig, hrp, "DownTube", Vector3.new(0.25, 4, 0.25), BIKE_R,
			CFrame.new(0, -2, 1) * CFrame.Angles(math.rad(60), 0, 0))
		weldTo(rig, hrp, "SeatTube", Vector3.new(0.25, 2.5, 0.25), BIKE_R, CFrame.new(0, -1, -1.5))
		-- Pedal crank
		weldTo(rig, hrp, "CrankBox", Vector3.new(0.4, 0.4, 0.4), CHROME, CFrame.new(0, -2.5, 0), Enum.PartType.Ball)
		weldTo(rig, hrp, "PedalF",   Vector3.new(0.5, 0.5, 0.15), Color3.fromRGB(40, 40, 50), CFrame.new(0, -2.5, 0.9))
		weldTo(rig, hrp, "PedalB",   Vector3.new(0.5, 0.5, 0.15), Color3.fromRGB(40, 40, 50), CFrame.new(0, -2.5, -0.9))
		-- Handlebars + grips + bell
		weldTo(rig, hrp, "Handlebar", Vector3.new(2, 0.2, 0.2), CHROME, CFrame.new(0, 1, 2.4))
		weldTo(rig, hrp, "Stem",      Vector3.new(0.2, 1.0, 0.2), CHROME, CFrame.new(0, 0.5, 2.4))
		weldTo(rig, hrp, "GripL",     Vector3.new(0.25, 0.25, 0.25), Color3.fromRGB(35, 30, 30), CFrame.new(-1, 1, 2.4), Enum.PartType.Ball)
		weldTo(rig, hrp, "GripR",     Vector3.new(0.25, 0.25, 0.25), Color3.fromRGB(35, 30, 30), CFrame.new( 1, 1, 2.4), Enum.PartType.Ball)
		weldTo(rig, hrp, "Bell",      Vector3.new(0.35, 0.35, 0.35), CHROME, CFrame.new(0.8, 1.4, 2.4), Enum.PartType.Ball)
		-- Seat
		weldTo(rig, hrp, "Seat",      Vector3.new(0.5, 0.3, 1.0), Color3.fromRGB(40, 30, 25), CFrame.new(0, 0.5, -1.5))

		-- Front basket + pizza box stack
		weldTo(rig, hrp, "Basket",    Vector3.new(2, 1.4, 1.8), BASKET, CFrame.new(0, 1.5, 3.5))
		weldTo(rig, hrp, "BasketRim", Vector3.new(2.2, 0.2, 2.0), Color3.fromRGB(130, 90, 50), CFrame.new(0, 2.2, 3.5))
		for i = 1, 4 do
			local y = 2.5 + (i - 1) * 0.5
			weldTo(rig, hrp, "PizzaBox_" .. i,     Vector3.new(1.8, 0.45, 1.6), CARD,    CFrame.new(0, y, 3.5))
			weldTo(rig, hrp, "PizzaBoxEdge_" .. i, Vector3.new(1.85, 0.05, 1.65), DK_CARD, CFrame.new(0, y + 0.22, 3.5))
			weldTo(rig, hrp, "PizzaBoxLogo_" .. i, Vector3.new(0.9, 0.2, 0.05), SHIRT_R, CFrame.new(0, y, 4.3))
		end

		-- Motion lines / wind streaks behind
		for i = 1, 4 do
			local streak = weldTo(rig, hrp, "WindStreak_" .. i, Vector3.new(2, 0.06, 0.05),
				Color3.fromRGB(180, 220, 240), CFrame.new((i - 2.5) * 0.7, 1 + i * 0.4, -3.5))
			streak.Transparency = 0.4
		end
	end

	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Big excited eyes + grin
		weldTo(rig, head, "EyeWhiteL", Vector3.new(0.25, 0.25, 0.25), Color3.fromRGB(245, 240, 230), CFrame.new(-0.4, 0.1, 0.45), Enum.PartType.Ball)
		weldTo(rig, head, "EyeWhiteR", Vector3.new(0.25, 0.25, 0.25), Color3.fromRGB(245, 240, 230), CFrame.new( 0.4, 0.1, 0.45), Enum.PartType.Ball)
		weldTo(rig, head, "PupilL",    Vector3.new(0.13, 0.13, 0.13), Color3.fromRGB(30, 25, 20), CFrame.new(-0.4, 0.1, 0.55), Enum.PartType.Ball)
		weldTo(rig, head, "PupilR",    Vector3.new(0.13, 0.13, 0.13), Color3.fromRGB(30, 25, 20), CFrame.new( 0.4, 0.1, 0.55), Enum.PartType.Ball)
		weldTo(rig, head, "Grin",      Vector3.new(0.7, 0.15, 0.1), Color3.fromRGB(140, 70, 70), CFrame.new(0, -0.4, 0.5))
	end
	-- Tousled hair + red delivery cap (body + brim)
	AB.r15Hat(rig, Vector3.new(1.7, 0.6, 1.5), HAIR,  0.55, "Hair", Enum.PartType.Ball)
	AB.r15Hat(rig, Vector3.new(2.0, 0.5, 2.0), CAP_R, 0.9, "CapBody")
	AB.r15Hat(rig, Vector3.new(0.3, 0.15, 1.4), CAP_R, 0.65, "CapBrim")

	AB.r15NameTag(rig, NAME)
	return rig
end
