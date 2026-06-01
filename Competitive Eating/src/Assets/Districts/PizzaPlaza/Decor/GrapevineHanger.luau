-- Grapevine Hanger — overhead grapevine garland with clusters of grapes
-- hanging over a walkway.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VINE   = Color3.fromRGB(100, 70, 40)
local LEAF   = Color3.fromRGB(80, 140, 60)
local GRAPE  = Color3.fromRGB(85, 40, 100)
local GRAPE2 = Color3.fromRGB(130, 80, 140)
local POST   = Color3.fromRGB(80, 50, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GrapevineHanger", parent)

	-- Two support posts
	AB.cylinder(0.3, 7, POST, AB.offset(originCF, -6, 3.5, 0), model, "PostL")
	AB.cylinder(0.3, 7, POST, AB.offset(originCF,  6, 3.5, 0), model, "PostR")
	-- Crossbeam at top
	AB.block(Vector3.new(13, 0.4, 0.4), POST, AB.offset(originCF, 0, 7, 0), model, "Crossbeam")

	-- Wavy vine across the crossbeam
	for s = 1, 10 do
		local t = (s - 0.5) / 10
		local x = -6 + t * 12
		local y = 6.5 + math.sin(t * math.pi * 2) * 0.3
		AB.cylinder(0.2, 1.4, VINE, AB.offset(originCF, x, y, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)), model, "VineSeg_" .. s)
	end

	-- Leaves clustered along vine
	for i = 1, 22 do
		local t = (i - 0.5) / 22
		local x = -6 + t * 12
		AB.sphere(0.5 + math.random() * 0.2, LEAF,
			AB.offset(originCF, x + (math.random() - 0.5) * 0.6, 6.5 + (math.random() - 0.5) * 0.6, (math.random() - 0.5) * 0.6),
			model, "Leaf_" .. i)
	end

	-- 4 grape clusters hanging down
	for c = 1, 4 do
		local x = -4.5 + (c - 1) * 3
		local clusterTop = 5.8
		-- Stem from vine to cluster
		AB.cylinder(0.1, 0.6, VINE, AB.offset(originCF, x, clusterTop + 0.3, 0), model, "ClusterStem_" .. c)
		-- Cluster of grapes (15 small spheres in a teardrop arrangement)
		for i = 1, 15 do
			local angle = i / 15 * 2 * math.pi
			local row = math.floor((i - 1) / 5)
			local rx = math.cos(angle * 2) * 0.4
			local rz = math.sin(angle * 2) * 0.4
			local ry = clusterTop - row * 0.4
			AB.sphere(0.28, c % 2 == 0 and GRAPE or GRAPE2, AB.offset(originCF, x + rx, ry, rz), model, "Grape_" .. c .. "_" .. i)
		end
	end

	-- Tendril curls
	for t = 1, 5 do
		local x = -5 + t * 2
		AB.cylinder(0.06, 0.8, VINE,
			AB.offset(originCF, x, 6, 0.4) * CFrame.Angles(math.rad(45), 0, math.rad(45)),
			model, "Tendril_" .. t)
	end

	-- Post caps
	AB.sphere(0.5, Color3.fromRGB(220, 180, 60), AB.offset(originCF, -6, 7.3, 0), model, "PostCapL")
	AB.sphere(0.5, Color3.fromRGB(220, 180, 60), AB.offset(originCF,  6, 7.3, 0), model, "PostCapR")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
