-- Tenement Walkup — 3-story brick walkup building with fire escape, multiple
-- amber-glow windows, stoop entry, and rooftop water tower silhouette.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BRICK     = Color3.fromRGB(150, 60, 50)
local DARK_BRK  = Color3.fromRGB(110, 45, 40)
local AMBER     = Color3.fromRGB(255, 195, 100)
local STEEL_DK  = Color3.fromRGB(60, 60, 65)
local STOOP     = Color3.fromRGB(140, 130, 120)
local WD_TRIM   = Color3.fromRGB(70, 50, 35)
local TANK_WD   = Color3.fromRGB(90, 65, 45)
local NEON_WHT  = Color3.fromRGB(255, 255, 230)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TenementWalkup", parent)

	-- Footprint
	AB.block(Vector3.new(22, 0.5, 18), STOOP, AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Main walls (3 stories ~ 36 studs tall)
	AB.block(Vector3.new(22, 36, 1), BRICK, AB.offset(originCF, 0, 18, -9), model, "BackWall")
	AB.block(Vector3.new(1, 36, 18), BRICK, AB.offset(originCF, -11, 18, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 36, 18), BRICK, AB.offset(originCF,  11, 18, 0), model, "RightWall")
	AB.block(Vector3.new(22, 36, 1), BRICK, AB.offset(originCF, 0, 18, 9), model, "FrontWall")

	-- Brick courses (darker horizontal stripes every 6 studs)
	for s = 1, 5 do
		AB.block(Vector3.new(22.2, 0.4, 1.1), DARK_BRK, AB.offset(originCF, 0, s * 6, 9), model, "Course_" .. s)
	end

	-- Windows: 3 columns × 3 rows on front
	for row = 0, 2 do
		for col = -1, 1 do
			local x = col * 6
			local y = 10 + row * 9
			-- Window glass (amber neon)
			local w = AB.block(Vector3.new(2.6, 3.6, 0.3), AMBER, AB.offset(originCF, x, y, 9.15), model, "Win_" .. row .. "_" .. col)
			AB.neon(w)
			AB.glow(w, w.Color, 0.8)
			-- Frame
			AB.block(Vector3.new(3, 0.3, 0.4), WD_TRIM, AB.offset(originCF, x, y + 1.9, 9.2), model, "WinTop_" .. row .. col)
			AB.block(Vector3.new(3, 0.3, 0.4), WD_TRIM, AB.offset(originCF, x, y - 1.9, 9.2), model, "WinBot_" .. row .. col)
			AB.block(Vector3.new(0.3, 4, 0.4), WD_TRIM, AB.offset(originCF, x - 1.4, y, 9.2), model, "WinL_" .. row .. col)
			AB.block(Vector3.new(0.3, 4, 0.4), WD_TRIM, AB.offset(originCF, x + 1.4, y, 9.2), model, "WinR_" .. row .. col)
			-- Window sill
			AB.block(Vector3.new(3.2, 0.4, 0.6), STOOP, AB.offset(originCF, x, y - 2.1, 9.3), model, "Sill_" .. row .. col)
		end
	end

	-- Stoop entrance (5 steps up) — middle column row 0 has stoop instead of window
	-- Replace the middle-column row-0 window: doorway with arched header
	AB.block(Vector3.new(4, 7, 1), WD_TRIM, AB.offset(originCF, 0, 7.5, 9), model, "DoorBody")
	AB.sphere(2.3, WD_TRIM, AB.offset(originCF, 0, 10, 9), model, "DoorArch")
	AB.block(Vector3.new(2.4, 0.4, 1.1), Color3.fromRGB(220, 200, 180), AB.offset(originCF, 0, 7.5, 9.5), model, "DoorPanel")
	-- Stoop steps
	for i = 1, 5 do
		AB.block(Vector3.new(5.5, 0.6, 1), STOOP, AB.offset(originCF, 0, 0.7 + i * 0.6, 9.5 + i * 0.6), model, "Step_" .. i)
	end
	-- Stoop rails
	for i, sx in {-1, 1} do
		AB.block(Vector3.new(0.2, 3, 0.2), STEEL_DK, AB.offset(originCF, sx * 2.8, 2.2, 11), model, "StoopRail_" .. i)
		AB.cylinder(0.15, 4.5, STEEL_DK,
			AB.offset(originCF, sx * 2.8, 3.2, 12.5) * CFrame.Angles(math.rad(-30), 0, 0), model, "StoopBar_" .. i)
	end

	-- Fire escape (steel) on the right side
	for floor = 1, 2 do
		local fy = floor * 9 + 5
		-- Platform
		AB.block(Vector3.new(8, 0.3, 3), STEEL_DK, AB.offset(originCF, 0, fy, 11), model, "FePlat_" .. floor)
		-- Rails
		AB.block(Vector3.new(8, 2, 0.1), STEEL_DK, AB.offset(originCF, 0, fy + 1, 12.3), model, "FeRail_" .. floor)
		-- Ladder up
		AB.block(Vector3.new(0.3, 9, 0.3), STEEL_DK, AB.offset(originCF, 3.8, fy + 4.5, 12.3), model, "FeLadderL_" .. floor)
		AB.block(Vector3.new(0.3, 9, 0.3), STEEL_DK, AB.offset(originCF, 4.6, fy + 4.5, 12.3), model, "FeLadderR_" .. floor)
		for r = 1, 6 do
			AB.block(Vector3.new(0.9, 0.15, 0.15), STEEL_DK, AB.offset(originCF, 4.2, fy + r * 1.4, 12.3), model, "FeRung_" .. floor .. "_" .. r)
		end
	end

	-- Roof + parapet
	AB.block(Vector3.new(22, 1, 18), DARK_BRK, AB.offset(originCF, 0, 36.5, 0), model, "Roof")
	AB.block(Vector3.new(22, 2, 0.8), BRICK, AB.offset(originCF, 0, 37.5, 9), model, "ParapetFront")
	AB.block(Vector3.new(22, 2, 0.8), BRICK, AB.offset(originCF, 0, 37.5, -9), model, "ParapetBack")
	AB.block(Vector3.new(0.8, 2, 18), BRICK, AB.offset(originCF, -11, 37.5, 0), model, "ParapetL")
	AB.block(Vector3.new(0.8, 2, 18), BRICK, AB.offset(originCF,  11, 37.5, 0), model, "ParapetR")

	-- Rooftop wooden water tower
	AB.cylinder(5, 6, TANK_WD, AB.offset(originCF, -5, 41, -3) * CFrame.Angles(0, 0, math.rad(90)), model, "WaterTankBody")
	-- Tank legs
	for i, sx in {-1, 1} do
		for j, sz in {-1, 1} do
			AB.block(Vector3.new(0.4, 4, 0.4), TANK_WD,
				AB.offset(originCF, -5 + sx * 2, 39, -3 + sz * 2), model, "TankLeg_" .. i .. j)
		end
	end
	-- Tank conical top
	AB.wedge(Vector3.new(5, 2.5, 5), TANK_WD,
		AB.offset(originCF, -5, 44.5, -3) * CFrame.Angles(0, math.rad(45), 0), model, "TankTop")

	-- Rooftop chimney
	AB.block(Vector3.new(2.4, 3, 2.4), BRICK, AB.offset(originCF, 6, 39, -6), model, "Chimney")
	AB.block(Vector3.new(2.6, 0.4, 2.6), DARK_BRK, AB.offset(originCF, 6, 40.7, -6), model, "ChimneyCap")

	-- Building number plaque (neon)
	local plaque = AB.block(Vector3.new(1.6, 1.4, 0.2), NEON_WHT, AB.offset(originCF, 3.5, 7, 9.2), model, "BldgNum")
	AB.neon(plaque)

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
