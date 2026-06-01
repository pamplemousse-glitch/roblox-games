-- Salaryman Suited — Tokyo pedestrian. Black suit, white shirt, red tie,
-- briefcase in one hand. Generic anonymous office worker silhouette.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "Salaryman"
local SKIN       = Color3.fromRGB(255, 220, 180)
local SUIT_BLACK = Color3.fromRGB(35, 30, 40)
local SHIRT      = Color3.fromRGB(245, 240, 230)
local TIE_RED    = Color3.fromRGB(200, 50, 50)
local HAIR       = Color3.fromRGB(30, 25, 25)
local BRIEFCASE  = Color3.fromRGB(70, 50, 30)
local GOLD       = Color3.fromRGB(220, 180, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (black suit jacket)
	local torso = AB.part({
		size = Vector3.new(2.6, 3, 1.2), color = SUIT_BLACK,
		cf = originCF, canCollide = false, name = "Torso",
	}, model)
	-- White shirt panel front
	AB.part({
		size = Vector3.new(1.0, 2.8, 1.21), color = SHIRT,
		cf = AB.offset(originCF, 0, 0, 0.005), canCollide = false, name = "ShirtPanel",
	}, model)
	-- Red tie
	AB.part({
		size = Vector3.new(0.35, 2, 1.22), color = TIE_RED,
		cf = AB.offset(originCF, 0, -0.2, 0.01), canCollide = false, name = "Tie",
	}, model)
	-- Suit pants
	AB.part({
		size = Vector3.new(2.6, 0.8, 1.2), color = SUIT_BLACK,
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
		size = Vector3.new(1.85, 0.7, 1.85), color = HAIR,
		cf = AB.offset(originCF, 0, 2.9, 0), canCollide = false, name = "Hair",
	}, model)
	-- Glasses (tiny gold frames)
	for i, x in {-0.5, 0.5} do
		AB.cylinder(0.5, 0.1, GOLD,
			AB.offset(originCF, x, 2.2, 0.85), model, "GlassFrame_" .. i)
	end

	-- Arms
	for _, side in {-1, 1} do
		AB.part({
			size = Vector3.new(0.9, 2.4, 0.9), color = SUIT_BLACK,
			cf = AB.offset(originCF, side * 1.6, 0, 0), canCollide = false,
			name = "Arm_" .. (side == -1 and "L" or "R"),
		}, model)
	end

	-- Briefcase in right hand (block hanging at the side)
	AB.part({
		size = Vector3.new(1.6, 1, 0.5), color = BRIEFCASE,
		cf = AB.offset(originCF, 1.6, -1.6, 0.4), canCollide = false, name = "Briefcase",
	}, model)
	-- Briefcase handle
	AB.block(Vector3.new(0.7, 0.18, 0.18), Color3.fromRGB(40, 30, 20),
		AB.offset(originCF, 1.6, -1.0, 0.4), model, "BriefcaseHandle")

	AB.billboard(head, NAME, Vector2.new(220, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
