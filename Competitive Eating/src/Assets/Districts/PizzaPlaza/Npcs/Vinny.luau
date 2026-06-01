-- Vinny — slick young Brooklyn slice-shop guy in a wifebeater + apron,
-- hair slicked back, holding a slice and a cash roll.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Vinny"
local SKIN    = Color3.fromRGB(245, 215, 175)
local TANK    = Color3.fromRGB(245, 240, 230)
local APRON   = Color3.fromRGB(240, 200, 80)
local JEANS   = Color3.fromRGB(60, 80, 130)
local HAIR    = Color3.fromRGB(30, 25, 25)
local PEPP    = Color3.fromRGB(200, 50, 50)
local CRUST   = Color3.fromRGB(220, 180, 110)
local CHAIN_G = Color3.fromRGB(220, 180, 60)
local CASH_G  = Color3.fromRGB(120, 180, 130)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (tank top)
	local torso = AB.part({size=Vector3.new(2.6, 3, 1.2), color=TANK,
		cf=originCF, canCollide=false, name="Torso"}, model)
	-- Apron (yellow)
	AB.part({size=Vector3.new(2.2, 2.4, 0.2), color=APRON,
		cf=AB.offset(originCF, 0, -0.2, 0.65), canCollide=false, name="Apron"}, model)
	AB.part({size=Vector3.new(0.3, 1.8, 0.15), color=APRON,
		cf=AB.offset(originCF, -0.8, 1.4, 0.65), canCollide=false, name="StrapL"}, model)
	AB.part({size=Vector3.new(0.3, 1.8, 0.15), color=APRON,
		cf=AB.offset(originCF, 0.8, 1.4, 0.65), canCollide=false, name="StrapR"}, model)
	-- Pants
	AB.part({size=Vector3.new(2.6, 0.4, 1.2), color=JEANS,
		cf=AB.offset(originCF, 0, -1.6, 0), canCollide=false, name="Belt"}, model)
	AB.part({size=Vector3.new(2.6, 0.4, 1.2), color=JEANS,
		cf=AB.offset(originCF, 0, -1.9, 0), canCollide=false, name="Pants"}, model)
	-- Gold chain
	AB.cylinder(1.4, 0.15, CHAIN_G,
		AB.offset(originCF, 0, 1.4, 0.55) * CFrame.Angles(0, 0, math.rad(90)), model, "Chain")
	AB.sphere(0.4, CHAIN_G, AB.offset(originCF, 0, 0.8, 0.7), model, "Pendant")

	-- Head
	local head = AB.part({size=Vector3.new(1.8, 1.8, 1.8), color=SKIN,
		cf=AB.offset(originCF, 0, 2.4, 0), shape=Enum.PartType.Ball, canCollide=false, name="Head"}, model)
	-- Slick hair (back-swept)
	AB.part({size=Vector3.new(1.9, 0.6, 1.6), color=HAIR,
		cf=AB.offset(originCF, 0, 3.1, -0.1), canCollide=false, name="HairTop"}, model)
	AB.wedge(Vector3.new(1.7, 0.5, 0.8), HAIR,
		AB.offset(originCF, 0, 3.3, -0.5) * CFrame.Angles(0, math.rad(180), 0), model, "HairBack")
	-- Sunglasses (cool, black)
	AB.block(Vector3.new(1.6, 0.3, 0.15), Color3.fromRGB(30, 30, 35),
		AB.offset(originCF, 0, 2.6, 0.85), model, "Shades")
	-- Smirk (small wedge mouth)
	AB.block(Vector3.new(0.7, 0.1, 0.1), Color3.fromRGB(150, 80, 80),
		AB.offset(originCF, 0.1, 2, 0.9), model, "Smirk")
	-- Earring
	AB.sphere(0.12, CHAIN_G, AB.offset(originCF, -0.85, 2.5, 0.2), model, "Earring")

	-- Arms forward (holding stuff)
	AB.part({size=Vector3.new(0.9, 2.2, 0.9), color=SKIN,
		cf=AB.offset(originCF, -1.6, -0.2, 0.2) * CFrame.Angles(math.rad(-45), 0, 0), canCollide=false, name="ArmL"}, model)
	AB.part({size=Vector3.new(0.9, 2.2, 0.9), color=SKIN,
		cf=AB.offset(originCF, 1.6, -0.2, 0.2) * CFrame.Angles(math.rad(-45), 0, 0), canCollide=false, name="ArmR"}, model)
	-- Hands
	AB.sphere(0.45, SKIN, AB.offset(originCF, -1.6, -1, 1.4), model, "HandL")
	AB.sphere(0.45, SKIN, AB.offset(originCF, 1.6, -1, 1.4), model, "HandR")

	-- Pizza slice in right hand (wedge)
	AB.wedge(Vector3.new(0.2, 0.8, 1.5), CRUST,
		AB.offset(originCF, 1.7, -0.9, 2.4) * CFrame.Angles(math.rad(180), 0, math.rad(90)), model, "Slice")
	AB.sphere(0.18, PEPP, AB.offset(originCF, 1.8, -0.65, 2.4), model, "SlicePep1")
	AB.sphere(0.18, PEPP, AB.offset(originCF, 1.5, -0.65, 2.3), model, "SlicePep2")

	-- Cash roll in left hand
	AB.cylinder(0.45, 0.8, CASH_G,
		AB.offset(originCF, -1.7, -0.9, 2.4) * CFrame.Angles(0, 0, math.rad(90)), model, "CashRoll")
	AB.cylinder(0.15, 1, Color3.fromRGB(220, 60, 80),
		AB.offset(originCF, -1.7, -0.9, 2.4) * CFrame.Angles(math.rad(90), 0, 0), model, "CashBand")

	AB.billboard(head, NAME, Vector2.new(200, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
