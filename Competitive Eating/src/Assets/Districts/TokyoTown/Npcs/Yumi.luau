-- Yumi — Tokyo Town NPC. Pastel pink + cream kimono palette.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Yumi"
local SKIN    = Color3.fromRGB(255, 220, 195)
local KIMONO  = Color3.fromRGB(245, 195, 210)   -- pastel pink
local OBI     = Color3.fromRGB(200, 50, 40)     -- vermilion sash
local HAIR    = Color3.fromRGB(40, 30, 30)
local FLOWER  = Color3.fromRGB(255, 180, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	local torso = AB.part({
		size      = Vector3.new(2.6, 3, 1.2),
		color     = KIMONO,
		cf        = originCF,
		canCollide = false,
		name      = "Torso",
	}, model)

	-- Obi (sash across the middle)
	AB.part({
		size      = Vector3.new(2.7, 0.8, 1.25),
		color     = OBI,
		cf        = AB.offset(originCF, 0, -0.2, 0),
		canCollide = false,
		name      = "Obi",
	}, model)

	local head = AB.part({
		size      = Vector3.new(1.8, 1.8, 1.8),
		color     = SKIN,
		cf        = AB.offset(originCF, 0, 2.2, 0),
		shape     = Enum.PartType.Ball,
		canCollide = false,
		name      = "Head",
	}, model)

	-- Long hair (back panel down to shoulders)
	AB.part({
		size      = Vector3.new(2.0, 2.4, 0.5),
		color     = HAIR,
		cf        = AB.offset(originCF, 0, 1.6, 0.6),
		canCollide = false,
		name      = "HairBack",
	}, model)
	-- Hair top
	AB.part({
		size      = Vector3.new(1.9, 0.7, 1.9),
		color     = HAIR,
		cf        = AB.offset(originCF, 0, 2.95, 0),
		canCollide = false,
		name      = "HairTop",
	}, model)

	-- Hair flower (yellow dot on the side)
	AB.sphere(0.5, FLOWER, AB.offset(originCF, -0.9, 2.7, 0.3), model, "Flower")

	for _, side in {-1, 1} do
		AB.part({
			size      = Vector3.new(0.9, 0.9, 2.4),
			color     = KIMONO,
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
