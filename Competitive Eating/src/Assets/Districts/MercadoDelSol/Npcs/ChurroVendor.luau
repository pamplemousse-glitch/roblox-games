-- Don Churros — friendly churro vendor with a frying cart at his side.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN        = Color3.fromRGB(210, 165, 130)
local CREAM       = Color3.fromRGB(245, 230, 200)
local JEANS_BLUE  = Color3.fromRGB(50, 80, 140)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local BLACK       = Color3.fromRGB(30, 25, 25)
local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local AGAVE_TEAL  = Color3.fromRGB(43, 140, 156)
local ORANGE_GLOW = Color3.fromRGB(255, 140, 50)
local BROWN_SUGAR = Color3.fromRGB(140, 90, 50)
local WHITE       = Color3.fromRGB(245, 240, 235)
local SHOE_BROWN  = Color3.fromRGB(85, 55, 35)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ChurroVendor", parent)

	-- Torso (cream shirt)
	local torso = AB.block(Vector3.new(2.6, 3, 1.2), CREAM,
		AB.offset(originCF, 0, 1.5, 0), model, "Torso")
	-- Apron
	AB.block(Vector3.new(2.0, 2.6, 0.1), CREAM,
		AB.offset(originCF, 0, 1.4, 0.65), model, "Apron")
	-- Apron strap
	AB.block(Vector3.new(0.2, 0.5, 0.1), CREAM,
		AB.offset(originCF, -0.7, 2.6, 0.66), model, "ApronStrap_L")
	AB.block(Vector3.new(0.2, 0.5, 0.1), CREAM,
		AB.offset(originCF, 0.7, 2.6, 0.66), model, "ApronStrap_R")

	-- Head
	AB.sphere(1.8, SKIN, AB.offset(originCF, 0, 3.9, 0), model, "Head")
	-- Eyes
	for i, x in {-0.35, 0.35} do
		AB.sphere(0.18, BLACK,
			AB.offset(originCF, x, 4.0, 0.85), model, "Eye_" .. i)
	end
	-- Mustache
	AB.block(Vector3.new(1.0, 0.22, 0.2), BLACK,
		AB.offset(originCF, 0, 3.55, 0.85), model, "Mustache")
	-- Smile
	AB.block(Vector3.new(0.6, 0.1, 0.12), Color3.fromRGB(160, 80, 70),
		AB.offset(originCF, 0, 3.35, 0.85), model, "Mouth")

	-- Yellow paper hat (flat-topped cylinder + brim)
	AB.cylinder(1.9, 0.7, FIESTA_YEL,
		AB.offset(originCF, 0, 5.0, 0) * CFrame.Angles(0, 0, math.rad(-90)),
		model, "PaperHatCrown")
	-- Hat brim (thin disc)
	AB.cylinder(2.4, 0.12, FIESTA_YEL,
		AB.offset(originCF, 0, 4.65, 0), model, "PaperHatBrim")

	-- Arms
	-- Left arm: down at side
	AB.block(Vector3.new(0.9, 2.4, 0.9), CREAM,
		AB.offset(originCF, -1.7, 1.5, 0), model, "Arm_L")
	AB.sphere(0.7, SKIN,
		AB.offset(originCF, -1.7, 0.2, 0), model, "Hand_L")
	-- Right arm: forward holding a paper bag of churros
	AB.block(Vector3.new(0.9, 2.4, 0.9), CREAM,
		AB.offset(originCF, 1.7, 1.7, 0.6) * CFrame.Angles(math.rad(-30), 0, 0),
		model, "Arm_R")
	AB.sphere(0.7, SKIN,
		AB.offset(originCF, 1.7, 0.8, 1.6), model, "Hand_R")

	-- Paper bag of churros
	AB.block(Vector3.new(0.9, 1.0, 0.7), CREAM,
		AB.offset(originCF, 1.7, 1.3, 1.7), model, "PaperBag")
	-- Churro sticks poking out
	for i = 1, 4 do
		local xOff = (i - 2.5) * 0.18
		AB.cylinder(0.18, 1.2, FIESTA_YEL,
			AB.offset(originCF, 1.7 + xOff, 2.3, 1.7) * CFrame.Angles(0, 0, math.rad(-90)),
			model, "Churro_" .. i)
		-- Brown sugar coating dot
		AB.sphere(0.1, BROWN_SUGAR,
			AB.offset(originCF, 1.7 + xOff, 2.5, 1.7), model, "ChurroSugar_" .. i)
	end

	-- Pants
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.9, 2.6, 1.0), JEANS_BLUE,
			AB.offset(originCF, side * 0.6, -1.3, 0),
			model, "Leg_" .. (side == -1 and "L" or "R"))
		AB.block(Vector3.new(1.0, 0.4, 1.5), SHOE_BROWN,
			AB.offset(originCF, side * 0.6, -2.8, 0.25),
			model, "Shoe_" .. (side == -1 and "L" or "R"))
	end

	-- ============================================================
	-- CHURRO CART beside vendor at x = 3.5
	-- ============================================================
	-- Cart wooden body
	AB.block(Vector3.new(3, 2.4, 2.2), WOOD_DARK,
		AB.offset(originCF, 3.5, 0.7, 0), model, "CartBody")
	-- Cart counter top
	AB.block(Vector3.new(3.1, 0.15, 2.3), Color3.fromRGB(150, 110, 70),
		AB.offset(originCF, 3.5, 2.0, 0), model, "CartTop")
	-- Churro fryer cylinder (steel-gray teal)
	AB.cylinder(1.6, 0.8, AGAVE_TEAL,
		AB.offset(originCF, 3.5, 2.5, 0) * CFrame.Angles(0, 0, math.rad(-90)),
		model, "FryerPot")
	-- Hot oil glow inside (neon orange)
	local oil = AB.cylinder(1.3, 0.3, ORANGE_GLOW,
		AB.offset(originCF, 3.5, 2.75, 0) * CFrame.Angles(0, 0, math.rad(-90)),
		model, "FryerOil")
	AB.neon(oil)
	AB.glow(oil, ORANGE_GLOW, 2)

	-- Cart wheels
	for _, side in {-1, 1} do
		AB.cylinder(1.0, 0.3, BLACK,
			AB.offset(originCF, 3.5, -0.4, side * 0.95) * CFrame.Angles(math.rad(90), 0, 0),
			model, "CartWheel_" .. (side == -1 and "L" or "R"))
	end

	-- Canopy poles
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.15, 2.4, 0.15), WOOD_DARK,
			AB.offset(originCF, 3.5 + side * 1.3, 3.3, 0),
			model, "CanopyPole_" .. (side == -1 and "L" or "R"))
	end
	-- Striped yellow awning
	for i = 1, 5 do
		local stripeColor = (i % 2 == 0) and FIESTA_YEL or WHITE
		AB.block(Vector3.new(3.4, 0.15, 0.45), stripeColor,
			AB.offset(originCF, 3.5, 4.4, -0.9 + (i - 1) * 0.45),
			model, "AwningStripe_" .. i)
	end

	-- "CHURROS" sign — 4 neon yellow letter blocks on cart front
	for i = 1, 4 do
		local letter = AB.block(Vector3.new(0.4, 0.5, 0.1), FIESTA_YEL,
			AB.offset(originCF, 3.5 + (i - 2.5) * 0.55, 1.0, 1.15),
			model, "SignLetter_" .. i)
		AB.neon(letter)
	end

	-- Nametag
	local head = model:FindFirstChild("Head") :: BasePart
	if head then AB.billboard(head, "Don Churros", Vector2.new(220, 36), 2.5) end

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
