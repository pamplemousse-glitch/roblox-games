-- Bicycle Rack — a metal frame holding 3 simple bicycles (frame + wheels +
-- handlebar). A small "shopping bike" feel: front basket on each bike.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local METAL_GREY  = Color3.fromRGB(110, 110, 120)
local DARK_METAL  = Color3.fromRGB(55, 55, 65)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local STONE       = Color3.fromRGB(120, 115, 105)
local BIKE_COLORS = {
	Color3.fromRGB(60, 90, 130),    -- navy
	Color3.fromRGB(190, 60, 60),    -- red
	Color3.fromRGB(80, 130, 80),    -- green
}
local BASKET      = Color3.fromRGB(180, 150, 100)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BicycleRack", parent)

	-- Stone base strip
	AB.block(Vector3.new(12, 0.4, 3), STONE,
		AB.offset(originCF, 0, 0.2, 0), model, "Base")

	-- Rack bars — 4 vertical metal U-shapes
	for i, x in {-4.5, -1.5, 1.5, 4.5} do
		AB.cylinder(0.25, 2, METAL_GREY, AB.offset(originCF, x, 1.2, -0.6), model, "RackLegL_" .. i)
		AB.cylinder(0.25, 2, METAL_GREY, AB.offset(originCF, x, 1.2,  0.6), model, "RackLegR_" .. i)
		AB.cylinder(0.25, 1.6, METAL_GREY,
			AB.offset(originCF, x, 2.2, 0) * CFrame.Angles(math.rad(90), 0, 0),
			model, "RackTop_" .. i)
	end

	-- 3 bicycles parked between the bars
	for b = 1, 3 do
		local cx = (b - 2) * 3
		local color = BIKE_COLORS[b]
		-- Two wheels
		for j, dx in {-0.9, 0.9} do
			AB.cylinder(1.2, 0.2, IRON_BLACK,
				AB.offset(originCF, cx + dx, 0.9, 0) * CFrame.Angles(0, math.rad(90), 0),
				model, "Wheel_" .. b .. "_" .. j)
			-- Hub
			AB.cylinder(0.3, 0.25, METAL_GREY,
				AB.offset(originCF, cx + dx, 0.9, 0) * CFrame.Angles(0, math.rad(90), 0),
				model, "Hub_" .. b .. "_" .. j)
		end
		-- Frame top tube
		AB.cylinder(0.18, 1.8, color,
			AB.offset(originCF, cx, 1.8, 0) * CFrame.Angles(0, 0, math.rad(90)),
			model, "Frame_" .. b)
		-- Seat post
		AB.cylinder(0.15, 1, color,
			AB.offset(originCF, cx + 0.7, 2.2, 0), model, "SeatPost_" .. b)
		-- Seat
		AB.block(Vector3.new(0.7, 0.18, 0.3), IRON_BLACK,
			AB.offset(originCF, cx + 0.7, 2.7, 0), model, "Seat_" .. b)
		-- Handlebars
		AB.cylinder(0.15, 1.2, IRON_BLACK,
			AB.offset(originCF, cx - 0.7, 2.2, 0) * CFrame.Angles(math.rad(90), 0, 0),
			model, "Handles_" .. b)
		-- Front basket
		AB.block(Vector3.new(0.9, 0.6, 0.6), BASKET,
			AB.offset(originCF, cx - 0.9, 2.4, 0), model, "Basket_" .. b)
		-- Basket grid lines
		for j, dy in {0, 0.3} do
			AB.block(Vector3.new(0.95, 0.05, 0.65), DARK_METAL,
				AB.offset(originCF, cx - 0.9, 2.1 + dy, 0), model, "BasketRing_" .. b .. "_" .. j)
		end
		-- Pedals
		AB.block(Vector3.new(0.18, 0.18, 0.5), IRON_BLACK,
			AB.offset(originCF, cx, 1.2, 0.3), model, "Pedal_" .. b)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
