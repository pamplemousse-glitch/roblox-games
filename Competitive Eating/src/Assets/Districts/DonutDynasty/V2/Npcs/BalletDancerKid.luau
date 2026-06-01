-- BalletDancerKid — child ballerina in pink tutu, frozen in arabesque
-- pose, with hair in a bun and ballet slippers.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN  = Color3.fromRGB(250, 220, 200)
local HAIR  = Color3.fromRGB(70, 45, 30)
local TUTU  = Color3.fromRGB(255, 200, 214)
local DEEP  = Color3.fromRGB(232, 130, 165)
local LEOT  = Color3.fromRGB(232, 130, 165)
local CREAM = Color3.fromRGB(255, 240, 220)
local SLIP  = Color3.fromRGB(255, 200, 214)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BalletDancerKid", parent)

	-- Standing leg (slight tip-toe — under torso)
	AB.block(Vector3.new(0.5, 2.4, 0.6), SKIN, AB.offset(originCF, 0, 1.2, 0), model, "LegStand")
	-- Slipper on standing leg
	AB.block(Vector3.new(0.6, 0.3, 0.9), SLIP, AB.offset(originCF, 0, 0.1, 0.1), model, "SlipperStand")
	AB.cylinder(0.4, 0.3, SLIP, AB.offset(originCF, 0, 0.4, 0), model, "AnkleStrapStand")
	-- Ribbon laces up shin
	for i = 1, 3 do
		AB.cylinder(0.55, 0.1, DEEP,
			AB.offset(originCF, 0, 0.8 + (i - 1) * 0.6, 0, i * 35), model, "Ribbon_" .. i)
	end

	-- Extended back leg (arabesque) — angled up behind
	AB.block(Vector3.new(0.5, 2.6, 0.6), SKIN,
		AB.offset(originCF, 0, 2.5, -1.8) * CFrame.Angles(math.rad(-60), 0, 0), model, "LegExt")
	AB.block(Vector3.new(0.6, 0.3, 0.9), SLIP,
		AB.offset(originCF, 0, 3.6, -3.2) * CFrame.Angles(math.rad(-60), 0, 0), model, "SlipperExt")

	-- Tutu (flat horizontal disc) — short cylinder
	AB.cylinder(4.5, 0.3, TUTU, AB.offset(originCF, 0, 3, 0), model, "Tutu")
	AB.cylinder(4.5, 0.3, DEEP, AB.offset(originCF, 0, 3.3, 0), model, "TutuUnder")
	-- Tutu petal ruffles
	for i = 1, 12 do
		local a = (i / 12) * math.pi * 2
		AB.sphere(0.7, TUTU,
			AB.offset(originCF, math.cos(a) * 2.2, 3.1, math.sin(a) * 2.2),
			model, "TutuPuff_" .. i)
	end

	-- Leotard torso
	local torso = AB.block(Vector3.new(1.6, 2.4, 0.9), LEOT,
		AB.offset(originCF, 0, 3.9, 0), model, "Torso")
	-- Leotard strap accents
	AB.block(Vector3.new(0.2, 1.2, 0.95), CREAM,
		AB.offset(originCF, -0.5, 4.6, 0), model, "StrapL")
	AB.block(Vector3.new(0.2, 1.2, 0.95), CREAM,
		AB.offset(originCF, 0.5, 4.6, 0), model, "StrapR")

	-- Arms in en haut (one up, one out)
	AB.block(Vector3.new(0.4, 2.2, 0.4), SKIN,
		AB.offset(originCF, -0.7, 5.5, 0) * CFrame.Angles(0, 0, math.rad(50)), model, "ArmL")
	AB.block(Vector3.new(0.4, 2.2, 0.4), SKIN,
		AB.offset(originCF, 1.2, 4.2, 0) * CFrame.Angles(0, 0, math.rad(-80)), model, "ArmR")
	AB.sphere(0.4, SKIN, AB.offset(originCF, -1.6, 6.5, 0), model, "HandL")
	AB.sphere(0.4, SKIN, AB.offset(originCF, 2.4, 4.2, 0), model, "HandR")

	-- Head
	AB.sphere(1.2, SKIN, AB.offset(originCF, 0, 6.7, 0), model, "Head")
	-- Bun hair
	AB.sphere(1.1, HAIR, AB.offset(originCF, 0, 7, -0.2), model, "Hair")
	AB.sphere(0.7, HAIR, AB.offset(originCF, 0, 7.8, -0.3), model, "Bun")
	AB.cylinder(0.9, 0.1, TUTU, AB.offset(originCF, 0, 7.8, -0.3, 90), model, "BunRibbon")

	-- Pink flower on bun
	AB.sphere(0.3, DEEP, AB.offset(originCF, 0, 8.2, -0.3), model, "BunFlower")

	AB.billboard(torso, "Ballerina", nil, 5)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
