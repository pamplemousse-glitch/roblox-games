-- Taqueria El Sol — HERO open-front taqueria. Big hand-painted menu board,
-- grill with glowing embers, chili ristras, sun emblem, neon "EL SOL" sign.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local BOUG_PINK    = Color3.fromRGB(220, 80, 140)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local STUCCO_CREAM = Color3.fromRGB(245, 230, 200)
local ROOF_TILE    = Color3.fromRGB(140, 65, 40)
local GRILL_GREY   = Color3.fromRGB(55, 55, 60)
local EMBER_RED    = Color3.fromRGB(255, 95, 40)
local EMBER_ORG    = Color3.fromRGB(255, 150, 50)
local CHILI_RED    = Color3.fromRGB(190, 35, 35)
local CHALK_BLACK  = Color3.fromRGB(28, 28, 28)
local SALSA_RED    = Color3.fromRGB(180, 40, 35)
local SALSA_GRN    = Color3.fromRGB(120, 180, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TaqueriaElSol", parent)

	-- Foundation slab
	AB.block(Vector3.new(22, 0.5, 16), Color3.fromRGB(150, 145, 140),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Back wall (terracotta)
	AB.block(Vector3.new(20, 12, 0.8), TERRACOTTA,
		AB.offset(originCF, 0, 6.5, -6.6), model, "BackWall")

	-- Side walls (open-front, only half height in front for shop visibility)
	AB.block(Vector3.new(0.8, 12, 14), TERRACOTTA,
		AB.offset(originCF, -9.6, 6.5, 0), model, "WallL")
	AB.block(Vector3.new(0.8, 12, 14), TERRACOTTA,
		AB.offset(originCF, 9.6, 6.5, 0), model, "WallR")

	-- Accent stripe along base of back wall
	AB.block(Vector3.new(20, 1, 0.9), FIESTA_YEL,
		AB.offset(originCF, 0, 1.2, -6.55), model, "BaseStripe")

	-- Hand-painted menu board (12w x 4t) on the back wall
	local board = AB.block(Vector3.new(12, 4, 0.3), CHALK_BLACK,
		AB.offset(originCF, 0, 7.5, -6.15), model, "MenuBoard")
	-- Menu board frame
	AB.block(Vector3.new(12.6, 0.3, 0.4), WOOD_DARK,
		AB.offset(originCF, 0, 9.55, -6.1), model, "BoardFrameTop")
	AB.block(Vector3.new(12.6, 0.3, 0.4), WOOD_DARK,
		AB.offset(originCF, 0, 5.45, -6.1), model, "BoardFrameBot")
	AB.block(Vector3.new(0.3, 4.4, 0.4), WOOD_DARK,
		AB.offset(originCF, -6.15, 7.5, -6.1), model, "BoardFrameL")
	AB.block(Vector3.new(0.3, 4.4, 0.4), WOOD_DARK,
		AB.offset(originCF, 6.15, 7.5, -6.1), model, "BoardFrameR")

	-- Painted menu rows (4 rows, varied colored blocks suggesting writing)
	local rowColors = {FIESTA_YEL, BOUG_PINK, PAPEL_GREEN, AGAVE_TEAL}
	for r = 1, 4 do
		local y = 9.1 - (r - 1) * 1.0
		for c = 1, 7 do
			local x = -5.0 + (c - 1) * 1.6
			local w = 0.6 + (c % 3) * 0.3
			AB.block(Vector3.new(w, 0.45, 0.1), rowColors[r],
				AB.offset(originCF, x, y, -5.95), model, string.format("MenuText_%d_%d", r, c))
		end
	end

	-- Counter at front (wood top + terracotta front)
	AB.block(Vector3.new(18, 0.5, 2), WOOD_DARK,
		AB.offset(originCF, 0, 4, 5.5), model, "CounterTop")
	AB.block(Vector3.new(18, 3.5, 1.5), TERRACOTTA,
		AB.offset(originCF, 0, 2, 5.7), model, "CounterFront")
	-- Counter trim
	AB.block(Vector3.new(18, 0.3, 1.6), FIESTA_YEL,
		AB.offset(originCF, 0, 0.4, 5.7), model, "CounterTrim")

	-- Grill behind the counter
	AB.block(Vector3.new(9, 1.2, 3), GRILL_GREY,
		AB.offset(originCF, -2, 4.9, 2), model, "Grill")
	AB.block(Vector3.new(9, 0.3, 3), Color3.fromRGB(35, 35, 35),
		AB.offset(originCF, -2, 5.55, 2), model, "GrillGrate")

	-- 6 glowing embers (alternating red/orange neon)
	for i = 1, 6 do
		local x = -5.5 + (i - 1) * 1.4
		local c = (i % 2 == 0) and EMBER_RED or EMBER_ORG
		local ember = AB.block(Vector3.new(0.7, 0.25, 2.4), c,
			AB.offset(originCF, x, 5.4, 2), model, "Ember_" .. i)
		AB.neon(ember)
		AB.glow(ember, c, 2.0)
	end

	-- Tortilla press (next to grill, right side)
	AB.block(Vector3.new(2, 0.4, 2), Color3.fromRGB(45, 45, 45),
		AB.offset(originCF, 4, 4.7, 2), model, "PressBase")
	AB.cylinder(1.4, 0.4, Color3.fromRGB(60, 60, 60),
		AB.offset(originCF, 4, 5.1, 2), model, "PressDisc")
	AB.block(Vector3.new(0.4, 1.2, 0.4), WOOD_DARK,
		AB.offset(originCF, 4, 5.9, 1.2), model, "PressHandle")

	-- Salsa bowls on counter (3 bowls)
	for i, c in {SALSA_RED, SALSA_GRN, Color3.fromRGB(220, 180, 130)} do
		local x = 3 + i * 1.5
		AB.cylinder(1.0, 0.5, STUCCO_CREAM,
			AB.offset(originCF, x, 4.5, 5.2), model, "BowlOuter_" .. i)
		AB.cylinder(0.7, 0.4, c,
			AB.offset(originCF, x, 4.7, 5.2), model, "BowlSalsa_" .. i)
	end

	-- Tortilla stack on counter
	for i = 1, 5 do
		AB.cylinder(1.6, 0.12, Color3.fromRGB(230, 200, 140),
			AB.offset(originCF, -7, 4.4 + (i - 1) * 0.13, 5.2), model, "Tortilla_" .. i)
	end

	-- Sloped fiesta yellow awning shade (sticks out front)
	AB.block(Vector3.new(22, 0.5, 16), FIESTA_YEL,
		AB.offset(originCF, 0, 12.5, 1), model, "AwningBase")

	-- Striped fabric — alternating green / teal / pink stripes
	local stripeColors = {PAPEL_GREEN, AGAVE_TEAL, BOUG_PINK, PAPEL_GREEN, AGAVE_TEAL, BOUG_PINK, PAPEL_GREEN, AGAVE_TEAL}
	for i, c in stripeColors do
		AB.block(Vector3.new(2.5, 0.2, 15),
			c,
			AB.offset(originCF, -9 + (i - 1) * 2.5, 12.15, 1), model, "Stripe_" .. i)
	end

	-- Awning front fringe (small hanging triangles approximated with small blocks)
	for i = 1, 11 do
		AB.block(Vector3.new(1.6, 0.5, 0.2), STUCCO_CREAM,
			AB.offset(originCF, -10 + (i - 1) * 2, 11.85, 9), model, "Fringe_" .. i)
	end

	-- Sun emblem on awning peak (yellow neon sphere with 8 ray blocks)
	local sun = AB.sphere(2.6, FIESTA_YEL,
		AB.offset(originCF, 0, 14, 8), model, "SunCore")
	AB.neon(sun)
	AB.glow(sun, FIESTA_YEL, 3)
	for i = 1, 8 do
		local a = (i - 1) * math.pi / 4
		local rx = math.cos(a) * 2.4
		local ry = math.sin(a) * 2.4
		local ray = AB.block(Vector3.new(1.5, 0.4, 0.4), FIESTA_YEL,
			AB.offset(originCF, rx, 14 + ry, 8) * CFrame.Angles(0, 0, a),
			model, "SunRay_" .. i)
		AB.neon(ray)
	end

	-- Neon "EL SOL" sign letters (5 separate neon blocks) above awning
	local letterColors = {FIESTA_YEL, FIESTA_YEL, BOUG_PINK, BOUG_PINK, BOUG_PINK}
	for i = 1, 5 do
		local x = -6 + (i - 1) * 3
		local letter = AB.block(Vector3.new(2, 2.5, 0.4), letterColors[i],
			AB.offset(originCF, x, 16.5, -5.8), model, "Letter_" .. i)
		AB.neon(letter)
		AB.glow(letter, letterColors[i], 1.6)
	end

	-- Wooden support posts at four corners
	for i, pos in {Vector3.new(-9.6, 0, 6.8), Vector3.new(9.6, 0, 6.8), Vector3.new(-9.6, 0, -6.4), Vector3.new(9.6, 0, -6.4)} do
		AB.block(Vector3.new(0.8, 12, 0.8), WOOD_DARK,
			AB.offset(originCF, pos.X, 6, pos.Z), model, "Post_" .. i)
	end

	-- Small order window cutout in side wall (left), with chalkboard inside
	AB.block(Vector3.new(0.9, 2, 3), CHALK_BLACK,
		AB.offset(originCF, -9.55, 7, -3), model, "OrderWindow")
	AB.block(Vector3.new(1.0, 0.3, 3.2), WOOD_DARK,
		AB.offset(originCF, -9.55, 8.15, -3), model, "OrderWinFrameTop")
	AB.block(Vector3.new(1.0, 0.3, 3.2), WOOD_DARK,
		AB.offset(originCF, -9.55, 5.85, -3), model, "OrderWinFrameBot")

	-- Chili ristra (chain of red spheres) hanging from each front corner of awning
	for side, sx in {-1, 1} do
		for i = 1, 6 do
			AB.sphere(0.55, CHILI_RED,
				AB.offset(originCF, sx * 9, 11.5 - i * 0.7, 7.5), model,
				string.format("Chili_%d_%d", side, i))
		end
		-- String tie at top
		AB.block(Vector3.new(0.15, 0.5, 0.15), WOOD_DARK,
			AB.offset(originCF, sx * 9, 11.5, 7.5), model, "ChiliTie_" .. side)
	end

	-- Marigold pot at side (small decorative)
	AB.cylinder(1.6, 1.4, TERRACOTTA,
		AB.offset(originCF, -8, 1.2, 7.5), model, "MarigoldPot")
	for i = 1, 5 do
		AB.sphere(0.6, FIESTA_YEL,
			AB.offset(originCF, -8 + math.cos(i) * 0.5, 2.2 + (i % 2) * 0.3, 7.5 + math.sin(i) * 0.5),
			model, "Marigold_" .. i)
	end

	-- Sandwich board outside (chalkboard A-frame)
	AB.block(Vector3.new(3, 3, 0.3), CHALK_BLACK,
		AB.offset(originCF, 8, 2.5, 7.5, -15), model, "SandwichBoard")
	AB.block(Vector3.new(0.5, 0.5, 1), WOOD_DARK,
		AB.offset(originCF, 8, 0.4, 7.5), model, "SandwichBoardFoot")
	-- Painted text on sandwich board
	for i = 1, 3 do
		AB.block(Vector3.new(2, 0.3, 0.1), (i == 2) and FIESTA_YEL or STUCCO_CREAM,
			AB.offset(originCF, 8, 3 - i * 0.6, 7.35, -15), model, "BoardText_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
