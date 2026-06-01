-- Taco — folded yellow corn shell with brown meat, green lettuce, red salsa.
-- Shell is two angled blocks meeting at a V; fillings poke out the top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SHELL_YELLOW = Color3.fromRGB(245, 200, 90)
local MEAT_BROWN   = Color3.fromRGB(120, 70, 35)
local LETTUCE      = Color3.fromRGB(120, 200, 90)
local SALSA_RED    = Color3.fromRGB(210, 55, 45)
local CHEESE       = Color3.fromRGB(255, 215, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Taco", parent)

	-- Two shell halves angled inward, meeting at the bottom seam
	local leftShell = AB.part({
		size  = Vector3.new(0.4, 3.2, 4.6),
		color = SHELL_YELLOW,
		cf    = AB.offset(originCF, -0.9, 1.6, 0) * CFrame.Angles(0, 0, math.rad(-22)),
		name  = "ShellL",
	}, model)

	AB.part({
		size  = Vector3.new(0.4, 3.2, 4.6),
		color = SHELL_YELLOW,
		cf    = AB.offset(originCF, 0.9, 1.6, 0) * CFrame.Angles(0, 0, math.rad(22)),
		name  = "ShellR",
	}, model)

	-- Bottom seam (thin block to hide the gap)
	AB.block(
		Vector3.new(0.6, 0.4, 4.4),
		SHELL_YELLOW,
		AB.offset(originCF, 0, 0.3, 0),
		model,
		"ShellSeam"
	)

	-- Meat layer (visible from above between the shell halves)
	AB.block(
		Vector3.new(1.4, 0.5, 3.8),
		MEAT_BROWN,
		AB.offset(originCF, 0, 1.4, 0),
		model,
		"Meat"
	)

	-- Lettuce strands (3 small green cubes poking up)
	for i, offset in {
		Vector3.new(-0.4, 0,  1.0),
		Vector3.new( 0.5, 0, -0.3),
		Vector3.new(-0.3, 0, -1.2),
	} do
		AB.block(
			Vector3.new(0.4, 0.6, 0.5),
			LETTUCE,
			AB.offset(originCF, offset.X, 2.0, offset.Z),
			model,
			"Lettuce_" .. i
		)
	end

	-- Salsa dots (3 red spheres on top of the meat)
	for i, z in {-1.0, 0.2, 1.3} do
		AB.sphere(
			0.5,
			SALSA_RED,
			AB.offset(originCF, 0.1, 1.9, z),
			model,
			"Salsa_" .. i
		)
	end

	-- Cheese sprinkles
	for i, offset in {
		Vector3.new(-0.5, 0,  0.5),
		Vector3.new( 0.4, 0, -0.8),
	} do
		AB.block(
			Vector3.new(0.25, 0.15, 0.25),
			CHEESE,
			AB.offset(originCF, offset.X, 2.05, offset.Z),
			model,
			"Cheese_" .. i
		)
	end

	AB.pivot(model, leftShell)
	AB.weldAll(model)
	return model
end
