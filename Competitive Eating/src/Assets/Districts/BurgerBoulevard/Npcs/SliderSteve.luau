-- Slider Steve — bowling-shirt diner regular. Shorter, rounder, mustache.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN      = Color3.fromRGB(225, 185, 145)
local SHIRT     = Color3.fromRGB(127, 202, 194)
local SHIRT_TRIM= Color3.fromRGB(255, 245, 232)
local PANTS     = Color3.fromRGB(80, 60, 50)
local HAIR      = Color3.fromRGB(160, 120, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SliderSteve", parent)

	-- Legs (shorter — Steve is a stocky guy)
	AB.block(Vector3.new(0.8, 2.0, 0.8), PANTS, AB.offset(originCF, -0.45, 1.0, 0), model, "LegL")
	AB.block(Vector3.new(0.8, 2.0, 0.8), PANTS, AB.offset(originCF,  0.45, 1.0, 0), model, "LegR")

	-- Belt
	AB.block(Vector3.new(2.4, 0.3, 1.3), Color3.fromRGB(50, 35, 25), AB.offset(originCF, 0, 2.1, 0), model, "Belt")

	-- Torso (round bowling shirt — wider, shorter)
	local torso = AB.block(
		Vector3.new(2.4, 2.4, 1.3),
		SHIRT,
		AB.offset(originCF, 0, 3.4, 0),
		model,
		"Torso"
	)

	-- Bowling shirt trim (vertical white stripe down the front)
	AB.block(
		Vector3.new(0.5, 2.4, 0.05),
		SHIRT_TRIM,
		AB.offset(originCF, 0, 3.4, 0.7),
		model,
		"FrontStripe"
	)

	-- Shirt buttons (3 small dots)
	for i, y in {2.7, 3.4, 4.1} do
		AB.sphere(0.13, Color3.fromRGB(40, 40, 50), AB.offset(originCF, 0, y, 0.73), model, "Button_" .. i)
	end

	-- "Steve" name patch on chest
	AB.block(Vector3.new(0.9, 0.5, 0.05), SHIRT_TRIM, AB.offset(originCF, -0.8, 4.0, 0.7), model, "NamePatch")

	-- Arms (rolled sleeves — show skin at the ends)
	AB.block(Vector3.new(0.7, 1.4, 0.7), SHIRT, AB.offset(originCF, -1.5, 3.8, 0), model, "ArmUpL")
	AB.block(Vector3.new(0.7, 1.4, 0.7), SHIRT, AB.offset(originCF,  1.5, 3.8, 0), model, "ArmUpR")
	AB.block(Vector3.new(0.7, 0.8, 0.7), SKIN,  AB.offset(originCF, -1.5, 2.6, 0), model, "ArmDnL")
	AB.block(Vector3.new(0.7, 0.8, 0.7), SKIN,  AB.offset(originCF,  1.5, 2.6, 0), model, "ArmDnR")

	-- Hands
	AB.sphere(0.55, SKIN, AB.offset(originCF, -1.5, 2.0, 0), model, "HandL")
	AB.sphere(0.55, SKIN, AB.offset(originCF,  1.5, 2.0, 0), model, "HandR")

	-- Head (slightly bigger, jolly)
	AB.sphere(1.5, SKIN, AB.offset(originCF, 0, 5.4, 0), model, "Head")

	-- Hair (a thin layer on top — receding hairline suggested by leaving forehead bare)
	AB.block(Vector3.new(1.5, 0.4, 1.3), HAIR, AB.offset(originCF, 0, 6.1, -0.1), model, "Hair")

	-- Mustache (the signature)
	AB.block(Vector3.new(1.0, 0.18, 0.15), HAIR, AB.offset(originCF, 0, 5.0, 0.78), model, "Mustache")

	-- Eyes
	AB.sphere(0.13, Color3.fromRGB(20, 20, 20), AB.offset(originCF, -0.32, 5.55, 0.7), model, "EyeL")
	AB.sphere(0.13, Color3.fromRGB(20, 20, 20), AB.offset(originCF,  0.32, 5.55, 0.7), model, "EyeR")

	-- Name tag
	AB.billboard(torso, "Slider Steve", Vector2.new(220, 36), 4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
