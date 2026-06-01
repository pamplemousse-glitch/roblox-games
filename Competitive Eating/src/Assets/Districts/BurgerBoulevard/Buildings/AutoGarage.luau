-- AutoGarage — open-bay garage with visible tool walls, lift, and a classic car
-- partially visible inside.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BRICK    = Color3.fromRGB(150, 60, 50)
local CHROME   = Color3.fromRGB(176, 176, 176)
local CREAM    = Color3.fromRGB(255, 245, 232)
local DARK     = Color3.fromRGB(50, 50, 55)
local OIL      = Color3.fromRGB(35, 35, 40)
local NEON_RED = Color3.fromRGB(255, 48, 48)
local YELLOW   = Color3.fromRGB(245, 195, 70)
local TEAL     = Color3.fromRGB(127, 202, 194)
local CAR_BLUE = Color3.fromRGB(80, 130, 200)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("AutoGarage", parent)

	-- Concrete pad
	local pad = AB.block(Vector3.new(28, 0.6, 22), OIL, AB.offset(originCF, 0, 0.3, 0), model, "Pad")
	pad.Material = Enum.Material.Concrete

	-- Oil stain
	AB.block(Vector3.new(4, 0.62, 3), Color3.fromRGB(20, 20, 25), AB.offset(originCF, 2, 0.62, 6), model, "OilStain1")

	-- Brick walls (back + sides)
	local back = AB.block(Vector3.new(28, 12, 1), BRICK, AB.offset(originCF, 0, 6.6, -10.5), model, "BackWall")
	back.Material = Enum.Material.Brick
	AB.block(Vector3.new(1, 12, 22), BRICK, AB.offset(originCF, -13.5, 6.6, 0), model, "LeftWall").Material = Enum.Material.Brick
	AB.block(Vector3.new(1, 12, 22), BRICK, AB.offset(originCF,  13.5, 6.6, 0), model, "RightWall").Material = Enum.Material.Brick

	-- Open front (big garage opening) — show 2 bays separated by a column
	-- Side fronts
	AB.block(Vector3.new(4, 12, 1), BRICK, AB.offset(originCF, -11.5, 6.6, 10.5), model, "FrontFarL").Material = Enum.Material.Brick
	AB.block(Vector3.new(4, 12, 1), BRICK, AB.offset(originCF,  11.5, 6.6, 10.5), model, "FrontFarR").Material = Enum.Material.Brick
	-- Center column
	AB.block(Vector3.new(1.5, 12, 1), BRICK, AB.offset(originCF, 0, 6.6, 10.5), model, "CenterColumn").Material = Enum.Material.Brick
	-- Front header above bays
	AB.block(Vector3.new(28, 3, 1), BRICK, AB.offset(originCF, 0, 11.1, 10.5), model, "FrontHeader").Material = Enum.Material.Brick

	-- Garage door frames (open)
	AB.block(Vector3.new(8, 0.4, 0.6), CHROME, AB.offset(originCF, -5.75, 9.4, 10.65), model, "BayLTrim")
	AB.block(Vector3.new(8, 0.4, 0.6), CHROME, AB.offset(originCF,  5.75, 9.4, 10.65), model, "BayRTrim")

	-- Corrugated metal sloped roof
	for i = 0, 6 do
		local x = -12 + i * 4
		AB.block(Vector3.new(4, 0.4, 22), CHROME, AB.offset(originCF, x, 13.2, 0), model, "RoofRib_" .. i).Material = Enum.Material.Metal
	end

	-- "GARAGE" hanging neon sign
	local hangSign = AB.block(Vector3.new(14, 2.5, 0.5), CREAM, AB.offset(originCF, 0, 13.5, 10.5), model, "HangSign")
	local hangNeon = AB.block(Vector3.new(12, 1.8, 0.6), NEON_RED, AB.offset(originCF, 0, 13.5, 10.7), model, "HangNeon")
	AB.neon(hangNeon); AB.glow(hangNeon, NEON_RED, 2.5)
	AB.billboard(hangSign, "AUTO GARAGE", Vector2.new(280, 60), 0)

	-- Inside left bay: a car on a lift (visible from front)
	-- Lift platform
	AB.block(Vector3.new(7, 0.5, 3.5), DARK, AB.offset(originCF, -6, 4, -2), model, "LiftPlatform")
	-- Hydraulic post
	AB.cylinder(1, 4, CHROME, AB.offset(originCF, -6, 2, -2), model, "LiftPost")
	-- Car body (block on lift)
	AB.block(Vector3.new(6, 1.5, 3), CAR_BLUE, AB.offset(originCF, -6, 5, -2), model, "CarBody")
	-- Car windshield (sky-blue glass)
	local shield = AB.block(Vector3.new(2.5, 1.2, 2.8), Color3.fromRGB(135, 206, 235), AB.offset(originCF, -7.5, 6, -2), model, "CarShield")
	shield.Material = Enum.Material.Glass; shield.Transparency = 0.4
	-- Wheels (small cylinders visible)
	AB.cylinder(1, 0.6, OIL, AB.offset(originCF, -8, 4.5, -0.5), model, "CarWheel1")
	AB.cylinder(1, 0.6, OIL, AB.offset(originCF, -4, 4.5, -0.5), model, "CarWheel2")

	-- Right bay: workbench + tools
	AB.block(Vector3.new(7, 3, 1.5), CREAM, AB.offset(originCF, 5, 2.5, -9), model, "Workbench")
	-- Tools on bench
	AB.block(Vector3.new(0.4, 1, 2), CHROME, AB.offset(originCF, 4, 4.5, -9), model, "ToolWrench1")
	AB.block(Vector3.new(0.4, 0.8, 1.5), CHROME, AB.offset(originCF, 5, 4.4, -9), model, "ToolWrench2")
	AB.block(Vector3.new(1.5, 1, 1), NEON_RED, AB.offset(originCF, 6.5, 4.5, -9), model, "ToolBox")
	-- Tire stack
	for i = 0, 2 do
		AB.cylinder(2.5, 0.8, OIL, AB.offset(originCF, 10, 1 + i * 0.85, -7), model, "TireStack_" .. i)
	end
	-- Pegboard with hanging tools (back wall accent)
	AB.block(Vector3.new(6, 4, 0.4), Color3.fromRGB(180, 130, 80), AB.offset(originCF, 5, 7, -10.2), model, "Pegboard")
	AB.block(Vector3.new(0.4, 1.8, 0.4), CHROME, AB.offset(originCF, 3, 6.5, -10), model, "PegTool1")
	AB.block(Vector3.new(0.4, 1.5, 0.4), CHROME, AB.offset(originCF, 4, 6.7, -10), model, "PegTool2")
	AB.block(Vector3.new(0.4, 2, 0.4), CHROME, AB.offset(originCF, 7, 6.5, -10), model, "PegTool3")

	-- Yellow gas can outside
	AB.block(Vector3.new(1.8, 2, 1.2), YELLOW, AB.offset(originCF, 12, 1.6, 7), model, "GasCan")
	AB.cylinder(0.3, 1, CHROME, AB.offset(originCF, 12, 3, 7), model, "GasCanSpout")

	-- Air-pump hose reel
	AB.cylinder(1.5, 0.8, NEON_RED, AB.offset(originCF, -12, 3, 8) * CFrame.Angles(0, 0, math.rad(90)), model, "HoseReel")

	-- "OPEN" small flag
	local flag = AB.block(Vector3.new(2.5, 1.2, 0.2), TEAL, AB.offset(originCF, -10, 8, 11.1), model, "OpenFlag")
	AB.billboard(flag, "OPEN", Vector2.new(80, 40), 0)

	AB.pivot(model, pad)
	AB.weldAll(model)
	return model
end
