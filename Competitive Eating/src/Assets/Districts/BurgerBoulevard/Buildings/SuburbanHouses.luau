-- SuburbanHouses — row of 3 small picket-fence single-story homes, mid-century
-- ranch-style. Pastel colors, white trim, low-pitched roofs.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PASTEL_BLUE  = Color3.fromRGB(170, 200, 220)
local PASTEL_PINK  = Color3.fromRGB(240, 200, 200)
local PASTEL_YELL  = Color3.fromRGB(245, 230, 170)
local WHITE_TRIM   = Color3.fromRGB(245, 245, 245)
local DARK_ROOF    = Color3.fromRGB(70, 50, 50)
local CHIMNEY_RED  = Color3.fromRGB(150, 60, 50)
local SKY          = Color3.fromRGB(135, 206, 235)
local GRASS        = Color3.fromRGB(110, 180, 90)
local DOOR_RED     = Color3.fromRGB(180, 30, 40)
local DOOR_BLUE    = Color3.fromRGB(40, 80, 140)
local DOOR_GREEN   = Color3.fromRGB(60, 140, 80)
local FENCE        = Color3.fromRGB(245, 245, 240)

local function buildHouse(parent: Instance, originCF: CFrame, name: string, wallColor: Color3, doorColor: Color3)
	-- Lawn
	local lawn = AB.block(Vector3.new(16, 0.3, 14), GRASS, AB.offset(originCF, 0, 0.15, 0), parent, name .. "_Lawn")
	lawn.Material = Enum.Material.Grass
	-- Foundation
	AB.block(Vector3.new(12, 0.6, 10), Color3.fromRGB(110, 110, 110), AB.offset(originCF, 0, 0.6, -1), parent, name .. "_Foundation").Material = Enum.Material.Concrete
	-- Walls
	AB.block(Vector3.new(12, 5, 1),  wallColor, AB.offset(originCF, 0, 3.4, -5.5), parent, name .. "_Back")
	AB.block(Vector3.new(1,  5, 10), wallColor, AB.offset(originCF, -5.5, 3.4, -1), parent, name .. "_Left")
	AB.block(Vector3.new(1,  5, 10), wallColor, AB.offset(originCF,  5.5, 3.4, -1), parent, name .. "_Right")
	-- Front w/ door + window
	AB.block(Vector3.new(3, 5, 1), wallColor, AB.offset(originCF, -4, 3.4, 3.5), parent, name .. "_FrontL")
	AB.block(Vector3.new(3, 5, 1), wallColor, AB.offset(originCF,  4, 3.4, 3.5), parent, name .. "_FrontR")
	AB.block(Vector3.new(6, 1.5, 1), wallColor, AB.offset(originCF, 0, 5.65, 3.5), parent, name .. "_FrontHeader")
	-- Door
	AB.block(Vector3.new(2.5, 4, 0.3), doorColor, AB.offset(originCF, 0, 2.9, 4.1), parent, name .. "_Door")
	AB.sphere(0.3, Color3.fromRGB(220, 200, 100), AB.offset(originCF, 0.8, 2.9, 4.3), parent, name .. "_DoorKnob")
	-- Side windows
	for _, x in {-4, 4} do
		local win = AB.block(Vector3.new(2, 2.5, 0.3), SKY, AB.offset(originCF, x, 4, 4.1), parent, name .. "_Win_" .. x)
		win.Material = Enum.Material.Glass; win.Transparency = 0.5
		AB.block(Vector3.new(2.4, 0.25, 0.4), WHITE_TRIM, AB.offset(originCF, x, 5.3, 4.2), parent, name .. "_WinT_" .. x)
		AB.block(Vector3.new(2.4, 0.25, 0.4), WHITE_TRIM, AB.offset(originCF, x, 2.7, 4.2), parent, name .. "_WinB_" .. x)
		AB.block(Vector3.new(0.25, 2.7, 0.4), WHITE_TRIM, AB.offset(originCF, x, 4, 4.2), parent, name .. "_WinM_" .. x)
		-- Shutters
		AB.block(Vector3.new(0.4, 2.6, 0.5), wallColor:Lerp(Color3.new(0,0,0), 0.4), AB.offset(originCF, x - 1.4, 4, 4.2), parent, name .. "_ShutterL_" .. x)
		AB.block(Vector3.new(0.4, 2.6, 0.5), wallColor:Lerp(Color3.new(0,0,0), 0.4), AB.offset(originCF, x + 1.4, 4, 4.2), parent, name .. "_ShutterR_" .. x)
	end
	-- Low-pitched roof (two wedges)
	AB.wedge(Vector3.new(6, 1.5, 12), DARK_ROOF, AB.offset(originCF, -3, 6.95, -1) * CFrame.Angles(0, math.rad(90), 0), parent, name .. "_RoofL").Material = Enum.Material.Slate
	AB.wedge(Vector3.new(6, 1.5, 12), DARK_ROOF, AB.offset(originCF,  3, 6.95, -1) * CFrame.Angles(0, math.rad(-90), 0), parent, name .. "_RoofR").Material = Enum.Material.Slate
	AB.block(Vector3.new(12.4, 0.4, 12.4), DARK_ROOF, AB.offset(originCF, 0, 6.2, -1), parent, name .. "_RoofBase").Material = Enum.Material.Slate
	-- Chimney
	AB.block(Vector3.new(1.5, 3, 1.5), CHIMNEY_RED, AB.offset(originCF, 3, 8, -3), parent, name .. "_Chimney").Material = Enum.Material.Brick
	-- White picket fence in front
	for i = 0, 7 do
		AB.block(Vector3.new(0.3, 1.8, 0.3), FENCE, AB.offset(originCF, -7 + i * 2, 1.2, 6.5), parent, name .. "_Picket_" .. i)
	end
	AB.block(Vector3.new(15, 0.2, 0.4), FENCE, AB.offset(originCF, 0, 1.9, 6.5), parent, name .. "_FenceRailTop")
	AB.block(Vector3.new(15, 0.2, 0.4), FENCE, AB.offset(originCF, 0, 0.8, 6.5), parent, name .. "_FenceRailBot")
	-- Mailbox
	AB.cylinder(0.4, 2, WHITE_TRIM, AB.offset(originCF, 6, 1.1, 6.2), parent, name .. "_MailboxPost")
	AB.block(Vector3.new(1, 0.8, 1.5), wallColor, AB.offset(originCF, 6, 2.4, 6.2), parent, name .. "_MailboxBody")
	-- Walkway
	AB.block(Vector3.new(2, 0.2, 3), WHITE_TRIM, AB.offset(originCF, 0, 0.4, 5), parent, name .. "_Walkway1")
end

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SuburbanHouses", parent)

	buildHouse(model, AB.offset(originCF, -18, 0, 0), "House1", PASTEL_BLUE, DOOR_RED)
	buildHouse(model, AB.offset(originCF,   0, 0, 0), "House2", PASTEL_PINK, DOOR_GREEN)
	buildHouse(model, AB.offset(originCF,  18, 0, 0), "House3", PASTEL_YELL, DOOR_BLUE)

	-- A shared driveway / sidewalk in front of all 3
	local sidewalk = AB.block(Vector3.new(54, 0.3, 2), Color3.fromRGB(180, 180, 180), AB.offset(originCF, 0, 0.45, 8), model, "Sidewalk")
	sidewalk.Material = Enum.Material.Concrete

	-- Anchor reference
	local anchor = AB.block(Vector3.new(0.2, 0.2, 0.2), Color3.fromRGB(100, 100, 100), originCF, model, "Anchor")
	anchor.Transparency = 1

	AB.pivot(model, sidewalk)
	AB.weldAll(model)
	return model
end
