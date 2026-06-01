-- BBQ Judge — official judge in navy blazer + bowtie, glasses, holding a
-- clipboard with a pen. Looks the part of a competition official.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN     = Color3.fromRGB(225, 190, 160)
local BLAZER   = Color3.fromRGB(40, 55, 95)
local BLAZER_D = Color3.fromRGB(28, 38, 65)
local SHIRT    = Color3.fromRGB(240, 235, 225)
local PANTS    = Color3.fromRGB(50, 50, 55)
local SHOE     = Color3.fromRGB(30, 25, 22)
local BOWTIE   = Color3.fromRGB(170, 30, 40)
local CLIP_W   = Color3.fromRGB(235, 230, 220)
local CLIP_M   = Color3.fromRGB(140, 140, 145)
local PEN      = Color3.fromRGB(45, 45, 50)
local HAIR     = Color3.fromRGB(70, 50, 38)
local GLASS    = Color3.fromRGB(200, 220, 230)
local IRON     = Color3.fromRGB(35, 30, 28)
local RIBBON_G = Color3.fromRGB(220, 180, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BBQJudge", parent)

	-- Legs
	AB.block(Vector3.new(1.2, 3.6, 1.2), PANTS, AB.offset(originCF, -0.7, 1.8, 0), model, "LegL")
	AB.block(Vector3.new(1.2, 3.6, 1.2), PANTS, AB.offset(originCF,  0.7, 1.8, 0), model, "LegR")
	AB.block(Vector3.new(1.3, 0.5, 1.6), SHOE, AB.offset(originCF, -0.7, 0.25, 0.1), model, "ShoeL")
	AB.block(Vector3.new(1.3, 0.5, 1.6), SHOE, AB.offset(originCF,  0.7, 0.25, 0.1), model, "ShoeR")

	-- Shirt (visible under open blazer)
	AB.block(Vector3.new(2.4, 4, 1.6), SHIRT, AB.offset(originCF, 0, 5.5, 0), model, "Shirt")
	-- Blazer (front panels on either side of shirt, full back)
	local torso = AB.block(Vector3.new(3.4, 4, 1.8), BLAZER, AB.offset(originCF, 0, 5.5, -0.05), model, "BlazerBack")
	AB.block(Vector3.new(1.0, 4, 0.4), BLAZER_D, AB.offset(originCF, -1.3, 5.5, 0.8), model, "LapelL")
	AB.block(Vector3.new(1.0, 4, 0.4), BLAZER_D, AB.offset(originCF,  1.3, 5.5, 0.8), model, "LapelR")
	-- Gold ribbon on lapel
	AB.block(Vector3.new(0.4, 0.6, 0.2), RIBBON_G, AB.offset(originCF, 1.4, 6.4, 1.0), model, "Ribbon")
	-- Bowtie
	AB.block(Vector3.new(1.3, 0.5, 0.2), BOWTIE, AB.offset(originCF, 0, 7.6, 0.95), model, "BowtieC")
	AB.wedge(Vector3.new(0.2, 0.6, 0.6), BOWTIE, AB.offset(originCF, -0.6, 7.6, 1.0) * CFrame.Angles(0, math.rad(90), 0), model, "BowtieL")
	AB.wedge(Vector3.new(0.2, 0.6, 0.6), BOWTIE, AB.offset(originCF,  0.6, 7.6, 1.0) * CFrame.Angles(0, math.rad(-90), 0), model, "BowtieR")

	-- Arms (left holding clipboard, right with pen)
	AB.block(Vector3.new(1.1, 3.8, 1.1), BLAZER, AB.offset(originCF, -2.3, 5.5, 0), model, "ArmL")
	local armR = AB.block(Vector3.new(1.1, 3.8, 1.1), BLAZER, AB.offset(originCF, 2.3, 5.5, 0.4), model, "ArmR")
	armR.CFrame = armR.CFrame * CFrame.Angles(math.rad(-20), 0, 0)
	AB.sphere(0.85, SKIN, AB.offset(originCF, -2.3, 3.5, 0.5), model, "HandL")
	AB.sphere(0.85, SKIN, AB.offset(originCF,  2.3, 4.2, 1.5), model, "HandR")

	-- Clipboard (in left hand at front)
	local board = AB.block(Vector3.new(2, 3, 0.3), CLIP_W, AB.offset(originCF, -1.8, 4.6, 1.6), model, "Clipboard")
	AB.block(Vector3.new(2.1, 0.4, 0.4), CLIP_M, AB.offset(originCF, -1.8, 6.0, 1.65), model, "ClipboardTop")
	-- Paper lines
	for i, y in {3.5, 4.0, 4.6, 5.1, 5.6} do
		AB.block(Vector3.new(1.5, 0.05, 0.05), Color3.new(0, 0, 0), AB.offset(originCF, -1.8, y, 1.78), model, "PaperLine_" .. i)
	end

	-- Pen (in right hand)
	local pen = AB.block(Vector3.new(0.2, 1.2, 0.2), PEN, AB.offset(originCF, 2.0, 4.4, 1.9), model, "Pen")
	pen.CFrame = pen.CFrame * CFrame.Angles(math.rad(-45), 0, 0)

	-- Head
	AB.sphere(2.1, SKIN, AB.offset(originCF, 0, 8.7, 0), model, "Head")
	-- Hair
	AB.block(Vector3.new(2.2, 0.3, 2.2), HAIR, AB.offset(originCF, 0, 9.4, 0), model, "Hair")
	-- Side-comb part
	AB.block(Vector3.new(0.2, 0.4, 2.0), Color3.fromRGB(50, 38, 28), AB.offset(originCF, -0.7, 9.45, 0), model, "Part")

	-- Glasses (frame ring + lens shimmer)
	AB.block(Vector3.new(0.6, 0.5, 0.05), IRON, AB.offset(originCF, -0.55, 8.95, 1.0), model, "GlassFrameL")
	AB.block(Vector3.new(0.6, 0.5, 0.05), IRON, AB.offset(originCF,  0.55, 8.95, 1.0), model, "GlassFrameR")
	AB.block(Vector3.new(0.3, 0.05, 0.05), IRON, AB.offset(originCF, 0, 8.95, 1.0), model, "GlassBridge")
	local lensL = AB.block(Vector3.new(0.5, 0.4, 0.04), GLASS, AB.offset(originCF, -0.55, 8.95, 1.04), model, "LensL")
	local lensR = AB.block(Vector3.new(0.5, 0.4, 0.04), GLASS, AB.offset(originCF,  0.55, 8.95, 1.04), model, "LensR")
	lensL.Transparency = 0.5
	lensR.Transparency = 0.5

	-- Mouth (slight pursed look)
	AB.block(Vector3.new(0.9, 0.18, 0.2), Color3.new(0, 0, 0), AB.offset(originCF, 0, 8.25, 1.0), model, "Mouth")

	AB.billboard(model:FindFirstChild("Head") or torso, "BBQ Judge", Vector2.new(180, 36), 2.4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
