-- Smash Riley — burger-flipper chef NPC. White apron, red bandana, spatula.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN     = Color3.fromRGB(225, 185, 145)
local APRON    = Color3.fromRGB(255, 245, 232)
local BANDANA  = Color3.fromRGB(255, 48, 48)
local PANTS    = Color3.fromRGB(60, 60, 70)
local CHROME   = Color3.fromRGB(176, 176, 176)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SmashRiley", parent)

	-- Legs
	AB.block(Vector3.new(0.7, 2.4, 0.7), PANTS, AB.offset(originCF, -0.4, 1.2, 0), model, "LegL")
	AB.block(Vector3.new(0.7, 2.4, 0.7), PANTS, AB.offset(originCF,  0.4, 1.2, 0), model, "LegR")

	-- Torso (apron front)
	local torso = AB.block(
		Vector3.new(2, 2.5, 1),
		APRON,
		AB.offset(originCF, 0, 3.65, 0),
		model,
		"Torso"
	)

	-- Red apron neck-strap
	AB.block(Vector3.new(0.3, 0.8, 0.15), BANDANA, AB.offset(originCF, -0.7, 4.7, 0.5), model, "StrapL")
	AB.block(Vector3.new(0.3, 0.8, 0.15), BANDANA, AB.offset(originCF,  0.7, 4.7, 0.5), model, "StrapR")

	-- Arms
	AB.block(Vector3.new(0.6, 2, 0.6), APRON, AB.offset(originCF, -1.3, 3.5, 0), model, "ArmL")
	AB.block(Vector3.new(0.6, 2, 0.6), APRON, AB.offset(originCF,  1.3, 3.5, 0), model, "ArmR")

	-- Hands
	AB.sphere(0.55, SKIN, AB.offset(originCF, -1.3, 2.4, 0), model, "HandL")
	AB.sphere(0.55, SKIN, AB.offset(originCF,  1.3, 2.4, 0), model, "HandR")

	-- Spatula in right hand (chrome rectangle on a wooden handle)
	AB.cylinder(0.15, 1.6, Color3.fromRGB(140, 90, 50), AB.offset(originCF, 1.3, 1.5, 0) * CFrame.Angles(0, 0, math.rad(-90)), model, "SpatulaHandle")
	local spat = AB.block(
		Vector3.new(0.9, 0.08, 1.2),
		CHROME,
		AB.offset(originCF, 1.3, 0.6, 0),
		model,
		"SpatulaBlade"
	)
	spat.Material   = Enum.Material.Metal
	spat.Reflectance = 0.5

	-- Head
	AB.sphere(1.4, SKIN, AB.offset(originCF, 0, 5.6, 0), model, "Head")

	-- Red bandana (a flat band wrapping the forehead)
	AB.block(Vector3.new(1.5, 0.5, 1.5), BANDANA, AB.offset(originCF, 0, 6.1, 0), model, "Bandana")

	-- Bandana knot (a small ball off the back)
	AB.sphere(0.4, BANDANA, AB.offset(originCF, 0, 6.2, -0.9), model, "BandanaKnot")

	-- Eyes (two small black dots)
	AB.sphere(0.12, Color3.fromRGB(20, 20, 20), AB.offset(originCF, -0.3, 5.65, 0.65), model, "EyeL")
	AB.sphere(0.12, Color3.fromRGB(20, 20, 20), AB.offset(originCF,  0.3, 5.65, 0.65), model, "EyeR")

	-- Name tag
	AB.billboard(torso, "Smash Riley", Vector2.new(220, 36), 4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
