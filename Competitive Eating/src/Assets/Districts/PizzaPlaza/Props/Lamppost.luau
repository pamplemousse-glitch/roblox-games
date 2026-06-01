-- Lamppost — wrought-iron street lamp with double globe + scroll bracket
-- and a small "DI ROMA" plaque.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local IRON      = Color3.fromRGB(35, 35, 40)
local GLOBE     = Color3.fromRGB(255, 230, 160)
local BRASS     = Color3.fromRGB(200, 160, 80)
local PLAQUE    = Color3.fromRGB(190, 165, 110)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Lamppost", parent)

	-- Foot base (square)
	AB.block(Vector3.new(1.6, 1, 1.6), IRON, AB.offset(originCF, 0, 0.5, 0), model, "Base")
	AB.block(Vector3.new(2, 0.4, 2), IRON, AB.offset(originCF, 0, 0.2, 0), model, "BasePlate")
	-- Decorative ring
	AB.cylinder(1.5, 0.2, BRASS, AB.offset(originCF, 0, 1.1, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "BaseRing")

	-- Main post (tapered cylinder via 3 stacks)
	AB.cylinder(0.8, 6, IRON, AB.offset(originCF, 0, 4, 0), model, "PostLower")
	AB.cylinder(0.6, 4, IRON, AB.offset(originCF, 0, 9, 0), model, "PostUpper")

	-- Mid decoration (Acanthus leaf ring)
	for i = 0, 3 do
		local angle = i / 4 * 2 * math.pi
		AB.block(Vector3.new(0.3, 0.6, 0.3), BRASS,
			AB.offset(originCF, 0.5 * math.cos(angle), 7, 0.5 * math.sin(angle)), model, "Leaf_" .. i)
	end

	-- Top crossbar (scroll bracket)
	AB.block(Vector3.new(5, 0.3, 0.3), IRON, AB.offset(originCF, 0, 11.5, 0), model, "Crossbar")
	-- Scroll curls at each end
	AB.sphere(0.6, IRON, AB.offset(originCF, -2.5, 11.5, 0), model, "ScrollL")
	AB.sphere(0.6, IRON, AB.offset(originCF,  2.5, 11.5, 0), model, "ScrollR")

	-- Hanging brackets
	AB.block(Vector3.new(0.3, 1, 0.3), IRON, AB.offset(originCF, -2.5, 11, 0), model, "HangerL")
	AB.block(Vector3.new(0.3, 1, 0.3), IRON, AB.offset(originCF,  2.5, 11, 0), model, "HangerR")

	-- Two glowing globes
	for i, sx in {-1, 1} do
		local g = AB.sphere(1.8, GLOBE, AB.offset(originCF, sx * 2.5, 10, 0), model, "Globe_" .. i)
		AB.neon(g)
		AB.glow(g, g.Color, 3)
		-- Cap on top
		AB.cylinder(1.3, 0.3, IRON,
			AB.offset(originCF, sx * 2.5, 11, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "GlobeCap_" .. i)
	end

	-- Central decorative finial
	AB.sphere(0.5, BRASS, AB.offset(originCF, 0, 12.2, 0), model, "Finial")
	AB.block(Vector3.new(0.2, 1, 0.2), BRASS, AB.offset(originCF, 0, 12.8, 0), model, "FinialSpike")

	-- Plaque
	AB.block(Vector3.new(1.4, 0.7, 0.1), PLAQUE, AB.offset(originCF, 0, 3, 0.85), model, "Plaque")

	-- Hanging flower basket (small)
	AB.cylinder(1, 0.5, Color3.fromRGB(110, 75, 45),
		AB.offset(originCF, -2.5, 9, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "FlowerBasket")
	AB.sphere(0.5, Color3.fromRGB(220, 60, 80), AB.offset(originCF, -2.5, 9.4, 0), model, "BasketFlower")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
