-- Koi Pond Stones — small ornamental water feature with a curved arrangement
-- of stones, a glowing-cyan water disc, 3 koi fish blocks (orange + black),
-- and a tiny bamboo water spout (shishi-odoshi).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STONE       = Color3.fromRGB(120, 115, 105)
local STONE_DARK  = Color3.fromRGB(90, 85, 75)
local WATER_BLUE  = Color3.fromRGB(110, 180, 220)
local KOI_ORANGE  = Color3.fromRGB(255, 130, 60)
local KOI_WHITE   = Color3.fromRGB(245, 240, 230)
local KOI_BLACK   = Color3.fromRGB(35, 30, 30)
local BAMBOO      = Color3.fromRGB(140, 180, 100)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local GRASS       = Color3.fromRGB(100, 160, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("KoiPondStones", parent)

	-- Pond floor (a flat brown disc)
	AB.cylinder(10, 0.3, STONE_DARK,
		AB.offset(originCF, 0, 0.15, 0), model, "PondFloor")
	-- Water surface (slightly translucent cyan-neon disc)
	local water = AB.cylinder(9.4, 0.2, WATER_BLUE,
		AB.offset(originCF, 0, 0.45, 0), model, "WaterSurface")
	water.Transparency = 0.4
	water.Material     = Enum.Material.Neon
	AB.glow(water, WATER_BLUE, 1.5)

	-- Ring of stones around the pond (8 stones)
	for i = 1, 8 do
		local angle = (i - 1) * (math.pi * 2 / 8)
		local r = 5
		local sx = math.cos(angle) * r
		local sz = math.sin(angle) * r
		AB.block(Vector3.new(1.4 + (i % 3) * 0.3, 1.2, 1.4 + (i % 2) * 0.3), STONE,
			AB.offset(originCF, sx, 0.6, sz) * CFrame.Angles(0, math.rad(i * 17), 0),
			model, "Stone_" .. i)
	end

	-- 3 koi fish in the pond
	-- Koi 1: orange + white
	AB.block(Vector3.new(1.8, 0.3, 0.7), KOI_ORANGE,
		AB.offset(originCF, -1.5, 0.5, -1) * CFrame.Angles(0, math.rad(20), 0),
		model, "Koi1_Body")
	AB.block(Vector3.new(0.7, 0.3, 0.5), KOI_WHITE,
		AB.offset(originCF, -2.2, 0.51, -1.2) * CFrame.Angles(0, math.rad(20), 0),
		model, "Koi1_Patch")
	-- Tail (small wedge)
	AB.wedge(Vector3.new(0.4, 0.3, 0.5), KOI_ORANGE,
		AB.offset(originCF, -0.8, 0.5, -0.7) * CFrame.Angles(0, math.rad(110), 0),
		model, "Koi1_Tail")

	-- Koi 2: white + black
	AB.block(Vector3.new(1.6, 0.3, 0.6), KOI_WHITE,
		AB.offset(originCF, 2, 0.5, 1) * CFrame.Angles(0, math.rad(-30), 0),
		model, "Koi2_Body")
	AB.block(Vector3.new(0.4, 0.3, 0.4), KOI_BLACK,
		AB.offset(originCF, 1.8, 0.51, 1.3) * CFrame.Angles(0, math.rad(-30), 0),
		model, "Koi2_Patch")
	AB.wedge(Vector3.new(0.4, 0.3, 0.5), KOI_WHITE,
		AB.offset(originCF, 2.8, 0.5, 0.6) * CFrame.Angles(0, math.rad(60), 0),
		model, "Koi2_Tail")

	-- Koi 3: solid orange
	AB.block(Vector3.new(1.5, 0.3, 0.6), KOI_ORANGE,
		AB.offset(originCF, 0.3, 0.5, 2.5) * CFrame.Angles(0, math.rad(70), 0),
		model, "Koi3_Body")
	AB.wedge(Vector3.new(0.4, 0.3, 0.5), KOI_ORANGE,
		AB.offset(originCF, -0.4, 0.5, 2.8) * CFrame.Angles(0, math.rad(160), 0),
		model, "Koi3_Tail")

	-- Bamboo water spout (shishi-odoshi) on the back edge
	-- Vertical bamboo pole
	AB.cylinder(0.3, 4, BAMBOO,
		AB.offset(originCF, -5.5, 2, 4), model, "SpoutPole")
	-- Pivoting bamboo spout arm (angled)
	AB.cylinder(0.4, 3.5, BAMBOO,
		AB.offset(originCF, -4.5, 3.4, 4) * CFrame.Angles(0, 0, math.rad(-15)),
		model, "SpoutArm")
	-- Spout opening (dark hole at end of arm)
	AB.cylinder(0.42, 0.2, DARK_WOOD,
		AB.offset(originCF, -3.2, 3.0, 4), model, "SpoutMouth")
	-- Bamboo cap rings
	for i, y in {2.5, 3.6} do
		AB.cylinder(0.32, 0.1, DARK_WOOD,
			AB.offset(originCF, -5.5, y, 4), model, "PoleRing_" .. i)
	end

	-- Small grass tufts on a couple of stones
	for i, offset in {
		Vector3.new(-5, 1.3, 0),
		Vector3.new(3, 1.3, -4),
		Vector3.new(0, 1.3, -5),
	} do
		AB.block(Vector3.new(0.8, 0.4, 0.8), GRASS,
			AB.offset(originCF, offset.X, offset.Y, offset.Z), model, "GrassTuft_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
