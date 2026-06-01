-- BurgerTowerLandmark — giant burger statue, 20 studs tall.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BurgerTowerLandmark", parent)

	-- Pedestal base
	local pedestal = AB.cylinder(
		16, 2,
		Color3.fromRGB(120, 120, 120),
		AB.offset(originCF, 0, 1, 0),
		model,
		"Pedestal"
	)
	pedestal.Material = Enum.Material.Concrete

	-- Pedestal plaque (front)
	AB.block(
		Vector3.new(5, 2, 0.3),
		Color3.fromRGB(176, 176, 176),
		AB.offset(originCF, 0, 1.5, 8.1),
		model,
		"Plaque"
	)

	-- The giant burger: scale ~ 5x normal
	-- Bottom bun (a wide squat cylinder)
	AB.cylinder(
		14, 2.5,
		AB.colors.bunTan,
		AB.offset(originCF, 0, 3.5, 0),
		model,
		"BottomBun"
	)

	-- Patty
	AB.cylinder(
		14.5, 2,
		AB.colors.burgerBrown,
		AB.offset(originCF, 0, 5.5, 0),
		model,
		"Patty"
	)

	-- Cheese (wider, drapes)
	AB.block(
		Vector3.new(14, 0.4, 14),
		AB.colors.cheese,
		AB.offset(originCF, 0, 6.7, 0),
		model,
		"Cheese"
	)
	-- Cheese corner drips (4 corners pointing down)
	for i, pos in {
		Vector3.new( 6.5, 0,  6.5),
		Vector3.new(-6.5, 0,  6.5),
		Vector3.new( 6.5, 0, -6.5),
		Vector3.new(-6.5, 0, -6.5),
	} do
		AB.block(
			Vector3.new(2, 1.2, 2),
			AB.colors.cheese,
			AB.offset(originCF, pos.X, 6.0, pos.Z),
			model,
			"CheeseDrip_" .. i
		)
	end

	-- Lettuce ring
	AB.cylinder(
		15, 1,
		AB.colors.lettuce,
		AB.offset(originCF, 0, 7.5, 0),
		model,
		"Lettuce"
	)

	-- Tomato slice
	AB.cylinder(
		13, 0.5,
		Color3.fromRGB(220, 60, 50),
		AB.offset(originCF, 0, 8.3, 0),
		model,
		"Tomato"
	)

	-- Top bun (huge dome)
	AB.sphere(
		15,
		AB.colors.bunTan,
		AB.offset(originCF, 0, 12, 0),
		model,
		"TopBun"
	)

	-- Giant sesame seeds on the bun (6 around the top)
	for i = 1, 6 do
		local angle = (i / 6) * 2 * math.pi
		AB.sphere(
			1.0,
			Color3.fromRGB(245, 230, 200),
			AB.offset(originCF, math.cos(angle) * 3, 17.5 + math.sin(i * 1.3) * 0.5, math.sin(angle) * 3),
			model,
			"Seed_" .. i
		)
	end

	-- Decorative flag on top (toothpick-style)
	AB.cylinder(0.3, 4, Color3.fromRGB(200, 180, 130), AB.offset(originCF, 0, 21, 0) * CFrame.Angles(0, 0, math.rad(-90)), model, "FlagPole")
	local flag = AB.block(
		Vector3.new(0.1, 1.5, 2),
		Color3.fromRGB(255, 48, 48),
		AB.offset(originCF, 0, 22, 1.2),
		model,
		"Flag"
	)
	AB.glow(flag, flag.Color, 1.5)

	AB.pivot(model, pedestal)
	AB.weldAll(model)
	return model
end
