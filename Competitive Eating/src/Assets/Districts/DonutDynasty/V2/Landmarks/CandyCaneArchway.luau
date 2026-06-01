-- CandyCaneArchway — entry arch made of two giant candy-cane pillars
-- joined by a banner ribbon, with peppermint orbs and a glowing
-- neon-pink "WELCOME" sign at the keystone.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CREAM  = Color3.fromRGB(255, 240, 220)
local BROWN  = Color3.fromRGB(92,  57,  36)
local GOLD   = Color3.fromRGB(212, 168, 82)
local MINT   = Color3.fromRGB(180, 230, 200)
local NEONPK = Color3.fromRGB(255, 110, 170)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CandyCaneArchway", parent)

	local archHalfWidth = 14
	local pillarHeight = 24

	-- Base platforms (gold) under each pillar
	for i, x in {-archHalfWidth, archHalfWidth} do
		AB.cylinder(4, 0.8, GOLD, AB.offset(originCF, x, 0.4, 0), model, "Base_" .. i)
		AB.cylinder(4.4, 0.4, CREAM, AB.offset(originCF, x, 0.9, 0), model, "BaseRim_" .. i)
	end

	-- Left + right candy-cane pillars (vertical sections)
	for _, side in {{"L", -archHalfWidth}, {"R", archHalfWidth}} do
		local label, px = side[1], side[2]
		-- Pillar core (cream)
		AB.cylinder(3, pillarHeight, CREAM,
			AB.offset(originCF, px, pillarHeight / 2 + 1, 0), model, "Pillar" .. label)
		-- Spiral stripes
		for j = 1, 14 do
			local sy = 2 + (j - 1) * 1.6
			AB.cylinder(3.1, 0.55, DEEP,
				AB.offset(originCF, px, sy, 0, j * 30), model, "Stripe" .. label .. "_" .. j)
		end
		-- Hook at top — 3 spheres curving inward
		AB.sphere(3.4, CREAM, AB.offset(originCF, px, pillarHeight + 1.5, 0), model, "Hook" .. label .. "1")
		local towardCenter = (label == "L") and 1 or -1
		AB.sphere(3.4, CREAM, AB.offset(originCF, px + 2.5 * towardCenter, pillarHeight + 2.5, 0), model, "Hook" .. label .. "2")
		AB.sphere(3.4, CREAM, AB.offset(originCF, px + 5 * towardCenter, pillarHeight + 1.5, 0), model, "Hook" .. label .. "3")
		-- Stripes on hook
		AB.sphere(3.5, DEEP, AB.offset(originCF, px + 1 * towardCenter, pillarHeight + 2.2, 0), model, "HookStripe" .. label .. "1")
		AB.sphere(3.5, DEEP, AB.offset(originCF, px + 4 * towardCenter, pillarHeight + 2.2, 0), model, "HookStripe" .. label .. "2")
	end

	-- Top crossbeam ribbon (deep pink)
	AB.block(Vector3.new(archHalfWidth * 2, 2, 1.5), DEEP,
		AB.offset(originCF, 0, pillarHeight + 5, 0), model, "Ribbon")
	-- Cream wave underneath
	for i = 1, 7 do
		local rx = -archHalfWidth + 4 + (i - 1) * (archHalfWidth * 2 - 8) / 6
		AB.sphere(1.6, CREAM, AB.offset(originCF, rx, pillarHeight + 4, 0), model, "RibbonScallop_" .. i)
	end
	-- Ribbon tails on each end
	AB.wedge(Vector3.new(0.5, 4, 3), DEEP,
		AB.offset(originCF, -archHalfWidth - 0.5, pillarHeight + 3, 0) * CFrame.Angles(0, math.rad(90), math.rad(-15)),
		model, "RibbonTailL")
	AB.wedge(Vector3.new(0.5, 4, 3), DEEP,
		AB.offset(originCF, archHalfWidth + 0.5, pillarHeight + 3, 0) * CFrame.Angles(0, math.rad(-90), math.rad(15)),
		model, "RibbonTailR")

	-- "WELCOME" neon sign on the ribbon
	local sign = AB.block(Vector3.new(20, 3, 0.5), NEONPK,
		AB.offset(originCF, 0, pillarHeight + 5, 0.9), model, "NeonSign")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 4)
	-- Sign gold frame
	AB.block(Vector3.new(22, 3.6, 0.3), GOLD,
		AB.offset(originCF, 0, pillarHeight + 5, 0.6), model, "SignFrame")

	-- Peppermint orbs hanging from ribbon
	for i = 1, 5 do
		local hx = -10 + (i - 1) * 5
		AB.cylinder(0.1, 1.5, CREAM, AB.offset(originCF, hx, pillarHeight + 3.2, 0), model, "OrbWire_" .. i)
		local orb = AB.sphere(1.4, CREAM, AB.offset(originCF, hx, pillarHeight + 2, 0), model, "Orb_" .. i)
		AB.cylinder(1.45, 0.25, DEEP, AB.offset(originCF, hx, pillarHeight + 2, 0, 90), model, "OrbStripe_" .. i)
		AB.neon(orb)
		AB.glow(orb, NEONPK, 2)
	end

	-- Gold finial cherries on top of each pillar hook
	for i, x in {-archHalfWidth + 5, archHalfWidth - 5} do
		AB.sphere(1.6, NEONPK, AB.offset(originCF, x, pillarHeight + 4.5, 0), model, "FinialCherry_" .. i)
		AB.cylinder(0.3, 1.6, BROWN, AB.offset(originCF, x, pillarHeight + 5.5, 0), model, "FinialStem_" .. i)
		AB.wedge(Vector3.new(0.2, 1, 1), MINT,
			AB.offset(originCF, x + 0.5, pillarHeight + 6, 0) * CFrame.Angles(0, 0, math.rad(45)),
			model, "FinialLeaf_" .. i)
	end

	-- Welcome carpet (cream + sprinkle path style)
	AB.block(Vector3.new(8, 0.3, 6), CREAM,
		AB.offset(originCF, 0, 0.15, 0), model, "Carpet")
	for i = 1, 12 do
		local rx = (math.random() - 0.5) * 7
		local rz = (math.random() - 0.5) * 5
		AB.block(Vector3.new(0.25, 0.15, 0.7), DEEP,
			AB.offset(originCF, rx, 0.4, rz, math.random(0, 180)),
			model, "CarpetSprinkle_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
