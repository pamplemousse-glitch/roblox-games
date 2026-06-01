-- Mariachi Gear Pile — instruments left in a heap on a circular floor disc.
-- Guitarrón, acoustic guitar, vihuela, trumpet, maracas, topped by a sombrero.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BURGUNDY    = Color3.fromRGB(110, 30, 40)
local CREAM       = Color3.fromRGB(245, 230, 200)
local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local WOOD_LIGHT  = Color3.fromRGB(170, 130, 80)
local GOLD_TRUMP  = Color3.fromRGB(220, 175, 60)
local SOUNDHOLE   = Color3.fromRGB(40, 25, 15)
local MARACA_RED  = Color3.fromRGB(180, 50, 50)
local TERRACOTTA  = Color3.fromRGB(196, 95, 44)
local DISC_DARK   = Color3.fromRGB(80, 65, 55)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MariachiGearPile", parent)

	-- Ground disc
	local disc = AB.cylinder(6, 1, DISC_DARK,
		AB.offset(originCF, 0, 0.5, 0), model, "GroundDisc")

	-- Guitarrón (big rounded body)
	AB.sphere(2.4, BURGUNDY,
		AB.offset(originCF, -1.2, 1.6, -0.5), model, "GuitarronBody")
	AB.block(Vector3.new(0.4, 0.3, 2.5), WOOD_DARK,
		AB.offset(originCF, -1.2, 1.7, 1.7), model, "GuitarronNeck")
	AB.sphere(0.6, SOUNDHOLE,
		AB.offset(originCF, -1.2, 2.4, -0.4), model, "GuitarronHole")

	-- Acoustic guitar laying on side
	AB.sphere(1.8, CREAM,
		AB.offset(originCF, 1.4, 1.3, 0.3), model, "GuitarBody")
	AB.block(Vector3.new(0.3, 0.25, 2.2), WOOD_DARK,
		AB.offset(originCF, 1.4, 1.4, 2.4), model, "GuitarNeck")
	AB.sphere(0.45, SOUNDHOLE,
		AB.offset(originCF, 1.4, 2, 0.4), model, "GuitarHole")

	-- Vihuela (small guitar)
	AB.sphere(1.2, WOOD_LIGHT,
		AB.offset(originCF, 0.2, 2.2, -1.7), model, "VihuelaBody")
	AB.block(Vector3.new(0.25, 0.2, 1.5), WOOD_DARK,
		AB.offset(originCF, 0.2, 2.3, -3), model, "VihuelaNeck")

	-- Trumpet — thin gold cylinder with a flared bell
	AB.cylinder(0.4, 3, GOLD_TRUMP,
		AB.offset(originCF, -2, 2.4, 1.5) * CFrame.Angles(0, math.rad(35), 0),
		model, "TrumpetTube")
	local bell = AB.cylinder(1.1, 0.6, GOLD_TRUMP,
		AB.offset(originCF, -2.9, 2.4, 0.5) * CFrame.Angles(0, math.rad(35), 0),
		model, "TrumpetBell")
	AB.neon(bell)

	-- Maracas (2 spheres on sticks)
	for i, dx in {-0.6, 0.6} do
		AB.sphere(0.7, MARACA_RED,
			AB.offset(originCF, 2.1, 1.5 + i * 0.3, -1.4 + dx), model, "Maraca_" .. i)
		AB.block(Vector3.new(0.18, 0.18, 1), WOOD_DARK,
			AB.offset(originCF, 2.1, 1.2 + i * 0.3, -2.1 + dx), model, "MaracaStick_" .. i)
	end

	-- Sombrero on top of the pile
	AB.cylinder(2.8, 0.25, TERRACOTTA,
		AB.offset(originCF, 0, 3.2, 0), model, "TopSombreroBrim")
	AB.cylinder(1.4, 0.9, TERRACOTTA,
		AB.offset(originCF, 0, 3.7, 0), model, "TopSombreroCrown")
	AB.cylinder(1.45, 0.2, GOLD_TRUMP,
		AB.offset(originCF, 0, 3.35, 0), model, "TopSombreroBand")

	AB.pivot(model, disc)
	AB.weldAll(model)
	return model
end
