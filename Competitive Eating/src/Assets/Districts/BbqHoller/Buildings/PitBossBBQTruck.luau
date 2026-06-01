-- Pit Boss BBQ Truck — vintage 50s food truck. Box trailer with a serving
-- window, striped awning, menu chalkboard, smokestack on top of the box,
-- chunky tires, cab up front with windshield.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TRUCK_RED  = Color3.fromRGB(160, 40, 40)
local CREAM      = Color3.fromRGB(235, 225, 200)
local TIRE_BLACK = Color3.fromRGB(28, 28, 30)
local RIM_GRAY   = Color3.fromRGB(140, 140, 145)
local CHROME     = Color3.fromRGB(200, 200, 205)
local DARK_WOOD  = Color3.fromRGB(70, 45, 22)
local CHALK      = Color3.fromRGB(35, 35, 35)
local STEEL      = Color3.fromRGB(95, 95, 100)
local SMOKE      = Color3.fromRGB(200, 200, 205)
local EMBER      = Color3.fromRGB(255, 128, 48)
local GLASS      = Color3.fromRGB(180, 220, 230)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PitBossBBQTruck", parent)

	-- Box trailer body
	local box = AB.block(Vector3.new(18, 8, 9), TRUCK_RED, AB.offset(originCF, 3, 5.5, 0), model, "Box")
	-- Cream stripe along the side
	AB.block(Vector3.new(18, 1.4, 0.1), CREAM, AB.offset(originCF, 3, 5.5, 4.56), model, "StripeR")
	AB.block(Vector3.new(18, 1.4, 0.1), CREAM, AB.offset(originCF, 3, 5.5, -4.56), model, "StripeL")
	-- Box roof
	AB.block(Vector3.new(18.4, 0.4, 9.4), CHROME, AB.offset(originCF, 3, 9.7, 0), model, "BoxRoof")

	-- Cab (front of truck, smaller)
	AB.block(Vector3.new(7, 6.5, 9), TRUCK_RED, AB.offset(originCF, -9.5, 4.75, 0), model, "Cab")
	-- Cab roof
	AB.block(Vector3.new(7.4, 0.4, 9.4), CHROME, AB.offset(originCF, -9.5, 8.15, 0), model, "CabRoof")
	-- Windshield (slanted)
	local windshield = AB.block(Vector3.new(0.3, 4, 8.4), GLASS, AB.offset(originCF, -12.4, 5.2, 0), model, "Windshield")
	windshield.Transparency = 0.4
	windshield.Reflectance  = 0.2
	-- Hood / grill
	AB.block(Vector3.new(3, 3.5, 8.5), TRUCK_RED, AB.offset(originCF, -14.5, 2.85, 0), model, "Hood")
	AB.block(Vector3.new(0.5, 1.5, 5), CHROME, AB.offset(originCF, -16.1, 3, 0), model, "FrontGrill")
	-- Headlights
	for i, z in {-3.2, 3.2} do
		local hl = AB.sphere(1.0, CREAM, AB.offset(originCF, -16.2, 3.6, z), model, "Headlight_" .. i)
		AB.neon(hl)
		AB.glow(hl, CREAM, 1.5)
	end
	-- Bumper
	AB.block(Vector3.new(0.5, 0.8, 9), CHROME, AB.offset(originCF, -16.4, 1.3, 0), model, "FrontBumper")

	-- Door on cab (left side, with tiny window)
	AB.block(Vector3.new(0.1, 4, 3), DARK_WOOD, AB.offset(originCF, -10, 4.5, 4.55), model, "CabDoorR")
	AB.block(Vector3.new(0.1, 1.2, 2), GLASS, AB.offset(originCF, -10, 5.6, 4.6), model, "CabWindowR")

	-- 4 wheels (axles along Z, so flat faces visible from the side)
	for i, p in {Vector3.new(-11, 1.4, 4.3), Vector3.new(-11, 1.4, -4.3), Vector3.new(7, 1.4, 4.3), Vector3.new(7, 1.4, -4.3)} do
		AB.cylinder(2.8, 1.4, TIRE_BLACK, originCF * CFrame.new(p) * CFrame.Angles(math.rad(90), 0, 0), model, "Wheel_" .. i)
		AB.cylinder(1.6, 1.5, RIM_GRAY, originCF * CFrame.new(p) * CFrame.Angles(math.rad(90), 0, 0), model, "Rim_" .. i)
	end

	-- Serving window (cut out on the right side of the box, hinged-up flap)
	AB.block(Vector3.new(9, 4, 0.1), CHALK, AB.offset(originCF, 3, 5.5, 4.61), model, "WindowGap")
	-- Counter sill
	AB.block(Vector3.new(9, 0.8, 1.6), DARK_WOOD, AB.offset(originCF, 3, 3.0, 5.2), model, "Counter")
	-- Hinged awning above window (cream + red stripes)
	for i = 1, 5 do
		local col = (i % 2 == 0) and CREAM or TRUCK_RED
		local x = 3 - 4 + (i - 1) * 2
		local awn = AB.block(Vector3.new(2, 0.3, 3.2), col, AB.offset(originCF, x, 8.5, 5.8), model, "Awn_" .. i)
		awn.CFrame = awn.CFrame * CFrame.Angles(math.rad(-20), 0, 0)
	end
	-- Chalkboard menu next to window
	local menu = AB.block(Vector3.new(2.5, 4, 0.2), CHALK, AB.offset(originCF, -2, 5.5, 4.7), model, "MenuBoard")
	local mGui = Instance.new("SurfaceGui")
	mGui.Face = Enum.NormalId.Front
	mGui.LightInfluence = 0
	mGui.Parent = menu
	local mLbl = Instance.new("TextLabel")
	mLbl.Size              = UDim2.fromScale(1, 1)
	mLbl.BackgroundTransparency = 1
	mLbl.Font              = Enum.Font.GothamBold
	mLbl.Text              = "BRISKET\nRIBS\nHOTLINK\nPULLED PORK"
	mLbl.TextColor3        = CREAM
	mLbl.TextScaled        = true
	mLbl.Parent            = mGui

	-- Smokestack on top of box (cylinder + cap + smoke puffs)
	for layer = 1, 3 do
		AB.cylinder(1.6, 1.6, STEEL, AB.offset(originCF, 6.5, 10.5 + (layer - 1) * 1.6, -2), model, "Stack_" .. layer)
	end
	AB.cylinder(2.0, 0.4, CHROME, AB.offset(originCF, 6.5, 15.6, -2), model, "StackCap")
	for i = 1, 4 do
		local puff = AB.sphere(1.6 + i * 0.3, SMOKE,
			AB.offset(originCF, 6.5 + math.sin(i) * 0.4, 17 + (i - 1) * 1.6, -2),
			model, "Smoke_" .. i)
		puff.Transparency = 0.25 + (i - 1) * 0.12
		puff.Material     = Enum.Material.Neon
	end

	-- "PIT BOSS" panel sign on the box side
	local sign = AB.block(Vector3.new(8, 1.8, 0.1), CREAM, AB.offset(originCF, 3, 8.4, 4.62), model, "TruckSign")
	local sGui = Instance.new("SurfaceGui")
	sGui.Face = Enum.NormalId.Front
	sGui.LightInfluence = 0
	sGui.Parent = sign
	local sLbl = Instance.new("TextLabel")
	sLbl.Size              = UDim2.fromScale(1, 1)
	sLbl.BackgroundTransparency = 1
	sLbl.Font              = Enum.Font.GothamBlack
	sLbl.Text              = "PIT BOSS BBQ"
	sLbl.TextColor3        = TRUCK_RED
	sLbl.TextStrokeColor3  = Color3.new(0, 0, 0)
	sLbl.TextStrokeTransparency = 0.4
	sLbl.TextScaled        = true
	sLbl.Parent            = sGui

	-- Glow under awning
	local underAwn = AB.sphere(0.7, EMBER, AB.offset(originCF, 3, 7.7, 5.6), model, "AwningGlow")
	AB.neon(underAwn)
	AB.glow(underAwn, EMBER, 2)

	AB.pivot(model, box)
	AB.weldAll(model)
	return model
end
