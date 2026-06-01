-- Weathered Farmhouse — two-story plank house, peaked roof, simple porch.
-- Background filler — keeps geometry light.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PLANK   = Color3.fromRGB(190, 175, 145)
local TRIM    = Color3.fromRGB(110, 95, 75)
local ROOF    = Color3.fromRGB(60, 40, 28)
local DARK    = Color3.fromRGB(70, 45, 22)
local GLASS   = Color3.fromRGB(140, 175, 195)
local STRAW   = Color3.fromRGB(232, 200, 112)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WeatheredFarmhouse", parent)

	local foundation = AB.block(Vector3.new(22, 0.8, 18), DARK, AB.offset(originCF, 0, 0.4, 0), model, "Foundation")

	-- Two-story walls
	AB.block(Vector3.new(22, 22, 1), PLANK, AB.offset(originCF,  0, 11.8, -8.5), model, "BackWall")
	AB.block(Vector3.new(1, 22, 18), PLANK, AB.offset(originCF, -10.5, 11.8, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 22, 18), PLANK, AB.offset(originCF,  10.5, 11.8, 0), model, "RightWall")
	-- Front with door + window cuts
	AB.block(Vector3.new(7, 22, 1), PLANK, AB.offset(originCF, -7.5, 11.8, 8.5), model, "FrontL")
	AB.block(Vector3.new(7, 22, 1), PLANK, AB.offset(originCF,  7.5, 11.8, 8.5), model, "FrontR")
	AB.block(Vector3.new(8, 12, 1), PLANK, AB.offset(originCF, 0, 16.8, 8.5),    model, "FrontUpper")

	-- Door
	AB.block(Vector3.new(4, 8, 0.3), DARK, AB.offset(originCF, 0, 4.8, 8.6), model, "Door")

	-- Windows (2 ground floor + 2 upper)
	for i, p in {
		Vector3.new(-7.5, 14, 8.6), Vector3.new(7.5, 14, 8.6),
		Vector3.new(-10.5, 6, 0), Vector3.new(10.5, 6, 0),
	} do
		local w = AB.block(Vector3.new(2.4, 3, 0.2), GLASS, originCF * CFrame.new(p), model, "Window_" .. i)
		w.Transparency = 0.3
		AB.block(Vector3.new(0.2, 3, 0.3), TRIM, originCF * CFrame.new(p) * CFrame.new(0, 0, 0.1), model, "WindowCross_" .. i)
	end

	-- Peaked roof (two big wedges)
	AB.wedge(Vector3.new(24, 7, 10), ROOF, AB.offset(originCF, 0, 26.5,  5) * CFrame.Angles(0, math.rad(180), 0), model, "RoofF")
	AB.wedge(Vector3.new(24, 7, 10), ROOF, AB.offset(originCF, 0, 26.5, -5), model, "RoofB")
	AB.block(Vector3.new(24, 0.5, 1.2), DARK, AB.offset(originCF, 0, 30.3, 0), model, "Ridge")

	-- Small porch
	AB.block(Vector3.new(14, 0.5, 4), DARK, AB.offset(originCF, 0, 1.0, 10.5), model, "Porch")
	AB.block(Vector3.new(0.5, 5, 0.5), TRIM, AB.offset(originCF, -6, 3.8, 12), model, "PostL")
	AB.block(Vector3.new(0.5, 5, 0.5), TRIM, AB.offset(originCF,  6, 3.8, 12), model, "PostR")
	AB.block(Vector3.new(14, 0.4, 4.5), ROOF, AB.offset(originCF, 0, 6.6, 12), model, "PorchRoof")

	-- Small chimney
	AB.block(Vector3.new(2.4, 6, 2.4), TRIM, AB.offset(originCF, -7, 28, -3), model, "Chimney")

	-- Warm window glow (single light hint)
	local glow = AB.sphere(0.6, STRAW, AB.offset(originCF, 0, 15, 8.7), model, "InnerGlow")
	AB.neon(glow)
	AB.glow(glow, STRAW, 1.5)
	glow.Transparency = 0.6

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
