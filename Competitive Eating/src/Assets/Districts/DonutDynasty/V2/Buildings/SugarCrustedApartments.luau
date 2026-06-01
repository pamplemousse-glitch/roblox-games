-- SugarCrustedApartments — a tall cream-colored apartment block with a
-- sparkly "sugar crust" texture along the top edge, multiple windows lit
-- with warm pink glow, and a small ground-floor cafe entrance.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK    = Color3.fromRGB(255, 200, 214)
local DEEP    = Color3.fromRGB(232, 130, 165)
local CREAM   = Color3.fromRGB(255, 240, 220)
local LIGHTCR = Color3.fromRGB(250, 245, 230)
local BROWN   = Color3.fromRGB(92,  57,  36)
local GOLD    = Color3.fromRGB(212, 168, 82)
local MINT    = Color3.fromRGB(180, 230, 200)
local NEONPK  = Color3.fromRGB(255, 110, 170)
local GLASS   = Color3.fromRGB(210, 235, 250)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SugarCrustedApartments", parent)

	local W, H, D = 28, 36, 18

	-- Foundation
	AB.block(Vector3.new(W + 2, 0.5, D + 2), Color3.fromRGB(110, 100, 95),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Walls (cream)
	AB.block(Vector3.new(W, H, 1),  CREAM, AB.offset(originCF, 0,    H/2, -D/2), model, "BackWall")
	AB.block(Vector3.new(1,  H, D), CREAM, AB.offset(originCF, -W/2, H/2,  0),   model, "LeftWall")
	AB.block(Vector3.new(1,  H, D), CREAM, AB.offset(originCF,  W/2, H/2,  0),   model, "RightWall")
	AB.block(Vector3.new(W, H, 1),  CREAM, AB.offset(originCF, 0,    H/2,  D/2), model, "FrontWall")

	-- 4 floors of 5 windows each (front-facing)
	for floor = 1, 4 do
		local y = 7 + (floor - 1) * 7
		for i = 1, 5 do
			local x = -W/2 + 4 + (i - 1) * 5
			-- Window frame
			AB.block(Vector3.new(3, 4, 0.3), BROWN,
				AB.offset(originCF, x, y, D/2 + 0.1), model, "FrameF" .. floor .. "_" .. i)
			-- Glass (lit warm)
			local g = AB.block(Vector3.new(2.6, 3.6, 0.2), NEONPK,
				AB.offset(originCF, x, y, D/2 + 0.2), model, "WinF" .. floor .. "_" .. i)
			AB.neon(g)
			g.Transparency = 0.4
			-- Sill
			AB.block(Vector3.new(3.4, 0.4, 0.5), GOLD,
				AB.offset(originCF, x, y - 2, D/2 + 0.3), model, "SillF" .. floor .. "_" .. i)
			-- Window box (mint planter every 2nd floor)
			if floor % 2 == 0 then
				AB.block(Vector3.new(3, 0.7, 1), MINT,
					AB.offset(originCF, x, y - 2.3, D/2 + 0.9), model, "Box" .. floor .. "_" .. i)
				AB.sphere(0.7, DEEP, AB.offset(originCF, x - 0.6, y - 1.8, D/2 + 1.2), model, "BoxFlowerL_" .. floor .. "_" .. i)
				AB.sphere(0.7, PINK, AB.offset(originCF, x + 0.6, y - 1.8, D/2 + 1.2), model, "BoxFlowerR_" .. floor .. "_" .. i)
			end
		end
	end

	-- Ground-floor cafe entrance (center)
	AB.block(Vector3.new(5, 6, 0.4), BROWN,
		AB.offset(originCF, 0, 3.5, D/2 + 0.2), model, "CafeDoor")
	local cafeGlass = AB.block(Vector3.new(4, 5, 0.2), GLASS,
		AB.offset(originCF, 0, 3.5, D/2 + 0.3), model, "CafeGlass")
	cafeGlass.Transparency = 0.4
	cafeGlass.Material = Enum.Material.Glass

	-- Cafe awning (deep pink)
	AB.block(Vector3.new(8, 0.5, 3), DEEP,
		AB.offset(originCF, 0, 7, D/2 + 1.7), model, "CafeAwning")
	for i, x in {-3, -1, 1, 3} do
		AB.block(Vector3.new(0.6, 0.55, 3), CREAM,
			AB.offset(originCF, x, 7, D/2 + 1.7), model, "CafeAwningStripe_" .. i)
	end
	-- Cafe sign (small neon)
	local cafeSign = AB.block(Vector3.new(6, 1.5, 0.3), NEONPK,
		AB.offset(originCF, 0, 8.8, D/2 + 0.2), model, "CafeSign")
	AB.neon(cafeSign)
	AB.glow(cafeSign, cafeSign.Color, 2)

	-- "Sugar crust" sparkly top edge — small white spheres lining the parapet
	for i = 1, 14 do
		local x = -W/2 + 1 + (i - 1) * 2
		AB.sphere(1.2, LIGHTCR,
			AB.offset(originCF, x, H + 0.6, D/2), model, "SugarF_" .. i)
		AB.sphere(1.2, LIGHTCR,
			AB.offset(originCF, x, H + 0.6, -D/2), model, "SugarB_" .. i)
		-- A few sparkle crystals
		if i % 3 == 0 then
			local sparkle = AB.sphere(0.5, NEONPK,
				AB.offset(originCF, x, H + 1.5, D/2), model, "SparkleF_" .. i)
			AB.neon(sparkle)
			AB.glow(sparkle, NEONPK, 1.5)
		end
	end
	-- Roof
	AB.block(Vector3.new(W, 0.6, D), BROWN,
		AB.offset(originCF, 0, H + 0.3, 0), model, "RoofSlab")

	-- Sidewalk lamps flanking
	for i, x in {-W/2 - 3, W/2 + 3} do
		AB.block(Vector3.new(0.6, 0.6, 0.6), BROWN, AB.offset(originCF, x, 0.7, D/2 + 1), model, "LampBase_" .. i)
		AB.cylinder(0.4, 7, BROWN, AB.offset(originCF, x, 4.5, D/2 + 1), model, "LampPost_" .. i)
		local lb = AB.sphere(1.2, NEONPK, AB.offset(originCF, x, 8.4, D/2 + 1), model, "LampBulb_" .. i)
		AB.neon(lb)
		AB.glow(lb, NEONPK, 2)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
