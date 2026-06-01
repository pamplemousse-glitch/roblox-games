-- Sidewalk Chalk Art — colorful chalk drawings on the sidewalk (hopscotch
-- grid, pizza heart, flower) — flat decals on the ground.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CHALK_W  = Color3.fromRGB(245, 240, 230)
local CHALK_Y  = Color3.fromRGB(240, 220, 100)
local CHALK_R  = Color3.fromRGB(220, 80, 80)
local CHALK_G  = Color3.fromRGB(120, 200, 130)
local CHALK_B  = Color3.fromRGB(100, 180, 220)
local CHALK_P  = Color3.fromRGB(200, 130, 230)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SidewalkChalkArt", parent)

	-- Hopscotch grid (7 squares)
	for i = 1, 7 do
		local x = -2 + (i - 4) * 0.05
		local z = (i - 4) * 1.5
		-- Square outline (4 lines)
		AB.block(Vector3.new(1.5, 0.05, 0.1), CHALK_W, AB.offset(originCF, x, 0.05, z - 0.7), model, "HopTop_" .. i)
		AB.block(Vector3.new(1.5, 0.05, 0.1), CHALK_W, AB.offset(originCF, x, 0.05, z + 0.7), model, "HopBot_" .. i)
		AB.block(Vector3.new(0.1, 0.05, 1.5), CHALK_W, AB.offset(originCF, x - 0.7, 0.05, z), model, "HopL_" .. i)
		AB.block(Vector3.new(0.1, 0.05, 1.5), CHALK_W, AB.offset(originCF, x + 0.7, 0.05, z), model, "HopR_" .. i)
		-- Number
		AB.block(Vector3.new(0.4, 0.06, 0.4), ({CHALK_R, CHALK_Y, CHALK_B, CHALK_G, CHALK_P, CHALK_R, CHALK_Y})[i],
			AB.offset(originCF, x, 0.06, z), model, "HopNum_" .. i)
	end

	-- Heart drawing to the side (2 circles + tip)
	AB.cylinder(0.5, 0.05, CHALK_R, AB.offset(originCF, 4, 0.05, -2) * CFrame.Angles(math.rad(90), 0, 0), model, "HeartL")
	AB.cylinder(0.5, 0.05, CHALK_R, AB.offset(originCF, 4.6, 0.05, -2) * CFrame.Angles(math.rad(90), 0, 0), model, "HeartR")
	AB.wedge(Vector3.new(0.05, 0.8, 1), CHALK_R,
		AB.offset(originCF, 4.3, 0.05, -1.2) * CFrame.Angles(math.rad(180), 0, math.rad(90)), model, "HeartTip")

	-- Sun (yellow circle + rays)
	AB.cylinder(0.8, 0.05, CHALK_Y, AB.offset(originCF, 4, 0.05, 2) * CFrame.Angles(math.rad(90), 0, 0), model, "Sun")
	for i = 0, 7 do
		local angle = i / 8 * 2 * math.pi
		AB.block(Vector3.new(0.6, 0.05, 0.1), CHALK_Y,
			AB.offset(originCF, 4 + math.cos(angle) * 1.2, 0.05, 2 + math.sin(angle) * 1.2) * CFrame.Angles(0, -angle, 0),
			model, "SunRay_" .. i)
	end

	-- Flower drawing (5 petals around center)
	for i = 0, 4 do
		local angle = i / 5 * 2 * math.pi
		AB.cylinder(0.35, 0.05, CHALK_P,
			AB.offset(originCF, -3 + math.cos(angle) * 0.5, 0.05, 1 + math.sin(angle) * 0.5) * CFrame.Angles(math.rad(90), 0, 0),
			model, "Petal_" .. i)
	end
	AB.cylinder(0.3, 0.05, CHALK_Y,
		AB.offset(originCF, -3, 0.05, 1) * CFrame.Angles(math.rad(90), 0, 0), model, "FlowerCenter")
	-- Stem + leaf
	AB.block(Vector3.new(0.05, 0.05, 1.5), CHALK_G, AB.offset(originCF, -3, 0.05, 2), model, "FlowerStem")
	AB.sphere(0.25, CHALK_G, AB.offset(originCF, -2.5, 0.05, 2.2), model, "FlowerLeaf")

	-- "CIAO!" scribbled
	for i = 1, 4 do
		AB.block(Vector3.new(0.3, 0.05, 0.05), ({CHALK_R, CHALK_B, CHALK_G, CHALK_Y})[i],
			AB.offset(originCF, -3 + (i - 1) * 0.5, 0.05, -2), model, "CiaoLetter_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
