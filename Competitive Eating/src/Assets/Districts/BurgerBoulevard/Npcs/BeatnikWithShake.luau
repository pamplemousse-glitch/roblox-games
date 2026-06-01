-- BeatnikWithShake — black turtleneck, beret, holding a shake; serious expression.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN    = Color3.fromRGB(220, 175, 130)
local BLACK   = Color3.fromRGB(25, 25, 30)
local PANTS   = Color3.fromRGB(25, 25, 30)
local SHOE    = Color3.fromRGB(40, 40, 45)
local CHROME  = Color3.fromRGB(176, 176, 176)
local PINK_M  = Color3.fromRGB(255, 200, 215)
local WHITE   = Color3.fromRGB(245, 245, 240)
local RED     = Color3.fromRGB(220, 50, 50)
local DARK    = Color3.fromRGB(30, 30, 35)
local BERET_B = Color3.fromRGB(45, 35, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BeatnikWithShake", parent)

	-- Shoes
	AB.block(Vector3.new(0.8, 0.4, 1.1), SHOE, AB.offset(originCF, -0.4, 0.2, 0.2), model, "ShoeL")
	AB.block(Vector3.new(0.8, 0.4, 1.1), SHOE, AB.offset(originCF,  0.4, 0.2, 0.2), model, "ShoeR")
	-- Legs (black slacks)
	AB.block(Vector3.new(0.7, 2.4, 0.7), PANTS, AB.offset(originCF, -0.4, 1.6, 0), model, "LegL")
	AB.block(Vector3.new(0.7, 2.4, 0.7), PANTS, AB.offset(originCF,  0.4, 1.6, 0), model, "LegR")
	-- Belt
	AB.block(Vector3.new(1.8, 0.3, 1), DARK, AB.offset(originCF, 0, 3, 0), model, "Belt")

	-- Torso (black turtleneck)
	local torso = AB.block(Vector3.new(2, 2.5, 1), BLACK, AB.offset(originCF, 0, 4.4, 0), model, "Torso")
	-- Turtleneck collar (raised black)
	AB.cylinder(0.9, 0.7, BLACK, AB.offset(originCF, 0, 5.9, 0), model, "TurtleneckCollar")

	-- Arms (one holding shake)
	AB.block(Vector3.new(0.55, 2, 0.55), BLACK, AB.offset(originCF, -1.25, 4.2, 0), model, "ArmL")
	AB.block(Vector3.new(0.55, 1.8, 0.55), BLACK, AB.offset(originCF, 1.1, 4.5, 0.4) * CFrame.Angles(0, 0, math.rad(-30)), model, "ArmR")
	AB.sphere(0.5, SKIN, AB.offset(originCF, -1.25, 3.2, 0), model, "HandL")
	AB.sphere(0.5, SKIN, AB.offset(originCF, 1.7, 5.4, 0.7), model, "HandR")

	-- Milkshake in right hand
	-- Glass
	local glass = AB.cylinder(0.9, 1.8, Color3.fromRGB(220, 240, 255), AB.offset(originCF, 1.7, 5.9, 0.7), model, "ShakeGlass")
	glass.Material = Enum.Material.Glass; glass.Transparency = 0.45
	-- Pink shake inside
	AB.cylinder(0.7, 1.5, PINK_M, AB.offset(originCF, 1.7, 5.85, 0.7), model, "ShakeContent")
	-- Whipped cream
	AB.sphere(0.8, WHITE, AB.offset(originCF, 1.7, 7, 0.7), model, "Whip")
	-- Cherry
	AB.sphere(0.2, RED, AB.offset(originCF, 1.7, 7.5, 0.7), model, "Cherry")
	-- Straw
	AB.cylinder(0.1, 2, RED, AB.offset(originCF, 1.85, 7.2, 0.7), model, "Straw")

	-- Head
	AB.sphere(1.35, SKIN, AB.offset(originCF, 0, 7, 0), model, "Head")
	-- Beret (purple-black, tilted)
	AB.cylinder(2, 0.4, BERET_B, AB.offset(originCF, 0, 7.9, 0) * CFrame.Angles(math.rad(-12), 0, math.rad(8)), model, "Beret")
	-- Beret stem (the little nub)
	AB.sphere(0.25, BERET_B, AB.offset(originCF, 0, 8.3, 0), model, "BeretStem")

	-- Goatee
	AB.block(Vector3.new(0.4, 0.4, 0.2), DARK, AB.offset(originCF, 0, 6.4, 0.7), model, "Goatee")
	-- Mustache (thin)
	AB.block(Vector3.new(0.8, 0.08, 0.1), DARK, AB.offset(originCF, 0, 6.7, 0.7), model, "Mustache")

	-- Beatnik shades (black bar across eyes)
	AB.block(Vector3.new(1.5, 0.3, 0.1), DARK, AB.offset(originCF, 0, 7.1, 0.7), model, "Shades")
	-- Sideburns
	AB.block(Vector3.new(0.15, 0.5, 0.3), DARK, AB.offset(originCF, -0.85, 6.7, 0.25), model, "SideburnL")
	AB.block(Vector3.new(0.15, 0.5, 0.3), DARK, AB.offset(originCF,  0.85, 6.7, 0.25), model, "SideburnR")

	-- Bongos under arm (small wood cylinder pair)
	AB.cylinder(0.7, 0.8, Color3.fromRGB(120, 70, 40), AB.offset(originCF, -1.6, 3, 0), model, "BongoL")
	AB.cylinder(0.6, 0.8, Color3.fromRGB(120, 70, 40), AB.offset(originCF, -2.1, 3, 0), model, "BongoR")

	AB.billboard(torso, "Beatnik", Vector2.new(180, 36), 4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
