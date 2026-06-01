-- Doña Rosa — older mercado matriarch: papel-green dress, embroidered shawl,
-- silver-streaked bun, rosary.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN        = Color3.fromRGB(215, 170, 130)
local DRESS_GREEN = Color3.fromRGB(93, 168, 85)
local SHAWL_RED   = Color3.fromRGB(180, 50, 50)
local SHAWL_TRIM  = Color3.fromRGB(255, 184, 52)
local HAIR_GREY   = Color3.fromRGB(180, 175, 170)
local HAIR_DARK   = Color3.fromRGB(60, 45, 40)
local SHOE_BROWN  = Color3.fromRGB(85, 55, 35)
local ROSARY_GOLD = Color3.fromRGB(220, 180, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DonaRosa", parent)

	-- Torso (green dress)
	local torso = AB.block(Vector3.new(2.6, 3, 1.3), DRESS_GREEN,
		AB.offset(originCF, 0, 1.5, 0), model, "Torso")

	-- Shawl over the shoulders
	AB.block(Vector3.new(3.2, 1.6, 1.5), SHAWL_RED,
		AB.offset(originCF, 0, 2.4, 0), model, "Shawl")
	-- Shawl trim (yellow fringe at bottom)
	AB.block(Vector3.new(3.25, 0.2, 1.55), SHAWL_TRIM,
		AB.offset(originCF, 0, 1.65, 0), model, "ShawlTrim")
	-- Embroidered floral dots on shawl
	for i, pos in {
		Vector3.new(-1.0, 2.3,  0.8),
		Vector3.new( 1.0, 2.3,  0.8),
		Vector3.new( 0.0, 2.7,  0.8),
		Vector3.new(-1.0, 2.7,  0.8),
		Vector3.new( 1.0, 2.7,  0.8),
	} do
		AB.sphere(0.25, SHAWL_TRIM,
			AB.offset(originCF, pos.X, pos.Y, pos.Z),
			model, "Embroidery_" .. i)
	end

	-- Long dress skirt
	AB.block(Vector3.new(2.9, 2.6, 1.6), DRESS_GREEN,
		AB.offset(originCF, 0, -1.1, 0), model, "Skirt")

	-- Head
	AB.sphere(1.8, SKIN, AB.offset(originCF, 0, 3.9, 0), model, "Head")
	-- Eyes
	for i, x in {-0.35, 0.35} do
		AB.sphere(0.16, Color3.fromRGB(50, 35, 25),
			AB.offset(originCF, x, 4.0, 0.85), model, "Eye_" .. i)
	end
	-- Wrinkle lines (small dark blocks near eyes)
	for i, pos in {
		Vector3.new(-0.55, 3.85, 0.85), Vector3.new(0.55, 3.85, 0.85),
	} do
		AB.block(Vector3.new(0.2, 0.05, 0.05),
			Color3.fromRGB(170, 130, 100),
			AB.offset(originCF, pos.X, pos.Y, pos.Z),
			model, "Wrinkle_" .. i)
	end
	-- Warm smile
	AB.block(Vector3.new(0.7, 0.12, 0.12), Color3.fromRGB(160, 90, 70),
		AB.offset(originCF, 0, 3.5, 0.85), model, "Mouth")

	-- Hair bun (silver-streaked grey)
	AB.sphere(1.9, HAIR_GREY,
		AB.offset(originCF, 0, 4.0, -0.15), model, "Hair")
	AB.sphere(1.0, HAIR_GREY,
		AB.offset(originCF, 0, 4.6, -0.9), model, "Bun")
	-- Dark streak in hair
	AB.block(Vector3.new(0.3, 1.2, 1.6), HAIR_DARK,
		AB.offset(originCF, 0.7, 4.1, -0.2), model, "HairStreak")

	-- Arms (hands clasped in front)
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.9, 2.4, 0.9), DRESS_GREEN,
			AB.offset(originCF, side * 1.7, 1.5, 0),
			model, "Arm_" .. (side == -1 and "L" or "R"))
		AB.sphere(0.65, SKIN,
			AB.offset(originCF, side * 0.55, 0.3, 0.6),
			model, "Hand_" .. (side == -1 and "L" or "R"))
	end

	-- Rosary draped from clasped hands
	for i = 1, 5 do
		AB.sphere(0.18, ROSARY_GOLD,
			AB.offset(originCF, -0.2 + (i - 1) * 0.1, 0.0 - (i - 1) * 0.18, 0.9),
			model, "Bead_" .. i)
	end
	AB.block(Vector3.new(0.12, 0.5, 0.05), ROSARY_GOLD,
		AB.offset(originCF, 0.2, -0.9, 0.95), model, "Cross")

	-- Shoes
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.9, 0.4, 1.4), SHOE_BROWN,
			AB.offset(originCF, side * 0.55, -2.6, 0.25),
			model, "Shoe_" .. (side == -1 and "L" or "R"))
	end

	-- Nametag
	local head = model:FindFirstChild("Head") :: BasePart
	if head then AB.billboard(head, "Doña Rosa", Vector2.new(220, 36), 2.5) end

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
