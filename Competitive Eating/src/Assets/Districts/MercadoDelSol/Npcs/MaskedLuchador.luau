-- El Rayo Loco — pumped luchador in pink/teal mask and cape, fist in the air.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN_MED    = Color3.fromRGB(210, 165, 130)
local AGAVE_TEAL  = Color3.fromRGB(43, 140, 156)
local BOUG_PINK   = Color3.fromRGB(220, 80, 140)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local BLACK       = Color3.fromRGB(30, 25, 25)
local WHITE       = Color3.fromRGB(245, 240, 235)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MaskedLuchador", parent)

	-- Torso (singlet, wider than usual)
	local torso = AB.block(Vector3.new(3, 3, 1.3), AGAVE_TEAL,
		AB.offset(originCF, 0, 1.5, 0), model, "Torso")

	-- Wide gold belt across torso bottom
	AB.block(Vector3.new(3.1, 0.7, 1.35), FIESTA_YEL,
		AB.offset(originCF, 0, 0.2, 0), model, "Belt")
	-- Belt buckle
	AB.block(Vector3.new(0.8, 0.6, 0.15), Color3.fromRGB(230, 200, 80),
		AB.offset(originCF, 0, 0.2, 0.7), model, "BeltBuckle")
	AB.block(Vector3.new(0.6, 0.4, 0.1), FIESTA_YEL,
		AB.offset(originCF, 0, 0.2, 0.78), model, "BeltBuckleInner")

	-- Cape on back (teal body, pink trim)
	AB.block(Vector3.new(3.2, 3.2, 0.15), AGAVE_TEAL,
		AB.offset(originCF, 0, 1.8, -0.75), model, "Cape")
	AB.block(Vector3.new(3.3, 0.3, 0.18), BOUG_PINK,
		AB.offset(originCF, 0, 0.3, -0.78), model, "CapeTrim")

	-- Head (mostly pink mask)
	AB.sphere(1.8, BOUG_PINK, AB.offset(originCF, 0, 3.9, 0), model, "Head")

	-- Mask yellow stripe across forehead
	AB.block(Vector3.new(1.85, 0.3, 0.15), FIESTA_YEL,
		AB.offset(originCF, 0, 4.4, 0.78), model, "MaskStripeTop")
	-- Mask yellow side stripe
	AB.block(Vector3.new(1.85, 0.25, 0.15), FIESTA_YEL,
		AB.offset(originCF, 0, 3.4, 0.78), model, "MaskStripeBot")

	-- Mask flame/lightning accent on forehead
	AB.wedge(Vector3.new(0.4, 0.7, 0.15), WHITE,
		AB.offset(originCF, 0, 4.55, 0.88), model, "MaskFlame")

	-- Eye holes (dark ovals)
	for i, x in {-0.4, 0.4} do
		AB.block(Vector3.new(0.4, 0.25, 0.1), BLACK,
			AB.offset(originCF, x, 4.0, 0.88), model, "EyeHole_" .. i)
	end
	-- Mouth hole
	AB.block(Vector3.new(0.6, 0.18, 0.1), BLACK,
		AB.offset(originCF, 0, 3.55, 0.88), model, "MouthHole")

	-- Big muscular arms
	-- Left arm: raised high with fist
	AB.block(Vector3.new(1.1, 2.6, 1.1), SKIN_MED,
		AB.offset(originCF, -1.9, 3.2, 0) * CFrame.Angles(0, 0, math.rad(-25)),
		model, "Arm_L")
	-- Fist raised above head
	AB.sphere(0.9, SKIN_MED,
		AB.offset(originCF, -2.6, 5.5, 0), model, "Fist_L")
	-- Right arm: down at side flexed
	AB.block(Vector3.new(1.1, 2.6, 1.1), SKIN_MED,
		AB.offset(originCF, 1.95, 1.5, 0),
		model, "Arm_R")
	AB.sphere(0.85, SKIN_MED,
		AB.offset(originCF, 1.95, 0.1, 0), model, "Hand_R")

	-- Bicep bulge accents
	AB.sphere(0.7, SKIN_MED,
		AB.offset(originCF, -2.3, 4.2, 0), model, "Bicep_L")
	AB.sphere(0.7, SKIN_MED,
		AB.offset(originCF, 2.0, 2.3, 0), model, "Bicep_R")

	-- Wrestling tights (legs)
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.9, 2.6, 1.0), AGAVE_TEAL,
			AB.offset(originCF, side * 0.7, -1.3, 0),
			model, "Leg_" .. (side == -1 and "L" or "R"))
		-- Tall wrestling boots
		AB.block(Vector3.new(1.0, 1.4, 1.5), BLACK,
			AB.offset(originCF, side * 0.7, -2.3, 0.25),
			model, "Boot_" .. (side == -1 and "L" or "R"))
		-- Yellow stripe on boot
		AB.block(Vector3.new(1.05, 0.2, 1.55), FIESTA_YEL,
			AB.offset(originCF, side * 0.7, -1.8, 0.25),
			model, "BootStripe_" .. (side == -1 and "L" or "R"))
	end

	-- Nametag
	local head = model:FindFirstChild("Head") :: BasePart
	if head then AB.billboard(head, "El Rayo Loco", Vector2.new(220, 36), 3.0) end

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
