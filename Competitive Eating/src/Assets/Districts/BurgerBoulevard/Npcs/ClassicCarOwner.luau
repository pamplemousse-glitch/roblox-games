-- ClassicCarOwner — middle-aged guy with hawaiian shirt, sunglasses, dangling keys.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN    = Color3.fromRGB(225, 175, 130)
local HAWAII  = Color3.fromRGB(220, 50, 50)
local LEAF    = Color3.fromRGB(120, 200, 90)
local SHORTS  = Color3.fromRGB(245, 240, 220)
local SHOE_BR = Color3.fromRGB(110, 70, 50)
local HAIR_GR = Color3.fromRGB(150, 145, 145)
local DARK    = Color3.fromRGB(30, 30, 35)
local CHROME  = Color3.fromRGB(176, 176, 176)
local YELLOW  = Color3.fromRGB(245, 220, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ClassicCarOwner", parent)

	-- Loafers
	AB.block(Vector3.new(0.85, 0.4, 1.2), SHOE_BR, AB.offset(originCF, -0.4, 0.2, 0.2), model, "ShoeL")
	AB.block(Vector3.new(0.85, 0.4, 1.2), SHOE_BR, AB.offset(originCF,  0.4, 0.2, 0.2), model, "ShoeR")
	-- Tassel on each loafer
	AB.cylinder(0.1, 0.3, Color3.fromRGB(220, 180, 60), AB.offset(originCF, -0.4, 0.5, 0.6), model, "TasselL")
	AB.cylinder(0.1, 0.3, Color3.fromRGB(220, 180, 60), AB.offset(originCF,  0.4, 0.5, 0.6), model, "TasselR")

	-- Legs (white shorts)
	AB.block(Vector3.new(0.8, 1.8, 0.8), SHORTS, AB.offset(originCF, -0.4, 1.3, 0), model, "LegL")
	AB.block(Vector3.new(0.8, 1.8, 0.8), SHORTS, AB.offset(originCF,  0.4, 1.3, 0), model, "LegR")
	-- Skin below shorts
	AB.block(Vector3.new(0.75, 0.6, 0.75), SKIN, AB.offset(originCF, -0.4, 0.7, 0), model, "ShinL")
	AB.block(Vector3.new(0.75, 0.6, 0.75), SKIN, AB.offset(originCF,  0.4, 0.7, 0), model, "ShinR")

	-- Belt
	AB.block(Vector3.new(2.2, 0.3, 1.2), Color3.fromRGB(70, 50, 35), AB.offset(originCF, 0, 2.35, 0), model, "Belt")
	AB.block(Vector3.new(0.4, 0.4, 1.25), YELLOW, AB.offset(originCF, 0, 2.35, 0.65), model, "Buckle")

	-- Torso (Hawaiian shirt — red with leaf prints)
	local torso = AB.block(Vector3.new(2.2, 2.5, 1.2), HAWAII, AB.offset(originCF, 0, 3.85, 0), model, "Torso")
	-- Leaf prints scattered on shirt
	for i, pos in {Vector3.new(-0.6, 4.5, 0.65), Vector3.new(0.5, 4.0, 0.65), Vector3.new(-0.2, 3.4, 0.65), Vector3.new(0.7, 3.2, 0.65), Vector3.new(-0.5, 3.2, 0.65)} do
		AB.block(Vector3.new(0.4, 0.6, 0.05), LEAF, AB.offset(originCF, pos.X, pos.Y, pos.Z) * CFrame.Angles(0, 0, math.rad(i * 30)), model, "Leaf_" .. i)
	end
	-- Shirt collar (open V-neck)
	AB.block(Vector3.new(0.3, 0.7, 0.4), HAWAII, AB.offset(originCF, -0.6, 5, 0.4) * CFrame.Angles(0, 0, math.rad(20)), model, "CollarL")
	AB.block(Vector3.new(0.3, 0.7, 0.4), HAWAII, AB.offset(originCF,  0.6, 5, 0.4) * CFrame.Angles(0, 0, math.rad(-20)), model, "CollarR")
	-- Belly (a slight bulge)
	AB.block(Vector3.new(2.3, 1.5, 1.4), HAWAII, AB.offset(originCF, 0, 3.4, 0), model, "Belly")

	-- Arms
	AB.block(Vector3.new(0.7, 1.4, 0.7), HAWAII, AB.offset(originCF, -1.4, 4.2, 0), model, "ArmL")
	AB.block(Vector3.new(0.7, 1.4, 0.7), HAWAII, AB.offset(originCF,  1.4, 4.2, 0), model, "ArmR")
	-- Forearms (skin — short sleeve shirt)
	AB.block(Vector3.new(0.7, 1, 0.7), SKIN, AB.offset(originCF, -1.4, 3, 0), model, "ForeL")
	AB.block(Vector3.new(0.7, 1, 0.7), SKIN, AB.offset(originCF,  1.4, 3, 0), model, "ForeR")
	-- Hands
	AB.sphere(0.55, SKIN, AB.offset(originCF, -1.4, 2.3, 0), model, "HandL")
	AB.sphere(0.55, SKIN, AB.offset(originCF,  1.4, 2.3, 0), model, "HandR")

	-- Car keys dangling from right hand (chrome ring + 2 keys)
	AB.cylinder(0.4, 0.1, CHROME, AB.offset(originCF, 1.4, 1.7, 0) * CFrame.Angles(0, math.rad(90), 0), model, "KeyRing")
	AB.block(Vector3.new(0.15, 0.8, 0.05), CHROME, AB.offset(originCF, 1.3, 1.2, 0), model, "Key1")
	AB.block(Vector3.new(0.15, 0.7, 0.05), CHROME, AB.offset(originCF, 1.5, 1.3, 0), model, "Key2")
	-- Key fob (red leather oval)
	AB.sphere(0.2, HAWAII, AB.offset(originCF, 1.5, 1.55, 0), model, "KeyFob")

	-- Head
	AB.sphere(1.4, SKIN, AB.offset(originCF, 0, 6.4, 0), model, "Head")
	-- Receding gray hair (a thin layer)
	AB.block(Vector3.new(1.3, 0.4, 1.3), HAIR_GR, AB.offset(originCF, 0, 7.05, -0.1), model, "Hair")
	-- Hair sides
	AB.block(Vector3.new(0.2, 0.7, 1.2), HAIR_GR, AB.offset(originCF, -0.85, 6.6, -0.1), model, "HairSideL")
	AB.block(Vector3.new(0.2, 0.7, 1.2), HAIR_GR, AB.offset(originCF,  0.85, 6.6, -0.1), model, "HairSideR")

	-- Aviator sunglasses (large dark lenses + chrome bridge)
	AB.block(Vector3.new(0.55, 0.35, 0.1), DARK, AB.offset(originCF, -0.35, 6.5, 0.7), model, "ShadeL")
	AB.block(Vector3.new(0.55, 0.35, 0.1), DARK, AB.offset(originCF,  0.35, 6.5, 0.7), model, "ShadeR")
	AB.block(Vector3.new(0.2, 0.08, 0.08), CHROME, AB.offset(originCF, 0, 6.5, 0.72), model, "ShadeBridge")
	-- Mustache
	AB.block(Vector3.new(0.8, 0.15, 0.15), HAIR_GR, AB.offset(originCF, 0, 6, 0.7), model, "Mustache")
	-- Smile
	AB.block(Vector3.new(0.5, 0.1, 0.08), DARK, AB.offset(originCF, 0, 5.7, 0.68), model, "Smile")

	AB.billboard(torso, "ClassicCarOwner", Vector2.new(220, 36), 4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
