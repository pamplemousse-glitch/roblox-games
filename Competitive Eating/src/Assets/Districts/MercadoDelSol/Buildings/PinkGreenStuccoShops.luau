-- Pink+Green Stucco Shops — backdrop composite of two adjacent shop fronts.
-- One bougainvillea pink, one papel green. Each with door, windows, awnings,
-- display cases, neon signs.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local BOUG_PINK    = Color3.fromRGB(220, 80, 140)
local STUCCO_CREAM = Color3.fromRGB(245, 230, 200)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local ROOF_TILE    = Color3.fromRGB(140, 65, 40)
local GLASS_PANE   = Color3.fromRGB(170, 200, 220)
local IRON_BLACK   = Color3.fromRGB(30, 28, 28)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PinkGreenStuccoShops", parent)

	-- Foundation
	AB.block(Vector3.new(32, 0.5, 16), Color3.fromRGB(150, 145, 140),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Sidewalk strip at base (cream)
	AB.block(Vector3.new(31, 0.4, 3), STUCCO_CREAM,
		AB.offset(originCF, 0, 0.7, 7.5), model, "Sidewalk")

	-- Back wall (shared, internal to building)
	AB.block(Vector3.new(30, 14, 0.8), TERRACOTTA,
		AB.offset(originCF, 0, 7.5, -7), model, "BackWall")
	AB.block(Vector3.new(0.8, 14, 14), TERRACOTTA,
		AB.offset(originCF, -15, 7.5, 0), model, "WallL")
	AB.block(Vector3.new(0.8, 14, 14), TERRACOTTA,
		AB.offset(originCF, 15, 7.5, 0), model, "WallR")

	-- ─── LEFT SHOP (BOUG_PINK) ─────────────────────────────────────────────
	-- Front wall sections (left of door, right of door)
	AB.block(Vector3.new(4, 14, 0.8), BOUG_PINK,
		AB.offset(originCF, -13, 7.5, 7), model, "PinkWallL")
	AB.block(Vector3.new(3.5, 14, 0.8), BOUG_PINK,
		AB.offset(originCF, -7.25, 7.5, 7), model, "PinkWallR")
	-- Pink front center upper above door
	AB.block(Vector3.new(7.5, 5, 0.8), BOUG_PINK,
		AB.offset(originCF, -9.25, 12, 7), model, "PinkUpperFront")
	-- Door cutout (interior dark)
	AB.block(Vector3.new(3, 9, 0.3), Color3.fromRGB(40, 30, 25),
		AB.offset(originCF, -9.25, 5, 6.9), model, "PinkDoorInt")
	-- Door leaf
	AB.block(Vector3.new(2.7, 8.5, 0.25), WOOD_DARK,
		AB.offset(originCF, -9.25, 4.75, 6.85), model, "PinkDoor")
	AB.block(Vector3.new(0.3, 0.3, 0.3), FIESTA_YEL,
		AB.offset(originCF, -8.2, 4.75, 6.75), model, "PinkDoorKnob")

	-- 2 window cutouts on pink shop (left + right of door)
	for i, x in {-12, -6.5} do
		AB.block(Vector3.new(2.5, 3, 0.4), Color3.fromRGB(40, 35, 30),
			AB.offset(originCF, x, 7, 6.9), model, "PinkWinHole_" .. i)
		AB.block(Vector3.new(2.9, 0.3, 0.5), WOOD_DARK,
			AB.offset(originCF, x, 8.65, 6.85), model, "PinkWinTop_" .. i)
		AB.block(Vector3.new(2.9, 0.3, 0.5), WOOD_DARK,
			AB.offset(originCF, x, 5.35, 6.85), model, "PinkWinBot_" .. i)
		AB.part({size=Vector3.new(2.3, 2.8, 0.1), color=GLASS_PANE,
			cf=AB.offset(originCF, x, 7, 6.92),
			transparency=0.55, name="PinkWinGlass_" .. i}, model)
		-- Visible inventory inside (small colored objects)
		AB.sphere(0.4, FIESTA_YEL,
			AB.offset(originCF, x - 0.5, 6.5, 6.5), model, "PinkInv_" .. i .. "_A")
		AB.block(Vector3.new(0.4, 0.6, 0.4), AGAVE_TEAL,
			AB.offset(originCF, x + 0.5, 6.5, 6.5), model, "PinkInv_" .. i .. "_B")
		AB.block(Vector3.new(0.5, 0.5, 0.3), PAPEL_GREEN,
			AB.offset(originCF, x, 7.2, 6.5), model, "PinkInv_" .. i .. "_C")
	end

	-- Pink-cream striped awning
	AB.block(Vector3.new(13, 0.4, 3), BOUG_PINK,
		AB.offset(originCF, -9.25, 10.5, 8.6), model, "PinkAwningBase")
	for i = 1, 6 do
		AB.block(Vector3.new(2, 0.2, 2.8),
			(i % 2 == 0) and STUCCO_CREAM or BOUG_PINK,
			AB.offset(originCF, -14.5 + (i - 1) * 2.1, 10.75, 8.6), model,
			"PinkStripe_" .. i)
	end
	-- Awning fringe
	for i = 1, 7 do
		AB.block(Vector3.new(1.6, 0.5, 0.2), STUCCO_CREAM,
			AB.offset(originCF, -15 + (i - 1) * 2, 10.3, 10), model, "PinkFringe_" .. i)
	end

	-- "MERCADO" neon sign on the pink side (7 letters)
	for i = 1, 7 do
		local letter = AB.block(Vector3.new(1.1, 1.4, 0.2), FIESTA_YEL,
			AB.offset(originCF, -13 + (i - 1) * 1.3, 13, 6.7), model, "MercadoLetter_" .. i)
		AB.neon(letter)
		if i % 2 == 0 then AB.glow(letter, FIESTA_YEL, 1.4) end
	end

	-- 2 potted plants flanking pink entrance
	for i, x in {-12.5, -6} do
		local suffix = (x < -10) and "L" or "R"
		AB.cylinder(1.4, 1.2, TERRACOTTA,
			AB.offset(originCF, x, 1.4, 8.5), model, "PinkPot_" .. suffix)
		for j = 1, 4 do
			AB.sphere(0.5, PAPEL_GREEN,
				AB.offset(originCF, x + math.cos(j) * 0.4, 2.2 + (j % 2) * 0.2, 8.5 + math.sin(j) * 0.4),
				model, string.format("PinkPlant_%s_%d", suffix, j))
		end
	end

	-- ─── SEPARATING PILASTER (cream stucco) ────────────────────────────────
	AB.block(Vector3.new(2, 16, 1.2), STUCCO_CREAM,
		AB.offset(originCF, 0, 8.5, 7), model, "Pilaster")
	-- Pilaster cap (terracotta)
	AB.block(Vector3.new(2.4, 0.5, 1.4), TERRACOTTA,
		AB.offset(originCF, 0, 16.75, 7), model, "PilasterCap")
	AB.block(Vector3.new(2.4, 0.3, 1.4), TERRACOTTA,
		AB.offset(originCF, 0, 1.5, 7), model, "PilasterBase")

	-- ─── RIGHT SHOP (PAPEL_GREEN) ──────────────────────────────────────────
	AB.block(Vector3.new(3.5, 14, 0.8), PAPEL_GREEN,
		AB.offset(originCF, 7.25, 7.5, 7), model, "GreenWallL")
	AB.block(Vector3.new(4, 14, 0.8), PAPEL_GREEN,
		AB.offset(originCF, 13, 7.5, 7), model, "GreenWallR")
	AB.block(Vector3.new(7.5, 5, 0.8), PAPEL_GREEN,
		AB.offset(originCF, 9.25, 12, 7), model, "GreenUpperFront")
	-- Green door
	AB.block(Vector3.new(3, 9, 0.3), Color3.fromRGB(40, 30, 25),
		AB.offset(originCF, 9.25, 5, 6.9), model, "GreenDoorInt")
	AB.block(Vector3.new(2.7, 8.5, 0.25), WOOD_DARK,
		AB.offset(originCF, 9.25, 4.75, 6.85), model, "GreenDoor")
	AB.block(Vector3.new(0.3, 0.3, 0.3), FIESTA_YEL,
		AB.offset(originCF, 10.3, 4.75, 6.75), model, "GreenDoorKnob")

	-- 2 window cutouts on green shop
	for i, x in {6.5, 12} do
		AB.block(Vector3.new(2.5, 3, 0.4), Color3.fromRGB(40, 35, 30),
			AB.offset(originCF, x, 7, 6.9), model, "GreenWinHole_" .. i)
		AB.block(Vector3.new(2.9, 0.3, 0.5), WOOD_DARK,
			AB.offset(originCF, x, 8.65, 6.85), model, "GreenWinTop_" .. i)
		AB.block(Vector3.new(2.9, 0.3, 0.5), WOOD_DARK,
			AB.offset(originCF, x, 5.35, 6.85), model, "GreenWinBot_" .. i)
		AB.part({size=Vector3.new(2.3, 2.8, 0.1), color=GLASS_PANE,
			cf=AB.offset(originCF, x, 7, 6.92),
			transparency=0.55, name="GreenWinGlass_" .. i}, model)
		-- Visible inventory (artesania = woven crafts, pottery)
		AB.cylinder(0.6, 0.8, TERRACOTTA,
			AB.offset(originCF, x - 0.5, 6.5, 6.5), model, "GreenInv_" .. i .. "_A")
		AB.sphere(0.5, BOUG_PINK,
			AB.offset(originCF, x + 0.5, 6.5, 6.5), model, "GreenInv_" .. i .. "_B")
		AB.block(Vector3.new(0.4, 0.6, 0.3), AGAVE_TEAL,
			AB.offset(originCF, x, 7.2, 6.5), model, "GreenInv_" .. i .. "_C")
	end

	-- Green-cream striped awning
	AB.block(Vector3.new(13, 0.4, 3), PAPEL_GREEN,
		AB.offset(originCF, 9.25, 10.5, 8.6), model, "GreenAwningBase")
	for i = 1, 6 do
		AB.block(Vector3.new(2, 0.2, 2.8),
			(i % 2 == 0) and STUCCO_CREAM or PAPEL_GREEN,
			AB.offset(originCF, 4 + (i - 1) * 2.1, 10.75, 8.6), model,
			"GreenStripe_" .. i)
	end
	for i = 1, 7 do
		AB.block(Vector3.new(1.6, 0.5, 0.2), STUCCO_CREAM,
			AB.offset(originCF, 3.5 + (i - 1) * 2, 10.3, 10), model, "GreenFringe_" .. i)
	end

	-- "ARTESANIA" neon sign on green side (using 7 visible letter blocks)
	for i = 1, 7 do
		local letter = AB.block(Vector3.new(1.1, 1.4, 0.2), BOUG_PINK,
			AB.offset(originCF, 5 + (i - 1) * 1.3, 13, 6.7), model, "ArtesaniaLetter_" .. i)
		AB.neon(letter)
		if i % 2 == 0 then AB.glow(letter, BOUG_PINK, 1.4) end
	end

	-- 2 potted plants flanking green entrance
	for i, x in {6, 12.5} do
		local suffix = (x < 8) and "L" or "R"
		AB.cylinder(1.4, 1.2, TERRACOTTA,
			AB.offset(originCF, x, 1.4, 8.5), model, "GreenPot_" .. suffix)
		for j = 1, 4 do
			AB.sphere(0.5, BOUG_PINK,
				AB.offset(originCF, x + math.cos(j) * 0.4, 2.2 + (j % 2) * 0.2, 8.5 + math.sin(j) * 0.4),
				model, string.format("GreenFlower_%s_%d", suffix, j))
		end
	end

	-- Roof parapet with terracotta tile cap (whole building)
	AB.block(Vector3.new(31, 0.5, 16), STUCCO_CREAM,
		AB.offset(originCF, 0, 14.7, 0), model, "RoofSlab")
	AB.block(Vector3.new(31, 1.2, 0.6), STUCCO_CREAM,
		AB.offset(originCF, 0, 15.6, 7), model, "ParapetF")
	AB.block(Vector3.new(31, 1.2, 0.6), STUCCO_CREAM,
		AB.offset(originCF, 0, 15.6, -7), model, "ParapetB")
	-- Terracotta tile cap on parapet
	AB.block(Vector3.new(31, 0.4, 0.9), ROOF_TILE,
		AB.offset(originCF, 0, 16.4, 7), model, "ParapetCapF")
	AB.block(Vector3.new(31, 0.4, 0.9), ROOF_TILE,
		AB.offset(originCF, 0, 16.4, -7), model, "ParapetCapB")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
