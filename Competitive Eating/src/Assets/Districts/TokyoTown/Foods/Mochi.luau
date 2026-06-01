-- Mochi — three stacked round mochi balls in pastel colors (pink, white, green)
-- on a small dark plate. A skewer through the stack suggests dango.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PLATE_DARK  = Color3.fromRGB(50, 40, 45)
local SKEWER_WOOD = Color3.fromRGB(170, 140, 90)
local PINK        = Color3.fromRGB(245, 195, 210)
local CREAM       = Color3.fromRGB(245, 240, 230)
local MATCHA      = Color3.fromRGB(170, 200, 140)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Mochi", parent)

	-- Small round plate
	local plate = AB.cylinder(3.6, 0.25, PLATE_DARK, AB.offset(originCF, 0, 0.13, 0), model, "Plate")

	-- Skewer (thin wood cylinder running through the stack)
	AB.part({
		size  = Vector3.new(3.6, 0.12, 0.12),
		color = SKEWER_WOOD,
		cf    = AB.offset(originCF, 0, 2.2, 0) * CFrame.Angles(0, 0, math.rad(90)),
		shape = Enum.PartType.Cylinder,
		name  = "Skewer",
	}, model)

	-- 3 mochi balls stacked
	local colors = { PINK, CREAM, MATCHA }
	for i = 1, 3 do
		local y = 0.6 + (i - 1) * 1.05
		AB.sphere(1.3, colors[i], AB.offset(originCF, 0, y, 0), model, "Mochi_" .. i)
	end

	-- Tiny pastel dust speckles on the plate
	for i, offset in {
		Vector3.new( 1.2, 0,  0.6),
		Vector3.new(-1.1, 0, -0.4),
		Vector3.new( 0.5, 0,  1.1),
		Vector3.new(-0.6, 0,  0.9),
	} do
		AB.block(
			Vector3.new(0.18, 0.04, 0.18),
			(i % 2 == 1) and PINK or MATCHA,
			AB.offset(originCF, offset.X, 0.28, offset.Z),
			model,
			"Speckle_" .. i
		)
	end

	AB.pivot(model, plate)
	AB.weldAll(model)
	return model
end
