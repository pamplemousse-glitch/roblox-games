-- CottonCandyBush — fluffy decorative shrub built from pink + cream
-- spheres, resembling a candy floss puff with a brown stick base.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CREAM  = Color3.fromRGB(255, 240, 220)
local BROWN  = Color3.fromRGB(92,  57,  36)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CottonCandyBush", parent)

	-- Stick / trunk (small brown stake)
	local trunk = AB.cylinder(0.4, 1.6, BROWN,
		AB.offset(originCF, 0, 0.8, 0), model, "Stick")

	-- Big main puff (pink)
	AB.sphere(4, PINK, AB.offset(originCF, 0, 4, 0), model, "PuffMain")

	-- Surrounding smaller puffs in alternating shades
	local puffs = {
		{2.6, -2, 4.2, 0,    DEEP},
		{2.6,  2, 4.2, 0,    PINK},
		{2.4,  0, 4.5, 2,    CREAM},
		{2.4,  0, 4.5, -2,   PINK},
		{2.2, -1.4, 5.5, 1,  CREAM},
		{2.2,  1.4, 5.5, -1, DEEP},
		{2,    0,   6.4, 0,  PINK},
	}
	for i, p in puffs do
		AB.sphere(p[1], p[5],
			AB.offset(originCF, p[2], p[3], p[4]), model, "Puff_" .. i)
	end

	-- A few tiny sparkle dots
	for i = 1, 5 do
		local a = (i / 5) * math.pi * 2
		AB.sphere(0.2, CREAM,
			AB.offset(originCF, math.cos(a) * 3, 4.5 + math.sin(a) * 1.5, math.sin(a) * 1.5),
			model, "Sparkle_" .. i)
	end

	AB.pivot(model, trunk)
	AB.weldAll(model)
	return model
end
