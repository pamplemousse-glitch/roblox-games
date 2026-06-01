-- Sakura Petal Scatter — flat ground patch covered with scattered pink
-- cherry petals + a few small twigs. Use as transient/decorative ground cover.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local GROUND_PINK = Color3.fromRGB(230, 200, 215)
local PETAL_P     = Color3.fromRGB(255, 200, 220)
local PETAL_D     = Color3.fromRGB(240, 160, 190)
local PETAL_W     = Color3.fromRGB(250, 240, 245)
local TWIG_BROWN  = Color3.fromRGB(110, 70, 50)
local LEAF_GREEN  = Color3.fromRGB(150, 200, 130)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SakuraPetalScatter", parent)

	-- Soft pink ground tint patch
	AB.cylinder(10, 0.15, GROUND_PINK,
		AB.offset(originCF, 0, 0.08, 0), model, "PinkGround")

	-- 32 scattered petals at varied positions / rotations / sizes
	local rng = Random.new(1234)
	for i = 1, 32 do
		local angle = rng:NextNumber(0, math.pi * 2)
		local radius = rng:NextNumber(0.5, 4.5)
		local x = math.cos(angle) * radius
		local z = math.sin(angle) * radius
		local yaw = rng:NextNumber(0, math.pi * 2)
		local size = rng:NextNumber(0.3, 0.55)
		local color = ({PETAL_P, PETAL_D, PETAL_W})[((i % 3) + 1)]
		AB.block(Vector3.new(size, 0.04, size * 0.7), color,
			AB.offset(originCF, x, 0.18, z) * CFrame.Angles(0, yaw, 0),
			model, "Petal_" .. i)
	end

	-- 4 small twigs (thin brown cylinders, lying flat)
	for i = 1, 4 do
		local angle = (i - 1) * (math.pi / 2) + 0.4
		local x = math.cos(angle) * 2.5
		local z = math.sin(angle) * 2.5
		AB.cylinder(0.1, 1.4, TWIG_BROWN,
			AB.offset(originCF, x, 0.19, z) * CFrame.Angles(0, angle, 0),
			model, "Twig_" .. i)
		-- A small green leaf on one twig
		if i == 1 or i == 3 then
			AB.block(Vector3.new(0.4, 0.04, 0.25), LEAF_GREEN,
				AB.offset(originCF, x + 0.3, 0.23, z + 0.2) * CFrame.Angles(0, angle, 0),
				model, "TwigLeaf_" .. i)
		end
	end

	-- A handful of "drift" larger petals slightly elevated (suggests falling)
	for i = 1, 5 do
		local angle = (i - 1) * (math.pi * 2 / 5)
		local x = math.cos(angle) * 5.5
		local z = math.sin(angle) * 5.5
		AB.block(Vector3.new(0.55, 0.05, 0.4), PETAL_P,
			AB.offset(originCF, x, 0.6 + i * 0.2, z) * CFrame.Angles(0, angle, math.rad(30)),
			model, "DriftPetal_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
