-- BBQ Grill — classic kettle grill (round body on tripod legs with side wheels)
-- and a domed lid. Glowing charcoal inside.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local KETTLE_BLACK = Color3.fromRGB(45, 38, 38)
local LID_BLACK    = Color3.fromRGB(28, 25, 25)
local STEEL        = Color3.fromRGB(130, 130, 135)
local DARK_WOOD    = Color3.fromRGB(70, 45, 22)
local TIRE         = Color3.fromRGB(28, 28, 30)
local EMBER        = Color3.fromRGB(255, 128, 48)
local CHARCOAL     = Color3.fromRGB(35, 28, 25)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BBQGrill", parent)

	-- Kettle body (lower hemisphere — use a flattened cylinder + sphere top)
	local body = AB.sphere(3.6, KETTLE_BLACK, AB.offset(originCF, 0, 3, 0), model, "Body")
	-- Ring band around middle
	AB.cylinder(3.7, 0.3, STEEL, AB.offset(originCF, 0, 3, 0), model, "Band")

	-- Charcoal bed inside (visible from above when lid is open)
	AB.cylinder(2.6, 0.4, CHARCOAL, AB.offset(originCF, 0, 3.6, 0), model, "Charcoal")
	-- Ember glow
	for i, p in {Vector3.new(0.6, 3.8, 0.3), Vector3.new(-0.5, 3.8, -0.5), Vector3.new(0.3, 3.8, -0.7)} do
		local em = AB.sphere(0.5, EMBER, originCF * CFrame.new(p), model, "Ember_" .. i)
		AB.neon(em)
		AB.glow(em, EMBER, 2)
	end

	-- Dome lid (open / tilted back)
	local lid = AB.sphere(3.6, LID_BLACK, AB.offset(originCF, 0, 4.6, -0.8), model, "Lid")
	lid.CFrame = lid.CFrame * CFrame.Angles(math.rad(-25), 0, 0)
	-- Lid handle
	AB.block(Vector3.new(0.4, 0.4, 1), DARK_WOOD, AB.offset(originCF, 0, 6, -1.2), model, "LidHandle")
	-- Lid vent (small disc on top)
	AB.cylinder(0.8, 0.2, STEEL, AB.offset(originCF, 0, 6.3, -0.4), model, "Vent")

	-- Tripod legs (3)
	for i = 1, 3 do
		local angle = (i / 3) * math.pi * 2
		local x = math.cos(angle) * 1.6
		local z = math.sin(angle) * 1.6
		local leg = AB.block(Vector3.new(0.3, 3.2, 0.3), STEEL, AB.offset(originCF, x, 1.6, z), model, "Leg_" .. i)
		leg.CFrame = leg.CFrame * CFrame.Angles(math.rad(z * 8), 0, math.rad(-x * 8))
	end

	-- Two side wheels (on rear legs)
	AB.cylinder(1.0, 0.5, TIRE, AB.offset(originCF, -1.6, 0.5, -1.3) * CFrame.Angles(0, 0, math.rad(90)), model, "WheelL")
	AB.cylinder(1.0, 0.5, TIRE, AB.offset(originCF,  1.6, 0.5, -1.3) * CFrame.Angles(0, 0, math.rad(90)), model, "WheelR")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
