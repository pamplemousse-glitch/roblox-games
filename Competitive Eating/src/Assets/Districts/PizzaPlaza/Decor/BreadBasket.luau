-- Bread Basket — overflowing wicker basket of fresh-baked breads.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BASKET = Color3.fromRGB(190, 140, 80)
local DK_BSK = Color3.fromRGB(130, 90, 50)
local CRUST  = Color3.fromRGB(220, 180, 110)
local DK_CRT = Color3.fromRGB(180, 130, 70)
local BAGUET = Color3.fromRGB(220, 190, 130)
local FLOUR  = Color3.fromRGB(240, 235, 220)
local CLOTH  = Color3.fromRGB(240, 240, 230)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BreadBasket", parent)

	-- Basket body (slatted look via 8 segments)
	for i = 0, 7 do
		local angle = i / 8 * 2 * math.pi
		AB.block(Vector3.new(0.3, 2.5, 1.2), BASKET,
			AB.offset(originCF, 2.4 * math.cos(angle), 1.5, 2.4 * math.sin(angle)) * CFrame.Angles(0, -angle, 0),
			model, "BasketSlat_" .. i)
	end
	-- Basket top rim
	AB.cylinder(5, 0.3, DK_BSK, AB.offset(originCF, 0, 2.8, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Rim")
	-- Bottom
	AB.cylinder(4.8, 0.3, BASKET, AB.offset(originCF, 0, 0.15, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "BasketBottom")
	-- Handle
	AB.cylinder(0.25, 5, DK_BSK,
		AB.offset(originCF, 0, 4.5, 0) * CFrame.Angles(math.rad(90), 0, math.rad(90)), model, "Handle")
	-- Handle vertical (sides)
	AB.cylinder(0.25, 2.5, DK_BSK, AB.offset(originCF, -2.4, 4, 0), model, "HandleStemL")
	AB.cylinder(0.25, 2.5, DK_BSK, AB.offset(originCF,  2.4, 4, 0), model, "HandleStemR")

	-- White cloth liner spilling over
	AB.block(Vector3.new(5, 0.2, 5), CLOTH, AB.offset(originCF, 0, 2.9, 0), model, "ClothLiner")
	-- Cloth corners hanging
	for k, off in {Vector3.new(2.4, 0, 2.4), Vector3.new(-2.4, 0, 2.4), Vector3.new(2.4, 0, -2.4), Vector3.new(-2.4, 0, -2.4)} do
		AB.wedge(Vector3.new(0.2, 1, 0.8), CLOTH,
			AB.offset(originCF, off.X, 2.6, off.Z) * CFrame.Angles(math.rad(180), 0, 0),
			model, "ClothDrape_" .. k)
	end

	-- Bread piles
	-- Baguettes (2 long cylinders sticking up at angles)
	for i, sx in {-0.8, 0.8} do
		AB.cylinder(0.6, 4, BAGUET,
			AB.offset(originCF, sx, 4, 0) * CFrame.Angles(math.rad(20), 0, math.rad(sx > 0 and -10 or 10)),
			model, "Baguette_" .. i)
		-- Baguette score marks
		AB.block(Vector3.new(0.05, 0.7, 0.05), DK_CRT,
			AB.offset(originCF, sx + 0.6, 4, 0) * CFrame.Angles(math.rad(20), 0, math.rad(sx > 0 and -10 or 10)),
			model, "BagScore_" .. i)
	end

	-- Round bread loaves
	AB.sphere(1.2, CRUST, AB.offset(originCF, -1, 3.4, 0.8), model, "Loaf1")
	AB.sphere(1.1, CRUST, AB.offset(originCF,  1.2, 3.4, -0.7), model, "Loaf2")
	AB.sphere(1, DK_CRT, AB.offset(originCF, 0, 3.4, -1.3), model, "Loaf3")

	-- Bread rolls (small spheres)
	for i = 1, 6 do
		local angle = i / 6 * 2 * math.pi
		AB.sphere(0.5, CRUST,
			AB.offset(originCF, 1.6 * math.cos(angle), 3.2, 1.6 * math.sin(angle)), model, "Roll_" .. i)
	end

	-- Dusting of flour
	for i = 1, 5 do
		AB.sphere(0.18, FLOUR,
			AB.offset(originCF, (math.random() - 0.5) * 4, 3.1, (math.random() - 0.5) * 4), model, "Flour_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
