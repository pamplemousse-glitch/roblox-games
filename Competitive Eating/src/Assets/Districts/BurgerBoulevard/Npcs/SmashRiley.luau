-- Smash Riley — burger-flipper chef NPC. White apron, red bandana, spatula,
-- chef cap, sauce-stained apron, smile.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN     = Color3.fromRGB(225, 185, 145)
local APRON    = Color3.fromRGB(255, 245, 232)
local BANDANA  = Color3.fromRGB(255, 48, 48)
local PANTS    = Color3.fromRGB(60, 60, 70)
local CHROME   = Color3.fromRGB(176, 176, 176)
local KETCHUP  = Color3.fromRGB(180, 30, 30)
local CHEF_W   = Color3.fromRGB(248, 248, 248)
local DARK     = Color3.fromRGB(30, 30, 35)
local SHOE     = Color3.fromRGB(40, 40, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SmashRiley", parent)

	-- Shoes
	AB.block(Vector3.new(0.9, 0.4, 1.2), SHOE, AB.offset(originCF, -0.4, 0.2, 0.2), model, "ShoeL")
	AB.block(Vector3.new(0.9, 0.4, 1.2), SHOE, AB.offset(originCF,  0.4, 0.2, 0.2), model, "ShoeR")
	-- Legs (pants)
	AB.block(Vector3.new(0.7, 2.4, 0.7), PANTS, AB.offset(originCF, -0.4, 1.6, 0), model, "LegL")
	AB.block(Vector3.new(0.7, 2.4, 0.7), PANTS, AB.offset(originCF,  0.4, 1.6, 0), model, "LegR")
	-- Belt
	AB.block(Vector3.new(1.8, 0.4, 1.05), DARK, AB.offset(originCF, 0, 3, 0), model, "Belt")
	AB.block(Vector3.new(0.4, 0.5, 1.1), CHROME, AB.offset(originCF, 0, 3, 0.5), model, "Buckle")

	-- Torso (apron front)
	local torso = AB.block(Vector3.new(2, 2.5, 1), APRON, AB.offset(originCF, 0, 4.4, 0), model, "Torso")
	-- Ketchup stain on apron (small splat)
	AB.sphere(0.5, KETCHUP, AB.offset(originCF, 0.5, 4.5, 0.55), model, "KetchupStain")
	-- Red apron neck-strap
	AB.block(Vector3.new(0.3, 0.8, 0.15), BANDANA, AB.offset(originCF, -0.7, 5.6, 0.5), model, "StrapL")
	AB.block(Vector3.new(0.3, 0.8, 0.15), BANDANA, AB.offset(originCF,  0.7, 5.6, 0.5), model, "StrapR")
	-- Apron pocket
	AB.block(Vector3.new(0.6, 0.7, 0.1), APRON:Lerp(DARK, 0.1), AB.offset(originCF, -0.5, 3.9, 0.55), model, "AprPocket")
	-- Pen in pocket
	AB.cylinder(0.1, 0.7, BANDANA, AB.offset(originCF, -0.5, 4.2, 0.6), model, "PocketPen")

	-- Arms
	AB.block(Vector3.new(0.6, 2, 0.6), APRON, AB.offset(originCF, -1.3, 4.2, 0), model, "ArmL")
	AB.block(Vector3.new(0.6, 2, 0.6), APRON, AB.offset(originCF,  1.3, 4.2, 0), model, "ArmR")
	-- Hands
	AB.sphere(0.55, SKIN, AB.offset(originCF, -1.3, 3.1, 0), model, "HandL")
	AB.sphere(0.55, SKIN, AB.offset(originCF,  1.3, 3.1, 0), model, "HandR")
	-- Spatula in right hand
	AB.cylinder(0.15, 1.6, Color3.fromRGB(140, 90, 50), AB.offset(originCF, 1.3, 2.2, 0) * CFrame.Angles(0, 0, math.rad(-90)), model, "SpatulaHandle")
	local spat = AB.block(Vector3.new(0.9, 0.08, 1.2), CHROME, AB.offset(originCF, 1.3, 1.3, 0), model, "SpatulaBlade")
	spat.Material = Enum.Material.Metal; spat.Reflectance = 0.5

	-- Head
	AB.sphere(1.4, SKIN, AB.offset(originCF, 0, 6.5, 0), model, "Head")
	-- Red bandana wrap around forehead
	AB.block(Vector3.new(1.5, 0.5, 1.5), BANDANA, AB.offset(originCF, 0, 7, 0), model, "Bandana")
	AB.sphere(0.4, BANDANA, AB.offset(originCF, 0, 7.1, -0.9), model, "BandanaKnot")
	-- Chef cap (tall white poof on top of bandana)
	AB.cylinder(1.2, 0.8, CHEF_W, AB.offset(originCF, 0, 7.5, 0), model, "CapBand")
	AB.sphere(1.5, CHEF_W, AB.offset(originCF, 0, 8.4, 0), model, "CapPoof1")
	AB.sphere(1.2, CHEF_W, AB.offset(originCF, 0.4, 8.7, 0.2), model, "CapPoof2")

	-- Eyes
	AB.sphere(0.13, DARK, AB.offset(originCF, -0.3, 6.6, 0.65), model, "EyeL")
	AB.sphere(0.13, DARK, AB.offset(originCF,  0.3, 6.6, 0.65), model, "EyeR")
	-- Smile (small dark curve)
	AB.block(Vector3.new(0.6, 0.08, 0.1), DARK, AB.offset(originCF, 0, 6.15, 0.7), model, "Smile")
	-- Stubble (a few small dark dots on jaw)
	AB.sphere(0.06, DARK, AB.offset(originCF, -0.3, 6, 0.6), model, "Stubble1")
	AB.sphere(0.06, DARK, AB.offset(originCF, 0.2, 5.95, 0.62), model, "Stubble2")
	AB.sphere(0.06, DARK, AB.offset(originCF, 0.4, 6.0, 0.55), model, "Stubble3")

	-- Name tag
	AB.billboard(torso, "Smash Riley", Vector2.new(220, 36), 4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
