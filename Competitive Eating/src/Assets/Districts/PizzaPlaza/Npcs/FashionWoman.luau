-- Fashion Woman — chic Italian woman in big sunglasses, designer handbag,
-- elegant dress, heels.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Bianca"
local SKIN    = Color3.fromRGB(245, 215, 175)
local DRESS_R = Color3.fromRGB(180, 30, 50)
local DRESS_T = Color3.fromRGB(220, 50, 70)
local HAIR    = Color3.fromRGB(60, 35, 25)
local SHOE_R  = Color3.fromRGB(150, 20, 30)
local BAG_GLD = Color3.fromRGB(200, 160, 80)
local BAG_BLK = Color3.fromRGB(35, 30, 30)
local LIPS    = Color3.fromRGB(180, 30, 40)
local SKIN_DK = Color3.fromRGB(220, 195, 165)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (red dress)
	local torso = AB.part({size=Vector3.new(2.4, 3, 1.2), color=DRESS_R,
		cf=originCF, canCollide=false, name="Torso"}, model)
	-- Dress tone highlight
	AB.part({size=Vector3.new(2.45, 1.2, 1.25), color=DRESS_T,
		cf=AB.offset(originCF, 0, 0.7, 0), canCollide=false, name="Bodice"}, model)
	-- Belt
	AB.cylinder(1.3, 0.3, BAG_BLK,
		AB.offset(originCF, 0, -0.4, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Belt")
	-- Gold belt buckle
	AB.block(Vector3.new(0.6, 0.5, 0.1), BAG_GLD, AB.offset(originCF, 0, -0.4, 0.65), model, "BeltBuckle")
	-- Dress hem (flared)
	AB.part({size=Vector3.new(2.8, 0.8, 1.5), color=DRESS_R,
		cf=AB.offset(originCF, 0, -1.8, 0), canCollide=false, name="Hem"}, model)
	-- Long bare legs
	AB.cylinder(0.4, 2, SKIN_DK, AB.offset(originCF, -0.5, -3.2, 0), model, "LegL")
	AB.cylinder(0.4, 2, SKIN_DK, AB.offset(originCF, 0.5, -3.2, 0), model, "LegR")
	-- Red high heels
	AB.part({size=Vector3.new(0.7, 0.3, 1.2), color=SHOE_R,
		cf=AB.offset(originCF, -0.5, -4.3, 0.3), canCollide=false, name="ShoeL"}, model)
	AB.part({size=Vector3.new(0.7, 0.3, 1.2), color=SHOE_R,
		cf=AB.offset(originCF, 0.5, -4.3, 0.3), canCollide=false, name="ShoeR"}, model)
	-- Heel spikes
	AB.cylinder(0.1, 0.6, SHOE_R, AB.offset(originCF, -0.5, -4.7, -0.2), model, "HeelL")
	AB.cylinder(0.1, 0.6, SHOE_R, AB.offset(originCF, 0.5, -4.7, -0.2), model, "HeelR")

	-- Head
	local head = AB.part({size=Vector3.new(1.7, 1.7, 1.7), color=SKIN,
		cf=AB.offset(originCF, 0, 2.4, 0), shape=Enum.PartType.Ball, canCollide=false, name="Head"}, model)
	-- Long flowing hair
	AB.part({size=Vector3.new(1.8, 2.5, 0.6), color=HAIR,
		cf=AB.offset(originCF, 0, 2, -0.7), canCollide=false, name="HairLong"}, model)
	-- Hair top
	AB.sphere(1.1, HAIR, AB.offset(originCF, 0, 3, 0), model, "HairTop")
	-- Side hair strands
	AB.cylinder(0.4, 1.4, HAIR, AB.offset(originCF, -0.9, 2, 0.3), model, "HairSideL")
	AB.cylinder(0.4, 1.4, HAIR, AB.offset(originCF, 0.9, 2, 0.3), model, "HairSideR")
	-- Big designer sunglasses
	AB.block(Vector3.new(1.8, 0.5, 0.2), BAG_BLK, AB.offset(originCF, 0, 2.5, 0.85), model, "Shades")
	-- Sunglass gold accents
	AB.cylinder(0.1, 0.3, BAG_GLD,
		AB.offset(originCF, -0.7, 2.5, 0.95) * CFrame.Angles(math.rad(90), 0, 0), model, "ShadeAccentL")
	AB.cylinder(0.1, 0.3, BAG_GLD,
		AB.offset(originCF, 0.7, 2.5, 0.95) * CFrame.Angles(math.rad(90), 0, 0), model, "ShadeAccentR")
	-- Red lips
	AB.block(Vector3.new(0.55, 0.15, 0.1), LIPS, AB.offset(originCF, 0, 1.95, 0.85), model, "Lips")
	-- Pearl earrings
	AB.sphere(0.18, Color3.fromRGB(245, 240, 230), AB.offset(originCF, -0.85, 2.4, 0.3), model, "EarringL")
	AB.sphere(0.18, Color3.fromRGB(245, 240, 230), AB.offset(originCF, 0.85, 2.4, 0.3), model, "EarringR")
	-- Pearl necklace
	for i = -1, 1 do
		AB.sphere(0.12, Color3.fromRGB(245, 240, 230),
			AB.offset(originCF, i * 0.3, 1.3, 0.7), model, "Pearl_" .. (i + 2))
	end

	-- Arms (one with bag, one to head touching glasses)
	AB.part({size=Vector3.new(0.7, 2.3, 0.7), color=SKIN,
		cf=AB.offset(originCF, -1.5, -0.2, 0), canCollide=false, name="ArmL"}, model)
	AB.part({size=Vector3.new(0.7, 2.3, 0.7), color=SKIN,
		cf=AB.offset(originCF, 1.5, 0.8, 0.3) * CFrame.Angles(math.rad(-100), 0, 0), canCollide=false, name="ArmR"}, model)
	-- Hands
	AB.sphere(0.4, SKIN, AB.offset(originCF, -1.5, -1.5, 0), model, "HandL")
	AB.sphere(0.4, SKIN, AB.offset(originCF, 1.5, 2.5, 0.6), model, "HandR")

	-- Designer handbag (gold + black, hanging from left arm)
	AB.block(Vector3.new(1.4, 1.6, 0.8), BAG_BLK, AB.offset(originCF, -1.5, -2.6, 0), model, "Bag")
	-- Bag gold chain handle
	AB.cylinder(0.08, 2, BAG_GLD,
		AB.offset(originCF, -1.5, -1.8, 0) * CFrame.Angles(math.rad(20), 0, 0), model, "BagHandle")
	-- Brand logo (gold buckle)
	AB.block(Vector3.new(0.6, 0.4, 0.1), BAG_GLD, AB.offset(originCF, -1.5, -2.6, 0.45), model, "BagBuckle")
	-- Tassel
	AB.cylinder(0.06, 0.8, BAG_GLD, AB.offset(originCF, -1.9, -3.2, 0), model, "BagTassel")
	AB.sphere(0.15, BAG_GLD, AB.offset(originCF, -1.9, -3.6, 0), model, "BagTasselBall")

	AB.billboard(head, NAME, Vector2.new(200, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
