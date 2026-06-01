-- Cowboy with Hat — pedestrian in plaid shirt, jeans, bandana, big brown
-- cowboy hat, boot spurs.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN       = Color3.fromRGB(220, 175, 135)
local HAT_BROWN  = Color3.fromRGB(95, 65, 38)
local HAT_DARK   = Color3.fromRGB(60, 40, 22)
local PLAID_RED  = Color3.fromRGB(160, 40, 40)
local PLAID_DARK = Color3.fromRGB(110, 28, 28)
local JEANS      = Color3.fromRGB(60, 80, 130)
local BOOT       = Color3.fromRGB(95, 60, 30)
local BANDANA    = Color3.fromRGB(220, 60, 60)
local SPUR       = Color3.fromRGB(190, 145, 60)
local HAIR       = Color3.fromRGB(105, 75, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CowboyWithHat", parent)

	-- Legs (jeans)
	AB.block(Vector3.new(1.2, 3.6, 1.2), JEANS, AB.offset(originCF, -0.7, 1.8, 0), model, "LegL")
	AB.block(Vector3.new(1.2, 3.6, 1.2), JEANS, AB.offset(originCF,  0.7, 1.8, 0), model, "LegR")
	-- Boots
	AB.block(Vector3.new(1.4, 0.8, 1.7), BOOT, AB.offset(originCF, -0.7, 0.4, 0.1), model, "BootL")
	AB.block(Vector3.new(1.4, 0.8, 1.7), BOOT, AB.offset(originCF,  0.7, 0.4, 0.1), model, "BootR")
	-- Spurs (gold star wheels at boot heels)
	AB.sphere(0.4, SPUR, AB.offset(originCF, -0.7, 0.4, -0.7), model, "SpurL")
	AB.sphere(0.4, SPUR, AB.offset(originCF,  0.7, 0.4, -0.7), model, "SpurR")

	-- Torso (plaid pattern via alternating stripes)
	local torso = AB.block(Vector3.new(3.4, 4, 1.8), PLAID_RED, AB.offset(originCF, 0, 5.6, 0), model, "Torso")
	-- Plaid stripes
	for i, y in {4.2, 5.0, 5.8, 6.6} do
		AB.block(Vector3.new(3.5, 0.2, 1.9), PLAID_DARK, AB.offset(originCF, 0, y, 0), model, "PlaidH_" .. i)
	end
	for i, x in {-1.0, 0, 1.0} do
		AB.block(Vector3.new(0.2, 4.1, 1.9), PLAID_DARK, AB.offset(originCF, x, 5.6, 0), model, "PlaidV_" .. i)
	end
	-- Bandana around neck
	AB.block(Vector3.new(2.2, 0.6, 2), BANDANA, AB.offset(originCF, 0, 7.8, 0), model, "Bandana")
	-- Bandana tail
	AB.block(Vector3.new(0.6, 1.4, 0.3), BANDANA, AB.offset(originCF, 0, 7.2, -1.0), model, "BandanaTail")

	-- Arms
	AB.block(Vector3.new(1.1, 3.8, 1.1), PLAID_RED, AB.offset(originCF, -2.3, 5.6, 0), model, "ArmL")
	AB.block(Vector3.new(1.1, 3.8, 1.1), PLAID_RED, AB.offset(originCF,  2.3, 5.6, 0), model, "ArmR")
	-- Hands
	AB.sphere(0.85, SKIN, AB.offset(originCF, -2.3, 3.6, 0), model, "HandL")
	AB.sphere(0.85, SKIN, AB.offset(originCF,  2.3, 3.6, 0), model, "HandR")
	-- Hooked thumb in belt (tilt one arm)
	local belt = AB.block(Vector3.new(3.5, 0.5, 1.9), HAT_DARK, AB.offset(originCF, 0, 3.7, 0), model, "Belt")
	AB.block(Vector3.new(0.8, 0.7, 0.2), SPUR, AB.offset(originCF, 0, 3.7, 0.95), model, "BeltBuckle")

	-- Head
	AB.sphere(2.2, SKIN, AB.offset(originCF, 0, 8.7, 0), model, "Head")
	-- Hair
	AB.block(Vector3.new(2.3, 0.3, 2.3), HAIR, AB.offset(originCF, 0, 9.4, 0), model, "Hair")

	-- Cowboy hat (wide flat brim + crown)
	AB.cylinder(5.8, 0.3, HAT_BROWN, AB.offset(originCF, 0, 9.9, 0), model, "HatBrim")
	AB.cylinder(2.8, 1.6, HAT_BROWN, AB.offset(originCF, 0, 10.9, 0), model, "HatCrown")
	-- Hatband
	AB.cylinder(2.85, 0.3, HAT_DARK, AB.offset(originCF, 0, 10.3, 0), model, "HatBand")
	-- Crown pinch (top dent)
	AB.block(Vector3.new(0.5, 0.3, 2.8), HAT_DARK, AB.offset(originCF, 0, 11.8, 0), model, "HatCrease")

	-- Eyes
	AB.sphere(0.22, Color3.new(0, 0, 0), AB.offset(originCF, -0.5, 8.9, 1.05), model, "EyeL")
	AB.sphere(0.22, Color3.new(0, 0, 0), AB.offset(originCF,  0.5, 8.9, 1.05), model, "EyeR")
	-- Mustache (handlebar)
	AB.block(Vector3.new(2.0, 0.3, 0.3), HAIR, AB.offset(originCF, 0, 8.25, 1.1), model, "Mustache")

	AB.billboard(model:FindFirstChild("Head") or torso, "Cowboy", Vector2.new(160, 32), 3.0)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
