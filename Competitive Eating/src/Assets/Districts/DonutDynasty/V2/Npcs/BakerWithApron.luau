-- BakerWithApron — burly baker with rolled sleeves, flour-dusted cream
-- apron, big mustache, holding a fresh loaf of bread.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN  = Color3.fromRGB(235, 195, 165)
local HAIR  = Color3.fromRGB(60, 45, 35)
local SHIRT = Color3.fromRGB(255, 240, 220)
local APRON = Color3.fromRGB(232, 130, 165)
local PANTS = Color3.fromRGB(92, 57, 36)
local SHOE  = Color3.fromRGB(40, 30, 25)
local BREAD = Color3.fromRGB(212, 168, 82)
local DOUGH = Color3.fromRGB(220, 170, 110)
local CREAM = Color3.fromRGB(255, 240, 220)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BakerWithApron", parent)

	-- Legs (wider, burlier)
	AB.block(Vector3.new(1, 2.6, 1), PANTS, AB.offset(originCF, -0.65, 1.3, 0), model, "LegL")
	AB.block(Vector3.new(1, 2.6, 1), PANTS, AB.offset(originCF, 0.65, 1.3, 0), model, "LegR")
	AB.block(Vector3.new(1.1, 0.4, 1.3), SHOE, AB.offset(originCF, -0.65, 0.2, 0.15), model, "ShoeL")
	AB.block(Vector3.new(1.1, 0.4, 1.3), SHOE, AB.offset(originCF, 0.65, 0.2, 0.15), model, "ShoeR")

	-- Bulky torso
	local torso = AB.block(Vector3.new(3, 3, 1.4), SHIRT,
		AB.offset(originCF, 0, 4.2, 0), model, "Torso")
	-- Pink apron over torso
	AB.block(Vector3.new(2.5, 3.2, 0.15), APRON,
		AB.offset(originCF, 0, 4.1, 0.75), model, "Apron")
	-- Apron neck strap
	AB.block(Vector3.new(0.3, 1.4, 0.05), APRON,
		AB.offset(originCF, 0, 5.8, 0.75), model, "ApronStrap")
	-- Apron waist tie
	AB.block(Vector3.new(2.6, 0.3, 0.2), APRON,
		AB.offset(originCF, 0, 3, 0.75), model, "ApronTie")
	-- Bow at waist
	AB.sphere(0.6, APRON, AB.offset(originCF, -0.6, 3, 0.85), model, "BowL")
	AB.sphere(0.6, APRON, AB.offset(originCF, 0.6, 3, 0.85), model, "BowR")
	-- Flour dust on apron (small cream specks)
	for i = 1, 8 do
		local x = (math.random() - 0.5) * 2
		local y = 3 + math.random() * 2.5
		AB.sphere(0.15, CREAM, AB.offset(originCF, x, y, 0.86), model, "Flour_" .. i)
	end

	-- Rolled sleeves (puffed at shoulder, bare forearms)
	AB.block(Vector3.new(0.8, 1.2, 0.9), SHIRT, AB.offset(originCF, -1.9, 5.3, 0), model, "SleeveL")
	AB.block(Vector3.new(0.8, 1.2, 0.9), SHIRT, AB.offset(originCF, 1.9, 5.3, 0), model, "SleeveR")
	-- Bare arms below
	AB.block(Vector3.new(0.85, 1.8, 0.85), SKIN, AB.offset(originCF, -1.9, 3.8, 0), model, "ArmL")
	AB.block(Vector3.new(0.85, 1.8, 0.85), SKIN,
		AB.offset(originCF, 1.9, 3.8, 0.6) * CFrame.Angles(math.rad(-25), 0, 0), model, "ArmR")
	-- Hands
	AB.sphere(0.7, SKIN, AB.offset(originCF, -1.9, 2.7, 0), model, "HandL")
	AB.sphere(0.7, SKIN, AB.offset(originCF, 1.9, 3.1, 1.4), model, "HandR")

	-- Head + mustache
	AB.sphere(1.7, SKIN, AB.offset(originCF, 0, 6.5, 0), model, "Head")
	-- Big bushy mustache
	AB.block(Vector3.new(2.2, 0.5, 0.4), HAIR, AB.offset(originCF, 0, 6.2, 0.9), model, "Mustache")
	AB.sphere(0.6, HAIR, AB.offset(originCF, -1, 6.2, 0.9), model, "MustacheL")
	AB.sphere(0.6, HAIR, AB.offset(originCF, 1, 6.2, 0.9), model, "MustacheR")
	-- Hair
	AB.block(Vector3.new(1.7, 0.4, 1.5), HAIR, AB.offset(originCF, 0, 7.2, -0.1), model, "Hair")

	-- Chef hat
	AB.cylinder(1.8, 0.4, SHIRT, AB.offset(originCF, 0, 7.4, 0), model, "HatBand")
	AB.sphere(2.1, SHIRT, AB.offset(originCF, 0, 8.2, 0), model, "HatPuff")

	-- Loaf of bread held in right hand
	AB.block(Vector3.new(1.4, 0.9, 3), BREAD,
		AB.offset(originCF, 1.9, 2.8, 1.7), model, "BreadLoaf")
	AB.sphere(0.8, BREAD, AB.offset(originCF, 1.9, 3.2, 0.4), model, "BreadEndL")
	AB.sphere(0.8, BREAD, AB.offset(originCF, 1.9, 3.2, 3), model, "BreadEndR")
	-- Slashes on top of bread
	for i = 1, 3 do
		AB.block(Vector3.new(0.8, 0.1, 0.3), DOUGH,
			AB.offset(originCF, 1.9, 3.35, 0.8 + (i - 1) * 0.7, 30), model, "BreadSlash_" .. i)
	end

	AB.billboard(torso, "Baker", nil, 5)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
