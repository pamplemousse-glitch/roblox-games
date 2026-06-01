-- Lucia — young salsa-cart vendor: fiesta-yellow dress, floral apron, braid.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN        = Color3.fromRGB(225, 185, 145)
local DRESS_YEL   = Color3.fromRGB(255, 184, 52)
local APRON_WHITE = Color3.fromRGB(250, 245, 230)
local FLOWER_PINK = Color3.fromRGB(230, 130, 165)
local FLOWER_TEAL = Color3.fromRGB(43, 140, 156)
local HAIR_BLACK  = Color3.fromRGB(40, 25, 20)
local LIP_PINK    = Color3.fromRGB(210, 110, 130)
local SHOE_BROWN  = Color3.fromRGB(100, 70, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Lucia", parent)

	-- Torso (dress upper)
	local torso = AB.block(Vector3.new(2.4, 3, 1.2), DRESS_YEL,
		AB.offset(originCF, 0, 1.5, 0), model, "Torso")

	-- Apron front (white)
	AB.block(Vector3.new(1.8, 2.6, 0.1), APRON_WHITE,
		AB.offset(originCF, 0, 1.4, 0.65), model, "Apron")
	-- Floral pattern dots on apron
	for i, pos in {
		Vector3.new(-0.6, 1.8, 0),
		Vector3.new( 0.5, 2.1, 0),
		Vector3.new(-0.3, 0.7, 0),
		Vector3.new( 0.6, 0.4, 0),
	} do
		AB.sphere(0.3,
			(i % 2 == 0) and FLOWER_PINK or FLOWER_TEAL,
			AB.offset(originCF, pos.X, pos.Y, 0.71),
			model, "Flower_" .. i)
	end

	-- Dress skirt flare (slightly wider lower torso)
	AB.block(Vector3.new(2.9, 1.5, 1.5), DRESS_YEL,
		AB.offset(originCF, 0, -0.3, 0), model, "Skirt")

	-- Head
	AB.sphere(1.8, SKIN, AB.offset(originCF, 0, 3.9, 0), model, "Head")
	-- Eyes
	for i, x in {-0.35, 0.35} do
		AB.sphere(0.16, Color3.fromRGB(60, 40, 25),
			AB.offset(originCF, x, 4.0, 0.85), model, "Eye_" .. i)
	end
	-- Lipstick smile
	AB.block(Vector3.new(0.5, 0.15, 0.15), LIP_PINK,
		AB.offset(originCF, 0, 3.55, 0.85), model, "Mouth")

	-- Hair cap (dome over head, black)
	AB.sphere(1.95, HAIR_BLACK,
		AB.offset(originCF, 0, 4.1, -0.15), model, "Hair")
	-- Braid down the back
	for i = 1, 4 do
		AB.sphere(0.5, HAIR_BLACK,
			AB.offset(originCF, 0, 3.6 - (i - 1) * 0.55, -0.9),
			model, "Braid_" .. i)
	end
	-- Flower in hair
	AB.sphere(0.45, FLOWER_PINK,
		AB.offset(originCF, -0.9, 4.4, 0.4), model, "HairFlower")

	-- Arms
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.8, 2.4, 0.8), DRESS_YEL,
			AB.offset(originCF, side * 1.55, 1.5, 0),
			model, "Arm_" .. (side == -1 and "L" or "R"))
		AB.sphere(0.65, SKIN,
			AB.offset(originCF, side * 1.55, 0.2, 0),
			model, "Hand_" .. (side == -1 and "L" or "R"))
	end

	-- Legs (peek of skin below skirt)
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.7, 1.4, 0.8), SKIN,
			AB.offset(originCF, side * 0.55, -1.7, 0),
			model, "Leg_" .. (side == -1 and "L" or "R"))
		AB.block(Vector3.new(0.85, 0.3, 1.2), SHOE_BROWN,
			AB.offset(originCF, side * 0.55, -2.5, 0.15),
			model, "Shoe_" .. (side == -1 and "L" or "R"))
	end

	-- Nametag
	local head = model:FindFirstChild("Head") :: BasePart
	if head then AB.billboard(head, "Lucia", Vector2.new(200, 36), 2.5) end

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
