-- Washi Paper Banner — a tall vertical paper banner mounted between two
-- bamboo poles, with vermilion + black calligraphic stripe pattern.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local VERMILION   = Color3.fromRGB(200, 50, 40)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local BAMBOO      = Color3.fromRGB(140, 180, 100)
local BAMBOO_DARK = Color3.fromRGB(100, 130, 70)
local STONE       = Color3.fromRGB(120, 115, 105)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WashiPaperBanner", parent)

	-- Two short stone bases
	for i, x in {-2, 2} do
		AB.block(Vector3.new(1, 0.4, 1), STONE,
			AB.offset(originCF, x, 0.2, 0), model, "Base_" .. i)
	end

	-- Two bamboo poles
	for i, x in {-2, 2} do
		AB.cylinder(0.4, 10, BAMBOO,
			AB.offset(originCF, x, 5.4, 0), model, "BambooPole_" .. i)
		-- Bamboo segment rings
		for j, y in {2, 4, 6, 8} do
			AB.cylinder(0.45, 0.15, BAMBOO_DARK,
				AB.offset(originCF, x, y, 0), model, "BambooRing_" .. i .. "_" .. j)
		end
	end

	-- Top crossbar (dark)
	AB.block(Vector3.new(5, 0.3, 0.3), BAMBOO_DARK,
		AB.offset(originCF, 0, 10, 0), model, "TopCrossbar")

	-- Main paper banner — tall white panel
	AB.block(Vector3.new(3, 8, 0.15), PAPER_WHITE,
		AB.offset(originCF, 0, 5.5, 0), model, "PaperFace")

	-- Vermilion top band
	AB.block(Vector3.new(3.1, 0.5, 0.16), VERMILION,
		AB.offset(originCF, 0, 9.2, 0.01), model, "TopBand")
	-- Vermilion bottom band
	AB.block(Vector3.new(3.1, 0.5, 0.16), VERMILION,
		AB.offset(originCF, 0, 1.8, 0.01), model, "BotBand")

	-- 4 black calligraphic stroke marks (suggesting characters)
	for i = 1, 4 do
		local y = 8.3 - (i - 1) * 1.7
		AB.block(Vector3.new(1.6, 0.18, 0.17), IRON_BLACK,
			AB.offset(originCF, 0.2, y, 0.02), model, "Stroke_" .. i .. "_H")
		AB.block(Vector3.new(0.18, 1.2, 0.17), IRON_BLACK,
			AB.offset(originCF, -0.4, y - 0.5, 0.02), model, "Stroke_" .. i .. "_V")
	end

	-- Single glowing red seal at bottom
	local seal = AB.block(Vector3.new(0.8, 0.8, 0.17), VERMILION,
		AB.offset(originCF, 0.6, 2.6, 0.03), model, "Seal")
	AB.neon(seal)
	AB.glow(seal, VERMILION, 1.5)

	-- Decorative tassel at top (yellow rope ball)
	AB.sphere(0.4, LANTERN_Y,
		AB.offset(originCF, 0, 9.9, 0), model, "Tassel")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
