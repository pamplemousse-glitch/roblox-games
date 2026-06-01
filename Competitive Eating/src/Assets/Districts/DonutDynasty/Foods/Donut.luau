-- Donut — pink-glazed torus approximated by a ring of spheres, dark cylinder
-- in the hole for contrast, plus colorful sprinkles on top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK       = Color3.fromRGB(255, 200, 214)
local DOUGH      = Color3.fromRGB(220, 170, 110)
local HOLE_DARK  = Color3.fromRGB(70, 45, 30)

local SPRINKLE_COLORS = {
	Color3.fromRGB(255, 80, 120),
	Color3.fromRGB(120, 200, 255),
	Color3.fromRGB(255, 220, 90),
	Color3.fromRGB(140, 230, 140),
	Color3.fromRGB(220, 120, 255),
}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Donut", parent)

	-- Base dough ring: tan spheres in a circle
	AB.circleArrange(originCF, 1.6, 12, model, function(i, cf, _)
		return AB.sphere(1.6, DOUGH, cf * CFrame.new(0, 1.2, 0), model, "Dough_" .. i)
	end)

	-- Pink glaze: slightly larger pink spheres sitting on top
	local glaze = AB.circleArrange(originCF, 1.6, 12, model, function(i, cf, _)
		return AB.sphere(1.4, PINK, cf * CFrame.new(0, 1.7, 0), model, "Glaze_" .. i)
	end)

	-- Hole shadow: short dark cylinder in the center
	AB.cylinder(
		1.2,
		0.4,
		HOLE_DARK,
		AB.offset(originCF, 0, 1.0, 0),
		model,
		"Hole"
	)

	-- Sprinkles: small colored blocks scattered around top of glaze
	for i = 1, 14 do
		local angle  = (i / 14) * math.pi * 2 + (i * 0.37)
		local radius = 1.5 + (i % 3) * 0.15
		local x      = math.cos(angle) * radius
		local z      = math.sin(angle) * radius
		local color  = SPRINKLE_COLORS[((i - 1) % #SPRINKLE_COLORS) + 1]
		AB.block(
			Vector3.new(0.18, 0.18, 0.5),
			color,
			AB.offset(originCF, x, 2.25, z, math.deg(angle)),
			model,
			"Sprinkle_" .. i
		)
	end

	-- Pivot on first glaze sphere
	AB.pivot(model, glaze[1])
	AB.weldAll(model)
	return model
end
