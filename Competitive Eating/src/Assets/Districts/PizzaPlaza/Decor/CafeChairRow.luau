-- Cafe Chair Row — row of 4 simple bistro chairs for outdoor seating.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local IRON   = Color3.fromRGB(40, 40, 45)
local SEAT   = Color3.fromRGB(110, 75, 45)
local CUSH_R = Color3.fromRGB(200, 40, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CafeChairRow", parent)

	for i = 1, 4 do
		local x = -6 + (i - 1) * 4
		-- Seat
		AB.cylinder(1.6, 0.3, SEAT,
			AB.offset(originCF, x, 2.2, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Seat_" .. i)
		-- Red cushion
		AB.cylinder(1.4, 0.2, CUSH_R,
			AB.offset(originCF, x, 2.45, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Cushion_" .. i)
		-- Backrest (vertical curved bars)
		for k = -1, 1 do
			AB.cylinder(0.15, 3.5, IRON, AB.offset(originCF, x + k * 0.5, 3.5, -0.7), model, "BackBar_" .. i .. "_" .. k)
		end
		-- Top crossbar
		AB.cylinder(0.15, 1.4, IRON,
			AB.offset(originCF, x, 5, -0.7) * CFrame.Angles(0, 0, math.rad(90)), model, "BackTop_" .. i)
		-- Backrest cushion (small block)
		AB.block(Vector3.new(1.2, 1, 0.25), CUSH_R, AB.offset(originCF, x, 4, -0.6), model, "BackCush_" .. i)
		-- 4 legs
		for j, off in {Vector3.new(-0.7, 0, -0.7), Vector3.new(0.7, 0, -0.7), Vector3.new(-0.7, 0, 0.7), Vector3.new(0.7, 0, 0.7)} do
			AB.cylinder(0.18, 2, IRON, AB.offset(originCF, x + off.X, 1, off.Z), model, "Leg_" .. i .. "_" .. j)
		end
		-- Foot rest ring (decorative)
		AB.cylinder(0.12, 1, IRON, AB.offset(originCF, x, 1, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "FootRing_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
