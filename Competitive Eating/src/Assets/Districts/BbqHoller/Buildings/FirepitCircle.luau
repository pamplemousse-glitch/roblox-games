-- Firepit Circle — ring of mossy stones around a stack of glowing neon logs.
-- A dirt circle, 12 stones around the rim, crossed logs, and an ember glow.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DIRT     = Color3.fromRGB(90, 65, 45)
local STONE    = Color3.fromRGB(135, 130, 120)
local STONE_DK = Color3.fromRGB(95, 90, 80)
local LOG      = Color3.fromRGB(107, 68, 35)
local EMBER    = Color3.fromRGB(255, 128, 48)
local ASH      = Color3.fromRGB(60, 50, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("FirepitCircle", parent)

	-- Dirt patch — wide flat disc
	local dirt = AB.cylinder(
		18, 0.4, DIRT,
		AB.offset(originCF, 0, 0.2, 0),
		model, "DirtPatch"
	)

	-- Ash inside the pit
	AB.cylinder(
		8, 0.2, ASH,
		AB.offset(originCF, 0, 0.45, 0),
		model, "AshLayer"
	)

	-- 12 stones around the rim — alternating sizes & dark/light
	for i = 1, 12 do
		local angle = (i / 12) * math.pi * 2
		local r = 5.2
		local x = math.cos(angle) * r
		local z = math.sin(angle) * r
		local color = (i % 2 == 0) and STONE or STONE_DK
		local s = 1.5 + (i % 3) * 0.25
		AB.part({
			size  = Vector3.new(s, s * 0.85, s),
			color = color,
			cf    = originCF * CFrame.new(x, s * 0.4, z) * CFrame.Angles(math.rad(i * 7), math.rad(i * 13), 0),
			shape = Enum.PartType.Ball,
			name  = "Stone_" .. i,
		}, model)
	end

	-- Crossed logs (3 logs in a teepee/lean stack)
	local logSpecs = {
		{Vector3.new(0,   1.4,  0),  20,  0},
		{Vector3.new(0.4, 1.4,  0),  -25, 90},
		{Vector3.new(-0.2, 1.4, 0.2), 15, 45},
	}
	for i, spec in logSpecs do
		AB.part({
			size  = Vector3.new(4.5, 0.7, 0.7),
			color = LOG,
			cf    = originCF * CFrame.new(spec[1]) * CFrame.Angles(0, math.rad(spec[3]), math.rad(spec[2])),
			shape = Enum.PartType.Cylinder,
			name  = "Log_" .. i,
		}, model)
	end

	-- Glowing embers — neon orange spheres rising slightly above the logs
	for i, p in {
		Vector3.new(0,    1.8,  0),
		Vector3.new(0.5,  2.4,  0.3),
		Vector3.new(-0.4, 2.8,  -0.2),
		Vector3.new(0.2,  3.4,  0.4),
	} do
		local ember = AB.sphere(
			1.2 - (i - 1) * 0.18, EMBER,
			originCF * CFrame.new(p), model, "Ember_" .. i
		)
		AB.neon(ember)
		ember.Transparency = (i - 1) * 0.12
	end

	-- Big single light so the firepit casts ambience
	local light = Instance.new("PointLight")
	light.Color      = EMBER
	light.Brightness = 4
	light.Range      = 28
	light.Parent     = dirt

	AB.pivot(model, dirt)
	AB.weldAll(model)
	return model
end
