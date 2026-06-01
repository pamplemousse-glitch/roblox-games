-- Mac & Cheese — a yellow cylinder of pasta mounded inside a small bowl.
-- Stoneware bowl + creamy cheese fill + a few visible elbow noodles on top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STONEWARE = Color3.fromRGB(225, 215, 195)
local STONE_DK  = Color3.fromRGB(170, 160, 140)
local CHEESE    = Color3.fromRGB(245, 195, 60)
local CHEESE_HL = Color3.fromRGB(255, 220, 110)
local CRUST     = Color3.fromRGB(200, 140, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MacAndCheese", parent)

	-- Bowl exterior (wider disc, beveled by stacking)
	local bowl = AB.cylinder(
		5.5, 0.8, STONE_DK,
		AB.offset(originCF, 0, 0.4, 0),
		model, "BowlBase"
	)

	AB.cylinder(
		5.2, 1.4, STONEWARE,
		AB.offset(originCF, 0, 1.1, 0),
		model, "BowlBody"
	)

	-- Cheese fill — bright yellow mound rising above bowl rim
	AB.cylinder(
		4.4, 1.2, CHEESE,
		AB.offset(originCF, 0, 2.0, 0),
		model, "CheeseFill"
	)

	-- Domed top (slight bulge)
	AB.cylinder(
		3.6, 0.6, CHEESE_HL,
		AB.offset(originCF, 0, 2.7, 0),
		model, "CheeseDome"
	)

	-- Toasted crust speckles around the rim
	for i = 1, 8 do
		local angle = (i / 8) * math.pi * 2
		local x = math.cos(angle) * 1.9
		local z = math.sin(angle) * 1.9
		AB.part({
			size  = Vector3.new(0.5, 0.2, 0.5),
			color = CRUST,
			cf    = AB.offset(originCF, x, 2.95, z),
			name  = "CrustChunk_" .. i,
		}, model)
	end

	-- A few elbow noodles poking out of the top (small curved-suggesting cylinders)
	for i, p in {
		Vector3.new(-0.7, 3.05,  0.4),
		Vector3.new( 0.5, 3.10, -0.5),
		Vector3.new( 0.0, 3.15,  0.7),
	} do
		AB.part({
			size  = Vector3.new(0.8, 0.4, 0.4),
			color = CHEESE_HL,
			cf    = originCF * CFrame.new(p) * CFrame.Angles(0, math.rad(i * 40), 0),
			shape = Enum.PartType.Cylinder,
			name  = "Elbow_" .. i,
		}, model)
	end

	AB.pivot(model, bowl)
	AB.weldAll(model)
	return model
end
