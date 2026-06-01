-- Salaryman Apartments — backdrop mid-rise apartment block. Beige stucco
-- facade, grid of identical balconied windows, air-con units visible, drying
-- laundry on a couple of balconies, rooftop water tank.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STUCCO      = Color3.fromRGB(200, 195, 175)
local STUCCO_DARK = Color3.fromRGB(170, 160, 140)
local DARK_METAL  = Color3.fromRGB(55, 55, 65)
local METAL_GREY  = Color3.fromRGB(110, 110, 120)
local GLASS_BLUE  = Color3.fromRGB(150, 200, 220)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local STONE       = Color3.fromRGB(120, 115, 105)
local AC_WHITE    = Color3.fromRGB(225, 220, 210)
local SHIRT_BLUE  = Color3.fromRGB(120, 170, 200)
local SHIRT_WHITE = Color3.fromRGB(240, 240, 240)
local PIPE_GREY   = Color3.fromRGB(80, 80, 90)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SalarymanApartments", parent)

	-- Foundation
	AB.block(Vector3.new(34, 0.5, 14), STONE,
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Main body (5 floors visible, plus a small parapet)
	AB.block(Vector3.new(34, 30, 13), STUCCO,
		AB.offset(originCF, 0, 15.5, 0), model, "Body")

	-- Stucco trim — horizontal floor separators
	for i = 1, 5 do
		AB.block(Vector3.new(34.1, 0.3, 13.1), STUCCO_DARK,
			AB.offset(originCF, 0, 1.5 + i * 6, 0), model, "FloorTrim_" .. i)
	end
	-- Corner dark stucco bands
	for i, x in {-17, 17} do
		AB.block(Vector3.new(0.4, 30, 13.05), STUCCO_DARK,
			AB.offset(originCF, x, 15.5, 0), model, "CornerStripe_" .. i)
	end

	-- 5 rows × 6 columns of balconied windows on the front face
	for row = 0, 4 do
		for col = 0, 5 do
			local x = (col - 2.5) * 5.4
			local y = 4 + row * 6
			-- Window glass
			local glass = AB.block(Vector3.new(3, 3.5, 0.4), GLASS_BLUE,
				AB.offset(originCF, x, y, 6.7), model, "Win_" .. row .. "_" .. col)
			glass.Transparency = 0.3
			-- Some windows glow yellow (occupants home)
			if (row + col * 2) % 4 == 0 then
				glass.Color = LANTERN_Y
				glass.Transparency = 0.05
				AB.neon(glass)
			end
			-- Window dark frame
			AB.block(Vector3.new(3.2, 0.2, 0.5), DARK_METAL, AB.offset(originCF, x, y + 1.8, 6.75), model, "WinTop_" .. row .. "_" .. col)
			AB.block(Vector3.new(3.2, 0.2, 0.5), DARK_METAL, AB.offset(originCF, x, y - 1.8, 6.75), model, "WinBot_" .. row .. "_" .. col)

			-- Small balcony rail (metal)
			AB.block(Vector3.new(3.4, 0.18, 0.18), METAL_GREY,
				AB.offset(originCF, x, y - 1.6, 7.4), model, "RailTop_" .. row .. "_" .. col)
			AB.block(Vector3.new(3.4, 0.18, 0.18), METAL_GREY,
				AB.offset(originCF, x, y - 2.4, 7.4), model, "RailBot_" .. row .. "_" .. col)
			for j, dx in {-1.4, -0.4, 0.4, 1.4} do
				AB.block(Vector3.new(0.12, 1, 0.12), METAL_GREY,
					AB.offset(originCF, x + dx, y - 2, 7.4), model, "Bar_" .. row .. "_" .. col .. "_" .. j)
			end

			-- Air-con unit beside random windows
			if (row * 3 + col) % 5 == 0 then
				AB.block(Vector3.new(1.4, 1, 0.6), AC_WHITE,
					AB.offset(originCF, x + 1.8, y - 1, 6.9), model, "AC_" .. row .. "_" .. col)
				AB.block(Vector3.new(0.8, 0.5, 0.1), DARK_METAL,
					AB.offset(originCF, x + 1.8, y - 0.8, 7.2), model, "ACGrille_" .. row .. "_" .. col)
			end
		end
	end

	-- Drying laundry on 3 balconies
	for _, info in {
		{-8.1, 10, SHIRT_WHITE}, {2.7, 16, SHIRT_BLUE}, {8.1, 22, SHIRT_WHITE},
	} do
		local lx, ly, lc = info[1], info[2], info[3]
		-- Clothesline
		AB.cylinder(0.05, 2.5, METAL_GREY,
			AB.offset(originCF, lx, ly - 1.3, 7.5) * CFrame.Angles(0, math.rad(90), math.rad(90)),
			model, "Line_" .. ly)
		-- Two shirts
		for j = 0, 1 do
			AB.block(Vector3.new(0.6, 0.9, 0.05), lc,
				AB.offset(originCF, lx - 0.5 + j * 1, ly - 1.8, 7.5), model, "Shirt_" .. ly .. "_" .. j)
		end
	end

	-- Rooftop parapet
	AB.block(Vector3.new(34, 1.4, 13), STUCCO_DARK,
		AB.offset(originCF, 0, 31.2, 0), model, "Parapet")

	-- Rooftop water tank (the iconic concrete cylinder)
	AB.cylinder(5, 5, METAL_GREY,
		AB.offset(originCF, 8, 34.5, -3) * CFrame.Angles(math.rad(90), 0, 0),
		model, "WaterTank")
	-- Tank legs (4 small)
	for i, offset in {
		Vector3.new(6, 32.5, -4.5),
		Vector3.new(10, 32.5, -4.5),
		Vector3.new(6, 32.5, -1.5),
		Vector3.new(10, 32.5, -1.5),
	} do
		AB.block(Vector3.new(0.4, 1.5, 0.4), DARK_METAL,
			AB.offset(originCF, offset.X, offset.Y, offset.Z), model, "TankLeg_" .. i)
	end

	-- Rooftop AC condensers (3)
	for i = 1, 3 do
		AB.block(Vector3.new(2, 1.5, 2), AC_WHITE,
			AB.offset(originCF, -10 + (i - 1) * 3, 32.7, 3), model, "RoofAC_" .. i)
	end

	-- Vertical drainpipe down the left edge
	AB.cylinder(0.4, 30, PIPE_GREY,
		AB.offset(originCF, -16.4, 15.5, 6.6), model, "DrainPipe")
	-- Pipe brackets
	for i, y in {6, 18, 28} do
		AB.block(Vector3.new(0.6, 0.4, 0.6), DARK_METAL,
			AB.offset(originCF, -16.4, y, 6.6), model, "PipeBracket_" .. i)
	end

	-- Glowing ground-floor entrance plaque
	local entry = AB.block(Vector3.new(3, 1, 0.4), PAPER_WHITE,
		AB.offset(originCF, 0, 2, 6.7), model, "EntryPlaque")
	AB.neon(entry)
	AB.glow(entry, PAPER_WHITE, 1.5)

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
