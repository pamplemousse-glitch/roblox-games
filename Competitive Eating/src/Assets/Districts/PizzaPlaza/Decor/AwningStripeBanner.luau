-- Awning Stripe Banner — long red/white striped fabric banner strung across
-- between two buildings, with golden tassels at the ends.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local RED   = Color3.fromRGB(200, 40, 40)
local WHT   = Color3.fromRGB(245, 240, 230)
local GOLD  = Color3.fromRGB(220, 180, 60)
local WIRE  = Color3.fromRGB(80, 50, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("AwningStripeBanner", parent)

	-- Two anchor posts
	AB.cylinder(0.25, 6, WIRE, AB.offset(originCF, -10, 3, 0), model, "PostL")
	AB.cylinder(0.25, 6, WIRE, AB.offset(originCF,  10, 3, 0), model, "PostR")
	-- Banner string
	AB.cylinder(0.08, 20, WIRE,
		AB.offset(originCF, 0, 5.5, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "String")

	-- Banner stripes (8 alternating)
	for i = 0, 7 do
		local x = -9 + i * 2.6
		local c = (i % 2 == 0) and RED or WHT
		AB.block(Vector3.new(2.4, 2.5, 0.15), c, AB.offset(originCF, x, 4.3, 0), model, "Stripe_" .. i)
	end
	-- Bottom scallop edge
	for i = 0, 9 do
		AB.wedge(Vector3.new(2, 0.6, 0.2), (i % 2 == 0) and RED or WHT,
			AB.offset(originCF, -9 + i * 2, 3, 0) * CFrame.Angles(math.rad(180), 0, 0),
			model, "Scallop_" .. i)
	end

	-- Tassels at each end (gold spheres + strings)
	for k, sx in {-1, 1} do
		AB.sphere(0.6, GOLD, AB.offset(originCF, sx * 10, 4.5, 0), model, "TasselBall_" .. k)
		for j = 1, 4 do
			AB.cylinder(0.08, 1.5, GOLD,
				AB.offset(originCF, sx * 10 + (j - 2.5) * 0.15, 3.5, 0), model, "TasselStrand_" .. k .. "_" .. j)
		end
	end

	-- "FESTA" text in middle (one band)
	local txt = AB.block(Vector3.new(5, 1, 0.1), GOLD, AB.offset(originCF, 0, 4.3, 0.18), model, "FestaText")
	AB.neon(txt)

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
