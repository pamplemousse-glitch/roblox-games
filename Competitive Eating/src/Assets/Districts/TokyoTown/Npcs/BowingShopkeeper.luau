-- Bowing Shopkeeper — older shopkeeper in traditional dark-blue happi coat
-- with white sash, bowing forward (greeting customers). Bald-ish head.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "Shopkeeper"
local SKIN       = Color3.fromRGB(255, 220, 180)
local HAPPI_NAVY = Color3.fromRGB(40, 50, 90)
local HAPPI_TRIM = Color3.fromRGB(245, 240, 230)
local PANTS_GREY = Color3.fromRGB(80, 80, 90)
local HAIR_GREY  = Color3.fromRGB(150, 145, 140)
local VERMILION  = Color3.fromRGB(200, 50, 40)
local DARK_WOOD  = Color3.fromRGB(80, 50, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso — tilted forward to suggest bowing
	local bowAngle = math.rad(35)
	local torso = AB.part({
		size = Vector3.new(2.6, 3, 1.2), color = HAPPI_NAVY,
		cf = originCF * CFrame.Angles(bowAngle, 0, 0),
		canCollide = false, name = "Torso",
	}, model)
	-- White trim band at front of happi
	AB.part({
		size = Vector3.new(0.5, 3.05, 1.25), color = HAPPI_TRIM,
		cf = originCF * CFrame.Angles(bowAngle, 0, 0) * CFrame.new(0, 0, 0.01),
		canCollide = false, name = "HappiTrim",
	}, model)
	-- Kanji emblem on back (vermilion square)
	AB.part({
		size = Vector3.new(1, 1, 0.05), color = VERMILION,
		cf = originCF * CFrame.Angles(bowAngle, 0, 0) * CFrame.new(0, 0.5, -0.65),
		canCollide = false, name = "HappiEmblem",
	}, model)

	-- Pants
	AB.part({
		size = Vector3.new(2.6, 0.8, 1.2), color = PANTS_GREY,
		cf = AB.offset(originCF, 0, -1.7, 0), canCollide = false, name = "Pants",
	}, model)

	-- Head — also tilted (bowing forward)
	local head = AB.part({
		size = Vector3.new(1.8, 1.8, 1.8), color = SKIN,
		cf = originCF * CFrame.Angles(bowAngle, 0, 0) * CFrame.new(0, 2.2, 0),
		shape = Enum.PartType.Ball, canCollide = false, name = "Head",
	}, model)
	-- Sparse grey hair (only a thin band around the head — balding shopkeeper)
	AB.part({
		size = Vector3.new(1.85, 0.4, 1.85), color = HAIR_GREY,
		cf = originCF * CFrame.Angles(bowAngle, 0, 0) * CFrame.new(0, 2.5, 0),
		canCollide = false, name = "Hair",
	}, model)

	-- Arms held down at sides (formal bow)
	for _, side in {-1, 1} do
		AB.part({
			size = Vector3.new(0.85, 2.4, 0.85), color = HAPPI_NAVY,
			cf = originCF * CFrame.Angles(bowAngle, 0, 0) * CFrame.new(side * 1.5, -0.3, 0.4),
			canCollide = false, name = "Arm_" .. (side == -1 and "L" or "R"),
		}, model)
	end

	-- Holding a small wooden noren rod in hands (welcoming gesture)
	AB.cylinder(0.18, 2.2, DARK_WOOD,
		originCF * CFrame.Angles(bowAngle, 0, 0) * CFrame.new(0, -1.4, 1.3) * CFrame.Angles(0, 0, math.rad(90)),
		model, "GreetingRod")

	AB.billboard(head, NAME, Vector2.new(220, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
