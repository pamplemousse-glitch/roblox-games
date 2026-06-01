-- Baroque Arch Entry — grand triumphal arch as the entry to Pizza Plaza,
-- with twin columns, a central archway, a sculpted keystone, and a "PIAZZA
-- ITALIA" neon banner.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local MARBLE    = Color3.fromRGB(235, 225, 200)
local DK_MARBLE = Color3.fromRGB(195, 180, 155)
local SHADOW    = Color3.fromRGB(160, 150, 130)
local GOLD      = Color3.fromRGB(220, 180, 60)
local NEON_RED  = Color3.fromRGB(255, 60, 40)
local NEON_GRN  = Color3.fromRGB(120, 230, 130)
local NEON_WHT  = Color3.fromRGB(255, 255, 230)
local AGED_BR   = Color3.fromRGB(120, 100, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BaroqueArchEntry", parent)

	-- Foundation plinth
	AB.block(Vector3.new(36, 2, 8), DK_MARBLE, AB.offset(originCF, 0, 1, 0), model, "Foundation")
	AB.block(Vector3.new(36, 0.4, 8.4), GOLD, AB.offset(originCF, 0, 2.2, 0), model, "FoundCap")

	-- Two great columns (left + right)
	for k, sx in {-12, 12} do
		-- Column base
		AB.block(Vector3.new(5, 1.5, 5), MARBLE, AB.offset(originCF, sx, 3, 0), model, "ColBase_" .. k)
		AB.block(Vector3.new(5.4, 0.3, 5.4), GOLD, AB.offset(originCF, sx, 3.9, 0), model, "ColBaseCap_" .. k)
		-- Column shaft (fluted via 8 cylinders around perimeter)
		AB.cylinder(3.5, 16, MARBLE, AB.offset(originCF, sx, 12, 0), model, "ColShaft_" .. k)
		-- Flutes (8 vertical grooves)
		for i = 0, 7 do
			local angle = i / 8 * 2 * math.pi
			AB.block(Vector3.new(0.3, 16, 0.3), SHADOW,
				AB.offset(originCF, sx + 1.7 * math.cos(angle), 12, 1.7 * math.sin(angle)), model, "Flute_" .. k .. "_" .. i)
		end
		-- Column capital (Corinthian-style)
		AB.cylinder(4, 1, MARBLE, AB.offset(originCF, sx, 20.5, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "ColCap_" .. k)
		AB.cylinder(4.3, 0.5, GOLD, AB.offset(originCF, sx, 21.2, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "ColCapGold_" .. k)
		-- Acanthus leaves around capital
		for i = 0, 5 do
			local angle = i / 6 * 2 * math.pi
			AB.wedge(Vector3.new(0.8, 1.5, 1.2), AGED_BR,
				AB.offset(originCF, sx + 1.8 * math.cos(angle), 20, 1.8 * math.sin(angle)) * CFrame.Angles(math.rad(180), -angle, 0),
				model, "Acanthus_" .. k .. "_" .. i)
		end
	end

	-- Central arch span — entablature above columns
	AB.block(Vector3.new(36, 3, 6), MARBLE, AB.offset(originCF, 0, 23, 0), model, "Entablature")
	-- Gold trim
	AB.block(Vector3.new(36.4, 0.4, 6.4), GOLD, AB.offset(originCF, 0, 24.7, 0), model, "EntabTrimTop")
	AB.block(Vector3.new(36.4, 0.4, 6.4), GOLD, AB.offset(originCF, 0, 21.7, 0), model, "EntabTrimBot")
	-- Cornice (small projecting ledge)
	AB.block(Vector3.new(38, 0.6, 7), DK_MARBLE, AB.offset(originCF, 0, 25.2, 0), model, "Cornice")

	-- Central archway opening (created by leaving gap between segments)
	-- Side walls of archway (left + right of opening)
	AB.block(Vector3.new(6, 16, 4), MARBLE, AB.offset(originCF, -6, 12, 0), model, "ArchSideL")
	AB.block(Vector3.new(6, 16, 4), MARBLE, AB.offset(originCF,  6, 12, 0), model, "ArchSideR")
	-- Archway curve (using sphere at top of opening)
	AB.sphere(4, MARBLE, AB.offset(originCF, 0, 20, 0), model, "ArchCurve")
	-- Inner archway shadow (recess)
	AB.block(Vector3.new(8, 12, 1), SHADOW, AB.offset(originCF, 0, 10, 0), model, "ArchRecess")

	-- Keystone (decorative carved stone at top of arch)
	AB.wedge(Vector3.new(2.5, 3, 4), GOLD,
		AB.offset(originCF, 0, 21, 0) * CFrame.Angles(0, math.rad(90), 0), model, "Keystone")
	-- Keystone face (carved gargoyle / lion head)
	AB.sphere(1.3, AGED_BR, AB.offset(originCF, 0, 20.5, 2), model, "KeystoneFace")
	-- Lion mane
	for i = 0, 7 do
		local angle = i / 8 * 2 * math.pi
		AB.wedge(Vector3.new(0.4, 0.8, 0.6), AGED_BR,
			AB.offset(originCF, math.cos(angle) * 1.5, 20.5 + math.sin(angle) * 1.5, 2.1) * CFrame.Angles(math.rad(180), 0, -angle),
			model, "Mane_" .. i)
	end
	-- Lion mouth (small dark hole)
	AB.block(Vector3.new(0.4, 0.4, 0.3), SHADOW, AB.offset(originCF, 0, 20, 2.5), model, "LionMouth")

	-- Carved relief panels above columns (low-relief decorative blocks)
	for k, sx in {-12, 12} do
		AB.block(Vector3.new(4, 2, 0.3), GOLD, AB.offset(originCF, sx, 23, 3.1), model, "Relief_" .. k)
	end

	-- Pediment (triangular gable on top)
	AB.wedge(Vector3.new(2.5, 6, 36), MARBLE,
		AB.offset(originCF, 0, 28.5, 0) * CFrame.Angles(0, math.rad(90), 0), model, "Pediment")
	-- Gold trim along pediment edges
	AB.block(Vector3.new(36, 0.4, 7), GOLD, AB.offset(originCF, 0, 25.7, 0), model, "PedimentBase")
	-- Pediment crest (statue at top)
	AB.sphere(2, GOLD, AB.offset(originCF, 0, 33, 0), model, "PedimentCrest")
	AB.cylinder(0.6, 3, GOLD, AB.offset(originCF, 0, 31.5, 0), model, "CrestSpire")

	-- "PIAZZA ITALIA" neon banner across the front
	local banner = AB.block(Vector3.new(24, 2.5, 0.4), NEON_RED,
		AB.offset(originCF, 0, 23, 3.5), model, "NeonBanner")
	AB.neon(banner)
	AB.glow(banner, banner.Color, 3)
	-- Banner border (gold)
	AB.block(Vector3.new(24.5, 0.3, 0.5), GOLD, AB.offset(originCF, 0, 24.5, 3.55), model, "BannerTop")
	AB.block(Vector3.new(24.5, 0.3, 0.5), GOLD, AB.offset(originCF, 0, 21.5, 3.55), model, "BannerBot")
	-- Banner letter accents (5 white neon bars)
	for i = -2, 2 do
		local letter = AB.block(Vector3.new(1.5, 1.8, 0.3), NEON_WHT,
			AB.offset(originCF, i * 4, 23, 3.7), model, "BannerLetter_" .. (i + 3))
		AB.neon(letter)
	end

	-- Side statues atop columns (allegorical figures)
	for k, sx in {-12, 12} do
		AB.cylinder(1.4, 4, MARBLE, AB.offset(originCF, sx, 28, 0), model, "TopStatue_" .. k)
		AB.sphere(1.2, MARBLE, AB.offset(originCF, sx, 30.5, 0), model, "TopHead_" .. k)
		-- Wreath in hand
		AB.cylinder(1.2, 0.3, GOLD,
			AB.offset(originCF, sx + (sx > 0 and -1.5 or 1.5), 29, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "TopWreath_" .. k)
	end

	-- Hanging lanterns from arch (2)
	for k, sx in {-3, 3} do
		AB.cylinder(0.2, 4, AGED_BR, AB.offset(originCF, sx, 16, 2), model, "LantChain_" .. k)
		local glow = AB.sphere(1.2, Color3.fromRGB(255, 220, 140), AB.offset(originCF, sx, 13, 2), model, "Lantern_" .. k)
		AB.neon(glow)
		AB.glow(glow, glow.Color, 2.5)
		-- Lantern cage
		for i = 0, 3 do
			local angle = i / 4 * 2 * math.pi
			AB.block(Vector3.new(0.1, 2, 0.1), AGED_BR,
				AB.offset(originCF, sx + math.cos(angle) * 1.3, 13, 2 + math.sin(angle) * 1.3), model, "LantCage_" .. k .. "_" .. i)
		end
	end

	-- Italian flag motif on the keystone area (3 stripes)
	AB.block(Vector3.new(1.2, 2, 0.2), Color3.fromRGB(80, 140, 60), AB.offset(originCF, -1.5, 26, 3.5), model, "FlagG")
	AB.block(Vector3.new(1.2, 2, 0.2), Color3.fromRGB(245, 240, 230), AB.offset(originCF, 0, 26, 3.5), model, "FlagW")
	AB.block(Vector3.new(1.2, 2, 0.2), Color3.fromRGB(200, 40, 40), AB.offset(originCF, 1.5, 26, 3.5), model, "FlagR")

	-- Cobblestone walkway leading through
	for i = 0, 4 do
		AB.block(Vector3.new(8, 0.3, 1), DK_MARBLE, AB.offset(originCF, 0, 0.15, -3 + i * 1.5), model, "Cobble_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
