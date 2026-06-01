-- Pachinko Machine — gaudy upright cabinet with neon top sign, glass play
-- area showing scattered pegs + a few ball positions, coin tray below.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CABINET     = Color3.fromRGB(60, 60, 70)
local NEON_PINK   = Color3.fromRGB(255, 90, 170)
local NEON_CYAN   = Color3.fromRGB(140, 220, 230)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local DARK_METAL  = Color3.fromRGB(55, 55, 65)
local GOLD        = Color3.fromRGB(220, 180, 60)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local SILVER      = Color3.fromRGB(200, 200, 210)
local VERMILION   = Color3.fromRGB(200, 50, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PachinkoMachine", parent)

	-- Cabinet body (tall narrow upright)
	AB.block(Vector3.new(4, 8, 2), CABINET,
		AB.offset(originCF, 0, 4, 0), model, "Cabinet")

	-- Top neon sign (gaudy pink)
	local topSign = AB.block(Vector3.new(4.4, 1.4, 0.5), NEON_PINK,
		AB.offset(originCF, 0, 8.4, 0.9), model, "TopSign")
	AB.neon(topSign)
	AB.glow(topSign, NEON_PINK, 2.5)
	-- Top sign frame
	AB.block(Vector3.new(4.6, 1.6, 0.55), DARK_METAL,
		AB.offset(originCF, 0, 8.4, 0.9), model, "TopSignFrame")
	-- Glowing yellow star accent
	local star = AB.sphere(0.8, LANTERN_Y,
		AB.offset(originCF, 1.5, 8.4, 1.1), model, "StarAccent")
	AB.neon(star)
	AB.glow(star, LANTERN_Y, 2)

	-- Glass play field (clear-ish blue panel)
	AB.part({
		size  = Vector3.new(3.4, 5, 0.2),
		color = NEON_CYAN, transparency = 0.4,
		cf    = AB.offset(originCF, 0, 5.2, 1.05),
		name  = "GlassField",
	}, model)
	-- Field border (gold)
	AB.block(Vector3.new(3.6, 0.2, 0.3), GOLD, AB.offset(originCF, 0, 7.7, 1.1), model, "FieldTop")
	AB.block(Vector3.new(3.6, 0.2, 0.3), GOLD, AB.offset(originCF, 0, 2.7, 1.1), model, "FieldBot")
	AB.block(Vector3.new(0.2, 5, 0.3), GOLD, AB.offset(originCF, -1.7, 5.2, 1.1), model, "FieldL")
	AB.block(Vector3.new(0.2, 5, 0.3), GOLD, AB.offset(originCF,  1.7, 5.2, 1.1), model, "FieldR")

	-- Scattered pegs inside the field (silver spheres)
	for row = 0, 4 do
		for col = 0, 4 do
			if (row + col) % 2 == 0 then
				local x = -1.2 + col * 0.6
				local y = 3.2 + row * 0.9
				AB.sphere(0.18, SILVER,
					AB.offset(originCF, x, y, 1.15), model, "Peg_" .. row .. "_" .. col)
			end
		end
	end

	-- Center jackpot indicator (vermilion sphere glowing)
	local jackpot = AB.sphere(0.6, VERMILION,
		AB.offset(originCF, 0, 3.5, 1.15), model, "Jackpot")
	AB.neon(jackpot)
	AB.glow(jackpot, VERMILION, 2)

	-- Lower controls panel
	AB.block(Vector3.new(3.6, 1.5, 0.3), DARK_METAL,
		AB.offset(originCF, 0, 1.5, 1.05), model, "Controls")
	-- Big launch knob (gold dial)
	AB.cylinder(0.9, 0.5, GOLD,
		AB.offset(originCF, 1.2, 1.4, 1.2) * CFrame.Angles(0, 0, math.rad(90)),
		model, "LaunchKnob")

	-- Coin tray (bottom recess)
	AB.block(Vector3.new(3.8, 0.4, 1.2), IRON_BLACK,
		AB.offset(originCF, 0, 0.5, 1), model, "CoinTray")
	-- Pile of coins
	for i = 1, 5 do
		AB.cylinder(0.35, 0.1, GOLD,
			AB.offset(originCF, -0.8 + i * 0.4, 0.65, 1), model, "Coin_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
