-- Brisket Barn — classic red barn with white trim, sliding wood door,
-- gambrel roof, hayloft window with X-cross bracing, weathervane on top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BARN_RED  = Color3.fromRGB(160, 40, 40)
local TRIM      = Color3.fromRGB(235, 225, 200)
local DARK_WOOD = Color3.fromRGB(70, 45, 22)
local ROOF      = Color3.fromRGB(95, 28, 28)
local STRAW     = Color3.fromRGB(232, 200, 112)
local STEEL     = Color3.fromRGB(120, 120, 125)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BrisketBarn", parent)

	local foundation = AB.block(Vector3.new(34, 0.8, 26), DARK_WOOD, AB.offset(originCF, 0, 0.4, 0), model, "Foundation")

	-- Walls (barn red)
	AB.block(Vector3.new(34, 16, 1), BARN_RED, AB.offset(originCF,  0, 8.8, -12.5), model, "BackWall")
	AB.block(Vector3.new(1, 16, 26), BARN_RED, AB.offset(originCF, -16.5, 8.8, 0),  model, "LeftWall")
	AB.block(Vector3.new(1, 16, 26), BARN_RED, AB.offset(originCF,  16.5, 8.8, 0),  model, "RightWall")
	-- Front wall with sliding door gap
	AB.block(Vector3.new(11, 16, 1), BARN_RED, AB.offset(originCF, -11.5, 8.8, 12.5), model, "FrontL")
	AB.block(Vector3.new(11, 16, 1), BARN_RED, AB.offset(originCF,  11.5, 8.8, 12.5), model, "FrontR")
	AB.block(Vector3.new(12, 4, 1),  BARN_RED, AB.offset(originCF, 0, 14.8, 12.5),    model, "Header")

	-- White trim corners
	for i, x in {-16.5, 16.5} do
		AB.block(Vector3.new(0.7, 16, 0.7), TRIM, AB.offset(originCF, x, 8.8, 12.5), model, "TrimFC_" .. i)
		AB.block(Vector3.new(0.7, 16, 0.7), TRIM, AB.offset(originCF, x, 8.8, -12.5), model, "TrimBC_" .. i)
	end
	-- White trim X on the door header
	local barnX1 = AB.block(Vector3.new(0.5, 4.5, 12), TRIM, AB.offset(originCF, 0, 16.8, 12.6), model, "XBrace1")
	barnX1.CFrame = barnX1.CFrame * CFrame.Angles(0, 0, math.rad(30))
	local barnX2 = AB.block(Vector3.new(0.5, 4.5, 12), TRIM, AB.offset(originCF, 0, 16.8, 12.6), model, "XBrace2")
	barnX2.CFrame = barnX2.CFrame * CFrame.Angles(0, 0, math.rad(-30))

	-- Sliding door (off-center to one side, like it's been slid open)
	AB.block(Vector3.new(11, 11.5, 0.4), DARK_WOOD, AB.offset(originCF, -3, 6.55, 12.95), model, "SlidingDoor")
	-- Door X-brace (planks)
	AB.block(Vector3.new(11, 0.3, 0.3), TRIM, AB.offset(originCF, -3, 11.6, 13.2), model, "DoorTop")
	AB.block(Vector3.new(11, 0.3, 0.3), TRIM, AB.offset(originCF, -3, 1.0, 13.2), model, "DoorBottom")
	local dX1 = AB.block(Vector3.new(0.3, 10, 0.3), TRIM, AB.offset(originCF, -3, 6.6, 13.2), model, "DoorBraceX1")
	dX1.CFrame = dX1.CFrame * CFrame.Angles(0, 0, math.rad(45))
	local dX2 = AB.block(Vector3.new(0.3, 10, 0.3), TRIM, AB.offset(originCF, -3, 6.6, 13.2), model, "DoorBraceX2")
	dX2.CFrame = dX2.CFrame * CFrame.Angles(0, 0, math.rad(-45))
	-- Sliding rail
	AB.block(Vector3.new(28, 0.3, 0.4), STEEL, AB.offset(originCF, 0, 13, 13.0), model, "SlideRail")

	-- Gambrel roof (two-pitch). Lower steep wedges + upper shallow wedges.
	-- Lower steep front/back
	AB.wedge(Vector3.new(36, 4.5, 6),  ROOF, AB.offset(originCF, 0, 18.4,  9) * CFrame.Angles(0, math.rad(180), 0), model, "LowRoofF")
	AB.wedge(Vector3.new(36, 4.5, 6),  ROOF, AB.offset(originCF, 0, 18.4, -9), model, "LowRoofB")
	-- Upper shallow front/back
	AB.wedge(Vector3.new(36, 3, 9),    ROOF, AB.offset(originCF, 0, 22.0,  4.5) * CFrame.Angles(0, math.rad(180), 0), model, "UpRoofF")
	AB.wedge(Vector3.new(36, 3, 9),    ROOF, AB.offset(originCF, 0, 22.0, -4.5), model, "UpRoofB")
	-- Ridge cap
	AB.block(Vector3.new(36, 0.5, 1.2), DARK_WOOD, AB.offset(originCF, 0, 24.0, 0), model, "RidgeCap")

	-- Hayloft window (round)
	AB.sphere(3.5, DARK_WOOD, AB.offset(originCF, 0, 18.5, 12.7), model, "LoftWindowFrame")
	AB.sphere(2.7, STRAW, AB.offset(originCF, 0, 18.5, 12.85), model, "LoftWindowInner")

	-- Weathervane on the roof (rooster silhouette)
	AB.block(Vector3.new(0.3, 5, 0.3), STEEL, AB.offset(originCF, 0, 27, 0), model, "VanePost")
	AB.block(Vector3.new(3, 0.3, 0.4), DARK_WOOD, AB.offset(originCF, 0, 29, 0), model, "VaneArrow")
	AB.block(Vector3.new(0.6, 1.4, 0.4), DARK_WOOD, AB.offset(originCF, 1.4, 29.7, 0), model, "VaneRooster")
	AB.block(Vector3.new(0.4, 0.4, 0.4), BARN_RED, AB.offset(originCF, 1.7, 30.5, 0), model, "VaneComb")

	-- Sign reading "BRISKET BARN" hanging from header
	local sign = AB.block(Vector3.new(14, 3, 0.4), TRIM, AB.offset(originCF, 0, 13.5, 13.2), model, "Sign")
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.LightInfluence = 0
	gui.Parent = sign
	local lbl = Instance.new("TextLabel")
	lbl.Size              = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Font              = Enum.Font.GothamBlack
	lbl.Text              = "BRISKET BARN"
	lbl.TextColor3        = BARN_RED
	lbl.TextStrokeColor3  = Color3.new(0, 0, 0)
	lbl.TextStrokeTransparency = 0.5
	lbl.TextScaled        = true
	lbl.Parent            = gui

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
