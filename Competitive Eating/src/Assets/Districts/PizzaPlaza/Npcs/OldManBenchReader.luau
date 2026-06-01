-- Old Man Bench Reader — seated elderly man reading a newspaper, flat cap,
-- on a small bench. Iconic Italian street scene.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Nonno Giuseppe"
local SKIN    = Color3.fromRGB(235, 200, 165)
local CAP     = Color3.fromRGB(100, 80, 60)
local CARDIGAN= Color3.fromRGB(120, 90, 60)
local SHIRT   = Color3.fromRGB(245, 240, 230)
local PANTS   = Color3.fromRGB(60, 60, 70)
local HAIR    = Color3.fromRGB(180, 180, 185)
local PAPER   = Color3.fromRGB(245, 240, 230)
local TXT_DK  = Color3.fromRGB(40, 40, 45)
local WD      = Color3.fromRGB(110, 75, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Bench he's sitting on
	AB.block(Vector3.new(5, 0.3, 1.5), WD, AB.offset(originCF, 0, -2, 0), model, "BenchSeat")
	AB.block(Vector3.new(5, 2, 0.3), WD, AB.offset(originCF, 0, -1, -0.8), model, "BenchBack")
	for i, sx in {-2, 2} do
		AB.block(Vector3.new(0.3, 2.5, 1.5), Color3.fromRGB(80, 50, 30),
			AB.offset(originCF, sx, -3, 0), model, "BenchLeg_" .. i)
	end

	-- Torso (cardigan, slumped/seated)
	local torso = AB.part({size=Vector3.new(2.5, 2.5, 1.2), color=CARDIGAN,
		cf=AB.offset(originCF, 0, -0.5, 0), canCollide=false, name="Torso"}, model)
	-- Shirt collar
	AB.part({size=Vector3.new(1, 0.4, 0.3), color=SHIRT,
		cf=AB.offset(originCF, 0, 0.7, 0.6), canCollide=false, name="Collar"}, model)
	-- Cardigan buttons
	for i, y in {0.3, -0.2, -0.7} do
		AB.sphere(0.12, Color3.fromRGB(80, 60, 50), AB.offset(originCF, 0, y, 0.65), model, "Button_" .. i)
	end
	-- Pants (legs out forward)
	AB.part({size=Vector3.new(0.9, 0.6, 2.5), color=PANTS,
		cf=AB.offset(originCF, -0.6, -2.1, 0.8), canCollide=false, name="LegL"}, model)
	AB.part({size=Vector3.new(0.9, 0.6, 2.5), color=PANTS,
		cf=AB.offset(originCF, 0.6, -2.1, 0.8), canCollide=false, name="LegR"}, model)
	-- Shoes
	AB.part({size=Vector3.new(0.9, 0.5, 1.4), color=Color3.fromRGB(60, 40, 35),
		cf=AB.offset(originCF, -0.6, -2.45, 2.3), canCollide=false, name="ShoeL"}, model)
	AB.part({size=Vector3.new(0.9, 0.5, 1.4), color=Color3.fromRGB(60, 40, 35),
		cf=AB.offset(originCF, 0.6, -2.45, 2.3), canCollide=false, name="ShoeR"}, model)

	-- Head
	local head = AB.part({size=Vector3.new(1.8, 1.8, 1.8), color=SKIN,
		cf=AB.offset(originCF, 0, 1.6, 0), shape=Enum.PartType.Ball, canCollide=false, name="Head"}, model)
	-- Grey hair on sides
	AB.part({size=Vector3.new(1.85, 0.5, 1.85), color=HAIR,
		cf=AB.offset(originCF, 0, 2, -0.1), canCollide=false, name="HairSides"}, model)
	-- Flat cap
	AB.part({size=Vector3.new(2, 0.5, 2), color=CAP,
		cf=AB.offset(originCF, 0, 2.4, 0), canCollide=false, name="CapBody"}, model)
	AB.wedge(Vector3.new(0.4, 0.6, 1.4), CAP,
		AB.offset(originCF, 0, 2.4, 0.95) * CFrame.Angles(math.rad(90), 0, 0), model, "CapBrim")
	-- Glasses
	AB.block(Vector3.new(0.4, 0.4, 0.05), TXT_DK, AB.offset(originCF, -0.4, 1.7, 0.92), model, "GlassL")
	AB.block(Vector3.new(0.4, 0.4, 0.05), TXT_DK, AB.offset(originCF, 0.4, 1.7, 0.92), model, "GlassR")
	AB.block(Vector3.new(0.4, 0.04, 0.04), TXT_DK, AB.offset(originCF, 0, 1.7, 0.92), model, "GlassBridge")
	-- Mustache (grey)
	AB.block(Vector3.new(1.2, 0.25, 0.4), HAIR, AB.offset(originCF, 0, 1.2, 0.85), model, "Mustache")

	-- Arms (holding newspaper in front)
	AB.part({size=Vector3.new(0.85, 1.8, 0.85), color=CARDIGAN,
		cf=AB.offset(originCF, -1.3, 0, 0.5) * CFrame.Angles(math.rad(-60), 0, 0), canCollide=false, name="ArmL"}, model)
	AB.part({size=Vector3.new(0.85, 1.8, 0.85), color=CARDIGAN,
		cf=AB.offset(originCF, 1.3, 0, 0.5) * CFrame.Angles(math.rad(-60), 0, 0), canCollide=false, name="ArmR"}, model)
	-- Hands
	AB.sphere(0.4, SKIN, AB.offset(originCF, -1.3, -0.4, 1.7), model, "HandL")
	AB.sphere(0.4, SKIN, AB.offset(originCF, 1.3, -0.4, 1.7), model, "HandR")

	-- Newspaper (held open)
	AB.block(Vector3.new(3.2, 2.4, 0.1), PAPER,
		AB.offset(originCF, 0, -0.2, 2) * CFrame.Angles(math.rad(-15), 0, 0), model, "Newspaper")
	-- Newspaper fold (center)
	AB.block(Vector3.new(0.05, 2.4, 0.12), Color3.fromRGB(180, 175, 170),
		AB.offset(originCF, 0, -0.2, 2) * CFrame.Angles(math.rad(-15), 0, 0), model, "Fold")
	-- Masthead (red bar)
	AB.block(Vector3.new(2.8, 0.4, 0.04), Color3.fromRGB(180, 30, 40),
		AB.offset(originCF, 0, 0.7, 2.05) * CFrame.Angles(math.rad(-15), 0, 0), model, "Masthead")
	-- Headline
	AB.block(Vector3.new(2.6, 0.25, 0.04), TXT_DK,
		AB.offset(originCF, 0, 0.2, 2.05) * CFrame.Angles(math.rad(-15), 0, 0), model, "Headline")
	-- Sub-lines
	for i = 1, 4 do
		AB.block(Vector3.new(2.4, 0.06, 0.04), Color3.fromRGB(110, 110, 110),
			AB.offset(originCF, 0, -0.1 - i * 0.2, 2.05) * CFrame.Angles(math.rad(-15), 0, 0), model, "NewsLine_" .. i)
	end

	-- Coffee cup beside on bench
	AB.cylinder(0.5, 0.8, PAPER, AB.offset(originCF, 2.2, -1.4, 0.4), model, "Cup")
	AB.cylinder(0.4, 0.2, Color3.fromRGB(60, 35, 20),
		AB.offset(originCF, 2.2, -0.9, 0.4) * CFrame.Angles(0, 0, math.rad(90)), model, "CupCoffee")

	AB.billboard(head, NAME, Vector2.new(260, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
