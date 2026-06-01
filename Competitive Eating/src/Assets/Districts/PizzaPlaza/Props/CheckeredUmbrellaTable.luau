-- Checkered Umbrella Table — outdoor cafe set: round table, 2 chairs, big
-- red-white checkered umbrella, with an espresso cup and bread basket on top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local RED       = Color3.fromRGB(200, 40, 40)
local WHITE     = Color3.fromRGB(245, 240, 230)
local TBL_WD    = Color3.fromRGB(110, 75, 45)
local DK_WD     = Color3.fromRGB(80, 50, 30)
local CUP       = Color3.fromRGB(245, 235, 220)
local ESPR      = Color3.fromRGB(60, 35, 20)
local BASKET    = Color3.fromRGB(190, 140, 80)
local BREAD     = Color3.fromRGB(220, 190, 130)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CheckeredUmbrellaTable", parent)

	-- Round wooden table
	AB.cylinder(4, 0.4, TBL_WD, AB.offset(originCF, 0, 3, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "TableTop")
	AB.cylinder(0.6, 3, DK_WD, AB.offset(originCF, 0, 1.5, 0), model, "TableLeg")
	-- Foot base
	AB.cylinder(2, 0.2, DK_WD, AB.offset(originCF, 0, 0.1, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "TableFoot")

	-- Red checkered tablecloth (square draped over edge)
	AB.block(Vector3.new(4.5, 0.3, 4.5), RED, AB.offset(originCF, 0, 3.2, 0), model, "Tablecloth")
	-- White check overlay (4 small squares)
	for i, off in {Vector3.new(-1, 0, -1), Vector3.new(1, 0, -1), Vector3.new(-1, 0, 1), Vector3.new(1, 0, 1)} do
		AB.block(Vector3.new(1.8, 0.32, 1.8), WHITE, AB.offset(originCF, off.X, 3.2, off.Z), model, "Check_" .. i)
	end

	-- Espresso cup
	AB.cylinder(0.8, 0.7, CUP, AB.offset(originCF, 0.8, 3.7, 0.4) * CFrame.Angles(0, 0, math.rad(90)), model, "Cup")
	AB.cylinder(0.7, 0.2, ESPR, AB.offset(originCF, 0.8, 3.95, 0.4) * CFrame.Angles(0, 0, math.rad(90)), model, "CupCoffee")
	-- Saucer
	AB.cylinder(1.2, 0.1, CUP, AB.offset(originCF, 0.8, 3.4, 0.4) * CFrame.Angles(0, 0, math.rad(90)), model, "Saucer")

	-- Bread basket
	AB.block(Vector3.new(1.4, 0.6, 1), BASKET, AB.offset(originCF, -1, 3.7, -0.2), model, "Basket")
	AB.sphere(0.5, BREAD, AB.offset(originCF, -1.2, 4.1, -0.2), model, "Roll1")
	AB.sphere(0.5, BREAD, AB.offset(originCF, -0.7, 4.1, 0.1), model, "Roll2")
	AB.sphere(0.5, BREAD, AB.offset(originCF, -0.9, 4.1, -0.5), model, "Roll3")

	-- Umbrella pole through the table
	AB.cylinder(0.4, 12, DK_WD, AB.offset(originCF, 0, 7, 0), model, "UmbPole")

	-- Umbrella canopy (8 wedges, alternating red/white)
	for i = 1, 8 do
		local angle = (i - 1) / 8 * 2 * math.pi
		local c = (i % 2 == 0) and RED or WHITE
		AB.wedge(Vector3.new(0.3, 2.5, 5), c,
			AB.offset(originCF, 0, 11.5, 0) * CFrame.Angles(0, angle, math.rad(-25)) * CFrame.new(0, 0.5, 2.5),
			model, "Wedge_" .. i)
	end
	-- Umbrella ruffle edge
	for i = 0, 7 do
		local angle = i / 8 * 2 * math.pi
		AB.wedge(Vector3.new(2, 0.4, 0.5), RED,
			AB.offset(originCF, 5 * math.cos(angle), 9.6, 5 * math.sin(angle)) * CFrame.Angles(math.rad(180), -angle, 0),
			model, "Ruffle_" .. i)
	end
	-- Finial
	AB.sphere(0.7, Color3.fromRGB(220, 180, 60), AB.offset(originCF, 0, 13.5, 0), model, "Finial")

	-- Two chairs (simple block + back)
	for i, sx in {-3.5, 3.5} do
		AB.block(Vector3.new(2, 0.3, 2), TBL_WD, AB.offset(originCF, sx, 2.2, 0), model, "ChairSeat_" .. i)
		AB.block(Vector3.new(2, 2.5, 0.3), TBL_WD, AB.offset(originCF, sx, 3.5, -0.9), model, "ChairBack_" .. i)
		for k, off in {Vector3.new(-0.8, 0, -0.8), Vector3.new(0.8, 0, -0.8), Vector3.new(-0.8, 0, 0.8), Vector3.new(0.8, 0, 0.8)} do
			AB.cylinder(0.2, 2.2, DK_WD, AB.offset(originCF, sx + off.X, 1.1, off.Z), model, "ChairLeg_" .. i .. "_" .. k)
		end
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
