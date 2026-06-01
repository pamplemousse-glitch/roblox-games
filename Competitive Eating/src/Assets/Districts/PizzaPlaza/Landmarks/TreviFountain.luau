-- Trevi Fountain — Baroque-style 3-tier fountain with a central Neptune
-- statue, flanking allegorical figures, scallop basins, and falling water.
-- Built fully from primitives (no Cube 3D mesh) for self-contained rendering.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local MARBLE    = Color3.fromRGB(235, 225, 200)
local DK_MARBLE = Color3.fromRGB(195, 180, 155)
local SHADOW    = Color3.fromRGB(160, 150, 130)
local WATER     = Color3.fromRGB(140, 200, 235)
local WATER_FOAM= Color3.fromRGB(220, 235, 245)
local AGED_BR   = Color3.fromRGB(120, 100, 70)
local GOLD      = Color3.fromRGB(220, 180, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TreviFountain", parent)

	-- Bottom basin (huge oval pool, made of 8 blocks in ring + filled center)
	-- Outer pool floor (large rectangle)
	AB.block(Vector3.new(38, 0.5, 24), DK_MARBLE, AB.offset(originCF, 0, 0.25, 0), model, "Floor")
	-- Pool walls (rectangular tub)
	AB.block(Vector3.new(40, 2, 0.8), MARBLE, AB.offset(originCF, 0, 1, 12), model, "PoolWallFront")
	AB.block(Vector3.new(40, 2, 0.8), MARBLE, AB.offset(originCF, 0, 1, -12), model, "PoolWallBack")
	AB.block(Vector3.new(0.8, 2, 25), MARBLE, AB.offset(originCF, -20, 1, 0), model, "PoolWallL")
	AB.block(Vector3.new(0.8, 2, 25), MARBLE, AB.offset(originCF,  20, 1, 0), model, "PoolWallR")
	-- Wall caps
	AB.block(Vector3.new(40, 0.3, 1.2), GOLD, AB.offset(originCF, 0, 2.1, 12), model, "PoolCapFront")
	AB.block(Vector3.new(40, 0.3, 1.2), GOLD, AB.offset(originCF, 0, 2.1, -12), model, "PoolCapBack")
	AB.block(Vector3.new(1.2, 0.3, 25), GOLD, AB.offset(originCF, -20, 2.1, 0), model, "PoolCapL")
	AB.block(Vector3.new(1.2, 0.3, 25), GOLD, AB.offset(originCF,  20, 2.1, 0), model, "PoolCapR")
	-- Water surface (transparent)
	local water = AB.block(Vector3.new(38, 0.4, 23), WATER, AB.offset(originCF, 0, 1.5, 0), model, "WaterSurface")
	water.Transparency = 0.4
	water.Material = Enum.Material.Glass

	-- Decorative scrolls at corners
	for i, sx in {-1, 1} do
		for j, sz in {-1, 1} do
			AB.sphere(1.4, MARBLE,
				AB.offset(originCF, sx * 20, 2.5, sz * 12), model, "Scroll_" .. i .. j)
		end
	end

	-- Middle tier (scallop basin sitting in middle of back area)
	AB.cylinder(8, 1.5, MARBLE, AB.offset(originCF, 0, 4, -6) * CFrame.Angles(0, 0, math.rad(90)), model, "MidBasin")
	AB.cylinder(8.4, 0.4, DK_MARBLE,
		AB.offset(originCF, 0, 4.8, -6) * CFrame.Angles(0, 0, math.rad(90)), model, "MidBasinRim")
	-- Scallop bumps around mid basin
	for i = 0, 11 do
		local angle = i / 12 * 2 * math.pi
		AB.wedge(Vector3.new(0.5, 1.5, 1.5), MARBLE,
			AB.offset(originCF, 8 * math.cos(angle), 4, -6 + 8 * math.sin(angle)) * CFrame.Angles(math.rad(180), -angle, 0),
			model, "MidScallop_" .. i)
	end
	-- Water in mid basin
	local midWater = AB.cylinder(7.6, 0.4, WATER,
		AB.offset(originCF, 0, 4.7, -6) * CFrame.Angles(0, 0, math.rad(90)), model, "MidWater")
	midWater.Transparency = 0.4

	-- Triumphal arch backdrop wall (Baroque facade)
	-- Lower base
	AB.block(Vector3.new(20, 6, 1), MARBLE, AB.offset(originCF, 0, 6, -10), model, "BackBase")
	-- Pilasters
	for i, sx in {-7, -3, 3, 7} do
		AB.block(Vector3.new(1.5, 18, 1.5), DK_MARBLE,
			AB.offset(originCF, sx, 12, -10), model, "Pilaster_" .. i)
		-- Capital
		AB.block(Vector3.new(2.2, 1, 2.2), GOLD, AB.offset(originCF, sx, 20.5, -10), model, "Capital_" .. i)
		-- Base block
		AB.block(Vector3.new(2.2, 1, 2.2), DK_MARBLE, AB.offset(originCF, sx, 3.5, -10), model, "PilBase_" .. i)
	end
	-- Central niche arch
	AB.block(Vector3.new(8, 14, 1), MARBLE, AB.offset(originCF, 0, 13, -10.5), model, "Niche")
	AB.sphere(4.5, MARBLE, AB.offset(originCF, 0, 18, -10.5), model, "NicheArch")
	-- Niche dark interior (recess)
	AB.block(Vector3.new(6, 12, 0.8), SHADOW, AB.offset(originCF, 0, 13, -9.7), model, "NicheRecess")

	-- Neptune statue (large figure in niche)
	-- Body
	AB.cylinder(1.6, 6, AGED_BR, AB.offset(originCF, 0, 10, -8.8), model, "NeptuneBody")
	-- Head
	AB.sphere(1.4, AGED_BR, AB.offset(originCF, 0, 14, -8.8), model, "NeptuneHead")
	-- Crown
	AB.cylinder(1.5, 0.6, GOLD, AB.offset(originCF, 0, 15.2, -8.8) * CFrame.Angles(0, 0, math.rad(90)), model, "NeptuneCrown")
	-- 3 crown spikes
	for i = -1, 1 do
		AB.wedge(Vector3.new(0.4, 1, 0.4), GOLD,
			AB.offset(originCF, i * 0.6, 15.7, -8.8), model, "CrownSpike_" .. (i + 2))
	end
	-- Arms outstretched
	AB.cylinder(0.5, 3, AGED_BR,
		AB.offset(originCF, -2, 11, -8.8) * CFrame.Angles(0, 0, math.rad(60)), model, "NeptuneArmL")
	AB.cylinder(0.5, 3, AGED_BR,
		AB.offset(originCF,  2, 11, -8.8) * CFrame.Angles(0, 0, math.rad(-60)), model, "NeptuneArmR")
	-- Trident
	AB.cylinder(0.25, 6, GOLD, AB.offset(originCF, -3, 14, -8.8), model, "Trident")
	for i = -1, 1 do
		AB.wedge(Vector3.new(0.2, 1.5, 0.5), GOLD,
			AB.offset(originCF, -3 + i * 0.4, 17.5, -8.8), model, "TridentSpike_" .. (i + 2))
	end
	-- Robe (drapes at bottom)
	AB.block(Vector3.new(4, 3, 1.4), AGED_BR, AB.offset(originCF, 0, 8, -8.8), model, "NeptuneRobe")

	-- Two flanking allegorical statues (smaller, on side pedestals)
	for k, sx in {-12, 12} do
		-- Pedestal
		AB.block(Vector3.new(3, 4, 3), DK_MARBLE, AB.offset(originCF, sx, 4, -8), model, "SidePed_" .. k)
		AB.block(Vector3.new(3.4, 0.4, 3.4), GOLD, AB.offset(originCF, sx, 6.2, -8), model, "SidePedCap_" .. k)
		-- Statue body
		AB.cylinder(1.2, 5, MARBLE, AB.offset(originCF, sx, 8.5, -8), model, "SideBody_" .. k)
		-- Head
		AB.sphere(1, MARBLE, AB.offset(originCF, sx, 11.5, -8), model, "SideHead_" .. k)
		-- Outstretched arm (one)
		AB.cylinder(0.35, 2.5, MARBLE,
			AB.offset(originCF, sx - sx * 0.15, 9.5, -8) * CFrame.Angles(0, 0, math.rad(sx > 0 and -30 or 30)),
			model, "SideArm_" .. k)
		-- Vase (water source)
		AB.cylinder(1, 1.6, AGED_BR, AB.offset(originCF, sx + (sx > 0 and -1 or 1), 7, -7), model, "SideVase_" .. k)
		-- Water falling from vase
		AB.block(Vector3.new(0.4, 4, 0.4), WATER,
			AB.offset(originCF, sx + (sx > 0 and -1 or 1), 5, -7), model, "SideStream_" .. k)
	end

	-- Marine creatures around base (horses/dolphins as abstract shapes)
	-- Two horses rearing up
	for k, sx in {-5, 5} do
		AB.sphere(1.5, AGED_BR, AB.offset(originCF, sx, 4, 2), model, "HorseBody_" .. k)
		AB.cylinder(0.6, 2.5, AGED_BR,
			AB.offset(originCF, sx, 5.5, 3) * CFrame.Angles(math.rad(-45), 0, 0), model, "HorseNeck_" .. k)
		AB.sphere(0.9, AGED_BR, AB.offset(originCF, sx, 7, 4.5), model, "HorseHead_" .. k)
		-- Mane (wedge)
		AB.wedge(Vector3.new(0.4, 1.5, 0.8), AGED_BR,
			AB.offset(originCF, sx, 6.5, 4) * CFrame.Angles(math.rad(180), 0, math.rad(90)), model, "HorseMane_" .. k)
		-- 4 legs
		for i, off in {Vector3.new(-0.5, 0, -0.8), Vector3.new(0.5, 0, -0.8), Vector3.new(-0.5, 0, 0.8), Vector3.new(0.5, 0, 0.8)} do
			AB.cylinder(0.3, 2, AGED_BR, AB.offset(originCF, sx + off.X, 3, 2 + off.Z), model, "HorseLeg_" .. k .. "_" .. i)
		end
	end

	-- Water cascades from upper basins to lower pool (foamy strips)
	for i = 1, 6 do
		local x = -6 + (i - 1) * 2.4
		local cascade = AB.block(Vector3.new(1.4, 3, 0.5), WATER_FOAM,
			AB.offset(originCF, x, 3.5, -3), model, "Cascade_" .. i)
		cascade.Transparency = 0.3
		AB.neon(cascade)
		-- Foam burst at bottom
		AB.sphere(0.7, WATER_FOAM, AB.offset(originCF, x, 2.2, -3), model, "Foam_" .. i)
	end

	-- Coin scattered at the bottom (tradition!)
	for i = 1, 16 do
		AB.cylinder(0.25, 0.05, GOLD,
			AB.offset(originCF, (math.random() - 0.5) * 30, 0.65, (math.random() - 0.5) * 18) * CFrame.Angles(0, 0, math.rad(90)),
			model, "Coin_" .. i)
	end

	-- Side niches (smaller statues in niches in the wall) — already done above as side statues

	-- Top pediment (triangular crown)
	AB.wedge(Vector3.new(1.5, 4, 20), GOLD,
		AB.offset(originCF, 0, 23, -10) * CFrame.Angles(0, math.rad(90), 0), model, "Pediment")
	-- Central cartouche (decorative shield)
	AB.block(Vector3.new(4, 3, 1), GOLD, AB.offset(originCF, 0, 22, -9.5), model, "Cartouche")
	AB.sphere(2, GOLD, AB.offset(originCF, 0, 23.5, -9.5), model, "CartoucheCrown")

	-- Lantern bracket atop
	AB.cylinder(0.6, 2, AGED_BR, AB.offset(originCF, 0, 26, -9), model, "TopLanternPost")
	local lantern = AB.sphere(1.4, Color3.fromRGB(255, 220, 140), AB.offset(originCF, 0, 27.5, -9), model, "TopLantern")
	AB.neon(lantern)
	AB.glow(lantern, lantern.Color, 3)

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
