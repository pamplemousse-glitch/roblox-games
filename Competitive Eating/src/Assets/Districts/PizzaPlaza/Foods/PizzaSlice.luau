-- Pizza Slice — a single triangular slice with red sauce + yellow cheese +
-- pepperoni dots. Built from a WedgePart base + decoration layers.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PizzaSlice", parent)

	-- Crust (the wedge)
	local crust = AB.wedge(
		Vector3.new(4, 0.4, 6),
		AB.colors.pizzaCrust,
		AB.offset(originCF, 0, 0.2, 0),
		model,
		"Crust"
	)

	-- Sauce layer (slightly smaller wedge sitting on top)
	local sauce = AB.wedge(
		Vector3.new(3.6, 0.05, 5.6),
		AB.colors.pizzaRed,
		AB.offset(originCF, 0, 0.45, 0),
		model,
		"Sauce"
	)

	-- Cheese layer (yellow, even smaller, slightly transparent for melt look)
	local cheese = AB.part({
		size         = Vector3.new(3.4, 0.05, 5.4),
		color        = AB.colors.cheese,
		cf           = AB.offset(originCF, 0, 0.5, 0),
		transparency = 0.05,
		name         = "Cheese",
	}, model)

	-- Pepperoni: 4 red dots in a diamond pattern
	for i, offset in {
		Vector3.new(0,  0,  2),
		Vector3.new(0,  0, -2),
		Vector3.new( 1, 0, 0),
		Vector3.new(-1, 0, 0),
	} do
		AB.cylinder(
			0.9,
			0.1,
			Color3.fromRGB(160, 30, 30),
			AB.offset(originCF, offset.X, 0.6, offset.Z),
			model,
			"Pepperoni_" .. i
		)
	end

	AB.pivot(model, crust)
	AB.weldAll(model)
	return model
end
