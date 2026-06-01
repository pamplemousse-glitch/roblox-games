-- Pizza Parlor — a small Italian-American storefront.
-- Red awning, brick walls, glowing "PIZZA" neon sign.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PizzaParlor", parent)

	-- Foundation
	AB.block(
		Vector3.new(30, 0.5, 24),
		Color3.fromRGB(100, 100, 100),
		AB.offset(originCF, 0, 0.25, 0),
		model,
		"Foundation"
	)

	-- Back wall (brick red)
	AB.block(
		Vector3.new(30, 16, 1),
		Color3.fromRGB(150, 60, 50),
		AB.offset(originCF, 0, 8, -11.5),
		model,
		"BackWall"
	)

	-- Side walls
	AB.block(
		Vector3.new(1, 16, 24),
		Color3.fromRGB(150, 60, 50),
		AB.offset(originCF, -14.5, 8, 0),
		model,
		"LeftWall"
	)
	AB.block(
		Vector3.new(1, 16, 24),
		Color3.fromRGB(150, 60, 50),
		AB.offset(originCF, 14.5, 8, 0),
		model,
		"RightWall"
	)

	-- Front wall with doorway gap
	AB.block(
		Vector3.new(10, 16, 1),
		Color3.fromRGB(150, 60, 50),
		AB.offset(originCF, -10, 8, 11.5),
		model,
		"FrontLeft"
	)
	AB.block(
		Vector3.new(10, 16, 1),
		Color3.fromRGB(150, 60, 50),
		AB.offset(originCF, 10, 8, 11.5),
		model,
		"FrontRight"
	)
	-- Header above doorway
	AB.block(
		Vector3.new(10, 4, 1),
		Color3.fromRGB(150, 60, 50),
		AB.offset(originCF, 0, 14, 11.5),
		model,
		"FrontHeader"
	)

	-- Red awning above doorway
	local awning = AB.block(
		Vector3.new(12, 0.6, 4),
		AB.colors.pizzaRed,
		AB.offset(originCF, 0, 11.5, 13.5),
		model,
		"Awning"
	)

	-- Awning stripes (white)
	for i, x in {-4, -1.3, 1.3, 4} do
		AB.block(
			Vector3.new(1.2, 0.7, 4),
			Color3.fromRGB(255, 255, 240),
			AB.offset(originCF, x, 11.5, 13.5),
			model,
			"AwningStripe_" .. i
		)
	end

	-- "PIZZA" neon sign (a glowing bar above the awning)
	local sign = AB.block(
		Vector3.new(14, 2, 0.5),
		Color3.fromRGB(255, 60, 40),
		AB.offset(originCF, 0, 14, 12),
		model,
		"NeonSign"
	)
	AB.neon(sign)
	AB.glow(sign, sign.Color, 2.5)

	-- Roof (sloped)
	AB.block(
		Vector3.new(32, 1, 26),
		Color3.fromRGB(90, 70, 50),
		AB.offset(originCF, 0, 16.5, 0),
		model,
		"Roof"
	)

	-- Chimney
	AB.block(
		Vector3.new(2.5, 4, 2.5),
		Color3.fromRGB(140, 130, 120),
		AB.offset(originCF, 8, 19, -6),
		model,
		"Chimney"
	)

	-- Foundation as primary
	AB.pivot(model)
	AB.weldAll(model)
	return model
end
