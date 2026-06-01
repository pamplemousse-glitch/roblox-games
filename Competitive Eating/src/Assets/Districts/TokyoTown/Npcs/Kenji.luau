-- Kenji — Tokyo Town NPC. Simple block rig (torso + head + 2 arms) with name
-- billboard. Follows the makeNpcRig pattern from ContestStaging.luau.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "Kenji"
local SKIN       = Color3.fromRGB(255, 220, 180)
local SHIRT      = Color3.fromRGB(60, 60, 90)     -- dark indigo
local PANTS      = Color3.fromRGB(35, 30, 35)
local HAIR       = Color3.fromRGB(35, 30, 30)
local HEADBAND   = Color3.fromRGB(200, 50, 40)    -- vermilion hachimaki

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (shirt)
	local torso = AB.part({
		size      = Vector3.new(2.6, 3, 1.2),
		color     = SHIRT,
		cf        = originCF,
		canCollide = false,
		name      = "Torso",
	}, model)

	-- Lower body suggested by a darker rectangle below (legs/pants)
	AB.part({
		size      = Vector3.new(2.6, 0.6, 1.2),
		color     = PANTS,
		cf        = AB.offset(originCF, 0, -1.6, 0),
		canCollide = false,
		name      = "Belt",
	}, model)

	-- Head (ball)
	local head = AB.part({
		size      = Vector3.new(1.8, 1.8, 1.8),
		color     = SKIN,
		cf        = AB.offset(originCF, 0, 2.2, 0),
		shape     = Enum.PartType.Ball,
		canCollide = false,
		name      = "Head",
	}, model)

	-- Hair cap (a flatter block on top of the head)
	AB.part({
		size      = Vector3.new(1.85, 0.7, 1.85),
		color     = HAIR,
		cf        = AB.offset(originCF, 0, 2.9, 0),
		canCollide = false,
		name      = "Hair",
	}, model)

	-- Hachimaki (vermilion headband)
	AB.part({
		size      = Vector3.new(2.0, 0.3, 2.0),
		color     = HEADBAND,
		cf        = AB.offset(originCF, 0, 2.45, 0),
		canCollide = false,
		name      = "Headband",
	}, model)

	-- Arms (forward, suggesting "rolling sushi" pose)
	for _, side in {-1, 1} do
		AB.part({
			size      = Vector3.new(0.9, 0.9, 2.4),
			color     = SHIRT,
			cf        = AB.offset(originCF, side * 1.6, 0.4, -1.2),
			canCollide = false,
			name      = "Arm_" .. (side == -1 and "L" or "R"),
		}, model)
	end

	-- Name billboard
	AB.billboard(head, NAME, Vector2.new(200, 36), 3)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
