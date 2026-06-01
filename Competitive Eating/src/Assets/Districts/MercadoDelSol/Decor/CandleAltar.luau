-- Candle Altar — small Day-of-the-Dead style ofrenda altar. Three tiers of
-- terracotta blocks, candles of varying heights with glowing flames, framed
-- photo, marigold petals, calavera skull, pan de muerto, drinks, and a tiny
-- papel picado banner draped above.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local BOUG_PINK    = Color3.fromRGB(220, 80, 140)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local MARIGOLD     = Color3.fromRGB(255, 145, 30)
local CANDLE_FLAME = Color3.fromRGB(255, 200, 90)
local CREAM        = Color3.fromRGB(245, 230, 200)
local BONE_WHITE   = Color3.fromRGB(240, 232, 215)
local PHOTO_DARK   = Color3.fromRGB(50, 40, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CandleAltar", parent)

	-- Tier 1 (base): 5 × 0.5 × 4
	local base = AB.block(Vector3.new(5, 0.5, 4), TERRACOTTA,
		AB.offset(originCF, 0, 0.25, 0), model, "BaseTier")
	-- Tier 1 cloth trim (cream cloth strip along the front)
	AB.block(Vector3.new(5.05, 0.3, 0.1), CREAM,
		AB.offset(originCF, 0, 0.25, 2.0), model, "BaseCloth")

	-- Tier 2 (middle): 4 × 0.5 × 3
	AB.block(Vector3.new(4, 0.5, 3), TERRACOTTA,
		AB.offset(originCF, 0, 0.75, -0.3), model, "MidTier")
	AB.block(Vector3.new(4.05, 0.3, 0.1), CREAM,
		AB.offset(originCF, 0, 0.75, 1.2), model, "MidCloth")

	-- Tier 3 (top): 3 × 0.5 × 2
	AB.block(Vector3.new(3, 0.5, 2), TERRACOTTA,
		AB.offset(originCF, 0, 1.25, -0.6), model, "TopTier")
	AB.block(Vector3.new(3.05, 0.3, 0.1), CREAM,
		AB.offset(originCF, 0, 1.25, 0.4), model, "TopCloth")

	-- Vertical back wall (where the photo sits)
	AB.block(Vector3.new(3, 3, 0.2), WOOD_DARK,
		AB.offset(originCF, 0, 3, -1.5), model, "BackWall")

	-- Framed photo on the back wall (cream rectangle with dark accent face)
	AB.block(Vector3.new(1.6, 2, 0.1), CREAM,
		AB.offset(originCF, 0, 3.2, -1.35), model, "PhotoMat")
	AB.block(Vector3.new(1.8, 2.2, 0.15), WOOD_DARK,
		AB.offset(originCF, 0, 3.2, -1.4), model, "PhotoFrame")
	-- The "face" silhouette
	AB.sphere(0.55, PHOTO_DARK,
		AB.offset(originCF, 0, 3.4, -1.3), model, "PhotoFace")
	-- Tiny shoulders/torso under face
	AB.block(Vector3.new(0.9, 0.5, 0.05), PHOTO_DARK,
		AB.offset(originCF, 0, 2.85, -1.3), model, "PhotoTorso")

	-- 5 candles of varying heights — varied positions across the tiers
	local candleData = {
		{x = -1.8, y = 0.5, h = 2.4, name = "Candle1"}, -- base tier left
		{x =  1.8, y = 0.5, h = 1.8, name = "Candle2"}, -- base tier right
		{x = -1.2, y = 1.0, h = 1.6, name = "Candle3"}, -- mid tier left
		{x =  1.2, y = 1.0, h = 2.0, name = "Candle4"}, -- mid tier right
		{x =  0.0, y = 1.5, h = 1.4, name = "Candle5"}, -- top tier center-front
	}
	for i, c in candleData do
		local cz = (i == 5) and 0.0 or ((i % 2 == 0) and 1.3 or 1.3)
		if i == 3 or i == 4 then cz = 0.7 end
		-- Cream cylindrical wax body
		AB.cylinder(0.45, c.h, CREAM,
			AB.offset(originCF, c.x, c.y + c.h / 2, cz), model, c.name .. "_Body")
		-- Wick + flame
		local flame = AB.sphere(0.35, CANDLE_FLAME,
			AB.offset(originCF, c.x, c.y + c.h + 0.2, cz), model, c.name .. "_Flame")
		AB.neon(flame)
		AB.glow(flame, CANDLE_FLAME, 2.2)
		-- Tiny wick base
		AB.block(Vector3.new(0.06, 0.15, 0.06), PHOTO_DARK,
			AB.offset(originCF, c.x, c.y + c.h + 0.05, cz), model, c.name .. "_Wick")
	end

	-- Marigold petals scattered around the candles
	local petalSpots = {
		{-2.4, 0.55, 1.6}, {-2.0, 0.55, 0.8}, {2.2, 0.55, 1.7},
		{2.4, 0.55, 0.5}, {-0.6, 0.55, 1.8}, {0.6, 0.55, 1.8},
		{-1.5, 1.05, 0.6}, {1.5, 1.05, 0.6}, {-0.7, 1.55, 0.2}, {0.7, 1.55, 0.2},
	}
	for i, p in petalSpots do
		AB.sphere(0.32 + (i % 3) * 0.05, MARIGOLD,
			AB.offset(originCF, p[1], p[2], p[3]), model, "Petal_" .. i)
	end

	-- Small calavera skull on the middle tier
	local skull = AB.sphere(0.7, BONE_WHITE,
		AB.offset(originCF, -0.6, 1.4, 0.4), model, "Skull")
	AB.sphere(0.1, PHOTO_DARK,
		AB.offset(originCF, -0.75, 1.5, 0.75), model, "SkullEyeL")
	AB.sphere(0.1, PHOTO_DARK,
		AB.offset(originCF, -0.45, 1.5, 0.75), model, "SkullEyeR")
	AB.sphere(0.08, BOUG_PINK,
		AB.offset(originCF, -0.6, 1.75, 0.78), model, "SkullDot")

	-- Pan de muerto (small round bread, WOOD_DARK)
	AB.sphere(0.55, WOOD_DARK,
		AB.offset(originCF, 0.5, 1.55, 0.4), model, "PanDeMuerto")
	-- Bread cross detail on top
	AB.block(Vector3.new(0.5, 0.08, 0.1), CREAM,
		AB.offset(originCF, 0.5, 1.82, 0.4), model, "BreadCrossA")
	AB.block(Vector3.new(0.1, 0.08, 0.5), CREAM,
		AB.offset(originCF, 0.5, 1.82, 0.4), model, "BreadCrossB")

	-- Cup of water (cream cylinder)
	AB.cylinder(0.5, 0.7, CREAM,
		AB.offset(originCF, -2.0, 0.85, -0.3), model, "WaterCup")
	AB.cylinder(0.4, 0.1, AGAVE_TEAL,
		AB.offset(originCF, -2.0, 1.15, -0.3), model, "WaterTop")

	-- Tequila bottle (small dark cylinder)
	AB.cylinder(0.45, 1.2, PAPEL_GREEN,
		AB.offset(originCF, 2.0, 1.1, -0.3), model, "TequilaBody")
	AB.cylinder(0.25, 0.4, PAPEL_GREEN,
		AB.offset(originCF, 2.0, 1.85, -0.3), model, "TequilaNeck")
	AB.block(Vector3.new(0.4, 0.2, 0.05), CREAM,
		AB.offset(originCF, 2.0, 1.1, -0.07), model, "TequilaLabel")

	-- Papel picado banner draped above (3 mini colorful rectangles on a string)
	-- The string
	AB.cylinder(0.08, 4.5, WOOD_DARK,
		AB.offset(originCF, 0, 4.4, -1.45)
			* CFrame.Angles(0, 0, math.rad(90)), model, "BannerString")
	-- Hmm actually we want a horizontal string; cylinder rotates along X so just place it
	-- The 3 papel rectangles
	local bannerColors = {BOUG_PINK, FIESTA_YEL, AGAVE_TEAL}
	for i, c in bannerColors do
		local x = -1.4 + (i - 1) * 1.4
		AB.block(Vector3.new(1.0, 0.7, 0.04), c,
			AB.offset(originCF, x, 3.95, -1.42), model, "Papel_" .. i)
	end

	-- Small marigold cluster as a wreath piece on top tier
	for i = 1, 4 do
		local angle = (i - 1) * math.pi / 2
		AB.sphere(0.3, MARIGOLD,
			AB.offset(originCF, math.cos(angle) * 0.4, 4.6,
				-1.0 + math.sin(angle) * 0.4), model, "WreathBloom_" .. i)
	end

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
