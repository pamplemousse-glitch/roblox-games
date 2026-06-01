-- Lupita & Diego — folkloric dancing couple, hands meeting in the middle.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN_LIGHT  = Color3.fromRGB(220, 180, 150)
local SKIN_MED    = Color3.fromRGB(210, 165, 130)
local BOUG_PINK   = Color3.fromRGB(220, 80, 140)
local CREAM       = Color3.fromRGB(245, 230, 200)
local HAIR_BLACK  = Color3.fromRGB(40, 30, 25)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN = Color3.fromRGB(93, 168, 85)
local TERRACOTTA  = Color3.fromRGB(196, 95, 44)
local BLACK       = Color3.fromRGB(30, 25, 25)
local LIP_PINK    = Color3.fromRGB(210, 110, 130)
local SHOE_BROWN  = Color3.fromRGB(85, 55, 35)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DancingCouple", parent)

	-- ============================================================
	-- FIGURE 1 — LUPITA (woman, x = -1.5)
	-- ============================================================
	local woX = -1.5

	-- Torso (blouse)
	local wTorso = AB.block(Vector3.new(2.4, 2.4, 1.1), CREAM,
		AB.offset(originCF, woX, 1.7, 0), model, "Lupita_Torso")
	-- Wide dress skirt
	AB.block(Vector3.new(3, 2, 2), BOUG_PINK,
		AB.offset(originCF, woX, 0.2, 0), model, "Lupita_Skirt")
	-- Skirt flare wedges
	for i, side in {-1, 1} do
		AB.wedge(Vector3.new(0.5, 1.5, 1.5), BOUG_PINK,
			AB.offset(originCF, woX + side * 1.6, -0.5, 0) * CFrame.Angles(0, math.rad(side * 90), 0),
			model, "Lupita_SkirtFlare_" .. i)
	end
	-- Embroidered flowers on skirt
	AB.sphere(0.25, FIESTA_YEL,
		AB.offset(originCF, woX - 0.6, 0.4, 1.05), model, "Lupita_Flower1")
	AB.sphere(0.25, PAPEL_GREEN,
		AB.offset(originCF, woX + 0.6, 0.4, 1.05), model, "Lupita_Flower2")
	AB.sphere(0.25, FIESTA_YEL,
		AB.offset(originCF, woX - 0.4, -0.4, 1.05), model, "Lupita_Flower3")
	AB.sphere(0.25, PAPEL_GREEN,
		AB.offset(originCF, woX + 0.5, -0.3, 1.05), model, "Lupita_Flower4")

	-- Head
	AB.sphere(1.6, SKIN_LIGHT,
		AB.offset(originCF, woX, 3.7, 0), model, "Lupita_Head")
	-- Eyes
	for i, x in {-0.3, 0.3} do
		AB.sphere(0.15, BLACK,
			AB.offset(originCF, woX + x, 3.8, 0.75), model, "Lupita_Eye_" .. i)
	end
	-- Smile
	AB.block(Vector3.new(0.5, 0.15, 0.12), LIP_PINK,
		AB.offset(originCF, woX, 3.4, 0.78), model, "Lupita_Mouth")

	-- Hair cap
	AB.sphere(1.75, HAIR_BLACK,
		AB.offset(originCF, woX, 3.85, -0.15), model, "Lupita_Hair")
	-- Two side braids
	for i, side in {-1, 1} do
		for j = 1, 3 do
			AB.sphere(0.35, HAIR_BLACK,
				AB.offset(originCF, woX + side * 0.85, 3.5 - (j - 1) * 0.45, 0),
				model, "Lupita_Braid_" .. i .. "_" .. j)
		end
	end

	-- Left arm: raised up
	AB.block(Vector3.new(0.7, 2.2, 0.7), CREAM,
		AB.offset(originCF, woX - 1.4, 2.5, 0) * CFrame.Angles(0, 0, math.rad(-45)),
		model, "Lupita_Arm_L")
	AB.sphere(0.55, SKIN_LIGHT,
		AB.offset(originCF, woX - 2.2, 3.6, 0), model, "Lupita_Hand_L")
	-- Right arm: outstretched toward Diego (toward center, x=0)
	AB.block(Vector3.new(2.0, 0.7, 0.7), CREAM,
		AB.offset(originCF, woX + 1.4, 2.0, 0),
		model, "Lupita_Arm_R")
	-- Right hand meets Diego's at x=0
	AB.sphere(0.55, SKIN_LIGHT,
		AB.offset(originCF, 0, 2.0, 0), model, "Lupita_Hand_R")

	-- Shoes peek out below skirt
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.6, 0.3, 1.0), SHOE_BROWN,
			AB.offset(originCF, woX + side * 0.4, -1.0, 0.1),
			model, "Lupita_Shoe_" .. (side == -1 and "L" or "R"))
	end

	-- ============================================================
	-- FIGURE 2 — DIEGO (man, x = 1.5)
	-- ============================================================
	local dX = 1.5

	-- Torso (cream charro shirt)
	AB.block(Vector3.new(2.4, 3, 1.2), CREAM,
		AB.offset(originCF, dX, 1.5, 0), model, "Diego_Torso")
	-- Terracotta cummerbund sash
	AB.block(Vector3.new(2.5, 0.6, 1.25), TERRACOTTA,
		AB.offset(originCF, dX, 0.5, 0), model, "Diego_Sash")
	-- Sash diagonal accent
	AB.block(Vector3.new(2.6, 0.2, 1.27), FIESTA_YEL,
		AB.offset(originCF, dX, 0.7, 0), model, "Diego_SashTrim")

	-- Head
	AB.sphere(1.8, SKIN_MED,
		AB.offset(originCF, dX, 3.9, 0), model, "Diego_Head")
	-- Eyes
	for i, x in {-0.35, 0.35} do
		AB.sphere(0.18, BLACK,
			AB.offset(originCF, dX + x, 4.0, 0.85), model, "Diego_Eye_" .. i)
	end
	-- Mustache + smile
	AB.block(Vector3.new(0.9, 0.18, 0.18), HAIR_BLACK,
		AB.offset(originCF, dX, 3.6, 0.85), model, "Diego_Mustache")
	AB.block(Vector3.new(0.5, 0.1, 0.12), Color3.fromRGB(160, 80, 70),
		AB.offset(originCF, dX, 3.4, 0.85), model, "Diego_Mouth")

	-- Small black sombrero
	AB.cylinder(3.5, 0.25, BLACK,
		AB.offset(originCF, dX, 4.75, 0), model, "Diego_HatBrim")
	AB.cylinder(1.8, 1.0, BLACK,
		AB.offset(originCF, dX, 5.4, 0) * CFrame.Angles(0, 0, math.rad(-90)),
		model, "Diego_HatCrown")
	AB.cylinder(1.85, 0.18, FIESTA_YEL,
		AB.offset(originCF, dX, 4.95, 0) * CFrame.Angles(0, 0, math.rad(-90)),
		model, "Diego_HatBand")

	-- Right arm: down at side
	AB.block(Vector3.new(0.85, 2.4, 0.85), CREAM,
		AB.offset(originCF, dX + 1.5, 1.5, 0),
		model, "Diego_Arm_R")
	AB.sphere(0.65, SKIN_MED,
		AB.offset(originCF, dX + 1.5, 0.2, 0), model, "Diego_Hand_R")
	-- Left arm: outstretched toward Lupita (toward center, x=0)
	AB.block(Vector3.new(2.0, 0.85, 0.85), CREAM,
		AB.offset(originCF, dX - 1.4, 2.0, 0),
		model, "Diego_Arm_L")
	-- Diego's left hand meets Lupita's right hand at x=0
	AB.sphere(0.65, SKIN_MED,
		AB.offset(originCF, 0.1, 2.0, 0), model, "Diego_Hand_L")

	-- Black charro pants
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.9, 2.6, 1.0), BLACK,
			AB.offset(originCF, dX + side * 0.55, -1.3, 0),
			model, "Diego_Leg_" .. (side == -1 and "L" or "R"))
		AB.block(Vector3.new(1.0, 0.4, 1.5), BLACK,
			AB.offset(originCF, dX + side * 0.55, -2.8, 0.25),
			model, "Diego_Boot_" .. (side == -1 and "L" or "R"))
	end

	-- Nametag (on the woman's head)
	local lupitaHead = model:FindFirstChild("Lupita_Head") :: BasePart
	if lupitaHead then AB.billboard(lupitaHead, "Lupita & Diego", Vector2.new(240, 36), 2.5) end

	AB.pivot(model, wTorso)
	AB.weldAll(model)
	return model
end
