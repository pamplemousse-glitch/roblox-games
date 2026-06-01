-- Mini Vespa — small Italian scooter parked on the street. Body, seat,
-- headlight, mirrors, wheels, kickstand.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VESPA_RED = Color3.fromRGB(220, 60, 60)
local CHROME    = Color3.fromRGB(220, 220, 230)
local BLACK     = Color3.fromRGB(35, 30, 30)
local LEATHER   = Color3.fromRGB(60, 45, 40)
local GLASS_Y   = Color3.fromRGB(255, 230, 180)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MiniVespa", parent)

	-- Body (rounded back fairing)
	AB.sphere(3, VESPA_RED, AB.offset(originCF, 0, 2, -1), model, "RearBody")
	AB.block(Vector3.new(2.6, 2.5, 3), VESPA_RED, AB.offset(originCF, 0, 2.2, -1), model, "BodyBlock")
	-- Front fairing / leg shield
	AB.block(Vector3.new(2.6, 3.5, 0.8), VESPA_RED, AB.offset(originCF, 0, 3, 1.4), model, "LegShield")
	AB.block(Vector3.new(2.4, 1.5, 1.8), VESPA_RED, AB.offset(originCF, 0, 2, 1.4), model, "FrontBody")

	-- Seat (leather)
	AB.block(Vector3.new(2, 0.5, 2.4), LEATHER, AB.offset(originCF, 0, 3.6, -1), model, "Seat")
	AB.block(Vector3.new(2, 0.4, 0.6), LEATHER, AB.offset(originCF, 0, 3.9, 0.3), model, "SeatFrontHump")

	-- Handlebars (chrome)
	AB.cylinder(0.3, 3, CHROME,
		AB.offset(originCF, 0, 5, 1.4) * CFrame.Angles(0, 0, math.rad(90)), model, "Handlebar")
	AB.sphere(0.4, BLACK, AB.offset(originCF, -1.5, 5, 1.4), model, "GripL")
	AB.sphere(0.4, BLACK, AB.offset(originCF,  1.5, 5, 1.4), model, "GripR")
	-- Mirrors
	AB.cylinder(0.2, 1.2, CHROME, AB.offset(originCF, -1.6, 5.7, 1.4), model, "MirrorStemL")
	AB.cylinder(0.2, 1.2, CHROME, AB.offset(originCF,  1.6, 5.7, 1.4), model, "MirrorStemR")
	AB.sphere(0.7, CHROME, AB.offset(originCF, -1.8, 6.3, 1.4), model, "MirrorL")
	AB.sphere(0.7, CHROME, AB.offset(originCF,  1.8, 6.3, 1.4), model, "MirrorR")

	-- Front column
	AB.cylinder(0.4, 2.5, CHROME, AB.offset(originCF, 0, 4, 1.4), model, "SteerCol")

	-- Headlight
	local hl = AB.sphere(1, GLASS_Y, AB.offset(originCF, 0, 3.6, 2), model, "Headlight")
	AB.neon(hl)
	AB.glow(hl, hl.Color, 1.5)
	-- Headlight ring
	AB.cylinder(1.2, 0.3, CHROME, AB.offset(originCF, 0, 3.6, 2.1) * CFrame.Angles(0, 0, math.rad(0)), model, "HLRing")

	-- Wheels (front + back)
	for i, sz in {1.5, -2.5} do
		AB.cylinder(2, 0.6, BLACK,
			AB.offset(originCF, 0, 1, sz) * CFrame.Angles(math.rad(90), 0, 0), model, "Wheel_" .. i)
		AB.cylinder(0.8, 0.7, CHROME,
			AB.offset(originCF, 0, 1, sz) * CFrame.Angles(math.rad(90), 0, 0), model, "Rim_" .. i)
		-- Spokes
		for k = 0, 3 do
			AB.block(Vector3.new(0.1, 1.8, 0.1), CHROME,
				AB.offset(originCF, 0, 1, sz) * CFrame.Angles(math.rad(90), math.rad(k * 45), 0), model, "Spoke_" .. i .. "_" .. k)
		end
	end

	-- Kickstand
	AB.block(Vector3.new(0.2, 1.6, 0.2), BLACK,
		AB.offset(originCF, 1.2, 0.8, -1.5) * CFrame.Angles(math.rad(-15), 0, 0), model, "Kickstand")

	-- Italian flag sticker on side
	AB.block(Vector3.new(0.3, 0.4, 0.3), Color3.fromRGB(80, 140, 60),
		AB.offset(originCF, 1.35, 2.5, -0.5), model, "FlagG")
	AB.block(Vector3.new(0.3, 0.4, 0.3), Color3.fromRGB(245, 240, 230),
		AB.offset(originCF, 1.35, 2.5, -0.2), model, "FlagW")
	AB.block(Vector3.new(0.3, 0.4, 0.3), Color3.fromRGB(200, 40, 40),
		AB.offset(originCF, 1.35, 2.5,  0.1), model, "FlagR")

	-- License plate
	AB.block(Vector3.new(1.4, 0.6, 0.1), Color3.fromRGB(245, 240, 230),
		AB.offset(originCF, 0, 1.8, -3), model, "Plate")

	-- Exhaust pipe
	AB.cylinder(0.4, 2, CHROME,
		AB.offset(originCF, 1.3, 1.3, -1.5) * CFrame.Angles(0, 0, math.rad(90)), model, "Exhaust")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
