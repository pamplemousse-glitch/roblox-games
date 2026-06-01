-- Carmela — Mamma Carmela herself. Older Italian woman in a floral dress
-- and apron, hair in a bun, holding a wooden spoon and a pot of sauce.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Carmela"
local SKIN    = Color3.fromRGB(240, 210, 175)
local DRESS   = Color3.fromRGB(150, 50, 50)
local APRON   = Color3.fromRGB(245, 240, 230)
local FLOWERS = Color3.fromRGB(240, 220, 80)
local HAIR    = Color3.fromRGB(160, 160, 165)
local POT_BLK = Color3.fromRGB(40, 40, 45)
local SAUCE_R = Color3.fromRGB(180, 40, 35)
local WD      = Color3.fromRGB(110, 75, 45)
local CHEEK_R = Color3.fromRGB(240, 160, 150)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (floral dress)
	local torso = AB.part({size=Vector3.new(2.8, 3, 1.4), color=DRESS,
		cf=originCF, canCollide=false, name="Torso"}, model)
	-- Flower pattern (yellow dots on dress)
	for i, off in {Vector3.new(-0.7, 0.5, 0), Vector3.new(0.7, 0.7, 0), Vector3.new(-0.5, -0.5, 0), Vector3.new(0.6, -0.4, 0)} do
		AB.sphere(0.18, FLOWERS, AB.offset(originCF, off.X, off.Y, 0.75), model, "Flower_" .. i)
	end
	-- Apron (white, with frilly edge)
	AB.part({size=Vector3.new(2.4, 2.5, 0.15), color=APRON,
		cf=AB.offset(originCF, 0, -0.2, 0.78), canCollide=false, name="Apron"}, model)
	-- Apron strap
	AB.part({size=Vector3.new(0.3, 1.8, 0.1), color=APRON,
		cf=AB.offset(originCF, -0.8, 1.4, 0.78), canCollide=false, name="StrapL"}, model)
	AB.part({size=Vector3.new(0.3, 1.8, 0.1), color=APRON,
		cf=AB.offset(originCF, 0.8, 1.4, 0.78), canCollide=false, name="StrapR"}, model)
	-- Apron pocket
	AB.part({size=Vector3.new(0.6, 0.8, 0.1), color=Color3.fromRGB(220, 215, 200),
		cf=AB.offset(originCF, 0.4, -0.4, 0.85), canCollide=false, name="Pocket"}, model)
	-- Dress hem (lower puff)
	AB.part({size=Vector3.new(3.2, 0.6, 1.6), color=DRESS,
		cf=AB.offset(originCF, 0, -1.7, 0), canCollide=false, name="Hem"}, model)

	-- Head
	local head = AB.part({size=Vector3.new(1.9, 1.9, 1.9), color=SKIN,
		cf=AB.offset(originCF, 0, 2.5, 0), shape=Enum.PartType.Ball, canCollide=false, name="Head"}, model)
	-- Hair bun (round on top)
	AB.sphere(1, HAIR, AB.offset(originCF, 0, 3.6, -0.3), model, "Bun")
	-- Hair on sides (small grey blocks)
	AB.part({size=Vector3.new(2, 0.5, 1.5), color=HAIR,
		cf=AB.offset(originCF, 0, 3, -0.4), canCollide=false, name="HairBack"}, model)
	-- Cheeks (rosy)
	AB.sphere(0.3, CHEEK_R, AB.offset(originCF, -0.6, 2.4, 0.85), model, "CheekL")
	AB.sphere(0.3, CHEEK_R, AB.offset(originCF, 0.6, 2.4, 0.85), model, "CheekR")
	-- Eyes (closed, smiling — small dark arcs)
	AB.block(Vector3.new(0.3, 0.05, 0.1), Color3.fromRGB(60, 40, 35),
		AB.offset(originCF, -0.4, 2.7, 0.93), model, "EyeL")
	AB.block(Vector3.new(0.3, 0.05, 0.1), Color3.fromRGB(60, 40, 35),
		AB.offset(originCF, 0.4, 2.7, 0.93), model, "EyeR")
	-- Smile
	AB.block(Vector3.new(0.6, 0.08, 0.1), Color3.fromRGB(140, 70, 70),
		AB.offset(originCF, 0, 2.1, 0.93), model, "Smile")

	-- Arms forward
	AB.part({size=Vector3.new(0.95, 2.4, 0.95), color=DRESS,
		cf=AB.offset(originCF, -1.8, 0, 0.3) * CFrame.Angles(math.rad(-30), 0, 0), canCollide=false, name="ArmL"}, model)
	AB.part({size=Vector3.new(0.95, 2.4, 0.95), color=DRESS,
		cf=AB.offset(originCF, 1.8, 0, 0.3) * CFrame.Angles(math.rad(-30), 0, 0), canCollide=false, name="ArmR"}, model)
	-- Hands
	AB.sphere(0.5, SKIN, AB.offset(originCF, -1.8, -1, 1.4), model, "HandL")
	AB.sphere(0.5, SKIN, AB.offset(originCF, 1.8, -1, 1.4), model, "HandR")

	-- Big pot of sauce (carried in left hand)
	AB.cylinder(1.6, 1.6, POT_BLK,
		AB.offset(originCF, -1.8, -0.5, 2.5), model, "Pot")
	AB.cylinder(1.65, 0.2, Color3.fromRGB(60, 60, 65),
		AB.offset(originCF, -1.8, 0.3, 2.5) * CFrame.Angles(0, 0, math.rad(90)), model, "PotRim")
	-- Sauce inside
	AB.cylinder(1.45, 0.3, SAUCE_R,
		AB.offset(originCF, -1.8, 0.25, 2.5) * CFrame.Angles(0, 0, math.rad(90)), model, "Sauce")
	-- Steam from sauce
	local s1 = AB.sphere(0.7, Color3.fromRGB(240, 240, 240), AB.offset(originCF, -1.8, 1, 2.5), model, "Steam1"); s1.Transparency = 0.55
	local s2 = AB.sphere(0.9, Color3.fromRGB(240, 240, 240), AB.offset(originCF, -1.8, 2, 2.6), model, "Steam2"); s2.Transparency = 0.75
	-- Pot handle (left side)
	AB.cylinder(0.2, 0.7, POT_BLK,
		AB.offset(originCF, -3.2, -0.3, 2.5) * CFrame.Angles(0, 0, math.rad(90)), model, "PotHandle")

	-- Wooden spoon in right hand
	AB.cylinder(0.2, 3, WD,
		AB.offset(originCF, 1.8, -0.2, 2.5) * CFrame.Angles(math.rad(-20), 0, 0), model, "Spoon")
	AB.cylinder(0.6, 0.4, WD,
		AB.offset(originCF, 1.8, 0.6, 3.5) * CFrame.Angles(math.rad(-20), 0, math.rad(90)), model, "SpoonHead")
	-- Sauce on spoon
	AB.sphere(0.25, SAUCE_R, AB.offset(originCF, 1.8, 0.7, 3.5), model, "SauceDrip")

	AB.billboard(head, NAME, Vector2.new(220, 40), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
