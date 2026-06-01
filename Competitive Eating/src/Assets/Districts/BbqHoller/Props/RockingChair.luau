-- Rocking Chair — country wood rocker with vertical-slat back and curved rails.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WOOD      = Color3.fromRGB(130, 90, 55)
local DARK_WOOD = Color3.fromRGB(85, 55, 35)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RockingChair", parent)

	-- Seat
	local seat = AB.block(Vector3.new(3, 0.3, 3), WOOD, AB.offset(originCF, 0, 2.3, 0), model, "Seat")
	-- Front legs
	AB.block(Vector3.new(0.3, 2.4, 0.3), DARK_WOOD, AB.offset(originCF, -1.3, 1.1, 1.3), model, "LegFL")
	AB.block(Vector3.new(0.3, 2.4, 0.3), DARK_WOOD, AB.offset(originCF,  1.3, 1.1, 1.3), model, "LegFR")
	-- Back legs (taller, become backrest posts)
	AB.block(Vector3.new(0.3, 6, 0.3), DARK_WOOD, AB.offset(originCF, -1.3, 3.0, -1.3), model, "LegBL")
	AB.block(Vector3.new(0.3, 6, 0.3), DARK_WOOD, AB.offset(originCF,  1.3, 3.0, -1.3), model, "LegBR")

	-- Backrest slats (5 vertical spindles)
	for i, x in {-1.0, -0.5, 0, 0.5, 1.0} do
		AB.block(Vector3.new(0.2, 3.6, 0.2), WOOD, AB.offset(originCF, x, 4.3, -1.3), model, "Spindle_" .. i)
	end
	-- Top rail of backrest
	AB.block(Vector3.new(3, 0.4, 0.4), DARK_WOOD, AB.offset(originCF, 0, 5.9, -1.3), model, "TopRail")
	-- Bottom slat just above seat
	AB.block(Vector3.new(3, 0.3, 0.3), DARK_WOOD, AB.offset(originCF, 0, 2.7, -1.3), model, "BotRail")

	-- Armrests
	AB.block(Vector3.new(0.4, 0.3, 2.6), WOOD, AB.offset(originCF, -1.3, 3.3, 0), model, "ArmL")
	AB.block(Vector3.new(0.4, 0.3, 2.6), WOOD, AB.offset(originCF,  1.3, 3.3, 0), model, "ArmR")

	-- Curved rocker rails (approximate with 3 stacked angled blocks each side)
	for i, z in {-1.5, 0, 1.5} do
		AB.block(Vector3.new(0.3, 0.3, 1.2), DARK_WOOD, AB.offset(originCF, -1.3, 0.2 + math.abs(z) * 0.15, z), model, "RockerL_" .. i)
		AB.block(Vector3.new(0.3, 0.3, 1.2), DARK_WOOD, AB.offset(originCF,  1.3, 0.2 + math.abs(z) * 0.15, z), model, "RockerR_" .. i)
	end
	-- End tips lift up
	AB.block(Vector3.new(0.3, 0.5, 0.8), DARK_WOOD, AB.offset(originCF, -1.3, 0.5, 2.2), model, "RockerTipFL")
	AB.block(Vector3.new(0.3, 0.5, 0.8), DARK_WOOD, AB.offset(originCF,  1.3, 0.5, 2.2), model, "RockerTipFR")
	AB.block(Vector3.new(0.3, 0.5, 0.8), DARK_WOOD, AB.offset(originCF, -1.3, 0.5, -2.2), model, "RockerTipBL")
	AB.block(Vector3.new(0.3, 0.5, 0.8), DARK_WOOD, AB.offset(originCF,  1.3, 0.5, -2.2), model, "RockerTipBR")

	AB.pivot(model, seat)
	AB.weldAll(model)
	return model
end
