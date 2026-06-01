-- String Light — a swag of warm bulbs strung between two posts, with the
-- cord sagging in the middle. Eight glowing neon bulbs.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local POST    = Color3.fromRGB(70, 45, 22)
local CORD    = Color3.fromRGB(28, 24, 20)
local BULB    = Color3.fromRGB(255, 220, 140)
local BULB_S  = Color3.fromRGB(255, 180, 100)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("StringLight", parent)

	-- Two posts at the ends
	local postL = AB.block(Vector3.new(0.5, 12, 0.5), POST, AB.offset(originCF, -14, 6, 0), model, "PostL")
	AB.block(Vector3.new(0.5, 12, 0.5), POST, AB.offset(originCF,  14, 6, 0), model, "PostR")
	-- Post caps
	AB.sphere(0.7, POST, AB.offset(originCF, -14, 12.2, 0), model, "CapL")
	AB.sphere(0.7, POST, AB.offset(originCF,  14, 12.2, 0), model, "CapR")

	-- Cord (8 short segments forming a shallow catenary sag)
	local span = 28
	local sag = 1.6
	for i = 1, 8 do
		local t1 = (i - 1) / 8
		local t2 = i / 8
		local x1 = -14 + t1 * span
		local x2 = -14 + t2 * span
		local y1 = 11.5 - sag * (1 - (2 * t1 - 1)^2)
		local y2 = 11.5 - sag * (1 - (2 * t2 - 1)^2)
		local mx = (x1 + x2) / 2
		local my = (y1 + y2) / 2
		local dx = x2 - x1
		local dy = y2 - y1
		local len = math.sqrt(dx * dx + dy * dy)
		local angle = math.atan2(dy, dx)
		local seg = AB.block(Vector3.new(len, 0.12, 0.12), CORD, AB.offset(originCF, mx, my, 0), model, "Cord_" .. i)
		seg.CFrame = seg.CFrame * CFrame.Angles(0, 0, angle)
	end

	-- Bulbs hanging slightly below cord at each segment join
	for i = 0, 8 do
		local t = i / 8
		local x = -14 + t * span
		local y = 11.5 - sag * (1 - (2 * t - 1)^2) - 0.5
		local bulb = AB.sphere(0.55, (i % 2 == 0) and BULB or BULB_S,
			AB.offset(originCF, x, y, 0), model, "Bulb_" .. i)
		AB.neon(bulb)
		local light = AB.glow(bulb, BULB, 1.2)
		light.Range = 8
		-- Tiny stem connecting bulb to cord
		AB.block(Vector3.new(0.1, 0.4, 0.1), CORD, AB.offset(originCF, x, y + 0.45, 0), model, "Stem_" .. i)
	end

	AB.pivot(model, postL)
	AB.weldAll(model)
	return model
end
