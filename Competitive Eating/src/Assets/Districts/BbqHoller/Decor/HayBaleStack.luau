-- Hay Bale Stack — 4 rectangular hay bales stacked pyramid-style.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local HAY      = Color3.fromRGB(232, 200, 112)
local HAY_DARK = Color3.fromRGB(190, 155, 75)
local TWINE    = Color3.fromRGB(120, 100, 70)

local function bale(parent, cf, name)
	-- A bale = a hay-colored block with darker striations and twine bands
	local b = AB.block(Vector3.new(4, 2.5, 2.5), HAY, cf, parent, name)
	-- Striations (4 thin dark strips on top + sides)
	for i, dy in {-0.6, 0, 0.6} do
		AB.block(Vector3.new(4.05, 0.2, 2.55), HAY_DARK, cf * CFrame.new(0, dy, 0), parent, name .. "_Str_" .. i)
	end
	-- Twine bands
	AB.block(Vector3.new(4.1, 0.1, 0.1), TWINE, cf * CFrame.new(0, 0.5, 1.0), parent, name .. "_TwineFT")
	AB.block(Vector3.new(4.1, 0.1, 0.1), TWINE, cf * CFrame.new(0, 0.5, -1.0), parent, name .. "_TwineBT")
	AB.block(Vector3.new(4.1, 0.1, 0.1), TWINE, cf * CFrame.new(0, -0.5, 1.0), parent, name .. "_TwineFB")
	AB.block(Vector3.new(4.1, 0.1, 0.1), TWINE, cf * CFrame.new(0, -0.5, -1.0), parent, name .. "_TwineBB")
	return b
end

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("HayBaleStack", parent)

	-- Bottom row: 2 bales side by side
	bale(model, AB.offset(originCF, -2.1, 1.25, 0), "Bale1")
	bale(model, AB.offset(originCF,  2.1, 1.25, 0), "Bale2")
	-- Middle row: 1 bale on top, centered
	bale(model, AB.offset(originCF, 0, 3.75, 0), "Bale3")
	-- Top bale offset to one side (rakish)
	local top = bale(model, AB.offset(originCF, 0.5, 6.25, 0.4), "Bale4")
	top.CFrame = top.CFrame * CFrame.Angles(0, math.rad(15), math.rad(4))

	-- Loose hay around base
	for i, p in {Vector3.new(-3, 0.1, 1.5), Vector3.new(3.2, 0.1, -1), Vector3.new(0, 0.1, -2)} do
		AB.block(Vector3.new(0.8, 0.2, 0.6), HAY, originCF * CFrame.new(p) * CFrame.Angles(0, math.rad(i * 27), 0), model, "Loose_" .. i)
	end

	AB.pivot(model, model:FindFirstChild("Bale1"))
	AB.weldAll(model)
	return model
end
