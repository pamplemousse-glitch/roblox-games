-- Glaze Fountain — multi-tier white fountain with pink glaze pooling and
-- overflowing from each basin.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STONE = Color3.fromRGB(245, 235, 225)
local GLAZE = Color3.fromRGB(255, 200, 214)
local GOLD  = Color3.fromRGB(212, 168, 82)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GlazeFountain", parent)

	-- Plaza base (octagonal-ish, just a wide low cylinder)
	AB.cylinder(24, 0.6, STONE,
		AB.offset(originCF, 0, 0.3, 0), model, "Plaza")

	-- Tier 1 (largest basin)
	AB.cylinder(18, 1.2, STONE,
		AB.offset(originCF, 0, 1.2, 0), model, "Basin1")
	local glaze1 = AB.cylinder(16, 0.3, GLAZE,
		AB.offset(originCF, 0, 1.95, 0), model, "Glaze1")
	glaze1.Material = Enum.Material.Glass

	-- Glaze drips off tier 1
	for i = 1, 8 do
		local angle  = (i / 8) * math.pi * 2
		local x      = math.cos(angle) * 9
		local z      = math.sin(angle) * 9
		AB.block(Vector3.new(0.6, 1.0, 0.6), GLAZE,
			AB.offset(originCF, x, 1.5, z), model, "Drip1_" .. i)
	end

	-- Column 1
	AB.cylinder(4, 4, STONE,
		AB.offset(originCF, 0, 4, 0), model, "Col1")

	-- Tier 2
	AB.cylinder(11, 1.0, STONE,
		AB.offset(originCF, 0, 6.5, 0), model, "Basin2")
	local glaze2 = AB.cylinder(10, 0.3, GLAZE,
		AB.offset(originCF, 0, 7.1, 0), model, "Glaze2")
	glaze2.Material = Enum.Material.Glass

	for i = 1, 6 do
		local angle = (i / 6) * math.pi * 2
		local x     = math.cos(angle) * 5.5
		local z     = math.sin(angle) * 5.5
		AB.block(Vector3.new(0.5, 0.9, 0.5), GLAZE,
			AB.offset(originCF, x, 6.7, z), model, "Drip2_" .. i)
	end

	-- Column 2
	AB.cylinder(2.4, 3, STONE,
		AB.offset(originCF, 0, 9, 0), model, "Col2")

	-- Top basin
	AB.cylinder(5, 0.8, STONE,
		AB.offset(originCF, 0, 10.8, 0), model, "Basin3")
	local glaze3 = AB.cylinder(4.4, 0.3, GLAZE,
		AB.offset(originCF, 0, 11.2, 0), model, "Glaze3")
	glaze3.Material = Enum.Material.Glass

	-- Crowning golden donut
	AB.cylinder(3, 0.8, GOLD,
		AB.offset(originCF, 0, 12.0, 0), model, "Crown")
	AB.cylinder(1.0, 0.9, STONE,
		AB.offset(originCF, 0, 12.0, 0), model, "CrownHole")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
