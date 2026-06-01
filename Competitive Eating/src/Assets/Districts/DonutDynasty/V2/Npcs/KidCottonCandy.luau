-- KidCottonCandy — small child holding an oversized pink cotton-candy
-- swirl on a stick.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN  = Color3.fromRGB(248, 220, 195)
local HAIR  = Color3.fromRGB(220, 160, 60)
local SHIRT = Color3.fromRGB(180, 230, 200)
local PANTS = Color3.fromRGB(100, 80, 90)
local SHOE  = Color3.fromRGB(40, 40, 40)
local PINK  = Color3.fromRGB(255, 200, 214)
local DEEP  = Color3.fromRGB(232, 130, 165)
local CREAM = Color3.fromRGB(255, 240, 220)
local STICK = Color3.fromRGB(92, 57, 36)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("KidCottonCandy", parent)

	-- Small legs
	AB.block(Vector3.new(0.6, 1.3, 0.7), PANTS, AB.offset(originCF, -0.35, 0.65, 0), model, "LegL")
	AB.block(Vector3.new(0.6, 1.3, 0.7), PANTS, AB.offset(originCF, 0.35, 0.65, 0), model, "LegR")
	AB.block(Vector3.new(0.7, 0.3, 1), SHOE, AB.offset(originCF, -0.35, 0.15, 0.15), model, "ShoeL")
	AB.block(Vector3.new(0.7, 0.3, 1), SHOE, AB.offset(originCF, 0.35, 0.15, 0.15), model, "ShoeR")

	-- Torso
	local torso = AB.block(Vector3.new(1.8, 1.8, 0.9), SHIRT,
		AB.offset(originCF, 0, 2.2, 0), model, "Torso")
	-- T-shirt logo (heart)
	AB.sphere(0.4, DEEP, AB.offset(originCF, -0.2, 2.5, 0.5), model, "ShirtHeartL")
	AB.sphere(0.4, DEEP, AB.offset(originCF, 0.2, 2.5, 0.5), model, "ShirtHeartR")
	AB.wedge(Vector3.new(0.4, 0.6, 0.2), DEEP,
		AB.offset(originCF, 0, 2.1, 0.5) * CFrame.Angles(math.rad(180), 0, 0), model, "ShirtHeartTip")

	-- Arms — one up holding stick
	AB.block(Vector3.new(0.5, 1.8, 0.5), SHIRT, AB.offset(originCF, -1.15, 2.3, 0), model, "ArmL")
	AB.block(Vector3.new(0.5, 1.8, 0.5), SHIRT,
		AB.offset(originCF, 1.15, 2.9, 0) * CFrame.Angles(math.rad(-80), 0, 0), model, "ArmR")
	AB.sphere(0.45, SKIN, AB.offset(originCF, -1.15, 1.3, 0), model, "HandL")
	AB.sphere(0.45, SKIN, AB.offset(originCF, 1.15, 3.6, 0.8), model, "HandR")

	-- Head
	AB.sphere(1.3, SKIN, AB.offset(originCF, 0, 3.9, 0), model, "Head")
	-- Curly hair (two puffs)
	AB.sphere(0.9, HAIR, AB.offset(originCF, -0.5, 4.6, 0), model, "HairL")
	AB.sphere(0.9, HAIR, AB.offset(originCF, 0.5, 4.6, 0), model, "HairR")
	AB.sphere(0.7, HAIR, AB.offset(originCF, 0, 4.8, -0.4), model, "HairBack")
	-- Cheeks (rosy)
	AB.sphere(0.25, PINK, AB.offset(originCF, -0.6, 3.8, 0.7), model, "CheekL")
	AB.sphere(0.25, PINK, AB.offset(originCF, 0.6, 3.8, 0.7), model, "CheekR")

	-- Cotton candy stick (held up)
	AB.cylinder(0.2, 3, STICK,
		AB.offset(originCF, 1.15, 5.5, 0.8), model, "Stick")
	-- Cotton candy puffs (big swirl)
	AB.sphere(2.4, PINK, AB.offset(originCF, 1.15, 8, 0.8), model, "CCMain")
	AB.sphere(1.6, DEEP, AB.offset(originCF, 0.4, 8.3, 0.8), model, "CCL")
	AB.sphere(1.6, CREAM, AB.offset(originCF, 1.9, 8.3, 0.8), model, "CCR")
	AB.sphere(1.4, PINK, AB.offset(originCF, 1.15, 8.8, 0), model, "CCBack")
	AB.sphere(1.4, PINK, AB.offset(originCF, 1.15, 8.8, 1.6), model, "CCFront")
	AB.sphere(1.3, DEEP, AB.offset(originCF, 1.15, 9.4, 0.8), model, "CCTop")

	AB.billboard(torso, "Kid", nil, 4)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
