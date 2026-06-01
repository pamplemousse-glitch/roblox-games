-- Cafe Umbrella Small — standalone striped umbrella over a small base,
-- the kind that anchors a sidewalk corner.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STRIPE_R = Color3.fromRGB(200, 40, 40)
local STRIPE_C = Color3.fromRGB(240, 220, 180)
local POLE_DK  = Color3.fromRGB(80, 50, 30)
local BASE_STN = Color3.fromRGB(140, 130, 120)
local GOLD     = Color3.fromRGB(220, 180, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CafeUmbrellaSmall", parent)

	-- Stone base (weighted)
	AB.cylinder(2.2, 1, BASE_STN, AB.offset(originCF, 0, 0.5, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Base")
	-- Base ring (decorative)
	AB.cylinder(2.4, 0.2, POLE_DK, AB.offset(originCF, 0, 1.1, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "BaseRing")

	-- Pole
	AB.cylinder(0.35, 9, POLE_DK, AB.offset(originCF, 0, 5.5, 0), model, "Pole")

	-- Striped canopy (6 alternating wedges)
	for i = 1, 6 do
		local angle = (i - 1) / 6 * 2 * math.pi
		local c = (i % 2 == 0) and STRIPE_R or STRIPE_C
		AB.wedge(Vector3.new(0.3, 2, 4), c,
			AB.offset(originCF, 0, 9.5, 0) * CFrame.Angles(0, angle, math.rad(-25)) * CFrame.new(0, 0.4, 2),
			model, "Wedge_" .. i)
	end

	-- Scallop edge
	for i = 0, 5 do
		local angle = i / 6 * 2 * math.pi
		AB.wedge(Vector3.new(2, 0.4, 0.5), STRIPE_R,
			AB.offset(originCF, 3.5 * math.cos(angle), 8.2, 3.5 * math.sin(angle)) * CFrame.Angles(math.rad(180), -angle, 0),
			model, "Scallop_" .. i)
	end

	-- Finial on top
	AB.sphere(0.4, GOLD, AB.offset(originCF, 0, 10.6, 0), model, "Finial")
	AB.cylinder(0.15, 0.5, GOLD, AB.offset(originCF, 0, 11, 0), model, "FinialSpike")

	-- Crank handle on pole
	AB.cylinder(0.15, 0.6, GOLD,
		AB.offset(originCF, 0.4, 3, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Crank")
	AB.sphere(0.2, POLE_DK, AB.offset(originCF, 0.6, 3, 0), model, "CrankBall")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
