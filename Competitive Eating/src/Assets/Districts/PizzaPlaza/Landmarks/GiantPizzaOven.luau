-- Giant Pizza Oven — landmark-scale wood-fired pizza oven with a domed brick
-- exterior, raging flames inside, a giant peel paddle, smoke chimney, and
-- a stack of huge prep ingredients.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BRICK     = Color3.fromRGB(150, 60, 50)
local DK_BRK    = Color3.fromRGB(110, 45, 40)
local STUCCO    = Color3.fromRGB(240, 220, 180)
local MORTAR    = Color3.fromRGB(180, 165, 140)
local FIRE_R    = Color3.fromRGB(255, 80, 30)
local FIRE_O    = Color3.fromRGB(255, 150, 50)
local FIRE_Y    = Color3.fromRGB(255, 220, 100)
local EMBER     = Color3.fromRGB(200, 60, 30)
local STEEL     = Color3.fromRGB(170, 170, 175)
local IRON      = Color3.fromRGB(50, 50, 55)
local WD        = Color3.fromRGB(110, 75, 45)
local GOLD      = Color3.fromRGB(220, 180, 60)
local SMOKE     = Color3.fromRGB(80, 80, 85)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GiantPizzaOven", parent)

	-- Base platform (stone)
	AB.block(Vector3.new(28, 4, 22), MORTAR, AB.offset(originCF, 0, 2, 0), model, "Base")
	-- Base brick courses (3 horizontal stripes)
	for i, y in {1, 2.5, 4} do
		AB.block(Vector3.new(28.1, 0.3, 22.1), DK_BRK, AB.offset(originCF, 0, y, 0), model, "BaseCourse_" .. i)
	end
	-- Base front trim (with steps leading up)
	for i = 1, 3 do
		AB.block(Vector3.new(20, 0.4, 1.5), MORTAR, AB.offset(originCF, 0, 0.2 + i * 0.4, 12 + i * 0.7), model, "Step_" .. i)
	end

	-- Oven dome body (massive sphere)
	AB.sphere(20, BRICK, AB.offset(originCF, 0, 14, 0), model, "DomeMain")
	-- Domed inner color (for visual layers, smaller sphere with stucco)
	AB.sphere(18, STUCCO, AB.offset(originCF, 0, 15, 0), model, "DomeInner")
	-- Reveal brick by carving with stucco overlay on top half
	-- Brick courses spiraling around the dome (8 horizontal rings of small bricks)
	for ring = 1, 6 do
		local y = 4 + ring * 1.8
		local r = 9.5 - ring * 0.8
		for i = 0, 23 do
			local angle = i / 24 * 2 * math.pi
			AB.block(Vector3.new(1.4, 0.7, 0.8), DK_BRK,
				AB.offset(originCF, r * math.cos(angle), y, r * math.sin(angle)) * CFrame.Angles(0, -angle, 0),
				model, "Course_" .. ring .. "_" .. i)
		end
	end

	-- Oven mouth (large arched opening on the front)
	-- Black recess inside oven mouth
	AB.block(Vector3.new(8, 5, 0.5), Color3.fromRGB(20, 15, 15),
		AB.offset(originCF, 0, 7, 9.5), model, "OvenMouthBack")
	-- Arched stone frame around the mouth
	AB.block(Vector3.new(10, 2, 1), DK_BRK, AB.offset(originCF, 0, 10.5, 9.5), model, "MouthTopFrame")
	AB.sphere(5, DK_BRK, AB.offset(originCF, 0, 10, 9.5), model, "MouthArch")
	-- Hide center of arch with black recess
	AB.sphere(4.2, Color3.fromRGB(20, 15, 15), AB.offset(originCF, 0, 9, 9.7), model, "MouthArchInner")
	-- Side frame stones
	AB.block(Vector3.new(1.2, 7, 1.2), DK_BRK, AB.offset(originCF, -5, 7, 9.5), model, "MouthSideL")
	AB.block(Vector3.new(1.2, 7, 1.2), DK_BRK, AB.offset(originCF,  5, 7, 9.5), model, "MouthSideR")
	-- Keystone (decorative gold)
	AB.wedge(Vector3.new(1.5, 2, 2), GOLD,
		AB.offset(originCF, 0, 12, 9.7) * CFrame.Angles(0, math.rad(90), 0), model, "Keystone")

	-- Raging fire inside the oven (multiple neon parts)
	for i = 1, 6 do
		local x = (math.random() - 0.5) * 5
		local y = 5 + math.random() * 2
		local z = 8 + math.random() * 1
		local size = 1.2 + math.random() * 0.8
		local color = ({FIRE_R, FIRE_O, FIRE_Y})[(i % 3) + 1]
		local flame = AB.sphere(size, color, AB.offset(originCF, x, y, z), model, "Flame_" .. i)
		AB.neon(flame)
		AB.glow(flame, flame.Color, 3)
	end
	-- Embers (small bright dots)
	for i = 1, 12 do
		local ember = AB.sphere(0.3, EMBER,
			AB.offset(originCF, (math.random() - 0.5) * 6, 4 + math.random() * 3, 7 + math.random() * 2), model, "Ember_" .. i)
		AB.neon(ember)
	end
	-- Charred log/wood stack inside
	for i = 1, 4 do
		AB.cylinder(0.5, 4, Color3.fromRGB(40, 25, 20),
			AB.offset(originCF, (i - 2.5) * 1, 4.2, 8) * CFrame.Angles(0, math.rad((i - 2) * 15), math.rad(90)),
			model, "Log_" .. i)
	end

	-- Pizza on the peel inside (just visible)
	AB.cylinder(3, 0.3, AB.colors.pizzaCrust,
		AB.offset(originCF, 0, 4.8, 8) * CFrame.Angles(0, 0, math.rad(90)), model, "OvenPizza")
	AB.sphere(0.5, AB.colors.pizzaRed, AB.offset(originCF, 0.6, 4.95, 8), model, "PieTop1")
	AB.sphere(0.5, AB.colors.pizzaRed, AB.offset(originCF, -0.6, 4.95, 8), model, "PieTop2")
	AB.sphere(0.5, AB.colors.pizzaRed, AB.offset(originCF, 0, 4.95, 7.4), model, "PieTop3")

	-- Giant pizza peel (paddle) leaning against the side
	AB.cylinder(0.4, 14, WD,
		AB.offset(originCF, -14, 8, 5) * CFrame.Angles(0, 0, math.rad(60)), model, "PeelHandle")
	AB.block(Vector3.new(4, 0.3, 4), STEEL,
		AB.offset(originCF, -18, 13, 5) * CFrame.Angles(0, 0, math.rad(60)), model, "PeelHead")
	-- Peel handle grip
	AB.block(Vector3.new(0.8, 1, 0.8), Color3.fromRGB(80, 50, 30),
		AB.offset(originCF, -12, 5, 5) * CFrame.Angles(0, 0, math.rad(60)), model, "PeelGrip")

	-- Massive chimney rising from the top of the dome
	AB.block(Vector3.new(4, 14, 4), BRICK, AB.offset(originCF, 0, 28, -5), model, "Chimney")
	-- Chimney brick courses
	for i, y in {22, 25, 28, 31, 34} do
		AB.block(Vector3.new(4.2, 0.4, 4.2), DK_BRK, AB.offset(originCF, 0, y, -5), model, "ChimneyCourse_" .. i)
	end
	-- Chimney cap (mushroom-shaped)
	AB.block(Vector3.new(5.5, 0.6, 5.5), DK_BRK, AB.offset(originCF, 0, 35.5, -5), model, "ChimneyCap")
	-- Decorative finial on cap
	AB.cylinder(0.6, 1.5, IRON, AB.offset(originCF, 0, 36.5, -5), model, "ChimneyFinial")
	-- Smoke billowing from chimney (transparent spheres)
	for i = 1, 5 do
		local smoke = AB.sphere(2 + i * 0.4, SMOKE,
			AB.offset(originCF, math.sin(i) * 1.5, 37 + i * 1.5, -5 + math.cos(i) * 1.5), model, "Smoke_" .. i)
		smoke.Transparency = 0.5 + i * 0.07
	end
	-- Glowing embers rising in smoke
	for i = 1, 6 do
		local ember = AB.sphere(0.25, EMBER,
			AB.offset(originCF, (math.random() - 0.5) * 3, 36 + i * 1.2, -5 + (math.random() - 0.5) * 3), model, "RisingEmber_" .. i)
		AB.neon(ember)
	end

	-- Decorative iron banding around the dome (3 metal strips)
	for i, y in {7, 11, 16} do
		AB.cylinder(11, 0.4, IRON,
			AB.offset(originCF, 0, y, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "DomeBand_" .. i)
	end

	-- Front-facing pizza-themed signage above the mouth
	local sign = AB.block(Vector3.new(14, 2.5, 0.4), Color3.fromRGB(220, 40, 40),
		AB.offset(originCF, 0, 14, 9.5), model, "OvenSign")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 3)
	AB.block(Vector3.new(14.4, 0.4, 0.6), GOLD, AB.offset(originCF, 0, 15.5, 9.7), model, "SignTopTrim")
	AB.block(Vector3.new(14.4, 0.4, 0.6), GOLD, AB.offset(originCF, 0, 12.5, 9.7), model, "SignBotTrim")
	-- Sign letters (5 white neon bars)
	for i = -2, 2 do
		local letter = AB.block(Vector3.new(1.6, 1.8, 0.3), Color3.fromRGB(255, 255, 230),
			AB.offset(originCF, i * 2.6, 14, 9.8), model, "SignLetter_" .. (i + 3))
		AB.neon(letter)
	end

	-- Side prep stations (stone counters with giant ingredients)
	for k, sx in {-11, 11} do
		AB.block(Vector3.new(6, 4, 5), STUCCO, AB.offset(originCF, sx, 6, 3), model, "PrepCounter_" .. k)
		AB.block(Vector3.new(6.4, 0.4, 5.4), STEEL, AB.offset(originCF, sx, 8.2, 3), model, "PrepTop_" .. k)
		-- Giant cheese wheel
		AB.cylinder(2, 1.2, AB.colors.cheese, AB.offset(originCF, sx, 9, 3) * CFrame.Angles(0, 0, math.rad(90)), model, "BigCheese_" .. k)
		-- Giant tomato
		AB.sphere(1.4, AB.colors.tomato, AB.offset(originCF, sx + (sx > 0 and -1.8 or 1.8), 9, 3), model, "BigTomato_" .. k)
		-- Giant flour sack
		AB.block(Vector3.new(2, 2.5, 2), Color3.fromRGB(240, 235, 220), AB.offset(originCF, sx, 9.7, 1), model, "BigFlour_" .. k)
		-- Sack label
		AB.block(Vector3.new(1.4, 0.6, 0.05), Color3.fromRGB(110, 30, 40),
			AB.offset(originCF, sx, 9.7, 2.05), model, "FlourLabel_" .. k)
	end

	-- Ground level wood pile (logs stacked)
	for i = 1, 5 do
		for k = 1, 4 do
			AB.cylinder(0.6, 4, Color3.fromRGB(140, 100, 60),
				AB.offset(originCF, -8 + i * 0.1, 0.6 + k * 0.6, -12 + (i - 3) * 0.5) * CFrame.Angles(math.rad(90), 0, 0),
				model, "WoodLog_" .. i .. "_" .. k)
		end
	end

	-- Tip jar / coin offering at the front
	AB.cylinder(1.4, 2, Color3.fromRGB(220, 240, 255), AB.offset(originCF, 8, 5, 12), model, "TipJar")
	for i = 1, 5 do
		AB.cylinder(0.7, 0.15, GOLD,
			AB.offset(originCF, 8, 4.2 + i * 0.25, 12) * CFrame.Angles(0, 0, math.rad(90)), model, "TipCoin_" .. i)
	end

	-- Italian flag on top of the chimney
	AB.cylinder(0.2, 5, IRON, AB.offset(originCF, 0, 39, -5), model, "FlagPoleTop")
	AB.block(Vector3.new(0.2, 1.5, 0.8), Color3.fromRGB(80, 140, 60), AB.offset(originCF, 0.4, 40, -5), model, "TopFlagG")
	AB.block(Vector3.new(0.2, 1.5, 0.8), Color3.fromRGB(245, 240, 230), AB.offset(originCF, 0.4, 40, -4.2), model, "TopFlagW")
	AB.block(Vector3.new(0.2, 1.5, 0.8), Color3.fromRGB(200, 40, 40), AB.offset(originCF, 0.4, 40, -3.4), model, "TopFlagR")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
