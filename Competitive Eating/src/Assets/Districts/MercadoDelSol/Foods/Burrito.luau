-- Burrito — rolled cylinder with multi-color filling visible at each end.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TORTILLA   = Color3.fromRGB(232, 210, 160)
local RICE       = Color3.fromRGB(245, 235, 200)
local BEAN       = Color3.fromRGB(95, 55, 35)
local MEAT       = Color3.fromRGB(150, 75, 45)
local SALSA      = Color3.fromRGB(195, 60, 50)
local LETTUCE    = Color3.fromRGB(115, 195, 90)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Burrito", parent)

	-- Main tortilla wrap (horizontal cylinder lying along Z)
	local wrap = AB.part({
		size  = Vector3.new(6.5, 2.4, 2.4),
		color = TORTILLA,
		cf    = AB.offset(originCF, 0, 1.4, 0) * CFrame.Angles(0, math.rad(90), 0),
		shape = Enum.PartType.Cylinder,
		name  = "Wrap",
	}, model)

	-- Slight overlap fold ridge along the top
	AB.part({
		size  = Vector3.new(6.4, 0.3, 0.6),
		color = Color3.fromRGB(215, 190, 140),
		cf    = AB.offset(originCF, 0, 2.55, 0.4),
		name  = "FoldRidge",
	}, model)

	-- End caps — multi-color filling slices (front cap = +Z end)
	local fillingColors = {RICE, BEAN, MEAT, SALSA, LETTUCE}
	for endIdx, zMul in {1, -1} do
		local z = zMul * 3.3
		for i, color in fillingColors do
			local angle = ((i - 1) / #fillingColors) * 2 * math.pi
			local r     = 0.7
			AB.part({
				size  = Vector3.new(0.4, 0.7, 0.7),
				color = color,
				cf    = AB.offset(originCF, r * math.cos(angle), 1.4 + r * math.sin(angle), z),
				name  = string.format("Filling_%d_%d", endIdx, i),
			}, model)
		end
		-- Center fill (rice)
		AB.part({
			size  = Vector3.new(0.3, 0.7, 0.7),
			color = RICE,
			cf    = AB.offset(originCF, 0, 1.4, z),
			name  = "FillCenter_" .. endIdx,
		}, model)
	end

	-- Char marks (small darker spots scattered on top)
	for i, offset in {
		Vector3.new(0,    0,  1.5),
		Vector3.new(-0.6, 0, -0.8),
		Vector3.new( 0.5, 0,  0.2),
		Vector3.new(-0.2, 0, -2.0),
	} do
		AB.part({
			size  = Vector3.new(0.5, 0.05, 0.4),
			color = Color3.fromRGB(150, 110, 70),
			cf    = AB.offset(originCF, offset.X, 2.6, offset.Z),
			name  = "Char_" .. i,
		}, model)
	end

	AB.pivot(model, wrap)
	AB.weldAll(model)
	return model
end
