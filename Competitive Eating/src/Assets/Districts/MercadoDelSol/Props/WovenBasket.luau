-- Woven Basket — round basket with horizontal weave rings and an arched
-- handle, overflowing with market fruit (oranges, limes, chilies, lemon, corn).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BASKET_BROWN = Color3.fromRGB(130, 85, 50)
local WEAVE_LIGHT  = Color3.fromRGB(180, 140, 90)
local ORANGE       = Color3.fromRGB(240, 140, 40)
local LIME_GREEN   = Color3.fromRGB(140, 200, 60)
local CHILI_RED    = Color3.fromRGB(200, 40, 40)
local LEMON_YEL    = Color3.fromRGB(245, 220, 70)
local CORN_YEL     = Color3.fromRGB(255, 215, 100)
local CORN_LEAF    = Color3.fromRGB(120, 170, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WovenBasket", parent)

	-- Basket body
	local body = AB.cylinder(3, 2, BASKET_BROWN,
		AB.offset(originCF, 0, 1, 0), model, "BasketBody")

	-- 4 horizontal weave rings around the body
	for i = 1, 4 do
		AB.cylinder(3.05, 0.18, WEAVE_LIGHT,
			AB.offset(originCF, 0, 0.35 + (i - 1) * 0.45, 0),
			model, "WeaveRing_" .. i)
	end

	-- Vertical weave accents around the circumference
	for i = 1, 6 do
		local a = (i - 1) * (2 * math.pi / 6)
		local x = math.cos(a) * 1.52
		local z = math.sin(a) * 1.52
		AB.block(Vector3.new(0.18, 1.8, 0.18), WEAVE_LIGHT,
			AB.offset(originCF, x, 1, z) * CFrame.Angles(0, -a, 0),
			model, "WeaveVert_" .. i)
	end

	-- Arched handle (3 blocks forming an arch)
	AB.block(Vector3.new(0.3, 1, 0.3), BASKET_BROWN,
		AB.offset(originCF, -1.3, 2.5, 0) * CFrame.Angles(0, 0, math.rad(35)),
		model, "HandleL")
	AB.block(Vector3.new(0.3, 1, 0.3), BASKET_BROWN,
		AB.offset(originCF,  1.3, 2.5, 0) * CFrame.Angles(0, 0, math.rad(-35)),
		model, "HandleR")
	AB.block(Vector3.new(2.2, 0.3, 0.3), BASKET_BROWN,
		AB.offset(originCF, 0, 3.1, 0), model, "HandleTop")

	-- Fruit overflowing the top
	-- 3 oranges
	AB.sphere(0.75, ORANGE, AB.offset(originCF, -0.6, 2.3, 0.4), model, "Orange1")
	AB.sphere(0.75, ORANGE, AB.offset(originCF,  0.5, 2.3, -0.3), model, "Orange2")
	AB.sphere(0.7,  ORANGE, AB.offset(originCF,  0.1, 2.6, 0.7), model, "Orange3")
	-- 2 limes
	AB.sphere(0.55, LIME_GREEN, AB.offset(originCF, -0.8, 2.6, -0.4), model, "Lime1")
	AB.sphere(0.55, LIME_GREEN, AB.offset(originCF,  0.8, 2.6, 0.4), model, "Lime2")
	-- 2 chili peppers (small wedges)
	AB.wedge(Vector3.new(0.25, 0.9, 0.4), CHILI_RED,
		AB.offset(originCF, -0.3, 2.9, 0.5) * CFrame.Angles(0, math.rad(20), math.rad(-30)),
		model, "Chili1")
	AB.wedge(Vector3.new(0.25, 0.9, 0.4), CHILI_RED,
		AB.offset(originCF, 0.4, 2.85, -0.5) * CFrame.Angles(0, math.rad(-40), math.rad(25)),
		model, "Chili2")
	-- 1 lemon
	AB.sphere(0.55, LEMON_YEL, AB.offset(originCF, 0, 2.4, -0.7), model, "Lemon")
	-- 1 corn cob
	AB.cylinder(0.45, 1.3, CORN_YEL,
		AB.offset(originCF, 0.9, 2.9, 0) * CFrame.Angles(0, 0, math.rad(25)),
		model, "CornCob")
	AB.wedge(Vector3.new(0.3, 0.7, 0.3), CORN_LEAF,
		AB.offset(originCF, 0.4, 3.1, 0) * CFrame.Angles(0, 0, math.rad(45)),
		model, "CornLeaf")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
