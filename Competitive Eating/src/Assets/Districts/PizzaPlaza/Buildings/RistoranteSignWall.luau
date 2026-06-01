-- Ristorante Sign Wall — tall freestanding billboard / sign wall reading
-- "RISTORANTE" in big neon italic letters, framed by stucco columns and
-- topped with an Italian flag motif.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STUCCO    = Color3.fromRGB(240, 220, 180)
local DARK_WD   = Color3.fromRGB(80, 50, 30)
local NEON_RED  = Color3.fromRGB(255, 60, 40)
local NEON_GLD  = Color3.fromRGB(255, 220, 100)
local FLAG_GRN  = Color3.fromRGB(80, 140, 60)
local FLAG_WHT  = Color3.fromRGB(245, 240, 230)
local FLAG_RED  = Color3.fromRGB(200, 40, 40)
local BACK_BRK  = Color3.fromRGB(150, 60, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RistoranteSignWall", parent)

	-- Base plinth
	AB.block(Vector3.new(28, 1, 4), Color3.fromRGB(110, 100, 95),
		AB.offset(originCF, 0, 0.5, 0), model, "Plinth")

	-- Backing wall (brick)
	AB.block(Vector3.new(26, 18, 1), BACK_BRK, AB.offset(originCF, 0, 10, 0), model, "BackWall")

	-- Stucco columns flanking the sign
	for i, sx in {-1, 1} do
		AB.block(Vector3.new(2.5, 20, 2.5), STUCCO,
			AB.offset(originCF, sx * 12, 11, 1.5), model, "Column_" .. i)
		AB.block(Vector3.new(3, 1, 3), DARK_WD,
			AB.offset(originCF, sx * 12, 21.5, 1.5), model, "Capital_" .. i)
		AB.block(Vector3.new(3, 1, 3), DARK_WD,
			AB.offset(originCF, sx * 12, 1.5, 1.5), model, "ColBase_" .. i)
	end

	-- Sign panel (cream)
	AB.block(Vector3.new(22, 8, 0.4), Color3.fromRGB(245, 230, 200),
		AB.offset(originCF, 0, 11, 0.7), model, "SignPanel")
	-- Panel frame (gold)
	AB.block(Vector3.new(22.4, 0.4, 0.6), NEON_GLD, AB.offset(originCF, 0, 15, 0.85), model, "FrameTop")
	AB.block(Vector3.new(22.4, 0.4, 0.6), NEON_GLD, AB.offset(originCF, 0, 7, 0.85), model, "FrameBot")
	AB.block(Vector3.new(0.4, 8.4, 0.6), NEON_GLD, AB.offset(originCF, -11, 11, 0.85), model, "FrameL")
	AB.block(Vector3.new(0.4, 8.4, 0.6), NEON_GLD, AB.offset(originCF,  11, 11, 0.85), model, "FrameR")
	AB.neon(AB.block(Vector3.new(0.4, 8.4, 0.6), NEON_GLD, AB.offset(originCF, -11, 11, 0.95), model, "FrameLNeon"))
	AB.neon(AB.block(Vector3.new(0.4, 8.4, 0.6), NEON_GLD, AB.offset(originCF,  11, 11, 0.95), model, "FrameRNeon"))

	-- Big "RISTORANTE" neon — simplified as a long italic-tilted slab
	local main = AB.block(Vector3.new(20, 4, 0.4), NEON_RED, AB.offset(originCF, 0, 11, 1) * CFrame.Angles(0, 0, math.rad(-5)), model, "RistoranteNeon")
	AB.neon(main)
	AB.glow(main, main.Color, 3)
	-- "RISTORANTE" letter dot accents (simulate the letters with bumps)
	for i = -8, 8, 2 do
		local letter = AB.block(Vector3.new(1.2, 2.2, 0.2), NEON_RED,
			AB.offset(originCF, i, 11, 1.1) * CFrame.Angles(0, 0, math.rad(-5)),
			model, "Letter_" .. (i + 8))
		AB.neon(letter)
	end

	-- "FORNO • CUCINA" sub-label
	local sub = AB.block(Vector3.new(12, 0.8, 0.2), NEON_GLD,
		AB.offset(originCF, 0, 8.4, 1.0), model, "SubLabel")
	AB.neon(sub)
	AB.glow(sub, sub.Color, 1.5)

	-- Italian flag motif on top — three vertical bars
	AB.block(Vector3.new(2, 3, 0.4), FLAG_GRN, AB.offset(originCF, -2, 18, 0.7), model, "FlagGreen")
	AB.block(Vector3.new(2, 3, 0.4), FLAG_WHT, AB.offset(originCF,  0, 18, 0.7), model, "FlagWhite")
	AB.block(Vector3.new(2, 3, 0.4), FLAG_RED, AB.offset(originCF,  2, 18, 0.7), model, "FlagRed")
	-- Flag pole on top
	AB.cylinder(0.3, 4, DARK_WD, AB.offset(originCF, 0, 22, 0.7), model, "FlagPole")
	-- Flag waving (small triangular block)
	AB.wedge(Vector3.new(2.5, 1.5, 0.3), FLAG_RED, AB.offset(originCF, 1.5, 23, 0.7), model, "FlagWave")

	-- Lantern accents at the base of each column
	for i, sx in {-1, 1} do
		local g = AB.cylinder(1.2, 1.6, NEON_GLD,
			AB.offset(originCF, sx * 12, 3.5, 3.5) * CFrame.Angles(0, 0, math.rad(90)),
			model, "Lantern_" .. i)
		AB.neon(g)
		AB.glow(g, g.Color, 1.5)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
