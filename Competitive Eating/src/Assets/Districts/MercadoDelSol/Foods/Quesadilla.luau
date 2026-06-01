-- Quesadilla — flat folded round, cheese strings escape the seam.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TORTILLA   = Color3.fromRGB(232, 210, 160)
local CHEESE     = Color3.fromRGB(255, 215, 80)
local CHAR_BROWN = Color3.fromRGB(150, 110, 70)
local SOUR_CREAM = Color3.fromRGB(245, 240, 230)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Quesadilla", parent)

	-- Bottom half-circle (a wide flat wedge stand-in via cylinder cut)
	-- We build the half-moon as a thin cylinder, then place an occluder behind
	-- so visually it reads as a half. Easier shortcut: scaled wedge.
	local base = AB.wedge(
		Vector3.new(5.4, 0.4, 5.4),
		TORTILLA,
		AB.offset(originCF, 0, 0.4, 0),
		model,
		"BottomTortilla"
	)

	-- Cheese filling (slightly smaller wedge sandwiched on top)
	AB.wedge(
		Vector3.new(5.0, 0.25, 5.0),
		CHEESE,
		AB.offset(originCF, 0, 0.65, 0),
		model,
		"CheeseFill"
	)

	-- Top tortilla (slightly browned variant)
	AB.wedge(
		Vector3.new(5.4, 0.35, 5.4),
		Color3.fromRGB(210, 185, 130),
		AB.offset(originCF, 0, 0.95, 0),
		model,
		"TopTortilla"
	)

	-- Cheese strings escaping the seam (thin yellow blocks angled down)
	for i, offset in {
		Vector3.new(-1.6, 0,  0),
		Vector3.new(-0.5, 0,  0),
		Vector3.new( 0.7, 0,  0),
		Vector3.new( 1.8, 0,  0),
	} do
		AB.part({
			size  = Vector3.new(0.15, 1.0, 0.5),
			color = CHEESE,
			cf    = AB.offset(originCF, offset.X, 0.4, -2.5) * CFrame.Angles(math.rad(-15), 0, 0),
			name  = "CheeseString_" .. i,
		}, model)
	end

	-- Char marks on top tortilla (a few darker dots)
	for i, offset in {
		Vector3.new(-1.2, 0,  0.5),
		Vector3.new( 0.8, 0, -0.6),
		Vector3.new( 0.0, 0,  1.4),
		Vector3.new( 1.5, 0,  0.0),
	} do
		AB.part({
			size  = Vector3.new(0.6, 0.08, 0.5),
			color = CHAR_BROWN,
			cf    = AB.offset(originCF, offset.X, 1.18, offset.Z),
			name  = "Char_" .. i,
		}, model)
	end

	-- Sour cream dollop on the side
	AB.sphere(
		0.7,
		SOUR_CREAM,
		AB.offset(originCF, 1.7, 1.3, 1.2),
		model,
		"SourCream"
	)

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
