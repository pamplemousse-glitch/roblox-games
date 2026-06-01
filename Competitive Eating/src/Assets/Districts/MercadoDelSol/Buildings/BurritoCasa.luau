-- Burrito Casa — HERO colorful adobe storefront. Rounded archway door,
-- iron-barred windows, exposed vigas, bougainvillea vine, neon sign.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local BOUG_PINK    = Color3.fromRGB(220, 80, 140)
local ADOBE_TAN    = Color3.fromRGB(220, 180, 130)
local STUCCO_CREAM = Color3.fromRGB(245, 230, 200)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local IRON_BLACK   = Color3.fromRGB(30, 28, 28)
local ROOF_TILE    = Color3.fromRGB(140, 65, 40)
local CANDLE_FLAME = Color3.fromRGB(255, 200, 90)
local SMOKE_GREY   = Color3.fromRGB(180, 180, 180)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BurritoCasa", parent)

	-- Foundation
	AB.block(Vector3.new(26, 0.6, 18), Color3.fromRGB(150, 140, 130),
		AB.offset(originCF, 0, 0.3, 0), model, "Foundation")

	-- Adobe back wall (full)
	AB.block(Vector3.new(24, 18, 0.8), ADOBE_TAN,
		AB.offset(originCF, 0, 9.6, -7.6), model, "BackWall")

	-- Adobe side walls
	AB.block(Vector3.new(0.8, 18, 16), ADOBE_TAN,
		AB.offset(originCF, -11.6, 9.6, 0), model, "WallL")
	AB.block(Vector3.new(0.8, 18, 16), ADOBE_TAN,
		AB.offset(originCF, 11.6, 9.6, 0), model, "WallR")

	-- Front wall with door cutout: left/right wall blocks + header above
	AB.block(Vector3.new(8, 18, 0.8), ADOBE_TAN,
		AB.offset(originCF, -7.5, 9.6, 7.6), model, "FrontWallL")
	AB.block(Vector3.new(8, 18, 0.8), ADOBE_TAN,
		AB.offset(originCF, 7.5, 9.6, 7.6), model, "FrontWallR")
	-- Header above door
	AB.block(Vector3.new(8, 7, 0.8), ADOBE_TAN,
		AB.offset(originCF, 0, 15, 7.6), model, "DoorHeader")

	-- Terracotta accent stripe along base
	AB.block(Vector3.new(24, 1.2, 0.9), TERRACOTTA,
		AB.offset(originCF, 0, 1.2, 7.65), model, "BaseStripeF")
	AB.block(Vector3.new(0.9, 1.2, 16), TERRACOTTA,
		AB.offset(originCF, -11.6, 1.2, 0), model, "BaseStripeL")
	AB.block(Vector3.new(0.9, 1.2, 16), TERRACOTTA,
		AB.offset(originCF, 11.6, 1.2, 0), model, "BaseStripeR")

	-- Rounded archway door (using wedges + curve approximation)
	-- Door frame (dark interior space)
	AB.block(Vector3.new(7, 9, 0.3), Color3.fromRGB(40, 30, 25),
		AB.offset(originCF, 0, 6, 7.45), model, "DoorInterior")
	-- Arch top — stacked diminishing blocks to suggest curve
	AB.block(Vector3.new(7, 1, 0.9), ADOBE_TAN,
		AB.offset(originCF, 0, 11.1, 7.6), model, "ArchTier1")
	AB.block(Vector3.new(6, 1, 0.9), ADOBE_TAN,
		AB.offset(originCF, 0, 12, 7.6), model, "ArchTier2")
	AB.block(Vector3.new(4.5, 1, 0.9), ADOBE_TAN,
		AB.offset(originCF, 0, 12.8, 7.6), model, "ArchTier3")
	-- Arch wedges for curve corners
	AB.wedge(Vector3.new(0.9, 1.2, 1.2), ADOBE_TAN,
		AB.offset(originCF, -3, 11.6, 7.6) * CFrame.Angles(0, 0, math.rad(-90)), model, "ArchWedgeL")
	AB.wedge(Vector3.new(0.9, 1.2, 1.2), ADOBE_TAN,
		AB.offset(originCF, 3, 11.6, 7.6) * CFrame.Angles(0, 0, math.rad(90)), model, "ArchWedgeR")
	-- Wooden double door inside arch
	AB.block(Vector3.new(2.7, 8.5, 0.2), WOOD_DARK,
		AB.offset(originCF, -1.5, 5.75, 7.35), model, "DoorLeaf_L")
	AB.block(Vector3.new(2.7, 8.5, 0.2), WOOD_DARK,
		AB.offset(originCF, 1.5, 5.75, 7.35), model, "DoorLeaf_R")
	-- Door planks (horizontal accent lines)
	for i = 1, 3 do
		AB.block(Vector3.new(5.6, 0.15, 0.1), Color3.fromRGB(70, 50, 30),
			AB.offset(originCF, 0, 3 + i * 2, 7.25), model, "DoorPlank_" .. i)
	end

	-- 4 window cutouts with iron bars
	local winPositions = {
		Vector3.new(-9, 11, 7.6),
		Vector3.new(9, 11, 7.6),
		Vector3.new(-11.6, 11, -3),
		Vector3.new(11.6, 11, -3),
	}
	for i, pos in winPositions do
		local yaw = (i >= 3) and 90 or 0
		-- Window hole (dark)
		AB.part({
			size = Vector3.new(2.5, 3, 0.4), color = Color3.fromRGB(40, 35, 30),
			cf = AB.offset(originCF, pos.X, pos.Y, pos.Z, yaw),
			name = "WindowHole_" .. i,
		}, model)
		-- Window frame (4 sides)
		AB.part({size=Vector3.new(2.8, 0.3, 0.5), color=WOOD_DARK,
			cf=AB.offset(originCF, pos.X, pos.Y + 1.5, pos.Z, yaw), name="WinFTop_" .. i}, model)
		AB.part({size=Vector3.new(2.8, 0.3, 0.5), color=WOOD_DARK,
			cf=AB.offset(originCF, pos.X, pos.Y - 1.5, pos.Z, yaw), name="WinFBot_" .. i}, model)
		-- Iron bars crisscrossed (2 vertical, 1 horizontal)
		for b = 1, 2 do
			AB.part({size=Vector3.new(0.12, 3, 0.12), color=IRON_BLACK,
				cf=AB.offset(originCF, pos.X + (b - 1.5) * 1.4, pos.Y, pos.Z, yaw),
				name=string.format("BarV_%d_%d", i, b)}, model)
		end
		AB.part({size=Vector3.new(2.5, 0.12, 0.12), color=IRON_BLACK,
			cf=AB.offset(originCF, pos.X, pos.Y, pos.Z, yaw), name="BarH_" .. i}, model)
		-- Translucent glass pane
		AB.part({size=Vector3.new(2.4, 2.8, 0.1), color=Color3.fromRGB(170, 200, 220),
			cf=AB.offset(originCF, pos.X, pos.Y, pos.Z, yaw), transparency=0.55, name="WinGlass_" .. i}, model)
	end

	-- 5th window: small upper round window on the back wall side
	AB.block(Vector3.new(1.6, 1.6, 0.4), Color3.fromRGB(40, 35, 30),
		AB.offset(originCF, 0, 16, -7.55), model, "WindowHole_5")
	AB.cylinder(1.4, 0.3, WOOD_DARK,
		AB.offset(originCF, 0, 16, -7.45) * CFrame.Angles(math.rad(90), 0, 0),
		model, "RoundWinFrame")

	-- Flat adobe roof + parapet
	AB.block(Vector3.new(24, 0.6, 16), ADOBE_TAN,
		AB.offset(originCF, 0, 18.6, 0), model, "RoofSlab")
	-- Parapet (raised lip around the roof edge)
	AB.block(Vector3.new(24, 1.5, 0.6), ADOBE_TAN,
		AB.offset(originCF, 0, 19.5, 7.5), model, "ParapetF")
	AB.block(Vector3.new(24, 1.5, 0.6), ADOBE_TAN,
		AB.offset(originCF, 0, 19.5, -7.5), model, "ParapetB")
	AB.block(Vector3.new(0.6, 1.5, 16), ADOBE_TAN,
		AB.offset(originCF, -11.5, 19.5, 0), model, "ParapetL")
	AB.block(Vector3.new(0.6, 1.5, 16), ADOBE_TAN,
		AB.offset(originCF, 11.5, 19.5, 0), model, "ParapetR")

	-- Exposed wooden vigas (5 dark wooden cylinders poking out from below the roof line)
	for i = 1, 5 do
		local x = -10 + (i - 1) * 5
		AB.cylinder(0.7, 2.5, WOOD_DARK,
			AB.offset(originCF, x, 17.5, 8.4) * CFrame.Angles(0, math.rad(90), 0),
			model, "Viga_" .. i)
	end

	-- Hand-painted "BURRITO CASA" sign above the door (neon)
	local signBack = AB.block(Vector3.new(10, 2, 0.3), STUCCO_CREAM,
		AB.offset(originCF, 0, 14, 8), model, "SignBack")
	for i = 1, 7 do
		local x = -4.5 + (i - 1) * 1.5
		local c = (i % 3 == 0) and TERRACOTTA or (i % 3 == 1 and PAPEL_GREEN or FIESTA_YEL)
		local letter = AB.block(Vector3.new(0.9, 1.4, 0.2), c,
			AB.offset(originCF, x, 14, 8.2), model, "SignLetter_" .. i)
		AB.neon(letter)
		AB.glow(letter, c, 1.3)
	end

	-- Bougainvillea pink flower vines climbing the right wall
	for i = 1, 18 do
		local y = 2 + i * 0.9
		local zVar = -6 + ((i * 1.7) % 12)
		AB.sphere(0.7 + ((i % 3) * 0.1), BOUG_PINK,
			AB.offset(originCF, 11.85, y, zVar), model, "Boug_" .. i)
	end
	-- Vine stems
	for i = 1, 3 do
		AB.block(Vector3.new(0.15, 14, 0.15), Color3.fromRGB(80, 100, 50),
			AB.offset(originCF, 11.85, 9 + i * 0.2, -3 + i * 2), model, "Stem_" .. i)
	end

	-- Chimney + smokestack at back-left corner
	AB.block(Vector3.new(2.5, 4, 2.5), ADOBE_TAN,
		AB.offset(originCF, -9.5, 21, -6), model, "Chimney")
	AB.block(Vector3.new(3, 0.5, 3), TERRACOTTA,
		AB.offset(originCF, -9.5, 23.2, -6), model, "ChimneyCap")
	-- Smoke puffs
	for i = 1, 3 do
		AB.sphere(1.2 + i * 0.2, SMOKE_GREY,
			AB.offset(originCF, -9.5 + i * 0.3, 24.5 + i * 1.2, -6 - i * 0.2),
			model, "Smoke_" .. i)
	end

	-- Front stoop
	AB.block(Vector3.new(8, 0.4, 2.5), STUCCO_CREAM,
		AB.offset(originCF, 0, 0.7, 9.2), model, "Stoop")

	-- Ceramic pots flanking the door (2 pots with succulents)
	for side, sx in {-1, 1} do
		AB.cylinder(1.8, 1.6, TERRACOTTA,
			AB.offset(originCF, sx * 4.5, 1.7, 9.2), model, "Pot_" .. side)
		-- Pot rim
		AB.cylinder(2.0, 0.3, Color3.fromRGB(160, 75, 30),
			AB.offset(originCF, sx * 4.5, 2.6, 9.2), model, "PotRim_" .. side)
		-- Succulent (cluster of green spheres)
		for j = 1, 5 do
			AB.sphere(0.7, PAPEL_GREEN,
				AB.offset(originCF, sx * 4.5 + math.cos(j) * 0.5, 2.9 + (j % 2) * 0.3, 9.2 + math.sin(j) * 0.5),
				model, string.format("Succ_%d_%d", side, j))
		end
	end

	-- Lantern at door (neon yellow sphere in wire cage)
	local lanternBracket = AB.block(Vector3.new(0.3, 0.3, 1.5), IRON_BLACK,
		AB.offset(originCF, 0, 13, 8.5), model, "LanternArm")
	-- Wire cage frame (4 thin uprights + top/bottom)
	for i = 1, 4 do
		local a = (i - 1) * math.pi / 2
		AB.block(Vector3.new(0.08, 1.4, 0.08), IRON_BLACK,
			AB.offset(originCF, math.cos(a) * 0.55, 12.3, 9 + math.sin(a) * 0.55),
			model, "CageUp_" .. i)
	end
	AB.block(Vector3.new(1.4, 0.1, 1.4), IRON_BLACK,
		AB.offset(originCF, 0, 13, 9), model, "CageTop")
	AB.block(Vector3.new(1.2, 0.1, 1.2), IRON_BLACK,
		AB.offset(originCF, 0, 11.6, 9), model, "CageBot")
	local lantern = AB.sphere(0.9, CANDLE_FLAME,
		AB.offset(originCF, 0, 12.3, 9), model, "LanternFlame")
	AB.neon(lantern)
	AB.glow(lantern, CANDLE_FLAME, 2.5)

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
