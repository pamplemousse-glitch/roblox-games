-- Garlic Braid String — long braid of garlic bulbs and red chili peppers
-- on a rope, classic Italian kitchen decor.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local GARLIC = Color3.fromRGB(235, 225, 200)
local PURPLE = Color3.fromRGB(180, 160, 180)
local ROPE   = Color3.fromRGB(190, 165, 110)
local CHILI  = Color3.fromRGB(210, 50, 50)
local STEM_G = Color3.fromRGB(80, 140, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GarlicBraidString", parent)

	-- Top hanging hook + rope loop
	AB.sphere(0.25, Color3.fromRGB(50, 50, 55), AB.offset(originCF, 0, 8, 0), model, "Hook")
	AB.cylinder(0.1, 1.5, ROPE,
		AB.offset(originCF, 0, 7.5, 0), model, "RopeTop")

	-- Garlic bulbs (12 stacked in a tapered braid)
	for i = 1, 12 do
		local y = 6.5 - (i - 1) * 0.55
		local s = 0.7 - (i - 1) * 0.025
		AB.sphere(s, GARLIC, AB.offset(originCF, 0, y, 0), model, "Bulb_" .. i)
		-- Purple stripe
		AB.sphere(s * 0.9, PURPLE, AB.offset(originCF, 0.05, y, 0.05), model, "BulbStripe_" .. i)
	end

	-- Chili peppers tucked into the braid
	for i = 1, 5 do
		local y = 5.5 - i * 0.8
		local angle = (i * 60) % 360
		AB.cylinder(0.15, 1.4, CHILI,
			AB.offset(originCF, math.cos(math.rad(angle)) * 0.6, y, math.sin(math.rad(angle)) * 0.6) * CFrame.Angles(math.rad(20), 0, 0),
			model, "Chili_" .. i)
		AB.sphere(0.15, STEM_G,
			AB.offset(originCF, math.cos(math.rad(angle)) * 0.6, y + 0.6, math.sin(math.rad(angle)) * 0.6),
			model, "ChiliStem_" .. i)
	end

	-- Rope wrap around bulbs
	for i = 1, 6 do
		local y = 6.2 - i * 0.9
		AB.cylinder(0.06, 1, ROPE,
			AB.offset(originCF, 0, y, 0) * CFrame.Angles(math.rad(45), 0, math.rad(90)), model, "Wrap_" .. i)
	end

	-- Bottom rope tail
	AB.cylinder(0.1, 1, ROPE, AB.offset(originCF, 0, -0.3, 0), model, "RopeBot")
	AB.sphere(0.2, ROPE, AB.offset(originCF, 0, -0.8, 0), model, "RopeKnot")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
