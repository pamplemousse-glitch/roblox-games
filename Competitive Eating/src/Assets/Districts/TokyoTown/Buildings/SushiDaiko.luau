-- Sushi Daiko — long sleek minimal sushi counter. Cedar wood counter,
-- backlit glass display case full of nigiri, black slate roof, vermilion
-- single-line accent stripe, paper-screen back wall, hanging spotlight row.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local BLACK       = Color3.fromRGB(35, 30, 35)
local DARK_GREY   = Color3.fromRGB(60, 60, 65)
local VERMILION   = Color3.fromRGB(200, 50, 40)
local CEDAR       = Color3.fromRGB(195, 145, 90)
local GLASS_BLUE  = Color3.fromRGB(190, 220, 230)
local SALMON      = Color3.fromRGB(255, 130, 90)
local TUNA_RED    = Color3.fromRGB(190, 60, 50)
local TAMAGO      = Color3.fromRGB(245, 200, 90)
local NORI        = Color3.fromRGB(40, 50, 40)
local RICE        = Color3.fromRGB(245, 235, 215)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SushiDaiko", parent)

	-- Stone slab foundation
	AB.block(Vector3.new(42, 0.5, 18), DARK_GREY,
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Back wall — paper-screen with horizontal cedar slats above
	AB.block(Vector3.new(42, 8, 1), PAPER_WHITE,
		AB.offset(originCF, 0, 4, -8.5), model, "BackPaper")
	AB.block(Vector3.new(42, 4, 1), CEDAR,
		AB.offset(originCF, 0, 10, -8.5), model, "BackSlatBand")
	for i = 1, 6 do
		AB.block(Vector3.new(42.1, 0.15, 1.05), BLACK,
			AB.offset(originCF, 0, 8.4 + i * 0.55, -8.5), model, "BackSlat_" .. i)
	end

	-- Side walls — black
	AB.block(Vector3.new(1, 12, 18), BLACK, AB.offset(originCF, -20.5, 6, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 12, 18), BLACK, AB.offset(originCF,  20.5, 6, 0), model, "RightWall")

	-- Single vermilion accent stripe
	local stripe = AB.block(Vector3.new(42, 0.35, 0.4), VERMILION,
		AB.offset(originCF, 0, 9, 8.6), model, "AccentStripe")
	AB.neon(stripe)

	-- Front counter (low half-wall)
	AB.block(Vector3.new(42, 3, 0.5), BLACK,
		AB.offset(originCF, 0, 1.5, 8.5), model, "CounterFront")

	-- Long cedar counter top
	local counter = AB.block(Vector3.new(38, 0.5, 5), CEDAR,
		AB.offset(originCF, 0, 3.5, 5), model, "CedarCounter")

	-- Cedar legs under the counter
	for i, x in {-17, -8, 0, 8, 17} do
		AB.block(Vector3.new(0.8, 3, 0.8), CEDAR,
			AB.offset(originCF, x, 1.6, 5), model, "CounterLeg_" .. i)
	end

	-- Backlit glass display case
	for i, offset in {
		Vector3.new(-18, 5, 5),
		Vector3.new( 18, 5, 5),
		Vector3.new(-18, 5, 7),
		Vector3.new( 18, 5, 7),
	} do
		AB.block(Vector3.new(0.2, 3, 0.2), BLACK,
			AB.offset(originCF, offset.X, offset.Y, offset.Z), model, "GlassPost_" .. i)
	end
	for i, z in {7.05, 4.95} do
		AB.part({
			size  = Vector3.new(36, 2.8, 0.1),
			color = GLASS_BLUE, transparency = 0.55,
			cf    = AB.offset(originCF, 0, 5, z),
			name  = "Glass_" .. i,
		}, model)
	end
	AB.block(Vector3.new(36.2, 0.2, 2.2), BLACK,
		AB.offset(originCF, 0, 6.4, 6), model, "GlassTop")
	local backlight = AB.block(Vector3.new(36, 0.2, 2), PAPER_WHITE,
		AB.offset(originCF, 0, 4.0, 6), model, "Backlight")
	AB.neon(backlight)
	AB.glow(backlight, PAPER_WHITE, 1.5)

	-- Row of nigiri pieces in the case
	local toppings = {SALMON, TUNA_RED, TAMAGO, SALMON, TUNA_RED, TAMAGO, SALMON, TUNA_RED, TAMAGO, SALMON, TUNA_RED, TAMAGO, SALMON}
	for i = 1, 13 do
		local x = (i - 7) * 2.6
		AB.block(Vector3.new(1.6, 0.7, 1.0), RICE,
			AB.offset(originCF, x, 4.4, 6), model, "Rice_" .. i)
		AB.block(Vector3.new(1.7, 0.3, 1.1), toppings[i],
			AB.offset(originCF, x, 4.85, 6), model, "Topping_" .. i)
		if i % 3 == 0 then
			AB.block(Vector3.new(0.4, 0.6, 1.15), NORI,
				AB.offset(originCF, x, 4.5, 6), model, "Nori_" .. i)
		end
	end

	-- Hanging spotlight row
	for i = 1, 5 do
		local x = (i - 3) * 7
		AB.cylinder(0.3, 2.5, BLACK,
			AB.offset(originCF, x, 11, 5), model, "PendantCord_" .. i)
		AB.cylinder(1.4, 1.0, BLACK,
			AB.offset(originCF, x, 9.5, 5), model, "Pendant_" .. i)
		local bulb = AB.sphere(0.8, PAPER_WHITE,
			AB.offset(originCF, x, 8.9, 5), model, "Bulb_" .. i)
		AB.neon(bulb)
		AB.glow(bulb, PAPER_WHITE, 1.8)
	end

	-- Flat black slate roof
	AB.block(Vector3.new(44, 0.8, 20), BLACK,
		AB.offset(originCF, 0, 12.6, 0), model, "Roof")
	AB.block(Vector3.new(44.1, 0.3, 0.3), CEDAR,
		AB.offset(originCF, 0, 12.2, 9.9), model, "RoofFrontTrim")

	-- Vertical kanji-style plaque mounted on left wall, glowing
	local plaque = AB.block(Vector3.new(0.4, 5, 2.4), VERMILION,
		AB.offset(originCF, -20.7, 9, 5), model, "Plaque")
	AB.neon(plaque)
	AB.glow(plaque, VERMILION, 2)
	AB.block(Vector3.new(0.45, 5.4, 2.8), BLACK,
		AB.offset(originCF, -20.7, 9, 5), model, "PlaqueBorder")

	-- Small chef-call bell on the counter
	AB.cylinder(0.7, 0.5, Color3.fromRGB(220, 180, 60),
		AB.offset(originCF, 17, 4.0, 5), model, "ChefBell")

	-- Decorative bamboo trio on the back counter shelf
	for i, x in {-15, -13, -11} do
		AB.cylinder(0.3, 2, Color3.fromRGB(140, 180, 100),
			AB.offset(originCF, x, 5.2, 4.3), model, "Bamboo_" .. i)
	end

	AB.pivot(model, counter)
	AB.weldAll(model)
	return model
end
