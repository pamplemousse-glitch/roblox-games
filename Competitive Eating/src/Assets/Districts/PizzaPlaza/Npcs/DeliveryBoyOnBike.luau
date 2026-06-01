-- Delivery Boy on Bike — kid on a bicycle with a stack of pizza boxes
-- balanced on the handlebar basket. Mid-ride pose.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Paolo"
local SKIN    = Color3.fromRGB(240, 210, 175)
local SHIRT_R = Color3.fromRGB(200, 40, 40)
local SHIRT_W = Color3.fromRGB(245, 240, 230)
local PANTS   = Color3.fromRGB(40, 70, 100)
local HAIR    = Color3.fromRGB(60, 40, 35)
local CAP_R   = Color3.fromRGB(180, 30, 40)
local SHOE    = Color3.fromRGB(245, 240, 230)
local BIKE_R  = Color3.fromRGB(180, 30, 40)
local TIRE_BL = Color3.fromRGB(35, 30, 30)
local CHROME  = Color3.fromRGB(220, 220, 230)
local BASKET  = Color3.fromRGB(190, 140, 80)
local CARD    = Color3.fromRGB(170, 130, 80)
local DK_CARD = Color3.fromRGB(130, 100, 65)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Bike body
	-- Front wheel
	AB.cylinder(2, 0.4, TIRE_BL,
		AB.offset(originCF, 0, -2.5, 2.5) * CFrame.Angles(math.rad(90), 0, 0), model, "FrontTire")
	AB.cylinder(1.6, 0.5, CHROME,
		AB.offset(originCF, 0, -2.5, 2.5) * CFrame.Angles(math.rad(90), 0, 0), model, "FrontRim")
	-- Front wheel spokes
	for k = 0, 5 do
		AB.block(Vector3.new(0.06, 1.4, 0.06), CHROME,
			AB.offset(originCF, 0, -2.5, 2.5) * CFrame.Angles(math.rad(90), math.rad(k * 30), 0), model, "FSpoke_" .. k)
	end
	-- Back wheel
	AB.cylinder(2, 0.4, TIRE_BL,
		AB.offset(originCF, 0, -2.5, -2.5) * CFrame.Angles(math.rad(90), 0, 0), model, "BackTire")
	AB.cylinder(1.6, 0.5, CHROME,
		AB.offset(originCF, 0, -2.5, -2.5) * CFrame.Angles(math.rad(90), 0, 0), model, "BackRim")
	for k = 0, 5 do
		AB.block(Vector3.new(0.06, 1.4, 0.06), CHROME,
			AB.offset(originCF, 0, -2.5, -2.5) * CFrame.Angles(math.rad(90), math.rad(k * 30), 0), model, "BSpoke_" .. k)
	end
	-- Frame (3 tubes)
	AB.cylinder(0.25, 5, BIKE_R,
		AB.offset(originCF, 0, -1.5, 0) * CFrame.Angles(math.rad(90), 0, 0), model, "TopTube")
	AB.cylinder(0.25, 4, BIKE_R,
		AB.offset(originCF, 0, -2, 1) * CFrame.Angles(math.rad(60), 0, 0), model, "DownTube")
	AB.cylinder(0.25, 2.5, BIKE_R, AB.offset(originCF, 0, -1, -1.5), model, "SeatTube")
	-- Pedal crank
	AB.sphere(0.4, CHROME, AB.offset(originCF, 0, -2.5, 0), model, "CrankBox")
	AB.block(Vector3.new(0.5, 0.5, 0.15), Color3.fromRGB(40, 40, 50),
		AB.offset(originCF, 0, -2.5, 0.9), model, "PedalF")
	AB.block(Vector3.new(0.5, 0.5, 0.15), Color3.fromRGB(40, 40, 50),
		AB.offset(originCF, 0, -2.5, -0.9), model, "PedalB")
	-- Chain
	AB.block(Vector3.new(0.1, 0.1, 2.5), Color3.fromRGB(60, 60, 70),
		AB.offset(originCF, 0, -2.6, -1.5), model, "Chain")
	-- Handlebars
	AB.cylinder(0.2, 2, CHROME,
		AB.offset(originCF, 0, 1, 2.4) * CFrame.Angles(0, 0, math.rad(90)), model, "Handlebar")
	AB.cylinder(0.2, 2, CHROME, AB.offset(originCF, 0, 0, 2.4), model, "Stem")
	AB.sphere(0.25, Color3.fromRGB(35, 30, 30), AB.offset(originCF, -1, 1, 2.4), model, "GripL")
	AB.sphere(0.25, Color3.fromRGB(35, 30, 30), AB.offset(originCF, 1, 1, 2.4), model, "GripR")
	-- Bell on handlebar
	AB.cylinder(0.3, 0.4, CHROME,
		AB.offset(originCF, 0.8, 1.4, 2.4), model, "Bell")
	-- Seat
	AB.block(Vector3.new(0.5, 0.3, 1), Color3.fromRGB(40, 30, 25), AB.offset(originCF, 0, 0.5, -1.5), model, "Seat")

	-- Front basket
	AB.block(Vector3.new(2, 1.4, 1.8), BASKET, AB.offset(originCF, 0, 1.5, 3.5), model, "Basket")
	AB.block(Vector3.new(2.2, 0.2, 2), Color3.fromRGB(130, 90, 50),
		AB.offset(originCF, 0, 2.2, 3.5), model, "BasketRim")
	-- Pizza box stack in basket
	for i = 1, 4 do
		local y = 2.5 + (i - 1) * 0.5
		AB.block(Vector3.new(1.8, 0.45, 1.6), CARD, AB.offset(originCF, 0, y, 3.5), model, "PizzaBox_" .. i)
		AB.block(Vector3.new(1.85, 0.05, 1.65), DK_CARD, AB.offset(originCF, 0, y + 0.22, 3.5), model, "PizzaBoxEdge_" .. i)
		AB.block(Vector3.new(0.9, 0.2, 0.05), SHIRT_R, AB.offset(originCF, 0, y, 4.3), model, "PizzaBoxLogo_" .. i)
	end

	-- Rider torso (leaning forward in pedaling pose)
	local torso = AB.part({size=Vector3.new(2.3, 2.6, 1.1), color=SHIRT_R,
		cf=AB.offset(originCF, 0, 1.7, -0.5) * CFrame.Angles(math.rad(-20), 0, 0), canCollide=false, name="Torso"}, model)
	-- White stripe across chest
	AB.block(Vector3.new(2.4, 0.4, 1.15), SHIRT_W,
		AB.offset(originCF, 0, 1.7, -0.5) * CFrame.Angles(math.rad(-20), 0, 0), model, "ChestStripe")
	-- "PIZZA" patch (small white block on the front)
	AB.block(Vector3.new(1.2, 0.6, 0.1), SHIRT_W,
		AB.offset(originCF, 0, 1.7, 0.2) * CFrame.Angles(math.rad(-20), 0, 0), model, "PizzaPatch")
	-- Pants
	AB.part({size=Vector3.new(2.3, 0.4, 1.1), color=PANTS,
		cf=AB.offset(originCF, 0, 0.3, -0.8), canCollide=false, name="Belt"}, model)
	-- Bent legs (pedaling)
	AB.cylinder(0.4, 2, PANTS,
		AB.offset(originCF, -0.6, -1, -0.5) * CFrame.Angles(math.rad(30), 0, 0), model, "LegL")
	AB.cylinder(0.4, 2, PANTS,
		AB.offset(originCF, 0.6, -1, -1) * CFrame.Angles(math.rad(-30), 0, 0), model, "LegR")
	-- Shoes on pedals
	AB.part({size=Vector3.new(0.8, 0.4, 1), color=SHOE,
		cf=AB.offset(originCF, 0, -2.5, 0.9), canCollide=false, name="ShoeFwd"}, model)
	AB.part({size=Vector3.new(0.8, 0.4, 1), color=SHOE,
		cf=AB.offset(originCF, 0, -2.5, -0.9), canCollide=false, name="ShoeBack"}, model)

	-- Head
	local head = AB.part({size=Vector3.new(1.8, 1.8, 1.8), color=SKIN,
		cf=AB.offset(originCF, 0, 3.3, 0) * CFrame.Angles(math.rad(-20), 0, 0), shape=Enum.PartType.Ball, canCollide=false, name="Head"}, model)
	-- Hair tousled
	AB.sphere(1, HAIR, AB.offset(originCF, 0, 3.8, 0) * CFrame.Angles(math.rad(-20), 0, 0), model, "Hair")
	-- Cap (delivery cap, red)
	AB.cylinder(1.2, 0.5, CAP_R,
		AB.offset(originCF, 0, 4.1, -0.2) * CFrame.Angles(math.rad(-20), 0, 0) * CFrame.Angles(0, 0, math.rad(90)),
		model, "CapBody")
	AB.wedge(Vector3.new(0.3, 0.5, 1.4), CAP_R,
		AB.offset(originCF, 0, 4.05, 0.8) * CFrame.Angles(math.rad(-20), 0, 0) * CFrame.Angles(math.rad(90), 0, 0),
		model, "CapBrim")
	-- Excited eyes (wide)
	AB.sphere(0.22, Color3.fromRGB(245, 240, 230),
		AB.offset(originCF, -0.4, 3.3, 0.8) * CFrame.Angles(math.rad(-20), 0, 0), model, "EyeWhiteL")
	AB.sphere(0.22, Color3.fromRGB(245, 240, 230),
		AB.offset(originCF, 0.4, 3.3, 0.8) * CFrame.Angles(math.rad(-20), 0, 0), model, "EyeWhiteR")
	AB.sphere(0.12, Color3.fromRGB(30, 25, 20),
		AB.offset(originCF, -0.4, 3.3, 0.9) * CFrame.Angles(math.rad(-20), 0, 0), model, "PupilL")
	AB.sphere(0.12, Color3.fromRGB(30, 25, 20),
		AB.offset(originCF, 0.4, 3.3, 0.9) * CFrame.Angles(math.rad(-20), 0, 0), model, "PupilR")
	-- Big determined grin
	AB.block(Vector3.new(0.7, 0.15, 0.1), Color3.fromRGB(140, 70, 70),
		AB.offset(originCF, 0, 2.7, 0.85) * CFrame.Angles(math.rad(-20), 0, 0), model, "Grin")

	-- Arms gripping handlebars
	AB.part({size=Vector3.new(0.7, 2.2, 0.7), color=SHIRT_R,
		cf=AB.offset(originCF, -1, 1.8, 1) * CFrame.Angles(math.rad(-60), 0, 0), canCollide=false, name="ArmL"}, model)
	AB.part({size=Vector3.new(0.7, 2.2, 0.7), color=SHIRT_R,
		cf=AB.offset(originCF, 1, 1.8, 1) * CFrame.Angles(math.rad(-60), 0, 0), canCollide=false, name="ArmR"}, model)
	-- Hands on handlebars
	AB.sphere(0.4, SKIN, AB.offset(originCF, -1, 1, 2.4), model, "HandL")
	AB.sphere(0.4, SKIN, AB.offset(originCF, 1, 1, 2.4), model, "HandR")

	-- Motion lines / wind streaks (light blue blocks behind)
	for i = 1, 4 do
		local streak = AB.block(Vector3.new(2, 0.06, 0.05), Color3.fromRGB(180, 220, 240),
			AB.offset(originCF, (i - 2.5) * 0.7, 1 + i * 0.4, -3.5), model, "WindStreak_" .. i)
		streak.Transparency = 0.4
	end

	AB.billboard(head, NAME, Vector2.new(200, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
