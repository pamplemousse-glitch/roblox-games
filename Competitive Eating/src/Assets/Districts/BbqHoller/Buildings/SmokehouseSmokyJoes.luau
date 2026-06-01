-- Smokehouse "Smoky Joe's" — V2 hero. Stained plank shack with a tall brick
-- chimney puffing thick neon smoke, hand-painted sign over the door, hanging
-- lanterns by the porch, sauce-stained doormat.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SMOKED_WOOD = Color3.fromRGB(107, 68, 35)
local DARK_WOOD   = Color3.fromRGB(70, 45, 22)
local ROOF        = Color3.fromRGB(45, 30, 22)
local BRICK       = Color3.fromRGB(140, 60, 50)
local SMOKE       = Color3.fromRGB(200, 200, 205)
local EMBER       = Color3.fromRGB(255, 128, 48)
local STRAW       = Color3.fromRGB(232, 200, 112)
local SAUCE       = Color3.fromRGB(140, 35, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SmokehouseSmokyJoes", parent)

	local foundation = AB.block(Vector3.new(28, 0.8, 22), DARK_WOOD, AB.offset(originCF, 0, 0.4, 0), model, "Foundation")

	-- Walls (stained plank)
	AB.block(Vector3.new(28, 13, 1),  SMOKED_WOOD, AB.offset(originCF,  0, 7.3, -10.5), model, "BackWall")
	AB.block(Vector3.new(1, 13, 22),  SMOKED_WOOD, AB.offset(originCF, -13.5, 7.3, 0),  model, "LeftWall")
	AB.block(Vector3.new(1, 13, 22),  SMOKED_WOOD, AB.offset(originCF,  13.5, 7.3, 0),  model, "RightWall")
	AB.block(Vector3.new(9, 13, 1),   SMOKED_WOOD, AB.offset(originCF, -9.5, 7.3, 10.5), model, "FrontLeft")
	AB.block(Vector3.new(9, 13, 1),   SMOKED_WOOD, AB.offset(originCF,  9.5, 7.3, 10.5), model, "FrontRight")
	AB.block(Vector3.new(10, 4, 1),   SMOKED_WOOD, AB.offset(originCF,  0, 11.8, 10.5), model, "Header")

	-- Plank stripes (horizontal accent boards on front)
	for i, y in {3, 6, 9} do
		AB.block(Vector3.new(9, 0.3, 0.5), DARK_WOOD, AB.offset(originCF, -9.5, y, 11), model, "PlankL_" .. i)
		AB.block(Vector3.new(9, 0.3, 0.5), DARK_WOOD, AB.offset(originCF,  9.5, y, 11), model, "PlankR_" .. i)
	end

	-- Door
	AB.block(Vector3.new(8, 9, 0.4), DARK_WOOD, AB.offset(originCF, 0, 5.3, 11.0), model, "Door")
	AB.sphere(0.35, EMBER, AB.offset(originCF, 2.7, 5.4, 11.3), model, "DoorKnob")
	-- Sauce-stained doormat
	AB.block(Vector3.new(7, 0.2, 2.5), SAUCE, AB.offset(originCF, 0, 0.9, 12.6), model, "DoorMat")

	-- Sloped roof
	AB.wedge(Vector3.new(30, 5, 12), ROOF, AB.offset(originCF, 0, 16.2,  6) * CFrame.Angles(0, math.rad(180), 0), model, "RoofFront")
	AB.wedge(Vector3.new(30, 5, 12), ROOF, AB.offset(originCF, 0, 16.2, -6), model, "RoofBack")
	-- Ridge cap
	AB.block(Vector3.new(30, 0.6, 1.2), DARK_WOOD, AB.offset(originCF, 0, 18.9, 0), model, "RidgeCap")

	-- Tall brick chimney (5 layers, set back)
	for layer = 1, 5 do
		AB.block(Vector3.new(3.6, 1.8, 3.6), BRICK, AB.offset(originCF, 8.5, 19 + (layer - 1) * 1.8, -3.5), model, "Chimney_" .. layer)
	end
	AB.block(Vector3.new(4.4, 0.6, 4.4), DARK_WOOD, AB.offset(originCF, 8.5, 28.5, -3.5), model, "ChimneyCap")

	-- Thick smoke puffs
	for i = 1, 6 do
		local puff = AB.sphere(2.2 + i * 0.45, SMOKE,
			AB.offset(originCF, 8.5 + math.sin(i) * 0.6, 30 + (i - 1) * 2.2, -3.5 + math.cos(i) * 0.4),
			model, "Smoke_" .. i)
		puff.Transparency = 0.18 + (i - 1) * 0.11
		puff.Material     = Enum.Material.Neon
	end

	-- Front porch (deck + 2 posts + small roof)
	AB.block(Vector3.new(20, 0.5, 4), DARK_WOOD, AB.offset(originCF, 0, 1.05, 13.5), model, "Porch")
	AB.block(Vector3.new(0.6, 5, 0.6), DARK_WOOD, AB.offset(originCF, -9, 3.8, 15), model, "PostL")
	AB.block(Vector3.new(0.6, 5, 0.6), DARK_WOOD, AB.offset(originCF,  9, 3.8, 15), model, "PostR")
	AB.block(Vector3.new(20, 0.6, 4.5), ROOF, AB.offset(originCF, 0, 6.6, 15), model, "PorchRoof")

	-- Sign over the door — "SMOKY JOE'S"
	local signBoard = AB.block(Vector3.new(11, 2.5, 0.4), DARK_WOOD, AB.offset(originCF, 0, 13.5, 11.3), model, "SignBoard")
	local signGui = Instance.new("SurfaceGui")
	signGui.Face = Enum.NormalId.Front
	signGui.LightInfluence = 0
	signGui.Parent = signBoard
	local signLabel = Instance.new("TextLabel")
	signLabel.Size              = UDim2.fromScale(1, 1)
	signLabel.BackgroundTransparency = 1
	signLabel.Font              = Enum.Font.GothamBlack
	signLabel.Text              = "SMOKY JOE'S"
	signLabel.TextColor3        = STRAW
	signLabel.TextStrokeColor3  = Color3.new(0, 0, 0)
	signLabel.TextStrokeTransparency = 0
	signLabel.TextScaled        = true
	signLabel.Parent            = signGui

	-- Hanging porch lanterns (ember-lit)
	for i, x in {-9, 9} do
		local lantern = AB.block(Vector3.new(0.9, 1.2, 0.9), DARK_WOOD, AB.offset(originCF, x, 6.0, 14.5), model, "Lantern_" .. i)
		local flame = AB.sphere(0.6, EMBER, AB.offset(originCF, x, 5.95, 14.5), model, "Flame_" .. i)
		AB.neon(flame)
		AB.glow(flame, EMBER, 2.2)
		local cord = AB.block(Vector3.new(0.1, 0.6, 0.1), DARK_WOOD, AB.offset(originCF, x, 6.85, 14.5), model, "Cord_" .. i)
		cord.Transparency = 0.2
		lantern.Reflectance = 0.05
	end

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
