-- Red Rose Vase — glass vase with a dozen red roses + greenery.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local GLASS = Color3.fromRGB(220, 240, 255)
local WATER = Color3.fromRGB(180, 220, 240)
local ROSE  = Color3.fromRGB(200, 30, 50)
local DK_R  = Color3.fromRGB(140, 20, 30)
local STEM  = Color3.fromRGB(80, 140, 60)
local LEAF  = Color3.fromRGB(110, 160, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RedRoseVase", parent)

	-- Vase (tapered cylinder shape via 2 cylinders)
	AB.cylinder(1.6, 3, GLASS, AB.offset(originCF, 0, 1.5, 0), model, "VaseBot")
	AB.cylinder(2, 0.4, GLASS, AB.offset(originCF, 0, 3, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "VaseLip")
	-- Water inside
	AB.cylinder(1.5, 2, WATER, AB.offset(originCF, 0, 2, 0), model, "Water")

	-- 12 rose stems (vertical green cylinders)
	for i = 1, 12 do
		local angle = (i - 1) / 12 * 2 * math.pi
		local x = math.cos(angle) * 0.5
		local z = math.sin(angle) * 0.5
		AB.cylinder(0.1, 4, STEM, AB.offset(originCF, x, 5, z) * CFrame.Angles(0, 0, math.rad(angle * 5)), model, "Stem_" .. i)
		-- Thorns (small spikes)
		AB.block(Vector3.new(0.06, 0.2, 0.06), DK_R, AB.offset(originCF, x, 4.5, z + 0.1), model, "Thorn_" .. i)
		-- Leaf
		AB.sphere(0.3, LEAF, AB.offset(originCF, x * 1.8, 4 + math.sin(i) * 0.3, z * 1.8), model, "Leaf_" .. i)
		-- Rose blossom
		AB.sphere(0.5, ROSE, AB.offset(originCF, x * 2, 7 + math.sin(i) * 0.2, z * 2), model, "Rose_" .. i)
		AB.sphere(0.35, DK_R, AB.offset(originCF, x * 2, 7 + math.sin(i) * 0.2, z * 2), model, "RoseInner_" .. i)
	end

	-- Smaller filler greenery (baby's breath as white spheres)
	for i = 1, 8 do
		AB.sphere(0.15, Color3.fromRGB(245, 240, 220),
			AB.offset(originCF, math.cos(i) * 1.2, 7.5 + math.sin(i) * 0.5, math.sin(i) * 1.2), model, "Baby_" .. i)
	end

	-- Tied ribbon around vase
	AB.cylinder(1.65, 0.3, Color3.fromRGB(220, 60, 80),
		AB.offset(originCF, 0, 2, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Ribbon")
	-- Ribbon bow
	AB.block(Vector3.new(0.7, 0.4, 0.1), Color3.fromRGB(220, 60, 80), AB.offset(originCF, 1.4, 2, 0.4), model, "BowL")
	AB.block(Vector3.new(0.7, 0.4, 0.1), Color3.fromRGB(220, 60, 80), AB.offset(originCF, 1.4, 2, -0.4), model, "BowR")
	AB.sphere(0.15, Color3.fromRGB(220, 60, 80), AB.offset(originCF, 1.4, 2, 0), model, "BowKnot")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
