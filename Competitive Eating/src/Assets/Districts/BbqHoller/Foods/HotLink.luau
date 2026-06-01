-- Hot Link — a smoked sausage link with charred grill marks across the top.
-- Reddish-brown cylinder lying flat on a plate, with dark stripes baked in.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SAUSAGE = Color3.fromRGB(150, 55, 30)
local CHAR    = Color3.fromRGB(35, 18, 10)
local PLATE   = Color3.fromRGB(220, 210, 195)
local TIE     = Color3.fromRGB(95, 50, 25)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("HotLink", parent)

	-- Plate (a flat disc)
	local plate = AB.cylinder(
		6, 0.3, PLATE,
		AB.offset(originCF, 0, 0.15, 0),
		model, "Plate"
	)

	-- Sausage body — lying along the Z axis
	AB.part({
		size  = Vector3.new(1.3, 5.0, 1.3),
		color = SAUSAGE,
		cf    = AB.offset(originCF, 0, 0.95, 0) * CFrame.Angles(math.rad(90), 0, 0),
		shape = Enum.PartType.Cylinder,
		name  = "Sausage",
	}, model)

	-- Rounded ends (spheres for the casing twist)
	for i, z in {-2.5, 2.5} do
		AB.sphere(
			1.3, SAUSAGE,
			AB.offset(originCF, 0, 0.95, z),
			model, "End_" .. i
		)
		-- Tied-off "ear" of casing
		AB.part({
			size  = Vector3.new(0.4, 0.4, 0.4),
			color = TIE,
			cf    = AB.offset(originCF, 0, 1.15, z * 1.18),
			name  = "Tie_" .. i,
		}, model)
	end

	-- Grill marks across the top (4 dark stripes perpendicular to length)
	for i = 1, 4 do
		local z = -1.8 + (i - 1) * 1.2
		AB.block(
			Vector3.new(1.35, 0.08, 0.35),
			CHAR,
			AB.offset(originCF, 0, 1.62, z),
			model,
			"GrillMark_" .. i
		)
	end

	AB.pivot(model, plate)
	AB.weldAll(model)
	return model
end
