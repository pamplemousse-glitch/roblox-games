-- Chili Ristra Pole — two upright poles with a crossbar from which three
-- strings of dried red chilies hang, with a few yellow chilies for variety.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local ROPE_TAN    = Color3.fromRGB(200, 175, 120)
local CHILI_RED   = Color3.fromRGB(190, 35, 35)
local CHILI_DEEP  = Color3.fromRGB(140, 25, 25)
local CHILI_YEL   = Color3.fromRGB(255, 184, 52)
local TERRACOTTA  = Color3.fromRGB(196, 95, 44)
local STEM_GREEN  = Color3.fromRGB(85, 130, 65)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ChiliRistraPole", parent)

	-- Two vertical poles
	local poleL = AB.cylinder(0.5, 8, WOOD_DARK,
		AB.offset(originCF, -2, 4, 0), model, "PoleL")
	AB.cylinder(0.5, 8, WOOD_DARK,
		AB.offset(originCF,  2, 4, 0), model, "PoleR")

	-- Horizontal crossbar
	AB.cylinder(0.3, 4.4, WOOD_DARK,
		AB.offset(originCF, 0, 7.8, 0) * CFrame.Angles(0, 0, math.rad(90)),
		model, "Crossbar")

	-- 3 ristra strings, varied lengths and chili counts
	local ristras = {
		{x = -1.4, count = 8, len = 6.5},
		{x =  0.0, count = 7, len = 5.5},
		{x =  1.4, count = 6, len = 4.8},
	}
	for r, info in ristras do
		-- Hanging rope
		AB.block(Vector3.new(0.12, info.len, 0.12), ROPE_TAN,
			AB.offset(originCF, info.x, 7.8 - info.len / 2, 0),
			model, "Rope_" .. r)

		-- Decorative terracotta knot where the rope ties to the bar
		AB.sphere(0.4, TERRACOTTA,
			AB.offset(originCF, info.x, 7.7, 0), model, "Knot_" .. r)

		-- Chain of chili spheres descending
		for i = 1, info.count do
			local y = 7.5 - (i - 0.5) * (info.len / info.count)
			-- Most are red, alternate a couple yellows on the middle string
			local isYellow = (r == 2 and (i == 2 or i == 5))
			local color = isYellow and CHILI_YEL or (i % 2 == 0 and CHILI_RED or CHILI_DEEP)
			-- Offset each chili slightly side to side for organic look
			local dx = ((i % 2 == 0) and 0.15 or -0.15)
			local chili = AB.sphere(0.55, color,
				AB.offset(originCF, info.x + dx, y, 0), model,
				string.format("Chili_%d_%d", r, i))
			-- Small green stem on top of each chili
			AB.block(Vector3.new(0.1, 0.15, 0.1), STEM_GREEN,
				AB.offset(originCF, info.x + dx, y + 0.35, 0), model,
				string.format("Stem_%d_%d", r, i))
			-- Neon-glow the very top chili of each ristra for nighttime read
			if i == 1 then AB.neon(chili) end
		end
	end

	AB.pivot(model, poleL)
	AB.weldAll(model)
	return model
end
