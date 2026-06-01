-- Fountain Courtyard — central tiered fountain inside a U-shaped courtyard
-- wall with 3 arched alcoves (Virgin Mary, candle altar, marigold display),
-- tiled mosaic floor, benches.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local BOUG_PINK    = Color3.fromRGB(220, 80, 140)
local STUCCO_CREAM = Color3.fromRGB(245, 230, 200)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local ROOF_TILE    = Color3.fromRGB(140, 65, 40)
local CANDLE_FLAME = Color3.fromRGB(255, 200, 90)
local ROBE_WHITE   = Color3.fromRGB(245, 240, 230)
local ROBE_BLUE    = Color3.fromRGB(70, 100, 180)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("FountainCourtyard", parent)

	-- Foundation
	AB.block(Vector3.new(24, 0.4, 20), Color3.fromRGB(150, 145, 140),
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")

	-- TILE MOSAIC FLOOR (cream + terracotta checker pattern, 4x3 = 12 tiles)
	for r = 1, 3 do
		for c = 1, 4 do
			local x = -7.5 + (c - 1) * 5
			local z = -5 + (r - 1) * 5
			local color = ((r + c) % 2 == 0) and STUCCO_CREAM or TERRACOTTA
			AB.block(Vector3.new(4.5, 0.2, 4.5), color,
				AB.offset(originCF, x, 0.55, z), model, string.format("FloorTile_%d_%d", r, c))
		end
	end

	-- U-SHAPED COURTYARD WALL (3 walls)
	-- Back wall
	AB.block(Vector3.new(22, 4, 0.8), STUCCO_CREAM,
		AB.offset(originCF, 0, 2.4, -8), model, "BackWall")
	-- Left wall
	AB.block(Vector3.new(0.8, 4, 16), STUCCO_CREAM,
		AB.offset(originCF, -11, 2.4, -0.4), model, "WallL")
	-- Right wall
	AB.block(Vector3.new(0.8, 4, 16), STUCCO_CREAM,
		AB.offset(originCF, 11, 2.4, -0.4), model, "WallR")

	-- Terracotta cap on courtyard walls
	AB.block(Vector3.new(22, 0.4, 1), TERRACOTTA,
		AB.offset(originCF, 0, 4.6, -8), model, "BackCap")
	AB.block(Vector3.new(1, 0.4, 16), TERRACOTTA,
		AB.offset(originCF, -11, 4.6, -0.4), model, "CapL")
	AB.block(Vector3.new(1, 0.4, 16), TERRACOTTA,
		AB.offset(originCF, 11, 4.6, -0.4), model, "CapR")

	-- 3 ARCHED ALCOVES carved into the back wall
	-- Alcove dimensions: 4w x 3t x 0.5d
	local alcovePositions = {-7, 0, 7}
	for i, x in alcovePositions do
		-- Alcove interior (slightly recessed dark block)
		AB.block(Vector3.new(3.5, 3, 0.4), Color3.fromRGB(50, 45, 40),
			AB.offset(originCF, x, 2.4, -7.7), model, "AlcoveInt_" .. i)
		-- Alcove arch top (using stacked blocks for curve)
		AB.block(Vector3.new(3.7, 0.3, 0.6), STUCCO_CREAM,
			AB.offset(originCF, x, 4.05, -7.8), model, "AlcoveArchTop_" .. i)
		AB.block(Vector3.new(2.5, 0.3, 0.6), STUCCO_CREAM,
			AB.offset(originCF, x, 4.25, -7.8), model, "AlcoveArchMid_" .. i)
		-- Arch wedges for curve
		AB.wedge(Vector3.new(0.6, 0.4, 0.6), STUCCO_CREAM,
			AB.offset(originCF, x - 1.4, 3.9, -7.8) * CFrame.Angles(0, 0, math.rad(-90)),
			model, "AlcoveArchWedgeL_" .. i)
		AB.wedge(Vector3.new(0.6, 0.4, 0.6), STUCCO_CREAM,
			AB.offset(originCF, x + 1.4, 3.9, -7.8) * CFrame.Angles(0, 0, math.rad(90)),
			model, "AlcoveArchWedgeR_" .. i)
	end

	-- Alcove 1 (LEFT): VIRGIN MARY STATUE
	-- Robe body (white)
	AB.cylinder(1.4, 2.4, ROBE_WHITE,
		AB.offset(originCF, -7, 2, -7.6), model, "MaryRobe")
	-- Blue robe overlay (top half)
	AB.block(Vector3.new(1.5, 1.6, 0.6), ROBE_BLUE,
		AB.offset(originCF, -7, 2.6, -7.5), model, "MaryShawl")
	-- Head
	AB.sphere(0.9, Color3.fromRGB(220, 190, 160),
		AB.offset(originCF, -7, 3.7, -7.6), model, "MaryHead")
	-- Halo (neon yellow ring suggested with sphere)
	local halo = AB.sphere(1.1, FIESTA_YEL,
		AB.offset(originCF, -7, 4.2, -7.6), model, "MaryHalo")
	AB.neon(halo)
	halo.Transparency = 0.4
	AB.glow(halo, FIESTA_YEL, 1.5)

	-- Alcove 2 (CENTER): CANDLE ALTAR
	-- Altar base
	AB.block(Vector3.new(2.5, 1, 0.8), WOOD_DARK,
		AB.offset(originCF, 0, 1.4, -7.5), model, "AltarBase")
	-- 5 candles of varied heights
	for i = 1, 5 do
		local cx = -0.8 + (i - 1) * 0.4
		local h = 1.2 + (i % 3) * 0.4
		AB.cylinder(0.25, h, STUCCO_CREAM,
			AB.offset(originCF, cx, 1.9 + h / 2, -7.5), model, "Candle_" .. i)
		-- Flame
		local flame = AB.sphere(0.35, CANDLE_FLAME,
			AB.offset(originCF, cx, 1.9 + h + 0.2, -7.5), model, "CandleFlame_" .. i)
		AB.neon(flame)
		if i % 2 == 1 then AB.glow(flame, CANDLE_FLAME, 1.8) end
	end
	-- Small cross above altar
	AB.block(Vector3.new(0.15, 1.2, 0.15), WOOD_DARK,
		AB.offset(originCF, 0, 3.8, -7.5), model, "AltarCrossV")
	AB.block(Vector3.new(0.7, 0.15, 0.15), WOOD_DARK,
		AB.offset(originCF, 0, 4.0, -7.5), model, "AltarCrossH")

	-- Alcove 3 (RIGHT): MARIGOLD DISPLAY
	-- Large terracotta pot
	AB.cylinder(2, 1.6, TERRACOTTA,
		AB.offset(originCF, 7, 1.6, -7.5), model, "MarigoldPot")
	AB.cylinder(2.2, 0.3, Color3.fromRGB(160, 75, 30),
		AB.offset(originCF, 7, 2.5, -7.5), model, "MarigoldPotRim")
	-- Marigold flowers (cluster of orange/yellow spheres)
	for i = 1, 12 do
		local a = (i / 12) * math.pi * 2
		local r = 0.8 + (i % 3) * 0.2
		local c = (i % 2 == 0) and FIESTA_YEL or TERRACOTTA
		AB.sphere(0.55, c,
			AB.offset(originCF, 7 + math.cos(a) * r, 3.0 + (i % 4) * 0.25, -7.5 + math.sin(a) * r * 0.4),
			model, "Marigold_" .. i)
	end
	-- Top marigold cluster
	for i = 1, 5 do
		AB.sphere(0.6, FIESTA_YEL,
			AB.offset(originCF, 7 + math.cos(i) * 0.3, 4 + (i % 2) * 0.2, -7.5),
			model, "MarigoldTop_" .. i)
	end

	-- CENTRAL FOUNTAIN (stepped circular tiers)
	-- Bottom tier 12 wide x 1 tall
	AB.cylinder(12, 1, STUCCO_CREAM,
		AB.offset(originCF, 0, 1, 2), model, "FountainBottom")
	-- Bottom tier water (agave teal)
	AB.cylinder(11, 0.4, AGAVE_TEAL,
		AB.offset(originCF, 0, 1.4, 2), model, "FountainBottomWater")
	-- Middle tier 8 wide x 1 tall
	AB.cylinder(8, 1, STUCCO_CREAM,
		AB.offset(originCF, 0, 2, 2), model, "FountainMiddle")
	AB.cylinder(7, 0.4, AGAVE_TEAL,
		AB.offset(originCF, 0, 2.4, 2), model, "FountainMiddleWater")
	-- Top tier 4 wide x 1 tall
	AB.cylinder(4, 1, STUCCO_CREAM,
		AB.offset(originCF, 0, 3, 2), model, "FountainTop")
	AB.cylinder(3, 0.4, AGAVE_TEAL,
		AB.offset(originCF, 0, 3.4, 2), model, "FountainTopWater")
	-- Bottom rim accent (terracotta band)
	AB.cylinder(12.2, 0.25, TERRACOTTA,
		AB.offset(originCF, 0, 0.5, 2), model, "FountainBottomRim")

	-- Center spout (small cylindrical post)
	AB.cylinder(0.8, 1.2, WOOD_DARK,
		AB.offset(originCF, 0, 4.0, 2), model, "FountainSpoutPost")
	-- Neon teal water "spurt" — thin translucent neon cylinder upright
	local spurt = AB.cylinder(0.6, 4, AGAVE_TEAL,
		AB.offset(originCF, 0, 6.5, 2), model, "WaterSpurt")
	AB.neon(spurt)
	spurt.Transparency = 0.3
	AB.glow(spurt, AGAVE_TEAL, 2)

	-- 4 small neon water droplets floating around the spurt
	for i = 1, 4 do
		local a = (i - 1) * math.pi / 2
		local drop = AB.sphere(0.4, AGAVE_TEAL,
			AB.offset(originCF, math.cos(a) * 1.2, 7 + (i % 2) * 0.5, 2 + math.sin(a) * 1.2),
			model, "Droplet_" .. i)
		AB.neon(drop)
		drop.Transparency = 0.3
		if i == 1 then AB.glow(drop, AGAVE_TEAL, 1.2) end
	end

	-- More small splash droplets at base
	for i = 1, 8 do
		local a = (i - 1) * math.pi / 4
		local drop = AB.sphere(0.3, AGAVE_TEAL,
			AB.offset(originCF, math.cos(a) * 4, 1.8 + (i % 2) * 0.3, 2 + math.sin(a) * 4),
			model, "Splash_" .. i)
		AB.neon(drop)
		drop.Transparency = 0.4
	end

	-- TWO BENCHES inside the courtyard (against side walls)
	for side, sx in {-1, 1} do
		-- Bench seat
		AB.block(Vector3.new(0.8, 0.3, 4), WOOD_DARK,
			AB.offset(originCF, sx * 9, 1.5, 4), model, "BenchSeat_" .. side)
		-- Bench back
		AB.block(Vector3.new(0.4, 1.5, 4), WOOD_DARK,
			AB.offset(originCF, sx * 9.4, 2.4, 4), model, "BenchBack_" .. side)
		-- Bench legs (4 short)
		for j = 1, 4 do
			local zL = 2.5 + (j - 1) * 1
			AB.block(Vector3.new(0.6, 1.3, 0.4), STUCCO_CREAM,
				AB.offset(originCF, sx * 9, 0.95, zL), model,
				string.format("BenchLeg_%d_%d", side, j))
		end
	end

	-- Bougainvillea trailing over courtyard walls (decorative)
	for i = 1, 12 do
		local x = -10 + (i / 12) * 20
		AB.sphere(0.5 + ((i % 3) * 0.1), BOUG_PINK,
			AB.offset(originCF, x, 4.8 + (i % 3) * 0.3, -7.5 + math.sin(i) * 0.3),
			model, "WallBoug_" .. i)
	end

	-- Wall pillars at the U-opening corners (front of side walls)
	for side, sx in {-1, 1} do
		AB.block(Vector3.new(1.4, 5, 1.4), STUCCO_CREAM,
			AB.offset(originCF, sx * 10.5, 2.7, 7.4), model, "EntryPillar_" .. side)
		-- Pillar cap
		AB.block(Vector3.new(1.8, 0.4, 1.8), TERRACOTTA,
			AB.offset(originCF, sx * 10.5, 5.4, 7.4), model, "EntryPillarCap_" .. side)
		-- Pillar lantern (neon)
		local lant = AB.sphere(0.8, CANDLE_FLAME,
			AB.offset(originCF, sx * 10.5, 6.3, 7.4), model, "EntryLantern_" .. side)
		AB.neon(lant)
		AB.glow(lant, CANDLE_FLAME, 2)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
