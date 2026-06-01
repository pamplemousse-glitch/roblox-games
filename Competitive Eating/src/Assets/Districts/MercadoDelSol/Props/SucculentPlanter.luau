-- Succulent Planter — long wooden box with 4 different succulents plus accent
-- flowers. Reads as a desert-garden planter beside a market stall.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local WOOD_LIGHT  = Color3.fromRGB(160, 115, 70)
local SOIL_BROWN  = Color3.fromRGB(60, 42, 25)
local SUCC_GREEN  = Color3.fromRGB(80, 140, 70)
local SUCC_LIGHT  = Color3.fromRGB(140, 185, 110)
local CACTUS_GRN  = Color3.fromRGB(90, 130, 75)
local SPIKE_WHITE = Color3.fromRGB(240, 235, 220)
local BOUG_PINK   = Color3.fromRGB(220, 80, 140)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SucculentPlanter", parent)

	-- Main planter box
	local box = AB.block(Vector3.new(6, 1.5, 2), WOOD_DARK,
		AB.offset(originCF, 0, 0.75, 0), model, "Box")
	-- Top trim ledge (slightly wider rim)
	AB.block(Vector3.new(6.3, 0.25, 2.3), WOOD_LIGHT,
		AB.offset(originCF, 0, 1.6, 0), model, "TrimLedge")
	-- Soil layer
	AB.block(Vector3.new(5.7, 0.25, 1.7), SOIL_BROWN,
		AB.offset(originCF, 0, 1.6, 0), model, "Soil")

	-- 1) Aloe — 3 vertical wedges at left
	for i = 1, 3 do
		AB.wedge(Vector3.new(0.4, 1.6, 0.5), SUCC_GREEN,
			AB.offset(originCF, -2.2 + (i - 2) * 0.3, 2.5, 0) * CFrame.Angles(0, 0, math.rad((i - 2) * 12)),
			model, "Aloe_" .. i)
	end

	-- 2) Cactus — small cylinder with white spike spheres
	AB.cylinder(0.8, 1.6, CACTUS_GRN,
		AB.offset(originCF, -0.8, 2.5, 0), model, "CactusBody")
	for i, pos in {Vector3.new(-0.8, 2.2, 0.5), Vector3.new(-0.8, 2.8, -0.4),
	               Vector3.new(-0.4, 2.5, 0.2), Vector3.new(-1.2, 2.4, -0.3)} do
		AB.sphere(0.18, SPIKE_WHITE,
			AB.offset(originCF, pos.X, pos.Y, pos.Z), model, "Spike_" .. i)
	end

	-- 3) Echeveria — rosette of 6 small angled blocks
	for i = 1, 6 do
		local a = (i - 1) * (2 * math.pi / 6)
		AB.block(Vector3.new(0.55, 0.25, 0.55), SUCC_LIGHT,
			AB.offset(originCF, 0.8 + math.cos(a) * 0.45, 2.0, math.sin(a) * 0.45)
				* CFrame.Angles(math.rad(-25), -a, 0),
			model, "Echev_" .. i)
	end

	-- 4) Agave — large angled wedge cluster at right
	for i = 1, 4 do
		local a = (i - 1) * (math.pi / 2)
		AB.wedge(Vector3.new(0.5, 1.8, 0.7), SUCC_GREEN,
			AB.offset(originCF, 2.3, 2.5, 0) * CFrame.Angles(math.rad(15), -a, 0)
				* CFrame.new(0, 0, 0.4),
			model, "Agave_" .. i)
	end

	-- Pink accent flowers
	AB.sphere(0.35, BOUG_PINK, AB.offset(originCF, -2.2, 3.4, 0), model, "Flower1")
	AB.sphere(0.35, BOUG_PINK, AB.offset(originCF,  0.7, 2.5, 0.7), model, "Flower2")
	AB.sphere(0.35, BOUG_PINK, AB.offset(originCF,  2.3, 3.6, -0.4), model, "Flower3")

	AB.pivot(model, box)
	AB.weldAll(model)
	return model
end
