-- Cinnamon Roll — a spiral disk built from concentric cylinders, alternating
-- cinnamon-brown dough and cream icing rings.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DOUGH     = Color3.fromRGB(180, 120, 70)
local CINNAMON  = Color3.fromRGB(110, 60, 30)
local CREAM     = Color3.fromRGB(255, 240, 220)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CinnamonRoll", parent)

	-- Base dough disk (full diameter)
	local base = AB.cylinder(
		5.0,
		1.0,
		DOUGH,
		AB.offset(originCF, 0, 0.5, 0),
		model,
		"Base"
	)

	-- Concentric rings of cinnamon to suggest the spiral
	local rings = {
		{ d = 4.0, color = CINNAMON, y = 1.05 },
		{ d = 3.0, color = DOUGH,    y = 1.10 },
		{ d = 2.0, color = CINNAMON, y = 1.15 },
		{ d = 1.0, color = DOUGH,    y = 1.20 },
	}
	for i, ring in rings do
		AB.cylinder(
			ring.d,
			0.2,
			ring.color,
			AB.offset(originCF, 0, ring.y, 0),
			model,
			"Ring_" .. i
		)
	end

	-- Cream icing drizzle: 4 thin blocks crossing the top in a tic-tac-toe pattern
	for i = 1, 3 do
		local z = -1.5 + (i - 1) * 1.5
		AB.block(
			Vector3.new(4.5, 0.15, 0.4),
			CREAM,
			AB.offset(originCF, 0, 1.35, z),
			model,
			"Icing_H_" .. i
		)
	end
	for i = 1, 3 do
		local x = -1.5 + (i - 1) * 1.5
		AB.block(
			Vector3.new(0.4, 0.15, 4.5),
			CREAM,
			AB.offset(originCF, x, 1.35, 0),
			model,
			"Icing_V_" .. i
		)
	end

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
