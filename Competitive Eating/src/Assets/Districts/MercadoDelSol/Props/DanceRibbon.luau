-- Dance Ribbon — vertical pole with a colorful ribbon spiraling around it,
-- topped by a golden sun finial and a few hanging tassels.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local TERRACOTTA  = Color3.fromRGB(196, 95, 44)
local BOUG_PINK   = Color3.fromRGB(220, 80, 140)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local AGAVE_TEAL  = Color3.fromRGB(43, 140, 156)
local TASSEL_RED  = Color3.fromRGB(180, 50, 60)

local RIBBON_COLORS = {BOUG_PINK, FIESTA_YEL, AGAVE_TEAL}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DanceRibbon", parent)

	-- Decorative base
	local base = AB.cylinder(3, 0.6, TERRACOTTA,
		AB.offset(originCF, 0, 0.3, 0), model, "Base")

	-- Vertical pole
	AB.cylinder(0.4, 8, WOOD_DARK,
		AB.offset(originCF, 0, 4.6, 0), model, "Pole")

	-- Spiral ribbon — 14 thin blocks coiling around the pole
	local segs = 14
	for i = 1, segs do
		local t = (i - 1) / (segs - 1)
		local y = 1 + t * 7
		local angle = i * 55                              -- yaw spin
		local color = RIBBON_COLORS[((i - 1) % #RIBBON_COLORS) + 1]
		local x = math.cos(math.rad(angle)) * 0.5
		local z = math.sin(math.rad(angle)) * 0.5
		AB.block(Vector3.new(1.2, 0.25, 0.3),
			color,
			AB.offset(originCF, x, y, z) * CFrame.Angles(0, math.rad(-angle), math.rad(20)),
			model, "Ribbon_" .. i)
	end

	-- Top finial: golden sun
	local sun = AB.sphere(1, FIESTA_YEL,
		AB.offset(originCF, 0, 9, 0), model, "SunCore")
	AB.neon(sun)
	AB.glow(sun, FIESTA_YEL, 2)
	-- Sun rays (8 small radiating blocks)
	for i = 1, 8 do
		local a = (i - 1) * (math.pi / 4)
		AB.block(Vector3.new(0.25, 0.25, 0.9), FIESTA_YEL,
			AB.offset(originCF, math.cos(a) * 0.9, 9, math.sin(a) * 0.9)
				* CFrame.Angles(0, -a, 0),
			model, "Ray_" .. i)
	end

	-- 3 hanging tassels at the top
	for i = 1, 3 do
		local a = (i - 1) * (2 * math.pi / 3)
		local x = math.cos(a) * 0.6
		local z = math.sin(a) * 0.6
		AB.cylinder(0.18, 1, TASSEL_RED,
			AB.offset(originCF, x, 8.1, z), model, "Tassel_" .. i)
	end

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
