-- Brisket — rectangular smoked slab with dark "bark" crust on top.
-- A meaty cuboid sitting on a wood cutting board; bark sliced into 4 strips.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SMOKED_WOOD = Color3.fromRGB(107, 68, 35)
local BARK        = Color3.fromRGB(45, 22, 10)
local MEAT        = Color3.fromRGB(150, 60, 35)
local FAT_LINE    = Color3.fromRGB(225, 195, 140)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Brisket", parent)

	-- Cutting board (cherrywood)
	local board = AB.block(
		Vector3.new(7, 0.4, 4.5),
		SMOKED_WOOD,
		AB.offset(originCF, 0, 0.2, 0),
		model,
		"Board"
	)

	-- Meat body (the slab)
	AB.block(
		Vector3.new(6, 1.5, 3.4),
		MEAT,
		AB.offset(originCF, 0, 1.15, 0),
		model,
		"Meat"
	)

	-- Bark crust on top (slightly smaller, very dark)
	AB.block(
		Vector3.new(5.9, 0.35, 3.3),
		BARK,
		AB.offset(originCF, 0, 2.05, 0),
		model,
		"Bark"
	)

	-- Slice lines: 4 darker grooves cut into bark to suggest portioning
	for i, x in {-2.0, -0.6, 0.6, 2.0} do
		AB.block(
			Vector3.new(0.15, 0.45, 3.4),
			Color3.fromRGB(20, 10, 5),
			AB.offset(originCF, x, 2.05, 0),
			model,
			"SliceLine_" .. i
		)
	end

	-- Marbled fat streaks along the side (two horizontal bands)
	for i, y in {1.4, 0.9} do
		AB.block(
			Vector3.new(6.05, 0.1, 3.45),
			FAT_LINE,
			AB.offset(originCF, 0, y, 0),
			model,
			"Fat_" .. i
		)
	end

	AB.pivot(model, board)
	AB.weldAll(model)
	return model
end
