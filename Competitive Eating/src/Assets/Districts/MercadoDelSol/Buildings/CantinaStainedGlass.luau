-- Cantina Stained Glass — backdrop building with arched stained-glass front
-- window, saloon doors, neon "CANTINA" sign, barrels, hitching post, wagon wheel.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local BOUG_PINK    = Color3.fromRGB(220, 80, 140)
local ADOBE_TAN    = Color3.fromRGB(220, 180, 130)
local STUCCO_CREAM = Color3.fromRGB(245, 230, 200)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local ROOF_TILE    = Color3.fromRGB(140, 65, 40)
local IRON_BLACK   = Color3.fromRGB(30, 28, 28)
local GLASS_PANE   = Color3.fromRGB(170, 200, 220)
local CANDLE_FLAME = Color3.fromRGB(255, 200, 90)
local BARREL_BAND  = Color3.fromRGB(60, 45, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CantinaStainedGlass", parent)

	-- Foundation
	AB.block(Vector3.new(24, 0.5, 16), Color3.fromRGB(150, 145, 140),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Walls (adobe tan)
	-- Front wall split for door + window
	AB.block(Vector3.new(7, 14, 0.8), ADOBE_TAN,
		AB.offset(originCF, -8.5, 7.5, 7), model, "FrontWallL")
	AB.block(Vector3.new(7, 14, 0.8), ADOBE_TAN,
		AB.offset(originCF, 8.5, 7.5, 7), model, "FrontWallR")
	-- Header above door
	AB.block(Vector3.new(10, 6, 0.8), ADOBE_TAN,
		AB.offset(originCF, 0, 11.5, 7), model, "FrontHeader")

	-- Back + side walls
	AB.block(Vector3.new(22, 14, 0.8), ADOBE_TAN,
		AB.offset(originCF, 0, 7.5, -7), model, "BackWall")
	AB.block(Vector3.new(0.8, 14, 14), ADOBE_TAN,
		AB.offset(originCF, -11, 7.5, 0), model, "WallL")
	AB.block(Vector3.new(0.8, 14, 14), ADOBE_TAN,
		AB.offset(originCF, 11, 7.5, 0), model, "WallR")

	-- Terracotta base trim
	AB.block(Vector3.new(22, 1, 0.9), TERRACOTTA,
		AB.offset(originCF, 0, 1, 7.05), model, "BaseTrimF")
	AB.block(Vector3.new(22, 1, 0.9), TERRACOTTA,
		AB.offset(originCF, 0, 1, -7.05), model, "BaseTrimB")

	-- LARGE ARCHED STAINED-GLASS WINDOW (upper front)
	-- Window frame (arched outline using base + top arch)
	AB.block(Vector3.new(8, 5, 0.4), WOOD_DARK,
		AB.offset(originCF, 0, 11, 6.85), model, "StainedFrame")
	-- Arch top using stacked blocks
	AB.block(Vector3.new(7, 1.2, 0.4), WOOD_DARK,
		AB.offset(originCF, 0, 13.8, 6.85), model, "ArchTier1")
	AB.block(Vector3.new(5.5, 1.2, 0.4), WOOD_DARK,
		AB.offset(originCF, 0, 14.6, 6.85), model, "ArchTier2")
	AB.block(Vector3.new(3.5, 1, 0.4), WOOD_DARK,
		AB.offset(originCF, 0, 15.3, 6.85), model, "ArchTier3")

	-- 8 colored panes in a grid (4 cols x 2 rows lower + arch panes)
	local paneColors = {FIESTA_YEL, BOUG_PINK, PAPEL_GREEN, AGAVE_TEAL,
		BOUG_PINK, FIESTA_YEL, AGAVE_TEAL, PAPEL_GREEN}
	for i, c in paneColors do
		local col = ((i - 1) % 4) + 1
		local row = (i <= 4) and 1 or 2
		local x = -2.7 + (col - 1) * 1.8
		local y = 9.5 + (row - 1) * 2
		local pane = AB.block(Vector3.new(1.5, 1.8, 0.15), c,
			AB.offset(originCF, x, y, 6.7), model, "StainedPane_" .. i)
		pane.Transparency = 0.35
		AB.neon(pane)
		if i % 3 == 0 then AB.glow(pane, c, 1.0) end
	end
	-- Arched top panes (smaller)
	for i = 1, 3 do
		local c = (i == 2) and FIESTA_YEL or (i == 1 and BOUG_PINK or PAPEL_GREEN)
		local pane = AB.block(Vector3.new(1.3, 1.2, 0.15), c,
			AB.offset(originCF, -1.6 + (i - 1) * 1.6, 14, 6.7), model, "StainedArchPane_" .. i)
		pane.Transparency = 0.35
		AB.neon(pane)
		AB.glow(pane, c, 1.2)
	end
	-- Lead came lines (thin dark grid)
	AB.block(Vector3.new(8, 0.1, 0.2), IRON_BLACK,
		AB.offset(originCF, 0, 10.5, 6.65), model, "LeadH1")
	AB.block(Vector3.new(8, 0.1, 0.2), IRON_BLACK,
		AB.offset(originCF, 0, 12.5, 6.65), model, "LeadH2")
	for i = 1, 3 do
		AB.block(Vector3.new(0.1, 4, 0.2), IRON_BLACK,
			AB.offset(originCF, -2.7 + i * 1.8, 11, 6.65), model, "LeadV_" .. i)
	end

	-- WOODEN SALOON SWINGING DOUBLE DOORS
	-- Door opening (dark interior)
	AB.block(Vector3.new(6, 7, 0.3), Color3.fromRGB(40, 30, 25),
		AB.offset(originCF, 0, 5, 6.95), model, "DoorInterior")
	-- Two narrow vertical leaves with horizontal slats
	for side, sx in {-1, 1} do
		-- Vertical frame
		AB.block(Vector3.new(0.3, 5, 0.25), WOOD_DARK,
			AB.offset(originCF, sx * 2.7, 4.5, 6.8), model, "DoorFrameV_" .. side)
		AB.block(Vector3.new(2.5, 0.25, 0.25), WOOD_DARK,
			AB.offset(originCF, sx * 1.55, 7, 6.8), model, "DoorFrameTop_" .. side)
		AB.block(Vector3.new(2.5, 0.25, 0.25), WOOD_DARK,
			AB.offset(originCF, sx * 1.55, 2, 6.8), model, "DoorFrameBot_" .. side)
		-- Horizontal slats (4 per door)
		for i = 1, 4 do
			AB.block(Vector3.new(2.2, 0.6, 0.18), WOOD_DARK,
				AB.offset(originCF, sx * 1.55, 2.5 + i * 1, 6.85), model,
				string.format("Slat_%d_%d", side, i))
		end
	end

	-- Awning above the door (red + cream striped)
	AB.block(Vector3.new(12, 0.4, 4), TERRACOTTA,
		AB.offset(originCF, 0, 8.5, 8.8), model, "AwningBase")
	for i = 1, 6 do
		AB.block(Vector3.new(1.9, 0.2, 3.8),
			(i % 2 == 0) and STUCCO_CREAM or TERRACOTTA,
			AB.offset(originCF, -5 + (i - 1) * 2, 8.75, 8.8), model, "AwningStripe_" .. i)
	end
	-- Awning fringe
	for i = 1, 7 do
		AB.block(Vector3.new(1.6, 0.5, 0.2), STUCCO_CREAM,
			AB.offset(originCF, -6 + (i - 1) * 2, 8.3, 10.6), model, "Fringe_" .. i)
	end

	-- "CANTINA" sign in neon (7 letters above awning)
	for i = 1, 7 do
		local c = (i % 2 == 0) and FIESTA_YEL or BOUG_PINK
		local letter = AB.block(Vector3.new(1.1, 1.6, 0.3), c,
			AB.offset(originCF, -4.5 + (i - 1) * 1.5, 16.5, 8), model, "Letter_" .. i)
		AB.neon(letter)
		AB.glow(letter, c, 1.5)
	end

	-- Side windows with translucent glass panels
	for side, sx in {-1, 1} do
		AB.block(Vector3.new(0.4, 3, 2.5), Color3.fromRGB(40, 35, 30),
			AB.offset(originCF, sx * 11, 8, -3), model, "SideWinHole_" .. side)
		AB.block(Vector3.new(0.5, 0.3, 2.9), WOOD_DARK,
			AB.offset(originCF, sx * 11, 9.65, -3), model, "SideWinTop_" .. side)
		AB.block(Vector3.new(0.5, 0.3, 2.9), WOOD_DARK,
			AB.offset(originCF, sx * 11, 6.35, -3), model, "SideWinBot_" .. side)
		AB.part({size=Vector3.new(0.1, 2.8, 2.3), color=GLASS_PANE,
			cf=AB.offset(originCF, sx * 11.05, 8, -3),
			transparency=0.55, name="SideWinGlass_" .. side}, model)
		-- Iron cross bar
		AB.block(Vector3.new(0.15, 0.1, 2.4), IRON_BLACK,
			AB.offset(originCF, sx * 10.9, 8, -3), model, "SideBarH_" .. side)
	end

	-- Lantern hanging from awning (neon)
	AB.block(Vector3.new(0.15, 1.5, 0.15), IRON_BLACK,
		AB.offset(originCF, 0, 7.8, 10), model, "LanternChain")
	for i = 1, 4 do
		local a = (i - 1) * math.pi / 2
		AB.block(Vector3.new(0.1, 1.4, 0.1), IRON_BLACK,
			AB.offset(originCF, math.cos(a) * 0.5, 6.6, 10 + math.sin(a) * 0.5),
			model, "LantBar_" .. i)
	end
	local lantern = AB.sphere(1.0, CANDLE_FLAME,
		AB.offset(originCF, 0, 6.6, 10), model, "LanternFlame")
	AB.neon(lantern)
	AB.glow(lantern, CANDLE_FLAME, 2.5)

	-- TWO WOODEN BARRELS on the side (cylinders with horizontal dark stripes)
	for i, x in {-9, 9} do
		local suffix = (x < 0) and "L" or "R"
		AB.cylinder(2.5, 3, WOOD_DARK,
			AB.offset(originCF, x, 1.8, 9), model, "Barrel_" .. suffix)
		-- Barrel bands (3 darker stripes)
		for b = 1, 3 do
			AB.cylinder(2.6, 0.3, BARREL_BAND,
				AB.offset(originCF, x, 0.5 + (b - 1) * 1.2, 9), model,
				string.format("BarrelBand_%s_%d", suffix, b))
		end
		-- Barrel top
		AB.cylinder(2.4, 0.2, Color3.fromRGB(140, 100, 60),
			AB.offset(originCF, x, 3.4, 9), model, "BarrelTop_" .. suffix)
	end

	-- Hitching post outside
	AB.block(Vector3.new(0.5, 3, 0.5), WOOD_DARK,
		AB.offset(originCF, -5, 1.7, 11), model, "HitchPostL")
	AB.block(Vector3.new(0.5, 3, 0.5), WOOD_DARK,
		AB.offset(originCF, 5, 1.7, 11), model, "HitchPostR")
	AB.block(Vector3.new(10.5, 0.3, 0.4), WOOD_DARK,
		AB.offset(originCF, 0, 3, 11), model, "HitchBar")

	-- WAGON WHEEL decoration on the wall (8 spokes radiating from a hub)
	AB.cylinder(2.6, 0.2, WOOD_DARK,
		AB.offset(originCF, -7, 6, -6.95), model, "WheelRim")
	AB.cylinder(2.2, 0.25, ADOBE_TAN,
		AB.offset(originCF, -7, 6, -6.92), model, "WheelInner")
	AB.cylinder(0.6, 0.3, WOOD_DARK,
		AB.offset(originCF, -7, 6, -6.85), model, "WheelHub")
	for i = 1, 8 do
		local a = (i - 1) * math.pi / 4
		AB.block(Vector3.new(0.15, 2.0, 0.15), WOOD_DARK,
			AB.offset(originCF, -7 + math.cos(a) * 1.0, 6 + math.sin(a) * 1.0, -6.9)
				* CFrame.Angles(0, 0, a),
			model, "Spoke_" .. i)
	end

	-- Flat roof with parapet
	AB.block(Vector3.new(24, 0.5, 16), ROOF_TILE,
		AB.offset(originCF, 0, 14.7, 0), model, "RoofSlab")
	AB.block(Vector3.new(24, 1.2, 0.5), ADOBE_TAN,
		AB.offset(originCF, 0, 15.6, 7), model, "ParapetF")
	AB.block(Vector3.new(24, 1.2, 0.5), ADOBE_TAN,
		AB.offset(originCF, 0, 15.6, -7), model, "ParapetB")
	AB.block(Vector3.new(0.5, 1.2, 16), ADOBE_TAN,
		AB.offset(originCF, -11.5, 15.6, 0), model, "ParapetL")
	AB.block(Vector3.new(0.5, 1.2, 16), ADOBE_TAN,
		AB.offset(originCF, 11.5, 15.6, 0), model, "ParapetR")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
