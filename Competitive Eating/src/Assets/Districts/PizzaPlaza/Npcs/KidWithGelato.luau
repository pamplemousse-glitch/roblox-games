-- Kid with Gelato — small child holding a triple-scoop gelato cone, big grin.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Mia"
local SKIN    = Color3.fromRGB(245, 215, 175)
local SHIRT   = Color3.fromRGB(255, 180, 200)
local OVERALL = Color3.fromRGB(80, 120, 180)
local HAIR    = Color3.fromRGB(120, 80, 50)
local SHOE    = Color3.fromRGB(220, 60, 60)
local CONE    = Color3.fromRGB(220, 180, 110)
local SCOOP1  = Color3.fromRGB(255, 130, 150)
local SCOOP2  = Color3.fromRGB(180, 220, 130)
local SCOOP3  = Color3.fromRGB(120, 80, 50)
local STAIN_P = Color3.fromRGB(255, 130, 150)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Small torso (shorter scale)
	local torso = AB.part({size=Vector3.new(1.8, 2, 0.9), color=SHIRT,
		cf=originCF, canCollide=false, name="Torso"}, model)
	-- Overalls (blue front)
	AB.part({size=Vector3.new(1.6, 1.6, 0.15), color=OVERALL,
		cf=AB.offset(originCF, 0, -0.2, 0.5), canCollide=false, name="OverallFront"}, model)
	-- Overall straps
	AB.part({size=Vector3.new(0.3, 1.5, 0.1), color=OVERALL,
		cf=AB.offset(originCF, -0.5, 1, 0.5), canCollide=false, name="StrapL"}, model)
	AB.part({size=Vector3.new(0.3, 1.5, 0.1), color=OVERALL,
		cf=AB.offset(originCF, 0.5, 1, 0.5), canCollide=false, name="StrapR"}, model)
	-- Overall buttons (silver dots)
	AB.sphere(0.1, Color3.fromRGB(200, 200, 210), AB.offset(originCF, -0.5, 0.4, 0.6), model, "Button1")
	AB.sphere(0.1, Color3.fromRGB(200, 200, 210), AB.offset(originCF, 0.5, 0.4, 0.6), model, "Button2")
	-- Gelato stain on shirt (pink drip)
	AB.sphere(0.15, STAIN_P, AB.offset(originCF, 0.4, -0.5, 0.6), model, "Stain")
	-- Legs (short)
	AB.part({size=Vector3.new(0.7, 1.4, 0.7), color=OVERALL,
		cf=AB.offset(originCF, -0.4, -1.7, 0), canCollide=false, name="LegL"}, model)
	AB.part({size=Vector3.new(0.7, 1.4, 0.7), color=OVERALL,
		cf=AB.offset(originCF, 0.4, -1.7, 0), canCollide=false, name="LegR"}, model)
	-- Red sneakers
	AB.part({size=Vector3.new(0.8, 0.5, 1.2), color=SHOE,
		cf=AB.offset(originCF, -0.4, -2.6, 0.2), canCollide=false, name="ShoeL"}, model)
	AB.part({size=Vector3.new(0.8, 0.5, 1.2), color=SHOE,
		cf=AB.offset(originCF, 0.4, -2.6, 0.2), canCollide=false, name="ShoeR"}, model)

	-- Head (slightly larger proportionally — kid)
	local head = AB.part({size=Vector3.new(1.7, 1.7, 1.7), color=SKIN,
		cf=AB.offset(originCF, 0, 2, 0), shape=Enum.PartType.Ball, canCollide=false, name="Head"}, model)
	-- Curly brown hair
	AB.sphere(1.3, HAIR, AB.offset(originCF, 0, 2.6, 0), model, "Hair")
	AB.sphere(0.6, HAIR, AB.offset(originCF, -0.8, 2.4, 0), model, "HairBunL")
	AB.sphere(0.6, HAIR, AB.offset(originCF, 0.8, 2.4, 0), model, "HairBunR")
	-- Big eyes (white + dark pupils)
	AB.sphere(0.3, Color3.fromRGB(245, 240, 230), AB.offset(originCF, -0.35, 2, 0.85), model, "EyeWhiteL")
	AB.sphere(0.3, Color3.fromRGB(245, 240, 230), AB.offset(originCF, 0.35, 2, 0.85), model, "EyeWhiteR")
	AB.sphere(0.16, Color3.fromRGB(60, 40, 35), AB.offset(originCF, -0.35, 2, 0.95), model, "PupilL")
	AB.sphere(0.16, Color3.fromRGB(60, 40, 35), AB.offset(originCF, 0.35, 2, 0.95), model, "PupilR")
	-- Big toothy grin
	AB.block(Vector3.new(0.9, 0.3, 0.1), Color3.fromRGB(245, 240, 230), AB.offset(originCF, 0, 1.5, 0.9), model, "Grin")
	-- Rosy cheeks
	AB.sphere(0.18, Color3.fromRGB(255, 160, 160), AB.offset(originCF, -0.6, 1.7, 0.85), model, "CheekL")
	AB.sphere(0.18, Color3.fromRGB(255, 160, 160), AB.offset(originCF, 0.6, 1.7, 0.85), model, "CheekR")

	-- Arms up (holding gelato cone forward)
	AB.part({size=Vector3.new(0.6, 1.6, 0.6), color=SKIN,
		cf=AB.offset(originCF, -1.2, 0.2, 0.4) * CFrame.Angles(math.rad(-70), 0, 0), canCollide=false, name="ArmL"}, model)
	AB.part({size=Vector3.new(0.6, 1.6, 0.6), color=SKIN,
		cf=AB.offset(originCF, 1.2, 0.2, 0.4) * CFrame.Angles(math.rad(-70), 0, 0), canCollide=false, name="ArmR"}, model)
	-- Hands holding the cone
	AB.sphere(0.35, SKIN, AB.offset(originCF, -1.2, -0.3, 1.5), model, "HandL")
	AB.sphere(0.35, SKIN, AB.offset(originCF, 1.2, -0.3, 1.5), model, "HandR")

	-- Gelato cone (held forward, between hands)
	-- Cone (wedge pointing down)
	AB.wedge(Vector3.new(0.5, 1.5, 0.5), CONE,
		AB.offset(originCF, 0, 0.2, 1.6) * CFrame.Angles(math.rad(180), 0, math.rad(90)), model, "Cone")
	AB.wedge(Vector3.new(0.5, 1.5, 0.5), CONE,
		AB.offset(originCF, 0, 0.2, 1.6) * CFrame.Angles(math.rad(180), 0, math.rad(-90)), model, "Cone2")
	-- Cone waffle pattern (small dark lines)
	for i = -1, 1 do
		AB.block(Vector3.new(0.05, 1, 0.02), Color3.fromRGB(180, 130, 70),
			AB.offset(originCF, i * 0.2, 0.5, 1.55), model, "WafL_" .. (i + 2))
	end
	-- 3 scoops stacked on top
	AB.sphere(0.6, SCOOP3, AB.offset(originCF, 0, 1, 1.6), model, "Scoop3Choc")
	AB.sphere(0.6, SCOOP2, AB.offset(originCF, 0, 1.6, 1.5), model, "Scoop2Pist")
	AB.sphere(0.6, SCOOP1, AB.offset(originCF, 0, 2.2, 1.6), model, "Scoop1Strawb")
	-- Cherry on top
	AB.sphere(0.18, Color3.fromRGB(220, 30, 50), AB.offset(originCF, 0, 2.7, 1.6), model, "Cherry")
	AB.cylinder(0.04, 0.3, Color3.fromRGB(80, 140, 60), AB.offset(originCF, 0, 2.9, 1.6), model, "CherryStem")
	-- Drip running down
	AB.cylinder(0.1, 0.4, SCOOP1, AB.offset(originCF, 0.4, 1.5, 1.7), model, "Drip")

	AB.billboard(head, NAME, Vector2.new(180, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
