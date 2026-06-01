-- Akemi — Tokyo Town NPC. Deep purple yukata + gold highlights.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Akemi"
local SKIN    = Color3.fromRGB(255, 225, 200)
local YUKATA  = Color3.fromRGB(95, 60, 110)    -- deep purple
local OBI     = Color3.fromRGB(255, 180, 70)   -- lantern gold sash
local HAIR    = Color3.fromRGB(20, 15, 15)
local KANZASHI = Color3.fromRGB(200, 50, 40)   -- vermilion hair pin

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	local torso = AB.part({
		size      = Vector3.new(2.6, 3, 1.2),
		color     = YUKATA,
		cf        = originCF,
		canCollide = false,
		name      = "Torso",
	}, model)

	-- Gold obi
	AB.part({
		size      = Vector3.new(2.7, 0.9, 1.25),
		color     = OBI,
		cf        = AB.offset(originCF, 0, -0.4, 0),
		canCollide = false,
		name      = "Obi",
	}, model)
	-- Obi bow knot at the back
	AB.part({
		size      = Vector3.new(1.3, 1.0, 0.4),
		color     = OBI,
		cf        = AB.offset(originCF, 0, -0.2, 0.85),
		canCollide = false,
		name      = "ObiBow",
	}, model)

	local head = AB.part({
		size      = Vector3.new(1.8, 1.8, 1.8),
		color     = SKIN,
		cf        = AB.offset(originCF, 0, 2.2, 0),
		shape     = Enum.PartType.Ball,
		canCollide = false,
		name      = "Head",
	}, model)

	-- Hair: bun on top + sides
	AB.part({
		size      = Vector3.new(1.9, 0.8, 1.9),
		color     = HAIR,
		cf        = AB.offset(originCF, 0, 2.95, 0),
		canCollide = false,
		name      = "HairBase",
	}, model)
	AB.sphere(1.0, HAIR, AB.offset(originCF, 0, 3.55, -0.3), model, "Bun")

	-- Kanzashi (vermilion hair pin)
	AB.part({
		size      = Vector3.new(0.15, 0.6, 0.15),
		color     = KANZASHI,
		cf        = AB.offset(originCF, 0.6, 3.5, -0.1),
		canCollide = false,
		name      = "Kanzashi",
	}, model)
	AB.sphere(0.35, KANZASHI, AB.offset(originCF, 0.6, 3.85, -0.1), model, "KanzashiBead")

	for _, side in {-1, 1} do
		AB.part({
			size      = Vector3.new(0.9, 0.9, 2.4),
			color     = YUKATA,
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
