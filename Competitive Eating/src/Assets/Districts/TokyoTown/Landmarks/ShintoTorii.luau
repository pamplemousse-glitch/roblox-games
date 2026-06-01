-- Shinto Torii — 2x the v1 ShintoArchEntry. Massive vermilion gate marking
-- the district's ceremonial entrance: huge pillars, big kasagi crossbar with
-- pronounced upturned ends, central glowing plaque, stone steps + lantern guards.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION   = Color3.fromRGB(200, 50, 40)
local VERMILION_D = Color3.fromRGB(150, 35, 30)
local DARK_WOOD   = Color3.fromRGB(60, 40, 30)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local STONE       = Color3.fromRGB(120, 115, 105)
local STONE_DARK  = Color3.fromRGB(90, 85, 75)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local GOLD        = Color3.fromRGB(220, 180, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ShintoTorii", parent)

	-- Wide stone plaza below the gate (5 stepping levels)
	for i = 0, 4 do
		local w = 22 + i * 2
		AB.block(Vector3.new(w, 0.6, 8 + i * 2), STONE,
			AB.offset(originCF, 0, 0.3 + i * 0.5, 0), model, "PlazaStep_" .. i)
	end

	-- Two huge stone base blocks under each pillar (2x v1 = 6 wide vs 3)
	for i, x in {-14, 14} do
		AB.block(Vector3.new(6, 2.8, 6), STONE,
			AB.offset(originCF, x, 4.1, 0), model, "PillarBase_" .. i)
		-- Inner stone darker step
		AB.block(Vector3.new(5, 0.4, 5), STONE_DARK,
			AB.offset(originCF, x, 5.5, 0), model, "PillarBaseTop_" .. i)
	end

	-- Two MASSIVE pillars (2x = 4.4 diameter, 36 high)
	for i, x in {-14, 14} do
		AB.cylinder(4.4, 36, VERMILION,
			AB.offset(originCF, x, 23.7, 0), model, "Pillar_" .. i)
		-- Black band near top
		AB.cylinder(4.6, 0.8, IRON_BLACK,
			AB.offset(originCF, x, 36, 0), model, "PillarBlackBand_" .. i)
		-- White trim ring further down
		AB.cylinder(4.5, 0.3, PAPER_WHITE,
			AB.offset(originCF, x, 12, 0), model, "PillarTrim_" .. i)
	end

	-- Lower crossbar (nuki) — between the pillars
	AB.block(Vector3.new(34, 2.8, 2.8), VERMILION,
		AB.offset(originCF, 0, 32, 0), model, "Nuki")
	-- Nuki end caps
	for i, x in {-17, 17} do
		AB.block(Vector3.new(0.8, 3.2, 3.2), VERMILION_D,
			AB.offset(originCF, x, 32, 0), model, "NukiCap_" .. i)
	end

	-- Center plaque (suspended below kasagi)
	AB.block(Vector3.new(4.8, 4.4, 1.2), DARK_WOOD,
		AB.offset(originCF, 0, 35, 0.8), model, "PlaqueFrame")
	local plaqueFace = AB.block(Vector3.new(4, 3.6, 1.3), VERMILION,
		AB.offset(originCF, 0, 35, 0.9), model, "PlaqueFace")
	AB.neon(plaqueFace)
	AB.glow(plaqueFace, VERMILION, 3)
	-- Inner gold inscription block
	AB.block(Vector3.new(3, 2.6, 1.35), GOLD,
		AB.offset(originCF, 0, 35, 0.95), model, "PlaqueInscription")

	-- Top crossbar (kasagi) — massive
	AB.block(Vector3.new(40, 3.2, 3.6), VERMILION,
		AB.offset(originCF, 0, 38.8, 0), model, "Kasagi")
	-- Top secondary slab (slightly narrower for the layered look)
	AB.block(Vector3.new(36, 1.2, 2.8), VERMILION,
		AB.offset(originCF, 0, 40.6, 0), model, "KasagiTop")

	-- Big black wedge end caps (the pronounced upturned ends)
	for i, x in {-20, 20} do
		AB.wedge(Vector3.new(3.2, 2, 2), IRON_BLACK,
			AB.offset(originCF, x, 38.8, 0) * CFrame.Angles(0, math.rad((x < 0) and 90 or -90), 0),
			model, "KasagiCap_" .. i)
		-- Wedge underbody
		AB.block(Vector3.new(2, 1.2, 2.2), IRON_BLACK,
			AB.offset(originCF, x + (x < 0 and 0.5 or -0.5), 38, 0), model, "KasagiCapUnder_" .. i)
	end

	-- Black decorative bands around each pillar (above and below center)
	for i, x in {-14, 14} do
		for j, y in {18, 25, 30} do
			AB.cylinder(4.5, 0.4, IRON_BLACK,
				AB.offset(originCF, x, y, 0), model, "PillarBand_" .. i .. "_" .. j)
		end
	end

	-- Two stone lanterns flanking the front (the toro guardian lanterns)
	for i, x in {-22, 22} do
		-- Base
		AB.block(Vector3.new(3, 0.8, 3), STONE,
			AB.offset(originCF, x, 2.6, 5), model, "ToroBase_" .. i)
		-- Mid pillar
		AB.cylinder(1.4, 4, STONE,
			AB.offset(originCF, x, 5, 5), model, "ToroPillar_" .. i)
		-- Lantern house (square stone block)
		AB.block(Vector3.new(2.4, 2.4, 2.4), STONE,
			AB.offset(originCF, x, 8.2, 5), model, "ToroHouse_" .. i)
		-- Lantern light (inside, glowing)
		local light = AB.block(Vector3.new(1.4, 1.4, 1.4), LANTERN_Y,
			AB.offset(originCF, x, 8.2, 5), model, "ToroLight_" .. i)
		AB.neon(light)
		AB.glow(light, LANTERN_Y, 3)
		-- Pyramidal stone roof
		AB.block(Vector3.new(3.2, 0.4, 3.2), STONE_DARK,
			AB.offset(originCF, x, 9.6, 5), model, "ToroRoof_" .. i)
		AB.block(Vector3.new(2.4, 0.4, 2.4), STONE_DARK,
			AB.offset(originCF, x, 10, 5), model, "ToroRoof2_" .. i)
		AB.sphere(1, STONE_DARK,
			AB.offset(originCF, x, 10.6, 5), model, "ToroFinial_" .. i)
	end

	-- Decorative shimenawa (rope) draped between pillars below the nuki
	-- (suggested via a thick straw-colored cylinder + 5 hanging zigzag strips)
	AB.cylinder(0.9, 28, Color3.fromRGB(230, 200, 140),
		AB.offset(originCF, 0, 28, 0.5) * CFrame.Angles(0, 0, math.rad(90)),
		model, "Shimenawa")
	for i = 1, 5 do
		local x = (i - 3) * 5
		AB.block(Vector3.new(0.7, 2.4, 0.1), PAPER_WHITE,
			AB.offset(originCF, x, 26.3, 0.5), model, "Shide_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
