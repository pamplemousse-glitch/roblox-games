-- Sushi Bar — clean white + black aesthetic with a long counter and a glass
-- display case showing sushi pieces. Subtle vermilion stripe accent.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local BLACK       = Color3.fromRGB(35, 30, 35)
local VERMILION   = Color3.fromRGB(200, 50, 40)
local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local GLASS_BLUE  = Color3.fromRGB(190, 220, 230)
local SALMON      = Color3.fromRGB(255, 130, 90)
local NORI        = Color3.fromRGB(40, 50, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SushiBar", parent)

	-- Foundation
	AB.block(Vector3.new(30, 0.4, 20), Color3.fromRGB(100, 100, 100),
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")

	-- Back + side walls — paper white
	AB.block(Vector3.new(30, 12, 1), PAPER_WHITE, AB.offset(originCF, 0, 6, -9.5), model, "BackWall")
	AB.block(Vector3.new(1, 12, 20), PAPER_WHITE, AB.offset(originCF, -14.5, 6, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 12, 20), PAPER_WHITE, AB.offset(originCF,  14.5, 6, 0), model, "RightWall")

	-- Black trim band along the top of the back wall
	AB.block(Vector3.new(30, 0.8, 1.1), BLACK,
		AB.offset(originCF, 0, 11.6, -9.5), model, "BlackTrim")

	-- Vermilion accent stripe halfway up the back wall
	AB.block(Vector3.new(30, 0.35, 1.1), VERMILION,
		AB.offset(originCF, 0, 8, -9.5), model, "AccentStripe")

	-- Front opening: low half-wall counter, no full enclosure
	AB.block(Vector3.new(30, 3, 0.5), BLACK,
		AB.offset(originCF, 0, 1.5, 9.5), model, "CounterFront")

	-- Long wooden counter inside (sushi prep surface)
	local counter = AB.block(Vector3.new(26, 0.4, 4), WARM_WOOD,
		AB.offset(originCF, 0, 3.4, 6), model, "Counter")

	-- Glass display case on the counter
	-- Frame (4 vertical posts + top frame)
	for i, offset in {
		Vector3.new(-12, 4.5, 6),
		Vector3.new( 12, 4.5, 6),
		Vector3.new(-12, 4.5, 4),
		Vector3.new( 12, 4.5, 4),
	} do
		AB.block(Vector3.new(0.2, 2, 0.2), BLACK,
			AB.offset(originCF, offset.X, offset.Y, offset.Z), model, "GlassPost_" .. i)
	end
	-- Glass panels (translucent blue)
	AB.part({
		size  = Vector3.new(24, 1.8, 0.1),
		color = GLASS_BLUE, transparency = 0.6,
		cf    = AB.offset(originCF, 0, 4.5, 7.1),
		name  = "GlassFront",
	}, model)
	AB.part({
		size  = Vector3.new(24, 1.8, 0.1),
		color = GLASS_BLUE, transparency = 0.6,
		cf    = AB.offset(originCF, 0, 4.5, 4.9),
		name  = "GlassBack",
	}, model)
	-- Top
	AB.block(Vector3.new(24.2, 0.2, 2.4), BLACK,
		AB.offset(originCF, 0, 5.5, 6), model, "GlassTop")

	-- Sushi pieces inside the display case (alternating salmon / nori)
	for i = 1, 7 do
		local x = (i - 4) * 3.0
		local color = (i % 2 == 1) and SALMON or NORI
		AB.cylinder(1.2, 1.4, color,
			AB.offset(originCF, x, 4.3, 6) * CFrame.Angles(0, math.rad(90), 0),
			model, "SushiPiece_" .. i)
	end

	-- Black flat roof
	AB.block(Vector3.new(32, 0.8, 22), BLACK,
		AB.offset(originCF, 0, 12.4, 0), model, "Roof")

	-- Vertical signboard (white paper with vermilion border) above center
	local sign = AB.block(Vector3.new(2.2, 5, 0.4), PAPER_WHITE,
		AB.offset(originCF, -10, 9, 9.7), model, "Sign")
	AB.block(Vector3.new(2.6, 0.4, 0.5), VERMILION, AB.offset(originCF, -10, 11.7, 9.7), model, "SignTop")
	AB.block(Vector3.new(2.6, 0.4, 0.5), VERMILION, AB.offset(originCF, -10, 6.3, 9.7),  model, "SignBottom")
	AB.glow(sign, PAPER_WHITE, 1.2)

	AB.pivot(model, counter)
	AB.weldAll(model)
	return model
end
