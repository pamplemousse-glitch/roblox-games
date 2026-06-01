-- Pulled Pork — a mound of stringy meat piled high on a bun.
-- Bottom bun + chaotic pile of brown meat strands + sauce drizzle + top bun.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BUN     = Color3.fromRGB(220, 170, 110)
local PORK    = Color3.fromRGB(140, 70, 40)
local PORK_HL = Color3.fromRGB(180, 100, 60)
local SAUCE   = Color3.fromRGB(110, 25, 20)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PulledPork", parent)

	-- Bottom bun (standing cylinder = flat disc when height < diameter)
	local bottomBun = AB.cylinder(
		4.4, 0.7, BUN,
		AB.offset(originCF, 0, 0.45, 0),
		model, "BottomBun"
	)

	-- Pulled pork mound: 7 small bricks rotated chaotically.
	local strands = {
		{Vector3.new(2.6, 0.5, 0.6), Vector3.new(-0.6, 1.1,  0.4),  20},
		{Vector3.new(2.4, 0.5, 0.5), Vector3.new( 0.5, 1.2, -0.5), -35},
		{Vector3.new(2.8, 0.5, 0.7), Vector3.new( 0.1, 1.5,  0.0),  10},
		{Vector3.new(2.2, 0.4, 0.5), Vector3.new(-0.7, 1.7, -0.3),  55},
		{Vector3.new(2.5, 0.4, 0.6), Vector3.new( 0.6, 1.8,  0.4), -15},
		{Vector3.new(2.0, 0.4, 0.5), Vector3.new(-0.2, 2.0,  0.5),  70},
		{Vector3.new(1.8, 0.4, 0.5), Vector3.new( 0.3, 2.1, -0.4),  30},
	}
	for i, s in strands do
		local color = (i % 2 == 0) and PORK_HL or PORK
		AB.part({
			size  = s[1],
			color = color,
			cf    = originCF * CFrame.new(s[2]) * CFrame.Angles(0, math.rad(s[3]), 0),
			name  = "Strand_" .. i,
		}, model)
	end

	-- Sauce drizzle (a few dark red blobs on top of the mound)
	local blobs = {Vector3.new(-0.4, 2.3, 0), Vector3.new(0.5, 2.25, 0.3), Vector3.new(0, 2.35, -0.4)}
	for i, p in blobs do
		AB.sphere(0.55, SAUCE, originCF * CFrame.new(p), model, "Sauce_" .. i)
	end

	-- Top bun (slightly smaller disc)
	AB.cylinder(
		4.2, 0.7, BUN,
		AB.offset(originCF, 0, 2.7, 0),
		model, "TopBun"
	)

	AB.pivot(model, bottomBun)
	AB.weldAll(model)
	return model
end
