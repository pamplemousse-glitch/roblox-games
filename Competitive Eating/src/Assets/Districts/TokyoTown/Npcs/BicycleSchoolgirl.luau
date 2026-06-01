-- Bicycle Schoolgirl — schoolgirl perched on a city bicycle (with basket).
-- A single Model that includes both rider + bike, intended as a stationary
-- scene piece (not a dynamic mover).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "BicycleGirl"
local SKIN       = Color3.fromRGB(255, 220, 180)
local SAILOR_WHT = Color3.fromRGB(245, 240, 230)
local SKIRT_NAVY = Color3.fromRGB(35, 45, 80)
local HAIR_DARK  = Color3.fromRGB(40, 30, 30)
local BIKE_BLUE  = Color3.fromRGB(80, 130, 180)
local IRON_BLACK = Color3.fromRGB(45, 40, 40)
local METAL_GREY = Color3.fromRGB(110, 110, 120)
local BASKET     = Color3.fromRGB(180, 150, 100)
local BOOK_RED   = Color3.fromRGB(190, 60, 60)
local TIE_RED    = Color3.fromRGB(200, 50, 50)
local NAVY       = Color3.fromRGB(50, 60, 100)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- ── Bicycle ──
	-- Two wheels
	for i, dx in {-1.6, 1.6} do
		AB.cylinder(1.8, 0.2, IRON_BLACK,
			AB.offset(originCF, dx, -1.9, 0) * CFrame.Angles(0, math.rad(90), 0),
			model, "Wheel_" .. i)
		AB.cylinder(0.4, 0.25, METAL_GREY,
			AB.offset(originCF, dx, -1.9, 0) * CFrame.Angles(0, math.rad(90), 0),
			model, "Hub_" .. i)
	end
	-- Frame top tube
	AB.cylinder(0.2, 3.2, BIKE_BLUE,
		AB.offset(originCF, 0, -0.7, 0) * CFrame.Angles(0, 0, math.rad(90)),
		model, "BikeFrame")
	-- Seat post
	AB.cylinder(0.15, 1.2, BIKE_BLUE,
		AB.offset(originCF, 1.2, -0.1, 0), model, "SeatPost")
	-- Bike seat (covered by rider)
	AB.block(Vector3.new(0.7, 0.2, 0.4), IRON_BLACK,
		AB.offset(originCF, 1.2, 0.5, 0), model, "BikeSeat")
	-- Handlebars
	AB.cylinder(0.15, 1.4, IRON_BLACK,
		AB.offset(originCF, -1.4, -0.2, 0) * CFrame.Angles(math.rad(90), 0, 0),
		model, "Handlebars")
	-- Front basket
	AB.block(Vector3.new(1.4, 1, 0.8), BASKET,
		AB.offset(originCF, -1.8, 0.3, 0), model, "FrontBasket")
	AB.block(Vector3.new(1.45, 0.05, 0.85), Color3.fromRGB(140, 110, 70),
		AB.offset(originCF, -1.8, 0.8, 0), model, "BasketRim")
	-- Schoolbag inside the basket
	AB.block(Vector3.new(1.1, 0.8, 0.6), BOOK_RED,
		AB.offset(originCF, -1.8, 0.6, 0), model, "Bag")
	AB.block(Vector3.new(0.4, 0.18, 0.65), Color3.fromRGB(80, 30, 30),
		AB.offset(originCF, -1.8, 1.0, 0), model, "BagStrap")

	-- ── Rider (seated) ──
	-- Torso
	local torso = AB.part({
		size = Vector3.new(2.0, 2.2, 1.0), color = SAILOR_WHT,
		cf = AB.offset(originCF, 1.0, 1.8, 0) * CFrame.Angles(math.rad(15), 0, 0),
		canCollide = false, name = "Torso",
	}, model)
	-- Navy sailor collar
	AB.part({
		size = Vector3.new(2.05, 0.3, 1.05), color = NAVY,
		cf = AB.offset(originCF, 1.0, 2.6, 0) * CFrame.Angles(math.rad(15), 0, 0),
		canCollide = false, name = "Collar",
	}, model)
	-- Red ribbon
	AB.part({
		size = Vector3.new(0.6, 0.3, 0.05), color = TIE_RED,
		cf = AB.offset(originCF, 1.0, 2.4, 0.55) * CFrame.Angles(math.rad(15), 0, 0),
		canCollide = false, name = "Ribbon",
	}, model)
	-- Skirt (over the seat)
	AB.part({
		size = Vector3.new(2.4, 1.2, 1.6), color = SKIRT_NAVY,
		cf = AB.offset(originCF, 1.2, 0.6, 0), canCollide = false, name = "Skirt",
	}, model)
	-- Legs (bent at angle, reaching toward pedals)
	for _, side in {-0.5, 0.5} do
		AB.block(Vector3.new(0.6, 1.4, 0.6), SKIN,
			AB.offset(originCF, 0, -0.4, side) * CFrame.Angles(math.rad(-20), 0, 0),
			model, "Leg_" .. tostring(side))
	end

	-- Head
	local head = AB.part({
		size = Vector3.new(1.6, 1.6, 1.6), color = SKIN,
		cf = AB.offset(originCF, 0.9, 4, 0.2), shape = Enum.PartType.Ball,
		canCollide = false, name = "Head",
	}, model)
	-- Long hair
	AB.part({
		size = Vector3.new(1.7, 1.4, 1.7), color = HAIR_DARK,
		cf = AB.offset(originCF, 0.9, 4.4, 0.2), canCollide = false, name = "Hair",
	}, model)

	-- Arms forward to handlebars
	for _, side in {-1, 1} do
		AB.part({
			size = Vector3.new(0.65, 0.65, 2), color = SAILOR_WHT,
			cf = AB.offset(originCF, -0.2, 1.5, side * 0.4) * CFrame.Angles(0, math.rad(side * 12), math.rad(-15)),
			canCollide = false, name = "Arm_" .. (side == -1 and "L" or "R"),
		}, model)
	end

	AB.billboard(head, NAME, Vector2.new(220, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
