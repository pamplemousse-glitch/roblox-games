-- Takoyaki Cart — V2 pushcart. Bigger + more detailed than v1 StreetCart:
-- proper push handle, propane tank, sauce squeeze bottles, octopus mascot
-- topper on the awning, ticker price chalkboard, and a tip jar.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION   = Color3.fromRGB(200, 50, 40)
local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local BALL_BROWN  = Color3.fromRGB(190, 130, 70)
local OCTO_PINK   = Color3.fromRGB(230, 140, 160)
local SAUCE_BROWN = Color3.fromRGB(90, 50, 30)
local GLASS_BLUE  = Color3.fromRGB(190, 220, 230)
local PROPANE     = Color3.fromRGB(180, 180, 190)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TakoyakiCart", parent)

	-- Cart body
	local body = AB.block(Vector3.new(12, 4.5, 6), WARM_WOOD,
		AB.offset(originCF, 0, 3, 0), model, "CartBody")
	AB.block(Vector3.new(12.1, 0.5, 6.1), DARK_WOOD,
		AB.offset(originCF, 0, 1.2, 0), model, "BodyTrim")
	for i = -5, 5, 1.5 do
		AB.block(Vector3.new(0.15, 4, 6.05), DARK_WOOD,
			AB.offset(originCF, i, 3, 0), model, "Panel_" .. (i + 5))
	end

	-- Four big wheels
	for i, offset in {
		Vector3.new(-5.5, 1.2, -2.0),
		Vector3.new( 5.5, 1.2, -2.0),
		Vector3.new(-5.5, 1.2,  2.0),
		Vector3.new( 5.5, 1.2,  2.0),
	} do
		AB.cylinder(2.4, 0.7, IRON_BLACK,
			AB.offset(originCF, offset.X, offset.Y, offset.Z) * CFrame.Angles(0, math.rad(90), 0),
			model, "Wheel_" .. i)
		AB.cylinder(0.6, 0.8, Color3.fromRGB(180, 140, 60),
			AB.offset(originCF, offset.X, offset.Y, offset.Z) * CFrame.Angles(0, math.rad(90), 0),
			model, "Hub_" .. i)
	end

	-- Push handle
	for i, side in {-1, 1} do
		AB.cylinder(0.4, 5, DARK_WOOD,
			AB.offset(originCF, side * 1.8, 4, -5.5) * CFrame.Angles(0, 0, math.rad(90)),
			model, "HandleArm_" .. i)
	end
	AB.cylinder(0.4, 4, DARK_WOOD,
		AB.offset(originCF, 0, 4, -7.8) * CFrame.Angles(0, math.rad(90), math.rad(90)),
		model, "HandleGrip")

	-- Counter top + recessed grill plate
	AB.block(Vector3.new(12.2, 0.4, 6.2), DARK_WOOD,
		AB.offset(originCF, 0, 5.4, 0), model, "CounterTop")
	AB.block(Vector3.new(6, 0.3, 3.5), IRON_BLACK,
		AB.offset(originCF, -2, 5.7, 0), model, "GrillPlate")
	for row = 0, 2 do
		for col = 0, 4 do
			local x = -3.7 + col * 0.9
			local z = (row - 1) * 0.9
			AB.sphere(0.6, BALL_BROWN,
				AB.offset(originCF, x, 5.9, z), model, "Ball_" .. row .. "_" .. col)
		end
	end

	-- Sauce squeeze bottles
	for i, x in {3.5, 4.2, 4.9} do
		AB.cylinder(0.5, 1.4, SAUCE_BROWN,
			AB.offset(originCF, x, 6.2, -1.5), model, "SauceBottle_" .. i)
		AB.cylinder(0.3, 0.3, DARK_WOOD,
			AB.offset(originCF, x, 7, -1.5), model, "SauceCap_" .. i)
	end

	-- Glass food display case at right end of counter
	AB.part({
		size  = Vector3.new(2.4, 1.6, 2),
		color = GLASS_BLUE, transparency = 0.55,
		cf    = AB.offset(originCF, 4.5, 6.4, 1),
		name  = "DisplayGlass",
	}, model)
	AB.block(Vector3.new(2.5, 0.15, 2.1), IRON_BLACK, AB.offset(originCF, 4.5, 7.2, 1), model, "DisplayTop")
	for i = 1, 3 do
		AB.sphere(0.55, BALL_BROWN, AB.offset(originCF, 4 + (i - 1) * 0.4, 6.2, 1), model, "DispBall_" .. i)
	end

	-- Propane tank
	AB.cylinder(1.6, 2.2, PROPANE,
		AB.offset(originCF, 4, 4.3, 2.5), model, "Propane")
	AB.cylinder(0.4, 0.6, IRON_BLACK,
		AB.offset(originCF, 4, 5.6, 2.5), model, "PropaneValve")

	-- 4 awning posts
	for i, offset in {
		Vector3.new(-5.5, 7, -2.5),
		Vector3.new( 5.5, 7, -2.5),
		Vector3.new(-5.5, 7,  2.5),
		Vector3.new( 5.5, 7,  2.5),
	} do
		AB.block(Vector3.new(0.4, 3.5, 0.4), DARK_WOOD,
			AB.offset(originCF, offset.X, offset.Y, offset.Z), model, "Post_" .. i)
	end

	-- Vermilion awning with white stripe trim
	AB.block(Vector3.new(13, 0.4, 7), VERMILION,
		AB.offset(originCF, 0, 8.8, 0), model, "Awning")
	for i, z in {-3, 3} do
		AB.block(Vector3.new(13, 0.45, 0.5), PAPER_WHITE,
			AB.offset(originCF, 0, 8.8, z), model, "AwningTrim_" .. i)
	end

	-- Glowing yellow lantern on the front-left corner
	local lantern = AB.cylinder(1.8, 2.2, LANTERN_Y,
		AB.offset(originCF, -4.5, 7.5, 3.2), model, "Lantern")
	AB.neon(lantern)
	AB.glow(lantern, lantern.Color, 2.5)
	AB.cylinder(1.85, 0.2, DARK_WOOD, AB.offset(originCF, -4.5, 8.7, 3.2), model, "LantTopCap")
	AB.cylinder(1.85, 0.2, DARK_WOOD, AB.offset(originCF, -4.5, 6.4, 3.2), model, "LantBotCap")

	-- "たこ焼" style sign
	local sign = AB.block(Vector3.new(5, 1.8, 0.3), VERMILION,
		AB.offset(originCF, 2.5, 9.6, 3.25), model, "Sign")
	AB.neon(sign)
	AB.glow(sign, LANTERN_Y, 2)
	AB.block(Vector3.new(4.6, 0.2, 0.35), PAPER_WHITE,
		AB.offset(originCF, 2.5, 8.9, 3.3), model, "SignText")

	-- Octopus mascot topper on awning
	AB.sphere(1.8, OCTO_PINK,
		AB.offset(originCF, 0, 10.1, 0), model, "OctoHead")
	for i, side in {-1, 1} do
		AB.sphere(0.35, PAPER_WHITE, AB.offset(originCF, side * 0.5, 10.4, 0.9), model, "OctoEyeW_" .. i)
		AB.sphere(0.18, IRON_BLACK, AB.offset(originCF, side * 0.5, 10.4, 1.05), model, "OctoEyeB_" .. i)
	end
	for i = 1, 6 do
		local angle = (i - 1) * (math.pi * 2 / 6)
		AB.cylinder(0.45, 1.2, OCTO_PINK,
			AB.offset(originCF, math.cos(angle) * 1.4, 9.3, math.sin(angle) * 1.4) * CFrame.Angles(0, 0, math.rad(20)),
			model, "OctoTent_" .. i)
	end

	-- Chalkboard price ticker
	AB.block(Vector3.new(0.3, 2.5, 2.5), IRON_BLACK,
		AB.offset(originCF, -6.6, 4, 0), model, "Chalkboard")
	for i, y in {3.3, 4, 4.7} do
		AB.block(Vector3.new(0.35, 0.2, 1.8), PAPER_WHITE,
			AB.offset(originCF, -6.6, y, 0), model, "ChalkLine_" .. i)
	end

	-- Tip jar
	AB.cylinder(0.7, 1.2, GLASS_BLUE,
		AB.offset(originCF, -5.5, 6.2, -1), model, "TipJar")
	AB.cylinder(0.5, 0.3, Color3.fromRGB(220, 180, 60),
		AB.offset(originCF, -5.5, 5.8, -1), model, "TipCoins")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
