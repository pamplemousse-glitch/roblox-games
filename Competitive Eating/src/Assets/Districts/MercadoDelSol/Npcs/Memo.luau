-- Memo — young grill cook: teal apron over white shirt, baseball cap.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN        = Color3.fromRGB(215, 170, 130)
local SHIRT_WHITE = Color3.fromRGB(245, 240, 230)
local APRON_TEAL  = Color3.fromRGB(43, 140, 156)
local APRON_TRIM  = Color3.fromRGB(255, 184, 52)
local CAP_GREEN   = Color3.fromRGB(93, 168, 85)
local PANTS_DARK  = Color3.fromRGB(60, 50, 40)
local HAIR_BLACK  = Color3.fromRGB(35, 25, 20)
local SNEAKER_GREY= Color3.fromRGB(80, 80, 90)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Memo", parent)

	-- Torso (white shirt)
	local torso = AB.block(Vector3.new(2.5, 3, 1.2), SHIRT_WHITE,
		AB.offset(originCF, 0, 1.5, 0), model, "Torso")

	-- Apron (teal, front)
	AB.block(Vector3.new(2.0, 2.4, 0.1), APRON_TEAL,
		AB.offset(originCF, 0, 1.4, 0.65), model, "Apron")
	-- Apron pocket (yellow trim)
	AB.block(Vector3.new(1.3, 0.5, 0.05), APRON_TRIM,
		AB.offset(originCF, 0, 0.8, 0.71), model, "Pocket")
	-- Apron neck strap
	AB.block(Vector3.new(0.15, 0.7, 0.15), APRON_TEAL,
		AB.offset(originCF, -0.7, 2.7, 0.65), model, "StrapL")
	AB.block(Vector3.new(0.15, 0.7, 0.15), APRON_TEAL,
		AB.offset(originCF, 0.7, 2.7, 0.65), model, "StrapR")

	-- Head
	AB.sphere(1.8, SKIN, AB.offset(originCF, 0, 3.9, 0), model, "Head")
	-- Eyes
	for i, x in {-0.35, 0.35} do
		AB.sphere(0.18, Color3.fromRGB(30, 25, 25),
			AB.offset(originCF, x, 4.0, 0.85), model, "Eye_" .. i)
	end
	-- Goatee
	AB.block(Vector3.new(0.4, 0.4, 0.15), HAIR_BLACK,
		AB.offset(originCF, 0, 3.4, 0.85), model, "Goatee")
	-- Mouth
	AB.block(Vector3.new(0.6, 0.1, 0.1), Color3.fromRGB(150, 80, 60),
		AB.offset(originCF, 0, 3.6, 0.85), model, "Mouth")

	-- Hair (sides peeking under cap)
	AB.sphere(1.9, HAIR_BLACK,
		AB.offset(originCF, 0, 3.95, -0.05), model, "Hair")

	-- Baseball cap brim
	AB.block(Vector3.new(2.0, 0.2, 1.2), CAP_GREEN,
		AB.offset(originCF, 0, 4.8, 0.8), model, "CapBrim")
	-- Cap crown (dome via sphere flattened by stacking)
	AB.sphere(2.0, CAP_GREEN,
		AB.offset(originCF, 0, 4.7, 0), model, "CapCrown")
	-- Cap front emblem
	AB.block(Vector3.new(0.6, 0.4, 0.1), APRON_TRIM,
		AB.offset(originCF, 0, 4.7, 0.95), model, "CapEmblem")

	-- Arms (one slightly raised holding a spatula approximation)
	-- Left arm down
	AB.block(Vector3.new(0.85, 2.4, 0.85), SHIRT_WHITE,
		AB.offset(originCF, -1.65, 1.5, 0), model, "ArmL")
	AB.sphere(0.65, SKIN,
		AB.offset(originCF, -1.65, 0.2, 0), model, "HandL")

	-- Right arm bent forward
	AB.block(Vector3.new(0.85, 2.2, 0.85), SHIRT_WHITE,
		AB.offset(originCF, 1.65, 1.9, 0.6)
		* CFrame.Angles(math.rad(-45), 0, 0),
		model, "ArmR")
	AB.sphere(0.65, SKIN,
		AB.offset(originCF, 1.65, 0.9, 1.5), model, "HandR")
	-- Spatula in right hand
	AB.block(Vector3.new(0.2, 0.2, 1.5), Color3.fromRGB(100, 70, 50),
		AB.offset(originCF, 1.65, 1.0, 2.4), model, "SpatulaHandle")
	AB.block(Vector3.new(1.0, 0.1, 0.8), Color3.fromRGB(150, 150, 160),
		AB.offset(originCF, 1.65, 1.0, 3.3), model, "SpatulaHead")

	-- Pants
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.9, 2.6, 1.0), PANTS_DARK,
			AB.offset(originCF, side * 0.6, -1.3, 0),
			model, "Leg_" .. (side == -1 and "L" or "R"))
		AB.block(Vector3.new(1.0, 0.4, 1.5), SNEAKER_GREY,
			AB.offset(originCF, side * 0.6, -2.8, 0.25),
			model, "Sneaker_" .. (side == -1 and "L" or "R"))
	end

	-- Nametag
	local head = model:FindFirstChild("Head") :: BasePart
	if head then AB.billboard(head, "Memo", Vector2.new(200, 36), 2.5) end

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
