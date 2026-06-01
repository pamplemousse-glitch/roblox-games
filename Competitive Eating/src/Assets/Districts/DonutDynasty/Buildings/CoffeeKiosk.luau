-- Coffee Kiosk — small wooden hut with a striped awning and an espresso
-- machine silhouette on the counter.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WOOD   = Color3.fromRGB(120, 80, 50)
local DARK   = Color3.fromRGB(80, 55, 35)
local CREAM  = Color3.fromRGB(255, 240, 220)
local CHROME = Color3.fromRGB(200, 200, 210)
local CHOCO  = Color3.fromRGB(92, 57, 36)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CoffeeKiosk", parent)

	AB.block(Vector3.new(14, 0.4, 12), DARK,
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")

	-- Hut walls (back + sides only — counter open at front)
	AB.block(Vector3.new(14, 8, 0.5), WOOD,
		AB.offset(originCF, 0, 4, -5.75), model, "BackWall")
	AB.block(Vector3.new(0.5, 8, 12), WOOD,
		AB.offset(originCF, -6.75, 4, 0), model, "LeftWall")
	AB.block(Vector3.new(0.5, 8, 12), WOOD,
		AB.offset(originCF,  6.75, 4, 0), model, "RightWall")

	-- Counter (front bar)
	AB.block(Vector3.new(14, 3.5, 1), DARK,
		AB.offset(originCF, 0, 1.75, 5), model, "Counter")
	AB.block(Vector3.new(14, 0.4, 2), WOOD,
		AB.offset(originCF, 0, 3.7, 4.5), model, "CounterTop")

	-- Espresso machine silhouette on the counter
	AB.block(Vector3.new(5, 2.5, 1.4), CHROME,
		AB.offset(originCF, -1, 5.15, 4.7), model, "EspressoBody")
	AB.block(Vector3.new(5, 0.5, 1.6), DARK,
		AB.offset(originCF, -1, 6.5, 4.7), model, "EspressoTop")
	-- Two portafilter spouts
	for i, x in {-2.2, 0.2} do
		AB.cylinder(0.5, 0.8, CHROME,
			AB.offset(originCF, x, 4.4, 4.7), model, "Spout_" .. i)
	end
	-- A coffee cup beside it
	AB.cylinder(1.4, 1.4, CREAM,
		AB.offset(originCF, 4, 4.6, 4.7), model, "Cup")
	AB.cylinder(1.0, 0.2, CHOCO,
		AB.offset(originCF, 4, 5.3, 4.7), model, "CupCoffee")

	-- Striped awning above counter
	for i, x in {-5.6, -3.2, -0.8, 1.6, 4, 6.4} do
		local color = (i % 2 == 0) and CREAM or CHOCO
		AB.block(Vector3.new(2.4, 0.5, 4), color,
			AB.offset(originCF, x, 8.5, 4.5), model, "AwningStripe_" .. i)
	end

	-- Roof
	AB.block(Vector3.new(16, 0.8, 14), DARK,
		AB.offset(originCF, 0, 9, 0), model, "Roof")

	-- "COFFEE" mini sign on the front header
	local sign = AB.block(Vector3.new(7, 1.5, 0.3), CHOCO,
		AB.offset(originCF, 0, 7, 4.9), model, "Sign")
	AB.glow(sign, CREAM, 1.5)

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
