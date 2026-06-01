-- Quesadilla Stand — small corner stall with cheese-pull sculpture display.
-- Papel green walls, yellow trim, angled corner gives it character.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local STUCCO_CREAM = Color3.fromRGB(245, 230, 200)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local CHEESE_YEL   = Color3.fromRGB(255, 210, 90)
local TORTILLA     = Color3.fromRGB(230, 200, 140)
local CHALK_BLACK  = Color3.fromRGB(28, 28, 28)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("QuesadillaStand", parent)

	-- Foundation
	AB.block(Vector3.new(15, 0.5, 13), Color3.fromRGB(150, 145, 140),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Back wall + side wall (papel green)
	AB.block(Vector3.new(14, 10, 0.8), PAPEL_GREEN,
		AB.offset(originCF, 0, 5.5, -6), model, "BackWall")
	AB.block(Vector3.new(0.8, 10, 12), PAPEL_GREEN,
		AB.offset(originCF, -7, 5.5, 0), model, "WallL")

	-- DIAGONAL angled corner wall (rotated 45°)
	AB.block(Vector3.new(5, 10, 0.8), PAPEL_GREEN,
		AB.offset(originCF, 5.5, 5.5, 4, -45), model, "AngledCorner")

	-- Yellow accent trim along base
	AB.block(Vector3.new(14, 0.8, 0.9), FIESTA_YEL,
		AB.offset(originCF, 0, 1, -5.95), model, "BaseTrimBack")
	AB.block(Vector3.new(0.9, 0.8, 12), FIESTA_YEL,
		AB.offset(originCF, -6.95, 1, 0), model, "BaseTrimL")
	AB.block(Vector3.new(5, 0.8, 0.9), FIESTA_YEL,
		AB.offset(originCF, 5.5, 1, 4, -45), model, "BaseTrimAngle")

	-- Yellow accent trim along top (just under awning)
	AB.block(Vector3.new(14, 0.5, 0.9), FIESTA_YEL,
		AB.offset(originCF, 0, 10.3, -5.95), model, "TopTrimBack")

	-- Counter at front (wooden)
	AB.block(Vector3.new(14, 0.4, 2), WOOD_DARK,
		AB.offset(originCF, 0, 3.8, 5), model, "CounterTop")
	AB.block(Vector3.new(14, 3.3, 1.5), PAPEL_GREEN,
		AB.offset(originCF, 0, 2, 5.2), model, "CounterFront")
	-- Yellow trim on counter
	AB.block(Vector3.new(14, 0.3, 1.6), FIESTA_YEL,
		AB.offset(originCF, 0, 0.45, 5.2), model, "CounterBaseTrim")

	-- CHEESE PULL SCULPTURE — center of counter
	-- Tortilla disc (folded quesadilla suggested with a wedge)
	AB.cylinder(3.2, 0.35, TORTILLA,
		AB.offset(originCF, 0, 4.2, 5), model, "QuesadillaDisc")
	-- Top half lifted (cheese pull origin)
	AB.cylinder(2.6, 0.3, TORTILLA,
		AB.offset(originCF, 0, 6.5, 5) * CFrame.Angles(math.rad(20), 0, 0),
		model, "QuesadillaTop")
	-- Cheese strands stretching between (8 thin yellow blocks)
	for i = 1, 8 do
		local angle = (i - 1) * math.pi / 4
		local xOff = math.cos(angle) * 0.6
		local zOff = math.sin(angle) * 0.6
		local strand = AB.block(Vector3.new(0.12, 2.2, 0.12), CHEESE_YEL,
			AB.offset(originCF, xOff, 5.3, 5 + zOff)
				* CFrame.Angles(math.rad(((i % 2) * 2 - 1) * 8), 0, math.rad(((i % 3) - 1) * 6)),
			model, "CheeseStrand_" .. i)
		if i % 2 == 0 then AB.neon(strand) end
	end
	-- Cheese drips (small spheres at strand bottoms)
	for i = 1, 5 do
		AB.sphere(0.3, CHEESE_YEL,
			AB.offset(originCF, -1 + i * 0.4, 4.8, 5 + (i % 2) * 0.3),
			model, "Drip_" .. i)
	end

	-- Hanging sign "QUESADILLA" with neon yellow letters
	-- Sign chains
	AB.block(Vector3.new(0.1, 1.5, 0.1), WOOD_DARK,
		AB.offset(originCF, -4, 9.6, 5), model, "SignChainL")
	AB.block(Vector3.new(0.1, 1.5, 0.1), WOOD_DARK,
		AB.offset(originCF, 4, 9.6, 5), model, "SignChainR")
	-- Sign board
	AB.block(Vector3.new(9, 1.5, 0.3), STUCCO_CREAM,
		AB.offset(originCF, 0, 8.5, 5), model, "SignBoard")
	-- Neon letters (5 letters spelling part of QUESADILLA)
	for i = 1, 5 do
		local letter = AB.block(Vector3.new(1.2, 1.0, 0.2), FIESTA_YEL,
			AB.offset(originCF, -3.5 + (i - 1) * 1.7, 8.5, 5.2), model, "SignLetter_" .. i)
		AB.neon(letter)
		AB.glow(letter, FIESTA_YEL, 1.4)
	end

	-- Striped awning (green + cream stripes)
	AB.block(Vector3.new(16, 0.4, 5), PAPEL_GREEN,
		AB.offset(originCF, 0, 10.8, 6), model, "AwningBase")
	for i = 1, 6 do
		AB.block(Vector3.new(2.3, 0.2, 4.8),
			(i % 2 == 0) and STUCCO_CREAM or PAPEL_GREEN,
			AB.offset(originCF, -7 + (i - 1) * 2.4, 11.1, 6), model, "Stripe_" .. i)
	end
	-- Awning fringe
	for i = 1, 8 do
		AB.block(Vector3.new(1.6, 0.5, 0.2), STUCCO_CREAM,
			AB.offset(originCF, -7 + (i - 1) * 2, 10.6, 8.4), model, "Fringe_" .. i)
	end

	-- Stacked plates on left side of counter
	for i = 1, 6 do
		AB.cylinder(1.8, 0.1, STUCCO_CREAM,
			AB.offset(originCF, -4.5, 4.2 + (i - 1) * 0.12, 5), model, "Plate_" .. i)
	end

	-- Tortilla stack on right side of counter
	for i = 1, 8 do
		AB.cylinder(1.6, 0.1, TORTILLA,
			AB.offset(originCF, 4.5, 4.2 + (i - 1) * 0.11, 5), model, "TortillaStack_" .. i)
	end

	-- Small chalk menu board on side (mounted on angled corner)
	AB.block(Vector3.new(3, 4, 0.2), CHALK_BLACK,
		AB.offset(originCF, 6.5, 6, 4.5, -45), model, "ChalkBoard")
	-- Frame
	AB.block(Vector3.new(3.4, 0.3, 0.3), WOOD_DARK,
		AB.offset(originCF, 6.5, 8.05, 4.5, -45), model, "ChalkFrameTop")
	AB.block(Vector3.new(3.4, 0.3, 0.3), WOOD_DARK,
		AB.offset(originCF, 6.5, 3.95, 4.5, -45), model, "ChalkFrameBot")
	-- Chalk text rows
	for r = 1, 3 do
		AB.block(Vector3.new(2.3, 0.2, 0.05), STUCCO_CREAM,
			AB.offset(originCF, 6.5, 7.2 - (r - 1) * 0.8, 4.4, -45), model, "ChalkText_" .. r)
	end

	-- Cash box on counter
	AB.block(Vector3.new(1.8, 1.0, 1.2), WOOD_DARK,
		AB.offset(originCF, -5.5, 4.5, 5), model, "CashBox")
	AB.block(Vector3.new(1.8, 0.2, 1.2), FIESTA_YEL,
		AB.offset(originCF, -5.5, 5.05, 5), model, "CashBoxTop")

	-- Decorative succulent pot at entrance
	AB.cylinder(1.6, 1.4, TERRACOTTA,
		AB.offset(originCF, -6, 1.2, 6.5), model, "EntryPot")
	for i = 1, 6 do
		AB.sphere(0.55, PAPEL_GREEN,
			AB.offset(originCF, -6 + math.cos(i) * 0.5, 2.2 + (i % 2) * 0.3, 6.5 + math.sin(i) * 0.5),
			model, "EntrySucc_" .. i)
	end

	-- Order window cutout (in back wall area)
	AB.block(Vector3.new(3, 2.5, 0.4), CHALK_BLACK,
		AB.offset(originCF, -3, 6, -5.6), model, "OrderWindow")
	AB.block(Vector3.new(3.2, 0.3, 0.5), WOOD_DARK,
		AB.offset(originCF, -3, 7.3, -5.55), model, "OrderWinTop")
	AB.block(Vector3.new(3.2, 0.3, 0.5), WOOD_DARK,
		AB.offset(originCF, -3, 4.7, -5.55), model, "OrderWinBot")

	-- Corner support post
	AB.block(Vector3.new(0.8, 11, 0.8), WOOD_DARK,
		AB.offset(originCF, -6.9, 5.5, 5.9), model, "PostFront")

	-- Roof tiles on top
	for i = 1, 4 do
		AB.block(Vector3.new(16, 0.25, 1.4), Color3.fromRGB(140, 65, 40),
			AB.offset(originCF, 0, 11.4 + i * 0.2, 5 - (i - 1) * 1.2), model, "RoofTile_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
