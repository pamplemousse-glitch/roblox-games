-- Sandwich Board Chalk Menu — A-frame sidewalk menu with chalk scribbles
-- listing the day's pizza specials.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WD        = Color3.fromRGB(110, 75, 45)
local DK_WD     = Color3.fromRGB(80, 50, 30)
local BOARD     = Color3.fromRGB(30, 35, 30)
local CHALK_W   = Color3.fromRGB(245, 240, 230)
local CHALK_R   = Color3.fromRGB(220, 80, 80)
local CHALK_Y   = Color3.fromRGB(240, 220, 100)
local CHALK_G   = Color3.fromRGB(120, 200, 130)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SandwichBoardChalkMenu", parent)

	-- Two boards forming an A-frame
	-- Left board (tilted -15° on z)
	AB.block(Vector3.new(0.3, 5, 4), DK_WD,
		AB.offset(originCF, -1, 2.7, 0) * CFrame.Angles(0, 0, math.rad(-15)), model, "FrameL")
	AB.block(Vector3.new(0.25, 4.5, 3.5), BOARD,
		AB.offset(originCF, -0.9, 2.7, 0) * CFrame.Angles(0, 0, math.rad(-15)), model, "BoardL")

	-- Right board (tilted +15°)
	AB.block(Vector3.new(0.3, 5, 4), DK_WD,
		AB.offset(originCF, 1, 2.7, 0) * CFrame.Angles(0, 0, math.rad(15)), model, "FrameR")
	AB.block(Vector3.new(0.25, 4.5, 3.5), BOARD,
		AB.offset(originCF, 0.9, 2.7, 0) * CFrame.Angles(0, 0, math.rad(15)), model, "BoardR")

	-- Hinge bar at top
	AB.cylinder(0.2, 4, WD,
		AB.offset(originCF, 0, 5, 0) * CFrame.Angles(math.rad(90), 0, 0), model, "HingeBar")

	-- Chalk title "OGGI" (yellow)
	AB.block(Vector3.new(0.05, 0.7, 2.5), CHALK_Y,
		AB.offset(originCF, -1.05, 4.5, 0) * CFrame.Angles(0, 0, math.rad(-15)), model, "TitleL")
	AB.block(Vector3.new(0.05, 0.7, 2.5), CHALK_Y,
		AB.offset(originCF, 1.05, 4.5, 0) * CFrame.Angles(0, 0, math.rad(15)), model, "TitleR")

	-- Menu items: 3 lines of white chalk + colored accents
	for i = 1, 3 do
		local y = 3.5 - (i - 1) * 0.8
		AB.block(Vector3.new(0.05, 0.3, 3), CHALK_W,
			AB.offset(originCF, -1.05, y, 0.2) * CFrame.Angles(0, 0, math.rad(-15)), model, "MenuL_" .. i)
		AB.block(Vector3.new(0.05, 0.3, 3), CHALK_W,
			AB.offset(originCF, 1.05, y, 0.2) * CFrame.Angles(0, 0, math.rad(15)), model, "MenuR_" .. i)
	end

	-- Price tag accents (red circles)
	for i = 1, 3 do
		local y = 3.5 - (i - 1) * 0.8
		AB.sphere(0.3, CHALK_R,
			AB.offset(originCF, -1.1, y, -1.3) * CFrame.Angles(0, 0, math.rad(-15)), model, "PriceL_" .. i)
		AB.sphere(0.3, CHALK_R,
			AB.offset(originCF, 1.1, y, -1.3) * CFrame.Angles(0, 0, math.rad(15)), model, "PriceR_" .. i)
	end

	-- Decorative pizza slice doodle bottom of left board (yellow wedge)
	AB.wedge(Vector3.new(0.05, 1, 1.5), CHALK_Y,
		AB.offset(originCF, -1.05, 1.2, 1) * CFrame.Angles(math.rad(180), 0, math.rad(-15 + 90)), model, "SliceDoodle")
	-- Pepperoni dots on the doodle
	AB.sphere(0.15, CHALK_R,
		AB.offset(originCF, -1.07, 1.3, 1.1) * CFrame.Angles(0, 0, math.rad(-15)), model, "DoodleDot1")
	AB.sphere(0.15, CHALK_R,
		AB.offset(originCF, -1.07, 1.5, 0.9) * CFrame.Angles(0, 0, math.rad(-15)), model, "DoodleDot2")

	-- Heart on right board (green)
	AB.sphere(0.3, CHALK_G,
		AB.offset(originCF, 1.07, 1.3, -1) * CFrame.Angles(0, 0, math.rad(15)), model, "HeartDoodle")

	-- Chalk tray + chalks at the base
	AB.block(Vector3.new(2, 0.3, 0.5), DK_WD, AB.offset(originCF, 0, 0.4, 1.6), model, "ChalkTray")
	for i, c in {CHALK_W, CHALK_R, CHALK_Y} do
		AB.cylinder(0.15, 0.8, c,
			AB.offset(originCF, -0.7 + (i - 1) * 0.7, 0.5, 1.6) * CFrame.Angles(0, math.rad(90), math.rad(90)),
			model, "Chalk_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
