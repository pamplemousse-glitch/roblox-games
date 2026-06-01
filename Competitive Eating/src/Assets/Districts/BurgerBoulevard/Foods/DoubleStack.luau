-- DoubleStack — two patties + double bun stack. A monster of a burger.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DoubleStack", parent)

	-- Bottom bun
	local bottomBun = AB.cylinder(
		4.2, 0.7,
		AB.colors.bunTan,
		AB.offset(originCF, 0, 0.35, 0),
		model,
		"BottomBun"
	)

	-- Patty 1
	AB.cylinder(
		4.4, 0.5,
		AB.colors.burgerBrown,
		AB.offset(originCF, 0, 0.95, 0),
		model,
		"Patty_1"
	)

	-- Cheese 1
	AB.block(
		Vector3.new(4.0, 0.1, 4.0),
		AB.colors.cheese,
		AB.offset(originCF, 0, 1.25, 0),
		model,
		"Cheese_1"
	)

	-- Middle bun (the legendary "club bun" in the middle)
	AB.cylinder(
		4.2, 0.5,
		AB.colors.bunTan,
		AB.offset(originCF, 0, 1.6, 0),
		model,
		"MidBun"
	)

	-- Patty 2
	AB.cylinder(
		4.4, 0.5,
		AB.colors.burgerBrown,
		AB.offset(originCF, 0, 2.1, 0),
		model,
		"Patty_2"
	)

	-- Cheese 2
	AB.block(
		Vector3.new(4.0, 0.1, 4.0),
		AB.colors.cheese,
		AB.offset(originCF, 0, 2.4, 0),
		model,
		"Cheese_2"
	)

	-- Lettuce (a green wavy disk)
	AB.cylinder(
		4.5, 0.2,
		AB.colors.lettuce,
		AB.offset(originCF, 0, 2.6, 0),
		model,
		"Lettuce"
	)

	-- Top bun
	AB.sphere(
		4.3,
		AB.colors.bunTan,
		AB.offset(originCF, 0, 3.3, 0),
		model,
		"TopBun"
	)

	-- Toothpick (a skewer marking it as "the double")
	AB.cylinder(
		0.12, 1.6,
		Color3.fromRGB(220, 200, 150),
		AB.offset(originCF, 0.8, 4.0, 0.5) * CFrame.Angles(0, 0, math.rad(-90)),
		model,
		"Toothpick"
	)

	AB.pivot(model, bottomBun)
	AB.weldAll(model)
	return model
end
