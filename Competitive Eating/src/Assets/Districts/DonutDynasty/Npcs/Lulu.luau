-- Lulu — sprinkle-loving young pâtissière NPC, gold-trimmed cream uniform,
-- twin pigtails, holding a tray of mini cinnamon rolls.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN   = Color3.fromRGB(250, 220, 195)
local HAIR   = Color3.fromRGB(212, 168, 82)
local UNIFM  = Color3.fromRGB(255, 240, 220)
local TRIM   = Color3.fromRGB(212, 168, 82)
local SKIRT  = Color3.fromRGB(255, 200, 214)
local SHOE   = Color3.fromRGB(120, 60, 80)
local TRAY   = Color3.fromRGB(160, 120, 70)
local DOUGH  = Color3.fromRGB(180, 120, 70)
local CREAM  = Color3.fromRGB(255, 240, 220)
local CINN   = Color3.fromRGB(110, 60, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Lulu", parent)

	-- Legs (shorter / younger proportions)
	AB.block(Vector3.new(0.7, 2.0, 0.8), SKIN,
		AB.offset(originCF, -0.45, 1.0, 0), model, "LegL")
	AB.block(Vector3.new(0.7, 2.0, 0.8), SKIN,
		AB.offset(originCF,  0.45, 1.0, 0), model, "LegR")
	AB.block(Vector3.new(0.8, 0.3, 1.0), SHOE,
		AB.offset(originCF, -0.45, 0.15, 0.1), model, "ShoeL")
	AB.block(Vector3.new(0.8, 0.3, 1.0), SHOE,
		AB.offset(originCF,  0.45, 0.15, 0.1), model, "ShoeR")

	-- Skirt
	AB.block(Vector3.new(2.6, 1.4, 1.6), SKIRT,
		AB.offset(originCF, 0, 2.7, 0), model, "Skirt")
	AB.block(Vector3.new(2.7, 0.2, 1.7), TRIM,
		AB.offset(originCF, 0, 2.0, 0), model, "SkirtTrim")

	-- Torso (smaller than adults)
	local torso = AB.block(Vector3.new(2.2, 2.0, 1.1), UNIFM,
		AB.offset(originCF, 0, 4.4, 0), model, "Torso")
	AB.block(Vector3.new(2.3, 0.2, 1.2), TRIM,
		AB.offset(originCF, 0, 3.4, 0), model, "BeltTrim")

	-- Arms
	AB.block(Vector3.new(0.6, 1.9, 0.6), UNIFM,
		AB.offset(originCF, -1.4, 4.4, 0.4), model, "ArmL")
	AB.block(Vector3.new(0.6, 1.9, 0.6), UNIFM,
		AB.offset(originCF,  1.4, 4.4, 0.4), model, "ArmR")
	AB.sphere(0.55, SKIN, AB.offset(originCF, -1.4, 3.4, 0.5), model, "HandL")
	AB.sphere(0.55, SKIN, AB.offset(originCF,  1.4, 3.4, 0.5), model, "HandR")

	-- Head + pigtails
	AB.sphere(1.5, SKIN, AB.offset(originCF, 0, 6.3, 0), model, "Head")
	AB.block(Vector3.new(1.6, 0.6, 1.5), HAIR,
		AB.offset(originCF, 0, 6.8, 0), model, "HairTop")
	for i, x in {-1.1, 1.1} do
		AB.sphere(0.7, HAIR, AB.offset(originCF, x, 6.0, 0), model, "Pigtail_" .. i)
		AB.block(Vector3.new(0.4, 1.2, 0.4), HAIR,
			AB.offset(originCF, x, 5.2, 0), model, "PigtailStrand_" .. i)
	end
	AB.block(Vector3.new(0.4, 0.3, 0.4), SKIRT,
		AB.offset(originCF, -1.1, 6.4, 0), model, "BowL")
	AB.block(Vector3.new(0.4, 0.3, 0.4), SKIRT,
		AB.offset(originCF,  1.1, 6.4, 0), model, "BowR")

	-- Tray held in front of her
	AB.block(Vector3.new(2.6, 0.15, 1.4), TRAY,
		AB.offset(originCF, 0, 3.2, 1.0), model, "Tray")
	AB.block(Vector3.new(2.6, 0.4, 0.15), TRAY,
		AB.offset(originCF, 0, 3.4, 1.65), model, "TrayLip")
	-- Mini cinnamon rolls on the tray
	for i = 1, 4 do
		local x = -0.9 + (i - 1) * 0.6
		AB.cylinder(0.55, 0.2, DOUGH,
			AB.offset(originCF, x, 3.35, 0.9), model, "RollDough_" .. i)
		AB.cylinder(0.4, 0.1, CINN,
			AB.offset(originCF, x, 3.45, 0.9), model, "RollCinn_" .. i)
		AB.block(Vector3.new(0.5, 0.05, 0.1), CREAM,
			AB.offset(originCF, x, 3.5, 0.9), model, "RollIcing_" .. i)
	end

	AB.billboard(torso, "Lulu", nil, 5)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
