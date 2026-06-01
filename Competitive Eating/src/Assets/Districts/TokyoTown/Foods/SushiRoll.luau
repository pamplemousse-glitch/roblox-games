-- Sushi Roll — cylindrical maki: nori shell, rice interior, colored topping
-- (salmon-orange). Sliced into 5 pieces sitting on a small bamboo board.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BAMBOO_GREEN = Color3.fromRGB(140, 180, 100)
local BAMBOO_WOOD  = Color3.fromRGB(170, 140, 90)
local NORI         = Color3.fromRGB(40, 50, 40)
local RICE         = Color3.fromRGB(245, 240, 230)
local SALMON       = Color3.fromRGB(255, 130, 90)
local AVOCADO      = Color3.fromRGB(130, 170, 90)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SushiRoll", parent)

	-- Bamboo serving board (a flat slab with subtle "slat" stripes)
	local board = AB.block(
		Vector3.new(6.0, 0.3, 3.2),
		BAMBOO_WOOD,
		AB.offset(originCF, 0, 0.15, 0),
		model,
		"Board"
	)
	for i, x in {-2.2, -0.8, 0.6, 2.0} do
		AB.block(
			Vector3.new(0.12, 0.32, 3.2),
			BAMBOO_GREEN,
			AB.offset(originCF, x, 0.16, 0),
			model,
			"Slat_" .. i
		)
	end

	-- 5 sushi pieces, evenly spaced
	for i = 1, 5 do
		local x = (i - 3) * 1.0
		-- Nori outer cylinder (lying on its side)
		AB.part({
			size  = Vector3.new(0.9, 1.6, 1.6),
			color = NORI,
			cf    = AB.offset(originCF, x, 1.1, 0) * CFrame.Angles(0, 0, math.rad(90)),
			shape = Enum.PartType.Cylinder,
			name  = "Nori_" .. i,
		}, model)
		-- Rice fill (slightly smaller cylinder of pale white)
		AB.part({
			size  = Vector3.new(0.95, 1.4, 1.4),
			color = RICE,
			cf    = AB.offset(originCF, x, 1.1, 0) * CFrame.Angles(0, 0, math.rad(90)),
			shape = Enum.PartType.Cylinder,
			name  = "Rice_" .. i,
		}, model)
		-- Topping (small salmon dome on top, alternating with avocado for variety)
		local topColor = (i % 2 == 1) and SALMON or AVOCADO
		AB.sphere(
			0.7,
			topColor,
			AB.offset(originCF, x, 1.85, 0),
			model,
			"Topping_" .. i
		)
	end

	AB.pivot(model, board)
	AB.weldAll(model)
	return model
end
