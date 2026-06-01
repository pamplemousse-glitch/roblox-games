-- Tamale — corn-husk-wrapped log tied at the ends, red sauce dot on top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local HUSK_TAN   = Color3.fromRGB(220, 195, 130)
local HUSK_PALE  = Color3.fromRGB(235, 220, 165)
local TWINE      = Color3.fromRGB(180, 150, 90)
local SAUCE_RED  = Color3.fromRGB(195, 55, 45)
local MASA_PEEK  = Color3.fromRGB(245, 230, 175)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Tamale", parent)

	-- Main husk-wrapped log (horizontal cylinder)
	local log = AB.part({
		size  = Vector3.new(5.2, 1.9, 1.9),
		color = HUSK_TAN,
		cf    = AB.offset(originCF, 0, 1.2, 0) * CFrame.Angles(0, math.rad(90), 0),
		shape = Enum.PartType.Cylinder,
		name  = "Husk",
	}, model)

	-- Husk striations (lighter strips along the length)
	for i, offset in {-0.5, 0.0, 0.5} do
		AB.part({
			size  = Vector3.new(4.6, 0.06, 0.4),
			color = HUSK_PALE,
			cf    = AB.offset(originCF, 0, 2.05, offset),
			name  = "Striation_" .. i,
		}, model)
	end

	-- Pinched twisted ends (smaller cones approximated by small cylinders)
	for i, x in {-2.8, 2.8} do
		AB.part({
			size  = Vector3.new(1.0, 0.9, 0.9),
			color = HUSK_PALE,
			cf    = AB.offset(originCF, x, 1.2, 0) * CFrame.Angles(0, math.rad(90), 0),
			shape = Enum.PartType.Cylinder,
			name  = "EndTwist_" .. i,
		}, model)
		-- Twine tie
		AB.part({
			size  = Vector3.new(0.2, 1.1, 1.1),
			color = TWINE,
			cf    = AB.offset(originCF, x - (i == 1 and -0.5 or 0.5) * 0, 1.2, 0)
			        * CFrame.Angles(0, math.rad(90), 0),
			shape = Enum.PartType.Cylinder,
			name  = "Twine_" .. i,
		}, model)
	end

	-- Masa peek through a partial fold (yellow strip visible)
	AB.part({
		size  = Vector3.new(2.2, 0.18, 1.4),
		color = MASA_PEEK,
		cf    = AB.offset(originCF, 0, 2.15, 0),
		name  = "MasaPeek",
	}, model)

	-- Red sauce dot on top
	AB.sphere(
		0.65,
		SAUCE_RED,
		AB.offset(originCF, 0, 2.4, 0),
		model,
		"SauceDot"
	)
	-- Small sauce drip
	AB.sphere(
		0.35,
		SAUCE_RED,
		AB.offset(originCF, 0.7, 2.3, 0.4),
		model,
		"SauceDrip"
	)

	AB.pivot(model, log)
	AB.weldAll(model)
	return model
end
