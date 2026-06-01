-- Pasta Cart — wheeled cart displaying fresh pasta in trays (spaghetti,
-- ravioli, fettuccine), with a flour sack and a hanging garlic braid.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WD        = Color3.fromRGB(110, 75, 45)
local DK_WD     = Color3.fromRGB(80, 50, 30)
local STEEL     = Color3.fromRGB(170, 170, 175)
local PASTA_CRM = Color3.fromRGB(240, 220, 180)
local PASTA_YEL = Color3.fromRGB(230, 200, 130)
local SAUCE_R   = Color3.fromRGB(200, 60, 50)
local FLOUR     = Color3.fromRGB(240, 235, 220)
local GARLIC_W  = Color3.fromRGB(230, 220, 200)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PastaCart", parent)

	-- Cart body
	AB.block(Vector3.new(7, 3, 4), WD, AB.offset(originCF, 0, 2.5, 0), model, "Body")
	-- Top counter (steel)
	AB.block(Vector3.new(7.2, 0.4, 4.2), STEEL, AB.offset(originCF, 0, 4.2, 0), model, "CounterTop")
	-- Dark wood trim
	AB.block(Vector3.new(7.4, 0.3, 4.4), DK_WD, AB.offset(originCF, 0, 1, 0), model, "BotTrim")

	-- 3 trays on the counter
	-- Spaghetti tray (yellow strands)
	AB.block(Vector3.new(2, 0.3, 3), STEEL, AB.offset(originCF, -2.3, 4.5, 0), model, "Tray1")
	-- Spaghetti strands (long thin cylinders)
	for i = 1, 8 do
		AB.cylinder(0.1, 2.6, PASTA_YEL,
			AB.offset(originCF, -2.3 + (math.random() - 0.5) * 1.5, 4.7 + math.random() * 0.2, 0), model, "Spaghetti_" .. i)
	end

	-- Ravioli tray (small white pillows)
	AB.block(Vector3.new(2, 0.3, 3), STEEL, AB.offset(originCF, 0, 4.5, 0), model, "Tray2")
	for r = 1, 3 do
		for c = 1, 3 do
			AB.block(Vector3.new(0.5, 0.25, 0.5), PASTA_CRM,
				AB.offset(originCF, -0.5 + (c - 1) * 0.5, 4.75, -0.8 + (r - 1) * 0.8), model, "Rav_" .. r .. c)
			-- Ravioli crimp dot
			AB.sphere(0.08, PASTA_YEL,
				AB.offset(originCF, -0.5 + (c - 1) * 0.5, 4.85, -0.8 + (r - 1) * 0.8), model, "RavDot_" .. r .. c)
		end
	end

	-- Fettuccine tray with sauce
	AB.block(Vector3.new(2, 0.3, 3), STEEL, AB.offset(originCF, 2.3, 4.5, 0), model, "Tray3")
	-- Pile of fettuccine (wide flat strips)
	for i = 1, 5 do
		AB.block(Vector3.new(0.3, 0.1, 2.6), PASTA_YEL,
			AB.offset(originCF, 2.3 + (math.random() - 0.5) * 1.3, 4.75 + math.random() * 0.15, 0), model, "Fett_" .. i)
	end
	-- Tomato sauce splash on top
	for i = 1, 4 do
		AB.sphere(0.25, SAUCE_R,
			AB.offset(originCF, 2.3 + math.cos(i) * 0.6, 4.95, math.sin(i) * 0.6), model, "Sauce_" .. i)
	end

	-- Flour sack at the side
	AB.block(Vector3.new(1.4, 1.8, 1.4), FLOUR, AB.offset(originCF, 4.2, 1.7, 1.4), model, "FlourSack")
	AB.sphere(0.4, FLOUR, AB.offset(originCF, 4.2, 2.6, 1.4), model, "FlourSackTop")
	-- Sack rope tie
	AB.cylinder(0.15, 1.2, Color3.fromRGB(190, 165, 110),
		AB.offset(originCF, 4.2, 2.4, 1.4) * CFrame.Angles(0, 0, math.rad(90)), model, "FlourTie")
	-- Sack label
	AB.block(Vector3.new(0.8, 0.5, 0.05), Color3.fromRGB(110, 30, 40),
		AB.offset(originCF, 4.2, 1.7, 2.1), model, "FlourLabel")

	-- Wheels
	for i, sx in {-1, 1} do
		AB.cylinder(2, 0.4, DK_WD,
			AB.offset(originCF, sx * 3, 1, 2.4) * CFrame.Angles(math.rad(90), 0, 0), model, "FWheel_" .. i)
		AB.cylinder(2, 0.4, DK_WD,
			AB.offset(originCF, sx * 3, 1, -2.4) * CFrame.Angles(math.rad(90), 0, 0), model, "BWheel_" .. i)
		AB.sphere(0.4, Color3.fromRGB(200, 160, 80),
			AB.offset(originCF, sx * 3, 1, 2.4), model, "FHub_" .. i)
		AB.sphere(0.4, Color3.fromRGB(200, 160, 80),
			AB.offset(originCF, sx * 3, 1, -2.4), model, "BHub_" .. i)
	end

	-- Push handle
	AB.cylinder(0.3, 5, WD,
		AB.offset(originCF, -5, 4, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)), model, "Handle")

	-- Hanging garlic braid above the counter (rope arch + bulbs)
	for i = 1, 5 do
		AB.sphere(0.4, GARLIC_W,
			AB.offset(originCF, -2 + (i - 1) * 1, 6.5 - math.sin(i / 5 * math.pi) * 0.5, -2),
			model, "Garlic_" .. i)
	end
	-- Support rope across counter rail
	AB.cylinder(0.1, 5, Color3.fromRGB(190, 165, 110),
		AB.offset(originCF, 0, 6.8, -2) * CFrame.Angles(0, 0, math.rad(90)), model, "GarlicRope")

	-- "PASTA FRESCA" sign
	local sign = AB.block(Vector3.new(5, 1, 0.3), Color3.fromRGB(245, 230, 200),
		AB.offset(originCF, 0, 7.5, -2), model, "PastaSign")
	AB.block(Vector3.new(5.2, 0.3, 0.4), DK_WD, AB.offset(originCF, 0, 8.1, -2), model, "SignTop")
	AB.block(Vector3.new(5.2, 0.3, 0.4), DK_WD, AB.offset(originCF, 0, 6.9, -2), model, "SignBot")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
