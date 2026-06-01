-- Don Pepe — older taqueria owner: terracotta poncho, sombrero, gray mustache.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN        = Color3.fromRGB(210, 165, 130)
local PONCHO_TERR = Color3.fromRGB(196, 95, 44)
local PONCHO_TRIM = Color3.fromRGB(255, 184, 52)
local PANTS_DARK  = Color3.fromRGB(70, 50, 35)
local HAT_TAN     = Color3.fromRGB(220, 190, 130)
local HAT_BAND    = Color3.fromRGB(140, 80, 50)
local MUSTACHE    = Color3.fromRGB(220, 215, 210)
local BOOT_BROWN  = Color3.fromRGB(85, 55, 35)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DonPepe", parent)

	-- Torso
	local torso = AB.block(Vector3.new(2.6, 3, 1.2), PONCHO_TERR,
		AB.offset(originCF, 0, 1.5, 0), model, "Torso")
	-- Poncho trim stripe across chest
	AB.block(Vector3.new(2.7, 0.4, 1.25), PONCHO_TRIM,
		AB.offset(originCF, 0, 1.0, 0), model, "PonchoTrim")

	-- Head
	AB.sphere(1.8, SKIN, AB.offset(originCF, 0, 3.9, 0), model, "Head")

	-- Mustache (under the nose)
	AB.block(Vector3.new(1.2, 0.25, 0.2), MUSTACHE,
		AB.offset(originCF, 0, 3.55, 0.85), model, "Mustache")

	-- Eyes
	for i, x in {-0.35, 0.35} do
		AB.sphere(0.18, Color3.fromRGB(30, 25, 25),
			AB.offset(originCF, x, 4.0, 0.85), model, "Eye_" .. i)
	end

	-- Sombrero brim (wide cylinder)
	AB.cylinder(4.5, 0.3, HAT_TAN,
		AB.offset(originCF, 0, 4.75, 0), model, "HatBrim")
	-- Sombrero crown
	AB.cylinder(2.4, 1.2, HAT_TAN,
		AB.offset(originCF, 0, 5.5, 0) * CFrame.Angles(0, 0, math.rad(-90)),
		model, "HatCrown")
	-- Hat band
	AB.cylinder(2.45, 0.25, HAT_BAND,
		AB.offset(originCF, 0, 5.0, 0) * CFrame.Angles(0, 0, math.rad(-90)),
		model, "HatBand")

	-- Arms (slightly down at sides)
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.9, 2.4, 0.9), PONCHO_TERR,
			AB.offset(originCF, side * 1.7, 1.5, 0),
			model, "Arm_" .. (side == -1 and "L" or "R"))
		-- Hand
		AB.sphere(0.7, SKIN,
			AB.offset(originCF, side * 1.7, 0.2, 0),
			model, "Hand_" .. (side == -1 and "L" or "R"))
	end

	-- Pants (legs)
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.9, 2.6, 1.0), PANTS_DARK,
			AB.offset(originCF, side * 0.6, -1.3, 0),
			model, "Leg_" .. (side == -1 and "L" or "R"))
		AB.block(Vector3.new(1.0, 0.4, 1.5), BOOT_BROWN,
			AB.offset(originCF, side * 0.6, -2.8, 0.25),
			model, "Boot_" .. (side == -1 and "L" or "R"))
	end

	-- Nametag
	local head = model:FindFirstChild("Head") :: BasePart
	if head then AB.billboard(head, "Don Pepe", Vector2.new(200, 36), 2.5) end

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
