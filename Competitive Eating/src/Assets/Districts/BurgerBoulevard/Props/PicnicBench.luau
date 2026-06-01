-- PicnicBench — outdoor red+white checkered picnic table with two benches.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PicnicBench", parent)
	local RED   = Color3.fromRGB(220, 50, 50)
	local WHITE = Color3.fromRGB(245, 245, 240)
	local WOOD  = Color3.fromRGB(140, 90, 50)
	local CHROME = Color3.fromRGB(176, 176, 176)

	-- Table top (start with white, then add red checker stripes)
	local top = AB.block(Vector3.new(8, 0.3, 4), WHITE, AB.offset(originCF, 0, 3, 0), model, "TableTop")
	-- Painted red checker stripes (4 across)
	for i = 0, 3 do
		local x = -3 + i * 2
		AB.block(Vector3.new(0.9, 0.32, 4), RED, AB.offset(originCF, x, 3, 0), model, "Stripe_" .. i)
	end
	-- Cross stripes (3 along Z)
	for j = 0, 2 do
		local z = -1.3 + j * 1.3
		AB.block(Vector3.new(8, 0.33, 0.6), RED, AB.offset(originCF, 0, 3, z), model, "ZStripe_" .. j)
	end
	-- Top trim
	AB.block(Vector3.new(8.2, 0.1, 4.2), CHROME, AB.offset(originCF, 0, 3.2, 0), model, "TopTrim")

	-- 4 chrome legs (X-pair)
	AB.block(Vector3.new(0.3, 3, 0.3), CHROME, AB.offset(originCF, -3.5, 1.5, -1.5), model, "Leg1")
	AB.block(Vector3.new(0.3, 3, 0.3), CHROME, AB.offset(originCF,  3.5, 1.5, -1.5), model, "Leg2")
	AB.block(Vector3.new(0.3, 3, 0.3), CHROME, AB.offset(originCF, -3.5, 1.5,  1.5), model, "Leg3")
	AB.block(Vector3.new(0.3, 3, 0.3), CHROME, AB.offset(originCF,  3.5, 1.5,  1.5), model, "Leg4")
	-- Cross brace
	AB.block(Vector3.new(8, 0.2, 0.2), CHROME, AB.offset(originCF, 0, 1, 0), model, "Brace")

	-- Two benches (back + front)
	AB.block(Vector3.new(8, 0.3, 1.2), WOOD, AB.offset(originCF, 0, 1.7, 3), model, "BenchF").Material = Enum.Material.WoodPlanks
	AB.block(Vector3.new(8, 0.3, 1.2), WOOD, AB.offset(originCF, 0, 1.7, -3), model, "BenchB").Material = Enum.Material.WoodPlanks
	AB.block(Vector3.new(0.3, 1.7, 0.3), CHROME, AB.offset(originCF, -3, 0.85, 3), model, "BenchFLegL")
	AB.block(Vector3.new(0.3, 1.7, 0.3), CHROME, AB.offset(originCF, 3, 0.85, 3), model, "BenchFLegR")
	AB.block(Vector3.new(0.3, 1.7, 0.3), CHROME, AB.offset(originCF, -3, 0.85, -3), model, "BenchBLegL")
	AB.block(Vector3.new(0.3, 1.7, 0.3), CHROME, AB.offset(originCF, 3, 0.85, -3), model, "BenchBLegR")

	-- A salt + pepper on the table for vibe
	AB.cylinder(0.4, 0.8, WHITE, AB.offset(originCF, 1, 3.5, 0.5), model, "Salt")
	AB.cylinder(0.4, 0.8, Color3.fromRGB(35, 35, 35), AB.offset(originCF, 1.5, 3.5, 0.5), model, "Pepper")

	AB.pivot(model, top)
	AB.weldAll(model)
	return model
end
