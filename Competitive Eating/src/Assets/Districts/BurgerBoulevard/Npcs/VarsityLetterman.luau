-- VarsityLetterman — letterman jacket, slicked hair, varsity "S".

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN    = Color3.fromRGB(240, 210, 175)
local JACKET  = Color3.fromRGB(40, 70, 130)
local SLEEVE  = Color3.fromRGB(245, 245, 240)
local PANTS   = Color3.fromRGB(70, 70, 80)
local SHOE    = Color3.fromRGB(245, 245, 240)
local HAIR_BR = Color3.fromRGB(80, 50, 30)
local DARK    = Color3.fromRGB(30, 30, 35)
local GOLD    = Color3.fromRGB(220, 180, 60)
local RED     = Color3.fromRGB(180, 30, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("VarsityLetterman", parent)

	-- Sneakers (Converse-style white)
	AB.block(Vector3.new(0.9, 0.4, 1.3), SHOE, AB.offset(originCF, -0.4, 0.2, 0.2), model, "ShoeL")
	AB.block(Vector3.new(0.9, 0.4, 1.3), SHOE, AB.offset(originCF,  0.4, 0.2, 0.2), model, "ShoeR")
	-- Shoe trim
	AB.block(Vector3.new(0.95, 0.1, 1.35), DARK, AB.offset(originCF, -0.4, 0.45, 0.2), model, "ShoeTrimL")
	AB.block(Vector3.new(0.95, 0.1, 1.35), DARK, AB.offset(originCF,  0.4, 0.45, 0.2), model, "ShoeTrimR")
	-- Legs (chinos)
	AB.block(Vector3.new(0.7, 2.4, 0.7), PANTS, AB.offset(originCF, -0.4, 1.6, 0), model, "LegL")
	AB.block(Vector3.new(0.7, 2.4, 0.7), PANTS, AB.offset(originCF,  0.4, 1.6, 0), model, "LegR")

	-- Torso (varsity jacket body — navy with cream sleeves)
	local torso = AB.block(Vector3.new(2.1, 2.5, 1.1), JACKET, AB.offset(originCF, 0, 4.4, 0), model, "Torso")
	-- Varsity "S" patch
	local patch = AB.block(Vector3.new(1, 1.2, 0.1), SLEEVE, AB.offset(originCF, -0.3, 4.4, 0.6), model, "Patch")
	AB.billboard(patch, "S", Vector2.new(60, 80), 0)
	-- Jacket button strip (vertical line)
	AB.block(Vector3.new(0.1, 2.4, 0.08), GOLD, AB.offset(originCF, 0.4, 4.4, 0.62), model, "ButtonStrip")
	for i, y in {3.6, 4.2, 4.8} do
		AB.sphere(0.12, GOLD, AB.offset(originCF, 0.4, y, 0.7), model, "Button_" .. i)
	end
	-- Collar trim (cream + gold)
	AB.block(Vector3.new(2.1, 0.3, 1.15), SLEEVE, AB.offset(originCF, 0, 5.7, 0), model, "Collar")
	AB.block(Vector3.new(2.15, 0.1, 1.2), GOLD, AB.offset(originCF, 0, 5.85, 0), model, "CollarTrim")
	-- Waistband
	AB.block(Vector3.new(2.15, 0.3, 1.15), SLEEVE, AB.offset(originCF, 0, 3.1, 0), model, "Waistband")
	AB.block(Vector3.new(2.2, 0.1, 1.2), GOLD, AB.offset(originCF, 0, 2.95, 0), model, "WaistTrim")

	-- Arms (cream sleeves — different color from body)
	AB.block(Vector3.new(0.65, 2, 0.65), SLEEVE, AB.offset(originCF, -1.35, 4.2, 0), model, "ArmL")
	AB.block(Vector3.new(0.65, 2, 0.65), SLEEVE, AB.offset(originCF,  1.35, 4.2, 0), model, "ArmR")
	-- Sleeve gold band at cuff
	AB.block(Vector3.new(0.7, 0.2, 0.7), GOLD, AB.offset(originCF, -1.35, 3.1, 0), model, "CuffL")
	AB.block(Vector3.new(0.7, 0.2, 0.7), GOLD, AB.offset(originCF,  1.35, 3.1, 0), model, "CuffR")
	-- Hands
	AB.sphere(0.55, SKIN, AB.offset(originCF, -1.35, 2.7, 0), model, "HandL")
	AB.sphere(0.55, SKIN, AB.offset(originCF,  1.35, 2.7, 0), model, "HandR")
	-- Football in right hand (a brown ellipsoid)
	AB.sphere(0.7, Color3.fromRGB(140, 80, 40), AB.offset(originCF, 1.35, 2.7, 0.8), model, "Football")
	AB.block(Vector3.new(0.4, 0.1, 0.1), SLEEVE, AB.offset(originCF, 1.35, 2.95, 0.8), model, "FootballLace1")
	AB.block(Vector3.new(0.4, 0.1, 0.1), SLEEVE, AB.offset(originCF, 1.35, 2.85, 0.8), model, "FootballLace2")
	AB.block(Vector3.new(0.4, 0.1, 0.1), SLEEVE, AB.offset(originCF, 1.35, 2.75, 0.8), model, "FootballLace3")

	-- Head
	AB.sphere(1.4, SKIN, AB.offset(originCF, 0, 6.7, 0), model, "Head")
	-- Hair (slicked side-part)
	AB.sphere(1.45, HAIR_BR, AB.offset(originCF, 0, 7.1, -0.1), model, "Hair")
	AB.block(Vector3.new(1.3, 0.4, 0.3), HAIR_BR, AB.offset(originCF, 0, 7.5, 0.5), model, "HairFront")
	-- Hair part (a thin lighter line)
	AB.block(Vector3.new(0.05, 0.2, 1.4), Color3.fromRGB(50, 30, 20), AB.offset(originCF, -0.5, 7.7, 0), model, "Part")

	-- Eyes
	AB.sphere(0.13, DARK, AB.offset(originCF, -0.3, 6.8, 0.65), model, "EyeL")
	AB.sphere(0.13, DARK, AB.offset(originCF,  0.3, 6.8, 0.65), model, "EyeR")
	-- Smile
	AB.block(Vector3.new(0.7, 0.1, 0.1), DARK, AB.offset(originCF, 0, 6.3, 0.68), model, "Smile")
	-- Teeth
	AB.sphere(0.07, SLEEVE, AB.offset(originCF, -0.15, 6.35, 0.7), model, "Tooth1")
	AB.sphere(0.07, SLEEVE, AB.offset(originCF, 0.15, 6.35, 0.7), model, "Tooth2")

	AB.billboard(torso, "VarsityLetterman", Vector2.new(220, 36), 4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
