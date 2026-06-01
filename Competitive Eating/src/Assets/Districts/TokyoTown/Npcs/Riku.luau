-- Riku — Tokyo Town NPC. Blue jacket / chef white apron.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "Riku"
local SKIN       = Color3.fromRGB(245, 210, 175)
local JACKET     = Color3.fromRGB(60, 90, 140)    -- indigo blue
local APRON      = Color3.fromRGB(245, 240, 230)  -- paper white
local PANTS      = Color3.fromRGB(50, 50, 60)
local HAIR       = Color3.fromRGB(30, 25, 25)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	local torso = AB.part({
		size      = Vector3.new(2.6, 3, 1.2),
		color     = JACKET,
		cf        = originCF,
		canCollide = false,
		name      = "Torso",
	}, model)

	-- Apron front (paper white panel)
	AB.part({
		size      = Vector3.new(1.6, 2.4, 0.05),
		color     = APRON,
		cf        = AB.offset(originCF, 0, 0, -0.65),
		canCollide = false,
		name      = "Apron",
	}, model)

	-- Belt at the waist
	AB.part({
		size      = Vector3.new(2.7, 0.4, 1.25),
		color     = PANTS,
		cf        = AB.offset(originCF, 0, -1.3, 0),
		canCollide = false,
		name      = "Belt",
	}, model)

	local head = AB.part({
		size      = Vector3.new(1.8, 1.8, 1.8),
		color     = SKIN,
		cf        = AB.offset(originCF, 0, 2.2, 0),
		shape     = Enum.PartType.Ball,
		canCollide = false,
		name      = "Head",
	}, model)

	-- Spiky short hair (a slightly taller cap)
	AB.part({
		size      = Vector3.new(1.9, 0.9, 1.9),
		color     = HAIR,
		cf        = AB.offset(originCF, 0, 3.0, 0),
		canCollide = false,
		name      = "Hair",
	}, model)

	-- Chef bandana (white strip)
	AB.part({
		size      = Vector3.new(2.0, 0.25, 2.0),
		color     = APRON,
		cf        = AB.offset(originCF, 0, 2.5, 0),
		canCollide = false,
		name      = "Bandana",
	}, model)

	for _, side in {-1, 1} do
		AB.part({
			size      = Vector3.new(0.9, 0.9, 2.4),
			color     = JACKET,
			cf        = AB.offset(originCF, side * 1.6, 0.4, -1.2),
			canCollide = false,
			name      = "Arm_" .. (side == -1 and "L" or "R"),
		}, model)
	end

	AB.billboard(head, NAME, Vector2.new(200, 36), 3)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
