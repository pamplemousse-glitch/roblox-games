-- Chianti Bottle Stack — 9 wicker-wrapped Chianti bottles in a 3x3 pyramid.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BOTTLE  = Color3.fromRGB(40, 70, 45)
local WICKER  = Color3.fromRGB(190, 140, 80)
local DK_WK   = Color3.fromRGB(130, 90, 50)
local CORK    = Color3.fromRGB(195, 165, 120)
local LABEL   = Color3.fromRGB(245, 230, 200)
local WD      = Color3.fromRGB(110, 75, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ChiantiBottleStack", parent)

	-- Wooden crate base
	AB.block(Vector3.new(7, 0.5, 3), WD, AB.offset(originCF, 0, 0.25, 0), model, "CrateBase")

	-- Pyramid: 4 base + 3 middle + 2 top = 9 bottles
	local function bottle(x, y, z, name)
		-- Wicker base (basket bottom)
		AB.sphere(0.85, WICKER, AB.offset(originCF, x, y, z), model, name .. "_Wicker")
		-- Bottle body
		AB.cylinder(0.7, 2.2, BOTTLE,
			AB.offset(originCF, x, y + 1, z), model, name .. "_Body")
		-- Neck
		AB.cylinder(0.35, 0.8, BOTTLE, AB.offset(originCF, x, y + 2.4, z), model, name .. "_Neck")
		-- Cork
		AB.cylinder(0.3, 0.3, CORK, AB.offset(originCF, x, y + 3, z), model, name .. "_Cork")
		-- Label
		AB.block(Vector3.new(0.9, 0.6, 0.05), LABEL,
			AB.offset(originCF, x, y + 1.3, z + 0.65), model, name .. "_Label")
		-- Wicker weave (subtle dark band)
		AB.cylinder(0.92, 0.15, DK_WK,
			AB.offset(originCF, x, y - 0.15, z) * CFrame.Angles(0, 0, math.rad(90)), model, name .. "_WickerBand")
	end

	-- 4 base bottles
	for i = 1, 4 do bottle(-2.4 + (i - 1) * 1.6, 1, 0, "Btl1_" .. i) end
	-- 3 middle (offset up + back)
	for i = 1, 3 do bottle(-1.6 + (i - 1) * 1.6, 4.5, -1.2, "Btl2_" .. i) end
	-- 2 top
	for i = 1, 2 do bottle(-0.8 + (i - 1) * 1.6, 8, -2.4, "Btl3_" .. i) end

	-- "CHIANTI" plaque on crate
	AB.block(Vector3.new(3, 0.5, 0.1), Color3.fromRGB(110, 30, 40),
		AB.offset(originCF, 0, 0.6, 1.6), model, "Plaque")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
