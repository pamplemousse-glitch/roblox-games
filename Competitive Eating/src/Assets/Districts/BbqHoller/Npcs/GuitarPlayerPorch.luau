-- Guitar Player on Porch — seated musician in jeans, denim vest, scruffy
-- beard, holding an acoustic guitar across the lap. Tipped cowboy hat.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN      = Color3.fromRGB(225, 180, 140)
local DENIM     = Color3.fromRGB(60, 80, 130)
local DENIM_D   = Color3.fromRGB(40, 55, 95)
local SHIRT_W   = Color3.fromRGB(245, 240, 225)
local PANTS     = Color3.fromRGB(55, 70, 100)
local BOOT      = Color3.fromRGB(70, 50, 30)
local HAT_BROWN = Color3.fromRGB(95, 65, 38)
local HAT_DARK  = Color3.fromRGB(60, 40, 22)
local HAIR      = Color3.fromRGB(95, 70, 45)
local BEARD     = Color3.fromRGB(75, 55, 35)
local GUITAR    = Color3.fromRGB(170, 105, 55)
local GUITAR_D  = Color3.fromRGB(110, 65, 30)
local STRING    = Color3.fromRGB(220, 220, 225)
local STOOL     = Color3.fromRGB(120, 85, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GuitarPlayerPorch", parent)

	-- Stool / barrel he's sitting on
	local stool = AB.cylinder(3, 2.4, STOOL, AB.offset(originCF, 0, 1.2, 0), model, "Stool")
	-- Stool bands
	AB.cylinder(3.1, 0.2, HAT_DARK, AB.offset(originCF, 0, 0.5, 0), model, "StoolBand1")
	AB.cylinder(3.1, 0.2, HAT_DARK, AB.offset(originCF, 0, 2.0, 0), model, "StoolBand2")

	-- Legs (seated — pointing forward)
	local legL = AB.block(Vector3.new(1.2, 3, 1.2), PANTS, AB.offset(originCF, -0.7, 2.5, 1.5), model, "LegL")
	legL.CFrame = legL.CFrame * CFrame.Angles(math.rad(85), 0, 0)
	local legR = AB.block(Vector3.new(1.2, 3, 1.2), PANTS, AB.offset(originCF,  0.7, 2.5, 1.5), model, "LegR")
	legR.CFrame = legR.CFrame * CFrame.Angles(math.rad(85), 0, 0)
	-- Boots resting on ground (front of stool)
	AB.block(Vector3.new(1.4, 0.7, 1.7), BOOT, AB.offset(originCF, -0.7, 0.35, 3.0), model, "BootL")
	AB.block(Vector3.new(1.4, 0.7, 1.7), BOOT, AB.offset(originCF,  0.7, 0.35, 3.0), model, "BootR")

	-- Torso (white shirt under denim vest)
	local torso = AB.block(Vector3.new(3.2, 3.6, 1.7), SHIRT_W, AB.offset(originCF, 0, 4.6, 0), model, "Torso")
	-- Denim vest panels
	AB.block(Vector3.new(0.7, 3.6, 1.7), DENIM, AB.offset(originCF, -1.4, 4.6, 0), model, "VestL")
	AB.block(Vector3.new(0.7, 3.6, 1.7), DENIM, AB.offset(originCF,  1.4, 4.6, 0), model, "VestR")
	AB.block(Vector3.new(3.2, 3.6, 0.2), DENIM, AB.offset(originCF, 0, 4.6, -0.8), model, "VestBack")
	-- Vest stitching
	AB.block(Vector3.new(0.1, 3.6, 0.1), DENIM_D, AB.offset(originCF, -1.05, 4.6, 0.85), model, "StitchL")
	AB.block(Vector3.new(0.1, 3.6, 0.1), DENIM_D, AB.offset(originCF,  1.05, 4.6, 0.85), model, "StitchR")

	-- Arms (positioned to play guitar — both forward and down)
	local armL = AB.block(Vector3.new(1.1, 3.2, 1.1), SHIRT_W, AB.offset(originCF, -2.1, 4.5, 0.6), model, "ArmL")
	armL.CFrame = armL.CFrame * CFrame.Angles(math.rad(-30), math.rad(20), 0)
	local armR = AB.block(Vector3.new(1.1, 3.2, 1.1), SHIRT_W, AB.offset(originCF,  2.1, 4.5, 0.6), model, "ArmR")
	armR.CFrame = armR.CFrame * CFrame.Angles(math.rad(-30), math.rad(-20), 0)
	AB.sphere(0.8, SKIN, AB.offset(originCF, -2.5, 3.5, 2.0), model, "HandL")
	AB.sphere(0.8, SKIN, AB.offset(originCF,  2.5, 3.5, 2.0), model, "HandR")

	-- Acoustic guitar (across lap, slightly tilted)
	-- Body (large hourglass — simplified to a stretched sphere)
	local guitarCF = AB.offset(originCF, 0.2, 4.0, 2.4) * CFrame.Angles(0, 0, math.rad(20))
	AB.sphere(3.4, GUITAR, guitarCF, model, "GuitarBody")
	-- Sound hole
	AB.cylinder(0.9, 0.1, GUITAR_D, guitarCF * CFrame.new(0, 0, 1.6), model, "SoundHole")
	-- Bridge
	AB.block(Vector3.new(1, 0.2, 0.3), GUITAR_D, guitarCF * CFrame.new(-1.2, 0, 1.6), model, "Bridge")
	-- Guitar neck (long stick)
	local neck = AB.block(Vector3.new(0.6, 7, 0.4), GUITAR_D, guitarCF * CFrame.new(2.5, 0, 1.4), model, "Neck")
	neck.CFrame = neck.CFrame * CFrame.Angles(0, 0, math.rad(90))
	-- Frets (5 lines on neck)
	for i = 1, 5 do
		AB.block(Vector3.new(0.55, 0.1, 0.42), STRING, guitarCF * CFrame.new(2 + i * 1.1, 0, 1.4), model, "Fret_" .. i)
	end
	-- Headstock
	AB.block(Vector3.new(1.4, 0.4, 0.6), GUITAR_D, guitarCF * CFrame.new(8.5, 0.2, 1.4), model, "Headstock")
	-- Tuning pegs (3 each side)
	for i = 1, 3 do
		AB.sphere(0.2, STRING, guitarCF * CFrame.new(8.3 + (i - 1) * 0.4, 0.5, 1.4), model, "PegT_" .. i)
		AB.sphere(0.2, STRING, guitarCF * CFrame.new(8.3 + (i - 1) * 0.4, -0.5, 1.4), model, "PegB_" .. i)
	end
	-- Strings (6 thin lines from bridge to headstock)
	for i = 1, 6 do
		local offY = -0.3 + (i - 1) * 0.12
		AB.block(Vector3.new(8.5, 0.04, 0.04), STRING, guitarCF * CFrame.new(2.5, offY, 1.42), model, "String_" .. i)
	end

	-- Head
	AB.sphere(2.1, SKIN, AB.offset(originCF, 0, 7.4, 0), model, "Head")
	-- Hair (longer, scraggly)
	AB.sphere(1.6, HAIR, AB.offset(originCF, 0, 7.8, -0.5), model, "HairBack")
	AB.block(Vector3.new(2.2, 0.3, 2.2), HAIR, AB.offset(originCF, 0, 8.1, 0), model, "HairTop")
	-- Scruffy beard
	AB.block(Vector3.new(1.8, 1, 1.5), BEARD, AB.offset(originCF, 0, 6.5, 0.4), model, "Beard")

	-- Cowboy hat (tipped slightly)
	local hatBrim = AB.cylinder(5.4, 0.3, HAT_BROWN, AB.offset(originCF, 0, 8.4, 0), model, "HatBrim")
	hatBrim.CFrame = hatBrim.CFrame * CFrame.Angles(math.rad(-8), 0, 0)
	local hatCrown = AB.cylinder(2.6, 1.4, HAT_BROWN, AB.offset(originCF, 0, 9.3, 0.2), model, "HatCrown")
	hatCrown.CFrame = hatCrown.CFrame * CFrame.Angles(math.rad(-8), 0, 0)
	AB.cylinder(2.65, 0.3, HAT_DARK, AB.offset(originCF, 0, 8.8, 0.2), model, "HatBand")

	-- Eyes (one closed in concentration — both as thin lines)
	AB.block(Vector3.new(0.35, 0.1, 0.1), Color3.new(0, 0, 0), AB.offset(originCF, -0.5, 7.7, 0.95), model, "EyeL")
	AB.block(Vector3.new(0.35, 0.1, 0.1), Color3.new(0, 0, 0), AB.offset(originCF,  0.5, 7.7, 0.95), model, "EyeR")

	AB.billboard(model:FindFirstChild("Head") or torso, "Musician", Vector2.new(180, 36), 3.2)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
