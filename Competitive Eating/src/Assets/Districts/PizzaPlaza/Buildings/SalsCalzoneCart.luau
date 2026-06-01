-- Sal's Calzone Cart — wheeled vendor cart with a neon "CALZONE" sign,
-- striped umbrella, calzones on display, and a steaming chimney.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CART_RED  = Color3.fromRGB(180, 50, 50)
local CART_CRM  = Color3.fromRGB(240, 220, 180)
local WHEEL_BLK = Color3.fromRGB(35, 30, 30)
local STEEL     = Color3.fromRGB(170, 170, 175)
local NEON_GRN  = Color3.fromRGB(80, 230, 130)
local CALZONE   = Color3.fromRGB(220, 180, 100)
local TRIM_GOLD = Color3.fromRGB(220, 180, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SalsCalzoneCart", parent)

	-- Cart body (rectangular box)
	AB.block(Vector3.new(10, 4, 5), CART_RED, AB.offset(originCF, 0, 3, 0), model, "CartBody")
	-- Cream stripes
	AB.block(Vector3.new(10.1, 0.6, 5.1), CART_CRM, AB.offset(originCF, 0, 4.6, 0), model, "StripeTop")
	AB.block(Vector3.new(10.1, 0.6, 5.1), CART_CRM, AB.offset(originCF, 0, 1.4, 0), model, "StripeBot")
	-- Gold trim line
	AB.block(Vector3.new(10.2, 0.2, 5.2), TRIM_GOLD, AB.offset(originCF, 0, 3, 0), model, "GoldTrim")

	-- Counter top (steel)
	AB.block(Vector3.new(10, 0.5, 5), STEEL, AB.offset(originCF, 0, 5.3, 0), model, "CounterTop")
	-- Counter rim
	AB.block(Vector3.new(10.2, 0.2, 5.2), TRIM_GOLD, AB.offset(originCF, 0, 5.7, 0), model, "CounterRim")

	-- Display calzones on the counter (3 half-circles)
	for i, x in {-3, 0, 3} do
		AB.sphere(1.6, CALZONE, AB.offset(originCF, x, 5.9, 0.5), model, "Calzone_" .. i)
		-- Browned top crust hint
		AB.sphere(1.65, Color3.fromRGB(180, 130, 70),
			AB.offset(originCF, x, 6.2, 0.5), model, "CalzoneCrust_" .. i)
	end
	-- Stack the second row
	for i, x in {-1.5, 1.5} do
		AB.sphere(1.4, CALZONE, AB.offset(originCF, x, 5.9, -1.5), model, "CalzoneBack_" .. i)
	end

	-- Wheels (4) — large cylinders on sides
	for i, sx in {-1, 1} do
		for j, sz in {-1, 1} do
			local wheel = AB.cylinder(2.4, 0.8, WHEEL_BLK,
				AB.offset(originCF, sx * 4.5, 1.5, sz * 1.8) * CFrame.Angles(math.rad(90), 0, 0),
				model, "Wheel_" .. i .. "_" .. j)
			-- Hub
			AB.sphere(0.6, STEEL,
				AB.offset(originCF, sx * 4.5, 1.5, sz * 1.8), model, "Hub_" .. i .. "_" .. j)
			-- Spokes
			for k = 0, 3 do
				AB.block(Vector3.new(0.18, 2.2, 0.18), TRIM_GOLD,
					AB.offset(originCF, sx * 4.5, 1.5, sz * 1.8) * CFrame.Angles(0, 0, math.rad(k * 45)),
					model, "Spoke_" .. i .. "_" .. j .. "_" .. k)
			end
		end
	end

	-- Push-handle bar
	AB.cylinder(0.4, 6, CART_CRM,
		AB.offset(originCF, -7.5, 5, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)),
		model, "PushBar")
	AB.cylinder(0.4, 3, CART_CRM,
		AB.offset(originCF, -5.5, 4, 0), model, "PushBarStem")

	-- Striped umbrella canopy
	for i = 1, 6 do
		local angle = (i - 1) / 6 * 2 * math.pi
		local c = (i % 2 == 0) and CART_RED or CART_CRM
		AB.wedge(Vector3.new(0.4, 2.5, 5), c,
			AB.offset(originCF, 0, 11, 0) * CFrame.Angles(0, angle, math.rad(-25)) * CFrame.new(0, 0.5, 2.5),
			model, "UmbWedge_" .. i)
	end
	AB.cylinder(0.4, 6, CART_CRM, AB.offset(originCF, 0, 8, 0), model, "UmbPole")
	AB.sphere(0.7, TRIM_GOLD, AB.offset(originCF, 0, 12, 0), model, "UmbFinial")

	-- Neon "CALZONE" sign on front of cart
	local sign = AB.block(Vector3.new(8, 1.6, 0.4), NEON_GRN, AB.offset(originCF, 0, 4.5, 2.7), model, "CalzoneNeon")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 2.5)
	-- Sign border
	AB.block(Vector3.new(8.4, 0.3, 0.5), TRIM_GOLD, AB.offset(originCF, 0, 5.4, 2.75), model, "SignTrimTop")
	AB.block(Vector3.new(8.4, 0.3, 0.5), TRIM_GOLD, AB.offset(originCF, 0, 3.6, 2.75), model, "SignTrimBot")

	-- Steaming chimney (a tube + glow)
	AB.cylinder(0.8, 2.5, STEEL, AB.offset(originCF, 3.5, 7, -1.5), model, "Chimney")
	local steam = AB.sphere(1.2, Color3.fromRGB(240, 240, 240),
		AB.offset(originCF, 3.5, 8.5, -1.5), model, "Steam1")
	steam.Transparency = 0.55
	local steam2 = AB.sphere(1.5, Color3.fromRGB(240, 240, 240),
		AB.offset(originCF, 3.7, 9.8, -1.7), model, "Steam2")
	steam2.Transparency = 0.7

	-- Cash drawer hint (small block)
	AB.block(Vector3.new(1.4, 0.6, 1), Color3.fromRGB(40, 40, 40), AB.offset(originCF, -3.5, 5.9, 1.5), model, "CashBox")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
