-- Tony's Pizzeria — flagship pizza joint. Red striped awning, big glowing
-- "PIZZA" neon sign, brick walls, mozzarella-yellow trim, big plate-glass
-- window with a pizza display, double doors, chimney puffing smoke vibes.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BRICK     = Color3.fromRGB(150, 60, 50)
local TRIM      = Color3.fromRGB(255, 215, 80)
local AWNING_R  = Color3.fromRGB(200, 40, 40)
local STRIPE    = Color3.fromRGB(255, 255, 240)
local NEON_RED  = Color3.fromRGB(255, 60, 40)
local GLASS     = Color3.fromRGB(200, 220, 235)
local DOOR_BR   = Color3.fromRGB(80, 50, 30)
local ROOF      = Color3.fromRGB(90, 70, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TonysPizzeria", parent)

	-- Foundation
	AB.block(Vector3.new(34, 0.5, 26), Color3.fromRGB(100, 100, 100),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Back + side walls (brick)
	AB.block(Vector3.new(34, 18, 1), BRICK, AB.offset(originCF, 0, 9, -12.5), model, "BackWall")
	AB.block(Vector3.new(1, 18, 26), BRICK, AB.offset(originCF, -16.5, 9, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 18, 26), BRICK, AB.offset(originCF,  16.5, 9, 0), model, "RightWall")

	-- Front facade pieces (brick) with central door + flanking window cutouts
	AB.block(Vector3.new(8, 18, 1), BRICK, AB.offset(originCF, -13, 9, 12.5), model, "FrontFarLeft")
	AB.block(Vector3.new(8, 18, 1), BRICK, AB.offset(originCF,  13, 9, 12.5), model, "FrontFarRight")
	AB.block(Vector3.new(4, 6, 1),  BRICK, AB.offset(originCF, -7, 15, 12.5), model, "FrontWinAboveL")
	AB.block(Vector3.new(4, 6, 1),  BRICK, AB.offset(originCF,  7, 15, 12.5), model, "FrontWinAboveR")
	AB.block(Vector3.new(4, 4, 1),  BRICK, AB.offset(originCF, -7, 4,  12.5), model, "FrontWinBelowL")
	AB.block(Vector3.new(4, 4, 1),  BRICK, AB.offset(originCF,  7, 4,  12.5), model, "FrontWinBelowR")
	AB.block(Vector3.new(6, 4, 1),  BRICK, AB.offset(originCF, 0, 16, 12.5), model, "FrontHeaderTop")

	-- Plate-glass windows (the cutouts)
	local winL = AB.block(Vector3.new(4, 5, 0.4), GLASS, AB.offset(originCF, -7, 9.5, 12.7), model, "WindowL")
	winL.Transparency = 0.4
	local winR = AB.block(Vector3.new(4, 5, 0.4), GLASS, AB.offset(originCF,  7, 9.5, 12.7), model, "WindowR")
	winR.Transparency = 0.4
	-- Mullions (window frame crosses)
	for i, x in {-7, 7} do
		AB.block(Vector3.new(0.2, 5, 0.6), DOOR_BR, AB.offset(originCF, x, 9.5, 12.8), model, "WinMullV_" .. i)
		AB.block(Vector3.new(4, 0.2, 0.6), DOOR_BR, AB.offset(originCF, x, 9.5, 12.8), model, "WinMullH_" .. i)
	end

	-- Display pizza in the left window (yellow disc + red dots)
	local disc = AB.cylinder(2.6, 0.2, AB.colors.pizzaCrust, AB.offset(originCF, -7, 9.5, 13.0) * CFrame.Angles(0, 0, math.rad(90)), model, "WindowPizzaDisc")
	disc.Material = Enum.Material.SmoothPlastic
	for i, off in {Vector3.new(0.5, 0, 0.3), Vector3.new(-0.4, 0, -0.5), Vector3.new(0.8, 0, -0.2)} do
		AB.sphere(0.45, AB.colors.pepperoni or AB.colors.pizzaRed, AB.offset(originCF, -7 + off.X, 9.7, 13.0 + off.Z), model, "Pepperoni_" .. i)
	end

	-- Door frame + double doors (dark wood)
	AB.block(Vector3.new(6, 8, 1), DOOR_BR, AB.offset(originCF, 0, 4, 12.5), model, "DoorFrame")
	AB.block(Vector3.new(2.6, 7, 0.4), DOOR_BR, AB.offset(originCF, -1.4, 3.5, 12.8), model, "DoorL")
	AB.block(Vector3.new(2.6, 7, 0.4), DOOR_BR, AB.offset(originCF,  1.4, 3.5, 12.8), model, "DoorR")
	-- Door handles
	AB.sphere(0.3, TRIM, AB.offset(originCF, -0.2, 3.5, 13.05), model, "HandleL")
	AB.sphere(0.3, TRIM, AB.offset(originCF,  0.2, 3.5, 13.05), model, "HandleR")
	-- Transom window above door
	local trans = AB.block(Vector3.new(6, 1.6, 0.3), GLASS, AB.offset(originCF, 0, 8.5, 12.7), model, "Transom")
	trans.Transparency = 0.5

	-- Red striped awning above the door (4 stripes)
	AB.block(Vector3.new(16, 0.8, 5), AWNING_R, AB.offset(originCF, 0, 11, 14.5), model, "AwningBase")
	for i, x in {-6, -2, 2, 6} do
		AB.block(Vector3.new(2.5, 1, 5), STRIPE, AB.offset(originCF, x, 11, 14.5), model, "AwningStripe_" .. i)
	end
	-- Awning scallop edge (small triangles wedge)
	for i = -3, 3 do
		AB.wedge(Vector3.new(2.4, 1.1, 1.2), (i % 2 == 0) and AWNING_R or STRIPE,
			AB.offset(originCF, i * 2.2, 10.3, 16.4) * CFrame.Angles(math.rad(180), 0, 0), model, "AwningScallop_" .. (i + 4))
	end

	-- Big neon "PIZZA" sign above awning
	local sign = AB.block(Vector3.new(18, 3, 0.6), NEON_RED, AB.offset(originCF, 0, 14.5, 13), model, "NeonPIZZASign")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 3)
	-- Sign frame
	AB.block(Vector3.new(18.6, 0.4, 0.8), DOOR_BR, AB.offset(originCF, 0, 16.2, 13), model, "SignFrameTop")
	AB.block(Vector3.new(18.6, 0.4, 0.8), DOOR_BR, AB.offset(originCF, 0, 12.8, 13), model, "SignFrameBot")
	-- Sign brackets
	for i, x in {-7, 7} do
		AB.block(Vector3.new(0.6, 4, 0.6), DOOR_BR, AB.offset(originCF, x, 14.5, 12.7), model, "SignBracket_" .. i)
	end

	-- Roof + cornice trim (yellow)
	AB.block(Vector3.new(36, 1, 28), ROOF, AB.offset(originCF, 0, 18.5, 0), model, "Roof")
	AB.block(Vector3.new(36, 0.8, 28.4), TRIM, AB.offset(originCF, 0, 17.8, 0), model, "Cornice")

	-- Brick chimney with pizza-oven heat shimmer (warm glow)
	AB.block(Vector3.new(3, 5, 3), BRICK, AB.offset(originCF, 12, 21, -6), model, "Chimney")
	AB.block(Vector3.new(3.4, 0.3, 3.4), DOOR_BR, AB.offset(originCF, 12, 23.5, -6), model, "ChimneyCap")
	local chimneyGlow = AB.block(Vector3.new(2, 0.4, 2), Color3.fromRGB(255, 140, 60),
		AB.offset(originCF, 12, 23.7, -6), model, "ChimneyEmber")
	AB.neon(chimneyGlow)
	AB.glow(chimneyGlow, chimneyGlow.Color, 1.5)

	-- Open neon "OPEN" in the right window
	local openSign = AB.block(Vector3.new(2.4, 0.9, 0.3), Color3.fromRGB(80, 200, 255),
		AB.offset(originCF, 7, 11, 12.9), model, "OpenSign")
	AB.neon(openSign)
	AB.glow(openSign, openSign.Color, 1.2)

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
