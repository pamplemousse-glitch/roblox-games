-- Sombrero Rack — wooden upright pole with 3 sombreros stacked at varied
-- heights, capped by a cross-arm. Each sombrero has brim, crown, band.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA = Color3.fromRGB(196, 95, 44)
local CREAM      = Color3.fromRGB(245, 230, 200)
local CHARCOAL   = Color3.fromRGB(55, 50, 50)
local WOOD_DARK  = Color3.fromRGB(110, 75, 45)
local BAND_GOLD  = Color3.fromRGB(200, 165, 60)
local BAND_RED   = Color3.fromRGB(160, 40, 50)
local BAND_TEAL  = Color3.fromRGB(43, 140, 156)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SombreroRack", parent)

	-- Small base block
	local base = AB.block(Vector3.new(1.6, 0.5, 1.6), WOOD_DARK,
		AB.offset(originCF, 0, 0.25, 0), model, "Base")

	-- Vertical pole
	AB.cylinder(0.4, 6, WOOD_DARK,
		AB.offset(originCF, 0, 3.5, 0), model, "Pole")

	-- Cross-arm at top
	AB.block(Vector3.new(2, 0.25, 0.25), WOOD_DARK,
		AB.offset(originCF, 0, 6.6, 0), model, "CrossArm")

	-- 3 stacked sombreros (color, band, height)
	local sombreros = {
		{y = 2.0, brim = TERRACOTTA, band = BAND_GOLD},
		{y = 3.7, brim = CREAM,      band = BAND_RED},
		{y = 5.4, brim = CHARCOAL,   band = BAND_TEAL},
	}
	for i, s in sombreros do
		-- Wide brim
		AB.cylinder(3, 0.3, s.brim,
			AB.offset(originCF, 0, s.y, 0), model, "Brim_" .. i)
		-- Brim turned-up edge (decorative ring around brim outer)
		AB.cylinder(3.1, 0.18, s.band,
			AB.offset(originCF, 0, s.y + 0.16, 0), model, "BrimEdge_" .. i)
		-- Crown
		AB.cylinder(1.5, 1, s.brim,
			AB.offset(originCF, 0, s.y + 0.7, 0), model, "Crown_" .. i)
		-- Crown peak tip (small ball on top of crown)
		AB.sphere(0.5, s.band,
			AB.offset(originCF, 0, s.y + 1.3, 0), model, "CrownTip_" .. i)
		-- Hat band stripe
		AB.cylinder(1.55, 0.25, s.band,
			AB.offset(originCF, 0, s.y + 0.3, 0), model, "Band_" .. i)
		-- Small embroidery dots around the band (4 evenly spaced)
		for d = 1, 4 do
			local a = (d - 1) * (math.pi / 2)
			AB.sphere(0.18, BAND_GOLD,
				AB.offset(originCF, math.cos(a) * 0.78, s.y + 0.3, math.sin(a) * 0.78),
				model, string.format("Embroid_%d_%d", i, d))
		end
	end

	-- Decorative finial on top of the cross-arm
	local finial = AB.sphere(0.55, BAND_GOLD,
		AB.offset(originCF, 0, 7.0, 0), model, "Finial")
	AB.neon(finial)
	AB.glow(finial, BAND_GOLD, 1.5)
	-- Cross-arm end caps (two small spheres at the tips)
	AB.sphere(0.3, BAND_RED,
		AB.offset(originCF, -1.0, 6.6, 0), model, "ArmCapL")
	AB.sphere(0.3, BAND_RED,
		AB.offset(originCF,  1.0, 6.6, 0), model, "ArmCapR")

	-- Small price tag hanging off the cross-arm
	AB.block(Vector3.new(0.8, 0.6, 0.05), CREAM,
		AB.offset(originCF, 1.4, 6.0, 0), model, "PriceTag")
	AB.block(Vector3.new(0.1, 0.4, 0.1), WOOD_DARK,
		AB.offset(originCF, 1.4, 6.35, 0), model, "TagString")

	-- Decorative base trim and accent stones
	AB.block(Vector3.new(2.2, 0.2, 2.2), TERRACOTTA,
		AB.offset(originCF, 0, 0.1, 0), model, "BaseSkirt")

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
