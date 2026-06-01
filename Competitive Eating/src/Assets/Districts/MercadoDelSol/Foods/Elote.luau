-- Elote — corn on the cob on a stick: yellow kernels, white mayo coat,
-- yellow cheese dust, red chili sprinkle.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local KERNEL_YELLOW = Color3.fromRGB(255, 200, 60)
local KERNEL_DEEP   = Color3.fromRGB(225, 165, 40)
local MAYO_WHITE    = Color3.fromRGB(250, 245, 230)
local COTIJA        = Color3.fromRGB(255, 235, 175)
local CHILI_RED     = Color3.fromRGB(210, 55, 35)
local STICK_BROWN   = Color3.fromRGB(140, 100, 60)
local LIME_GREEN    = Color3.fromRGB(150, 200, 90)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Elote", parent)

	-- Wooden stick (horizontal, sticks out one end)
	local stick = AB.part({
		size  = Vector3.new(6.0, 0.5, 0.5),
		color = STICK_BROWN,
		cf    = AB.offset(originCF, 0, 1.5, 0) * CFrame.Angles(0, math.rad(90), 0),
		shape = Enum.PartType.Cylinder,
		name  = "Stick",
	}, model)

	-- Corn cob body (slightly larger cylinder, surrounds stick)
	local cob = AB.part({
		size  = Vector3.new(4.2, 2.0, 2.0),
		color = KERNEL_YELLOW,
		cf    = AB.offset(originCF, -0.4, 1.5, 0) * CFrame.Angles(0, math.rad(90), 0),
		shape = Enum.PartType.Cylinder,
		name  = "Cob",
	}, model)

	-- Kernel bumps (rows of small spheres around the cob for texture)
	for row = 1, 4 do
		local rowAngle = (row / 4) * 2 * math.pi
		for col = 1, 6 do
			local zPos = -1.6 + (col - 1) * 0.6
			local y = 1.5 + 0.95 * math.cos(rowAngle)
			local x = -0.4 + 0.95 * math.sin(rowAngle)
			AB.sphere(
				0.3,
				(row + col) % 2 == 0 and KERNEL_DEEP or KERNEL_YELLOW,
				AB.offset(originCF, x, y, zPos),
				model,
				string.format("Kernel_%d_%d", row, col)
			)
		end
	end

	-- Mayo coat (thin lighter cylinder above the cob)
	AB.part({
		size  = Vector3.new(3.6, 2.15, 2.15),
		color = MAYO_WHITE,
		cf    = AB.offset(originCF, -0.4, 1.5, 0) * CFrame.Angles(0, math.rad(90), 0),
		shape = Enum.PartType.Cylinder,
		transparency = 0.35,
		name  = "MayoCoat",
	}, model)

	-- Cheese dust (small white-yellow cubes on top)
	for i, offset in {
		Vector3.new(-1.4, 0,  0.4),
		Vector3.new(-0.6, 0, -0.3),
		Vector3.new( 0.5, 0,  0.2),
		Vector3.new( 1.4, 0, -0.4),
	} do
		AB.block(
			Vector3.new(0.25, 0.1, 0.25),
			COTIJA,
			AB.offset(originCF, offset.X, 2.55, offset.Z),
			model,
			"Cotija_" .. i
		)
	end

	-- Chili sprinkle (small red dots)
	for i, offset in {
		Vector3.new(-1.0, 0,  0.3),
		Vector3.new( 0.0, 0, -0.4),
		Vector3.new( 1.2, 0,  0.4),
		Vector3.new(-0.4, 0, -0.6),
		Vector3.new( 0.8, 0,  0.7),
	} do
		AB.sphere(
			0.15,
			CHILI_RED,
			AB.offset(originCF, offset.X, 2.6, offset.Z),
			model,
			"Chili_" .. i
		)
	end

	-- Lime wedge stuck on the end
	AB.wedge(
		Vector3.new(0.8, 0.8, 0.8),
		LIME_GREEN,
		AB.offset(originCF, 2.3, 1.7, 0) * CFrame.Angles(0, math.rad(90), 0),
		model,
		"LimeWedge"
	)

	AB.pivot(model, cob)
	AB.weldAll(model)
	return model
end
