-- PaintedCurbStripes — small section of painted asphalt with bright zone stripes
-- (think the iconic drive-in service-stall stripes).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PaintedCurbStripes", parent)
	local ASPHALT = Color3.fromRGB(50, 50, 55)
	local WHITE   = Color3.fromRGB(245, 245, 240)
	local YELLOW  = Color3.fromRGB(245, 220, 80)

	-- Asphalt patch
	local patch = AB.block(Vector3.new(10, 0.2, 6), ASPHALT, AB.offset(originCF, 0, 0.1, 0), model, "Patch")
	patch.Material = Enum.Material.Asphalt

	-- Two parallel parking lines (white)
	AB.block(Vector3.new(9, 0.22, 0.3), WHITE, AB.offset(originCF, 0, 0.22, -2), model, "Line1")
	AB.block(Vector3.new(9, 0.22, 0.3), WHITE, AB.offset(originCF, 0, 0.22,  2), model, "Line2")

	-- Diagonal yellow striping at one end
	for i = 0, 4 do
		AB.block(Vector3.new(2, 0.22, 0.3), YELLOW, AB.offset(originCF, -3.5 + i * 0.6, 0.23, 0) * CFrame.Angles(0, math.rad(45), 0), model, "Yellow_" .. i)
	end

	-- Stall number painted
	AB.block(Vector3.new(1.5, 0.23, 1.5), WHITE, AB.offset(originCF, 3.5, 0.23, 0), model, "StallNum")

	AB.pivot(model, patch)
	AB.weldAll(model)
	return model
end
