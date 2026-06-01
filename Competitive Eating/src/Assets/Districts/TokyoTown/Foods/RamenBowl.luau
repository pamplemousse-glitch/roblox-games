-- Ramen Bowl — white bowl, broth, noodle nest, halved soft-boiled egg, scallions.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local BROTH       = Color3.fromRGB(200, 150, 70)
local NOODLE      = Color3.fromRGB(235, 215, 150)
local EGG_WHITE   = Color3.fromRGB(250, 245, 225)
local YOLK        = Color3.fromRGB(245, 175, 60)
local SCALLION    = Color3.fromRGB(140, 180, 100)
local NORI        = Color3.fromRGB(40, 50, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RamenBowl", parent)

	-- Bowl outer shell (squat cylinder)
	local bowl = AB.cylinder(4.4, 1.6, PAPER_WHITE, AB.offset(originCF, 0, 0.8, 0), model, "Bowl")

	-- Bowl inner rim (slightly smaller, neon for subtle highlight)
	AB.cylinder(4.0, 0.2, PAPER_WHITE, AB.offset(originCF, 0, 1.55, 0), model, "Rim")

	-- Broth surface
	AB.cylinder(3.8, 0.1, BROTH, AB.offset(originCF, 0, 1.5, 0), model, "Broth")

	-- Noodle nest — three thin tori-ish blocks rotated to suggest tangle
	for i, yaw in {0, 45, 90} do
		AB.part({
			size  = Vector3.new(3.2, 0.25, 0.4),
			color = NOODLE,
			cf    = AB.offset(originCF, 0, 1.7, 0, yaw),
			name  = "Noodles_" .. i,
		}, model)
	end

	-- Soft-boiled egg halves — two domes (we use spheres slightly sunken into broth)
	for i, x in {-0.9, 0.9} do
		AB.sphere(1.1, EGG_WHITE, AB.offset(originCF, x, 1.85, 0.6), model, "Egg_" .. i)
		AB.sphere(0.55, YOLK,    AB.offset(originCF, x, 1.95, 0.6), model, "Yolk_" .. i)
	end

	-- Scallion bits (tiny green cubes)
	for i, offset in {
		Vector3.new(-1.2, 0,  -0.4),
		Vector3.new( 0.6, 0,  -0.9),
		Vector3.new( 1.3, 0,   0.3),
		Vector3.new(-0.3, 0,   1.0),
		Vector3.new( 0.1, 0,  -0.2),
	} do
		AB.block(
			Vector3.new(0.35, 0.2, 0.35),
			SCALLION,
			AB.offset(originCF, offset.X, 1.85, offset.Z),
			model,
			"Scallion_" .. i
		)
	end

	-- Nori sheet leaning against the bowl edge
	AB.part({
		size  = Vector3.new(1.4, 1.6, 0.08),
		color = NORI,
		cf    = AB.offset(originCF, -1.4, 2.1, -1.1) * CFrame.Angles(math.rad(-25), 0, 0),
		name  = "Nori",
	}, model)

	AB.pivot(model, bowl)
	AB.weldAll(model)
	return model
end
