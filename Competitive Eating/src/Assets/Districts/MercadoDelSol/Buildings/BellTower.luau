-- Bell Tower — tall mission-style bell tower backdrop.
-- Square base, open belfry with bronze bell, clay tile pyramid roof,
-- iron cross at top, quatrefoil window, neon lanterns, bougainvillea vine.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local BOUG_PINK    = Color3.fromRGB(220, 80, 140)
local STUCCO_CREAM = Color3.fromRGB(245, 230, 200)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local ROOF_TILE    = Color3.fromRGB(140, 65, 40)
local IRON_BLACK   = Color3.fromRGB(30, 28, 28)
local BRONZE       = Color3.fromRGB(130, 80, 40)
local BRONZE_LIGHT = Color3.fromRGB(170, 110, 60)
local CANDLE_FLAME = Color3.fromRGB(255, 200, 90)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BellTower", parent)

	-- Foundation slab
	AB.block(Vector3.new(10, 0.5, 10), Color3.fromRGB(150, 145, 140),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- LOWER SECTION (square, 12 studs tall)
	-- Four walls
	AB.block(Vector3.new(8, 12, 0.8), STUCCO_CREAM,
		AB.offset(originCF, 0, 6.5, -4), model, "LowerWallB")
	AB.block(Vector3.new(8, 12, 0.8), STUCCO_CREAM,
		AB.offset(originCF, 0, 6.5, 4), model, "LowerWallF")
	AB.block(Vector3.new(0.8, 12, 8), STUCCO_CREAM,
		AB.offset(originCF, -4, 6.5, 0), model, "LowerWallL")
	AB.block(Vector3.new(0.8, 12, 8), STUCCO_CREAM,
		AB.offset(originCF, 4, 6.5, 0), model, "LowerWallR")

	-- Carved entry door at the bottom (cut into front wall)
	-- Cut by overlay: dark door interior block
	AB.block(Vector3.new(3, 5, 0.4), Color3.fromRGB(40, 30, 25),
		AB.offset(originCF, 0, 3, 4), model, "DoorInterior")
	-- Wooden door leaf
	AB.block(Vector3.new(2.7, 4.7, 0.25), WOOD_DARK,
		AB.offset(originCF, 0, 2.85, 3.9), model, "DoorLeaf")
	-- Door planks
	for i = 1, 3 do
		AB.block(Vector3.new(2.6, 0.12, 0.1), Color3.fromRGB(70, 50, 30),
			AB.offset(originCF, 0, 1.5 + i * 0.9, 3.8), model, "DoorPlank_" .. i)
	end
	-- Iron studs
	for i = 1, 4 do
		AB.sphere(0.2, IRON_BLACK,
			AB.offset(originCF, -1 + ((i - 1) % 2) * 2, 2 + math.floor((i - 1) / 2) * 1.5, 3.75),
			model, "DoorStud_" .. i)
	end
	-- Arched door header (stacked blocks for curve)
	AB.block(Vector3.new(3.4, 0.3, 0.5), STUCCO_CREAM,
		AB.offset(originCF, 0, 5.6, 4), model, "DoorHeaderTop")
	AB.block(Vector3.new(2.6, 0.3, 0.5), STUCCO_CREAM,
		AB.offset(originCF, 0, 5.85, 4), model, "DoorHeaderMid")
	AB.wedge(Vector3.new(0.5, 0.4, 0.5), STUCCO_CREAM,
		AB.offset(originCF, -1.3, 5.7, 4) * CFrame.Angles(0, 0, math.rad(-90)),
		model, "DoorWedgeL")
	AB.wedge(Vector3.new(0.5, 0.4, 0.5), STUCCO_CREAM,
		AB.offset(originCF, 1.3, 5.7, 4) * CFrame.Angles(0, 0, math.rad(90)),
		model, "DoorWedgeR")

	-- Terracotta base trim
	AB.block(Vector3.new(8.2, 1, 0.9), TERRACOTTA,
		AB.offset(originCF, 0, 1, 4), model, "BaseTrimF")
	AB.block(Vector3.new(8.2, 1, 0.9), TERRACOTTA,
		AB.offset(originCF, 0, 1, -4), model, "BaseTrimB")
	AB.block(Vector3.new(0.9, 1, 8), TERRACOTTA,
		AB.offset(originCF, -4, 1, 0), model, "BaseTrimL")
	AB.block(Vector3.new(0.9, 1, 8), TERRACOTTA,
		AB.offset(originCF, 4, 1, 0), model, "BaseTrimR")

	-- DECORATIVE QUATREFOIL WINDOW on the front (4 small circles in cross pattern)
	-- Center small block as the hub
	AB.block(Vector3.new(0.4, 0.4, 0.4), Color3.fromRGB(40, 35, 30),
		AB.offset(originCF, 0, 9, 4), model, "QuatCenter")
	-- 4 outer circles (small cylinders rotated to face out)
	local quatPositions = {
		Vector3.new(0, 9.8, 4),
		Vector3.new(0, 8.2, 4),
		Vector3.new(-0.8, 9, 4),
		Vector3.new(0.8, 9, 4),
	}
	for i, pos in quatPositions do
		AB.cylinder(0.9, 0.4, Color3.fromRGB(40, 35, 30),
			AB.offset(originCF, pos.X, pos.Y, pos.Z) * CFrame.Angles(math.rad(90), 0, 0),
			model, "QuatLobe_" .. i)
		-- Lobe outline (slightly larger ring)
		AB.cylinder(1.0, 0.45, IRON_BLACK,
			AB.offset(originCF, pos.X, pos.Y, pos.Z - 0.05) * CFrame.Angles(math.rad(90), 0, 0),
			model, "QuatOutline_" .. i)
		-- Translucent colored glass
		local pane = AB.cylinder(0.8, 0.5, (i % 2 == 0) and FIESTA_YEL or AGAVE_TEAL,
			AB.offset(originCF, pos.X, pos.Y, pos.Z + 0.05) * CFrame.Angles(math.rad(90), 0, 0),
			model, "QuatGlass_" .. i)
		pane.Transparency = 0.4
		AB.neon(pane)
	end

	-- BELFRY SECTION (upper open section, 8 studs tall)
	-- 4 corner pillars (square footprint)
	for i = 1, 4 do
		local sx = (i == 1 or i == 4) and -3.5 or 3.5
		local sz = (i <= 2) and -3.5 or 3.5
		AB.block(Vector3.new(1.5, 8, 1.5), STUCCO_CREAM,
			AB.offset(originCF, sx, 16, sz), model, "BelfryPillar_" .. i)
	end

	-- ARCHED OPENINGS on each side (top arch suggested by stacked blocks)
	-- 4 sides, each with a header arch
	local sides = {
		{x = 0, z = 4, yaw = 0},
		{x = 0, z = -4, yaw = 0},
		{x = 4, z = 0, yaw = 90},
		{x = -4, z = 0, yaw = 90},
	}
	for i, s in sides do
		-- Arch top (curve approximation)
		AB.block(Vector3.new(5, 0.5, 1), STUCCO_CREAM,
			AB.offset(originCF, s.x, 19, s.z, s.yaw), model, "BelfryArchTop_" .. i)
		AB.block(Vector3.new(3.5, 0.4, 1), STUCCO_CREAM,
			AB.offset(originCF, s.x, 19.4, s.z, s.yaw), model, "BelfryArchMid_" .. i)
		AB.block(Vector3.new(2, 0.4, 1), STUCCO_CREAM,
			AB.offset(originCF, s.x, 19.7, s.z, s.yaw), model, "BelfryArchHigh_" .. i)
		-- Wedges for curve corners
		AB.wedge(Vector3.new(1, 0.6, 1), STUCCO_CREAM,
			AB.offset(originCF, s.x, 19, s.z, s.yaw) * CFrame.new(-2, 0.3, 0)
				* CFrame.Angles(0, 0, math.rad(-90)),
			model, "BelfryWedgeL_" .. i)
		AB.wedge(Vector3.new(1, 0.6, 1), STUCCO_CREAM,
			AB.offset(originCF, s.x, 19, s.z, s.yaw) * CFrame.new(2, 0.3, 0)
				* CFrame.Angles(0, 0, math.rad(90)),
			model, "BelfryWedgeR_" .. i)
	end

	-- Belfry floor (small square inside the pillars)
	AB.block(Vector3.new(6, 0.5, 6), WOOD_DARK,
		AB.offset(originCF, 0, 12.4, 0), model, "BelfryFloor")

	-- LARGE BRONZE BELL inside the belfry
	-- Bell yoke (horizontal beam across the top)
	AB.block(Vector3.new(6, 0.5, 0.5), WOOD_DARK,
		AB.offset(originCF, 0, 19.5, 0), model, "BellYoke")
	-- Bell bracket (thin support)
	AB.block(Vector3.new(0.3, 0.6, 0.3), IRON_BLACK,
		AB.offset(originCF, 0, 19.1, 0), model, "BellBracket")
	-- Bell crown
	AB.cylinder(0.8, 0.4, BRONZE_LIGHT,
		AB.offset(originCF, 0, 18.7, 0), model, "BellCrown")
	-- Bell body (sphere ~3 studs)
	AB.sphere(3.2, BRONZE,
		AB.offset(originCF, 0, 17, 0), model, "BellBody")
	-- Bell rim (slightly wider cylinder at bottom)
	AB.cylinder(3.4, 0.4, BRONZE_LIGHT,
		AB.offset(originCF, 0, 15.5, 0), model, "BellRim")
	-- Bell clapper inside (small dark sphere visible from below)
	AB.sphere(0.6, IRON_BLACK,
		AB.offset(originCF, 0, 15.7, 0), model, "BellClapper")

	-- CLAY TILE PYRAMID ROOF over belfry (4 wedges meeting at peak)
	-- Use 4 wedges angled inward
	AB.wedge(Vector3.new(8, 4, 4), ROOF_TILE,
		AB.offset(originCF, 0, 22, 2) * CFrame.Angles(0, math.rad(180), 0),
		model, "RoofWedge1")
	AB.wedge(Vector3.new(8, 4, 4), ROOF_TILE,
		AB.offset(originCF, 0, 22, -2), model, "RoofWedge2")
	AB.wedge(Vector3.new(8, 4, 4), ROOF_TILE,
		AB.offset(originCF, 2, 22, 0) * CFrame.Angles(0, math.rad(-90), 0),
		model, "RoofWedge3")
	AB.wedge(Vector3.new(8, 4, 4), ROOF_TILE,
		AB.offset(originCF, -2, 22, 0) * CFrame.Angles(0, math.rad(90), 0),
		model, "RoofWedge4")
	-- Roof tile rows (decorative bands)
	for i = 1, 4 do
		AB.block(Vector3.new(8 - i * 1.5, 0.2, 8 - i * 1.5), Color3.fromRGB(120, 55, 35),
			AB.offset(originCF, 0, 21.5 + i * 0.8, 0), model, "RoofBand_" .. i)
	end

	-- IRON CROSS at the very top
	AB.block(Vector3.new(0.3, 3, 0.3), IRON_BLACK,
		AB.offset(originCF, 0, 27, 0), model, "CrossVertical")
	AB.block(Vector3.new(1.8, 0.3, 0.3), IRON_BLACK,
		AB.offset(originCF, 0, 27.5, 0), model, "CrossHorizontal")
	-- Decorative orb at cross intersection
	AB.sphere(0.5, BRONZE_LIGHT,
		AB.offset(originCF, 0, 27.5, 0), model, "CrossOrb")

	-- TWO NEON YELLOW LANTERNS flanking the door
	for side, sx in {-1, 1} do
		-- Lantern bracket
		AB.block(Vector3.new(0.3, 0.3, 1), IRON_BLACK,
			AB.offset(originCF, sx * 2.5, 6, 4.8), model, "LantBracket_" .. side)
		-- Wire cage
		for i = 1, 4 do
			local a = (i - 1) * math.pi / 2
			AB.block(Vector3.new(0.08, 1.2, 0.08), IRON_BLACK,
				AB.offset(originCF, sx * 2.5 + math.cos(a) * 0.4, 5.5, 5.2 + math.sin(a) * 0.4),
				model, string.format("LantCage_%d_%d", side, i))
		end
		AB.block(Vector3.new(0.9, 0.1, 0.9), IRON_BLACK,
			AB.offset(originCF, sx * 2.5, 6.1, 5.2), model, "LantCageTop_" .. side)
		-- Flame
		local flame = AB.sphere(0.7, CANDLE_FLAME,
			AB.offset(originCF, sx * 2.5, 5.5, 5.2), model, "LantFlame_" .. side)
		AB.neon(flame)
		AB.glow(flame, CANDLE_FLAME, 2.5)
	end

	-- BOUGAINVILLEA VINE climbing the lower section (cluster of pink spheres)
	for i = 1, 14 do
		local y = 1.5 + i * 0.7
		local zVar = -3 + ((i * 1.4) % 6)
		AB.sphere(0.55 + ((i % 3) * 0.1), BOUG_PINK,
			AB.offset(originCF, -4.1, y, zVar), model, "Boug_" .. i)
	end
	-- Vine stem
	for i = 1, 3 do
		AB.block(Vector3.new(0.12, 11, 0.12), Color3.fromRGB(80, 100, 50),
			AB.offset(originCF, -4.1, 7, -2 + i * 1.5), model, "VineStem_" .. i)
	end
	-- A few mixed green leaves
	for i = 1, 5 do
		AB.sphere(0.4, PAPEL_GREEN,
			AB.offset(originCF, -4.1, 3 + i * 1.6, -1 + (i * 1.3) % 4),
			model, "VineLeaf_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
