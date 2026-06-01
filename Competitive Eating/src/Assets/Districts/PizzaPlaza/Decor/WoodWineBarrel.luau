-- Wood Wine Barrel — single standalone barrel as a side-table, with a wine
-- bottle and glasses on top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WD     = Color3.fromRGB(110, 75, 45)
local DK_WD  = Color3.fromRGB(70, 45, 25)
local IRON   = Color3.fromRGB(50, 50, 55)
local GLASS  = Color3.fromRGB(220, 240, 255)
local WINE   = Color3.fromRGB(110, 30, 40)
local BOTTLE = Color3.fromRGB(40, 70, 45)
local CORK   = Color3.fromRGB(195, 165, 120)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WoodWineBarrel", parent)

	-- Barrel body (upright)
	AB.cylinder(3.5, 5, WD, AB.offset(originCF, 0, 2.5, 0), model, "Body")
	-- Top + bottom caps
	AB.cylinder(3.4, 0.3, DK_WD, AB.offset(originCF, 0, 5.1, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "TopCap")
	AB.cylinder(3.4, 0.3, DK_WD, AB.offset(originCF, 0, 0.15, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "BotCap")
	-- Iron hoops
	for i, y in {0.8, 2.5, 4.3} do
		AB.cylinder(3.6, 0.3, IRON, AB.offset(originCF, 0, y, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Hoop_" .. i)
	end
	-- Vertical stave lines (dark grain)
	for i = 0, 7 do
		local angle = i / 8 * 2 * math.pi
		AB.block(Vector3.new(0.06, 4.8, 0.06), DK_WD,
			AB.offset(originCF, 1.75 * math.cos(angle), 2.5, 1.75 * math.sin(angle)), model, "Stave_" .. i)
	end

	-- Top tabletop (round, slightly wider)
	AB.cylinder(3.8, 0.3, DK_WD, AB.offset(originCF, 0, 5.4, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Tabletop")

	-- Wine bottle on top
	AB.cylinder(0.6, 2.2, BOTTLE, AB.offset(originCF, -0.6, 6.6, 0), model, "Bottle")
	AB.cylinder(0.3, 0.6, BOTTLE, AB.offset(originCF, -0.6, 7.7, 0), model, "BottleNeck")
	AB.sphere(0.25, CORK, AB.offset(originCF, -0.6, 8.1, 0), model, "Cork")
	AB.block(Vector3.new(1, 0.7, 0.05), Color3.fromRGB(245, 230, 200),
		AB.offset(originCF, -0.6, 6.5, 0.6), model, "BottleLabel")

	-- Two wine glasses
	for i, sx in {0.8, 1.6} do
		AB.cylinder(0.4, 0.1, GLASS,
			AB.offset(originCF, sx, 5.6, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "GlassBase_" .. i)
		AB.cylinder(0.08, 1.2, GLASS, AB.offset(originCF, sx, 6.2, 0), model, "GlassStem_" .. i)
		AB.sphere(0.7, GLASS, AB.offset(originCF, sx, 7, 0), model, "GlassBowl_" .. i)
		AB.sphere(0.5, WINE, AB.offset(originCF, sx, 6.85, 0), model, "GlassWine_" .. i)
	end

	-- Wedge of cheese on a small plate
	AB.cylinder(1, 0.1, Color3.fromRGB(245, 240, 230),
		AB.offset(originCF, -1.5, 5.6, 1.2) * CFrame.Angles(0, 0, math.rad(90)), model, "CheesePlate")
	AB.wedge(Vector3.new(0.5, 0.5, 1), Color3.fromRGB(235, 215, 155),
		AB.offset(originCF, -1.5, 5.95, 1.2) * CFrame.Angles(math.rad(180), 0, math.rad(90)), model, "CheeseWedge")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
