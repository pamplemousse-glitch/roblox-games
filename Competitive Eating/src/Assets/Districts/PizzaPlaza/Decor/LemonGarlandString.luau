-- Lemon Garland String — string of fresh lemons with leaves draped between
-- two points, like a Sicilian decoration.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STRING = Color3.fromRGB(80, 50, 30)
local LEMON  = Color3.fromRGB(240, 220, 80)
local LEAF   = Color3.fromRGB(80, 140, 60)
local DK_LEM = Color3.fromRGB(220, 200, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("LemonGarlandString", parent)

	-- Two anchor posts
	AB.cylinder(0.2, 3, STRING, AB.offset(originCF, -6, 1.5, 0), model, "AnchorL")
	AB.cylinder(0.2, 3, STRING, AB.offset(originCF,  6, 1.5, 0), model, "AnchorR")

	-- Catenary string
	for s = 1, 6 do
		local t = (s - 0.5) / 6
		local x = -6 + t * 12
		local y = 3 - math.sin(t * math.pi) * 0.7
		AB.cylinder(0.04, 2.2, STRING,
			AB.offset(originCF, x, y, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)),
			model, "StrSeg_" .. s)
	end

	-- 10 lemons hung along the string with leaves
	for i = 1, 10 do
		local t = (i - 0.5) / 10
		local x = -6 + t * 12
		local y = 3 - math.sin(t * math.pi) * 0.7 - 0.6
		AB.sphere(0.6, LEMON, AB.offset(originCF, x, y, 0), model, "Lemon_" .. i)
		-- Lemon dimple end
		AB.sphere(0.15, DK_LEM, AB.offset(originCF, x, y + 0.55, 0), model, "LemonStem_" .. i)
		-- Leaf
		AB.wedge(Vector3.new(0.1, 0.6, 0.4), LEAF,
			AB.offset(originCF, x + 0.5, y + 0.5, 0.1) * CFrame.Angles(math.rad(180), math.rad(45), 0),
			model, "Leaf_" .. i)
	end

	-- Larger decorative leaf clusters at the anchors
	for k, sx in {-1, 1} do
		AB.sphere(0.7, LEAF, AB.offset(originCF, sx * 6, 3.2, 0), model, "LeafCluster_" .. k)
		AB.sphere(0.5, LEAF, AB.offset(originCF, sx * 6 - sx * 0.3, 3.5, 0.2), model, "LeafCluster2_" .. k)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
