-- Wine Barrel Stack — 3 wooden wine barrels stacked pyramid, iron hoops,
-- spigot, with a bottle on top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BARREL    = Color3.fromRGB(110, 75, 45)
local DK_WD     = Color3.fromRGB(70, 45, 25)
local IRON      = Color3.fromRGB(50, 50, 55)
local CORK      = Color3.fromRGB(195, 165, 120)
local GREEN_BTL = Color3.fromRGB(40, 70, 45)
local WINE      = Color3.fromRGB(110, 30, 40)

local function barrel(model, originCF, ox, oy, oz, name)
	-- Body (cylinder lying on its side, along Z axis using rotation)
	AB.cylinder(3.5, 4.5, BARREL,
		AB.offset(originCF, ox, oy, oz) * CFrame.Angles(0, math.rad(90), math.rad(90)),
		model, name .. "_Body")
	-- Top cap (slightly larger to suggest curvature)
	AB.cylinder(3.4, 0.3, DK_WD,
		AB.offset(originCF, ox, oy, oz + 2.4) * CFrame.Angles(0, 0, math.rad(90)),
		model, name .. "_CapF")
	AB.cylinder(3.4, 0.3, DK_WD,
		AB.offset(originCF, ox, oy, oz - 2.4) * CFrame.Angles(0, 0, math.rad(90)),
		model, name .. "_CapB")
	-- Iron hoops (3)
	for i, dz in {-1.2, 0, 1.2} do
		AB.cylinder(3.6, 0.25, IRON,
			AB.offset(originCF, ox, oy, oz + dz) * CFrame.Angles(0, 0, math.rad(90)),
			model, name .. "_Hoop_" .. i)
	end
end

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WineBarrelStack", parent)

	-- Bottom 2 barrels
	barrel(model, originCF, -2,   1.8, 0, "Barrel1")
	barrel(model, originCF,  2,   1.8, 0, "Barrel2")
	-- Top barrel
	barrel(model, originCF,  0,   5.0, 0, "Barrel3")

	-- Spigot on the bottom-left barrel
	AB.cylinder(0.4, 0.8, IRON,
		AB.offset(originCF, -2, 1.8, 2.7) * CFrame.Angles(math.rad(90), 0, 0), model, "Spigot")
	AB.cylinder(0.3, 0.4, IRON,
		AB.offset(originCF, -2, 1.4, 3) * CFrame.Angles(math.rad(90), 0, 0), model, "SpigotDrip")
	-- Wine puddle below
	local puddle = AB.cylinder(1.4, 0.05, WINE,
		AB.offset(originCF, -2, 0.05, 3.5) * CFrame.Angles(0, 0, math.rad(90)), model, "WinePuddle")
	puddle.Material = Enum.Material.Glass

	-- Wine bottle perched on top
	AB.cylinder(0.6, 1.8, GREEN_BTL, AB.offset(originCF, 0, 7, 0.8), model, "Bottle")
	AB.cylinder(0.3, 0.6, GREEN_BTL, AB.offset(originCF, 0, 8, 0.8), model, "BottleNeck")
	AB.sphere(0.25, CORK, AB.offset(originCF, 0, 8.5, 0.8), model, "Cork")
	-- Label on bottle
	AB.block(Vector3.new(1.0, 0.8, 0.1), Color3.fromRGB(240, 230, 200),
		AB.offset(originCF, 0, 6.7, 1.4), model, "BottleLabel")

	-- Bunch of grapes draped over top (small spheres)
	for i = 1, 8 do
		local x = (math.random() - 0.5) * 1.8
		local z = (math.random() - 0.5) * 1.8
		AB.sphere(0.35, Color3.fromRGB(85, 40, 100), AB.offset(originCF, 1.5 + x, 6.5 - i * 0.2, z - 0.5), model, "Grape_" .. i)
	end
	-- Vine leaf
	AB.sphere(0.7, Color3.fromRGB(80, 140, 60), AB.offset(originCF, 1.6, 7, -0.6), model, "GrapeLeaf")

	-- Burlap sack against the barrels
	AB.block(Vector3.new(1.6, 1.8, 1.4), Color3.fromRGB(180, 155, 110),
		AB.offset(originCF, 4, 0.9, 2), model, "BurlapSack")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
