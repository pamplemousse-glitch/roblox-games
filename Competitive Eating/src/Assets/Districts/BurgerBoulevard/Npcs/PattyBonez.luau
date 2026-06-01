-- Patty Bonez — skeletal biker NPC. Leather jacket, sunglasses, skull face.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKULL    = Color3.fromRGB(235, 230, 215)
local LEATHER  = Color3.fromRGB(35, 35, 40)
local DENIM    = Color3.fromRGB(70, 80, 110)
local CHROME   = Color3.fromRGB(176, 176, 176)
local NEON_RED = Color3.fromRGB(255, 48, 48)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PattyBonez", parent)

	-- Legs (denim)
	AB.block(Vector3.new(0.7, 2.4, 0.7), DENIM, AB.offset(originCF, -0.4, 1.2, 0), model, "LegL")
	AB.block(Vector3.new(0.7, 2.4, 0.7), DENIM, AB.offset(originCF,  0.4, 1.2, 0), model, "LegR")

	-- Boots
	AB.block(Vector3.new(0.9, 0.6, 1.2), LEATHER, AB.offset(originCF, -0.4, 0.3, 0.2), model, "BootL")
	AB.block(Vector3.new(0.9, 0.6, 1.2), LEATHER, AB.offset(originCF,  0.4, 0.3, 0.2), model, "BootR")

	-- Torso (leather jacket)
	local torso = AB.block(
		Vector3.new(2.1, 2.5, 1.1),
		LEATHER,
		AB.offset(originCF, 0, 3.65, 0),
		model,
		"Torso"
	)
	torso.Material = Enum.Material.Plastic

	-- White t-shirt strip (visible at the neck/chest)
	AB.block(
		Vector3.new(0.8, 1.4, 0.05),
		Color3.fromRGB(245, 245, 240),
		AB.offset(originCF, 0, 4.0, 0.6),
		model,
		"Shirt"
	)

	-- Jacket collar (popped collar effect — two small angled blocks)
	AB.block(Vector3.new(0.3, 0.6, 0.4), LEATHER, AB.offset(originCF, -0.7, 4.8, 0.4) * CFrame.Angles(0, 0, math.rad(15)), model, "CollarL")
	AB.block(Vector3.new(0.3, 0.6, 0.4), LEATHER, AB.offset(originCF,  0.7, 4.8, 0.4) * CFrame.Angles(0, 0, math.rad(-15)), model, "CollarR")

	-- Arms (leather)
	AB.block(Vector3.new(0.65, 2, 0.65), LEATHER, AB.offset(originCF, -1.35, 3.5, 0), model, "ArmL")
	AB.block(Vector3.new(0.65, 2, 0.65), LEATHER, AB.offset(originCF,  1.35, 3.5, 0), model, "ArmR")

	-- Skeleton hands
	AB.sphere(0.55, SKULL, AB.offset(originCF, -1.35, 2.4, 0), model, "HandL")
	AB.sphere(0.55, SKULL, AB.offset(originCF,  1.35, 2.4, 0), model, "HandR")

	-- Skull head
	AB.sphere(1.4, SKULL, AB.offset(originCF, 0, 5.6, 0), model, "Skull")

	-- Eye sockets (dark hollows)
	AB.sphere(0.32, Color3.fromRGB(15, 15, 15), AB.offset(originCF, -0.32, 5.7, 0.65), model, "SocketL")
	AB.sphere(0.32, Color3.fromRGB(15, 15, 15), AB.offset(originCF,  0.32, 5.7, 0.65), model, "SocketR")

	-- Sunglasses (a single black bar)
	AB.block(
		Vector3.new(1.5, 0.35, 0.15),
		Color3.fromRGB(10, 10, 15),
		AB.offset(originCF, 0, 5.7, 0.75),
		model,
		"Shades"
	)

	-- Jaw line gap (dark horizontal line)
	AB.block(Vector3.new(0.9, 0.05, 0.05), Color3.fromRGB(20, 20, 20), AB.offset(originCF, 0, 5.15, 0.7), model, "Jaw")

	-- Red glow around skull (his thing)
	AB.glow(torso, NEON_RED, 1.0)

	-- Name tag
	AB.billboard(torso, "Patty Bonez", Vector2.new(220, 36), 4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
