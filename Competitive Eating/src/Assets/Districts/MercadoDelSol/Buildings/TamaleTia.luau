-- Tamale Tia — small kiosk with a huge steamer pot, neon steam,
-- pyramid clay-tile roof, garlic/herbs hanging, stacked tamales.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local STUCCO_CREAM = Color3.fromRGB(245, 230, 200)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local ROOF_TILE    = Color3.fromRGB(140, 65, 40)
local ADOBE_TAN    = Color3.fromRGB(220, 180, 130)
local STEAM_WHITE  = Color3.fromRGB(245, 245, 250)
local CORN_HUSK    = Color3.fromRGB(170, 190, 95)
local GARLIC_TAN   = Color3.fromRGB(230, 220, 190)
local HERB_GREEN   = Color3.fromRGB(75, 130, 60)
local CURTAIN_RED  = Color3.fromRGB(180, 35, 35)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TamaleTia", parent)

	-- Foundation
	AB.block(Vector3.new(13, 0.5, 11), Color3.fromRGB(150, 145, 140),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Back wall (terracotta)
	AB.block(Vector3.new(12, 10, 0.8), TERRACOTTA,
		AB.offset(originCF, 0, 5.5, -5), model, "BackWall")

	-- Side walls
	AB.block(Vector3.new(0.8, 10, 10), TERRACOTTA,
		AB.offset(originCF, -6, 5.5, 0), model, "WallL")
	AB.block(Vector3.new(0.8, 10, 10), TERRACOTTA,
		AB.offset(originCF, 6, 5.5, 0), model, "WallR")

	-- Cream trim along top of walls
	AB.block(Vector3.new(12, 0.6, 0.9), STUCCO_CREAM,
		AB.offset(originCF, 0, 10.2, -4.95), model, "TrimBack")
	AB.block(Vector3.new(0.9, 0.6, 10), STUCCO_CREAM,
		AB.offset(originCF, -5.95, 10.2, 0), model, "TrimL")
	AB.block(Vector3.new(0.9, 0.6, 10), STUCCO_CREAM,
		AB.offset(originCF, 5.95, 10.2, 0), model, "TrimR")

	-- Cream base trim
	AB.block(Vector3.new(12, 1, 0.9), STUCCO_CREAM,
		AB.offset(originCF, 0, 1.2, -4.95), model, "BaseTrimBack")

	-- PYRAMID-STYLE STEEP ROOF using two wedges (front + back) meeting at peak
	AB.wedge(Vector3.new(13, 4, 5.5), ROOF_TILE,
		AB.offset(originCF, 0, 12.5, -2.5) * CFrame.Angles(0, math.rad(180), 0),
		model, "RoofWedgeBack")
	AB.wedge(Vector3.new(13, 4, 5.5), ROOF_TILE,
		AB.offset(originCF, 0, 12.5, 2.5), model, "RoofWedgeFront")
	-- Roof tile detail rows (overlapping bands)
	for i = 1, 5 do
		AB.block(Vector3.new(13.2, 0.2, 1.2), Color3.fromRGB(120, 55, 35),
			AB.offset(originCF, 0, 11.2 + (i - 1) * 0.8, 2.6 - (i - 1) * 1.0),
			model, "RoofTileF_" .. i)
		AB.block(Vector3.new(13.2, 0.2, 1.2), Color3.fromRGB(120, 55, 35),
			AB.offset(originCF, 0, 11.2 + (i - 1) * 0.8, -2.6 + (i - 1) * 1.0),
			model, "RoofTileB_" .. i)
	end
	-- Roof peak ridge
	AB.block(Vector3.new(13.4, 0.4, 0.6), Color3.fromRGB(95, 45, 30),
		AB.offset(originCF, 0, 16.4, 0), model, "RoofRidge")

	-- Counter at front
	AB.block(Vector3.new(12, 0.4, 2), WOOD_DARK,
		AB.offset(originCF, 0, 4, 4), model, "CounterTop")
	AB.block(Vector3.new(12, 3.3, 1.5), TERRACOTTA,
		AB.offset(originCF, 0, 2.2, 4.2), model, "CounterFront")
	AB.block(Vector3.new(12, 0.3, 1.6), FIESTA_YEL,
		AB.offset(originCF, 0, 0.6, 4.2), model, "CounterTrim")

	-- LARGE STEAMER POT on counter (corn-husk colored)
	AB.cylinder(3.8, 2.8, ADOBE_TAN,
		AB.offset(originCF, 0, 5.6, 4), model, "SteamerPotBody")
	-- Pot rim (slightly darker)
	AB.cylinder(4.0, 0.4, Color3.fromRGB(190, 150, 100),
		AB.offset(originCF, 0, 7.0, 4), model, "SteamerPotRim")
	-- Pot lid (slightly smaller domed)
	AB.cylinder(3.6, 0.3, Color3.fromRGB(160, 120, 70),
		AB.offset(originCF, 0, 7.3, 4), model, "SteamerLid")
	-- Lid handle
	AB.cylinder(0.4, 0.6, WOOD_DARK,
		AB.offset(originCF, 0, 7.7, 4), model, "LidHandle")
	-- Pot handles (side)
	AB.block(Vector3.new(0.3, 0.3, 1.2), Color3.fromRGB(80, 60, 40),
		AB.offset(originCF, -2.1, 6, 4), model, "PotHandleL")
	AB.block(Vector3.new(0.3, 0.3, 1.2), Color3.fromRGB(80, 60, 40),
		AB.offset(originCF, 2.1, 6, 4), model, "PotHandleR")

	-- Neon under-pot glow (suggests fire/heat)
	local heatGlow = AB.block(Vector3.new(3.5, 0.2, 3.5), Color3.fromRGB(255, 120, 40),
		AB.offset(originCF, 0, 4.3, 4), model, "HeatGlow")
	AB.neon(heatGlow)
	AB.glow(heatGlow, Color3.fromRGB(255, 120, 40), 2.5)

	-- Steam column rising above pot (3 stacked semi-transparent neon white spheres)
	local sizes = {2.5, 2.0, 1.5}
	for i, s in sizes do
		local steam = AB.sphere(s, STEAM_WHITE,
			AB.offset(originCF, math.sin(i) * 0.3, 8.5 + i * 1.6, 4 + math.cos(i) * 0.2),
			model, "Steam_" .. i)
		AB.neon(steam)
		steam.Transparency = 0.45
		AB.glow(steam, STEAM_WHITE, 1.2)
	end

	-- Sign "TAMALES" — 5 neon yellow letters above counter
	AB.block(Vector3.new(9, 1.5, 0.3), STUCCO_CREAM,
		AB.offset(originCF, 0, 9.5, -4.5), model, "SignBack")
	for i = 1, 7 do
		local letter = AB.block(Vector3.new(1.0, 1.2, 0.2), FIESTA_YEL,
			AB.offset(originCF, -3.6 + (i - 1) * 1.2, 9.5, -4.3), model, "SignLetter_" .. i)
		AB.neon(letter)
		if i <= 3 then AB.glow(letter, FIESTA_YEL, 1.4) end
	end

	-- Small window with red checked curtains
	-- Window hole
	AB.block(Vector3.new(2.4, 2.4, 0.4), Color3.fromRGB(40, 35, 30),
		AB.offset(originCF, -5.95, 7, 1.5, 90), model, "WindowHole")
	-- Window frame
	AB.block(Vector3.new(0.9, 0.3, 2.8), WOOD_DARK,
		AB.offset(originCF, -5.95, 8.3, 1.5), model, "WinFrameTop")
	AB.block(Vector3.new(0.9, 0.3, 2.8), WOOD_DARK,
		AB.offset(originCF, -5.95, 5.7, 1.5), model, "WinFrameBot")
	-- Red checked curtain grid pattern (5x4 = 20 small red blocks alternating)
	for r = 1, 4 do
		for c = 1, 5 do
			if (r + c) % 2 == 0 then
				AB.block(Vector3.new(0.1, 0.5, 0.5), CURTAIN_RED,
					AB.offset(originCF, -5.85, 6 + (r - 1) * 0.55, 0.2 + (c - 1) * 0.55),
					model, string.format("Check_%d_%d", r, c))
			end
		end
	end

	-- Stacked tamale display on counter (5 corn-husk wrapped cylinders)
	for i = 1, 5 do
		AB.cylinder(0.8, 2.4, CORN_HUSK,
			AB.offset(originCF, -4 + (i - 1) * 0.9, 4.45, 4.5)
				* CFrame.Angles(math.rad(90), 0, 0),
			model, "Tamale_" .. i)
		-- Tie string in middle
		AB.block(Vector3.new(0.85, 0.1, 0.1), Color3.fromRGB(100, 80, 40),
			AB.offset(originCF, -4 + (i - 1) * 0.9, 4.45, 4.5), model, "TamaleTie_" .. i)
	end

	-- Small stool beside the kiosk
	AB.block(Vector3.new(1.2, 0.3, 1.2), WOOD_DARK,
		AB.offset(originCF, 7, 1.7, 3), model, "StoolTop")
	for i = 1, 4 do
		local sx = (i == 1 or i == 4) and -0.5 or 0.5
		local sz = (i <= 2) and -0.5 or 0.5
		AB.block(Vector3.new(0.2, 1.5, 0.2), WOOD_DARK,
			AB.offset(originCF, 7 + sx, 0.85, 3 + sz), model, "StoolLeg_" .. i)
	end

	-- Garlic + herbs hanging from awning edge
	-- Garlic braid (left)
	for i = 1, 5 do
		AB.sphere(0.5, GARLIC_TAN,
			AB.offset(originCF, -4, 10 - i * 0.5, 5.2), model, "Garlic_" .. i)
	end
	AB.block(Vector3.new(0.15, 0.5, 0.15), WOOD_DARK,
		AB.offset(originCF, -4, 10.3, 5.2), model, "GarlicTie")

	-- Herb bundles (right)
	for i = 1, 3 do
		for j = 1, 4 do
			AB.block(Vector3.new(0.15, 1.5, 0.15), HERB_GREEN,
				AB.offset(originCF, 3.5 + i * 0.4, 9.5 - j * 0.2, 5.2)
					* CFrame.Angles(0, 0, math.rad((j - 2) * 8)),
				model, string.format("Herb_%d_%d", i, j))
		end
	end

	-- Corner support posts (front)
	AB.block(Vector3.new(0.6, 10, 0.6), WOOD_DARK,
		AB.offset(originCF, -6, 5.5, 5), model, "PostL")
	AB.block(Vector3.new(0.6, 10, 0.6), WOOD_DARK,
		AB.offset(originCF, 6, 5.5, 5), model, "PostR")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
