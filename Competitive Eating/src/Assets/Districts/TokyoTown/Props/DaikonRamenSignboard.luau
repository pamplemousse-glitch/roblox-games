-- Daikon Ramen vertical signboard — standalone wood-post + vermilion hanging
-- panel meant to be placed at the entry corner. Footprint ≈ 4w × 7.1h × 0.9d.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION  = Color3.fromRGB(200, 50, 40)
local DEEP_RED   = Color3.fromRGB(140, 30, 30)
local DARK_WOOD  = Color3.fromRGB(70, 45, 30)
local MID_WOOD   = Color3.fromRGB(120, 85, 55)
local CREAM      = Color3.fromRGB(240, 232, 215)
local LANTERN_Y  = Color3.fromRGB(255, 180, 70)
local GREY_STONE = Color3.fromRGB(110, 110, 110)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DaikonRamenSignboard", parent)

	-- Stone base
	AB.block(Vector3.new(2.5, 0.4, 1.5), GREY_STONE,
		AB.offset(originCF, 0, 0.2, 0), model, "StoneBase")

	-- Main vertical wood post
	AB.block(Vector3.new(0.7, 7.0, 0.7), DARK_WOOD,
		AB.offset(originCF, -1.4, 3.9, 0), model, "Post")

	-- Cross-arm extending right from top of post
	AB.block(Vector3.new(2.8, 0.4, 0.4), DARK_WOOD,
		AB.offset(originCF, 0, 6.8, 0), model, "CrossArm")

	-- Hanging vermilion panel (the main sign face)
	AB.block(Vector3.new(3.0, 5.2, 0.4), VERMILION,
		AB.offset(originCF, 0.4, 3.8, 0), model, "SignFace")
	-- Dark wood frame top + bottom + sides
	AB.block(Vector3.new(3.4, 0.35, 0.5), DARK_WOOD,
		AB.offset(originCF, 0.4, 6.5, 0), model, "FrameTop")
	AB.block(Vector3.new(3.4, 0.35, 0.5), DARK_WOOD,
		AB.offset(originCF, 0.4, 1.1, 0), model, "FrameBot")
	AB.block(Vector3.new(0.25, 5.5, 0.5), DARK_WOOD,
		AB.offset(originCF, -1.2, 3.8, 0), model, "FrameL")
	AB.block(Vector3.new(0.25, 5.5, 0.5), DARK_WOOD,
		AB.offset(originCF,  2.0, 3.8, 0), model, "FrameR")

	-- White kanji-band block in the middle (where the decal would print)
	AB.block(Vector3.new(2.6, 1.4, 0.42), CREAM,
		AB.offset(originCF, 0.4, 4.2, 0), model, "KanjiBand")
	-- Smaller deep-red accent band below
	AB.block(Vector3.new(2.6, 0.6, 0.42), DEEP_RED,
		AB.offset(originCF, 0.4, 3.0, 0), model, "AccentBand")

	-- Two short ropes connecting cross-arm to frame top
	for i, x in {-0.8, 1.6} do
		AB.block(Vector3.new(0.12, 0.5, 0.12), MID_WOOD,
			AB.offset(originCF, x, 6.65, 0), model, "Rope_" .. i)
	end

	-- Small glowing lantern at top of post
	local lantern = AB.cylinder(0.9, 1.2, LANTERN_Y,
		AB.offset(originCF, -1.4, 7.8, 0), model, "PostLantern")
	AB.neon(lantern)
	AB.glow(lantern, lantern.Color, 1.4)
	AB.cylinder(0.95, 0.12, DARK_WOOD,
		AB.offset(originCF, -1.4, 8.45, 0), model, "PostLanternTop")
	AB.cylinder(0.95, 0.12, DARK_WOOD,
		AB.offset(originCF, -1.4, 7.15, 0), model, "PostLanternBot")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
