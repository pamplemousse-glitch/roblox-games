-- Cathedral Arch Entry — cream-stucco gateway arch with painted flowers
-- and a small bell at the peak. Wide enough to walk through.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STUCCO_CREAM = Color3.fromRGB(238, 222, 188)
local STUCCO_TRIM  = Color3.fromRGB(215, 195, 155)
local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FLOWER_PINK  = Color3.fromRGB(230, 130, 165)
local FLOWER_GOLD  = Color3.fromRGB(255, 195, 75)
local LEAF_GREEN   = Color3.fromRGB(93, 168, 85)
local BELL_BRASS   = Color3.fromRGB(200, 160, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CathedralArchEntry", parent)

	-- Left column
	local leftCol = AB.block(
		Vector3.new(3.5, 14, 3.5),
		STUCCO_CREAM,
		AB.offset(originCF, -8, 7, 0),
		model,
		"ColumnL"
	)
	-- Right column
	AB.block(
		Vector3.new(3.5, 14, 3.5),
		STUCCO_CREAM,
		AB.offset(originCF, 8, 7, 0),
		model,
		"ColumnR"
	)

	-- Column bases (slightly wider)
	for i, x in {-8, 8} do
		AB.block(Vector3.new(4.5, 1, 4.5), STUCCO_TRIM,
			AB.offset(originCF, x, 0.5, 0), model, "ColBase_" .. i)
	end

	-- Top crossbeam
	AB.block(Vector3.new(22, 2.5, 3.5), STUCCO_CREAM,
		AB.offset(originCF, 0, 15.25, 0), model, "CrossBeam")

	-- Arch curve approximated by 5 wedges meeting at the top
	local archSegments = 5
	for i = 1, archSegments do
		local t = (i - 0.5) / archSegments
		local angle = (t - 0.5) * math.rad(150)
		local r = 8
		local x = r * math.sin(angle)
		local y = 14 - r * (1 - math.cos(angle))
		AB.wedge(
			Vector3.new(3.4, 2, 3.5),
			STUCCO_CREAM,
			AB.offset(originCF, x, y, 0) * CFrame.Angles(0, 0, math.deg(angle) > 0 and math.rad(angle) or math.rad(angle)),
			model,
			"Arch_" .. i
		)
	end

	-- Painted flower medallions on the columns (2 per column)
	for i, pos in {
		Vector3.new(-8, 5, 1.8),  Vector3.new(-8, 10, 1.8),
		Vector3.new( 8, 5, 1.8),  Vector3.new( 8, 10, 1.8),
	} do
		-- Flower center
		AB.sphere(0.8, FLOWER_GOLD,
			AB.offset(originCF, pos.X, pos.Y, pos.Z), model, "FlowerC_" .. i)
		-- Petals (4)
		for p, offset in {
			Vector3.new(0.7, 0, 0), Vector3.new(-0.7, 0, 0),
			Vector3.new(0, 0.7, 0), Vector3.new(0, -0.7, 0),
		} do
			AB.sphere(0.55, FLOWER_PINK,
				AB.offset(originCF, pos.X + offset.X, pos.Y + offset.Y, pos.Z),
				model, string.format("FlowerP_%d_%d", i, p))
		end
		-- Leaves
		AB.block(Vector3.new(0.3, 1.2, 0.2), LEAF_GREEN,
			AB.offset(originCF, pos.X - 1.0, pos.Y - 0.8, pos.Z),
			model, "Leaf_" .. i)
	end

	-- Terracotta cornice roof slab on top
	AB.block(Vector3.new(24, 0.8, 4.5), TERRACOTTA,
		AB.offset(originCF, 0, 16.8, 0), model, "Cornice")

	-- Small bell tower bump at the center
	AB.block(Vector3.new(4, 3, 3.5), STUCCO_CREAM,
		AB.offset(originCF, 0, 18.7, 0), model, "BellHouse")
	-- Bell archway opening (a darker block to suggest hollow)
	AB.block(Vector3.new(2.4, 2.2, 3.6), Color3.fromRGB(60, 45, 35),
		AB.offset(originCF, 0, 18.6, 0), model, "BellOpening")
	-- The bell itself
	AB.sphere(1.4, BELL_BRASS,
		AB.offset(originCF, 0, 19, 0), model, "Bell")
	AB.block(Vector3.new(0.2, 0.6, 0.2), BELL_BRASS,
		AB.offset(originCF, 0, 19.9, 0), model, "BellMount")

	-- Top finial / cross approximation
	AB.block(Vector3.new(0.3, 1.6, 0.3), STUCCO_TRIM,
		AB.offset(originCF, 0, 21, 0), model, "FinialV")
	AB.block(Vector3.new(1.0, 0.3, 0.3), STUCCO_TRIM,
		AB.offset(originCF, 0, 21.2, 0), model, "FinialH")

	AB.pivot(model, leftCol)
	AB.weldAll(model)
	return model
end
