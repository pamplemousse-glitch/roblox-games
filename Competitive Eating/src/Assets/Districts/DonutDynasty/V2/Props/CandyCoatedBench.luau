-- CandyCoatedBench — pastel pink park bench with cream piping and
-- gold legs, like a glossy hard-candy shell.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local CREAM  = Color3.fromRGB(255, 240, 220)
local GOLD   = Color3.fromRGB(212, 168, 82)
local MINT   = Color3.fromRGB(180, 230, 200)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CandyCoatedBench", parent)

	-- Seat slab (high reflectance for "candy coat")
	local seat = AB.part({
		size = Vector3.new(8, 0.6, 2.4), color = PINK,
		cf = AB.offset(originCF, 0, 2, 0),
		name = "Seat", reflectance = 0.2,
	}, model)

	-- Backrest
	AB.part({
		size = Vector3.new(8, 3, 0.4), color = PINK,
		cf = AB.offset(originCF, 0, 3.5, -1.1),
		name = "Backrest", reflectance = 0.2,
	}, model)

	-- Cream piping along seat edge
	AB.block(Vector3.new(8, 0.2, 0.3), CREAM,
		AB.offset(originCF, 0, 2.35, 1.2), model, "PipingFront")
	AB.block(Vector3.new(8, 0.2, 0.3), CREAM,
		AB.offset(originCF, 0, 5, -1.3), model, "PipingTop")

	-- Gold legs (curled, suggested by stack of 2 spheres + cylinder)
	for i, x in {-3.5, 3.5} do
		AB.cylinder(0.5, 2, GOLD,
			AB.offset(originCF, x, 1, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Leg_" .. i)
		AB.sphere(0.7, GOLD, AB.offset(originCF, x, 0.4, 0.8), model, "LegFootF_" .. i)
		AB.sphere(0.7, GOLD, AB.offset(originCF, x, 0.4, -0.8), model, "LegFootB_" .. i)
	end

	-- Mint mint-candy decoration on backrest center
	AB.sphere(0.8, MINT, AB.offset(originCF, 0, 4.6, -1.0), model, "Decoration")

	AB.pivot(model, seat)
	AB.weldAll(model)
	return model
end
