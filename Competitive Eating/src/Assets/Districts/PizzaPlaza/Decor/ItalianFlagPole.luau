-- Italian Flag Pole — tall freestanding flagpole with waving Italian tricolor.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local POLE_SLV = Color3.fromRGB(180, 180, 190)
local DK_STN   = Color3.fromRGB(110, 100, 95)
local GRN      = Color3.fromRGB(80, 140, 60)
local WHT      = Color3.fromRGB(245, 240, 230)
local RED      = Color3.fromRGB(200, 40, 40)
local GOLD     = Color3.fromRGB(220, 180, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ItalianFlagPole", parent)

	-- Stone base (square pyramid look)
	AB.block(Vector3.new(3, 0.8, 3), DK_STN, AB.offset(originCF, 0, 0.4, 0), model, "Base1")
	AB.block(Vector3.new(2.5, 0.6, 2.5), DK_STN, AB.offset(originCF, 0, 1.1, 0), model, "Base2")
	AB.block(Vector3.new(2, 0.4, 2), DK_STN, AB.offset(originCF, 0, 1.6, 0), model, "Base3")

	-- Main pole
	AB.cylinder(0.4, 18, POLE_SLV, AB.offset(originCF, 0, 11, 0), model, "Pole")
	-- Gold finial on top
	AB.sphere(0.7, GOLD, AB.offset(originCF, 0, 20.2, 0), model, "Finial")
	AB.sphere(0.4, GOLD, AB.offset(originCF, 0, 20.8, 0), model, "FinialTop")

	-- Flag (3 vertical stripes, slightly tilted as if waving)
	local flagY = 16
	local flagX = 2.2
	AB.block(Vector3.new(2, 4, 0.2), GRN, AB.offset(originCF, flagX, flagY, 0) * CFrame.Angles(0, math.rad(-5), 0), model, "FlagG")
	AB.block(Vector3.new(2, 4, 0.2), WHT, AB.offset(originCF, flagX + 2, flagY, -0.18) * CFrame.Angles(0, math.rad(-5), 0), model, "FlagW")
	AB.block(Vector3.new(2, 4, 0.2), RED, AB.offset(originCF, flagX + 4, flagY, -0.35) * CFrame.Angles(0, math.rad(-5), 0), model, "FlagR")
	-- Flag wave wedges at the trailing edge
	AB.wedge(Vector3.new(0.25, 1.3, 1.5), RED,
		AB.offset(originCF, flagX + 5.3, flagY + 1.5, -0.5) * CFrame.Angles(0, math.rad(85), 0),
		model, "FlagWaveTop")
	AB.wedge(Vector3.new(0.25, 1.3, 1.5), RED,
		AB.offset(originCF, flagX + 5.3, flagY - 1.5, -0.5) * CFrame.Angles(0, math.rad(85), math.rad(180)),
		model, "FlagWaveBot")

	-- Flag mount rope + ring on pole
	AB.cylinder(0.5, 0.2, GOLD, AB.offset(originCF, 0, 18, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "MountRing1")
	AB.cylinder(0.5, 0.2, GOLD, AB.offset(originCF, 0, 14, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "MountRing2")
	AB.cylinder(0.05, 4, GOLD, AB.offset(originCF, 0.4, 16, 0), model, "MountRope")

	-- Spotlight at base aimed up
	AB.block(Vector3.new(0.6, 0.4, 0.6), Color3.fromRGB(35, 35, 40), AB.offset(originCF, 1.5, 1.9, 1.5), model, "Spotlight")
	local lightCone = AB.sphere(0.5, Color3.fromRGB(255, 250, 220), AB.offset(originCF, 1.5, 2.3, 1.5), model, "SpotGlow")
	AB.neon(lightCone)
	AB.glow(lightCone, lightCone.Color, 2)

	-- Plaque
	AB.block(Vector3.new(2, 0.8, 0.1), GOLD, AB.offset(originCF, 0, 1.6, 1.5), model, "Plaque")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
