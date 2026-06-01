-- Vine Planter — tall terracotta pot with grapevine spilling out and
-- climbing up a small trellis.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local POT       = Color3.fromRGB(180, 100, 70)
local POT_DK    = Color3.fromRGB(140, 75, 50)
local SOIL      = Color3.fromRGB(70, 45, 25)
local VINE      = Color3.fromRGB(100, 70, 40)
local LEAF      = Color3.fromRGB(80, 140, 60)
local GRAPE     = Color3.fromRGB(85, 40, 100)
local TRELLIS_W = Color3.fromRGB(110, 75, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("VinePlanter", parent)

	-- Pot (taper using 2 cylinders)
	AB.cylinder(2.6, 3, POT, AB.offset(originCF, 0, 1.5, 0), model, "PotBot")
	AB.cylinder(3.2, 0.4, POT_DK, AB.offset(originCF, 0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "PotLip")
	-- Soil top
	AB.cylinder(2.6, 0.2, SOIL, AB.offset(originCF, 0, 3.1, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Soil")

	-- Trellis (latticework above pot)
	for i, x in {-1.5, 0, 1.5} do
		AB.block(Vector3.new(0.2, 7, 0.2), TRELLIS_W, AB.offset(originCF, x, 7, 0), model, "TrellisV_" .. i)
	end
	for i, y in {4, 6, 8, 10} do
		AB.block(Vector3.new(3.5, 0.2, 0.2), TRELLIS_W, AB.offset(originCF, 0, y, 0), model, "TrellisH_" .. i)
	end

	-- Vine winding up trellis (cylinder segments)
	for s = 0, 8 do
		local y = 3.5 + s * 0.9
		local x = math.cos(s * 0.8) * 1.5
		AB.cylinder(0.2, 1.1, VINE, AB.offset(originCF, x, y, 0), model, "VineSeg_" .. s)
	end

	-- Leaves (many small green spheres)
	for i = 1, 22 do
		local y = 3.5 + math.random() * 7
		local x = (math.random() - 0.5) * 3.5
		local z = (math.random() - 0.5) * 0.6
		AB.sphere(0.5 + math.random() * 0.2, LEAF, AB.offset(originCF, x, y, z), model, "Leaf_" .. i)
	end

	-- Grape clusters (3 clusters of small purple spheres)
	for c = 1, 3 do
		local cx = (math.random() - 0.5) * 2.5
		local cy = 5 + math.random() * 3
		for i = 1, 6 do
			AB.sphere(0.28, GRAPE,
				AB.offset(originCF, cx + (math.random() - 0.5) * 0.6, cy + (math.random() - 0.5) * 0.6, 0.4), model, "Grape_" .. c .. "_" .. i)
		end
	end

	-- Vine tendrils (thin curling cylinders)
	for t = 1, 4 do
		AB.cylinder(0.08, 1.4, VINE,
			AB.offset(originCF, (math.random() - 0.5) * 3, 5 + math.random() * 4, 0.5) * CFrame.Angles(math.rad(30), 0, math.rad(50)),
			model, "Tendril_" .. t)
	end

	-- Spillover vines down the front of the pot
	AB.cylinder(0.15, 2.5, VINE,
		AB.offset(originCF, -1, 1.5, 1.3) * CFrame.Angles(math.rad(-20), 0, 0), model, "Spillover1")
	AB.sphere(0.4, LEAF, AB.offset(originCF, -1, 0.3, 1.5), model, "SpilloverLeaf1")
	AB.sphere(0.4, LEAF, AB.offset(originCF, -0.7, 0.6, 1.5), model, "SpilloverLeaf2")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
