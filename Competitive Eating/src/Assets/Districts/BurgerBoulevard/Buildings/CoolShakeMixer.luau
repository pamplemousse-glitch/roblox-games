-- CoolShakeMixer — milkshake-themed building. Pink + white striped, with a giant
-- spinning-style milkshake glass on top (visual only — not actually spinning).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK      = Color3.fromRGB(255, 180, 200)
local WHITE     = Color3.fromRGB(248, 248, 248)
local NEON_RED  = Color3.fromRGB(255, 48, 48)
local CHROME    = Color3.fromRGB(176, 176, 176)
local TEAL      = Color3.fromRGB(127, 202, 194)
local CREAM     = Color3.fromRGB(255, 245, 232)
local SHAKE     = Color3.fromRGB(255, 220, 235)
local CHERRY    = Color3.fromRGB(220, 30, 50)
local BROWN     = Color3.fromRGB(110, 60, 30)
local SKY       = Color3.fromRGB(135, 206, 235)
local BLACK     = Color3.fromRGB(30, 30, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CoolShakeMixer", parent)

	-- Foundation
	local foundation = AB.block(Vector3.new(20, 0.6, 16), Color3.fromRGB(100, 100, 100), AB.offset(originCF, 0, 0.3, 0), model, "Foundation")
	foundation.Material = Enum.Material.Concrete

	-- Pink + white vertical-striped walls (8 stripes across back wall)
	for i = 0, 7 do
		local color = (i % 2 == 0) and PINK or WHITE
		local x = -8.75 + i * 2.5
		AB.block(Vector3.new(2.5, 8, 1), color, AB.offset(originCF, x, 4.6, -7.5), model, "BackStripe_" .. i)
	end
	-- Side walls (solid pink with white wainscot)
	AB.block(Vector3.new(1, 6, 16), PINK, AB.offset(originCF, -9.5, 5.6, 0), model, "LeftUpper")
	AB.block(Vector3.new(1, 2, 16), WHITE, AB.offset(originCF, -9.5, 1.6, 0), model, "LeftLower")
	AB.block(Vector3.new(1, 6, 16), PINK, AB.offset(originCF,  9.5, 5.6, 0), model, "RightUpper")
	AB.block(Vector3.new(1, 2, 16), WHITE, AB.offset(originCF,  9.5, 1.6, 0), model, "RightLower")

	-- Front wall (with large doorway + 2 windows)
	AB.block(Vector3.new(4, 8, 1), PINK, AB.offset(originCF, -8, 4.6, 7.5), model, "FrontFarL")
	AB.block(Vector3.new(4, 8, 1), PINK, AB.offset(originCF,  8, 4.6, 7.5), model, "FrontFarR")
	-- Door gap is the middle 12 studs; flank with two pink quarter panels
	AB.block(Vector3.new(3, 2, 1), PINK, AB.offset(originCF, 0, 7.6, 7.5), model, "FrontDoorHeader")
	-- Two side windows on the front
	local winL = AB.block(Vector3.new(2.5, 3, 0.4), SKY, AB.offset(originCF, -5.5, 5, 7.6), model, "FrontWinL")
	winL.Material = Enum.Material.Glass; winL.Transparency = 0.45
	local winR = AB.block(Vector3.new(2.5, 3, 0.4), SKY, AB.offset(originCF,  5.5, 5, 7.6), model, "FrontWinR")
	winR.Material = Enum.Material.Glass; winR.Transparency = 0.45
	-- Chrome window frames
	for _, x in {-5.5, 5.5} do
		AB.block(Vector3.new(2.8, 0.3, 0.5), CHROME, AB.offset(originCF, x, 6.55, 7.7), model, "WinT_" .. x)
		AB.block(Vector3.new(2.8, 0.3, 0.5), CHROME, AB.offset(originCF, x, 3.45, 7.7), model, "WinB_" .. x)
	end

	-- Awning over front
	AB.block(Vector3.new(20, 0.6, 4), TEAL, AB.offset(originCF, 0, 8.3, 9.3), model, "Awning")
	-- Awning striped fascia (pink + white)
	for i = 0, 9 do
		local color = (i % 2 == 0) and PINK or WHITE
		AB.block(Vector3.new(2, 0.6, 0.5), color, AB.offset(originCF, -9 + i * 2, 7.7, 11.3), model, "AwningStripe_" .. i)
	end

	-- Flat roof
	AB.block(Vector3.new(21, 0.5, 17), CHROME, AB.offset(originCF, 0, 8.85, 0), model, "Roof")

	-- Giant milkshake glass on roof
	-- Glass (transparent cone-shape) approximated by two cylinders
	local glass1 = AB.cylinder(8, 8, SHAKE, AB.offset(originCF, 0, 13, 0), model, "ShakeGlass")
	glass1.Material = Enum.Material.Glass; glass1.Transparency = 0.4; glass1.Reflectance = 0.2
	-- Whipped-cream top (sphere + smaller spheres stacked)
	AB.sphere(8, WHITE, AB.offset(originCF, 0, 17.5, 0), model, "WhipBase")
	AB.sphere(6, WHITE, AB.offset(originCF, 0, 19, 0), model, "WhipMid")
	AB.sphere(4, WHITE, AB.offset(originCF, 0, 20.5, 0), model, "WhipTop")
	-- Cherry on top
	local cherry = AB.sphere(1.6, CHERRY, AB.offset(originCF, 0, 22, 0), model, "Cherry")
	cherry.Material = Enum.Material.SmoothPlastic
	-- Cherry stem
	AB.cylinder(0.2, 1.5, BROWN, AB.offset(originCF, 0, 23, 0), model, "CherryStem")
	-- Straw poking out
	AB.cylinder(0.4, 5, NEON_RED, AB.offset(originCF, 2, 19, 0) * CFrame.Angles(0, 0, math.rad(-15)), model, "Straw")

	-- Neon "MILKSHAKES" sign on awning fascia
	local signBack = AB.block(Vector3.new(14, 2.5, 0.3), CHROME, AB.offset(originCF, 0, 6.5, 11.4), model, "SignBack")
	local signNeon = AB.block(Vector3.new(13, 1.8, 0.4), PINK, AB.offset(originCF, 0, 6.5, 11.55), model, "SignNeon")
	AB.neon(signNeon); AB.glow(signNeon, PINK, 2.5)
	AB.billboard(signBack, "MILKSHAKES", Vector2.new(340, 60), 0)

	-- Outdoor counter window (with stool to sit at)
	local stool = AB.cylinder(1.5, 3, NEON_RED, AB.offset(originCF, -8, 1.5, 9.5), model, "OutdoorStool1")
	AB.cylinder(0.5, 3, CHROME, AB.offset(originCF, -8, 1.5, 9.5), model, "OutdoorStool1Pole")
	AB.cylinder(1.5, 3, NEON_RED, AB.offset(originCF, 8, 1.5, 9.5), model, "OutdoorStool2")
	AB.cylinder(0.5, 3, CHROME, AB.offset(originCF, 8, 1.5, 9.5), model, "OutdoorStool2Pole")

	-- Side neon "SHAKES" vertical sign on left fin
	local fin = AB.block(Vector3.new(0.6, 8, 4), CREAM, AB.offset(originCF, -10.2, 4.6, -4), model, "VertSignFin")
	local finNeon = AB.block(Vector3.new(0.4, 7, 3.5), PINK, AB.offset(originCF, -10.4, 4.6, -4), model, "VertSignNeon")
	AB.neon(finNeon); AB.glow(finNeon, PINK, 2.0)
	AB.billboard(fin, "S\nH\nA\nK\nE\nS", Vector2.new(40, 200), 0)

	-- Entry steps + door
	AB.block(Vector3.new(8, 0.4, 1.5), CHROME, AB.offset(originCF, 0, 0.95, 8.3), model, "Step1")

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
