-- RollerSkatingWaitress — carhop on skates, holding a tray of burgers + shakes.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN     = Color3.fromRGB(235, 200, 170)
local UNIFORM  = Color3.fromRGB(255, 48, 48)
local APRON    = Color3.fromRGB(255, 245, 232)
local CHROME   = Color3.fromRGB(176, 176, 176)
local DARK     = Color3.fromRGB(30, 30, 35)
local HAIR_BL  = Color3.fromRGB(220, 200, 130)
local WHITE    = Color3.fromRGB(245, 245, 240)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RollerSkatingWaitress", parent)

	-- Roller skates (white with red trim + 4 small wheels each)
	for _, side in {-0.4, 0.4} do
		AB.block(Vector3.new(0.8, 0.5, 1.3), WHITE, AB.offset(originCF, side, 0.5, 0.2), model, "Skate_" .. side)
		AB.block(Vector3.new(0.85, 0.2, 1.35), UNIFORM, AB.offset(originCF, side, 0.65, 0.2), model, "SkateTrim_" .. side)
		-- 4 wheels per skate
		for w = 0, 3 do
			local wx = side + ((w % 2 == 0) and -0.25 or 0.25)
			local wz = 0.2 + ((w < 2) and -0.4 or 0.4)
			AB.cylinder(0.4, 0.25, DARK, AB.offset(originCF, wx, 0.2, wz) * CFrame.Angles(0, math.rad(90), 0), model, "Wheel_" .. side .. "_" .. w)
		end
	end
	-- Legs (tights)
	AB.block(Vector3.new(0.55, 2.2, 0.55), SKIN, AB.offset(originCF, -0.4, 1.9, 0), model, "LegL")
	AB.block(Vector3.new(0.55, 2.2, 0.55), SKIN, AB.offset(originCF,  0.4, 1.9, 0), model, "LegR")
	-- Skirt (red flare)
	AB.block(Vector3.new(2.2, 1.3, 1.5), UNIFORM, AB.offset(originCF, 0, 3.5, 0), model, "Skirt")
	-- White hem
	AB.block(Vector3.new(2.3, 0.2, 1.6), WHITE, AB.offset(originCF, 0, 2.9, 0), model, "Hem")
	-- Torso (red top w/ white apron)
	local torso = AB.block(Vector3.new(1.8, 2, 1), UNIFORM, AB.offset(originCF, 0, 5, 0), model, "Torso")
	AB.block(Vector3.new(1.5, 1.8, 0.05), APRON, AB.offset(originCF, 0, 5, 0.55), model, "Apron")
	-- Apron strap
	AB.block(Vector3.new(0.3, 0.8, 0.1), WHITE, AB.offset(originCF, 0, 6.1, 0.55), model, "AprStrap")
	-- Arms (one raised holding tray)
	AB.block(Vector3.new(0.5, 1.6, 0.5), UNIFORM, AB.offset(originCF, -1.2, 4.8, 0), model, "ArmL")
	-- Right arm raised at angle holding tray
	AB.block(Vector3.new(0.5, 1.8, 0.5), UNIFORM, AB.offset(originCF, 1.3, 5.5, 0.2) * CFrame.Angles(0, 0, math.rad(-25)), model, "ArmR")
	AB.sphere(0.5, SKIN, AB.offset(originCF, -1.2, 3.9, 0), model, "HandL")
	AB.sphere(0.5, SKIN, AB.offset(originCF, 1.6, 6.2, 0.3), model, "HandR")

	-- Tray held high in right hand
	AB.cylinder(2.5, 0.2, CHROME, AB.offset(originCF, 1.6, 6.5, 0.3), model, "Tray")
	-- Tray contents
	AB.cylinder(0.7, 0.5, AB.colors.bunTan, AB.offset(originCF, 1.2, 6.85, 0.3), model, "TrayBurger1")
	AB.cylinder(0.7, 0.5, AB.colors.bunTan, AB.offset(originCF, 2.0, 6.85, 0.3), model, "TrayBurger2")
	AB.cylinder(0.5, 1.2, WHITE, AB.offset(originCF, 1.6, 7.2, 0.5), model, "TrayShake")
	AB.sphere(0.4, UNIFORM, AB.offset(originCF, 1.6, 7.9, 0.5), model, "TrayCherry")

	-- Head + blonde hair in a 50s flip
	AB.sphere(1.35, SKIN, AB.offset(originCF, 0, 7.1, 0), model, "Head")
	AB.sphere(1.45, HAIR_BL, AB.offset(originCF, 0, 7.4, -0.1), model, "Hair")
	AB.block(Vector3.new(1.4, 0.5, 0.3), HAIR_BL, AB.offset(originCF, 0, 7.7, 0.6), model, "HairBangs")
	-- Hair flip curl at end
	AB.sphere(0.6, HAIR_BL, AB.offset(originCF, 1.3, 6.8, -0.2), model, "HairCurlL")
	AB.sphere(0.6, HAIR_BL, AB.offset(originCF, -1.3, 6.8, -0.2), model, "HairCurlR")

	-- Pillbox red hat
	AB.cylinder(0.9, 0.3, UNIFORM, AB.offset(originCF, 0, 8.3, 0), model, "Cap")
	AB.cylinder(0.7, 0.3, UNIFORM, AB.offset(originCF, 0, 8.6, 0), model, "CapTop")

	-- Eyes + lips
	AB.sphere(0.15, DARK, AB.offset(originCF, -0.3, 7.2, 0.62), model, "EyeL")
	AB.sphere(0.15, DARK, AB.offset(originCF,  0.3, 7.2, 0.62), model, "EyeR")
	AB.block(Vector3.new(0.4, 0.1, 0.05), UNIFORM, AB.offset(originCF, 0, 6.75, 0.7), model, "Lips")

	AB.billboard(torso, "RollerSkatingWaitress", Vector2.new(240, 36), 4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
