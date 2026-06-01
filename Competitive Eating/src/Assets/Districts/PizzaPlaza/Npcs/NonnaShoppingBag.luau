-- Nonna with Shopping Bag — old Italian grandma in a head scarf, carrying
-- a string bag full of groceries (bread, tomatoes, wine).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Nonna Rosa"
local SKIN    = Color3.fromRGB(230, 195, 165)
local DRESS   = Color3.fromRGB(70, 40, 80)
local SCARF   = Color3.fromRGB(200, 40, 40)
local HAIR    = Color3.fromRGB(180, 180, 185)
local SHOE    = Color3.fromRGB(40, 35, 30)
local BAG     = Color3.fromRGB(190, 165, 110)
local TOMATO  = Color3.fromRGB(220, 60, 50)
local BREAD   = Color3.fromRGB(220, 190, 130)
local BOTTLE  = Color3.fromRGB(40, 70, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (dark dress)
	local torso = AB.part({size=Vector3.new(2.5, 3, 1.3), color=DRESS,
		cf=originCF, canCollide=false, name="Torso"}, model)
	-- Apron / shawl over dress (smaller patch)
	AB.part({size=Vector3.new(2, 1.5, 0.15), color=Color3.fromRGB(40, 30, 40),
		cf=AB.offset(originCF, 0, -0.5, 0.7), canCollide=false, name="Shawl"}, model)
	-- Cross necklace (gold)
	AB.cylinder(0.15, 0.7, Color3.fromRGB(220, 180, 60),
		AB.offset(originCF, 0, 1, 0.7) * CFrame.Angles(math.rad(90), 0, 0), model, "CrossV")
	AB.cylinder(0.15, 0.4, Color3.fromRGB(220, 180, 60),
		AB.offset(originCF, 0, 1, 0.7) * CFrame.Angles(0, 0, math.rad(90)), model, "CrossH")
	-- Skirt flare
	AB.part({size=Vector3.new(2.8, 0.6, 1.5), color=DRESS,
		cf=AB.offset(originCF, 0, -1.7, 0), canCollide=false, name="Skirt"}, model)
	-- Lower legs (stocking-y)
	AB.cylinder(0.45, 1.5, Color3.fromRGB(60, 45, 40), AB.offset(originCF, -0.5, -2.7, 0), model, "LegL")
	AB.cylinder(0.45, 1.5, Color3.fromRGB(60, 45, 40), AB.offset(originCF, 0.5, -2.7, 0), model, "LegR")
	-- Black low-heel shoes
	AB.part({size=Vector3.new(0.7, 0.4, 1), color=SHOE,
		cf=AB.offset(originCF, -0.5, -3.6, 0.2), canCollide=false, name="ShoeL"}, model)
	AB.part({size=Vector3.new(0.7, 0.4, 1), color=SHOE,
		cf=AB.offset(originCF, 0.5, -3.6, 0.2), canCollide=false, name="ShoeR"}, model)

	-- Head
	local head = AB.part({size=Vector3.new(1.7, 1.7, 1.7), color=SKIN,
		cf=AB.offset(originCF, 0, 2.4, 0), shape=Enum.PartType.Ball, canCollide=false, name="Head"}, model)
	-- Headscarf (red, covers hair)
	AB.sphere(1.4, SCARF, AB.offset(originCF, 0, 2.7, 0), model, "ScarfTop")
	-- Scarf knot at back
	AB.sphere(0.5, SCARF, AB.offset(originCF, 0, 2.4, -0.8), model, "ScarfKnot")
	-- Wisps of grey hair peeking out
	AB.sphere(0.2, HAIR, AB.offset(originCF, -0.7, 2.1, 0.4), model, "HairWispL")
	AB.sphere(0.2, HAIR, AB.offset(originCF, 0.7, 2.1, 0.4), model, "HairWispR")
	-- Eyes (small, narrow with wrinkles)
	AB.block(Vector3.new(0.3, 0.06, 0.1), Color3.fromRGB(60, 40, 35),
		AB.offset(originCF, -0.4, 2.5, 0.82), model, "EyeL")
	AB.block(Vector3.new(0.3, 0.06, 0.1), Color3.fromRGB(60, 40, 35),
		AB.offset(originCF, 0.4, 2.5, 0.82), model, "EyeR")
	-- Wrinkles (crow's feet)
	AB.block(Vector3.new(0.15, 0.04, 0.06), Color3.fromRGB(190, 160, 130),
		AB.offset(originCF, -0.75, 2.4, 0.82), model, "WrinkleL")
	AB.block(Vector3.new(0.15, 0.04, 0.06), Color3.fromRGB(190, 160, 130),
		AB.offset(originCF, 0.75, 2.4, 0.82), model, "WrinkleR")
	-- Pursed lips
	AB.block(Vector3.new(0.4, 0.1, 0.1), Color3.fromRGB(160, 80, 80),
		AB.offset(originCF, 0, 1.95, 0.85), model, "Lips")

	-- Arms (one carrying bag, one resting)
	AB.part({size=Vector3.new(0.85, 2.3, 0.85), color=DRESS,
		cf=AB.offset(originCF, -1.6, 0, 0), canCollide=false, name="ArmL"}, model)
	AB.part({size=Vector3.new(0.85, 2.3, 0.85), color=DRESS,
		cf=AB.offset(originCF, 1.6, 0, 0), canCollide=false, name="ArmR"}, model)
	-- Hands
	AB.sphere(0.45, SKIN, AB.offset(originCF, -1.6, -1.2, 0), model, "HandL")
	AB.sphere(0.45, SKIN, AB.offset(originCF, 1.6, -1.2, 0), model, "HandR")

	-- Shopping bag (string net bag with handles) in right hand
	-- Bag body
	AB.sphere(1.4, BAG, AB.offset(originCF, 1.6, -2.8, 0), model, "BagBody")
	-- Bag handle
	AB.cylinder(0.1, 1.5, BAG, AB.offset(originCF, 1.6, -1.6, 0), model, "BagHandle")
	-- Items poking out of bag
	-- Bread loaf
	AB.cylinder(0.5, 2.5, BREAD,
		AB.offset(originCF, 1.6, -1.5, 0) * CFrame.Angles(math.rad(20), 0, math.rad(10)),
		model, "Bread")
	-- Score marks on bread
	AB.block(Vector3.new(0.05, 0.6, 0.05), Color3.fromRGB(180, 130, 70),
		AB.offset(originCF, 1.7, -1.2, 0) * CFrame.Angles(math.rad(20), 0, math.rad(10)),
		model, "BreadScore")
	-- Tomatoes (visible at top of bag)
	for i, off in {Vector3.new(0.5, 0, 0.4), Vector3.new(-0.4, 0.2, -0.3), Vector3.new(0.3, 0.3, -0.4)} do
		AB.sphere(0.3, TOMATO, AB.offset(originCF, 1.6 + off.X, -2.5 + off.Y, off.Z), model, "BagTomato_" .. i)
		AB.sphere(0.08, Color3.fromRGB(80, 140, 60), AB.offset(originCF, 1.6 + off.X, -2.2 + off.Y, off.Z), model, "BagTomStem_" .. i)
	end
	-- Wine bottle neck poking out
	AB.cylinder(0.25, 1, BOTTLE, AB.offset(originCF, 1.4, -1.8, -0.5), model, "WineNeck")
	AB.sphere(0.2, Color3.fromRGB(195, 165, 120), AB.offset(originCF, 1.4, -1.3, -0.5), model, "WineCork")
	-- Net pattern on bag (small diamond pattern via crossed thin lines)
	for i = 0, 3 do
		AB.cylinder(0.05, 2.5, Color3.fromRGB(160, 130, 90),
			AB.offset(originCF, 1.6, -2.8, 0) * CFrame.Angles(0, math.rad(i * 45), math.rad(90)),
			model, "NetLine_" .. i)
	end

	-- Cane in left hand
	AB.cylinder(0.15, 4, Color3.fromRGB(80, 50, 30),
		AB.offset(originCF, -1.6, -2.8, 0), model, "Cane")
	-- Cane handle (curved)
	AB.sphere(0.3, Color3.fromRGB(80, 50, 30), AB.offset(originCF, -1.8, -0.8, 0.3), model, "CaneHandle")

	AB.billboard(head, NAME, Vector2.new(220, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
