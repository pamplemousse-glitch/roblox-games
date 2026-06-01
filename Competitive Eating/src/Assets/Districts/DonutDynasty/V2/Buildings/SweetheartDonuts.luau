-- SweetheartDonuts — bright pink storefront with a rotating neon donut
-- mounted above the door, heart-shaped window cutouts, and a glazed
-- pink awning. Visual centerpiece of the v2 main street.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK    = Color3.fromRGB(255, 200, 214)
local DEEP    = Color3.fromRGB(232, 130, 165)
local CREAM   = Color3.fromRGB(255, 240, 220)
local BROWN   = Color3.fromRGB(92,  57,  36)
local GOLD    = Color3.fromRGB(212, 168, 82)
local MINT    = Color3.fromRGB(180, 230, 200)
local NEONPK  = Color3.fromRGB(255, 90, 160)
local DOUGH   = Color3.fromRGB(220, 170, 110)
local GLASS   = Color3.fromRGB(210, 235, 250)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SweetheartDonuts", parent)

	-- Foundation
	AB.block(Vector3.new(36, 0.5, 26), Color3.fromRGB(110, 100, 95),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Pink walls
	AB.block(Vector3.new(36, 16, 1),  PINK, AB.offset(originCF, 0,    8, -12.5), model, "BackWall")
	AB.block(Vector3.new(1,  16, 26), PINK, AB.offset(originCF, -17.5, 8,  0),   model, "LeftWall")
	AB.block(Vector3.new(1,  16, 26), PINK, AB.offset(originCF,  17.5, 8,  0),   model, "RightWall")
	AB.block(Vector3.new(11, 16, 1),  PINK, AB.offset(originCF, -12.5, 8,  12.5), model, "FrontLeft")
	AB.block(Vector3.new(11, 16, 1),  PINK, AB.offset(originCF,  12.5, 8,  12.5), model, "FrontRight")
	AB.block(Vector3.new(14, 4,  1),  PINK, AB.offset(originCF,  0,    14, 12.5), model, "FrontHeader")

	-- Deep-pink wainscot strip
	AB.block(Vector3.new(36, 1.6, 1.1), DEEP,
		AB.offset(originCF, 0, 1.4, 12.6), model, "WainscotFront")
	AB.block(Vector3.new(36, 1.6, 1.1), DEEP,
		AB.offset(originCF, 0, 1.4, -12.6), model, "WainscotBack")

	-- Cream pilasters
	for i, x in {-7.5, 7.5} do
		AB.block(Vector3.new(0.9, 14, 0.9), CREAM,
			AB.offset(originCF, x, 7, 13), model, "Pilaster_" .. i)
	end

	-- Heart cutout windows on side walls (8x8 with smaller spheres flanking)
	local function heartWindow(name: string, x: number, z: number, yaw: number)
		local glass = AB.block(Vector3.new(0.3, 3, 4), GLASS,
			AB.offset(originCF, x, 8, z, yaw), model, name)
		glass.Transparency = 0.5
		glass.Material = Enum.Material.Glass
		AB.sphere(2, DEEP, AB.offset(originCF, x, 9, z - 1), model, name .. "_LobeA")
		AB.sphere(2, DEEP, AB.offset(originCF, x, 9, z + 1), model, name .. "_LobeB")
	end
	heartWindow("HeartWinL", -17.6, -3, 0)
	heartWindow("HeartWinL2", -17.6, 3, 0)
	heartWindow("HeartWinR",  17.6, -3, 0)
	heartWindow("HeartWinR2", 17.6, 3, 0)

	-- Pink awning over door (scalloped front edge)
	AB.block(Vector3.new(14, 0.7, 4), DEEP,
		AB.offset(originCF, 0, 11.4, 14.5), model, "Awning")
	for i = 1, 7 do
		local x = -6 + (i - 1) * 2
		AB.sphere(1.6, PINK,
			AB.offset(originCF, x, 11, 16.4), model, "Scallop_" .. i)
	end

	-- Rotating neon donut centerpiece on a pole above the awning
	AB.cylinder(0.6, 5, BROWN,
		AB.offset(originCF, 0, 18, 13.5) * CFrame.Angles(0, 0, math.rad(-90)), model, "DonutPole")
	-- Donut torus made from arranged spheres
	AB.circleArrange(AB.offset(originCF, 0, 21.5, 13.5), 3.2, 14, model, function(i, cf, _)
		local s = AB.sphere(1.6, DOUGH, cf, model, "DonutRing_" .. i)
		return s
	end)
	-- Pink glaze on top
	AB.circleArrange(AB.offset(originCF, 0, 22.4, 13.5), 3.2, 14, model, function(i, cf, _)
		return AB.sphere(1.4, NEONPK, cf, model, "DonutGlaze_" .. i)
	end)
	-- Sprinkles
	local sprinkleColors = {MINT, CREAM, GOLD, DEEP}
	for i = 1, 16 do
		local angle = (i / 16) * math.pi * 2
		local r = 3.2 + math.random() * 0.4
		local x = math.cos(angle) * r
		local z = 13.5 + math.sin(angle) * r
		AB.block(Vector3.new(0.25, 0.6, 0.25), sprinkleColors[(i % 4) + 1],
			AB.offset(originCF, x, 22.8, z), model, "Sprinkle_" .. i)
	end
	-- Glow source at donut center
	local glowCore = AB.sphere(1.6, NEONPK, AB.offset(originCF, 0, 21.5, 13.5), model, "DonutGlowCore")
	AB.neon(glowCore)
	glowCore.Transparency = 0.6
	AB.glow(glowCore, NEONPK, 5)

	-- "SWEETHEART" neon sign panel
	local sign = AB.block(Vector3.new(20, 2.8, 0.5), NEONPK,
		AB.offset(originCF, 0, 14.2, 13.1), model, "NeonSign")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 3)
	AB.block(Vector3.new(22, 3.4, 0.3), BROWN,
		AB.offset(originCF, 0, 14.2, 13.0), model, "SignBacking")

	-- Roof (cream)
	AB.block(Vector3.new(38, 1, 28), CREAM,
		AB.offset(originCF, 0, 16.5, 0), model, "Roof")
	AB.block(Vector3.new(38, 0.7, 1), DEEP,
		AB.offset(originCF, 0, 17.2, 13.5), model, "RoofTrimFront")
	AB.block(Vector3.new(38, 0.7, 1), DEEP,
		AB.offset(originCF, 0, 17.2, -13.5), model, "RoofTrimBack")

	-- Sidewalk: candy cane pillars
	for i, x in {-15, 15} do
		AB.cylinder(1, 6, CREAM, AB.offset(originCF, x, 3, 14.5), model, "CanePost_" .. i)
		for j = 1, 5 do
			local y = 0.8 + (j - 1) * 1.2
			AB.cylinder(1.05, 0.5, DEEP, AB.offset(originCF, x, y, 14.5), model, "CaneStripe_" .. i .. "_" .. j)
		end
	end

	-- Heart sign topper above neon sign
	AB.sphere(1.6, NEONPK, AB.offset(originCF, -0.9, 17.5, 13.2), model, "HeartLobeL")
	AB.sphere(1.6, NEONPK, AB.offset(originCF, 0.9, 17.5, 13.2), model, "HeartLobeR")
	AB.wedge(Vector3.new(2.4, 2, 0.6), NEONPK,
		AB.offset(originCF, 0, 16.8, 13.2) * CFrame.Angles(math.rad(180), 0, 0), model, "HeartPoint")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
