-- SugarCubePlanter — cubic planter built from stacked white "sugar cubes"
-- with a mint shrub and a pink flower on top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CREAM  = Color3.fromRGB(255, 240, 220)
local LIGHT  = Color3.fromRGB(250, 245, 230)
local MINT   = Color3.fromRGB(180, 230, 200)
local DEEP   = Color3.fromRGB(232, 130, 165)
local PINK   = Color3.fromRGB(255, 200, 214)
local GOLD   = Color3.fromRGB(212, 168, 82)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SugarCubePlanter", parent)

	-- 2x2x2 grid of sugar cubes
	for x = 1, 2 do
		for y = 1, 2 do
			for z = 1, 2 do
				local cx = (x - 1.5) * 1.8
				local cy = 0.9 + (y - 1) * 1.8
				local cz = (z - 1.5) * 1.8
				local col = ((x + y + z) % 2 == 0) and CREAM or LIGHT
				AB.block(Vector3.new(1.7, 1.7, 1.7), col,
					AB.offset(originCF, cx, cy, cz), model, "Cube_" .. x .. y .. z)
			end
		end
	end

	-- Gold base ring
	AB.block(Vector3.new(4, 0.3, 4), GOLD,
		AB.offset(originCF, 0, 0.15, 0), model, "BaseRing")

	-- Mint shrub bursting from top
	AB.sphere(2.6, MINT, AB.offset(originCF, 0, 4.5, 0), model, "Shrub")
	AB.sphere(1.6, MINT, AB.offset(originCF, -0.8, 5.4, 0.5), model, "ShrubLump1")
	AB.sphere(1.6, MINT, AB.offset(originCF, 0.7, 5.4, -0.4), model, "ShrubLump2")

	-- Pink flower on top
	AB.circleArrange(AB.offset(originCF, 0, 6.2, 0), 0.6, 5, model, function(i, cf, _)
		return AB.sphere(0.6, DEEP, cf, model, "FlowerPetal_" .. i)
	end)
	AB.sphere(0.5, GOLD, AB.offset(originCF, 0, 6.2, 0), model, "FlowerCenter")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
