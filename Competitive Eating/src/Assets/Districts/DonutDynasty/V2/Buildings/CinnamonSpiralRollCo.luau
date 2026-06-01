-- CinnamonSpiralRollCo — twisted-tower bakery where the entire roof
-- spirals upward like a cinnamon roll. Brown facade, gold trim,
-- spiral roof, and a giant cinnamon-roll dome.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK    = Color3.fromRGB(255, 200, 214)
local CREAM   = Color3.fromRGB(255, 240, 220)
local BROWN   = Color3.fromRGB(92,  57,  36)
local LIGHTBR = Color3.fromRGB(168, 118, 78)
local GOLD    = Color3.fromRGB(212, 168, 82)
local MINT    = Color3.fromRGB(180, 230, 200)
local NEONPK  = Color3.fromRGB(255, 110, 170)
local ICING   = Color3.fromRGB(252, 246, 230)
local GLASS   = Color3.fromRGB(210, 235, 250)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CinnamonSpiralRollCo", parent)

	-- Foundation
	AB.block(Vector3.new(30, 0.5, 26), Color3.fromRGB(110, 100, 95),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Brown walls
	AB.block(Vector3.new(30, 14, 1),  BROWN, AB.offset(originCF, 0,    7, -12.5), model, "BackWall")
	AB.block(Vector3.new(1,  14, 26), BROWN, AB.offset(originCF, -14.5, 7,  0),   model, "LeftWall")
	AB.block(Vector3.new(1,  14, 26), BROWN, AB.offset(originCF,  14.5, 7,  0),   model, "RightWall")
	AB.block(Vector3.new(10, 14, 1),  BROWN, AB.offset(originCF, -10, 7, 12.5), model, "FrontL")
	AB.block(Vector3.new(10, 14, 1),  BROWN, AB.offset(originCF,  10, 7, 12.5), model, "FrontR")
	AB.block(Vector3.new(12, 4, 1),   BROWN, AB.offset(originCF,  0, 12, 12.5), model, "FrontHeader")

	-- Cinnamon-stripe wainscot (light/dark alternating)
	for i = 1, 15 do
		local x = -14 + (i - 1) * 2
		local col = (i % 2 == 0) and LIGHTBR or BROWN
		AB.block(Vector3.new(2, 2, 1.1), col,
			AB.offset(originCF, x, 1.5, 12.55), model, "StripeFront_" .. i)
	end

	-- Gold trim bands
	AB.block(Vector3.new(30, 0.5, 1.1), GOLD, AB.offset(originCF, 0, 2.7, 12.6), model, "TrimBaseFront")
	AB.block(Vector3.new(30, 0.5, 1.1), GOLD, AB.offset(originCF, 0, 13.8, 12.6), model, "TrimTopFront")
	AB.block(Vector3.new(32, 0.5, 1.1), GOLD, AB.offset(originCF, 0, 2.7, -12.6), model, "TrimBaseBack")

	-- Display windows flanking door
	for i, x in {-10, 10} do
		local g = AB.block(Vector3.new(7, 6, 0.2), GLASS,
			AB.offset(originCF, x, 7, 12.7), model, "WinGlass_" .. i)
		g.Transparency = 0.45
		g.Material = Enum.Material.Glass
		AB.block(Vector3.new(7.4, 0.4, 0.5), GOLD,
			AB.offset(originCF, x, 10.2, 12.6), model, "WinTrimTop_" .. i)
		AB.block(Vector3.new(7.4, 0.4, 0.5), GOLD,
			AB.offset(originCF, x, 3.8, 12.6), model, "WinTrimBot_" .. i)
	end

	-- Cream awning over door
	AB.block(Vector3.new(10, 0.6, 3.5), CREAM,
		AB.offset(originCF, 0, 9.6, 14.2), model, "Awning")
	for i, x in {-3.5, -1.2, 1.2, 3.5} do
		AB.block(Vector3.new(1, 0.65, 3.5), LIGHTBR,
			AB.offset(originCF, x, 9.6, 14.2), model, "AwningStripe_" .. i)
	end

	-- Spiral roof: stacked cylinders rotated incrementally (the signature)
	for i = 1, 8 do
		local y = 15 + (i - 1) * 1.6
		local diameter = 22 - (i - 1) * 1.4
		local angle = (i - 1) * 22.5
		AB.cylinder(diameter, 1.6, LIGHTBR,
			AB.offset(originCF, 0, y, 0, angle), model, "SpiralLayer_" .. i)
		-- Icing drizzle stripe on each layer
		AB.cylinder(diameter + 0.1, 0.4, ICING,
			AB.offset(originCF, 0, y - 0.4, 0, angle), model, "SpiralIcing_" .. i)
	end
	-- Top dollop of icing
	AB.sphere(4, ICING, AB.offset(originCF, 0, 30, 0), model, "IcingDollop")
	AB.sphere(1.4, NEONPK, AB.offset(originCF, 0, 31.5, 0), model, "Cherry")
	local cherryGlow = AB.sphere(1.2, NEONPK, AB.offset(originCF, 0, 31.5, 0), model, "CherryGlow")
	AB.neon(cherryGlow)
	cherryGlow.Transparency = 0.4
	AB.glow(cherryGlow, NEONPK, 2.5)

	-- Neon "CINNAMON" sign (light pink)
	local sign = AB.block(Vector3.new(20, 2.4, 0.5), NEONPK,
		AB.offset(originCF, 0, 13, 13.05), model, "NeonSign")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 3)
	AB.block(Vector3.new(22, 3.2, 0.3), CREAM,
		AB.offset(originCF, 0, 13, 12.95), model, "SignBacking")

	-- Cinnamon stick "columns" flanking the door
	for i, x in {-6.5, 6.5} do
		AB.cylinder(1.5, 8, LIGHTBR,
			AB.offset(originCF, x, 4, 13.1), model, "CinnaColumn_" .. i)
		-- Spiral wrap (stripes)
		for j = 1, 6 do
			local sy = 0.8 + (j - 1) * 1.3
			AB.cylinder(1.55, 0.25, BROWN,
				AB.offset(originCF, x, sy, 13.1, j * 30), model, "CinnaWrap_" .. i .. "_" .. j)
		end
	end

	-- Sidewalk planters
	for i, x in {-13, 13} do
		AB.block(Vector3.new(2, 1.4, 2), GOLD,
			AB.offset(originCF, x, 0.7, 13.5), model, "Planter_" .. i)
		AB.sphere(2.2, MINT,
			AB.offset(originCF, x, 2.5, 13.5), model, "PlanterShrub_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
