-- Cherry Blossom Strings — a swag of cherry-blossom branches strung between
-- two short poles, with pink blossom clusters dripping down.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local BRANCH      = Color3.fromRGB(110, 70, 50)
local BLOSSOM_P   = Color3.fromRGB(255, 200, 220)
local BLOSSOM_D   = Color3.fromRGB(240, 160, 190)
local LEAF_GREEN  = Color3.fromRGB(150, 200, 130)
local STONE       = Color3.fromRGB(120, 115, 105)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CherryBlossomStrings", parent)

	-- Two stone-base posts
	for i, x in {-8, 8} do
		AB.block(Vector3.new(1.2, 0.5, 1.2), STONE,
			AB.offset(originCF, x, 0.25, 0), model, "PostBase_" .. i)
		AB.cylinder(0.5, 7, DARK_WOOD,
			AB.offset(originCF, x, 4, 0), model, "Post_" .. i)
	end

	-- Curved branch crossing both posts (3 angled segments to suggest a sag)
	for j, segment in {
		{cf = AB.offset(originCF, -6, 7, 0) * CFrame.Angles(0, 0, math.rad(15)), size = Vector3.new(5, 0.25, 0.25)},
		{cf = AB.offset(originCF,  0, 6.4, 0), size = Vector3.new(5, 0.25, 0.25)},
		{cf = AB.offset(originCF,  6, 7, 0) * CFrame.Angles(0, 0, math.rad(-15)), size = Vector3.new(5, 0.25, 0.25)},
	} do
		AB.part({
			size  = segment.size,
			color = BRANCH,
			cf    = segment.cf,
			name  = "BranchSeg_" .. j,
		}, model)
	end

	-- Blossom clusters dripping down at intervals
	for i = 1, 8 do
		local x = (i - 4.5) * 2.0
		-- main blossom ball
		local pink = AB.sphere(0.9 + (i % 3) * 0.2, BLOSSOM_P,
			AB.offset(originCF, x, 6 - (i % 2) * 0.5, 0), model, "BlossomP_" .. i)
		pink.Material = Enum.Material.SmoothPlastic
		-- Darker pink inner cluster
		AB.sphere(0.5, BLOSSOM_D,
			AB.offset(originCF, x + 0.2, 5.8 - (i % 2) * 0.5, 0.2), model, "BlossomD_" .. i)
		-- A small green leaf
		AB.block(Vector3.new(0.5, 0.1, 0.3), LEAF_GREEN,
			AB.offset(originCF, x - 0.3, 5.4 - (i % 2) * 0.5, 0.1) * CFrame.Angles(0, 0, math.rad(40)),
			model, "Leaf_" .. i)
	end

	-- A few fallen petals scattered at the base
	for i = 1, 6 do
		local x = (i - 3.5) * 2.6 + (i % 2 == 0 and 0.5 or -0.5)
		AB.block(Vector3.new(0.3, 0.05, 0.4), BLOSSOM_P,
			AB.offset(originCF, x, 0.55, (i % 2 == 0) and 0.8 or -0.8),
			model, "FallenPetal_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
