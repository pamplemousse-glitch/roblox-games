-- Pizza Box Stack — tower of 6 cardboard pizza boxes ready for delivery,
-- with a checkered "TONY'S" logo on each.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CARDBOARD = Color3.fromRGB(170, 130, 80)
local DK_CARD   = Color3.fromRGB(130, 100, 65)
local LABEL_RED = Color3.fromRGB(200, 40, 40)
local LABEL_WHT = Color3.fromRGB(245, 240, 230)
local TWINE     = Color3.fromRGB(190, 165, 110)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PizzaBoxStack", parent)

	-- Stack of 6 boxes, each ~0.7 studs tall
	for i = 1, 6 do
		local y = (i - 0.5) * 0.7
		AB.block(Vector3.new(4.2, 0.65, 4.2), CARDBOARD, AB.offset(originCF, 0, y, 0), model, "Box_" .. i)
		-- Edge crease line
		AB.block(Vector3.new(4.3, 0.05, 4.3), DK_CARD, AB.offset(originCF, 0, y + 0.3, 0), model, "BoxEdge_" .. i)
		-- Checkered logo on the side
		AB.block(Vector3.new(2, 0.4, 0.1), LABEL_RED, AB.offset(originCF, 0, y, 2.15), model, "Logo_" .. i)
		-- Checker stripes (alternating white)
		for k = -1, 1, 2 do
			AB.block(Vector3.new(0.5, 0.4, 0.12), LABEL_WHT,
				AB.offset(originCF, k * 0.5, y, 2.17), model, "LogoCheck_" .. i .. "_" .. k)
		end
	end

	-- Twine wrap around stack (4 strings)
	local stackHeight = 6 * 0.7
	-- Vertical twine (front to back)
	AB.block(Vector3.new(0.05, stackHeight + 0.1, 0.05), TWINE,
		AB.offset(originCF, 0, stackHeight / 2, 2.15), model, "TwineV1")
	AB.block(Vector3.new(0.05, stackHeight + 0.1, 0.05), TWINE,
		AB.offset(originCF, 0, stackHeight / 2, -2.15), model, "TwineV2")
	-- Horizontal twine on top
	AB.block(Vector3.new(0.05, 0.05, 4.3), TWINE,
		AB.offset(originCF, 0, stackHeight + 0.05, 0), model, "TwineH1")
	AB.block(Vector3.new(4.3, 0.05, 0.05), TWINE,
		AB.offset(originCF, 0, stackHeight + 0.05, 0), model, "TwineH2")
	-- Twine bow on top
	AB.sphere(0.3, TWINE, AB.offset(originCF, 0, stackHeight + 0.3, 0), model, "TwineBow")
	AB.block(Vector3.new(0.6, 0.1, 0.1), TWINE,
		AB.offset(originCF, 0.4, stackHeight + 0.3, 0) * CFrame.Angles(0, 0, math.rad(20)), model, "BowLoop1")
	AB.block(Vector3.new(0.6, 0.1, 0.1), TWINE,
		AB.offset(originCF, -0.4, stackHeight + 0.3, 0) * CFrame.Angles(0, 0, math.rad(-20)), model, "BowLoop2")

	-- Receipt poking out of top box
	AB.block(Vector3.new(1.4, 0.8, 0.05), LABEL_WHT,
		AB.offset(originCF, 1.5, stackHeight - 0.2, 1.8) * CFrame.Angles(math.rad(-20), 0, 0),
		model, "Receipt")

	-- "DELIVERY" tag on top box (small red diamond)
	AB.block(Vector3.new(1, 1, 0.15), LABEL_RED,
		AB.offset(originCF, -1.4, stackHeight + 0.4, 1.8) * CFrame.Angles(0, 0, math.rad(45)),
		model, "DeliveryTag")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
