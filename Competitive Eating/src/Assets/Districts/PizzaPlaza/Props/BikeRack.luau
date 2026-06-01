-- Bike Rack — steel U-rack with one parked bike (frame, wheels, basket).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STEEL     = Color3.fromRGB(150, 150, 160)
local DK_STL    = Color3.fromRGB(80, 80, 90)
local BIKE_BLU  = Color3.fromRGB(80, 120, 180)
local CHROME    = Color3.fromRGB(220, 220, 230)
local TIRE_BLK  = Color3.fromRGB(35, 30, 30)
local BASKET    = Color3.fromRGB(190, 140, 80)
local SADDLE    = Color3.fromRGB(80, 50, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BikeRack", parent)

	-- 3 U-bars in a row
	for i, x in {-3, 0, 3} do
		-- Vertical legs
		AB.cylinder(0.25, 3, STEEL, AB.offset(originCF, x - 0.5, 1.5, 0), model, "UBarLegL_" .. i)
		AB.cylinder(0.25, 3, STEEL, AB.offset(originCF, x + 0.5, 1.5, 0), model, "UBarLegR_" .. i)
		-- Top arc (cylinder horizontal)
		AB.cylinder(0.25, 1.5, STEEL,
			AB.offset(originCF, x, 3, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "UBarTop_" .. i)
		-- Base plates
		AB.block(Vector3.new(0.6, 0.2, 0.6), DK_STL, AB.offset(originCF, x - 0.5, 0.1, 0), model, "Plate1_" .. i)
		AB.block(Vector3.new(0.6, 0.2, 0.6), DK_STL, AB.offset(originCF, x + 0.5, 0.1, 0), model, "Plate2_" .. i)
	end

	-- One bike leaning against the middle U-bar
	-- Frame triangles (top tube + down tube + seat tube)
	AB.cylinder(0.2, 4, BIKE_BLU,
		AB.offset(originCF, 0.5, 2.5, 1.8) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(80)), model, "TopTube")
	AB.cylinder(0.2, 3.5, BIKE_BLU,
		AB.offset(originCF, 0.5, 1.7, 2.3) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(55)), model, "DownTube")
	AB.cylinder(0.2, 2.5, BIKE_BLU,
		AB.offset(originCF, 1.5, 2.2, 1.8), model, "SeatTube")

	-- Wheels (front + back)
	for i, sz in {1.3, 3.4} do
		AB.cylinder(2, 0.3, TIRE_BLK,
			AB.offset(originCF, 0.5, 1.3, sz) * CFrame.Angles(math.rad(90), 0, 0), model, "Tire_" .. i)
		AB.cylinder(1.6, 0.4, CHROME,
			AB.offset(originCF, 0.5, 1.3, sz) * CFrame.Angles(math.rad(90), 0, 0), model, "Rim_" .. i)
		-- Spokes
		for k = 0, 5 do
			AB.block(Vector3.new(0.05, 1.4, 0.05), CHROME,
				AB.offset(originCF, 0.5, 1.3, sz) * CFrame.Angles(math.rad(90), math.rad(k * 30), 0), model, "Spoke_" .. i .. "_" .. k)
		end
	end

	-- Saddle (leather)
	AB.block(Vector3.new(0.6, 0.3, 1), SADDLE, AB.offset(originCF, 1.5, 3.4, 1.8), model, "Saddle")

	-- Handlebars
	AB.cylinder(0.15, 1.6, CHROME,
		AB.offset(originCF, 0.5, 3.4, 3.4) * CFrame.Angles(0, 0, math.rad(90)), model, "Handlebar")
	AB.cylinder(0.15, 1, CHROME, AB.offset(originCF, 0.5, 2.7, 3.4), model, "Stem")
	AB.sphere(0.2, BIKE_BLU, AB.offset(originCF, -0.3, 3.4, 3.4), model, "GripL")
	AB.sphere(0.2, BIKE_BLU, AB.offset(originCF, 1.3, 3.4, 3.4), model, "GripR")

	-- Basket on front handlebars (wicker)
	AB.block(Vector3.new(1.6, 1.2, 1.4), BASKET, AB.offset(originCF, 0.5, 3.6, 3.9), model, "Basket")
	AB.block(Vector3.new(1.7, 0.15, 1.5), Color3.fromRGB(130, 90, 50),
		AB.offset(originCF, 0.5, 4.2, 3.9), model, "BasketRim")
	-- Baguette poking out
	AB.cylinder(0.3, 2, Color3.fromRGB(220, 190, 130),
		AB.offset(originCF, 0.5, 4.4, 3.9) * CFrame.Angles(math.rad(30), 0, math.rad(90)), model, "Baguette")
	-- Apple in basket
	AB.sphere(0.4, Color3.fromRGB(200, 50, 50), AB.offset(originCF, 0.8, 4, 3.6), model, "Apple")

	-- Bell on handlebar
	AB.cylinder(0.3, 0.4, CHROME,
		AB.offset(originCF, 1, 3.6, 3.4), model, "Bell")

	-- Chain lock dangling
	AB.cylinder(0.15, 1.5, CHROME, AB.offset(originCF, 0.5, 2, 1.5), model, "ChainLock")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
