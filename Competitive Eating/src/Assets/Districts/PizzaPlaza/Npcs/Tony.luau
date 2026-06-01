-- Tony — owner of Tony's Pizzeria. Big mustache, white chef's hat, stained
-- red apron, holding a pizza peel.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Tony"
local SKIN    = Color3.fromRGB(245, 215, 175)
local SHIRT   = Color3.fromRGB(245, 240, 230)
local APRON   = Color3.fromRGB(200, 40, 40)
local PANTS   = Color3.fromRGB(60, 60, 70)
local HAIR    = Color3.fromRGB(50, 35, 30)
local HAT     = Color3.fromRGB(255, 255, 250)
local STAIN   = Color3.fromRGB(170, 30, 30)
local WD      = Color3.fromRGB(110, 75, 45)
local PEEL    = Color3.fromRGB(180, 180, 190)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (white chef shirt)
	local torso = AB.part({size=Vector3.new(3, 3, 1.4), color=SHIRT,
		cf=originCF, canCollide=false, name="Torso"}, model)
	-- Apron (red, over shirt)
	AB.part({size=Vector3.new(2.6, 2.8, 0.2), color=APRON,
		cf=AB.offset(originCF, 0, 0, 0.75), canCollide=false, name="Apron"}, model)
	-- Apron strap
	AB.part({size=Vector3.new(0.4, 2.2, 0.2), color=APRON,
		cf=AB.offset(originCF, -0.8, 1.5, 0.75), canCollide=false, name="StrapL"}, model)
	AB.part({size=Vector3.new(0.4, 2.2, 0.2), color=APRON,
		cf=AB.offset(originCF, 0.8, 1.5, 0.75), canCollide=false, name="StrapR"}, model)
	-- Apron stain
	AB.part({size=Vector3.new(0.6, 0.4, 0.05), color=STAIN,
		cf=AB.offset(originCF, 0.3, -0.5, 0.85), canCollide=false, name="Stain"}, model)
	-- Pants/belt
	AB.part({size=Vector3.new(3, 0.4, 1.4), color=Color3.fromRGB(40, 40, 50),
		cf=AB.offset(originCF, 0, -1.6, 0), canCollide=false, name="Belt"}, model)
	AB.part({size=Vector3.new(3, 0.4, 1.4), color=PANTS,
		cf=AB.offset(originCF, 0, -1.9, 0), canCollide=false, name="Pants"}, model)

	-- Head
	local head = AB.part({size=Vector3.new(2, 2, 2), color=SKIN,
		cf=AB.offset(originCF, 0, 2.5, 0), shape=Enum.PartType.Ball, canCollide=false, name="Head"}, model)
	-- Mustache (big, dark)
	AB.part({size=Vector3.new(1.6, 0.4, 0.5), color=HAIR,
		cf=AB.offset(originCF, 0, 2.1, 0.9), canCollide=false, name="Mustache"}, model)
	-- Eyebrows
	AB.part({size=Vector3.new(0.4, 0.15, 0.1), color=HAIR,
		cf=AB.offset(originCF, -0.4, 2.8, 0.95), canCollide=false, name="BrowL"}, model)
	AB.part({size=Vector3.new(0.4, 0.15, 0.1), color=HAIR,
		cf=AB.offset(originCF, 0.4, 2.8, 0.95), canCollide=false, name="BrowR"}, model)
	-- Eyes
	AB.sphere(0.18, Color3.fromRGB(30, 25, 20), AB.offset(originCF, -0.4, 2.5, 0.95), model, "EyeL")
	AB.sphere(0.18, Color3.fromRGB(30, 25, 20), AB.offset(originCF, 0.4, 2.5, 0.95), model, "EyeR")

	-- Chef's hat (puffy)
	AB.part({size=Vector3.new(2.2, 0.6, 2.2), color=HAT,
		cf=AB.offset(originCF, 0, 3.6, 0), canCollide=false, name="HatBase"}, model)
	AB.sphere(2.2, HAT, AB.offset(originCF, 0, 4.3, 0), model, "HatPuff")

	-- Arms
	AB.part({size=Vector3.new(1, 2.5, 1), color=SHIRT,
		cf=AB.offset(originCF, -1.8, 0.2, 0), canCollide=false, name="ArmL"}, model)
	AB.part({size=Vector3.new(1, 2.5, 1), color=SHIRT,
		cf=AB.offset(originCF, 1.8, 0.2, 0), canCollide=false, name="ArmR"}, model)
	-- Hands
	AB.sphere(0.5, SKIN, AB.offset(originCF, -1.8, -1.2, 0), model, "HandL")
	AB.sphere(0.5, SKIN, AB.offset(originCF, 1.8, -1.2, 0.5), model, "HandR")

	-- Pizza peel held in right hand (long stick + flat head)
	AB.cylinder(0.3, 7, WD, AB.offset(originCF, 2.3, 0, 1.5) * CFrame.Angles(math.rad(-30), 0, 0), model, "PeelStick")
	AB.block(Vector3.new(2.4, 0.2, 2.4), PEEL, AB.offset(originCF, 2.3, 3, 3) * CFrame.Angles(math.rad(-30), 0, 0), model, "PeelHead")
	-- Pizza on the peel
	AB.cylinder(2, 0.2, AB.colors.pizzaCrust,
		AB.offset(originCF, 2.3, 3.1, 3) * CFrame.Angles(math.rad(-30), 0, math.rad(90)), model, "PeelPizza")
	AB.sphere(0.3, AB.colors.pizzaRed,
		AB.offset(originCF, 2.0, 3.2, 3) * CFrame.Angles(math.rad(-30), 0, 0), model, "PeelPepperoni1")
	AB.sphere(0.3, AB.colors.pizzaRed,
		AB.offset(originCF, 2.6, 3.3, 3) * CFrame.Angles(math.rad(-30), 0, 0), model, "PeelPepperoni2")

	AB.billboard(head, NAME, Vector2.new(220, 40), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
