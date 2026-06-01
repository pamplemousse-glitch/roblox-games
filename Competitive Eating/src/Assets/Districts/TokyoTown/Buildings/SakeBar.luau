-- Sake Bar — narrow speakeasy. Dark facade, bamboo screen front, small
-- doorway with a single glowing kanji plate, bamboo grove flanking the
-- entrance. Tall + narrow proportions to feel like a hidden alley spot.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local BLACK       = Color3.fromRGB(35, 30, 35)
local BAMBOO      = Color3.fromRGB(140, 180, 100)
local BAMBOO_DARK = Color3.fromRGB(100, 130, 70)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local VERMILION   = Color3.fromRGB(200, 50, 40)
local SAKE_GREEN  = Color3.fromRGB(80, 110, 80)
local STONE       = Color3.fromRGB(120, 115, 105)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local CEDAR       = Color3.fromRGB(195, 145, 90)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SakeBar", parent)

	-- Stone foundation
	AB.block(Vector3.new(14, 0.5, 16), STONE,
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Tall narrow walls (16 high)
	AB.block(Vector3.new(14, 16, 1), BLACK, AB.offset(originCF, 0, 8, -7.5), model, "BackWall")
	AB.block(Vector3.new(1, 16, 16), BLACK, AB.offset(originCF, -6.5, 8, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 16, 16), BLACK, AB.offset(originCF,  6.5, 8, 0), model, "RightWall")

	-- Front facade — narrow speakeasy door
	AB.block(Vector3.new(5.75, 16, 1), BLACK, AB.offset(originCF, -4.125, 8, 7.5), model, "FrontLeft")
	AB.block(Vector3.new(5.75, 16, 1), BLACK, AB.offset(originCF,  4.125, 8, 7.5), model, "FrontRight")
	AB.block(Vector3.new(2.5, 9, 1),   BLACK, AB.offset(originCF, 0, 12.5, 7.5), model, "FrontHeader")

	-- Bamboo screen frontage — vertical bamboo stalks across the full front
	for i = -6, 6, 0.8 do
		if math.abs(i) > 1.4 then
			AB.cylinder(0.5, 13, BAMBOO,
				AB.offset(originCF, i, 7, 7.6), model, "BambooFront_" .. (i + 6))
		end
	end
	for i, y in {3, 6, 9, 12} do
		AB.block(Vector3.new(13, 0.18, 1.1), BAMBOO_DARK,
			AB.offset(originCF, 0, y, 7.65), model, "BambooBand_" .. i)
	end

	-- Doorway recessed into the bamboo
	AB.block(Vector3.new(2.4, 7.5, 0.4), DARK_WOOD,
		AB.offset(originCF, 0, 4.75, 7.7), model, "Door")
	AB.cylinder(0.3, 0.5, Color3.fromRGB(220, 180, 60),
		AB.offset(originCF, 0.8, 4.5, 7.85), model, "DoorHandle")

	-- Glowing kanji plate above doorway
	local kanji = AB.block(Vector3.new(2.4, 2.4, 0.4), LANTERN_Y,
		AB.offset(originCF, 0, 10, 7.9), model, "KanjiPlate")
	AB.neon(kanji)
	AB.glow(kanji, LANTERN_Y, 2.5)
	AB.block(Vector3.new(2.8, 2.8, 0.45), BLACK,
		AB.offset(originCF, 0, 10, 7.9), model, "KanjiBorder")

	-- Cedar accent band along the top of the front
	AB.block(Vector3.new(14.2, 0.5, 0.5), CEDAR,
		AB.offset(originCF, 0, 15.5, 7.7), model, "CedarTopBand")

	-- Bamboo grove flanking the entrance
	for _, sideData in {{-1, -9}, {1, 9}} do
		local side, baseX = sideData[1], sideData[2]
		for i = 0, 2 do
			local x = baseX + side * i * 0.7
			local h = 12 + i * 1.5
			AB.cylinder(0.5, h, BAMBOO,
				AB.offset(originCF, x, h / 2, 9 + i * 0.5), model, "BambooGrove_" .. baseX .. "_" .. i)
			AB.block(Vector3.new(1.6, 0.6, 1.6), BAMBOO_DARK,
				AB.offset(originCF, x, h, 9 + i * 0.5), model, "BambooLeaves_" .. baseX .. "_" .. i)
		end
	end

	-- Single small white paper lantern hanging beside the door
	local lantern = AB.cylinder(1.0, 1.4, PAPER_WHITE,
		AB.offset(originCF, -4, 9, 8.5), model, "SmallLantern")
	AB.neon(lantern)
	AB.glow(lantern, LANTERN_Y, 1.4)
	AB.block(Vector3.new(0.1, 0.8, 0.1), DARK_WOOD,
		AB.offset(originCF, -4, 9.9, 8.5), model, "SmallLanternRope")

	-- Flat dark roof with a single ridge accent
	AB.block(Vector3.new(16, 0.8, 18), DARK_WOOD,
		AB.offset(originCF, 0, 16.4, 0), model, "Roof")
	AB.block(Vector3.new(16.2, 0.3, 1), VERMILION,
		AB.offset(originCF, 0, 16.95, 0), model, "RoofRidge")

	-- Small sake-cup display ledge inside the bamboo screen
	for i, x in {-2.2, -1.4, -0.6, 0.6, 1.4, 2.2} do
		AB.cylinder(0.5, 0.4, SAKE_GREEN,
			AB.offset(originCF, x, 4, 7.0), model, "DispSakeCup_" .. i)
	end

	-- Stone path leading to door (3 stepping stones)
	for i = 0, 2 do
		AB.block(Vector3.new(2.4, 0.3, 1.8), STONE,
			AB.offset(originCF, 0, 0.65, 9 + i * 1.6), model, "Step_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
