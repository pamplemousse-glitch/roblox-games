-- Rib Shack — squat plank-walled rib joint with a corrugated tin roof,
-- open service window, big red "RIBS" sign, bone trim along the awning.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PLANK     = Color3.fromRGB(107, 68, 35)
local DARK      = Color3.fromRGB(70, 45, 22)
local TIN       = Color3.fromRGB(130, 130, 135)
local TIN_DARK  = Color3.fromRGB(85, 85, 92)
local BARN_RED  = Color3.fromRGB(160, 40, 40)
local STRAW     = Color3.fromRGB(232, 200, 112)
local BONE      = Color3.fromRGB(235, 225, 200)
local EMBER     = Color3.fromRGB(255, 128, 48)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RibShack", parent)

	local foundation = AB.block(Vector3.new(26, 0.6, 20), DARK, AB.offset(originCF, 0, 0.3, 0), model, "Foundation")

	-- Walls
	AB.block(Vector3.new(26, 10, 1), PLANK, AB.offset(originCF,  0, 5.6, -9.5), model, "BackWall")
	AB.block(Vector3.new(1, 10, 20), PLANK, AB.offset(originCF, -12.5, 5.6, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 10, 20), PLANK, AB.offset(originCF,  12.5, 5.6, 0), model, "RightWall")
	-- Front wall with big open service window
	AB.block(Vector3.new(6, 10, 1), PLANK, AB.offset(originCF, -10, 5.6, 9.5), model, "FrontL")
	AB.block(Vector3.new(6, 10, 1), PLANK, AB.offset(originCF,  10, 5.6, 9.5), model, "FrontR")
	-- Header above window
	AB.block(Vector3.new(14, 3, 1), PLANK, AB.offset(originCF, 0, 9.1, 9.5), model, "Header")
	-- Counter/sill at window
	AB.block(Vector3.new(14, 1, 1.5), DARK, AB.offset(originCF, 0, 3.1, 9.7), model, "Counter")

	-- Corrugated tin roof — alternating stripes for the "ribbed" look
	for i = -6, 6 do
		local col = (i % 2 == 0) and TIN or TIN_DARK
		AB.wedge(Vector3.new(2, 4, 11), col, AB.offset(originCF, i * 2, 12.6,  5.5) * CFrame.Angles(0, math.rad(180), 0), model, "RoofF_" .. i)
		AB.wedge(Vector3.new(2, 4, 11), col, AB.offset(originCF, i * 2, 12.6, -5.5), model, "RoofB_" .. i)
	end
	AB.block(Vector3.new(28, 0.5, 1.2), TIN_DARK, AB.offset(originCF, 0, 14.9, 0), model, "Ridge")

	-- Red awning over service window
	local awning = AB.block(Vector3.new(16, 0.5, 3.5), BARN_RED, AB.offset(originCF, 0, 10.7, 11.2), model, "Awning")
	awning.CFrame = awning.CFrame * CFrame.Angles(math.rad(-12), 0, 0)

	-- Bone trim hanging from awning
	for i = 1, 7 do
		local x = -7 + (i - 1) * (14 / 6)
		AB.cylinder(0.45, 1.6, BONE, AB.offset(originCF, x, 9.5, 12.5) * CFrame.Angles(0, 0, math.rad(90)), model, "Bone_" .. i)
		AB.sphere(0.7, BONE, AB.offset(originCF, x, 8.7, 12.5), model, "BoneTip_" .. i)
	end

	-- "RIBS" sign on header
	local sign = AB.block(Vector3.new(12, 3, 0.3), BARN_RED, AB.offset(originCF, 0, 9.0, 10.0), model, "Sign")
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.LightInfluence = 0
	gui.Parent = sign
	local lbl = Instance.new("TextLabel")
	lbl.Size              = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Font              = Enum.Font.GothamBlack
	lbl.Text              = "RIBS"
	lbl.TextColor3        = STRAW
	lbl.TextStrokeColor3  = Color3.new(0, 0, 0)
	lbl.TextStrokeTransparency = 0
	lbl.TextScaled        = true
	lbl.Parent            = gui

	-- Glowing ember warmer over counter
	for i, x in {-5, 0, 5} do
		local ember = AB.sphere(0.6, EMBER, AB.offset(originCF, x, 8.3, 9.7), model, "CounterLight_" .. i)
		AB.neon(ember)
		AB.glow(ember, EMBER, 1.6)
	end

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
