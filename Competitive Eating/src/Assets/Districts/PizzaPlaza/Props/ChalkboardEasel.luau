-- Chalkboard Easel — standing chalkboard on a wooden tripod easel with
-- a hand-drawn pizza of the day.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WD        = Color3.fromRGB(110, 75, 45)
local DK_WD     = Color3.fromRGB(80, 50, 30)
local BOARD     = Color3.fromRGB(30, 35, 30)
local CHALK_W   = Color3.fromRGB(245, 240, 230)
local CHALK_Y   = Color3.fromRGB(240, 220, 100)
local CHALK_R   = Color3.fromRGB(220, 80, 80)
local CHALK_G   = Color3.fromRGB(120, 200, 130)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ChalkboardEasel", parent)

	-- Tripod legs (3)
	AB.cylinder(0.3, 7, WD,
		AB.offset(originCF, -1.4, 3.5, 1) * CFrame.Angles(math.rad(8), 0, math.rad(15)), model, "LegFL")
	AB.cylinder(0.3, 7, WD,
		AB.offset(originCF, 1.4, 3.5, 1) * CFrame.Angles(math.rad(8), 0, math.rad(-15)), model, "LegFR")
	AB.cylinder(0.3, 7, WD,
		AB.offset(originCF, 0, 3.5, -1.2) * CFrame.Angles(math.rad(-15), 0, 0), model, "LegBack")
	-- Cross brace
	AB.block(Vector3.new(3, 0.2, 0.2), DK_WD, AB.offset(originCF, 0, 2.5, 0), model, "CrossBrace")

	-- Chalkboard panel
	AB.block(Vector3.new(5, 4, 0.3), BOARD, AB.offset(originCF, 0, 5.5, 0), model, "Board")
	-- Board frame
	AB.block(Vector3.new(5.4, 0.3, 0.4), DK_WD, AB.offset(originCF, 0, 7.6, 0), model, "FrameTop")
	AB.block(Vector3.new(5.4, 0.3, 0.4), DK_WD, AB.offset(originCF, 0, 3.4, 0), model, "FrameBot")
	AB.block(Vector3.new(0.3, 4, 0.4), DK_WD, AB.offset(originCF, -2.65, 5.5, 0), model, "FrameL")
	AB.block(Vector3.new(0.3, 4, 0.4), DK_WD, AB.offset(originCF,  2.65, 5.5, 0), model, "FrameR")

	-- "PIZZA DEL GIORNO" title (yellow chalk)
	AB.block(Vector3.new(4, 0.4, 0.05), CHALK_Y, AB.offset(originCF, 0, 7, 0.18), model, "TitleStripe")
	for i = -1, 1 do
		AB.block(Vector3.new(1, 0.3, 0.04), CHALK_W, AB.offset(originCF, i * 1.4, 7, 0.2), model, "TitleSeg_" .. (i + 2))
	end

	-- Pizza drawing (white circle outline + red dots)
	-- Circle outline as 8 small blocks around a circle
	for i = 0, 7 do
		local angle = i / 8 * 2 * math.pi
		AB.block(Vector3.new(0.4, 0.15, 0.05), CHALK_W,
			AB.offset(originCF, 1.4 * math.cos(angle), 5.5 + 1.4 * math.sin(angle), 0.18) * CFrame.Angles(0, 0, angle),
			model, "PieEdge_" .. i)
	end
	-- Pepperoni dots
	AB.sphere(0.18, CHALK_R, AB.offset(originCF, 0.4, 5.7, 0.2), model, "PepDot1")
	AB.sphere(0.18, CHALK_R, AB.offset(originCF, -0.5, 5.3, 0.2), model, "PepDot2")
	AB.sphere(0.18, CHALK_R, AB.offset(originCF, 0.3, 5.1, 0.2), model, "PepDot3")
	AB.sphere(0.18, CHALK_R, AB.offset(originCF, -0.4, 5.9, 0.2), model, "PepDot4")
	-- Basil leaves (green)
	AB.sphere(0.15, CHALK_G, AB.offset(originCF, 0.6, 5.5, 0.2), model, "BasilDot1")
	AB.sphere(0.15, CHALK_G, AB.offset(originCF, -0.6, 5.5, 0.2), model, "BasilDot2")

	-- "€8" price tag (red chalk box)
	AB.block(Vector3.new(0.8, 0.6, 0.05), CHALK_R, AB.offset(originCF, 1.8, 4, 0.18), model, "PriceBox")
	AB.block(Vector3.new(0.6, 0.3, 0.04), CHALK_W, AB.offset(originCF, 1.8, 4, 0.2), model, "PriceTxt")

	-- Chalk ledge (with chalk pieces)
	AB.block(Vector3.new(5.4, 0.25, 0.6), DK_WD, AB.offset(originCF, 0, 3.5, 0.4), model, "ChalkLedge")
	for i, c in {CHALK_W, CHALK_R, CHALK_Y, CHALK_G} do
		AB.cylinder(0.12, 0.8, c,
			AB.offset(originCF, -1.4 + (i - 1) * 0.6, 3.6, 0.5) * CFrame.Angles(0, math.rad(90), math.rad(90)),
			model, "Chalk_" .. i)
	end
	-- Eraser
	AB.block(Vector3.new(0.8, 0.3, 0.4), Color3.fromRGB(180, 100, 70), AB.offset(originCF, 2, 3.65, 0.5), model, "Eraser")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
