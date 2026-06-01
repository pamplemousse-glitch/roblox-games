-- Farmgirl with Iced Tea — sun dress, wide-brim straw hat, holding a clear
-- glass of iced tea with a lemon slice on top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN    = Color3.fromRGB(238, 200, 175)
local DRESS   = Color3.fromRGB(220, 175, 140)
local DRESS_S = Color3.fromRGB(180, 130, 100)
local STRAW   = Color3.fromRGB(232, 200, 112)
local HAT_BD  = Color3.fromRGB(170, 30, 40)
local SANDAL  = Color3.fromRGB(105, 70, 40)
local HAIR    = Color3.fromRGB(190, 130, 80)
local GLASS   = Color3.fromRGB(220, 240, 250)
local TEA     = Color3.fromRGB(140, 95, 50)
local LEMON   = Color3.fromRGB(245, 220, 90)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("FarmgirlIcedTea", parent)

	-- Legs (skinny)
	AB.block(Vector3.new(1.0, 3.6, 1.0), SKIN, AB.offset(originCF, -0.6, 1.8, 0), model, "LegL")
	AB.block(Vector3.new(1.0, 3.6, 1.0), SKIN, AB.offset(originCF,  0.6, 1.8, 0), model, "LegR")
	AB.block(Vector3.new(1.2, 0.3, 1.4), SANDAL, AB.offset(originCF, -0.6, 0.15, 0.1), model, "SandalL")
	AB.block(Vector3.new(1.2, 0.3, 1.4), SANDAL, AB.offset(originCF,  0.6, 0.15, 0.1), model, "SandalR")

	-- Dress (A-line skirt over torso)
	local torso = AB.block(Vector3.new(3, 4, 1.6), DRESS, AB.offset(originCF, 0, 5.5, 0), model, "Torso")
	-- Skirt flare (wedge-like, wider at bottom)
	AB.block(Vector3.new(4, 1, 2.4), DRESS, AB.offset(originCF, 0, 3.6, 0), model, "SkirtBot")
	AB.block(Vector3.new(3.5, 0.8, 2), DRESS, AB.offset(originCF, 0, 4.3, 0), model, "SkirtMid")
	-- Dress trim pattern (small dark dots)
	for i, x in {-1.0, 0, 1.0} do
		AB.sphere(0.25, DRESS_S, AB.offset(originCF, x, 4.5, 0.85), model, "DressDot_" .. i)
	end

	-- Arms
	AB.block(Vector3.new(0.9, 3.8, 0.9), SKIN, AB.offset(originCF, -2.0, 5.5, 0), model, "ArmL")
	-- Right arm bent forward (holding glass)
	local armR = AB.block(Vector3.new(0.9, 3.8, 0.9), SKIN, AB.offset(originCF, 2.0, 5.5, 0.4), model, "ArmR")
	armR.CFrame = armR.CFrame * CFrame.Angles(math.rad(-30), 0, 0)
	-- Hands
	AB.sphere(0.7, SKIN, AB.offset(originCF, -2.0, 3.6, 0), model, "HandL")
	AB.sphere(0.7, SKIN, AB.offset(originCF, 2.0, 4.5, 2.0), model, "HandR")

	-- Iced tea glass (in right hand)
	local glassCF = AB.offset(originCF, 2.0, 5.0, 2.4)
	local cup = AB.cylinder(1.3, 1.8, GLASS, glassCF, model, "Glass")
	cup.Transparency = 0.4
	cup.Reflectance  = 0.2
	-- Tea inside
	AB.cylinder(1.15, 1.4, TEA, glassCF * CFrame.new(0, -0.1, 0), model, "Tea")
	-- Lemon slice on rim
	local lemon = AB.cylinder(0.7, 0.15, LEMON, glassCF * CFrame.new(0, 1, 0.3) * CFrame.Angles(0, math.rad(15), 0), model, "Lemon")

	-- Head
	AB.sphere(2.0, SKIN, AB.offset(originCF, 0, 8.6, 0), model, "Head")
	-- Pigtails hair
	AB.sphere(1.3, HAIR, AB.offset(originCF, -1.6, 7.4, -0.4), model, "HairPigL")
	AB.sphere(1.3, HAIR, AB.offset(originCF,  1.6, 7.4, -0.4), model, "HairPigR")
	-- Fringe
	AB.block(Vector3.new(2.0, 0.3, 2.0), HAIR, AB.offset(originCF, 0, 9.3, 0), model, "Hair")

	-- Wide-brim straw sun hat
	AB.cylinder(5.4, 0.3, STRAW, AB.offset(originCF, 0, 9.8, 0), model, "HatBrim")
	AB.cylinder(2.4, 1.2, STRAW, AB.offset(originCF, 0, 10.6, 0), model, "HatCrown")
	-- Red hatband
	AB.cylinder(2.45, 0.3, HAT_BD, AB.offset(originCF, 0, 10.1, 0), model, "HatBand")

	-- Eyes (closed-happy crescent — just thin black blocks)
	AB.block(Vector3.new(0.4, 0.1, 0.1), Color3.new(0, 0, 0), AB.offset(originCF, -0.5, 8.85, 0.95), model, "EyeL")
	AB.block(Vector3.new(0.4, 0.1, 0.1), Color3.new(0, 0, 0), AB.offset(originCF,  0.5, 8.85, 0.95), model, "EyeR")
	-- Smile
	AB.block(Vector3.new(1.0, 0.2, 0.2), Color3.new(0, 0, 0), AB.offset(originCF, 0, 8.2, 0.95), model, "Smile")
	-- Cheek blush
	AB.sphere(0.3, HAT_BD, AB.offset(originCF, -1.0, 8.4, 0.85), model, "CheekL")
	AB.sphere(0.3, HAT_BD, AB.offset(originCF,  1.0, 8.4, 0.85), model, "CheekR")

	AB.billboard(model:FindFirstChild("Head") or torso, "Farmgirl", Vector2.new(160, 32), 2.6)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
