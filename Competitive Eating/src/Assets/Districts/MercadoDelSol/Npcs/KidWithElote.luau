-- Memito — small kid happily munching an elote on a stick.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN        = Color3.fromRGB(210, 165, 130)
local SHIRT_GREEN = Color3.fromRGB(93, 168, 85)
local JEANS_BLUE  = Color3.fromRGB(50, 80, 140)
local HAIR_BLACK  = Color3.fromRGB(40, 30, 25)
local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local CREAM       = Color3.fromRGB(245, 230, 200)
local TERRACOTTA  = Color3.fromRGB(196, 95, 44)
local WHITE       = Color3.fromRGB(245, 240, 235)
local BLACK       = Color3.fromRGB(30, 25, 25)
local CHEEK_PINK  = Color3.fromRGB(230, 150, 150)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("KidWithElote", parent)

	-- Torso (smaller — kid scale)
	local torso = AB.block(Vector3.new(2.0, 2.2, 1.0), SHIRT_GREEN,
		AB.offset(originCF, 0, 1.1, 0), model, "Torso")

	-- Head (smaller)
	AB.sphere(1.4, SKIN, AB.offset(originCF, 0, 2.9, 0), model, "Head")
	-- Eyes
	for i, x in {-0.28, 0.28} do
		AB.sphere(0.16, BLACK,
			AB.offset(originCF, x, 3.0, 0.68), model, "Eye_" .. i)
	end
	-- Cheek blushes
	for i, x in {-0.5, 0.5} do
		AB.sphere(0.18, CHEEK_PINK,
			AB.offset(originCF, x, 2.75, 0.65), model, "Cheek_" .. i)
	end
	-- Big smile with teeth
	AB.block(Vector3.new(0.7, 0.18, 0.12), WHITE,
		AB.offset(originCF, 0, 2.65, 0.7), model, "Teeth")
	AB.block(Vector3.new(0.7, 0.06, 0.12), BLACK,
		AB.offset(originCF, 0, 2.74, 0.71), model, "SmileLine")

	-- Hair cap (dark)
	AB.sphere(1.5, HAIR_BLACK,
		AB.offset(originCF, 0, 3.1, -0.15), model, "Hair")
	-- Cap on top
	AB.cylinder(1.6, 0.4, TERRACOTTA,
		AB.offset(originCF, 0, 3.8, 0) * CFrame.Angles(0, 0, math.rad(-90)),
		model, "Cap")
	-- Cap brim
	AB.block(Vector3.new(1.4, 0.15, 0.7), TERRACOTTA,
		AB.offset(originCF, 0, 3.65, 0.55), model, "CapBrim")

	-- Arms
	-- Left arm: down at side
	AB.block(Vector3.new(0.7, 1.8, 0.7), SHIRT_GREEN,
		AB.offset(originCF, -1.3, 1.1, 0),
		model, "Arm_L")
	AB.sphere(0.55, SKIN,
		AB.offset(originCF, -1.3, 0.1, 0), model, "Hand_L")
	-- Right arm: raised forward holding the elote
	AB.block(Vector3.new(0.7, 1.8, 0.7), SHIRT_GREEN,
		AB.offset(originCF, 1.3, 1.6, 0.5) * CFrame.Angles(math.rad(-50), 0, 0),
		model, "Arm_R")
	AB.sphere(0.55, SKIN,
		AB.offset(originCF, 1.3, 2.4, 1.5), model, "Hand_R")

	-- Elote stick (vertical from right hand)
	AB.cylinder(0.2, 2.0, WOOD_DARK,
		AB.offset(originCF, 1.3, 3.0, 1.5),
		model, "EloteStick")
	-- Corn cob (yellow cylinder)
	AB.cylinder(0.9, 1.8, FIESTA_YEL,
		AB.offset(originCF, 1.3, 4.2, 1.5),
		model, "Corn")
	-- Kernel detail (small darker yellow dots)
	for i = 1, 6 do
		local angle = (i / 6) * math.pi * 2
		AB.sphere(0.15, Color3.fromRGB(230, 160, 30),
			AB.offset(originCF, 1.3 + math.cos(angle) * 0.45, 4.0 + (i % 2) * 0.4, 1.5 + math.sin(angle) * 0.45),
			model, "Kernel_" .. i)
	end
	-- Mayo smear on top
	AB.block(Vector3.new(0.9, 0.2, 0.5), CREAM,
		AB.offset(originCF, 1.3, 5.2, 1.5), model, "Mayo")
	-- Chili powder sprinkle
	for i = 1, 4 do
		AB.sphere(0.12, TERRACOTTA,
			AB.offset(originCF, 1.3 + (i - 2) * 0.2, 5.0 + (i % 2) * 0.1, 1.5 + (i % 3 - 1) * 0.2),
			model, "Chili_" .. i)
	end

	-- Legs (shorter — kid scale)
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.7, 1.8, 0.8), JEANS_BLUE,
			AB.offset(originCF, side * 0.5, -0.9, 0),
			model, "Leg_" .. (side == -1 and "L" or "R"))
		AB.block(Vector3.new(0.85, 0.35, 1.3), WHITE,
			AB.offset(originCF, side * 0.5, -2.0, 0.2),
			model, "Sneaker_" .. (side == -1 and "L" or "R"))
	end

	-- Nametag
	local head = model:FindFirstChild("Head") :: BasePart
	if head then AB.billboard(head, "Memito", Vector2.new(200, 36), 2.0) end

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
