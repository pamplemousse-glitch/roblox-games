-- Wine Glass Display — 5 wine glasses on a small wooden tray, some empty,
-- some with red wine, one with white.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local GLASS = Color3.fromRGB(220, 240, 255)
local WINE  = Color3.fromRGB(110, 30, 40)
local WHITE = Color3.fromRGB(220, 215, 180)
local WD    = Color3.fromRGB(110, 75, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WineGlassDisplay", parent)

	-- Wood tray
	AB.block(Vector3.new(6, 0.3, 2.4), WD, AB.offset(originCF, 0, 0.15, 0), model, "Tray")
	AB.block(Vector3.new(6.1, 0.2, 2.5), Color3.fromRGB(80, 50, 30),
		AB.offset(originCF, 0, 0.4, 0), model, "TrayRim")

	-- 5 wine glasses in a row
	for i = 1, 5 do
		local x = -2.4 + (i - 1) * 1.2
		-- Base
		AB.cylinder(0.7, 0.1, GLASS,
			AB.offset(originCF, x, 0.4, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Base_" .. i)
		-- Stem
		AB.cylinder(0.1, 1.5, GLASS, AB.offset(originCF, x, 1.15, 0), model, "Stem_" .. i)
		-- Bowl (sphere flattened)
		AB.sphere(1, GLASS, AB.offset(originCF, x, 2.2, 0), model, "Bowl_" .. i)
		-- Contents: 1st = red, 2nd = empty, 3rd = white, 4th = red, 5th = empty
		if i == 1 or i == 4 then
			AB.sphere(0.85, WINE, AB.offset(originCF, x, 2, 0), model, "Wine_" .. i)
		elseif i == 3 then
			AB.sphere(0.85, WHITE, AB.offset(originCF, x, 2, 0), model, "Wine_" .. i)
		end
	end

	-- Wine bottle in the back-center (green)
	AB.cylinder(0.6, 2.5, Color3.fromRGB(40, 70, 45), AB.offset(originCF, 0, 1.7, -1), model, "Bottle")
	AB.cylinder(0.3, 0.7, Color3.fromRGB(40, 70, 45), AB.offset(originCF, 0, 3.2, -1), model, "BottleNeck")
	AB.sphere(0.25, Color3.fromRGB(195, 165, 120), AB.offset(originCF, 0, 3.65, -1), model, "Cork")
	AB.block(Vector3.new(1, 0.8, 0.05), Color3.fromRGB(245, 230, 200),
		AB.offset(originCF, 0, 1.7, -0.45), model, "BottleLabel")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
