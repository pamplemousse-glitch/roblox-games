-- Pizza Box Tower — taller stack than PizzaBoxStack (10 boxes high) for
-- a big delivery push. Multi-color labels for variety.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CARD = Color3.fromRGB(170, 130, 80)
local DK_C = Color3.fromRGB(130, 100, 65)
local RED  = Color3.fromRGB(200, 40, 40)
local GRN  = Color3.fromRGB(80, 140, 60)
local WHT  = Color3.fromRGB(245, 240, 230)
local TWINE = Color3.fromRGB(190, 165, 110)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PizzaBoxTower", parent)

	for i = 1, 10 do
		local y = (i - 0.5) * 0.6
		AB.block(Vector3.new(3.6, 0.55, 3.6), CARD, AB.offset(originCF, 0, y, 0), model, "Box_" .. i)
		AB.block(Vector3.new(3.7, 0.05, 3.7), DK_C, AB.offset(originCF, 0, y + 0.25, 0), model, "Edge_" .. i)
		-- Side label (rotates color)
		local c = (i % 3 == 0) and GRN or (i % 3 == 1) and RED or WHT
		AB.block(Vector3.new(1.8, 0.35, 0.1), c, AB.offset(originCF, 0, y, 1.85), model, "Label_" .. i)
	end

	-- Twine around tower
	AB.block(Vector3.new(0.05, 6, 0.05), TWINE, AB.offset(originCF, 0, 3, 1.85), model, "TwineV")
	AB.block(Vector3.new(3.7, 0.05, 0.05), TWINE, AB.offset(originCF, 0, 6.05, 0), model, "TwineHTop")
	AB.block(Vector3.new(0.05, 0.05, 3.7), TWINE, AB.offset(originCF, 0, 6.05, 0), model, "TwineHTop2")
	AB.sphere(0.3, TWINE, AB.offset(originCF, 0, 6.3, 0), model, "Bow")

	-- Lopsided top box (slightly off)
	AB.block(Vector3.new(3.6, 0.55, 3.6), CARD,
		AB.offset(originCF, 0.4, 6.5, -0.2) * CFrame.Angles(0, math.rad(15), 0),
		model, "TopOff")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
