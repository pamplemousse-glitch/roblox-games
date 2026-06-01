-- FriedChickenSandwich — chicken patty + slaw + bun. Crispy and craggy.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("FriedChickenSandwich", parent)

	-- Bottom bun (potato roll style, more golden)
	local bottomBun = AB.cylinder(
		4.0, 0.55,
		Color3.fromRGB(230, 190, 130),
		AB.offset(originCF, 0, 0.28, 0),
		model,
		"BottomBun"
	)

	-- Fried chicken patty (crispy golden brown, irregular by adding crispy bits)
	AB.cylinder(
		4.5, 0.6,
		Color3.fromRGB(210, 150, 70),
		AB.offset(originCF, 0, 0.85, 0),
		model,
		"ChickenPatty"
	)

	-- Crispy crag bits (4 small bumps sticking out the side)
	for i, pos in {
		Vector3.new( 2.0, 0,  0.6),
		Vector3.new(-2.0, 0,  0.6),
		Vector3.new( 1.8, 0, -1.0),
		Vector3.new(-1.6, 0, -1.2),
	} do
		AB.sphere(
			0.7,
			Color3.fromRGB(200, 130, 50),
			AB.offset(originCF, pos.X, 0.85, pos.Z),
			model,
			"Crisp_" .. i
		)
	end

	-- Coleslaw layer (creamy white-green shreds)
	AB.cylinder(
		4.0, 0.35,
		Color3.fromRGB(220, 220, 170),
		AB.offset(originCF, 0, 1.3, 0),
		model,
		"Slaw"
	)

	-- A few green slaw bits sticking out
	for i, pos in {
		Vector3.new( 1.5, 0,  1.4),
		Vector3.new(-1.8, 0,  1.0),
		Vector3.new( 1.0, 0, -1.5),
	} do
		AB.block(
			Vector3.new(0.5, 0.15, 0.5),
			AB.colors.lettuce,
			AB.offset(originCF, pos.X, 1.4, pos.Z),
			model,
			"SlawGreen_" .. i
		)
	end

	-- Pickle slices (2 visible)
	for i, x in {-1.0, 1.0} do
		AB.cylinder(
			0.9, 0.08,
			Color3.fromRGB(140, 180, 80),
			AB.offset(originCF, x, 1.55, 1.0),
			model,
			"Pickle_" .. i
		)
	end

	-- Top bun
	AB.sphere(
		4.0,
		Color3.fromRGB(230, 190, 130),
		AB.offset(originCF, 0, 2.0, 0),
		model,
		"TopBun"
	)

	AB.pivot(model, bottomBun)
	AB.weldAll(model)
	return model
end
