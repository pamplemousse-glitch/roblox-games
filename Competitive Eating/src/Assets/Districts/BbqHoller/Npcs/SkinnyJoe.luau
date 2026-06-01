-- Skinny Joe — gangly farmhand in red plaid shirt, denim overalls, ball cap.
-- Tall but very narrow, oversized boots, big front-toothed grin.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN     = Color3.fromRGB(240, 200, 165)
local PLAID    = Color3.fromRGB(160, 40, 40)
local PLAID_HL = Color3.fromRGB(70, 25, 25)
local DENIM    = Color3.fromRGB(70, 90, 130)
local DENIM_DK = Color3.fromRGB(40, 55, 90)
local CAP      = Color3.fromRGB(232, 200, 112)
local BOOT     = Color3.fromRGB(55, 35, 22)
local HAIR     = Color3.fromRGB(180, 130, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SkinnyJoe", parent)

	-- Skinny legs in overalls
	AB.block(Vector3.new(0.9, 4.8, 0.9), DENIM, AB.offset(originCF, -0.7, 2.4, 0), model, "LegL")
	AB.block(Vector3.new(0.9, 4.8, 0.9), DENIM, AB.offset(originCF,  0.7, 2.4, 0), model, "LegR")
	-- Big boots (look comically oversized)
	AB.block(Vector3.new(1.5, 0.9, 1.8), BOOT, AB.offset(originCF, -0.7, 0.45, 0.2), model, "BootL")
	AB.block(Vector3.new(1.5, 0.9, 1.8), BOOT, AB.offset(originCF,  0.7, 0.45, 0.2), model, "BootR")

	-- Narrow torso — plaid shirt visible behind overall bib
	local torso = AB.block(
		Vector3.new(2.4, 3.5, 1.5), PLAID,
		AB.offset(originCF, 0, 6.5, 0),
		model, "Torso"
	)
	-- Plaid pattern: dark cross stripes
	AB.block(Vector3.new(2.45, 3.5, 0.05), PLAID_HL, AB.offset(originCF, 0, 7.0, 0.78), model, "PlaidH1")
	AB.block(Vector3.new(2.45, 0.25, 1.55), PLAID_HL, AB.offset(originCF, 0, 6.0, 0), model, "PlaidV1")
	AB.block(Vector3.new(2.45, 0.25, 1.55), PLAID_HL, AB.offset(originCF, 0, 7.2, 0), model, "PlaidV2")

	-- Overall bib (denim square over the chest)
	AB.block(Vector3.new(1.6, 2.2, 0.25), DENIM, AB.offset(originCF, 0, 6.5, 0.85), model, "OverallBib")
	-- Bib straps over shoulders
	AB.block(Vector3.new(0.3, 1.4, 0.3), DENIM, AB.offset(originCF, -0.7, 8.2, 0.7), model, "StrapL")
	AB.block(Vector3.new(0.3, 1.4, 0.3), DENIM, AB.offset(originCF,  0.7, 8.2, 0.7), model, "StrapR")
	-- Two brass buttons
	AB.sphere(0.22, Color3.fromRGB(220, 180, 60), AB.offset(originCF, -0.5, 7.4, 0.99), model, "BibBtnL")
	AB.sphere(0.22, Color3.fromRGB(220, 180, 60), AB.offset(originCF,  0.5, 7.4, 0.99), model, "BibBtnR")

	-- Long thin arms
	AB.block(Vector3.new(0.8, 4.0, 0.8), PLAID, AB.offset(originCF, -1.7, 6.3, 0), model, "ArmL")
	AB.block(Vector3.new(0.8, 4.0, 0.8), PLAID, AB.offset(originCF,  1.7, 6.3, 0), model, "ArmR")
	AB.sphere(0.9, SKIN, AB.offset(originCF, -1.7, 4.2, 0), model, "HandL")
	AB.sphere(0.9, SKIN, AB.offset(originCF,  1.7, 4.2, 0), model, "HandR")

	-- Long thin neck (suggested with a small skin block)
	AB.block(Vector3.new(0.8, 0.7, 0.8), SKIN, AB.offset(originCF, 0, 8.6, 0), model, "Neck")

	-- Head — slightly oblong (use sphere; long via positioning)
	AB.sphere(2.0, SKIN, AB.offset(originCF, 0, 9.7, 0), model, "Head")
	-- Eyes
	AB.sphere(0.25, Color3.new(0, 0, 0), AB.offset(originCF, -0.5, 9.85, 0.9), model, "EyeL")
	AB.sphere(0.25, Color3.new(0, 0, 0), AB.offset(originCF,  0.5, 9.85, 0.9), model, "EyeR")
	-- Buck tooth grin
	AB.block(Vector3.new(0.3, 0.5, 0.1), Color3.fromRGB(240, 230, 200), AB.offset(originCF, 0, 9.2, 0.95), model, "Tooth")
	AB.block(Vector3.new(1.0, 0.15, 0.2), Color3.fromRGB(160, 60, 60), AB.offset(originCF, 0, 8.95, 0.9), model, "Grin")

	-- Shaggy hair sticking out from under the cap
	AB.block(Vector3.new(2.1, 0.4, 2.1), HAIR, AB.offset(originCF, 0, 10.7, 0), model, "Hair")

	-- Straw-yellow ball cap (brim + crown)
	AB.cylinder(2.6, 0.9, CAP, AB.offset(originCF, 0, 11.2, 0), model, "CapCrown")
	AB.block(Vector3.new(2.8, 0.3, 1.6), CAP, AB.offset(originCF, 0, 10.85, 1.2), model, "CapBrim")

	AB.billboard(model:FindFirstChild("Head") or torso, "Skinny Joe", Vector2.new(220, 40), 3.0)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
