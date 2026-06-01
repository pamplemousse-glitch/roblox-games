-- Marigold Flower Arch — Día de Muertos style decorative arch with two cream
-- stucco pillars, a wooden top beam laden with dense marigold blooms, ribbon
-- banners hanging down, candle tealights at the base, and small calavera
-- skulls mounted at mid-pillar height.

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
local SKULL_DOT    = Color3.fromRGB(40, 40, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MarigoldFlowerArch", parent)

	-- Two cream stucco pillars (slightly tapered look using stacked blocks)
	local pillarX = 4
	local leftPillar = AB.block(Vector3.new(1.4, 10, 1.4), CREAM,
		AB.offset(originCF, -pillarX, 5, 0), model, "PillarL")
	AB.block(Vector3.new(1.4, 10, 1.4), CREAM,
		AB.offset(originCF, pillarX, 5, 0), model, "PillarR")

	-- Pillar caps (terracotta tops)
	AB.block(Vector3.new(1.8, 0.4, 1.8), TERRACOTTA,
		AB.offset(originCF, -pillarX, 10.2, 0), model, "CapL")
	AB.block(Vector3.new(1.8, 0.4, 1.8), TERRACOTTA,
		AB.offset(originCF, pillarX, 10.2, 0), model, "CapR")

	-- Pillar bases (terracotta foot)
	AB.block(Vector3.new(1.8, 0.5, 1.8), TERRACOTTA,
		AB.offset(originCF, -pillarX, 0.25, 0), model, "BaseL")
	AB.block(Vector3.new(1.8, 0.5, 1.8), TERRACOTTA,
		AB.offset(originCF, pillarX, 0.25, 0), model, "BaseR")

	-- Top horizontal beam (WOOD_DARK)
	AB.block(Vector3.new(10, 0.8, 1), WOOD_DARK,
		AB.offset(originCF, 0, 10.8, 0), model, "TopBeam")
	-- Beam underglow trim
	AB.block(Vector3.new(10.2, 0.3, 1.1), TERRACOTTA,
		AB.offset(originCF, 0, 10.3, 0), model, "BeamTrim")

	-- Marigold cluster across the top beam — dense lush curtain
	-- Top row (18 blooms in a slight arc)
	for i = 1, 18 do
		local t = (i - 1) / 17
		local x = -4.5 + t * 9
		-- arc bulge upward in the middle, dip slightly at ends
		local y = 11.4 + math.sin(t * math.pi) * 0.5
		local z = (i % 2 == 0) and 0.3 or -0.3
		local d = 0.7 + ((i % 3) * 0.1)
		AB.sphere(d, MARIGOLD,
			AB.offset(originCF, x, y, z), model, "Marigold_" .. i)
	end

	-- Side cascading marigolds dropping down each pillar
	for i = 1, 6 do
		local drop = i * 1.2
		AB.sphere(0.7, MARIGOLD,
			AB.offset(originCF, -pillarX + 0.6, 10.6 - drop, 0.2), model, "CascadeL_" .. i)
		AB.sphere(0.7, MARIGOLD,
			AB.offset(originCF, pillarX - 0.6, 10.6 - drop, 0.2), model, "CascadeR_" .. i)
	end

	-- FIESTA_YEL accent flowers tucked into the marigold (neon for night)
	for i = 1, 6 do
		local x = -3.5 + (i - 1) * 1.4
		local accent = AB.sphere(0.5, FIESTA_YEL,
			AB.offset(originCF, x, 11.7, 0.5), model, "YellowAccent_" .. i)
		if i == 3 or i == 4 then
			AB.neon(accent)
			AB.glow(accent, FIESTA_YEL, 1.2)
		end
	end

	-- Ribbon banners hanging from the top beam
	local ribbonColors = {BOUG_PINK, FIESTA_YEL, AGAVE_TEAL, BOUG_PINK, FIESTA_YEL}
	for i, c in ribbonColors do
		local x = -3.6 + (i - 1) * 1.8
		AB.block(Vector3.new(0.4, 3.5, 0.05), c,
			AB.offset(originCF, x, 8.8, 0.45), model, "Ribbon_" .. i)
		-- Tiny knot at the top of each ribbon
		AB.sphere(0.25, c,
			AB.offset(originCF, x, 10.4, 0.45), model, "RibbonKnot_" .. i)
	end

	-- Candle tealights at the foot of each pillar (terracotta cup + neon flame)
	for side, sx in {-1, 1} do
		AB.cylinder(0.7, 0.4, TERRACOTTA,
			AB.offset(originCF, sx * pillarX, 0.7, 1.3), model, "Tealight_" .. side)
		local flame = AB.sphere(0.45, CANDLE_FLAME,
			AB.offset(originCF, sx * pillarX, 1.15, 1.3), model, "Flame_" .. side)
		AB.neon(flame)
		AB.glow(flame, CANDLE_FLAME, 2.5)
		-- Second tealight on opposite side of pillar foot
		AB.cylinder(0.7, 0.4, TERRACOTTA,
			AB.offset(originCF, sx * pillarX, 0.7, -1.3), model, "TealightBack_" .. side)
		local flameB = AB.sphere(0.4, CANDLE_FLAME,
			AB.offset(originCF, sx * pillarX, 1.1, -1.3), model, "FlameBack_" .. side)
		AB.neon(flameB)
		AB.glow(flameB, CANDLE_FLAME, 1.8)
	end

	-- Small calavera skulls at mid-pillar height (white sphere with dot details)
	for side, sx in {-1, 1} do
		local skull = AB.sphere(1.1, BONE_WHITE,
			AB.offset(originCF, sx * pillarX, 5.5, 0.9), model, "Skull_" .. side)
		-- Eye dots
		AB.sphere(0.18, SKULL_DOT,
			AB.offset(originCF, sx * pillarX - 0.25, 5.65, 1.4), model, "SkullEyeL_" .. side)
		AB.sphere(0.18, SKULL_DOT,
			AB.offset(originCF, sx * pillarX + 0.25, 5.65, 1.4), model, "SkullEyeR_" .. side)
		-- Painted floral dot on forehead (pink)
		AB.sphere(0.15, BOUG_PINK,
			AB.offset(originCF, sx * pillarX, 6.0, 1.4), model, "SkullForehead_" .. side)
		-- Tiny jaw line
		AB.block(Vector3.new(0.5, 0.1, 0.05), SKULL_DOT,
			AB.offset(originCF, sx * pillarX, 5.2, 1.45), model, "SkullJaw_" .. side)
	end

	AB.pivot(model, leftPillar)
	AB.weldAll(model)
	return model
end
