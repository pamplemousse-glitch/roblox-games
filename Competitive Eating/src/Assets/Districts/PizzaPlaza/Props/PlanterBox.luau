-- Planter Box — wooden raised planter with basil, rosemary, oregano sprigs.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WD        = Color3.fromRGB(110, 75, 45)
local DK_WD     = Color3.fromRGB(80, 50, 30)
local SOIL      = Color3.fromRGB(70, 45, 25)
local BASIL     = Color3.fromRGB(80, 140, 60)
local ROSE_GRN  = Color3.fromRGB(110, 130, 80)
local ORG_LEAF  = Color3.fromRGB(120, 160, 90)
local FLOWER    = Color3.fromRGB(220, 170, 220)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PlanterBox", parent)

	-- Box walls (slatted look)
	AB.block(Vector3.new(7, 2, 3), WD, AB.offset(originCF, 0, 1, 0), model, "BoxBody")
	-- Top slats (vertical wood planks)
	for i = -3, 3 do
		AB.block(Vector3.new(0.2, 2.2, 3.2), DK_WD,
			AB.offset(originCF, i * 1, 1, 0), model, "Slat_" .. (i + 4))
	end
	-- Top rim
	AB.block(Vector3.new(7.4, 0.3, 3.4), DK_WD, AB.offset(originCF, 0, 2.15, 0), model, "Rim")
	-- Bottom legs
	for i, sx in {-1, 1} do
		for j, sz in {-1, 1} do
			AB.block(Vector3.new(0.5, 0.5, 0.5), DK_WD,
				AB.offset(originCF, sx * 3, 0.25, sz * 1.3), model, "Leg_" .. i .. j)
		end
	end

	-- Soil top
	AB.block(Vector3.new(6.5, 0.3, 2.7), SOIL, AB.offset(originCF, 0, 2.25, 0), model, "Soil")

	-- Basil clump (mound of green spheres)
	for i = 1, 6 do
		AB.sphere(0.6 + math.random() * 0.2, BASIL,
			AB.offset(originCF, -2 + math.random() * 0.5, 2.7 + math.random() * 0.2, math.random() - 0.5), model, "Basil_" .. i)
	end

	-- Rosemary (vertical sprigs)
	for i = 1, 4 do
		AB.cylinder(0.18, 1.5, ROSE_GRN,
			AB.offset(originCF, 0 + (i - 2) * 0.3, 3.1, 0), model, "RoseSprig_" .. i)
		-- Tiny leaves on the sprig
		for k = 1, 3 do
			AB.sphere(0.15, ROSE_GRN,
				AB.offset(originCF, (i - 2) * 0.3, 2.7 + k * 0.4, 0), model, "RoseLeaf_" .. i .. "_" .. k)
		end
	end

	-- Oregano (low spreading clump on right)
	for i = 1, 6 do
		AB.sphere(0.4 + math.random() * 0.15, ORG_LEAF,
			AB.offset(originCF, 2 + math.random() * 0.7, 2.5 + math.random() * 0.15, math.random() - 0.5), model, "Oregano_" .. i)
	end

	-- A few tiny purple flowers (basil flowers)
	for i = 1, 3 do
		AB.sphere(0.15, FLOWER,
			AB.offset(originCF, -2 + i * 0.3, 3.3, math.random() - 0.5), model, "Flower_" .. i)
	end

	-- Plant label stake (small wooden marker)
	AB.block(Vector3.new(0.6, 0.4, 0.05), Color3.fromRGB(245, 240, 230),
		AB.offset(originCF, -2.5, 3, 1.2), model, "LabelBasil")
	AB.block(Vector3.new(0.1, 1, 0.1), DK_WD,
		AB.offset(originCF, -2.5, 2.5, 1.2), model, "LabelStake")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
