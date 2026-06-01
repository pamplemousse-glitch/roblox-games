-- Pit Master with Apron — pitmaster generic pedestrian. Cream apron with
-- sauce stains, brown shirt, white hat, leather gloves, towel over shoulder.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN     = Color3.fromRGB(215, 165, 125)
local SHIRT    = Color3.fromRGB(85, 65, 50)
local PANTS    = Color3.fromRGB(55, 40, 30)
local BOOT     = Color3.fromRGB(45, 28, 18)
local APRON    = Color3.fromRGB(240, 235, 215)
local HAT      = Color3.fromRGB(240, 235, 215)
local SAUCE    = Color3.fromRGB(140, 35, 30)
local GLOVE    = Color3.fromRGB(28, 24, 22)
local TOWEL    = Color3.fromRGB(220, 60, 60)
local HAIR     = Color3.fromRGB(35, 25, 20)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PitMasterApron", parent)

	-- Legs
	AB.block(Vector3.new(1.2, 3.5, 1.2), PANTS, AB.offset(originCF, -0.7, 1.75, 0), model, "LegL")
	AB.block(Vector3.new(1.2, 3.5, 1.2), PANTS, AB.offset(originCF,  0.7, 1.75, 0), model, "LegR")
	AB.block(Vector3.new(1.4, 0.6, 1.6), BOOT, AB.offset(originCF, -0.7, 0.3, 0.1), model, "BootL")
	AB.block(Vector3.new(1.4, 0.6, 1.6), BOOT, AB.offset(originCF,  0.7, 0.3, 0.1), model, "BootR")

	-- Torso
	local torso = AB.block(Vector3.new(3.6, 4, 1.9), SHIRT, AB.offset(originCF, 0, 5.5, 0), model, "Torso")
	-- Apron
	AB.block(Vector3.new(3, 4.2, 0.25), APRON, AB.offset(originCF, 0, 5.4, 1.0), model, "Apron")
	AB.block(Vector3.new(0.3, 1.5, 0.3), APRON, AB.offset(originCF, -0.8, 7.6, 0.9), model, "ApronStrapL")
	AB.block(Vector3.new(0.3, 1.5, 0.3), APRON, AB.offset(originCF,  0.8, 7.6, 0.9), model, "ApronStrapR")
	-- Sauce stains
	for i, p in {Vector3.new(-0.6, 5.0, 1.15), Vector3.new(0.5, 4.5, 1.15), Vector3.new(0.0, 6.0, 1.15)} do
		AB.sphere(0.5, SAUCE, originCF * CFrame.new(p), model, "Sauce_" .. i)
	end

	-- Arms
	AB.block(Vector3.new(1.2, 4, 1.2), SHIRT, AB.offset(originCF, -2.5, 5.5, 0), model, "ArmL")
	AB.block(Vector3.new(1.2, 4, 1.2), SHIRT, AB.offset(originCF,  2.5, 5.5, 0), model, "ArmR")
	-- Leather gloves at hand ends
	AB.sphere(1.0, GLOVE, AB.offset(originCF, -2.5, 3.4, 0), model, "GloveL")
	AB.sphere(1.0, GLOVE, AB.offset(originCF,  2.5, 3.4, 0), model, "GloveR")

	-- Red towel draped over right shoulder
	local towel = AB.block(Vector3.new(0.5, 1.8, 1.4), TOWEL, AB.offset(originCF, 2.0, 7.0, 0), model, "Towel")
	towel.CFrame = towel.CFrame * CFrame.Angles(0, 0, math.rad(20))

	-- Head
	AB.sphere(2.2, SKIN, AB.offset(originCF, 0, 8.7, 0), model, "Head")
	-- Hair fringe (visible under hat)
	AB.block(Vector3.new(2.3, 0.3, 2.3), HAIR, AB.offset(originCF, 0, 9.4, 0), model, "Hair")
	-- Pit chef hat (puffy)
	AB.cylinder(2.4, 0.6, HAT, AB.offset(originCF, 0, 9.8, 0), model, "HatBand")
	AB.sphere(2.8, HAT, AB.offset(originCF, 0, 11, 0), model, "HatPoof")

	-- Eyes
	AB.sphere(0.22, Color3.new(0, 0, 0), AB.offset(originCF, -0.5, 8.9, 1.05), model, "EyeL")
	AB.sphere(0.22, Color3.new(0, 0, 0), AB.offset(originCF,  0.5, 8.9, 1.05), model, "EyeR")
	-- Tooth-bearing smirk
	AB.block(Vector3.new(1.4, 0.3, 0.3), Color3.new(0, 0, 0), AB.offset(originCF, 0, 8.25, 1.1), model, "Mouth")

	AB.billboard(model:FindFirstChild("Head") or torso, "Pit Master", Vector2.new(180, 36), 2.4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
