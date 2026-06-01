-- Chuckwagon Stand — covered wagon trailer-cart with a BBQ rig in the back.
-- White canvas top over a brown wagon box, 4 wheels, a hitching tongue, and
-- a glowing grill barrel on the rear.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SMOKED_WOOD = Color3.fromRGB(107, 68, 35)
local DARK_WOOD   = Color3.fromRGB(70, 45, 22)
local CANVAS      = Color3.fromRGB(240, 230, 210)
local STEEL       = Color3.fromRGB(70, 70, 75)
local EMBER       = Color3.fromRGB(255, 128, 48)
local IRON        = Color3.fromRGB(45, 45, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ChuckwagonStand", parent)

	-- Ground pad (gravel patch)
	local pad = AB.block(
		Vector3.new(18, 0.3, 12),
		Color3.fromRGB(150, 140, 120),
		AB.offset(originCF, 0, 0.15, 0),
		model, "Pad"
	)

	-- Wagon box (the main cart body)
	AB.block(Vector3.new(10, 3, 5), SMOKED_WOOD, AB.offset(originCF, 0, 3, 0),   model, "WagonBox")
	AB.block(Vector3.new(10.2, 0.4, 5.2), DARK_WOOD, AB.offset(originCF, 0, 4.6, 0), model, "WagonRim")

	-- 4 wheels (cylinders rotating along Z so they face outward on X axis)
	for i, pos in {
		Vector3.new(-3.5, 1.2,  2.6),
		Vector3.new( 3.5, 1.2,  2.6),
		Vector3.new(-3.5, 1.2, -2.6),
		Vector3.new( 3.5, 1.2, -2.6),
	} do
		AB.part({
			size  = Vector3.new(0.4, 2.4, 2.4),
			color = DARK_WOOD,
			cf    = originCF * CFrame.new(pos),
			shape = Enum.PartType.Cylinder,
			name  = "Wheel_" .. i,
		}, model)
		-- Iron hub
		AB.part({
			size  = Vector3.new(0.5, 0.6, 0.6),
			color = IRON,
			cf    = originCF * CFrame.new(pos),
			shape = Enum.PartType.Ball,
			name  = "Hub_" .. i,
		}, model)
	end

	-- Hitching tongue extending forward
	AB.block(Vector3.new(0.5, 0.4, 5), DARK_WOOD, AB.offset(originCF, 0, 1.2, 5.5), model, "Tongue")

	-- Canvas top — three arched ribs + roof
	for i, x in {-4, 0, 4} do
		AB.block(Vector3.new(0.3, 4, 5), CANVAS, AB.offset(originCF, x, 6.6, 0), model, "Rib_" .. i)
	end
	-- The big rounded canvas top (use a wide flat block to suggest the cover)
	AB.block(Vector3.new(10, 0.5, 6), CANVAS, AB.offset(originCF, 0, 8.8, 0), model, "CanvasTop")
	AB.block(Vector3.new(10, 4, 0.3), CANVAS, AB.offset(originCF, 0, 6.6, 2.8), model, "CanvasSideR")
	AB.block(Vector3.new(10, 4, 0.3), CANVAS, AB.offset(originCF, 0, 6.6, -2.8), model, "CanvasSideL")

	-- BBQ rig on the back: steel barrel grill mounted on legs
	AB.part({
		size  = Vector3.new(4, 2.5, 2.5),
		color = STEEL,
		cf    = AB.offset(originCF, 0, 2.6, -6.5) * CFrame.Angles(0, 0, math.rad(90)),
		shape = Enum.PartType.Cylinder,
		name  = "GrillBarrel",
	}, model)
	-- Legs
	for i, x in {-1.6, 1.6} do
		AB.block(Vector3.new(0.3, 2.4, 0.3), IRON, AB.offset(originCF, x, 1.2, -6.5), model, "GrillLeg_" .. i)
	end
	-- Smokestack on top of barrel
	AB.block(Vector3.new(0.6, 2.5, 0.6), IRON, AB.offset(originCF, 1.2, 5.0, -6.5), model, "GrillStack")
	-- Ember glow inside the barrel mouth (the open end)
	local ember = AB.sphere(0.9, EMBER, AB.offset(originCF, 2.2, 2.6, -6.5), model, "Ember")
	AB.neon(ember)
	AB.glow(ember, EMBER, 2.5)

	AB.pivot(model, pad)
	AB.weldAll(model)
	return model
end
