-- Sushi Chef — itamae in white chef coat, hachimaki headband, holding a
-- decorative sushi block on a wooden tray.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "Itamae"
local SKIN       = Color3.fromRGB(255, 220, 180)
local CHEF_WHITE = Color3.fromRGB(245, 240, 230)
local APRON      = Color3.fromRGB(220, 215, 200)
local VERMILION  = Color3.fromRGB(200, 50, 40)
local HAIR       = Color3.fromRGB(30, 25, 25)
local DARK_WOOD  = Color3.fromRGB(80, 50, 30)
local RICE       = Color3.fromRGB(245, 235, 215)
local SALMON     = Color3.fromRGB(255, 130, 90)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Chef coat torso
	local torso = AB.part({
		size = Vector3.new(2.7, 3, 1.3), color = CHEF_WHITE,
		cf = originCF, canCollide = false, name = "Torso",
	}, model)
	-- Belt/apron tie around waist
	AB.part({
		size = Vector3.new(2.75, 0.4, 1.35), color = VERMILION,
		cf = AB.offset(originCF, 0, -1.0, 0), canCollide = false, name = "Belt",
	}, model)
	-- Apron front
	AB.part({
		size = Vector3.new(1.8, 2, 0.05), color = APRON,
		cf = AB.offset(originCF, 0, -0.2, 0.7), canCollide = false, name = "Apron",
	}, model)
	-- Coat lapels (V-shape via two angled blocks)
	for i, side in {-1, 1} do
		AB.block(Vector3.new(0.3, 1.2, 0.07), Color3.fromRGB(220, 215, 200),
			AB.offset(originCF, side * 0.4, 0.5, 0.66) * CFrame.Angles(0, 0, math.rad(side * 15)),
			model, "Lapel_" .. i)
	end

	-- Pants (white)
	AB.part({
		size = Vector3.new(2.7, 0.8, 1.3), color = CHEF_WHITE,
		cf = AB.offset(originCF, 0, -1.7, 0), canCollide = false, name = "Pants",
	}, model)

	-- Head
	local head = AB.part({
		size = Vector3.new(1.8, 1.8, 1.8), color = SKIN,
		cf = AB.offset(originCF, 0, 2.2, 0), shape = Enum.PartType.Ball,
		canCollide = false, name = "Head",
	}, model)
	-- Hair
	AB.part({
		size = Vector3.new(1.85, 0.6, 1.85), color = HAIR,
		cf = AB.offset(originCF, 0, 2.85, 0), canCollide = false, name = "Hair",
	}, model)
	-- Hachimaki headband (vermilion with a knot tail)
	AB.part({
		size = Vector3.new(2.0, 0.4, 2.0), color = VERMILION,
		cf = AB.offset(originCF, 0, 2.5, 0), canCollide = false, name = "Hachimaki",
	}, model)
	AB.block(Vector3.new(0.5, 0.4, 0.5), VERMILION,
		AB.offset(originCF, 0, 2.4, -1.05), model, "HachimakiKnot")

	-- Arms held forward (presenting tray)
	for _, side in {-1, 1} do
		AB.part({
			size = Vector3.new(0.9, 0.9, 2.5), color = CHEF_WHITE,
			cf = AB.offset(originCF, side * 1.6, 0.4, -1.2), canCollide = false,
			name = "Arm_" .. (side == -1 and "L" or "R"),
		}, model)
	end

	-- Wood tray held in front
	AB.block(Vector3.new(3, 0.2, 1.4), DARK_WOOD,
		AB.offset(originCF, 0, 0.2, -2.5), model, "Tray")
	-- Sushi pieces on tray (3 small nigiri)
	for i = 1, 3 do
		local x = (i - 2) * 0.9
		AB.block(Vector3.new(0.7, 0.4, 0.6), RICE,
			AB.offset(originCF, x, 0.5, -2.5), model, "Rice_" .. i)
		AB.block(Vector3.new(0.75, 0.18, 0.7), SALMON,
			AB.offset(originCF, x, 0.75, -2.5), model, "Salmon_" .. i)
	end

	AB.billboard(head, NAME, Vector2.new(220, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
