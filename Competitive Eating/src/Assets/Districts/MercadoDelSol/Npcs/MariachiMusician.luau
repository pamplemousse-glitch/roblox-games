-- Mariachi Musician — black charro suit, big black sombrero, holds a guitarrón.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN        = Color3.fromRGB(210, 165, 130)
local BLACK       = Color3.fromRGB(30, 25, 25)
local CREAM       = Color3.fromRGB(245, 230, 200)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local BURGUNDY    = Color3.fromRGB(110, 30, 40)
local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local HAT_BAND    = Color3.fromRGB(140, 80, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MariachiMusician", parent)

	-- Torso (black charro jacket)
	local torso = AB.block(Vector3.new(2.6, 3, 1.2), BLACK,
		AB.offset(originCF, 0, 1.5, 0), model, "Torso")

	-- Cream shirt collar peeking at neck
	AB.block(Vector3.new(1.6, 0.4, 1.25), CREAM,
		AB.offset(originCF, 0, 2.85, 0), model, "Collar")

	-- Bolo tie diamond at collar
	AB.block(Vector3.new(0.3, 0.3, 0.2), BLACK,
		AB.offset(originCF, 0, 2.7, 0.65) * CFrame.Angles(0, 0, math.rad(45)),
		model, "BoloTie")

	-- Head
	AB.sphere(1.8, SKIN, AB.offset(originCF, 0, 3.9, 0), model, "Head")
	-- Eyes
	for i, x in {-0.35, 0.35} do
		AB.sphere(0.18, BLACK,
			AB.offset(originCF, x, 4.0, 0.85), model, "Eye_" .. i)
	end
	-- Black mustache
	AB.block(Vector3.new(1.2, 0.25, 0.2), BLACK,
		AB.offset(originCF, 0, 3.55, 0.85), model, "Mustache")

	-- Sombrero brim (black with yellow trim)
	AB.cylinder(4.5, 0.3, BLACK,
		AB.offset(originCF, 0, 4.75, 0), model, "HatBrim")
	-- Yellow trim ring on brim edge
	AB.cylinder(4.6, 0.12, FIESTA_YEL,
		AB.offset(originCF, 0, 4.6, 0), model, "HatBrimTrim")
	-- Crown
	AB.cylinder(2.4, 1.2, BLACK,
		AB.offset(originCF, 0, 5.5, 0) * CFrame.Angles(0, 0, math.rad(-90)),
		model, "HatCrown")
	-- Yellow hat band
	AB.cylinder(2.45, 0.25, FIESTA_YEL,
		AB.offset(originCF, 0, 5.0, 0) * CFrame.Angles(0, 0, math.rad(-90)),
		model, "HatBand")

	-- Gold embroidery accents down sleeves
	for _, side in {-1, 1} do
		for j = 1, 3 do
			AB.block(Vector3.new(0.25, 0.25, 0.25), FIESTA_YEL,
				AB.offset(originCF, side * 2.15, 2.4 - (j - 1) * 0.8, 0),
				model, "Embroidery_" .. (side == -1 and "L" or "R") .. "_" .. j)
		end
	end

	-- Arms — both forward to hold guitarrón
	-- Left arm: brought forward and slightly up to hold neck
	AB.block(Vector3.new(0.9, 2.4, 0.9), BLACK,
		AB.offset(originCF, -1.7, 1.8, 0.8) * CFrame.Angles(math.rad(-30), 0, 0),
		model, "Arm_L")
	AB.sphere(0.7, SKIN,
		AB.offset(originCF, -1.7, 0.9, 1.8), model, "Hand_L")
	-- Right arm: forward to strum body
	AB.block(Vector3.new(0.9, 2.4, 0.9), BLACK,
		AB.offset(originCF, 1.7, 1.5, 0.6) * CFrame.Angles(math.rad(-15), 0, 0),
		model, "Arm_R")
	AB.sphere(0.7, SKIN,
		AB.offset(originCF, 1.7, 0.4, 1.5), model, "Hand_R")

	-- Guitarrón body (large burgundy oval) in front of torso
	AB.block(Vector3.new(2, 1.5, 0.6), BURGUNDY,
		AB.offset(originCF, 0, 1.0, 1.5), model, "GuitarronBody")
	-- Guitarrón sound hole
	AB.cylinder(0.5, 0.1, BLACK,
		AB.offset(originCF, 0, 1.0, 1.85), model, "GuitarronHole")
	-- Guitarrón neck pointing up-left
	AB.block(Vector3.new(0.3, 2.5, 0.25), WOOD_DARK,
		AB.offset(originCF, -1.3, 2.2, 1.3) * CFrame.Angles(0, 0, math.rad(-30)),
		model, "GuitarronNeck")
	-- Headstock
	AB.block(Vector3.new(0.5, 0.6, 0.25), HAT_BAND,
		AB.offset(originCF, -2.4, 3.2, 1.3), model, "GuitarronHead")

	-- Pants (black)
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.9, 2.6, 1.0), BLACK,
			AB.offset(originCF, side * 0.6, -1.3, 0),
			model, "Leg_" .. (side == -1 and "L" or "R"))
		-- Black boots
		AB.block(Vector3.new(1.0, 0.4, 1.5), BLACK,
			AB.offset(originCF, side * 0.6, -2.8, 0.25),
			model, "Boot_" .. (side == -1 and "L" or "R"))
	end

	-- Nametag
	local head = model:FindFirstChild("Head") :: BasePart
	if head then AB.billboard(head, "Mariachi", Vector2.new(200, 36), 2.5) end

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
