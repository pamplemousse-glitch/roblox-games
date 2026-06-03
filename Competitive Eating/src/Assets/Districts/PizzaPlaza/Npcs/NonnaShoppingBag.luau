-- NonnaShoppingBag — R15 retrofit (polish A)
-- Nonna Rosa: old Italian grandma in red headscarf + dark purple dress,
-- string bag of groceries (bread, tomatoes, wine), wooden cane.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Nonna Rosa"
local SKIN    = Color3.fromRGB(230, 195, 165)
local DRESS   = Color3.fromRGB(70, 40, 80)
local SCARF   = Color3.fromRGB(200, 40, 40)
local HAIR    = Color3.fromRGB(180, 180, 185)
local BAG     = Color3.fromRGB(190, 165, 110)
local TOMATO  = Color3.fromRGB(220, 60, 50)
local BREAD   = Color3.fromRGB(220, 190, 130)
local BOTTLE  = Color3.fromRGB(40, 70, 45)

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
		pants = DRESS,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Shawl over dress + gold cross necklace
		weldTo(rig, hrp, "Shawl",  Vector3.new(1.95, 1.35, 0.13), Color3.fromRGB(40, 30, 40), CFrame.new(0, -0.35, 0.6))
		weldTo(rig, hrp, "CrossV", Vector3.new(0.12, 0.6, 0.12), Color3.fromRGB(220, 180, 60), CFrame.new(0, 0.6, 0.62))
		weldTo(rig, hrp, "CrossH", Vector3.new(0.35, 0.12, 0.12), Color3.fromRGB(220, 180, 60), CFrame.new(0, 0.6, 0.62))
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Narrow wrinkled eyes + pursed lips + crow's-feet wrinkles
		weldTo(rig, head, "EyeL",     Vector3.new(0.3, 0.06, 0.1), Color3.fromRGB(60, 40, 35), CFrame.new(-0.4, 0.1, 0.5))
		weldTo(rig, head, "EyeR",     Vector3.new(0.3, 0.06, 0.1), Color3.fromRGB(60, 40, 35), CFrame.new( 0.4, 0.1, 0.5))
		weldTo(rig, head, "WrinkleL", Vector3.new(0.15, 0.04, 0.06), Color3.fromRGB(190, 160, 130), CFrame.new(-0.75, 0, 0.5))
		weldTo(rig, head, "WrinkleR", Vector3.new(0.15, 0.04, 0.06), Color3.fromRGB(190, 160, 130), CFrame.new( 0.75, 0, 0.5))
		weldTo(rig, head, "Lips",     Vector3.new(0.4, 0.1, 0.1), Color3.fromRGB(160, 80, 80), CFrame.new(0, -0.4, 0.5))
		-- Grey hair wisps peeking out
		weldTo(rig, head, "HairWispL", Vector3.new(0.2, 0.2, 0.2), HAIR, CFrame.new(-0.65, -0.2, 0.35), Enum.PartType.Ball)
		weldTo(rig, head, "HairWispR", Vector3.new(0.2, 0.2, 0.2), HAIR, CFrame.new( 0.65, -0.2, 0.35), Enum.PartType.Ball)
	end
	-- Red headscarf (round top + knot at back)
	AB.r15Hat(rig, Vector3.new(1.5, 1.2, 1.5), SCARF, 0.55, "ScarfTop", Enum.PartType.Ball)
	AB.r15Hat(rig, Vector3.new(0.5, 0.5, 0.5), SCARF, 0.25, "ScarfKnot", Enum.PartType.Ball)

	-- Shopping bag full of groceries in right hand
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "BagHandle", Vector3.new(0.1, 1.0, 0.1), BAG, CFrame.new(0, -0.4, 0))
		weldTo(rig, rHand, "BagBody",   Vector3.new(1.3, 1.3, 1.3), BAG, CFrame.new(0, -1.6, 0), Enum.PartType.Ball)
		-- Bread loaf poking out
		weldTo(rig, rHand, "Bread",      Vector3.new(0.45, 2.2, 0.45), BREAD,
			CFrame.new(0, -0.4, 0) * CFrame.Angles(math.rad(20), 0, math.rad(10)))
		weldTo(rig, rHand, "BreadScore", Vector3.new(0.05, 0.6, 0.05), Color3.fromRGB(180, 130, 70),
			CFrame.new(0.1, -0.2, 0) * CFrame.Angles(math.rad(20), 0, math.rad(10)))
		-- Tomatoes (visible at top of bag)
		for i, off in {Vector3.new(0.4, 0, 0.3), Vector3.new(-0.3, 0.1, -0.3), Vector3.new(0.3, 0.2, -0.35)} do
			weldTo(rig, rHand, "BagTomato_" .. i, Vector3.new(0.3, 0.3, 0.3), TOMATO,
				CFrame.new(off.X, -1.2 + off.Y, off.Z), Enum.PartType.Ball)
			weldTo(rig, rHand, "BagTomStem_" .. i, Vector3.new(0.08, 0.08, 0.08), Color3.fromRGB(80, 140, 60),
				CFrame.new(off.X, -1.0 + off.Y, off.Z), Enum.PartType.Ball)
		end
		-- Wine bottle neck + cork
		weldTo(rig, rHand, "WineNeck", Vector3.new(0.25, 1.0, 0.25), BOTTLE, CFrame.new(-0.2, -0.7, -0.4))
		weldTo(rig, rHand, "WineCork", Vector3.new(0.2, 0.2, 0.2), Color3.fromRGB(195, 165, 120), CFrame.new(-0.2, -0.2, -0.4), Enum.PartType.Ball)
	end
	-- Cane in left hand
	local lHand = rig:FindFirstChild("LeftHand") :: BasePart
	if lHand then
		weldTo(rig, lHand, "Cane",       Vector3.new(0.15, 3.6, 0.15), Color3.fromRGB(80, 50, 30), CFrame.new(0, -1.5, 0))
		weldTo(rig, lHand, "CaneHandle", Vector3.new(0.3, 0.3, 0.3), Color3.fromRGB(80, 50, 30), CFrame.new(-0.2, 0.4, 0.2), Enum.PartType.Ball)
	end

	AB.r15NameTag(rig, NAME)
	return rig
end
