-- IceCreamPushcart — pastel pink pushcart with a giant ice-cream cone
-- mounted on top and a wavy umbrella canopy in cream and mint.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CREAM  = Color3.fromRGB(255, 240, 220)
local BROWN  = Color3.fromRGB(92,  57,  36)
local GOLD   = Color3.fromRGB(212, 168, 82)
local MINT   = Color3.fromRGB(180, 230, 200)
local NEONPK = Color3.fromRGB(255, 110, 170)
local DOUGH  = Color3.fromRGB(220, 170, 110)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("IceCreamPushcart", parent)

	-- Cart body (pink)
	local body = AB.block(Vector3.new(5, 4, 3), PINK,
		AB.offset(originCF, 0, 2.5, 0), model, "CartBody")
	-- Wainscot stripe
	AB.block(Vector3.new(5.1, 1, 3.1), DEEP,
		AB.offset(originCF, 0, 1.5, 0), model, "Wainscot")
	-- Gold rim
	AB.block(Vector3.new(5.2, 0.3, 3.2), GOLD, AB.offset(originCF, 0, 4.55, 0), model, "TopRim")

	-- Counter top
	AB.block(Vector3.new(5, 0.4, 3.4), CREAM,
		AB.offset(originCF, 0, 4.8, 0), model, "CounterTop")

	-- Push handle
	AB.cylinder(0.4, 2, GOLD,
		AB.offset(originCF, 2.5, 4.5, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)), model, "HandleArm")
	AB.block(Vector3.new(0.4, 1, 2), GOLD,
		AB.offset(originCF, 3.5, 4.5, 0), model, "HandleGrip")

	-- Wheels (large)
	AB.cylinder(2.4, 0.4, BROWN, AB.offset(originCF, -1.5, 1.2, -1.6), model, "WheelL")
	AB.cylinder(2.4, 0.4, BROWN, AB.offset(originCF, -1.5, 1.2, 1.6), model, "WheelR")
	AB.cylinder(1.6, 0.4, BROWN, AB.offset(originCF, 1.8, 0.8, -1.6), model, "WheelLB")
	AB.cylinder(1.6, 0.4, BROWN, AB.offset(originCF, 1.8, 0.8, 1.6), model, "WheelRB")

	-- Giant cone on top
	-- Cone (inverted)
	AB.wedge(Vector3.new(2.6, 3, 2.6), DOUGH,
		AB.offset(originCF, -1, 6.7, 0), model, "ConeA")
	AB.wedge(Vector3.new(2.6, 3, 2.6), DOUGH,
		AB.offset(originCF, -1, 6.7, 0) * CFrame.Angles(0, math.rad(180), 0), model, "ConeB")
	-- Cross-hatch on cone
	for i = 1, 4 do
		local cy = 5.5 + (i - 1) * 0.6
		AB.block(Vector3.new(2.5 - i * 0.4, 0.1, 0.1), BROWN,
			AB.offset(originCF, -1, cy, 0), model, "ConeHatch_" .. i)
	end

	-- Ice cream scoops (pink, cream, mint stacked)
	AB.sphere(2, PINK,  AB.offset(originCF, -1, 8.8, 0), model, "ScoopPink")
	AB.sphere(1.7, CREAM, AB.offset(originCF, -1, 10.2, 0), model, "ScoopCream")
	AB.sphere(1.5, MINT,  AB.offset(originCF, -1, 11.4, 0), model, "ScoopMint")
	-- Cherry
	AB.sphere(0.5, NEONPK, AB.offset(originCF, -1, 12.4, 0), model, "Cherry")
	-- Sprinkles
	for i = 1, 6 do
		local a = (i / 6) * math.pi * 2
		AB.block(Vector3.new(0.15, 0.5, 0.15), NEONPK,
			AB.offset(originCF, -1 + math.cos(a), 9.4, math.sin(a)),
			model, "Sprinkle_" .. i)
	end

	-- Cream + mint stripe umbrella
	for j = 1, 8 do
		local angle = (j / 8) * math.pi * 2
		local col = (j % 2 == 0) and CREAM or MINT
		AB.wedge(Vector3.new(0.2, 0.3, 4), col,
			AB.offset(originCF, -1, 14, 0) * CFrame.Angles(0, angle, math.rad(20)),
			model, "Umbrella_" .. j)
	end
	-- Umbrella pole top
	AB.cylinder(0.3, 2, GOLD, AB.offset(originCF, -1, 13, 0), model, "UmbrellaPole")
	AB.sphere(0.5, GOLD, AB.offset(originCF, -1, 14, 0), model, "UmbrellaCap")

	-- Small "ICE CREAM" sign
	local sign = AB.block(Vector3.new(3, 0.9, 0.3), NEONPK,
		AB.offset(originCF, 0, 5.6, 1.6), model, "Sign")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 1.5)

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
