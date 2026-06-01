-- Cherry Tomato Plant — potted cherry tomato vine with little red tomatoes,
-- supported by a wooden stake.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local POT     = Color3.fromRGB(180, 100, 70)
local DK_POT  = Color3.fromRGB(140, 75, 50)
local SOIL    = Color3.fromRGB(70, 45, 25)
local STEM    = Color3.fromRGB(80, 140, 60)
local LEAF    = Color3.fromRGB(110, 160, 80)
local CHERRY  = Color3.fromRGB(220, 60, 50)
local DK_TM   = Color3.fromRGB(180, 40, 35)
local STAKE   = Color3.fromRGB(110, 75, 45)
local TWINE   = Color3.fromRGB(190, 165, 110)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CherryTomatoPlant", parent)

	-- Terracotta pot
	AB.cylinder(2.5, 3, POT, AB.offset(originCF, 0, 1.5, 0), model, "Pot")
	AB.cylinder(2.8, 0.3, DK_POT, AB.offset(originCF, 0, 3, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "PotLip")
	-- Soil
	AB.cylinder(2.4, 0.2, SOIL, AB.offset(originCF, 0, 3.05, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Soil")

	-- Wooden stake going up the center
	AB.block(Vector3.new(0.2, 8, 0.2), STAKE, AB.offset(originCF, 0, 7, 0), model, "Stake")

	-- Twisting main stem (segments)
	for s = 0, 7 do
		local y = 3.5 + s
		local angle = s * 0.5
		AB.cylinder(0.15, 1.1, STEM,
			AB.offset(originCF, math.cos(angle) * 0.3, y, math.sin(angle) * 0.3), model, "Stem_" .. s)
	end

	-- Twine ties (3 attaching stem to stake)
	for i, y in {5, 7, 9} do
		AB.cylinder(0.06, 0.6, TWINE,
			AB.offset(originCF, 0, y, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Tie_" .. i)
	end

	-- Big basil-like leaves (lots of them)
	for i = 1, 20 do
		local y = 4 + math.random() * 7
		local angle = math.random() * 2 * math.pi
		local x = math.cos(angle) * (0.6 + math.random() * 0.6)
		local z = math.sin(angle) * (0.6 + math.random() * 0.6)
		AB.sphere(0.4 + math.random() * 0.2, LEAF, AB.offset(originCF, x, y, z), model, "Leaf_" .. i)
	end

	-- 5 clusters of cherry tomatoes
	for c = 1, 5 do
		local cy = 5 + c * 1.2
		local angle = c * 1.3
		local cx = math.cos(angle) * 1.1
		local cz = math.sin(angle) * 1.1
		-- Tiny stem to cluster
		AB.cylinder(0.08, 0.4, STEM, AB.offset(originCF, cx, cy + 0.1, cz), model, "ClStem_" .. c)
		-- Cluster of 5 cherries
		for i = 1, 5 do
			local ang2 = i / 5 * 2 * math.pi
			AB.sphere(0.28, CHERRY,
				AB.offset(originCF, cx + math.cos(ang2) * 0.3, cy - 0.2 + math.sin(i) * 0.2, cz + math.sin(ang2) * 0.3),
				model, "Cherry_" .. c .. "_" .. i)
			-- Cherry stem (tiny green dot)
			AB.sphere(0.06, STEM,
				AB.offset(originCF, cx + math.cos(ang2) * 0.3, cy - 0.05, cz + math.sin(ang2) * 0.3),
				model, "ChStem_" .. c .. "_" .. i)
		end
	end

	-- A few small yellow flowers (tomato blossoms)
	for i = 1, 4 do
		AB.sphere(0.18, Color3.fromRGB(240, 220, 80),
			AB.offset(originCF, math.cos(i) * 1, 6 + i * 0.5, math.sin(i) * 1), model, "Blossom_" .. i)
	end

	-- Plant marker
	AB.block(Vector3.new(1, 0.4, 0.05), Color3.fromRGB(245, 240, 230),
		AB.offset(originCF, -1.6, 3.6, 0), model, "Marker")
	AB.block(Vector3.new(0.08, 0.8, 0.08), STAKE,
		AB.offset(originCF, -1.6, 3.2, 0), model, "MarkerStake")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
