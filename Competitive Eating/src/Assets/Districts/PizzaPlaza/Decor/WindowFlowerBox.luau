-- Window Flower Box — dark wood box with red geraniums and trailing ivy.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DK_WD  = Color3.fromRGB(80, 50, 30)
local SOIL   = Color3.fromRGB(70, 45, 25)
local GERAN  = Color3.fromRGB(220, 60, 80)
local LEAF   = Color3.fromRGB(80, 140, 60)
local IVY    = Color3.fromRGB(110, 140, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WindowFlowerBox", parent)

	-- Box
	AB.block(Vector3.new(5, 1, 1.5), DK_WD, AB.offset(originCF, 0, 0.5, 0), model, "Box")
	AB.block(Vector3.new(5.2, 0.15, 1.6), Color3.fromRGB(60, 40, 25),
		AB.offset(originCF, 0, 1.05, 0), model, "Rim")
	-- Mount brackets underneath
	for i, sx in {-1.5, 1.5} do
		AB.block(Vector3.new(0.3, 0.5, 0.6), Color3.fromRGB(50, 50, 55),
			AB.offset(originCF, sx, 0, -0.5), model, "Bracket_" .. i)
	end

	-- Soil top
	AB.block(Vector3.new(4.6, 0.15, 1.2), SOIL, AB.offset(originCF, 0, 1.1, 0), model, "Soil")

	-- 5 geranium blooms
	for i = 1, 5 do
		local x = -2 + (i - 1) * 1
		AB.sphere(0.55, GERAN, AB.offset(originCF, x, 1.7, 0), model, "Geranium_" .. i)
		-- Smaller cluster blossoms around it
		AB.sphere(0.3, GERAN, AB.offset(originCF, x + 0.3, 1.5, 0.3), model, "GerBud1_" .. i)
		AB.sphere(0.3, GERAN, AB.offset(originCF, x - 0.3, 1.5, -0.3), model, "GerBud2_" .. i)
		-- Stem
		AB.cylinder(0.1, 1, LEAF, AB.offset(originCF, x, 1.4, 0), model, "Stem_" .. i)
	end

	-- Trailing ivy (spillover down front)
	for i = 1, 4 do
		local x = -1.5 + i * 0.8
		AB.cylinder(0.1, 2, IVY,
			AB.offset(originCF, x, 0, 0.9) * CFrame.Angles(math.rad(-20), 0, 0), model, "IvyVine_" .. i)
		for k = 1, 3 do
			AB.sphere(0.25, IVY,
				AB.offset(originCF, x, -k * 0.5 + 0.3, 0.85), model, "IvyLeaf_" .. i .. "_" .. k)
		end
	end

	-- Big base leaves
	AB.sphere(0.5, LEAF, AB.offset(originCF, -1, 1.4, 0.5), model, "BaseLeaf1")
	AB.sphere(0.5, LEAF, AB.offset(originCF,  1, 1.4, 0.5), model, "BaseLeaf2")
	AB.sphere(0.5, LEAF, AB.offset(originCF, 0, 1.4, -0.5), model, "BaseLeaf3")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
