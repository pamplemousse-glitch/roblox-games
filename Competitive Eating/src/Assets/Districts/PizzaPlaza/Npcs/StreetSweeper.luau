-- Street Sweeper — municipal worker with a wide broom, orange vest, cap.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Giovanni"
local SKIN    = Color3.fromRGB(235, 200, 165)
local SHIRT   = Color3.fromRGB(60, 70, 90)
local VEST_OR = Color3.fromRGB(255, 150, 50)
local STRIPE  = Color3.fromRGB(200, 200, 210)
local PANTS_GR= Color3.fromRGB(60, 75, 60)
local CAP     = Color3.fromRGB(40, 60, 100)
local HAIR    = Color3.fromRGB(70, 50, 35)
local BOOT_BR = Color3.fromRGB(60, 40, 30)
local BROOM_HD= Color3.fromRGB(180, 130, 70)
local BRSTLE  = Color3.fromRGB(220, 180, 130)
local WD      = Color3.fromRGB(110, 75, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (blue shirt)
	local torso = AB.part({size=Vector3.new(2.7, 3, 1.3), color=SHIRT,
		cf=originCF, canCollide=false, name="Torso"}, model)
	-- Orange high-vis vest
	AB.part({size=Vector3.new(2.75, 2.5, 1.35), color=VEST_OR,
		cf=AB.offset(originCF, 0, -0.1, 0), canCollide=false, name="Vest"}, model)
	-- Reflective stripes (2 horizontal)
	AB.block(Vector3.new(2.8, 0.3, 1.4), STRIPE, AB.offset(originCF, 0, 0.5, 0), model, "StripeTop")
	AB.block(Vector3.new(2.8, 0.3, 1.4), STRIPE, AB.offset(originCF, 0, -0.7, 0), model, "StripeBot")
	-- Vest front zipper
	AB.block(Vector3.new(0.1, 2.4, 0.1), Color3.fromRGB(180, 180, 190),
		AB.offset(originCF, 0, -0.1, 0.7), model, "Zipper")
	-- Pants
	AB.part({size=Vector3.new(2.7, 0.4, 1.3), color=PANTS_GR,
		cf=AB.offset(originCF, 0, -1.65, 0), canCollide=false, name="Belt"}, model)
	AB.part({size=Vector3.new(2.7, 1.8, 1.3), color=PANTS_GR,
		cf=AB.offset(originCF, 0, -2.75, 0), canCollide=false, name="Pants"}, model)
	-- Knee pads (darker patch)
	AB.block(Vector3.new(0.9, 0.6, 0.2), Color3.fromRGB(40, 50, 40),
		AB.offset(originCF, -0.6, -3, 0.7), model, "KneeL")
	AB.block(Vector3.new(0.9, 0.6, 0.2), Color3.fromRGB(40, 50, 40),
		AB.offset(originCF, 0.6, -3, 0.7), model, "KneeR")
	-- Brown work boots
	AB.part({size=Vector3.new(0.9, 0.7, 1.4), color=BOOT_BR,
		cf=AB.offset(originCF, -0.6, -3.9, 0.3), canCollide=false, name="BootL"}, model)
	AB.part({size=Vector3.new(0.9, 0.7, 1.4), color=BOOT_BR,
		cf=AB.offset(originCF, 0.6, -3.9, 0.3), canCollide=false, name="BootR"}, model)

	-- Head
	local head = AB.part({size=Vector3.new(1.85, 1.85, 1.85), color=SKIN,
		cf=AB.offset(originCF, 0, 2.5, 0), shape=Enum.PartType.Ball, canCollide=false, name="Head"}, model)
	-- Worker's cap (with brim)
	AB.part({size=Vector3.new(2, 0.5, 2), color=CAP,
		cf=AB.offset(originCF, 0, 3.3, 0), canCollide=false, name="CapTop"}, model)
	AB.wedge(Vector3.new(0.3, 0.6, 1.4), CAP,
		AB.offset(originCF, 0, 3.3, 0.9) * CFrame.Angles(math.rad(90), 0, 0), model, "CapBrim")
	-- Hair sticking out from sides
	AB.sphere(0.3, HAIR, AB.offset(originCF, -0.85, 2.7, -0.1), model, "HairL")
	AB.sphere(0.3, HAIR, AB.offset(originCF, 0.85, 2.7, -0.1), model, "HairR")
	-- Tired eyes
	AB.block(Vector3.new(0.35, 0.08, 0.1), Color3.fromRGB(60, 40, 35),
		AB.offset(originCF, -0.4, 2.55, 0.88), model, "EyeL")
	AB.block(Vector3.new(0.35, 0.08, 0.1), Color3.fromRGB(60, 40, 35),
		AB.offset(originCF, 0.4, 2.55, 0.88), model, "EyeR")
	-- Stubble
	AB.part({size=Vector3.new(1.4, 0.4, 0.5), color=Color3.fromRGB(120, 90, 70),
		cf=AB.offset(originCF, 0, 2, 0.78), canCollide=false, name="Stubble"}, model)
	-- Cigarette in mouth
	AB.cylinder(0.08, 0.6, Color3.fromRGB(240, 230, 200),
		AB.offset(originCF, 0.5, 2.05, 1.1) * CFrame.Angles(0, math.rad(90), math.rad(90)), model, "Cig")
	local ember = AB.sphere(0.08, Color3.fromRGB(255, 100, 30),
		AB.offset(originCF, 0.85, 2.05, 1.1), model, "CigEmber")
	AB.neon(ember)
	-- Smoke wisp
	local smoke = AB.sphere(0.15, Color3.fromRGB(240, 240, 240),
		AB.offset(originCF, 1.1, 2.5, 1.1), model, "SmokeWisp")
	smoke.Transparency = 0.6

	-- Arms (both gripping broom handle in front)
	AB.part({size=Vector3.new(0.9, 2.4, 0.9), color=VEST_OR,
		cf=AB.offset(originCF, -1.7, -0.2, 0.7) * CFrame.Angles(math.rad(-45), 0, 0), canCollide=false, name="ArmL"}, model)
	AB.part({size=Vector3.new(0.9, 2.4, 0.9), color=VEST_OR,
		cf=AB.offset(originCF, 1.7, -0.2, 0.7) * CFrame.Angles(math.rad(-45), 0, 0), canCollide=false, name="ArmR"}, model)
	-- Hands
	AB.sphere(0.5, SKIN, AB.offset(originCF, -1.7, -1.4, 1.8), model, "HandL")
	AB.sphere(0.5, SKIN, AB.offset(originCF, 1.7, -1.4, 1.8), model, "HandR")
	-- Work gloves (yellow tip)
	AB.cylinder(0.55, 0.25, Color3.fromRGB(220, 180, 80),
		AB.offset(originCF, -1.7, -1.6, 1.8) * CFrame.Angles(0, 0, math.rad(90)), model, "GloveL")
	AB.cylinder(0.55, 0.25, Color3.fromRGB(220, 180, 80),
		AB.offset(originCF, 1.7, -1.6, 1.8) * CFrame.Angles(0, 0, math.rad(90)), model, "GloveR")

	-- Broom (handle + bristles)
	AB.cylinder(0.25, 7, WD,
		AB.offset(originCF, 0, -0.5, 2.2) * CFrame.Angles(math.rad(-30), 0, 0), model, "BroomHandle")
	-- Broom head (wider block)
	AB.block(Vector3.new(3, 0.5, 1.2), BROOM_HD,
		AB.offset(originCF, 0, -3.2, 4.5), model, "BroomHead")
	-- Broom bristles (8 rows)
	for i = -3, 3 do
		AB.block(Vector3.new(0.2, 0.8, 1), BRSTLE,
			AB.offset(originCF, i * 0.4, -3.8, 4.5), model, "Bristle_" .. (i + 4))
	end
	-- Bristle binding (metal band)
	AB.block(Vector3.new(3.1, 0.2, 1.3), Color3.fromRGB(180, 180, 190),
		AB.offset(originCF, 0, -3, 4.5), model, "BristleBand")

	-- Pile of swept debris on the ground in front of the broom
	for i = 1, 6 do
		local trashCol = (i % 3 == 0) and Color3.fromRGB(220, 60, 50) or (i % 3 == 1) and Color3.fromRGB(240, 220, 80) or Color3.fromRGB(80, 80, 90)
		AB.sphere(0.2 + math.random() * 0.15, trashCol,
			AB.offset(originCF, (math.random() - 0.5) * 2.5, -4.2, 4.5 + (math.random() - 0.5) * 0.6), model, "Trash_" .. i)
	end

	-- Small dustpan on belt
	AB.block(Vector3.new(1, 0.4, 0.8), Color3.fromRGB(180, 50, 50),
		AB.offset(originCF, 1.5, -1.6, -0.4), model, "Dustpan")

	AB.billboard(head, NAME, Vector2.new(220, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
