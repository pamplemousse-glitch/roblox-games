-- Marie — French pâtissière NPC, pink-trimmed apron over a cream uniform,
-- holding the district's signature pink donut.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN   = Color3.fromRGB(245, 215, 185)
local HAIR   = Color3.fromRGB(80,  45,  30)
local UNIFM  = Color3.fromRGB(255, 240, 220)
local APRON  = Color3.fromRGB(255, 200, 214)
local PANTS  = Color3.fromRGB(60,  55,  70)
local SHOE   = Color3.fromRGB(40,  35,  30)
local DOUGH  = Color3.fromRGB(220, 170, 110)
local PINK   = Color3.fromRGB(255, 200, 214)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Marie", parent)

	-- Legs
	AB.block(Vector3.new(0.8, 2.4, 0.9), PANTS,
		AB.offset(originCF, -0.5, 1.2, 0), model, "LegL")
	AB.block(Vector3.new(0.8, 2.4, 0.9), PANTS,
		AB.offset(originCF,  0.5, 1.2, 0), model, "LegR")
	-- Shoes
	AB.block(Vector3.new(0.9, 0.3, 1.2), SHOE,
		AB.offset(originCF, -0.5, 0.15, 0.15), model, "ShoeL")
	AB.block(Vector3.new(0.9, 0.3, 1.2), SHOE,
		AB.offset(originCF,  0.5, 0.15, 0.15), model, "ShoeR")

	-- Torso (uniform)
	local torso = AB.block(Vector3.new(2.4, 2.6, 1.2), UNIFM,
		AB.offset(originCF, 0, 3.7, 0), model, "Torso")

	-- Apron front
	AB.block(Vector3.new(2.0, 2.4, 0.1), APRON,
		AB.offset(originCF, 0, 3.7, 0.65), model, "Apron")
	-- Apron neck strap
	AB.block(Vector3.new(0.3, 1.2, 0.05), APRON,
		AB.offset(originCF, 0, 5.4, 0.65), model, "ApronStrap")
	-- Apron waist bow
	AB.block(Vector3.new(1.2, 0.3, 0.2), APRON,
		AB.offset(originCF, 0, 2.7, 0.7), model, "Bow")

	-- Arms
	AB.block(Vector3.new(0.7, 2.2, 0.7), UNIFM,
		AB.offset(originCF, -1.55, 3.8, 0), model, "ArmL")
	AB.block(Vector3.new(0.7, 2.2, 0.7), UNIFM,
		AB.offset(originCF,  1.55, 3.8, 0), model, "ArmR")
	-- Hands
	AB.sphere(0.65, SKIN, AB.offset(originCF, -1.55, 2.6, 0), model, "HandL")
	AB.sphere(0.65, SKIN, AB.offset(originCF,  1.55, 2.6, 0.5), model, "HandR")

	-- Head + hair
	AB.sphere(1.6, SKIN, AB.offset(originCF, 0, 6.0, 0), model, "Head")
	AB.block(Vector3.new(1.7, 0.7, 1.6), HAIR,
		AB.offset(originCF, 0, 6.5, 0), model, "Hair")
	AB.block(Vector3.new(0.4, 1.2, 0.4), HAIR,
		AB.offset(originCF, -0.9, 5.7, 0), model, "Ponytail")

	-- Chef hat
	AB.cylinder(1.7, 0.4, UNIFM,
		AB.offset(originCF, 0, 7.0, 0), model, "HatBand")
	AB.sphere(2.0, UNIFM, AB.offset(originCF, 0, 7.8, 0), model, "HatPuff")

	-- Donut in right hand
	AB.circleArrange(AB.offset(originCF, 1.55, 2.0, 0.5), 0.5, 8, model, function(i, cf, _)
		return AB.sphere(0.5, DOUGH, cf, model, "DonutPiece_" .. i)
	end)
	AB.cylinder(0.5, 0.2, PINK,
		AB.offset(originCF, 1.55, 2.2, 0.5), model, "DonutGlaze")

	AB.billboard(torso, "Marie", nil, 5)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
