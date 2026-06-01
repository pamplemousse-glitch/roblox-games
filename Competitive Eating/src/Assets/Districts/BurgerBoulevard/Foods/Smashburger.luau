-- Smashburger — flat thin patty + bun. The classic.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Smashburger", parent)

	-- Bottom bun (a cylinder lying flat)
	local bottomBun = AB.cylinder(
		4.4, 0.6,
		AB.colors.bunTan,
		AB.offset(originCF, 0, 0.3, 0),
		model,
		"BottomBun"
	)

	-- Smash patty (very thin, slightly wider than usual to look "smashed")
	AB.cylinder(
		4.6, 0.25,
		AB.colors.burgerBrown,
		AB.offset(originCF, 0, 0.75, 0),
		model,
		"Patty"
	)

	-- Cheese slice (yellow square, draped melty-style)
	AB.block(
		Vector3.new(4.2, 0.1, 4.2),
		AB.colors.cheese,
		AB.offset(originCF, 0, 0.95, 0),
		model,
		"Cheese"
	)

	-- Pickles (3 small green discs peeking out)
	for i, x in {-1.4, 0, 1.4} do
		AB.cylinder(
			0.7, 0.08,
			Color3.fromRGB(140, 180, 80),
			AB.offset(originCF, x, 1.05, 0.6),
			model,
			"Pickle_" .. i
		)
	end

	-- Top bun (dome — sphere squished by being parented above)
	AB.sphere(
		4.4,
		AB.colors.bunTan,
		AB.offset(originCF, 0, 1.6, 0),
		model,
		"TopBun"
	)

	-- Sesame seeds (4 tiny dots on bun)
	for i, pos in {
		Vector3.new( 0.6, 0,  0.4),
		Vector3.new(-0.7, 0,  0.5),
		Vector3.new( 0.3, 0, -0.7),
		Vector3.new(-0.4, 0, -0.3),
	} do
		AB.sphere(
			0.25,
			Color3.fromRGB(245, 230, 200),
			AB.offset(originCF, pos.X, 2.4, pos.Z),
			model,
			"Seed_" .. i
		)
	end

	AB.pivot(model, bottomBun)
	AB.weldAll(model)
	return model
end
