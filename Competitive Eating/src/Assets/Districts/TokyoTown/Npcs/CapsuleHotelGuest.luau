-- Capsule Hotel Guest — casually dressed traveler with a small wheeled
-- suitcase. Yawning, looks tired. Hoodie + jeans + backpack.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "Guest"
local SKIN       = Color3.fromRGB(255, 220, 180)
local HOODIE     = Color3.fromRGB(70, 90, 110)
local HOODIE_DRK = Color3.fromRGB(50, 65, 85)
local JEANS      = Color3.fromRGB(60, 70, 110)
local HAIR_DARK  = Color3.fromRGB(40, 30, 30)
local IRON_BLACK = Color3.fromRGB(45, 40, 40)
local SUITCASE_R = Color3.fromRGB(180, 60, 60)
local METAL_GREY = Color3.fromRGB(110, 110, 120)
local STRAP      = Color3.fromRGB(80, 80, 90)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (hoodie)
	local torso = AB.part({
		size = Vector3.new(2.7, 3, 1.3), color = HOODIE,
		cf = originCF, canCollide = false, name = "Torso",
	}, model)
	-- Hoodie pocket pouch (darker)
	AB.part({
		size = Vector3.new(1.8, 0.8, 1.35), color = HOODIE_DRK,
		cf = AB.offset(originCF, 0, -0.5, 0), canCollide = false, name = "Pocket",
	}, model)
	-- Hood collar (lump around the neck)
	AB.part({
		size = Vector3.new(2.0, 0.5, 1.4), color = HOODIE,
		cf = AB.offset(originCF, 0, 1.6, -0.1), canCollide = false, name = "HoodCollar",
	}, model)
	-- Backpack (block on back)
	AB.part({
		size = Vector3.new(2, 2.4, 0.8), color = HOODIE_DRK,
		cf = AB.offset(originCF, 0, 0.2, -1), canCollide = false, name = "Backpack",
	}, model)
	-- Backpack straps
	for i, x in {-0.7, 0.7} do
		AB.block(Vector3.new(0.2, 2.4, 0.1), STRAP,
			AB.offset(originCF, x, 0.3, -0.5), model, "Strap_" .. i)
	end

	-- Jeans
	AB.part({
		size = Vector3.new(2.7, 0.8, 1.3), color = JEANS,
		cf = AB.offset(originCF, 0, -1.7, 0), canCollide = false, name = "Pants",
	}, model)

	-- Head
	local head = AB.part({
		size = Vector3.new(1.8, 1.8, 1.8), color = SKIN,
		cf = AB.offset(originCF, 0, 2.2, 0), shape = Enum.PartType.Ball,
		canCollide = false, name = "Head",
	}, model)
	-- Messy hair sticking out from hood
	AB.part({
		size = Vector3.new(1.95, 0.7, 1.95), color = HAIR_DARK,
		cf = AB.offset(originCF, 0, 2.9, 0), canCollide = false, name = "Hair",
	}, model)
	-- Closed/tired eyes (small black lines)
	for i, x in {-0.4, 0.4} do
		AB.block(Vector3.new(0.45, 0.08, 0.1), IRON_BLACK,
			AB.offset(originCF, x, 2.2, 0.85), model, "TiredEye_" .. i)
	end
	-- Open yawn mouth
	AB.sphere(0.3, IRON_BLACK,
		AB.offset(originCF, 0, 1.7, 0.9), model, "YawnMouth")

	-- One arm down with suitcase, one arm up covering yawn
	-- Right arm down
	AB.part({
		size = Vector3.new(0.85, 2.4, 0.85), color = HOODIE,
		cf = AB.offset(originCF, 1.5, -0.3, 0), canCollide = false, name = "ArmR",
	}, model)
	-- Left arm up to mouth
	AB.part({
		size = Vector3.new(0.85, 1.8, 0.85), color = HOODIE,
		cf = AB.offset(originCF, -1, 1.5, 0.5) * CFrame.Angles(math.rad(80), 0, math.rad(20)),
		canCollide = false, name = "ArmL",
	}, model)

	-- Wheeled suitcase next to right side
	AB.block(Vector3.new(1.6, 3.2, 0.8), SUITCASE_R,
		AB.offset(originCF, 2.8, -0.4, 0), model, "Suitcase")
	-- Telescoping handle
	AB.cylinder(0.15, 2, METAL_GREY,
		AB.offset(originCF, 2.8, 2.2, 0), model, "SuitcaseHandle")
	AB.block(Vector3.new(0.5, 0.15, 0.6), METAL_GREY,
		AB.offset(originCF, 2.8, 3.15, 0), model, "SuitcaseGrip")
	-- Wheels at bottom
	for i, dx in {-0.5, 0.5} do
		AB.cylinder(0.4, 0.3, IRON_BLACK,
			AB.offset(originCF, 2.8 + dx, -2, 0) * CFrame.Angles(0, math.rad(90), 0),
			model, "SuitcaseWheel_" .. i)
	end

	AB.billboard(head, NAME, Vector2.new(220, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
