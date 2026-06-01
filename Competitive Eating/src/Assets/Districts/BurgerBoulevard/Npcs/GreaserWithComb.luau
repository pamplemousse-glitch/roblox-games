-- GreaserWithComb — slicked-back hair, leather jacket, jeans, holding a comb.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN    = Color3.fromRGB(225, 185, 145)
local LEATHER = Color3.fromRGB(40, 40, 45)
local DENIM   = Color3.fromRGB(70, 80, 110)
local WHITE_T = Color3.fromRGB(245, 245, 240)
local HAIR_BL = Color3.fromRGB(20, 20, 25)
local DARK    = Color3.fromRGB(30, 30, 35)
local SHOE_BR = Color3.fromRGB(70, 50, 35)
local CHROME  = Color3.fromRGB(176, 176, 176)
local RED     = Color3.fromRGB(220, 50, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GreaserWithComb", parent)

	-- Boots
	AB.block(Vector3.new(0.9, 0.6, 1.2), SHOE_BR, AB.offset(originCF, -0.4, 0.3, 0.2), model, "BootL")
	AB.block(Vector3.new(0.9, 0.6, 1.2), SHOE_BR, AB.offset(originCF,  0.4, 0.3, 0.2), model, "BootR")
	-- Legs (cuffed jeans)
	AB.block(Vector3.new(0.75, 2.3, 0.75), DENIM, AB.offset(originCF, -0.4, 1.7, 0), model, "LegL")
	AB.block(Vector3.new(0.75, 2.3, 0.75), DENIM, AB.offset(originCF,  0.4, 1.7, 0), model, "LegR")
	-- Cuff at bottom (lighter denim)
	AB.block(Vector3.new(0.8, 0.3, 0.8), DENIM:Lerp(WHITE_T, 0.3), AB.offset(originCF, -0.4, 0.7, 0), model, "CuffL")
	AB.block(Vector3.new(0.8, 0.3, 0.8), DENIM:Lerp(WHITE_T, 0.3), AB.offset(originCF,  0.4, 0.7, 0), model, "CuffR")

	-- Torso (leather jacket open over white tee)
	local torso = AB.block(Vector3.new(2.1, 2.5, 1.1), LEATHER, AB.offset(originCF, 0, 4.2, 0), model, "Torso")
	torso.Material = Enum.Material.SmoothPlastic
	torso.Reflectance = 0.08
	-- White t-shirt
	AB.block(Vector3.new(0.8, 1.8, 0.08), WHITE_T, AB.offset(originCF, 0, 4.4, 0.58), model, "Tee")
	-- Jacket collar
	AB.block(Vector3.new(0.3, 0.6, 0.4), LEATHER, AB.offset(originCF, -0.7, 5.3, 0.4) * CFrame.Angles(0, 0, math.rad(15)), model, "CollarL")
	AB.block(Vector3.new(0.3, 0.6, 0.4), LEATHER, AB.offset(originCF,  0.7, 5.3, 0.4) * CFrame.Angles(0, 0, math.rad(-15)), model, "CollarR")
	-- Chrome jacket zipper
	AB.block(Vector3.new(0.1, 2.4, 0.05), CHROME, AB.offset(originCF, -0.4, 4.2, 0.6), model, "Zipper")
	-- Jacket button studs
	for i, y in {3.6, 4.2, 4.8} do
		AB.sphere(0.1, CHROME, AB.offset(originCF, -0.95, y, 0.6), model, "Stud_" .. i)
	end

	-- Arms (leather)
	AB.block(Vector3.new(0.65, 2, 0.65), LEATHER, AB.offset(originCF, -1.35, 4, 0), model, "ArmL")
	-- Right arm at angle holding comb up to hair
	AB.block(Vector3.new(0.65, 2, 0.65), LEATHER, AB.offset(originCF, 1, 5, 0.3) * CFrame.Angles(0, 0, math.rad(-50)), model, "ArmR")
	-- Hands
	AB.sphere(0.55, SKIN, AB.offset(originCF, -1.35, 2.9, 0), model, "HandL")
	AB.sphere(0.55, SKIN, AB.offset(originCF, 1.7, 6.1, 0.4), model, "HandR")

	-- Comb in right hand
	AB.block(Vector3.new(0.5, 0.08, 1.2), DARK, AB.offset(originCF, 1.7, 6.3, 0.4), model, "Comb")
	-- Comb teeth (6 small lines)
	for i = 0, 5 do
		AB.block(Vector3.new(0.05, 0.4, 0.1), DARK, AB.offset(originCF, 1.7, 6.6, -0.1 + i * 0.18), model, "CombTooth_" .. i)
	end

	-- Head
	AB.sphere(1.35, SKIN, AB.offset(originCF, 0, 6.4, 0), model, "Head")
	-- Slicked-back hair (huge pompadour)
	AB.sphere(1.5, HAIR_BL, AB.offset(originCF, 0, 7, -0.05), model, "HairBack")
	-- Pompadour swoop at front
	AB.sphere(1.2, HAIR_BL, AB.offset(originCF, 0, 7.5, 0.3), model, "Pompadour")
	AB.block(Vector3.new(1.2, 0.5, 0.4), HAIR_BL, AB.offset(originCF, 0, 7.7, 0.4), model, "PompFront")
	-- Sideburns (long)
	AB.block(Vector3.new(0.2, 1, 0.4), HAIR_BL, AB.offset(originCF, -0.85, 6, 0.3), model, "SideburnL")
	AB.block(Vector3.new(0.2, 1, 0.4), HAIR_BL, AB.offset(originCF,  0.85, 6, 0.3), model, "SideburnR")

	-- Eyes (squinty cool)
	AB.block(Vector3.new(0.3, 0.08, 0.05), DARK, AB.offset(originCF, -0.3, 6.4, 0.68), model, "EyeL")
	AB.block(Vector3.new(0.3, 0.08, 0.05), DARK, AB.offset(originCF,  0.3, 6.4, 0.68), model, "EyeR")
	-- Smirk
	AB.block(Vector3.new(0.5, 0.08, 0.08), DARK, AB.offset(originCF, 0.15, 5.95, 0.7) * CFrame.Angles(0, 0, math.rad(-5)), model, "Smirk")
	-- Cigarette dangling from mouth
	AB.cylinder(0.07, 0.8, WHITE_T, AB.offset(originCF, 0.5, 5.95, 0.75) * CFrame.Angles(0, math.rad(90), 0), model, "Cigarette")
	-- Cigarette glowing tip
	local tip = AB.sphere(0.08, RED, AB.offset(originCF, 0.9, 5.95, 0.75), model, "CigTip")
	AB.neon(tip); AB.glow(tip, RED, 0.4)

	AB.billboard(torso, "Greaser", Vector2.new(180, 36), 4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
