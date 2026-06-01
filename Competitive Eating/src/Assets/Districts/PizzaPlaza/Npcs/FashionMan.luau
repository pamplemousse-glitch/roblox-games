-- Fashion Man — dapper Italian man in suit, fedora, espresso in hand.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Marcello"
local SKIN    = Color3.fromRGB(240, 210, 175)
local SUIT    = Color3.fromRGB(40, 50, 80)
local SHIRT   = Color3.fromRGB(245, 240, 230)
local TIE_RED = Color3.fromRGB(180, 30, 40)
local HAIR    = Color3.fromRGB(40, 30, 25)
local HAT     = Color3.fromRGB(60, 50, 40)
local HAT_BND = Color3.fromRGB(35, 30, 25)
local SHOE_BR = Color3.fromRGB(70, 45, 30)
local CUP_W   = Color3.fromRGB(245, 235, 220)
local ESPR    = Color3.fromRGB(60, 35, 20)
local POCKET  = Color3.fromRGB(245, 240, 230)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (navy suit jacket)
	local torso = AB.part({size=Vector3.new(2.8, 3, 1.3), color=SUIT,
		cf=originCF, canCollide=false, name="Torso"}, model)
	-- Shirt collar visible at top
	AB.part({size=Vector3.new(1.2, 0.5, 0.3), color=SHIRT,
		cf=AB.offset(originCF, 0, 1.2, 0.7), canCollide=false, name="Collar"}, model)
	-- White shirt under tie (V)
	AB.wedge(Vector3.new(0.2, 1, 0.8), SHIRT,
		AB.offset(originCF, 0, 0.5, 0.7) * CFrame.Angles(math.rad(180), 0, math.rad(90)), model, "ShirtV")
	AB.wedge(Vector3.new(0.2, 1, 0.8), SHIRT,
		AB.offset(originCF, 0, 0.5, 0.7) * CFrame.Angles(math.rad(180), 0, math.rad(-90)), model, "ShirtV2")
	-- Red tie
	AB.block(Vector3.new(0.35, 1.5, 0.2), TIE_RED, AB.offset(originCF, 0, 0.2, 0.75), model, "Tie")
	AB.wedge(Vector3.new(0.2, 0.4, 0.45), TIE_RED,
		AB.offset(originCF, 0, -0.7, 0.75) * CFrame.Angles(math.rad(180), 0, math.rad(90)), model, "TieTip")
	AB.wedge(Vector3.new(0.2, 0.4, 0.45), TIE_RED,
		AB.offset(originCF, 0, -0.7, 0.75) * CFrame.Angles(math.rad(180), 0, math.rad(-90)), model, "TieTip2")
	-- Pocket square (white triangle)
	AB.wedge(Vector3.new(0.05, 0.4, 0.4), POCKET,
		AB.offset(originCF, -0.9, 0.4, 0.7) * CFrame.Angles(math.rad(180), 0, math.rad(90)), model, "PocketSquare")
	-- Jacket lapels
	AB.wedge(Vector3.new(0.2, 1.5, 0.7), SUIT,
		AB.offset(originCF, -0.5, 0.5, 0.7) * CFrame.Angles(math.rad(180), 0, math.rad(90)), model, "LapelL")
	AB.wedge(Vector3.new(0.2, 1.5, 0.7), SUIT,
		AB.offset(originCF, 0.5, 0.5, 0.7) * CFrame.Angles(math.rad(180), 0, math.rad(-90)), model, "LapelR")
	-- Jacket button (silver)
	AB.sphere(0.12, Color3.fromRGB(200, 200, 210), AB.offset(originCF, 0.6, -0.3, 0.78), model, "JktButton")
	-- Pants
	AB.part({size=Vector3.new(2.8, 0.4, 1.3), color=SUIT,
		cf=AB.offset(originCF, 0, -1.6, 0), canCollide=false, name="Belt"}, model)
	AB.part({size=Vector3.new(2.8, 1.8, 1.3), color=SUIT,
		cf=AB.offset(originCF, 0, -2.7, 0), canCollide=false, name="Pants"}, model)
	-- Crease lines
	AB.block(Vector3.new(0.05, 1.8, 0.05), Color3.fromRGB(30, 35, 60),
		AB.offset(originCF, -0.7, -2.7, 0.7), model, "CreaseL")
	AB.block(Vector3.new(0.05, 1.8, 0.05), Color3.fromRGB(30, 35, 60),
		AB.offset(originCF, 0.7, -2.7, 0.7), model, "CreaseR")
	-- Brown leather shoes
	AB.part({size=Vector3.new(0.9, 0.5, 1.4), color=SHOE_BR,
		cf=AB.offset(originCF, -0.7, -3.85, 0.3), canCollide=false, name="ShoeL"}, model)
	AB.part({size=Vector3.new(0.9, 0.5, 1.4), color=SHOE_BR,
		cf=AB.offset(originCF, 0.7, -3.85, 0.3), canCollide=false, name="ShoeR"}, model)

	-- Head
	local head = AB.part({size=Vector3.new(1.9, 1.9, 1.9), color=SKIN,
		cf=AB.offset(originCF, 0, 2.5, 0), shape=Enum.PartType.Ball, canCollide=false, name="Head"}, model)
	-- Slick hair side
	AB.part({size=Vector3.new(2, 0.8, 1.5), color=HAIR,
		cf=AB.offset(originCF, 0, 3, -0.2), canCollide=false, name="HairTop"}, model)
	-- Fedora
	AB.part({size=Vector3.new(2.4, 0.5, 2.4), color=HAT,
		cf=AB.offset(originCF, 0, 3.7, 0), canCollide=false, name="HatBrim"}, model)
	AB.cylinder(1.4, 1.4, HAT, AB.offset(originCF, 0, 4.4, 0), model, "HatCrown")
	AB.cylinder(1.45, 0.2, HAT_BND, AB.offset(originCF, 0, 4, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "HatBand")
	-- Fedora pinch (small wedge on top)
	AB.wedge(Vector3.new(0.3, 0.4, 1.4), HAT,
		AB.offset(originCF, 0, 5.1, 0) * CFrame.Angles(0, math.rad(90), 0), model, "HatPinch")
	-- Sharp eyebrows
	AB.part({size=Vector3.new(0.4, 0.18, 0.08), color=HAIR,
		cf=AB.offset(originCF, -0.4, 2.95, 0.93), canCollide=false, name="BrowL"}, model)
	AB.part({size=Vector3.new(0.4, 0.18, 0.08), color=HAIR,
		cf=AB.offset(originCF, 0.4, 2.95, 0.93), canCollide=false, name="BrowR"}, model)
	-- Eyes
	AB.sphere(0.16, Color3.fromRGB(30, 25, 20), AB.offset(originCF, -0.4, 2.65, 0.95), model, "EyeL")
	AB.sphere(0.16, Color3.fromRGB(30, 25, 20), AB.offset(originCF, 0.4, 2.65, 0.95), model, "EyeR")
	-- Subtle smirk
	AB.block(Vector3.new(0.5, 0.08, 0.08), Color3.fromRGB(160, 100, 90),
		AB.offset(originCF, 0.1, 2.05, 0.93), model, "Smirk")
	-- Pencil mustache
	AB.block(Vector3.new(1, 0.1, 0.15), HAIR, AB.offset(originCF, 0, 2.2, 0.92), model, "Mustache")

	-- Arms (one holding espresso, one in pocket)
	AB.part({size=Vector3.new(0.85, 2.5, 0.85), color=SUIT,
		cf=AB.offset(originCF, -1.7, -0.5, 0.3) * CFrame.Angles(math.rad(-20), 0, 0), canCollide=false, name="ArmL"}, model)
	AB.part({size=Vector3.new(0.85, 2.4, 0.85), color=SUIT,
		cf=AB.offset(originCF, 1.7, 0.2, 0.5) * CFrame.Angles(math.rad(-60), 0, 0), canCollide=false, name="ArmR"}, model)
	-- Hands
	AB.sphere(0.45, SKIN, AB.offset(originCF, -1.7, -1.7, 0.8), model, "HandL")
	AB.sphere(0.45, SKIN, AB.offset(originCF, 1.7, -0.9, 1.6), model, "HandR")

	-- Espresso cup in right hand
	AB.cylinder(0.5, 0.6, CUP_W,
		AB.offset(originCF, 1.7, -0.6, 1.6), model, "Cup")
	AB.cylinder(0.55, 0.1, CUP_W,
		AB.offset(originCF, 1.7, -0.9, 1.6) * CFrame.Angles(0, 0, math.rad(90)), model, "Saucer")
	AB.cylinder(0.45, 0.1, ESPR,
		AB.offset(originCF, 1.7, -0.4, 1.6) * CFrame.Angles(0, 0, math.rad(90)), model, "CupCoffee")
	-- Cup handle
	AB.sphere(0.15, CUP_W, AB.offset(originCF, 2.15, -0.6, 1.6), model, "CupHandle")
	-- Steam
	local s = AB.sphere(0.4, Color3.fromRGB(240, 240, 240), AB.offset(originCF, 1.7, 0.2, 1.6), model, "Steam")
	s.Transparency = 0.6

	AB.billboard(head, NAME, Vector2.new(220, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
