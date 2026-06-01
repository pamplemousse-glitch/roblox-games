-- Food Crates — stack of 3 wooden food crates with labels (flour, olive oil,
-- tomatoes) and visible contents.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CRATE     = Color3.fromRGB(160, 120, 75)
local DK_WD     = Color3.fromRGB(80, 50, 30)
local LABEL_CR  = Color3.fromRGB(240, 220, 180)
local TXT_DK    = Color3.fromRGB(60, 40, 25)
local FLOUR_W   = Color3.fromRGB(240, 235, 220)
local OLIVE_G   = Color3.fromRGB(120, 140, 70)
local TOMATO    = Color3.fromRGB(220, 60, 50)
local OIL_BTL   = Color3.fromRGB(40, 70, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("FoodCrates", parent)

	-- Bottom crate (largest) — flour
	AB.block(Vector3.new(4, 3, 4), CRATE, AB.offset(originCF, 0, 1.5, 0), model, "CrateBot")
	-- Slat lines
	for i, y in {0.5, 1.5, 2.5} do
		AB.block(Vector3.new(4.1, 0.15, 4.1), DK_WD, AB.offset(originCF, 0, y, 0), model, "BotSlat_" .. i)
	end
	-- Label
	AB.block(Vector3.new(2.5, 1, 0.1), LABEL_CR, AB.offset(originCF, 0, 1.5, 2.05), model, "BotLabel")
	AB.block(Vector3.new(1.8, 0.3, 0.05), TXT_DK, AB.offset(originCF, 0, 1.5, 2.1), model, "BotLabelTxt")
	-- Flour sack peeking out top
	AB.sphere(0.9, FLOUR_W, AB.offset(originCF, -0.8, 3.4, 0), model, "FlourSack1")
	AB.sphere(0.9, FLOUR_W, AB.offset(originCF, 0.9, 3.4, -0.5), model, "FlourSack2")

	-- Middle crate (medium) — olive oil bottles
	AB.block(Vector3.new(3, 2.5, 3), CRATE, AB.offset(originCF, 0, 4.5, 0), model, "CrateMid")
	for i, y in {3.5, 4.5, 5.5} do
		AB.block(Vector3.new(3.1, 0.15, 3.1), DK_WD, AB.offset(originCF, 0, y, 0), model, "MidSlat_" .. i)
	end
	AB.block(Vector3.new(2, 0.8, 0.1), LABEL_CR, AB.offset(originCF, 0, 4.5, 1.55), model, "MidLabel")
	AB.block(Vector3.new(1.3, 0.25, 0.05), Color3.fromRGB(80, 140, 60), AB.offset(originCF, 0, 4.5, 1.6), model, "MidLabelTxt")
	-- Olive oil bottle tops visible
	for i, off in {Vector3.new(-0.7, 0, -0.6), Vector3.new(0.7, 0, -0.6), Vector3.new(0, 0, 0.7)} do
		AB.cylinder(0.5, 1.5, OIL_BTL, AB.offset(originCF, off.X, 6.4, off.Z), model, "Bottle_" .. i)
		AB.cylinder(0.25, 0.4, OIL_BTL, AB.offset(originCF, off.X, 7.2, off.Z), model, "BottleNeck_" .. i)
	end

	-- Top crate (smallest) — tomatoes
	AB.block(Vector3.new(2.2, 1.6, 2.2), CRATE, AB.offset(originCF, 1.8, 7.6, -0.5), model, "CrateTop")
	for i, y in {6.9, 7.6, 8.3} do
		AB.block(Vector3.new(2.25, 0.12, 2.25), DK_WD, AB.offset(originCF, 1.8, y, -0.5), model, "TopSlat_" .. i)
	end
	AB.block(Vector3.new(1.5, 0.6, 0.1), LABEL_CR, AB.offset(originCF, 1.8, 7.6, 0.65), model, "TopLabel")
	AB.block(Vector3.new(1, 0.2, 0.05), TOMATO, AB.offset(originCF, 1.8, 7.6, 0.7), model, "TopLabelTxt")
	-- Tomatoes peeking out
	for i = 1, 4 do
		AB.sphere(0.5, TOMATO,
			AB.offset(originCF, 1.8 + math.cos(i) * 0.6, 8.7, -0.5 + math.sin(i) * 0.6), model, "Tomato_" .. i)
		-- Tomato stems
		AB.sphere(0.15, OLIVE_G,
			AB.offset(originCF, 1.8 + math.cos(i) * 0.6, 9, -0.5 + math.sin(i) * 0.6), model, "TomStem_" .. i)
	end

	-- Pry-bar leaning against stack (iron)
	AB.cylinder(0.2, 3, Color3.fromRGB(50, 50, 55),
		AB.offset(originCF, -3, 1.5, 2.5) * CFrame.Angles(math.rad(-20), 0, math.rad(15)), model, "Crowbar")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
