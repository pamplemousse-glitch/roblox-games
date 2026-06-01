-- Farmer with Pitchfork — overalls, plaid shirt under, boots, straw hat,
-- holding a pitchfork tilted at the shoulder.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN     = Color3.fromRGB(220, 175, 135)
local OVERALL  = Color3.fromRGB(70, 95, 145)
local OVER_D   = Color3.fromRGB(50, 70, 105)
local SHIRT_R  = Color3.fromRGB(180, 50, 40)
local STRAW    = Color3.fromRGB(232, 200, 112)
local BAND_R   = Color3.fromRGB(170, 40, 40)
local BOOT     = Color3.fromRGB(60, 38, 25)
local HAIR     = Color3.fromRGB(150, 110, 60)
local STEEL    = Color3.fromRGB(135, 135, 140)
local DARK_WOOD= Color3.fromRGB(95, 65, 38)
local BUTTON   = Color3.fromRGB(220, 180, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("FarmerWithPitchfork", parent)

	-- Legs (overalls)
	AB.block(Vector3.new(1.3, 3.6, 1.3), OVERALL, AB.offset(originCF, -0.75, 1.8, 0), model, "LegL")
	AB.block(Vector3.new(1.3, 3.6, 1.3), OVERALL, AB.offset(originCF,  0.75, 1.8, 0), model, "LegR")
	-- Boots
	AB.block(Vector3.new(1.5, 0.7, 1.7), BOOT, AB.offset(originCF, -0.75, 0.35, 0.1), model, "BootL")
	AB.block(Vector3.new(1.5, 0.7, 1.7), BOOT, AB.offset(originCF,  0.75, 0.35, 0.1), model, "BootR")

	-- Plaid shirt sleeves (visible at arms)
	AB.block(Vector3.new(1.2, 2.4, 1.2), SHIRT_R, AB.offset(originCF, -2.3, 6.5, 0), model, "ArmL_Sleeve")
	AB.block(Vector3.new(1.2, 2.4, 1.2), SHIRT_R, AB.offset(originCF,  2.3, 6.5, 0), model, "ArmR_Sleeve")
	-- Arm exposed parts (skin) at forearm
	AB.block(Vector3.new(1.1, 1.6, 1.1), SKIN, AB.offset(originCF, -2.3, 4.5, 0), model, "ArmL_Skin")
	-- Right arm raised to shoulder (holding pitchfork)
	local armRSkin = AB.block(Vector3.new(1.1, 1.6, 1.1), SKIN, AB.offset(originCF, 2.3, 4.5, 0), model, "ArmR_Skin")
	armRSkin.CFrame = armRSkin.CFrame * CFrame.Angles(0, 0, math.rad(-15))
	AB.sphere(0.9, SKIN, AB.offset(originCF, -2.3, 3.5, 0), model, "HandL")
	AB.sphere(0.9, SKIN, AB.offset(originCF, 2.4, 3.6, 0), model, "HandR")

	-- Torso (overalls bib + shirt collar)
	-- Shirt under overall
	AB.block(Vector3.new(3.2, 1.6, 1.7), SHIRT_R, AB.offset(originCF, 0, 7.3, 0), model, "ShirtUpper")
	-- Overall bib
	local torso = AB.block(Vector3.new(3.4, 4, 1.9), OVERALL, AB.offset(originCF, 0, 5.3, 0), model, "OverallTorso")
	-- Bib stripes (vertical lighter line down center)
	AB.block(Vector3.new(0.2, 4, 1.95), OVER_D, AB.offset(originCF, -1.4, 5.3, 0), model, "BibSeamL")
	AB.block(Vector3.new(0.2, 4, 1.95), OVER_D, AB.offset(originCF,  1.4, 5.3, 0), model, "BibSeamR")
	-- Straps over shoulders
	AB.block(Vector3.new(0.6, 2.2, 0.4), OVERALL, AB.offset(originCF, -1.0, 7.6, 0.8), model, "StrapL")
	AB.block(Vector3.new(0.6, 2.2, 0.4), OVERALL, AB.offset(originCF,  1.0, 7.6, 0.8), model, "StrapR")
	-- Buttons on straps
	AB.sphere(0.3, BUTTON, AB.offset(originCF, -1.0, 6.5, 1.0), model, "ButtonL")
	AB.sphere(0.3, BUTTON, AB.offset(originCF,  1.0, 6.5, 1.0), model, "ButtonR")

	-- Head
	AB.sphere(2.2, SKIN, AB.offset(originCF, 0, 8.8, 0), model, "Head")
	-- Hair
	AB.block(Vector3.new(2.3, 0.3, 2.3), HAIR, AB.offset(originCF, 0, 9.5, 0), model, "Hair")
	-- Straw hat (wide brim)
	AB.cylinder(5.0, 0.3, STRAW, AB.offset(originCF, 0, 9.9, 0), model, "HatBrim")
	AB.cylinder(2.6, 1.0, STRAW, AB.offset(originCF, 0, 10.5, 0), model, "HatCrown")
	AB.cylinder(2.65, 0.3, BAND_R, AB.offset(originCF, 0, 10.1, 0), model, "HatBand")

	-- Eyes (squinting — small)
	AB.block(Vector3.new(0.35, 0.1, 0.1), Color3.new(0, 0, 0), AB.offset(originCF, -0.5, 9.0, 1.05), model, "EyeL")
	AB.block(Vector3.new(0.35, 0.1, 0.1), Color3.new(0, 0, 0), AB.offset(originCF,  0.5, 9.0, 1.05), model, "EyeR")
	-- Mouth (chewing a piece of straw — thin tan stripe)
	AB.block(Vector3.new(0.15, 0.15, 1.8), STRAW, AB.offset(originCF, 0.5, 8.3, 1.4), model, "Straw")

	-- Pitchfork (long handle held diagonally over shoulder)
	local pfHandle = AB.block(Vector3.new(0.4, 9, 0.4), DARK_WOOD, AB.offset(originCF, 2.6, 7.5, -1), model, "PFHandle")
	pfHandle.CFrame = pfHandle.CFrame * CFrame.Angles(math.rad(-35), 0, math.rad(-15))
	-- Pitchfork head (3 tines at top end)
	for i, x in {-0.45, 0, 0.45} do
		local prong = AB.block(Vector3.new(0.18, 1.8, 0.18), STEEL, AB.offset(originCF, 3.5 + x, 11.5, -3.4), model, "Prong_" .. i)
		prong.CFrame = prong.CFrame * CFrame.Angles(math.rad(-35), 0, math.rad(-15))
	end
	-- Pitchfork head socket
	AB.block(Vector3.new(1.4, 0.6, 0.5), STEEL, AB.offset(originCF, 3.0, 10.3, -2.5), model, "Socket")

	AB.billboard(model:FindFirstChild("Head") or torso, "Farmer", Vector2.new(160, 32), 3.2)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
