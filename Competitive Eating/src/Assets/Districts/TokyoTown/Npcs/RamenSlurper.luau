-- Ramen Slurper — pedestrian leaning forward with a bowl of ramen, chopsticks
-- mid-slurp. Casual t-shirt and jeans look.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "Slurper"
local SKIN       = Color3.fromRGB(255, 220, 180)
local TSHIRT     = Color3.fromRGB(80, 120, 170)
local JEANS      = Color3.fromRGB(60, 70, 110)
local HAIR_DARK  = Color3.fromRGB(40, 30, 30)
local PAPER_WHT  = Color3.fromRGB(245, 240, 230)
local BROTH      = Color3.fromRGB(200, 150, 70)
local NOODLE     = Color3.fromRGB(235, 215, 150)
local DARK_WOOD  = Color3.fromRGB(80, 50, 30)
local SCALLION   = Color3.fromRGB(140, 180, 100)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (t-shirt)
	local torso = AB.part({
		size = Vector3.new(2.6, 3, 1.2), color = TSHIRT,
		cf = originCF, canCollide = false, name = "Torso",
	}, model)
	-- Jeans
	AB.part({
		size = Vector3.new(2.6, 0.8, 1.2), color = JEANS,
		cf = AB.offset(originCF, 0, -1.7, 0), canCollide = false, name = "Pants",
	}, model)

	-- Head — leaning forward at angle
	local head = AB.part({
		size = Vector3.new(1.8, 1.8, 1.8), color = SKIN,
		cf = AB.offset(originCF, 0, 2.0, 0.4) * CFrame.Angles(math.rad(20), 0, 0),
		shape = Enum.PartType.Ball, canCollide = false, name = "Head",
	}, model)
	-- Hair
	AB.part({
		size = Vector3.new(1.9, 0.8, 1.9), color = HAIR_DARK,
		cf = AB.offset(originCF, 0, 2.6, 0.2) * CFrame.Angles(math.rad(20), 0, 0),
		canCollide = false, name = "Hair",
	}, model)
	-- Open mouth (small black oval — mid-slurp)
	AB.sphere(0.35, Color3.fromRGB(40, 30, 30),
		AB.offset(originCF, 0, 1.5, 1.1), model, "Mouth")

	-- Arms held forward holding bowl
	for _, side in {-1, 1} do
		AB.part({
			size = Vector3.new(0.85, 0.85, 2.5), color = TSHIRT,
			cf = AB.offset(originCF, side * 1.4, 0, -0.8), canCollide = false,
			name = "Arm_" .. (side == -1 and "L" or "R"),
		}, model)
	end

	-- Ramen bowl held in front
	AB.cylinder(2.4, 1.0, PAPER_WHT,
		AB.offset(originCF, 0, -0.2, -2.2), model, "Bowl")
	-- Broth
	AB.cylinder(2.0, 0.1, BROTH, AB.offset(originCF, 0, 0.25, -2.2), model, "Broth")
	-- Noodle nest
	for i, yaw in {0, 45, 90} do
		AB.block(Vector3.new(1.5, 0.2, 0.25), NOODLE,
			AB.offset(originCF, 0, 0.35, -2.2, yaw), model, "Noodles_" .. i)
	end
	-- Scallions
	for i = 1, 4 do
		local angle = (i - 1) * (math.pi / 2)
		AB.block(Vector3.new(0.3, 0.15, 0.3), SCALLION,
			AB.offset(originCF, math.cos(angle) * 0.6, 0.4, -2.2 + math.sin(angle) * 0.6),
			model, "Scallion_" .. i)
	end

	-- Chopsticks rising from bowl with noodle strand attached
	AB.block(Vector3.new(0.1, 1.6, 0.1), DARK_WOOD,
		AB.offset(originCF, 0.3, 1.2, -2) * CFrame.Angles(math.rad(-30), 0, 0),
		model, "Chopstick1")
	AB.block(Vector3.new(0.1, 1.6, 0.1), DARK_WOOD,
		AB.offset(originCF, 0.6, 1.2, -2) * CFrame.Angles(math.rad(-30), 0, 0),
		model, "Chopstick2")
	-- Noodle strand dangling from chopsticks to mouth
	AB.block(Vector3.new(0.08, 1.2, 0.08), NOODLE,
		AB.offset(originCF, 0.4, 1.6, -1.5) * CFrame.Angles(math.rad(-50), 0, 0),
		model, "NoodleStrand")

	AB.billboard(head, NAME, Vector2.new(220, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
