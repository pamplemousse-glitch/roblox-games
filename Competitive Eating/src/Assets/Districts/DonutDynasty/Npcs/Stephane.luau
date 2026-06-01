-- Stéphane — head chef NPC, dark-pinstripe pants, gold-trimmed chef coat,
-- distinguished mustache, holding a piping bag of icing.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN   = Color3.fromRGB(225, 190, 160)
local HAIR   = Color3.fromRGB(180, 180, 180) -- silver
local UNIFM  = Color3.fromRGB(255, 245, 235)
local TRIM   = Color3.fromRGB(212, 168, 82)
local PANTS  = Color3.fromRGB(50,  45,  55)
local SHOE   = Color3.fromRGB(30,  25,  20)
local CREAM  = Color3.fromRGB(255, 240, 220)
local PINK   = Color3.fromRGB(255, 200, 214)
local CHOCO  = Color3.fromRGB(92,  57,  36)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Stephane", parent)

	-- Legs (slim pinstripe)
	AB.block(Vector3.new(0.9, 2.6, 1.0), PANTS,
		AB.offset(originCF, -0.55, 1.3, 0), model, "LegL")
	AB.block(Vector3.new(0.9, 2.6, 1.0), PANTS,
		AB.offset(originCF,  0.55, 1.3, 0), model, "LegR")
	-- Pinstripe accents
	for _, x in {-0.55, 0.55} do
		AB.block(Vector3.new(0.05, 2.5, 0.05), TRIM,
			AB.offset(originCF, x, 1.3, 0.5), model, "Stripe_" .. ((x > 0) and "R" or "L"))
	end
	AB.block(Vector3.new(1.0, 0.3, 1.3), SHOE,
		AB.offset(originCF, -0.55, 0.15, 0.15), model, "ShoeL")
	AB.block(Vector3.new(1.0, 0.3, 1.3), SHOE,
		AB.offset(originCF,  0.55, 0.15, 0.15), model, "ShoeR")

	-- Torso — coat with gold trim
	local torso = AB.block(Vector3.new(2.9, 3.0, 1.4), UNIFM,
		AB.offset(originCF, 0, 4.1, 0), model, "Torso")
	AB.block(Vector3.new(3.0, 0.2, 1.45), TRIM,
		AB.offset(originCF, 0, 2.6, 0), model, "WaistTrim")
	AB.block(Vector3.new(0.2, 3.0, 1.45), TRIM,
		AB.offset(originCF, 0, 4.1, 0.7), model, "LapelSeam")

	-- Arms
	AB.block(Vector3.new(0.85, 2.4, 0.85), UNIFM,
		AB.offset(originCF, -1.85, 4.1, 0.3), model, "ArmL")
	AB.block(Vector3.new(0.85, 2.4, 0.85), UNIFM,
		AB.offset(originCF,  1.85, 4.1, 0.3), model, "ArmR")
	AB.sphere(0.7, SKIN, AB.offset(originCF, -1.85, 2.85, 0.6), model, "HandL")
	AB.sphere(0.7, SKIN, AB.offset(originCF,  1.85, 2.85, 0.6), model, "HandR")

	-- Head + grand mustache + silver hair
	AB.sphere(1.75, SKIN, AB.offset(originCF, 0, 6.3, 0), model, "Head")
	AB.block(Vector3.new(1.85, 0.4, 1.75), HAIR,
		AB.offset(originCF, 0, 7.0, 0), model, "Hair")
	-- Sideburns
	AB.block(Vector3.new(0.2, 0.6, 0.4), HAIR,
		AB.offset(originCF, -0.95, 6.0, 0.3), model, "SideburnL")
	AB.block(Vector3.new(0.2, 0.6, 0.4), HAIR,
		AB.offset(originCF,  0.95, 6.0, 0.3), model, "SideburnR")
	-- Curly handlebar mustache
	AB.block(Vector3.new(1.6, 0.25, 0.25), HAIR,
		AB.offset(originCF, 0, 5.85, 0.92), model, "Mustache")
	AB.sphere(0.3, HAIR, AB.offset(originCF, -0.85, 5.95, 0.95), model, "MustacheL")
	AB.sphere(0.3, HAIR, AB.offset(originCF,  0.85, 5.95, 0.95), model, "MustacheR")

	-- Toque with gold band
	AB.cylinder(2.0, 0.4, TRIM,
		AB.offset(originCF, 0, 7.4, 0), model, "ToqueBand")
	AB.cylinder(1.8, 1.6, UNIFM,
		AB.offset(originCF, 0, 8.5, 0), model, "ToqueShaft")
	AB.sphere(2.3, UNIFM, AB.offset(originCF, 0, 9.7, 0), model, "ToquePuff")

	-- Piping bag in right hand
	local bag = AB.block(Vector3.new(0.9, 1.6, 0.9), CREAM,
		AB.offset(originCF, 1.85, 2.1, 0.6) * CFrame.Angles(math.rad(20), 0, 0),
		model, "PipingBag")
	AB.cylinder(0.5, 0.6, PINK,
		AB.offset(originCF, 1.85, 1.3, 0.95), model, "PipingTip")
	AB.sphere(0.4, PINK, AB.offset(originCF, 1.85, 1.0, 1.15), model, "Glob")
	AB.sphere(0.25, CHOCO, AB.offset(originCF, 1.95, 0.7, 1.25), model, "Drop")
	bag.Material = Enum.Material.Fabric

	AB.billboard(torso, "Stéphane", nil, 5)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
