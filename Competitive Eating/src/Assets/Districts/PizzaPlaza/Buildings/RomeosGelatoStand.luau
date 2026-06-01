-- Romeo's Gelato Stand — pastel-colored kiosk with a glass display case
-- showing tubs of gelato, striped umbrella on top, and a small chalkboard menu.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PASTEL_PINK  = Color3.fromRGB(245, 200, 210)
local PASTEL_MINT  = Color3.fromRGB(180, 230, 210)
local PASTEL_BLUE  = Color3.fromRGB(180, 215, 235)
local PASTEL_CRM   = Color3.fromRGB(255, 240, 220)
local WHITE_HOT    = Color3.fromRGB(255, 255, 250)
local DARK_WD      = Color3.fromRGB(80, 50, 30)
local GELATO_STRWB = Color3.fromRGB(255, 130, 150)
local GELATO_PIST  = Color3.fromRGB(180, 220, 130)
local GELATO_CHOC  = Color3.fromRGB(120, 80, 50)
local GELATO_VAN   = Color3.fromRGB(250, 235, 210)
local GELATO_LMN   = Color3.fromRGB(240, 230, 100)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RomeosGelatoStand", parent)

	-- Foundation
	AB.block(Vector3.new(18, 0.4, 14), Color3.fromRGB(180, 175, 170),
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")

	-- Counter base (pastel pink)
	AB.block(Vector3.new(16, 4, 10), PASTEL_PINK, AB.offset(originCF, 0, 2.4, 0), model, "CounterBase")
	-- Pink scallop trim
	for i = -3, 3 do
		AB.cylinder(1.2, 0.6, WHITE_HOT, AB.offset(originCF, i * 2.4, 4.6, 5), model, "Scallop_" .. (i + 4))
	end

	-- Glass display case (transparent top)
	local glass = AB.block(Vector3.new(14, 3, 4), Color3.fromRGB(200, 220, 235),
		AB.offset(originCF, 0, 6, 2), model, "GlassCase")
	glass.Transparency = 0.5
	glass.Reflectance  = 0.3
	-- Case frame (dark wood)
	AB.block(Vector3.new(14.4, 0.3, 4.4), DARK_WD, AB.offset(originCF, 0, 7.6, 2), model, "GlassFrameTop")
	AB.block(Vector3.new(14.4, 0.3, 4.4), DARK_WD, AB.offset(originCF, 0, 4.5, 2), model, "GlassFrameBot")
	AB.block(Vector3.new(0.3, 3, 4.4), DARK_WD, AB.offset(originCF, -7, 6, 2), model, "GlassFrameL")
	AB.block(Vector3.new(0.3, 3, 4.4), DARK_WD, AB.offset(originCF,  7, 6, 2), model, "GlassFrameR")

	-- Gelato tubs inside the display (5 flavors)
	local flavors = {GELATO_STRWB, GELATO_PIST, GELATO_CHOC, GELATO_VAN, GELATO_LMN}
	for i, c in flavors do
		local x = -5.5 + (i - 1) * 2.75
		-- Tub
		AB.block(Vector3.new(2, 0.6, 3), Color3.fromRGB(220, 220, 220),
			AB.offset(originCF, x, 4.9, 2), model, "Tub_" .. i)
		-- Gelato mound (sphere on top)
		AB.sphere(1.6, c, AB.offset(originCF, x, 5.6, 2), model, "Gelato_" .. i)
		-- Scoop handle sticking out
		AB.cylinder(0.2, 1.2, Color3.fromRGB(170, 170, 175),
			AB.offset(originCF, x + 0.6, 6.2, 2.4) * CFrame.Angles(0, 0, math.rad(45)), model, "Scoop_" .. i)
	end

	-- Striped umbrella above the stand (mint + pink alternating wedges)
	local umbrellaCenter = AB.offset(originCF, 0, 12, 0)
	for i = 1, 8 do
		local angle = (i - 1) / 8 * 2 * math.pi
		local c = (i % 2 == 0) and PASTEL_MINT or PASTEL_PINK
		AB.wedge(Vector3.new(0.3, 2.5, 6), c,
			umbrellaCenter * CFrame.Angles(0, angle, math.rad(-25)) * CFrame.new(0, 0.5, 3),
			model, "Umb_" .. i)
	end
	-- Umbrella pole
	AB.cylinder(0.5, 14, DARK_WD, AB.offset(originCF, 0, 6, 0), model, "UmbPole")
	-- Umbrella finial
	AB.sphere(0.8, AB.colors.cheese, AB.offset(originCF, 0, 13.5, 0), model, "UmbFinial")

	-- "GELATO" neon sign on front of counter
	local sign = AB.block(Vector3.new(10, 1.5, 0.3), Color3.fromRGB(255, 130, 200),
		AB.offset(originCF, 0, 1.5, 5.2), model, "GelatoNeon")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 2)

	-- Chalkboard menu hanging off the counter
	AB.block(Vector3.new(3, 4, 0.2), Color3.fromRGB(30, 35, 30),
		AB.offset(originCF, -7.5, 6, 5.4), model, "Chalkboard")
	AB.block(Vector3.new(3.4, 0.3, 0.3), DARK_WD, AB.offset(originCF, -7.5, 4, 5.5), model, "ChalkFrameBot")
	AB.block(Vector3.new(3.4, 0.3, 0.3), DARK_WD, AB.offset(originCF, -7.5, 8, 5.5), model, "ChalkFrameTop")
	-- Chalk text suggestion (white scribbles)
	for i = 1, 4 do
		AB.block(Vector3.new(2, 0.15, 0.05), WHITE_HOT,
			AB.offset(originCF, -7.5, 7 - i * 0.6, 5.5), model, "Scribble_" .. i)
	end

	-- Small flower box on side
	AB.block(Vector3.new(4, 0.6, 1), DARK_WD, AB.offset(originCF, 6, 4.7, 5.3), model, "FlowerBox")
	for i = 1, 3 do
		AB.sphere(0.6, GELATO_STRWB,
			AB.offset(originCF, 5 + (i - 1) * 1, 5.2, 5.3), model, "Flower_" .. i)
	end

	-- Awning ruffle along front edge
	for i = -7, 7 do
		AB.wedge(Vector3.new(1.0, 0.6, 0.8), (i % 2 == 0) and PASTEL_MINT or PASTEL_PINK,
			AB.offset(originCF, i * 1, 2.2, 5.4) * CFrame.Angles(math.rad(180), 0, 0), model, "Ruffle_" .. (i + 8))
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
