-- GingerbreadStorefronts — a row of 3 small gingerbread-house themed
-- shops connected as a strip. Each has cream icing trim, gumdrop
-- buttons on the door, and a peppermint stripe roof.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK    = Color3.fromRGB(255, 200, 214)
local DEEP    = Color3.fromRGB(232, 130, 165)
local CREAM   = Color3.fromRGB(255, 240, 220)
local BROWN   = Color3.fromRGB(92,  57,  36)
local LIGHTBR = Color3.fromRGB(168, 118, 78)
local GOLD    = Color3.fromRGB(212, 168, 82)
local MINT    = Color3.fromRGB(180, 230, 200)
local NEONPK  = Color3.fromRGB(255, 110, 170)
local GLASS   = Color3.fromRGB(210, 235, 250)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GingerbreadStorefronts", parent)

	local shopW = 14
	local rowLen = 3 * shopW

	-- Foundation
	AB.block(Vector3.new(rowLen, 0.5, 16), Color3.fromRGB(110, 100, 95),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	for s = 1, 3 do
		local x0 = -rowLen / 2 + (s - 1) * shopW + shopW / 2

		-- Gingerbread walls (light brown)
		AB.block(Vector3.new(shopW, 14, 1), LIGHTBR,
			AB.offset(originCF, x0, 7, 7.5), model, "Shop" .. s .. "_Front")
		AB.block(Vector3.new(shopW, 14, 1), LIGHTBR,
			AB.offset(originCF, x0, 7, -7.5), model, "Shop" .. s .. "_Back")
		AB.block(Vector3.new(1, 14, 16), LIGHTBR,
			AB.offset(originCF, x0 - shopW/2, 7, 0), model, "Shop" .. s .. "_Left")

		-- Icing trim along facade top
		AB.block(Vector3.new(shopW, 0.6, 1.1), CREAM,
			AB.offset(originCF, x0, 13.5, 7.55), model, "Shop" .. s .. "_TopTrim")
		-- Wavy icing drip (small spheres)
		for i = 1, 7 do
			local dx = -shopW/2 + (i - 0.5) * (shopW / 7)
			AB.sphere(1.4, CREAM,
				AB.offset(originCF, x0 + dx, 13.4, 7.6), model, "Shop" .. s .. "_Drip_" .. i)
		end

		-- Pitched roof (wedge + wedge)
		AB.wedge(Vector3.new(shopW, 4, 9), DEEP,
			AB.offset(originCF, x0, 16, 4.5) * CFrame.Angles(math.rad(-25), 0, 0),
			model, "Shop" .. s .. "_RoofF")
		AB.wedge(Vector3.new(shopW, 4, 9), DEEP,
			AB.offset(originCF, x0, 16, -4.5) * CFrame.Angles(math.rad(25), math.rad(180), 0),
			model, "Shop" .. s .. "_RoofB")
		-- Peppermint stripe roof — cream stripes layered on top
		for j = 1, 3 do
			AB.block(Vector3.new(shopW - 0.5, 0.5, 1.4), CREAM,
				AB.offset(originCF, x0, 15.5 + j * 0.4, (j - 2) * 2.5), model, "Shop" .. s .. "_Stripe_" .. j)
		end

		-- Center door
		local doorColor = (s == 2) and BROWN or DEEP
		AB.block(Vector3.new(3, 6, 0.4), doorColor,
			AB.offset(originCF, x0, 3, 8), model, "Shop" .. s .. "_Door")
		-- Gumdrop buttons on door (4)
		for i = 1, 4 do
			local dy = 1.5 + (i - 1) * 1
			AB.sphere(0.6, NEONPK, AB.offset(originCF, x0, dy, 8.3), model, "Shop" .. s .. "_Gumdrop_" .. i)
		end

		-- Small window on each side of door
		for k, dx in {-3.5, 3.5} do
			local g = AB.block(Vector3.new(2.4, 2.4, 0.2), GLASS,
				AB.offset(originCF, x0 + dx, 6, 8.05), model, "Shop" .. s .. "_Win_" .. k)
			g.Transparency = 0.4
			g.Material = Enum.Material.Glass
			-- Cross frame
			AB.block(Vector3.new(2.5, 0.2, 0.4), CREAM,
				AB.offset(originCF, x0 + dx, 6, 8.1), model, "Shop" .. s .. "_WinH_" .. k)
			AB.block(Vector3.new(0.2, 2.5, 0.4), CREAM,
				AB.offset(originCF, x0 + dx, 6, 8.1), model, "Shop" .. s .. "_WinV_" .. k)
		end

		-- Mint shutters (decoration) on side windows
		AB.block(Vector3.new(0.4, 2.6, 0.3), MINT,
			AB.offset(originCF, x0 - 5, 6, 8.2), model, "Shop" .. s .. "_ShutterLA")
		AB.block(Vector3.new(0.4, 2.6, 0.3), MINT,
			AB.offset(originCF, x0 - 2, 6, 8.2), model, "Shop" .. s .. "_ShutterLB")
		AB.block(Vector3.new(0.4, 2.6, 0.3), MINT,
			AB.offset(originCF, x0 + 2, 6, 8.2), model, "Shop" .. s .. "_ShutterRA")
		AB.block(Vector3.new(0.4, 2.6, 0.3), MINT,
			AB.offset(originCF, x0 + 5, 6, 8.2), model, "Shop" .. s .. "_ShutterRB")

		-- Small neon sign above door
		local sign = AB.block(Vector3.new(5, 1.4, 0.4), NEONPK,
			AB.offset(originCF, x0, 11, 8.1), model, "Shop" .. s .. "_Sign")
		AB.neon(sign)
		AB.glow(sign, sign.Color, 2)

		-- Roof apex finial (candy)
		AB.sphere(1.2, NEONPK, AB.offset(originCF, x0, 18.5, 0), model, "Shop" .. s .. "_Finial")
		AB.cylinder(0.4, 1, GOLD, AB.offset(originCF, x0, 17.5, 0), model, "Shop" .. s .. "_FinialStem")
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
