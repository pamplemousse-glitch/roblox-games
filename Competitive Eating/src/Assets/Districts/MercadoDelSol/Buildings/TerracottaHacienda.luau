-- Terracotta Hacienda — wide backdrop building with overlapping clay tile roof,
-- wrought iron balcony, bougainvillea vine, big wooden double door, bell lantern.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local BOUG_PINK    = Color3.fromRGB(220, 80, 140)
local STUCCO_CREAM = Color3.fromRGB(245, 230, 200)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local ROOF_TILE    = Color3.fromRGB(140, 65, 40)
local ROOF_TILE_2  = Color3.fromRGB(120, 55, 35)
local IRON_BLACK   = Color3.fromRGB(30, 28, 28)
local STONE_GREY   = Color3.fromRGB(140, 130, 120)
local CANDLE_FLAME = Color3.fromRGB(255, 200, 90)
local GLASS_PANE   = Color3.fromRGB(170, 200, 220)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TerracottaHacienda", parent)

	-- Foundation slab
	AB.block(Vector3.new(30, 0.5, 20), Color3.fromRGB(150, 145, 140),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Stone foundation strip (visible base course)
	AB.block(Vector3.new(28, 1.4, 18.5), STONE_GREY,
		AB.offset(originCF, 0, 1.2, 0), model, "StoneBase")

	-- Terracotta stucco walls
	-- Front wall split for door cutout
	AB.block(Vector3.new(10, 16, 0.9), TERRACOTTA,
		AB.offset(originCF, -9, 9.9, 8.9), model, "FrontWallL")
	AB.block(Vector3.new(10, 16, 0.9), TERRACOTTA,
		AB.offset(originCF, 9, 9.9, 8.9), model, "FrontWallR")
	-- Door header
	AB.block(Vector3.new(8, 8, 0.9), TERRACOTTA,
		AB.offset(originCF, 0, 13.9, 8.9), model, "DoorHeader")

	-- Back + side walls
	AB.block(Vector3.new(28, 16, 0.9), TERRACOTTA,
		AB.offset(originCF, 0, 9.9, -8.9), model, "BackWall")
	AB.block(Vector3.new(0.9, 16, 18), TERRACOTTA,
		AB.offset(originCF, -13.9, 9.9, 0), model, "WallL")
	AB.block(Vector3.new(0.9, 16, 18), TERRACOTTA,
		AB.offset(originCF, 13.9, 9.9, 0), model, "WallR")

	-- Two front windows (split levels)
	-- Lower windows (one per side, between door and corner)
	for side, sx in {-1, 1} do
		AB.block(Vector3.new(3.2, 3, 0.4), Color3.fromRGB(40, 35, 30),
			AB.offset(originCF, sx * 9, 6, 8.7), model, "WinHole_" .. side)
		AB.block(Vector3.new(3.6, 0.3, 0.5), WOOD_DARK,
			AB.offset(originCF, sx * 9, 7.65, 8.65), model, "WinFrameTop_" .. side)
		AB.block(Vector3.new(3.6, 0.3, 0.5), WOOD_DARK,
			AB.offset(originCF, sx * 9, 4.35, 8.65), model, "WinFrameBot_" .. side)
		AB.part({size=Vector3.new(3.0, 2.8, 0.1), color=GLASS_PANE,
			cf=AB.offset(originCF, sx * 9, 6, 8.7),
			transparency=0.55, name="WinGlass_" .. side}, model)
		-- Cross mullion
		AB.block(Vector3.new(3.2, 0.12, 0.15), WOOD_DARK,
			AB.offset(originCF, sx * 9, 6, 8.55), model, "Mullion_" .. side)
		AB.block(Vector3.new(0.12, 3, 0.15), WOOD_DARK,
			AB.offset(originCF, sx * 9, 6, 8.55), model, "Mullion2_" .. side)
	end

	-- Upper windows (second story, smaller, paired with balcony)
	for side, sx in {-1, 1} do
		AB.block(Vector3.new(2.5, 2.5, 0.4), Color3.fromRGB(40, 35, 30),
			AB.offset(originCF, sx * 9, 13, 8.7), model, "UpperWinHole_" .. side)
		AB.block(Vector3.new(2.9, 0.3, 0.5), WOOD_DARK,
			AB.offset(originCF, sx * 9, 14.4, 8.65), model, "UpperWinTop_" .. side)
		AB.part({size=Vector3.new(2.3, 2.3, 0.1), color=GLASS_PANE,
			cf=AB.offset(originCF, sx * 9, 13, 8.7),
			transparency=0.55, name="UpperWinGlass_" .. side}, model)
	end

	-- Big wooden double door (carved-out cutout)
	AB.block(Vector3.new(8, 8, 0.3), Color3.fromRGB(40, 30, 25),
		AB.offset(originCF, 0, 5.9, 8.75), model, "DoorInterior")
	-- Two side-by-side dark wood door leaves
	AB.block(Vector3.new(3.7, 7.7, 0.3), WOOD_DARK,
		AB.offset(originCF, -1.9, 5.85, 8.7), model, "DoorLeafL")
	AB.block(Vector3.new(3.7, 7.7, 0.3), WOOD_DARK,
		AB.offset(originCF, 1.9, 5.85, 8.7), model, "DoorLeafR")
	-- Door planks
	for i = 1, 4 do
		AB.block(Vector3.new(7.8, 0.15, 0.1), Color3.fromRGB(70, 50, 30),
			AB.offset(originCF, 0, 2.5 + i * 1.5, 8.6), model, "DoorPlank_" .. i)
	end
	-- Iron door knockers / studs
	for i = 1, 6 do
		AB.sphere(0.3, IRON_BLACK,
			AB.offset(originCF, -3 + (i - 1) * 1.2, 5.8, 8.55), model, "DoorStud_" .. i)
	end

	-- CLAY TILE ROOF — 8-10 overlapping rows of thin tile blocks (scalloped look)
	for row = 1, 9 do
		local y = 18.5 + (row - 1) * 0.18
		local zOff = 9.8 - (row - 1) * 0.5
		local c = (row % 2 == 0) and ROOF_TILE_2 or ROOF_TILE
		-- Front-facing tile row
		AB.block(Vector3.new(30, 0.3, 1.2), c,
			AB.offset(originCF, 0, y, zOff), model, "RoofFR_" .. row)
		-- Back-facing tile row (mirror)
		AB.block(Vector3.new(30, 0.3, 1.2), c,
			AB.offset(originCF, 0, y, -zOff), model, "RoofBR_" .. row)
	end
	-- Roof eave overhang
	AB.block(Vector3.new(31, 0.4, 22), ROOF_TILE,
		AB.offset(originCF, 0, 18.2, 0), model, "RoofBase")
	-- Roof finial at peak
	AB.cylinder(0.6, 2, ROOF_TILE_2,
		AB.offset(originCF, 0, 21, 0), model, "FinialBase")
	local finial = AB.sphere(1.2, FIESTA_YEL,
		AB.offset(originCF, 0, 22.5, 0), model, "Finial")
	AB.neon(finial)
	AB.glow(finial, FIESTA_YEL, 1.2)

	-- WROUGHT IRON BALCONY on second story (thin black railings)
	-- Balcony floor
	AB.block(Vector3.new(20, 0.3, 2.5), WOOD_DARK,
		AB.offset(originCF, 0, 11.5, 10.2), model, "BalconyFloor")
	-- Front railing
	AB.block(Vector3.new(20, 0.15, 0.15), IRON_BLACK,
		AB.offset(originCF, 0, 12.7, 11.4), model, "BalconyRailTop")
	AB.block(Vector3.new(20, 0.15, 0.15), IRON_BLACK,
		AB.offset(originCF, 0, 11.7, 11.4), model, "BalconyRailBot")
	-- Vertical balusters
	for i = 1, 19 do
		AB.block(Vector3.new(0.12, 1.2, 0.12), IRON_BLACK,
			AB.offset(originCF, -9 + (i - 1) * 1, 12.2, 11.4), model, "Baluster_" .. i)
	end
	-- Side rails (short)
	for side, sx in {-1, 1} do
		AB.block(Vector3.new(0.15, 0.15, 2.5), IRON_BLACK,
			AB.offset(originCF, sx * 10, 12.7, 10.2), model, "BalconyRailSide_" .. side)
		AB.block(Vector3.new(0.15, 0.15, 2.5), IRON_BLACK,
			AB.offset(originCF, sx * 10, 11.7, 10.2), model, "BalconyRailSideB_" .. side)
		for i = 1, 3 do
			AB.block(Vector3.new(0.12, 1.2, 0.12), IRON_BLACK,
				AB.offset(originCF, sx * 10, 12.2, 9.2 + (i - 1) * 0.8), model,
				string.format("BalSideBal_%d_%d", side, i))
		end
	end
	-- Balcony brackets underneath
	for i = 1, 4 do
		AB.block(Vector3.new(0.4, 1, 0.4), WOOD_DARK,
			AB.offset(originCF, -7 + (i - 1) * 4.7, 10.8, 10), model, "BalconyBracket_" .. i)
	end

	-- BOUGAINVILLEA VINE on right wall (cluster of pink spheres)
	for i = 1, 22 do
		local y = 3 + i * 0.8
		local zVar = -6 + ((i * 1.3) % 13)
		AB.sphere(0.6 + ((i % 3) * 0.15), BOUG_PINK,
			AB.offset(originCF, 14.1, y, zVar), model, "Boug_" .. i)
	end
	-- Vine stems on the wall
	for i = 1, 4 do
		AB.block(Vector3.new(0.12, 12, 0.12), Color3.fromRGB(80, 100, 50),
			AB.offset(originCF, 14.1, 10, -3 + i * 1.5), model, "VineStem_" .. i)
	end
	-- A few green leaves mixed in
	for i = 1, 8 do
		AB.sphere(0.45, PAPEL_GREEN,
			AB.offset(originCF, 14.1, 5 + i * 1.4, -2 + (i * 1.7) % 8),
			model, "VineLeaf_" .. i)
	end

	-- BELL-SHAPED LANTERN at door (neon yellow)
	-- Hanging chain
	AB.block(Vector3.new(0.15, 1.5, 0.15), IRON_BLACK,
		AB.offset(originCF, 0, 13, 9.3), model, "LanternChain")
	-- Lantern cap (bell-shape top)
	AB.cylinder(1.2, 0.4, IRON_BLACK,
		AB.offset(originCF, 0, 12.3, 9.3), model, "LanternCap")
	-- Lantern body (vertical bars + dome bottom)
	for i = 1, 6 do
		local a = (i - 1) * math.pi / 3
		AB.block(Vector3.new(0.12, 1.6, 0.12), IRON_BLACK,
			AB.offset(originCF, math.cos(a) * 0.55, 11.5, 9.3 + math.sin(a) * 0.55),
			model, "LanternBar_" .. i)
	end
	-- Neon yellow flame inside
	local flame = AB.sphere(1.0, CANDLE_FLAME,
		AB.offset(originCF, 0, 11.5, 9.3), model, "LanternFlame")
	AB.neon(flame)
	AB.glow(flame, CANDLE_FLAME, 3)
	-- Bell tip at bottom
	AB.sphere(0.4, IRON_BLACK,
		AB.offset(originCF, 0, 10.5, 9.3), model, "LanternTip")

	-- Small courtyard wall extending out front (low decorative stucco wall U-shape)
	-- Front edge wall (low, leaving entry gap in middle)
	AB.block(Vector3.new(8, 3, 0.6), STUCCO_CREAM,
		AB.offset(originCF, -10, 2.5, 14), model, "CourtyardWallL")
	AB.block(Vector3.new(8, 3, 0.6), STUCCO_CREAM,
		AB.offset(originCF, 10, 2.5, 14), model, "CourtyardWallR")
	-- Side connecting walls
	AB.block(Vector3.new(0.6, 3, 5), STUCCO_CREAM,
		AB.offset(originCF, -13.7, 2.5, 11.5), model, "CourtSideL")
	AB.block(Vector3.new(0.6, 3, 5), STUCCO_CREAM,
		AB.offset(originCF, 13.7, 2.5, 11.5), model, "CourtSideR")
	-- Terracotta cap on courtyard walls
	AB.block(Vector3.new(8.2, 0.4, 0.8), TERRACOTTA,
		AB.offset(originCF, -10, 4.2, 14), model, "CourtCapL")
	AB.block(Vector3.new(8.2, 0.4, 0.8), TERRACOTTA,
		AB.offset(originCF, 10, 4.2, 14), model, "CourtCapR")

	-- Roof tile cap row (peak ridge)
	AB.block(Vector3.new(30, 0.5, 1), ROOF_TILE_2,
		AB.offset(originCF, 0, 20.3, 0), model, "RoofRidge")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
