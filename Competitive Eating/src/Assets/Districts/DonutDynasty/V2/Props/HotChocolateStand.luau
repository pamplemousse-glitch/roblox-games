-- HotChocolateStand — small wheeled vendor cart serving hot chocolate.
-- Brown body, cream awning, gold trim, steaming mug on top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local CREAM  = Color3.fromRGB(255, 240, 220)
local BROWN  = Color3.fromRGB(92,  57,  36)
local DARK   = Color3.fromRGB(60,  35,  22)
local GOLD   = Color3.fromRGB(212, 168, 82)
local MINT   = Color3.fromRGB(180, 230, 200)
local NEONPK = Color3.fromRGB(255, 110, 170)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("HotChocolateStand", parent)

	-- Cart body
	local body = AB.block(Vector3.new(6, 4, 3.5), BROWN,
		AB.offset(originCF, 0, 2.5, 0), model, "CartBody")
	-- Gold trim
	AB.block(Vector3.new(6.2, 0.4, 3.7), GOLD, AB.offset(originCF, 0, 4.7, 0), model, "TopTrim")
	AB.block(Vector3.new(6.2, 0.4, 3.7), GOLD, AB.offset(originCF, 0, 0.7, 0), model, "BottomTrim")

	-- Front counter
	AB.block(Vector3.new(6, 0.4, 1.4), CREAM,
		AB.offset(originCF, 0, 5, 1.8), model, "Counter")

	-- Striped awning
	AB.block(Vector3.new(7, 0.4, 4), BROWN,
		AB.offset(originCF, 0, 8.5, 0), model, "AwningBase")
	for i, x in {-2.8, -0.9, 0.9, 2.8} do
		AB.block(Vector3.new(1.7, 0.5, 4), CREAM,
			AB.offset(originCF, x, 8.6, 0), model, "AwningStripe_" .. i)
	end
	-- Awning supports
	for i, x in {-3, 3} do
		AB.block(Vector3.new(0.4, 4, 0.4), GOLD,
			AB.offset(originCF, x, 6.5, -1.5), model, "AwningPost_" .. i)
		AB.block(Vector3.new(0.4, 4, 0.4), GOLD,
			AB.offset(originCF, x, 6.5, 1.5), model, "AwningPostF_" .. i)
	end

	-- Wheels
	for i, z in {-1.4, 1.4} do
		AB.cylinder(2, 0.5, DARK,
			AB.offset(originCF, -2.5, 1, z), model, "WheelL_" .. i)
		AB.cylinder(2, 0.5, DARK,
			AB.offset(originCF, 2.5, 1, z), model, "WheelR_" .. i)
	end

	-- Mug of hot chocolate on counter
	AB.cylinder(1.4, 1.4, CREAM, AB.offset(originCF, -1.5, 5.9, 1.8), model, "Mug")
	AB.cylinder(1.45, 0.2, BROWN, AB.offset(originCF, -1.5, 6.6, 1.8), model, "MugSurface")
	-- Whipped cream dollop
	AB.sphere(0.9, CREAM, AB.offset(originCF, -1.5, 7.1, 1.8), model, "Whip")
	-- Cherry on top
	AB.sphere(0.4, NEONPK, AB.offset(originCF, -1.5, 7.6, 1.8), model, "Cherry")

	-- Steam puffs rising
	AB.sphere(0.7, CREAM, AB.offset(originCF, -1.5, 8.4, 1.8), model, "Steam1").Transparency = 0.4
	AB.sphere(0.5, CREAM, AB.offset(originCF, -1.2, 9.2, 1.8), model, "Steam2").Transparency = 0.5

	-- Signboard on front
	local sign = AB.block(Vector3.new(3, 1, 0.3), NEONPK,
		AB.offset(originCF, 1.5, 5.6, 2.6), model, "Sign")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 1.5)

	-- Mint marshmallow garnish stacked on counter
	AB.cylinder(0.7, 0.5, CREAM, AB.offset(originCF, 1.8, 5.5, 1.8), model, "Marsh1")
	AB.cylinder(0.7, 0.5, MINT, AB.offset(originCF, 1.8, 6, 1.8), model, "Marsh2")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
