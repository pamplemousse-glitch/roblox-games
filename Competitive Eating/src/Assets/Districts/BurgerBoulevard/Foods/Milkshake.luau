-- Milkshake — tall glass + dome of whipped cream + cherry. Diner classic.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Milkshake", parent)

	-- Glass body (transparent cylinder, slightly wider at top)
	local glass = AB.cylinder(
		2.4, 5.0,
		Color3.fromRGB(240, 240, 250),
		AB.offset(originCF, 0, 2.5, 0),
		model,
		"Glass"
	)
	glass.Material     = Enum.Material.Glass
	glass.Transparency = 0.55
	glass.Reflectance  = 0.15

	-- Milkshake liquid (strawberry pink, fills most of the glass)
	AB.cylinder(
		2.2, 4.2,
		AB.colors.strawberry,
		AB.offset(originCF, 0, 2.4, 0),
		model,
		"ShakeLiquid"
	)

	-- Glass base (footed bottom)
	AB.cylinder(
		3.0, 0.3,
		Color3.fromRGB(240, 240, 250),
		AB.offset(originCF, 0, 0.15, 0),
		model,
		"Base"
	)

	-- Whipped cream dome (creamy white sphere on top)
	AB.sphere(
		2.6,
		Color3.fromRGB(255, 245, 232),
		AB.offset(originCF, 0, 5.5, 0),
		model,
		"WhippedCream"
	)

	-- Second little dollop (whipped cream is bumpy)
	AB.sphere(
		1.4,
		Color3.fromRGB(255, 245, 232),
		AB.offset(originCF, 0.6, 6.4, 0.3),
		model,
		"WhippedBump"
	)

	-- Cherry on top
	AB.sphere(
		0.8,
		Color3.fromRGB(180, 30, 40),
		AB.offset(originCF, 0, 6.9, 0),
		model,
		"Cherry"
	)

	-- Cherry stem
	AB.cylinder(
		0.1, 0.8,
		Color3.fromRGB(80, 60, 30),
		AB.offset(originCF, 0.1, 7.4, 0) * CFrame.Angles(0, 0, math.rad(-90)),
		model,
		"Stem"
	)

	-- Straw (red & white striped — single piece for performance)
	local straw = AB.cylinder(
		0.3, 4.0,
		Color3.fromRGB(255, 48, 48),
		AB.offset(originCF, 0.8, 6.0, 0) * CFrame.Angles(0, 0, math.rad(80)),
		model,
		"Straw"
	)
	straw.CanCollide = false

	AB.pivot(model, glass)
	AB.weldAll(model)
	return model
end
