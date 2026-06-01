-- Picnic Bench — long wooden bench with red-checkered tablecloth, plates,
-- glasses, and a bottle of olive oil. Outdoor dining feel.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WD        = Color3.fromRGB(110, 75, 45)
local DK_WD     = Color3.fromRGB(80, 50, 30)
local RED       = Color3.fromRGB(200, 40, 40)
local WHITE     = Color3.fromRGB(245, 240, 230)
local OIL_GRN   = Color3.fromRGB(40, 70, 45)
local GLASS_Y   = Color3.fromRGB(220, 240, 255)
local WINE      = Color3.fromRGB(110, 30, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PicnicBench", parent)

	-- Table top
	AB.block(Vector3.new(10, 0.4, 3.5), WD, AB.offset(originCF, 0, 3, 0), model, "TableTop")
	-- Table legs (X-shaped)
	for i, sx in {-1, 1} do
		AB.block(Vector3.new(0.4, 3, 0.4), DK_WD,
			AB.offset(originCF, sx * 3.5, 1.5, 1.4) * CFrame.Angles(math.rad(15), 0, 0), model, "LegFront_" .. i)
		AB.block(Vector3.new(0.4, 3, 0.4), DK_WD,
			AB.offset(originCF, sx * 3.5, 1.5, -1.4) * CFrame.Angles(math.rad(-15), 0, 0), model, "LegBack_" .. i)
		-- Cross brace
		AB.block(Vector3.new(0.4, 0.3, 3), DK_WD, AB.offset(originCF, sx * 3.5, 0.4, 0), model, "LegBrace_" .. i)
	end
	-- Center stretcher
	AB.block(Vector3.new(7, 0.3, 0.3), DK_WD, AB.offset(originCF, 0, 1, 0), model, "Stretcher")

	-- Red-checkered tablecloth (cloth draped on top)
	AB.block(Vector3.new(10.4, 0.2, 3.8), RED, AB.offset(originCF, 0, 3.2, 0), model, "Tablecloth")
	-- White check pattern (small white squares)
	for i = -4, 4 do
		for j = -1, 1 do
			if (i + j) % 2 == 0 then
				AB.block(Vector3.new(0.9, 0.22, 0.9), WHITE,
					AB.offset(originCF, i * 1.1, 3.22, j * 1.1), model, "Check_" .. (i + 5) .. "_" .. (j + 2))
			end
		end
	end
	-- Tablecloth drape (hanging over edges)
	AB.block(Vector3.new(10.4, 0.6, 0.2), RED, AB.offset(originCF, 0, 2.7, 1.9), model, "DrapeFront")
	AB.block(Vector3.new(10.4, 0.6, 0.2), RED, AB.offset(originCF, 0, 2.7, -1.9), model, "DrapeBack")

	-- Two benches alongside the table
	for i, sz in {-2.6, 2.6} do
		AB.block(Vector3.new(10, 0.3, 1.2), WD, AB.offset(originCF, 0, 2, sz), model, "BenchSeat_" .. i)
		AB.block(Vector3.new(0.4, 2, 1.2), DK_WD, AB.offset(originCF, -3.5, 1, sz), model, "BenchLegL_" .. i)
		AB.block(Vector3.new(0.4, 2, 1.2), DK_WD, AB.offset(originCF,  3.5, 1, sz), model, "BenchLegR_" .. i)
	end

	-- Place settings (2 plates with pizza slices)
	for i, sx in {-3, 3} do
		-- Plate
		AB.cylinder(2, 0.15, WHITE, AB.offset(originCF, sx, 3.4, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Plate_" .. i)
		-- Pizza slice (wedge)
		AB.wedge(Vector3.new(0.15, 0.8, 1.5), AB.colors.pizzaCrust,
			AB.offset(originCF, sx, 3.55, 0) * CFrame.Angles(math.rad(180), 0, math.rad(90)), model, "Slice_" .. i)
		-- Pep dots on slice
		AB.sphere(0.18, RED, AB.offset(originCF, sx + 0.3, 3.7, 0), model, "SlicePep_" .. i)
		AB.sphere(0.18, RED, AB.offset(originCF, sx - 0.2, 3.7, -0.3), model, "SlicePep2_" .. i)
		-- Fork
		AB.block(Vector3.new(0.08, 0.05, 1), Color3.fromRGB(200, 200, 210),
			AB.offset(originCF, sx, 3.4, 1.8), model, "Fork_" .. i)
	end

	-- Wine glasses (2)
	for i, sx in {-3, 3} do
		AB.cylinder(0.5, 1.2, GLASS_Y,
			AB.offset(originCF, sx, 4, -1.2), model, "GlassBowl_" .. i)
		AB.cylinder(0.6, 0.15, WINE,
			AB.offset(originCF, sx, 4.4, -1.2), model, "WineInGlass_" .. i)
		AB.cylinder(0.1, 1, GLASS_Y, AB.offset(originCF, sx, 3.45, -1.2), model, "GlassStem_" .. i)
		AB.cylinder(0.6, 0.1, GLASS_Y,
			AB.offset(originCF, sx, 3.3, -1.2) * CFrame.Angles(0, 0, math.rad(90)), model, "GlassBase_" .. i)
	end

	-- Olive oil bottle in center
	AB.cylinder(0.5, 2, OIL_GRN, AB.offset(originCF, 0, 4.2, 0), model, "OilBottle")
	AB.cylinder(0.25, 0.6, OIL_GRN, AB.offset(originCF, 0, 5.3, 0), model, "OilNeck")
	AB.sphere(0.2, Color3.fromRGB(195, 165, 120), AB.offset(originCF, 0, 5.7, 0), model, "OilCork")
	-- Label
	AB.block(Vector3.new(0.9, 0.6, 0.05), Color3.fromRGB(240, 220, 180), AB.offset(originCF, 0, 4.2, 0.55), model, "OilLabel")

	-- Bread basket
	AB.block(Vector3.new(2, 0.6, 1.2), Color3.fromRGB(190, 140, 80),
		AB.offset(originCF, 0, 3.7, 1), model, "BreadBasket")
	for i = 1, 3 do
		AB.sphere(0.4, Color3.fromRGB(220, 190, 130), AB.offset(originCF, -0.5 + (i - 1) * 0.5, 4.1, 1), model, "Roll_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
