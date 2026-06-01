-- Abuela Rosa — elderly tortilla seller with a small wooden cart beside her.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN_LIGHT  = Color3.fromRGB(220, 180, 150)
local HAIR_GRAY   = Color3.fromRGB(180, 175, 170)
local TERRACOTTA  = Color3.fromRGB(196, 95, 44)
local CREAM       = Color3.fromRGB(245, 230, 200)
local BOUG_PINK   = Color3.fromRGB(220, 80, 140)
local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local BLACK       = Color3.fromRGB(30, 25, 25)
local WHITE       = Color3.fromRGB(245, 240, 235)
local WRINKLE     = Color3.fromRGB(180, 140, 115)
local SHOE_BROWN  = Color3.fromRGB(85, 55, 35)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("AbuelaTortillaCart", parent)

	-- Torso (terracotta dress)
	local torso = AB.block(Vector3.new(2.6, 3, 1.2), TERRACOTTA,
		AB.offset(originCF, 0, 1.5, 0), model, "Torso")
	-- Cream apron on front
	AB.block(Vector3.new(2.0, 2.6, 0.1), CREAM,
		AB.offset(originCF, 0, 1.4, 0.65), model, "Apron")

	-- Pink rebozo shawl draped on shoulders
	AB.block(Vector3.new(2.9, 0.6, 1.3), BOUG_PINK,
		AB.offset(originCF, 0, 2.7, 0), model, "Rebozo")
	AB.block(Vector3.new(0.5, 1.4, 0.3), BOUG_PINK,
		AB.offset(originCF, -1.2, 2.0, 0.55), model, "RebozoDrape_L")
	AB.block(Vector3.new(0.5, 1.4, 0.3), BOUG_PINK,
		AB.offset(originCF, 1.2, 2.0, 0.55), model, "RebozoDrape_R")

	-- Head
	AB.sphere(1.8, SKIN_LIGHT, AB.offset(originCF, 0, 3.9, 0), model, "Head")

	-- Wrinkle accent lines
	AB.block(Vector3.new(0.5, 0.06, 0.1), WRINKLE,
		AB.offset(originCF, -0.4, 4.25, 0.85), model, "Wrinkle_L")
	AB.block(Vector3.new(0.5, 0.06, 0.1), WRINKLE,
		AB.offset(originCF, 0.4, 4.25, 0.85), model, "Wrinkle_R")

	-- Glasses: two white squares + connecting bridge
	AB.block(Vector3.new(0.35, 0.35, 0.05), WHITE,
		AB.offset(originCF, -0.35, 4.0, 0.9), model, "GlassLens_L")
	AB.block(Vector3.new(0.35, 0.35, 0.05), WHITE,
		AB.offset(originCF, 0.35, 4.0, 0.9), model, "GlassLens_R")
	AB.block(Vector3.new(0.25, 0.06, 0.05), BLACK,
		AB.offset(originCF, 0, 4.0, 0.9), model, "GlassBridge")
	-- Eyes inside glasses
	for i, x in {-0.35, 0.35} do
		AB.sphere(0.12, BLACK,
			AB.offset(originCF, x, 4.0, 0.92), model, "Eye_" .. i)
	end
	-- Small smile
	AB.block(Vector3.new(0.4, 0.1, 0.12), Color3.fromRGB(160, 80, 70),
		AB.offset(originCF, 0, 3.55, 0.88), model, "Mouth")

	-- Gray bun on top of head
	AB.sphere(1.0, HAIR_GRAY,
		AB.offset(originCF, 0, 4.85, -0.1), model, "Bun")
	-- Hair cap behind
	AB.sphere(1.95, HAIR_GRAY,
		AB.offset(originCF, 0, 4.05, -0.2), model, "Hair")

	-- Arms in front to hold tortillas
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.9, 2.4, 0.9), TERRACOTTA,
			AB.offset(originCF, side * 1.5, 1.5, 0.4) * CFrame.Angles(math.rad(-20), 0, 0),
			model, "Arm_" .. (side == -1 and "L" or "R"))
		AB.sphere(0.7, SKIN_LIGHT,
			AB.offset(originCF, side * 1.4, 0.7, 1.4),
			model, "Hand_" .. (side == -1 and "L" or "R"))
	end

	-- Tortilla stack in hands
	for i = 1, 4 do
		AB.cylinder(1.5, 0.1, CREAM,
			AB.offset(originCF, 0, 0.9 + (i - 1) * 0.12, 1.4),
			model, "Tortilla_" .. i)
	end

	-- Legs (under skirt)
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.9, 2.6, 1.0), TERRACOTTA,
			AB.offset(originCF, side * 0.6, -1.3, 0),
			model, "Leg_" .. (side == -1 and "L" or "R"))
		AB.block(Vector3.new(1.0, 0.4, 1.5), SHOE_BROWN,
			AB.offset(originCF, side * 0.6, -2.8, 0.25),
			model, "Shoe_" .. (side == -1 and "L" or "R"))
	end

	-- TORTILLA CART beside her at x=2
	-- Cart body
	AB.block(Vector3.new(3, 2, 2), WOOD_DARK,
		AB.offset(originCF, 3.5, 0.5, 0), model, "CartBody")
	-- Cart top counter
	AB.block(Vector3.new(3.1, 0.15, 2.1), Color3.fromRGB(140, 100, 65),
		AB.offset(originCF, 3.5, 1.6, 0), model, "CartTop")
	-- Tortilla stack on top of cart
	for i = 1, 6 do
		AB.cylinder(1.4, 0.12, CREAM,
			AB.offset(originCF, 3.5, 1.75 + (i - 1) * 0.13, 0),
			model, "CartTortilla_" .. i)
	end
	-- Cart wheels
	for _, side in {-1, 1} do
		AB.cylinder(1.0, 0.3, BLACK,
			AB.offset(originCF, 3.5, -0.4, side * 0.9) * CFrame.Angles(math.rad(90), 0, 0),
			model, "CartWheel_" .. (side == -1 and "L" or "R"))
	end
	-- Canopy poles
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.15, 2.2, 0.15), WOOD_DARK,
			AB.offset(originCF, 3.5 + side * 1.2, 2.7, 0),
			model, "CanopyPole_" .. (side == -1 and "L" or "R"))
	end
	-- Canopy (thin terracotta block)
	AB.block(Vector3.new(3.4, 0.15, 2.3), TERRACOTTA,
		AB.offset(originCF, 3.5, 3.8, 0), model, "Canopy")

	-- Nametag
	local head = model:FindFirstChild("Head") :: BasePart
	if head then AB.billboard(head, "Abuela Rosa", Vector2.new(200, 36), 2.5) end

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
