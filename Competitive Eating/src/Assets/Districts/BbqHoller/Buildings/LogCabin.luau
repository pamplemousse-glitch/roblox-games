-- Log Cabin — stacked rectangular "logs" (thin alternating blocks) for walls,
-- stone chimney, small porch. Cozy backdrop building.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local LOG       = Color3.fromRGB(120, 80, 45)
local LOG_DARK  = Color3.fromRGB(90, 60, 35)
local ROOF      = Color3.fromRGB(50, 35, 25)
local STONE     = Color3.fromRGB(110, 100, 92)
local STONE_D   = Color3.fromRGB(80, 72, 65)
local EMBER     = Color3.fromRGB(255, 128, 48)
local DARK_WOOD = Color3.fromRGB(70, 45, 22)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("LogCabin", parent)

	local foundation = AB.block(Vector3.new(18, 0.6, 14), STONE_D, AB.offset(originCF, 0, 0.3, 0), model, "Foundation")

	-- Stacked log walls — 8 rows of alternating-tone log bands
	local logH = 1.4
	for r = 1, 8 do
		local y = 1 + (r - 1) * logH
		local col = (r % 2 == 0) and LOG or LOG_DARK
		-- Back wall (one full log along X)
		AB.block(Vector3.new(18, logH, 1), col, AB.offset(originCF, 0, y, -6.7), model, "LogBack_" .. r)
		-- Side walls (logs along Z)
		AB.block(Vector3.new(1, logH, 14), col, AB.offset(originCF, -8.7, y, 0), model, "LogLeft_" .. r)
		AB.block(Vector3.new(1, logH, 14), col, AB.offset(originCF,  8.7, y, 0), model, "LogRight_" .. r)
		-- Front wall (split into two halves with door gap, except top/bottom)
		if r <= 2 or r >= 7 then
			AB.block(Vector3.new(18, logH, 1), col, AB.offset(originCF, 0, y, 6.7), model, "LogFront_" .. r)
		else
			AB.block(Vector3.new(6, logH, 1), col, AB.offset(originCF, -6, y, 6.7), model, "LogFrontL_" .. r)
			AB.block(Vector3.new(6, logH, 1), col, AB.offset(originCF,  6, y, 6.7), model, "LogFrontR_" .. r)
		end
	end

	-- Door
	AB.block(Vector3.new(5, 7, 0.4), DARK_WOOD, AB.offset(originCF, 0, 4.5, 6.9), model, "Door")
	AB.sphere(0.25, Color3.fromRGB(140, 100, 50), AB.offset(originCF, 1.7, 4.5, 7.15), model, "DoorKnob")

	-- Roof (steep wedges)
	AB.wedge(Vector3.new(20, 6, 8), ROOF, AB.offset(originCF, 0, 14.5,  4) * CFrame.Angles(0, math.rad(180), 0), model, "RoofF")
	AB.wedge(Vector3.new(20, 6, 8), ROOF, AB.offset(originCF, 0, 14.5, -4), model, "RoofB")
	AB.block(Vector3.new(20, 0.4, 1), LOG_DARK, AB.offset(originCF, 0, 17.6, 0), model, "Ridge")

	-- Stone chimney
	for layer = 1, 6 do
		local col = (layer % 2 == 0) and STONE or STONE_D
		AB.block(Vector3.new(3, 1.8, 3), col, AB.offset(originCF, -7, 13 + (layer - 1) * 1.8, -4), model, "Chimney_" .. layer)
	end
	AB.block(Vector3.new(3.6, 0.4, 3.6), DARK_WOOD, AB.offset(originCF, -7, 24.0, -4), model, "ChimCap")
	local puff = AB.sphere(1.2, EMBER, AB.offset(originCF, -7, 25, -4), model, "ChimEmber")
	AB.neon(puff)
	AB.glow(puff, EMBER, 2)
	puff.Transparency = 0.4

	-- Tiny porch
	AB.block(Vector3.new(10, 0.4, 3.5), DARK_WOOD, AB.offset(originCF, 0, 1, 8.9), model, "Porch")
	AB.block(Vector3.new(0.5, 4, 0.5), LOG_DARK, AB.offset(originCF, -4, 3.2, 10.4), model, "PostL")
	AB.block(Vector3.new(0.5, 4, 0.5), LOG_DARK, AB.offset(originCF,  4, 3.2, 10.4), model, "PostR")
	AB.block(Vector3.new(10, 0.4, 3.5), ROOF, AB.offset(originCF, 0, 5.3, 10.4), model, "PorchRoof")

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
