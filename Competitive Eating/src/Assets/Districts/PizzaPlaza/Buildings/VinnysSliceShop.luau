-- Vinny's Slice Shop — corner takeaway joint with a long counter window
-- where pies sit under a heat lamp. Yellow walls, neon "BY THE SLICE".

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local YELLOW    = Color3.fromRGB(240, 200, 80)
local BRICK     = Color3.fromRGB(150, 60, 50)
local COUNTER   = Color3.fromRGB(180, 175, 165)
local LAMP_HOT  = Color3.fromRGB(255, 140, 60)
local GREEN_NEON= Color3.fromRGB(100, 230, 120)
local WOOD      = Color3.fromRGB(80, 50, 30)
local STEEL     = Color3.fromRGB(160, 160, 170)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("VinnysSliceShop", parent)

	-- Foundation
	AB.block(Vector3.new(28, 0.5, 22), Color3.fromRGB(100, 100, 100),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Walls (yellow stucco)
	AB.block(Vector3.new(28, 14, 1), YELLOW, AB.offset(originCF, 0, 7, -10.5), model, "BackWall")
	AB.block(Vector3.new(1, 14, 22), YELLOW, AB.offset(originCF, -13.5, 7, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 14, 22), YELLOW, AB.offset(originCF,  13.5, 7, 0), model, "RightWall")
	-- Front facade with big counter cutout (3 studs to 11 studs height = the counter window)
	AB.block(Vector3.new(28, 3, 1), YELLOW, AB.offset(originCF, 0, 1.5, 10.5), model, "FrontKneeWall")
	AB.block(Vector3.new(28, 3, 1), YELLOW, AB.offset(originCF, 0, 12.5, 10.5), model, "FrontHeader")
	AB.block(Vector3.new(4, 8, 1), YELLOW, AB.offset(originCF, -12, 7, 10.5), model, "FrontLeftPier")
	AB.block(Vector3.new(4, 8, 1), YELLOW, AB.offset(originCF,  12, 7, 10.5), model, "FrontRightPier")

	-- Brick base trim (red brick along the bottom)
	AB.block(Vector3.new(28, 2, 1.1), BRICK, AB.offset(originCF, 0, 1, 10.6), model, "BrickTrim")
	-- Brick corners
	AB.block(Vector3.new(1.2, 14, 1.2), BRICK, AB.offset(originCF, -13.5, 7, 10.5), model, "BrickCornerL")
	AB.block(Vector3.new(1.2, 14, 1.2), BRICK, AB.offset(originCF,  13.5, 7, 10.5), model, "BrickCornerR")

	-- Counter (steel slab)
	AB.block(Vector3.new(20, 1, 2), COUNTER, AB.offset(originCF, 0, 3.5, 11), model, "CounterTop")
	AB.block(Vector3.new(20, 0.4, 0.4), STEEL, AB.offset(originCF, 0, 4, 12), model, "CounterEdge")

	-- Heat-lamp tray with pizzas displayed (3 yellow discs)
	for i, x in {-6, 0, 6} do
		local disc = AB.cylinder(2.8, 0.25, AB.colors.pizzaCrust,
			AB.offset(originCF, x, 4.4, 11) * CFrame.Angles(0, 0, math.rad(90)), model, "Pie_" .. i)
		disc.Material = Enum.Material.SmoothPlastic
		-- Pepperoni dots
		for j = 1, 4 do
			AB.sphere(0.4, AB.colors.pizzaRed,
				AB.offset(originCF, x + math.cos(j) * 0.8, 4.6, 11 + math.sin(j) * 0.8),
				model, "Pep_" .. i .. "_" .. j)
		end
	end

	-- Heat lamp bar (warm glow)
	local heatBar = AB.block(Vector3.new(20, 0.4, 0.6), LAMP_HOT, AB.offset(originCF, 0, 11.5, 11), model, "HeatLamp")
	AB.neon(heatBar)
	AB.glow(heatBar, heatBar.Color, 2)
	-- Heat lamp hood
	AB.block(Vector3.new(20.5, 0.5, 2), STEEL, AB.offset(originCF, 0, 11.9, 11.2), model, "HeatHood")

	-- Big yellow "VINNY'S" sign mounted above the counter
	local sign = AB.block(Vector3.new(22, 4, 0.5), YELLOW, AB.offset(originCF, 0, 16, 10.7), model, "Sign")
	AB.block(Vector3.new(22.5, 0.4, 0.7), WOOD, AB.offset(originCF, 0, 18, 10.7), model, "SignTop")
	AB.block(Vector3.new(22.5, 0.4, 0.7), WOOD, AB.offset(originCF, 0, 14, 10.7), model, "SignBot")
	-- Neon "BY THE SLICE" stripe
	local slice = AB.block(Vector3.new(18, 1.4, 0.3), GREEN_NEON, AB.offset(originCF, 0, 16, 11.0), model, "SliceNeon")
	AB.neon(slice)
	AB.glow(slice, slice.Color, 2)
	-- Pizza-slice icon on left edge of sign (wedge)
	AB.wedge(Vector3.new(2.5, 2.5, 0.5), AB.colors.pizzaRed,
		AB.offset(originCF, -10, 16, 11.0) * CFrame.Angles(math.rad(180), 0, math.rad(90)), model, "SliceIcon")

	-- Roof (flat with parapet)
	AB.block(Vector3.new(30, 0.6, 24), Color3.fromRGB(110, 100, 90), AB.offset(originCF, 0, 14.3, 0), model, "Roof")
	AB.block(Vector3.new(30, 1.5, 0.6), BRICK, AB.offset(originCF, 0, 15, 12), model, "ParapetFront")
	AB.block(Vector3.new(30, 1.5, 0.6), BRICK, AB.offset(originCF, 0, 15, -12), model, "ParapetBack")

	-- Awning stripe (white-yellow checker)
	for i = -5, 5 do
		AB.block(Vector3.new(2, 0.6, 3), (i % 2 == 0) and YELLOW or Color3.fromRGB(255, 255, 240),
			AB.offset(originCF, i * 2.5, 13.5, 12.5), model, "Awning_" .. (i + 6))
	end

	-- Sidewalk + chalkboard A-frame in front
	AB.block(Vector3.new(28, 0.4, 4), Color3.fromRGB(180, 180, 175),
		AB.offset(originCF, 0, 0.4, 13), model, "Sidewalk")

	-- Cash register on counter (small black box)
	AB.block(Vector3.new(2, 1.2, 1.5), Color3.fromRGB(40, 40, 40), AB.offset(originCF, 10, 4.6, 11), model, "Register")
	AB.block(Vector3.new(1.8, 0.5, 0.2), Color3.fromRGB(80, 200, 255), AB.offset(originCF, 10, 5.3, 11.2), model, "RegScreen")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
