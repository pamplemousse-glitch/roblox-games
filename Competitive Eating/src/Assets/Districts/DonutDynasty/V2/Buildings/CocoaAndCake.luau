-- CocoaAndCake — chocolate-brown specialty cake shop with a rich
-- ganache-glazed facade, cream icing trim, a tiered cake display in
-- the window, and a glowing "COCOA" neon sign.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK    = Color3.fromRGB(255, 200, 214)
local CREAM   = Color3.fromRGB(255, 240, 220)
local BROWN   = Color3.fromRGB(92,  57,  36)
local DARKBR  = Color3.fromRGB(60,  35,  22)
local GOLD    = Color3.fromRGB(212, 168, 82)
local MINT    = Color3.fromRGB(180, 230, 200)
local NEONPK  = Color3.fromRGB(255, 110, 170)
local STRAW   = Color3.fromRGB(245, 80, 120)
local GLASS   = Color3.fromRGB(210, 235, 250)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CocoaAndCake", parent)

	-- Foundation
	AB.block(Vector3.new(32, 0.5, 24), Color3.fromRGB(110, 100, 95),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Chocolate brown walls
	AB.block(Vector3.new(32, 14, 1),  BROWN, AB.offset(originCF, 0,    7, -11.5), model, "BackWall")
	AB.block(Vector3.new(1,  14, 24), BROWN, AB.offset(originCF, -15.5, 7,  0),   model, "LeftWall")
	AB.block(Vector3.new(1,  14, 24), BROWN, AB.offset(originCF,  15.5, 7,  0),   model, "RightWall")
	AB.block(Vector3.new(11, 14, 1),  BROWN, AB.offset(originCF, -10.5, 7, 11.5), model, "FrontL")
	AB.block(Vector3.new(11, 14, 1),  BROWN, AB.offset(originCF,  10.5, 7, 11.5), model, "FrontR")
	AB.block(Vector3.new(10, 4, 1),   BROWN, AB.offset(originCF,  0,    12, 11.5), model, "FrontHeader")

	-- "Ganache drip" cream icing along the top edge
	for i = 1, 13 do
		local x = -15 + (i - 1) * 2.5
		local drip = 0.6 + (i % 3) * 0.5
		AB.sphere(1.8, CREAM, AB.offset(originCF, x, 13.5, 11.55), model, "Drip_" .. i)
		AB.sphere(1.0, CREAM, AB.offset(originCF, x, 12.8 - drip, 11.7), model, "DripTail_" .. i)
	end

	-- Gold sconces flanking the door
	for i, x in {-7, 7} do
		AB.cylinder(1.2, 1, GOLD, AB.offset(originCF, x, 7.5, 12.2), model, "Sconce_" .. i)
		local bulb = AB.sphere(1, NEONPK, AB.offset(originCF, x, 7.5, 12.6), model, "SconceBulb_" .. i)
		AB.neon(bulb)
		AB.glow(bulb, NEONPK, 2.5)
	end

	-- Display window (large) with 3-tier wedding cake
	local g = AB.block(Vector3.new(10, 6, 0.2), GLASS,
		AB.offset(originCF, 0, 5.5, 12), model, "WindowGlass")
	g.Transparency = 0.4
	g.Material = Enum.Material.Glass
	AB.block(Vector3.new(10.4, 0.4, 0.6), GOLD, AB.offset(originCF, 0, 8.7, 11.9), model, "WindowTrimTop")
	AB.block(Vector3.new(10.4, 0.4, 0.6), GOLD, AB.offset(originCF, 0, 2.5, 11.9), model, "WindowTrimBot")
	AB.block(Vector3.new(0.4, 6, 0.6), GOLD, AB.offset(originCF, -5.2, 5.5, 11.9), model, "WindowTrimL")
	AB.block(Vector3.new(0.4, 6, 0.6), GOLD, AB.offset(originCF,  5.2, 5.5, 11.9), model, "WindowTrimR")

	-- Tiered cake inside
	AB.cylinder(1.8, 0.4, GOLD,   AB.offset(originCF, 0, 3.0, 11.5), model, "CakeStand")
	AB.cylinder(5.5, 2.0, CREAM,  AB.offset(originCF, 0, 4.4, 11.5), model, "CakeT1")
	AB.cylinder(4.0, 1.8, PINK,   AB.offset(originCF, 0, 6.3, 11.5), model, "CakeT2")
	AB.cylinder(2.6, 1.6, NEONPK, AB.offset(originCF, 0, 8.0, 11.5), model, "CakeT3")
	-- Strawberry topper
	AB.sphere(1, STRAW, AB.offset(originCF, 0, 9.2, 11.5), model, "CakeStrawberry")
	-- Cake decorations: ring of cream dots on each tier
	for i = 1, 10 do
		local angle = (i / 10) * math.pi * 2
		local rT1 = 2.7
		AB.sphere(0.4, CREAM,
			AB.offset(originCF, math.cos(angle) * rT1, 5.4, 11.5 + math.sin(angle) * rT1),
			model, "CakeDotT1_" .. i)
	end

	-- Cream icing roof line
	AB.block(Vector3.new(34, 1.2, 26), DARKBR,
		AB.offset(originCF, 0, 14.6, 0), model, "Roof")
	AB.block(Vector3.new(34, 0.8, 26), CREAM,
		AB.offset(originCF, 0, 15.1, 0), model, "RoofIcing")

	-- Chocolate chimney with steam (cream puff sphere)
	AB.block(Vector3.new(3, 5, 3), DARKBR,
		AB.offset(originCF, -10, 18, -4), model, "Chimney")
	AB.sphere(2, CREAM,
		AB.offset(originCF, -10, 22, -4), model, "Steam1")
	AB.sphere(1.5, CREAM,
		AB.offset(originCF, -10.5, 24, -3.5), model, "Steam2")
	AB.sphere(1.2, CREAM,
		AB.offset(originCF, -9.5, 25.5, -3), model, "Steam3")

	-- Neon "COCOA" sign
	local sign = AB.block(Vector3.new(14, 2.4, 0.5), NEONPK,
		AB.offset(originCF, 0, 13, 12.1), model, "NeonSign")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 3)
	AB.block(Vector3.new(16, 3.2, 0.3), DARKBR,
		AB.offset(originCF, 0, 13, 12.0), model, "SignBacking")
	-- Sign gold curl frame
	for i, x in {-7.5, 7.5} do
		AB.sphere(0.8, GOLD, AB.offset(originCF, x, 14.2, 12.0), model, "SignCurlTop_" .. i)
		AB.sphere(0.8, GOLD, AB.offset(originCF, x, 11.8, 12.0), model, "SignCurlBot_" .. i)
	end

	-- Cup-of-cocoa hanging sign (3D shape) on bracket
	AB.block(Vector3.new(0.4, 0.4, 4), GOLD,
		AB.offset(originCF, 12, 9, 12.8), model, "CocoaBracketArm")
	AB.cylinder(2.5, 2, CREAM,
		AB.offset(originCF, 14.5, 9, 13.2), model, "CocoaCupBody")
	AB.cylinder(2.6, 0.3, BROWN,
		AB.offset(originCF, 14.5, 10.1, 13.2), model, "CocoaSurface")
	AB.cylinder(0.7, 1.4, CREAM,
		AB.offset(originCF, 14.5, 10.5, 13.2), model, "CocoaFoam")

	-- Sidewalk: chocolate cobblestones
	for i = 1, 6 do
		for j = 1, 3 do
			local x = -12.5 + (i - 1) * 5
			local z = 14 + (j - 1) * 1.6
			local col = ((i + j) % 2 == 0) and DARKBR or BROWN
			AB.block(Vector3.new(4.5, 0.4, 1.4), col,
				AB.offset(originCF, x, 0.7, z), model, "Cobble_" .. i .. "_" .. j)
		end
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
