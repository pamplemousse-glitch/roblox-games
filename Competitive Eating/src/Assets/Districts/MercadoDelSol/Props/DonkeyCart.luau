-- Donkey Cart — wooden plank cart with two spoked wheels, drawn by a stylized
-- gray donkey wearing a colorful saddle blanket. Cart carries a few crates.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local WOOD_LIGHT  = Color3.fromRGB(170, 130, 80)
local WHEEL_DARK  = Color3.fromRGB(60, 40, 25)
local DONKEY_GRAY = Color3.fromRGB(130, 125, 120)
local WHITE_MUZ   = Color3.fromRGB(240, 235, 225)
local EYE_BLACK   = Color3.fromRGB(20, 18, 16)
local CRATE_TAN   = Color3.fromRGB(180, 140, 90)
local BLANK_RED   = Color3.fromRGB(180, 40, 50)
local BLANK_YEL   = Color3.fromRGB(255, 184, 52)
local BLANK_TEAL  = Color3.fromRGB(43, 140, 156)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DonkeyCart", parent)

	-- Cart bed (plank top)
	local bed = AB.block(Vector3.new(3, 0.5, 4), WOOD_LIGHT,
		AB.offset(originCF, 0, 2.5, 0), model, "CartBed")
	-- Cart frame below the bed
	AB.block(Vector3.new(2.8, 0.6, 3.6), WOOD_DARK,
		AB.offset(originCF, 0, 2, 0), model, "CartFrame")

	-- Two large wooden wheels with 4 spokes each
	for i, x in {-1.7, 1.7} do
		AB.cylinder(3, 0.3, WHEEL_DARK,
			AB.offset(originCF, x, 1.5, 0), model, "Wheel_" .. i)
		for s = 1, 4 do
			local a = (s - 1) * math.pi / 2
			AB.part({
				size  = Vector3.new(0.2, 2.6, 0.2),
				color = WOOD_LIGHT,
				cf    = AB.offset(originCF, x, 1.5, 0) * CFrame.Angles(a, math.rad(90), 0),
				name  = string.format("Spoke_%d_%d", i, s),
			}, model)
		end
		AB.sphere(0.5, WOOD_DARK,
			AB.offset(originCF, x, 1.5, 0), model, "Hub_" .. i)
	end

	-- Two cart shafts extending forward to the donkey
	AB.block(Vector3.new(0.25, 0.25, 4), WOOD_LIGHT,
		AB.offset(originCF, -0.8, 2.4, 3.5), model, "ShaftL")
	AB.block(Vector3.new(0.25, 0.25, 4), WOOD_LIGHT,
		AB.offset(originCF,  0.8, 2.4, 3.5), model, "ShaftR")

	-- Donkey torso
	AB.block(Vector3.new(2, 1.5, 3), DONKEY_GRAY,
		AB.offset(originCF, 0, 2.6, 6.5), model, "DonkeyTorso")
	-- Saddle blanket on the donkey's back (striped)
	for i, color in {BLANK_RED, BLANK_YEL, BLANK_TEAL} do
		AB.block(Vector3.new(2.1, 0.1, 0.8), color,
			AB.offset(originCF, 0, 3.4, 5.5 + (i - 1) * 0.85), model, "BlanketStripe_" .. i)
	end
	-- Head
	AB.sphere(1.4, DONKEY_GRAY,
		AB.offset(originCF, 0, 3.4, 8.4), model, "DonkeyHead")
	-- Muzzle
	AB.sphere(0.7, WHITE_MUZ,
		AB.offset(originCF, 0, 3.0, 9.1), model, "Muzzle")
	-- Eyes
	AB.sphere(0.18, EYE_BLACK, AB.offset(originCF, -0.4, 3.7, 8.9), model, "EyeL")
	AB.sphere(0.18, EYE_BLACK, AB.offset(originCF,  0.4, 3.7, 8.9), model, "EyeR")
	-- Ears (perky angled wedges)
	AB.wedge(Vector3.new(0.3, 0.9, 0.5), DONKEY_GRAY,
		AB.offset(originCF, -0.45, 4.3, 8.0) * CFrame.Angles(0, 0, math.rad(-15)),
		model, "EarL")
	AB.wedge(Vector3.new(0.3, 0.9, 0.5), DONKEY_GRAY,
		AB.offset(originCF,  0.45, 4.3, 8.0) * CFrame.Angles(0, 0, math.rad(15)),
		model, "EarR")
	-- 4 stick legs
	for i, pos in {Vector3.new(-0.7, 0, 5.4), Vector3.new(0.7, 0, 5.4),
	               Vector3.new(-0.7, 0, 7.5), Vector3.new(0.7, 0, 7.5)} do
		AB.block(Vector3.new(0.3, 1.8, 0.3), DONKEY_GRAY,
			AB.offset(originCF, pos.X, 0.9, pos.Z), model, "Leg_" .. i)
	end

	-- Cart contents: stack of 2 crates
	AB.block(Vector3.new(1.4, 1.2, 1.4), CRATE_TAN,
		AB.offset(originCF, -0.6, 3.4, -0.4), model, "CrateA")
	AB.block(Vector3.new(1.2, 1, 1.2), CRATE_TAN,
		AB.offset(originCF, 0.7, 3.3, 0.6), model, "CrateB")

	AB.pivot(model, bed)
	AB.weldAll(model)
	return model
end
