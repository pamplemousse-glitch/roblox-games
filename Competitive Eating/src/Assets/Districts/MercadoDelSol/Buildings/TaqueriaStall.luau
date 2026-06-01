-- Taqueria Stall — open-front street stall with grill, hand-painted sign,
-- bright striped canopy. Terracotta + fiesta yellow palette.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local GRILL_GREY   = Color3.fromRGB(60, 60, 60)
local EMBER_RED    = Color3.fromRGB(255, 95, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TaqueriaStall", parent)

	-- Foundation
	AB.block(
		Vector3.new(22, 0.5, 16),
		Color3.fromRGB(150, 145, 140),
		AB.offset(originCF, 0, 0.25, 0),
		model,
		"Foundation"
	)

	-- Back wall (terracotta stucco)
	AB.block(
		Vector3.new(22, 12, 0.8),
		TERRACOTTA,
		AB.offset(originCF, 0, 6, -7.5),
		model,
		"BackWall"
	)

	-- Side walls (half height — open-front stall)
	AB.block(Vector3.new(0.8, 6, 16), TERRACOTTA, AB.offset(originCF, -10.5, 3, 0), model, "WallL")
	AB.block(Vector3.new(0.8, 6, 16), TERRACOTTA, AB.offset(originCF,  10.5, 3, 0), model, "WallR")

	-- Counter at the front (wooden top)
	AB.block(Vector3.new(20, 0.5, 2), WOOD_DARK,
		AB.offset(originCF, 0, 4, 6.5), model, "CounterTop")
	AB.block(Vector3.new(20, 3.5, 1.5), TERRACOTTA,
		AB.offset(originCF, 0, 2, 6.7), model, "CounterFront")

	-- Grill behind the counter
	AB.block(Vector3.new(8, 1.2, 3), GRILL_GREY,
		AB.offset(originCF, 0, 4.8, 3), model, "Grill")
	for i, x in {-2.5, -0.8, 0.8, 2.5} do
		local ember = AB.block(Vector3.new(0.5, 0.2, 2.5), EMBER_RED,
			AB.offset(originCF, x, 5.3, 3), model, "Ember_" .. i)
		AB.neon(ember)
		AB.glow(ember, EMBER_RED, 1.2)
	end

	-- Sloped canopy roof (slightly sticks out front)
	AB.block(Vector3.new(24, 0.6, 18), FIESTA_YEL,
		AB.offset(originCF, 0, 12, 1), model, "CanopyTop")

	-- Canopy stripes (alternating green + teal underside, visible from front)
	for i, x in {-9, -6, -3, 0, 3, 6, 9} do
		AB.block(Vector3.new(2.4, 0.2, 17),
			i % 2 == 0 and PAPEL_GREEN or AGAVE_TEAL,
			AB.offset(originCF, x, 11.65, 1), model, "Stripe_" .. i)
	end

	-- Hand-painted sign (above the counter)
	local sign = AB.block(Vector3.new(12, 2.5, 0.4), Color3.fromRGB(245, 235, 200),
		AB.offset(originCF, 0, 9.5, 6.4), model, "SignBoard")
	-- Painted letters approximated by colorful blocks
	for i, x in {-4, -2.2, -0.5, 1.2, 2.9, 4.4} do
		AB.block(Vector3.new(1.0, 1.4, 0.1),
			i % 3 == 0 and TERRACOTTA or (i % 3 == 1 and PAPEL_GREEN or AGAVE_TEAL),
			AB.offset(originCF, x, 9.5, 6.25), model, "Letter_" .. i)
	end

	-- Support posts at corners
	for i, pos in {Vector3.new(-10, 0, 7), Vector3.new(10, 0, 7)} do
		AB.block(Vector3.new(0.8, 12, 0.8), WOOD_DARK,
			AB.offset(originCF, pos.X, 6, pos.Z), model, "Post_" .. i)
	end

	-- Pepper string hanging from the canopy edge (decorative)
	for i = 1, 5 do
		AB.sphere(0.4, Color3.fromRGB(200, 40, 30),
			AB.offset(originCF, -8 + (i - 1) * 4, 11, 6.5), model, "ChiliRistra_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
