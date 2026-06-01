-- Tex Diggs — lean cowboy in a black hat, denim vest, and worn boots.
-- Tall, narrow build, oversized cowboy hat, brass belt buckle, kerchief.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN     = Color3.fromRGB(215, 170, 130)
local SHIRT    = Color3.fromRGB(230, 220, 195)
local VEST     = Color3.fromRGB(60, 60, 80)
local DENIM    = Color3.fromRGB(70, 90, 130)
local BOOT     = Color3.fromRGB(60, 35, 20)
local HAT      = Color3.fromRGB(35, 25, 22)
local BUCKLE   = Color3.fromRGB(220, 180, 60)
local KERCHIEF = Color3.fromRGB(160, 40, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TexDiggs", parent)

	-- Legs (denim)
	AB.block(Vector3.new(1.2, 4.5, 1.2), DENIM, AB.offset(originCF, -0.75, 2.25, 0), model, "LegL")
	AB.block(Vector3.new(1.2, 4.5, 1.2), DENIM, AB.offset(originCF,  0.75, 2.25, 0), model, "LegR")
	-- Boots
	AB.block(Vector3.new(1.4, 1.0, 1.6), BOOT, AB.offset(originCF, -0.75, 0.5, 0.1), model, "BootL")
	AB.block(Vector3.new(1.4, 1.0, 1.6), BOOT, AB.offset(originCF,  0.75, 0.5, 0.1), model, "BootR")
	-- Boot spurs
	AB.sphere(0.35, BUCKLE, AB.offset(originCF, -0.75, 0.5, -0.8), model, "SpurL")
	AB.sphere(0.35, BUCKLE, AB.offset(originCF,  0.75, 0.5, -0.8), model, "SpurR")

	-- Belt + buckle
	AB.block(Vector3.new(2.6, 0.5, 1.4), HAT, AB.offset(originCF, 0, 4.8, 0), model, "Belt")
	AB.block(Vector3.new(0.8, 0.6, 0.1), BUCKLE, AB.offset(originCF, 0, 4.8, 0.75), model, "BeltBuckle")

	-- Torso (cream shirt, then dark vest over it)
	local torso = AB.block(
		Vector3.new(3, 3.5, 1.8), SHIRT,
		AB.offset(originCF, 0, 6.5, 0),
		model, "Torso"
	)
	-- Vest panels (open in the middle, dark fabric on left/right)
	AB.block(Vector3.new(0.9, 3.5, 0.3), VEST, AB.offset(originCF, -1.0, 6.5, 0.95), model, "VestL")
	AB.block(Vector3.new(0.9, 3.5, 0.3), VEST, AB.offset(originCF,  1.0, 6.5, 0.95), model, "VestR")
	AB.block(Vector3.new(3.0, 3.5, 0.2), VEST, AB.offset(originCF, 0, 6.5, -0.95), model, "VestBack")

	-- Red kerchief at the neck
	AB.block(Vector3.new(2.2, 0.6, 2.0), KERCHIEF, AB.offset(originCF, 0, 8.4, 0), model, "Kerchief")

	-- Arms (cream shirt sleeves)
	AB.block(Vector3.new(1.0, 3.6, 1.0), SHIRT, AB.offset(originCF, -2.0, 6.5, 0), model, "ArmL")
	AB.block(Vector3.new(1.0, 3.6, 1.0), SHIRT, AB.offset(originCF,  2.0, 6.5, 0), model, "ArmR")
	AB.sphere(1.0, SKIN, AB.offset(originCF, -2.0, 4.6, 0), model, "HandL")
	AB.sphere(1.0, SKIN, AB.offset(originCF,  2.0, 4.6, 0), model, "HandR")

	-- Head (a touch narrower than the others)
	AB.sphere(2.0, SKIN, AB.offset(originCF, 0, 9.4, 0), model, "Head")
	-- Eyes
	AB.sphere(0.22, Color3.new(0, 0, 0), AB.offset(originCF, -0.45, 9.55, 0.9), model, "EyeL")
	AB.sphere(0.22, Color3.new(0, 0, 0), AB.offset(originCF,  0.45, 9.55, 0.9), model, "EyeR")
	-- Stubble (faint band on chin)
	AB.block(Vector3.new(1.4, 0.25, 0.3), Color3.fromRGB(60, 50, 45), AB.offset(originCF, 0, 8.85, 1.0), model, "Stubble")

	-- Cowboy hat: a wide brim + a tall crown, slightly tilted
	AB.cylinder(5.5, 0.25, HAT, AB.offset(originCF, 0, 10.5, 0), model, "HatBrim")
	AB.cylinder(3.0, 1.8,  HAT, AB.offset(originCF, 0, 11.6, 0), model, "HatCrown")
	-- Brim front dip
	AB.block(Vector3.new(2.5, 0.2, 0.6), HAT, AB.offset(originCF, 0, 10.45, 2.4), model, "BrimDip")
	-- Hat band
	AB.cylinder(3.05, 0.4, KERCHIEF, AB.offset(originCF, 0, 10.85, 0), model, "HatBand")

	AB.billboard(model:FindFirstChild("Head") or torso, "Tex Diggs", Vector2.new(220, 40), 3.2)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
