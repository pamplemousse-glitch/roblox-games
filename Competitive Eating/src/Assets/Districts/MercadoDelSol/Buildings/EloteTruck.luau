-- Elote Truck — yellow food truck with a giant corn cob mascot on the roof,
-- service window, awning, steam vent, "ELOTE" neon paint.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local CORN_YEL     = Color3.fromRGB(255, 210, 70)
local STUCCO_CREAM = Color3.fromRGB(245, 230, 200)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local TIRE_BLACK   = Color3.fromRGB(28, 28, 30)
local CHROME       = Color3.fromRGB(200, 200, 210)
local CAB_DARK     = Color3.fromRGB(180, 130, 30)
local GLASS_TEAL   = Color3.fromRGB(90, 180, 200)
local STEAM_WHITE  = Color3.fromRGB(245, 245, 250)
local STRIPE_RED   = Color3.fromRGB(200, 50, 50)
local SHADOW_GREY  = Color3.fromRGB(30, 30, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("EloteTruck", parent)

	-- Underbody shadow
	AB.part({
		size = Vector3.new(30, 0.1, 11), color = SHADOW_GREY,
		cf = AB.offset(originCF, 0, 0.05, 0),
		transparency = 0.5,
		name = "Shadow",
	}, model)

	-- Truck box body (yellow)
	AB.block(Vector3.new(22, 8, 10), FIESTA_YEL,
		AB.offset(originCF, 4, 5, 0), model, "TruckBox")
	-- Box bottom panel
	AB.block(Vector3.new(22, 0.8, 10), CAB_DARK,
		AB.offset(originCF, 4, 1.2, 0), model, "BoxChassis")
	-- Box back wall reinforcement
	AB.block(Vector3.new(0.5, 8, 10), CAB_DARK,
		AB.offset(originCF, 15, 5, 0), model, "BoxBack")

	-- Cab (smaller, in front of the box)
	AB.block(Vector3.new(6, 6, 8), FIESTA_YEL,
		AB.offset(originCF, -10, 4, 0), model, "Cab")
	-- Cab roof slope (wedge)
	AB.wedge(Vector3.new(8, 1.5, 6), FIESTA_YEL,
		AB.offset(originCF, -10, 7.5, 0) * CFrame.Angles(0, math.rad(-90), 0),
		model, "CabRoof")
	-- Cab windshield (translucent teal)
	AB.part({
		size = Vector3.new(0.3, 3, 5), color = GLASS_TEAL,
		cf = AB.offset(originCF, -13, 5, 0),
		transparency = 0.4,
		name = "Windshield",
	}, model)
	-- Side windows on cab
	AB.part({
		size = Vector3.new(2.5, 2.5, 0.3), color = GLASS_TEAL,
		cf = AB.offset(originCF, -10, 5, -4.1),
		transparency = 0.4,
		name = "SideWinL",
	}, model)
	AB.part({
		size = Vector3.new(2.5, 2.5, 0.3), color = GLASS_TEAL,
		cf = AB.offset(originCF, -10, 5, 4.1),
		transparency = 0.4,
		name = "SideWinR",
	}, model)
	-- Cab door outline
	AB.block(Vector3.new(2.6, 4, 0.1), CAB_DARK,
		AB.offset(originCF, -10, 3, -4.05), model, "CabDoorL")
	AB.block(Vector3.new(2.6, 4, 0.1), CAB_DARK,
		AB.offset(originCF, -10, 3, 4.05), model, "CabDoorR")
	-- Door handle
	AB.block(Vector3.new(0.4, 0.2, 0.2), CHROME,
		AB.offset(originCF, -10, 3.5, -4.15), model, "DoorHandleL")

	-- 4 wheels (2 per side, black cylinders)
	local wheelPositions = {
		Vector3.new(-9, 1.2, -5.1),
		Vector3.new(-9, 1.2, 5.1),
		Vector3.new(10, 1.2, -5.1),
		Vector3.new(10, 1.2, 5.1),
	}
	for i, pos in wheelPositions do
		AB.cylinder(2.4, 1.2, TIRE_BLACK,
			AB.offset(originCF, pos.X, pos.Y, pos.Z) * CFrame.Angles(math.rad(90), 0, 0),
			model, "Wheel_" .. i)
		-- Hub cap
		AB.cylinder(1.0, 1.3, CHROME,
			AB.offset(originCF, pos.X, pos.Y, pos.Z) * CFrame.Angles(math.rad(90), 0, 0),
			model, "Hub_" .. i)
	end

	-- Side service window cutout (cut on the +Z side of the box)
	AB.block(Vector3.new(10, 3.5, 0.4), SHADOW_GREY,
		AB.offset(originCF, 4, 5.5, 5), model, "ServiceWindowHole")
	-- Window frame
	AB.block(Vector3.new(10.4, 0.3, 0.5), WOOD_DARK,
		AB.offset(originCF, 4, 7.4, 5.05), model, "ServiceWinTop")
	AB.block(Vector3.new(10.4, 0.3, 0.5), WOOD_DARK,
		AB.offset(originCF, 4, 3.6, 5.05), model, "ServiceWinBot")
	-- Hinged service window flap (open, propped up)
	AB.block(Vector3.new(10, 3.5, 0.2), FIESTA_YEL,
		AB.offset(originCF, 4, 8.5, 6) * CFrame.Angles(math.rad(60), 0, 0),
		model, "ServiceFlap")
	-- Order counter sticking out of service window
	AB.block(Vector3.new(10, 0.4, 1.8), WOOD_DARK,
		AB.offset(originCF, 4, 5.5, 6), model, "OrderCounter")

	-- Awning extending from service side (red + white striped)
	AB.block(Vector3.new(12, 0.3, 3.5), STRIPE_RED,
		AB.offset(originCF, 4, 9.5, 6.8), model, "AwningBase")
	for i = 1, 6 do
		AB.block(Vector3.new(1.9, 0.15, 3.4),
			(i % 2 == 0) and STUCCO_CREAM or STRIPE_RED,
			AB.offset(originCF, -1.5 + (i - 1) * 2, 9.7, 6.8), model, "AwningStripe_" .. i)
	end
	-- Awning supports
	AB.block(Vector3.new(0.2, 1.4, 0.2), WOOD_DARK,
		AB.offset(originCF, -1.5, 8.7, 8.4), model, "AwningPoleL")
	AB.block(Vector3.new(0.2, 1.4, 0.2), WOOD_DARK,
		AB.offset(originCF, 9.5, 8.7, 8.4), model, "AwningPoleR")

	-- "ELOTE" painted on the side — 5 neon papel green letters
	for i = 1, 5 do
		local letter = AB.block(Vector3.new(1.5, 2, 0.1), PAPEL_GREEN,
			AB.offset(originCF, -2 + (i - 1) * 2.5, 5.5, -5.1), model, "ELOTE_" .. i)
		AB.neon(letter)
		if i % 2 == 0 then AB.glow(letter, PAPEL_GREEN, 1.4) end
	end

	-- GIANT CORN COB MASCOT on truck roof
	-- Core stem (vertical)
	AB.cylinder(1.4, 6.5, CORN_YEL,
		AB.offset(originCF, 4, 12, 0), model, "CornCore")
	-- 4 rows of kernels (stacked spheres around core)
	for row = 1, 4 do
		local y = 10 + row * 1.2
		for k = 1, 8 do
			local a = (k - 1) * math.pi / 4 + (row % 2) * math.pi / 8
			AB.sphere(0.9, CORN_YEL,
				AB.offset(originCF, 4 + math.cos(a) * 1.0, y, math.sin(a) * 1.0),
				model, string.format("Kernel_%d_%d", row, k))
		end
	end
	-- Top tip (small yellow cone-ish sphere)
	AB.sphere(1.0, CORN_YEL,
		AB.offset(originCF, 4, 15.5, 0), model, "CornTip")
	-- Two papel green leaves at the base (wedges angled outward)
	AB.wedge(Vector3.new(0.5, 3, 2.5), PAPEL_GREEN,
		AB.offset(originCF, 2, 9.5, 0) * CFrame.Angles(0, math.rad(-90), math.rad(-25)),
		model, "CornLeafL")
	AB.wedge(Vector3.new(0.5, 3, 2.5), PAPEL_GREEN,
		AB.offset(originCF, 6, 9.5, 0) * CFrame.Angles(0, math.rad(90), math.rad(-25)),
		model, "CornLeafR")
	AB.wedge(Vector3.new(0.5, 2.5, 2), PAPEL_GREEN,
		AB.offset(originCF, 4, 9.5, 2) * CFrame.Angles(math.rad(25), 0, 0),
		model, "CornLeafF")

	-- Steam vent on roof with neon white glow
	AB.cylinder(1.2, 1, CHROME,
		AB.offset(originCF, 12, 9.5, 0), model, "VentBase")
	AB.cylinder(0.9, 1.5, CHROME,
		AB.offset(originCF, 12, 10.5, 0), model, "VentPipe")
	for i = 1, 3 do
		local steam = AB.sphere(0.9 + i * 0.15, STEAM_WHITE,
			AB.offset(originCF, 12 + i * 0.2, 11.5 + i * 0.8, math.sin(i) * 0.2),
			model, "VentSteam_" .. i)
		AB.neon(steam)
		steam.Transparency = 0.5
		if i == 1 then AB.glow(steam, STEAM_WHITE, 1.5) end
	end

	-- Side mirrors on cab
	AB.block(Vector3.new(0.3, 1.2, 0.8), CAB_DARK,
		AB.offset(originCF, -12, 5.5, -4.5), model, "MirrorL")
	AB.block(Vector3.new(0.3, 1.2, 0.8), CAB_DARK,
		AB.offset(originCF, -12, 5.5, 4.5), model, "MirrorR")

	-- Headlights (neon white spheres)
	local hlL = AB.sphere(0.9, STEAM_WHITE,
		AB.offset(originCF, -13.2, 3, -2.5), model, "HeadlightL")
	AB.neon(hlL)
	AB.glow(hlL, STEAM_WHITE, 2)
	local hlR = AB.sphere(0.9, STEAM_WHITE,
		AB.offset(originCF, -13.2, 3, 2.5), model, "HeadlightR")
	AB.neon(hlR)
	AB.glow(hlR, STEAM_WHITE, 2)

	-- Grill (thin black bars)
	for i = 1, 5 do
		AB.block(Vector3.new(0.3, 0.15, 3), TIRE_BLACK,
			AB.offset(originCF, -13.1, 2 + (i - 1) * 0.3, 0), model, "GrillBar_" .. i)
	end

	-- License plate
	AB.block(Vector3.new(1.8, 0.7, 0.1), STUCCO_CREAM,
		AB.offset(originCF, 15.3, 2, 0), model, "LicensePlate")
	-- Plate text dots
	for i = 1, 4 do
		AB.block(Vector3.new(0.2, 0.4, 0.05), TIRE_BLACK,
			AB.offset(originCF, 15.35, 2, -0.6 + (i - 1) * 0.4), model, "PlateText_" .. i)
	end

	-- Back door handle/lever on box back
	AB.block(Vector3.new(0.3, 0.3, 1.5), CHROME,
		AB.offset(originCF, 15.3, 4, 0), model, "BackHandle")

	-- Ornamental terracotta stripe along truck body
	AB.block(Vector3.new(22.2, 0.4, 0.1), TERRACOTTA,
		AB.offset(originCF, 4, 3, -5.05), model, "BodyStripeL")
	AB.block(Vector3.new(22.2, 0.4, 0.1), TERRACOTTA,
		AB.offset(originCF, 4, 3, 5.05), model, "BodyStripeR")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
