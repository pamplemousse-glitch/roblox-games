-- Laundry Line Buildings — two narrow tenement facades with a string of
-- laundry hanging between them (shirts, sheets, socks). Iconic Italian-American
-- street ambience.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STUCCO_A  = Color3.fromRGB(220, 195, 160)
local STUCCO_B  = Color3.fromRGB(200, 180, 145)
local SHUTTER   = Color3.fromRGB(110, 30, 40)
local AMBER     = Color3.fromRGB(255, 195, 100)
local DARK_WD   = Color3.fromRGB(80, 50, 30)
local TILE      = Color3.fromRGB(170, 80, 60)

local SHIRT_R   = Color3.fromRGB(220, 70, 70)
local SHIRT_W   = Color3.fromRGB(245, 240, 230)
local SHIRT_B   = Color3.fromRGB(60, 100, 160)
local SHIRT_G   = Color3.fromRGB(80, 140, 60)
local SHIRT_Y   = Color3.fromRGB(240, 220, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("LaundryLineBuildings", parent)

	-- Two narrow building facades side-by-side, gap in between for laundry line
	for k, info in {{x = -10, color = STUCCO_A}, {x = 10, color = STUCCO_B}} do
		-- Foundation
		AB.block(Vector3.new(14, 0.5, 12), Color3.fromRGB(110, 100, 95),
			AB.offset(originCF, info.x, 0.25, 0), model, "Foundation_" .. k)
		-- Walls (2 stories)
		AB.block(Vector3.new(14, 24, 1), info.color, AB.offset(originCF, info.x, 12, -5.5), model, "Back_" .. k)
		AB.block(Vector3.new(1, 24, 12), info.color, AB.offset(originCF, info.x - 7, 12, 0), model, "Left_" .. k)
		AB.block(Vector3.new(1, 24, 12), info.color, AB.offset(originCF, info.x + 7, 12, 0), model, "Right_" .. k)
		AB.block(Vector3.new(14, 24, 1), info.color, AB.offset(originCF, info.x, 12, 5.5), model, "Front_" .. k)
		-- Wood beam between stories
		AB.block(Vector3.new(14, 0.4, 1.1), DARK_WD, AB.offset(originCF, info.x, 12, 5.5), model, "Beam_" .. k)

		-- Windows (4 per facade — 2 per floor)
		for row = 0, 1 do
			for col = -1, 1, 2 do
				local x = info.x + col * 3
				local y = 7 + row * 9
				local w = AB.block(Vector3.new(2.4, 3.5, 0.3), AMBER, AB.offset(originCF, x, y, 5.65), model, "Win_" .. k .. row .. col)
				AB.neon(w)
				AB.glow(w, w.Color, 0.7)
				-- Shutters
				AB.block(Vector3.new(0.8, 3.5, 0.3), SHUTTER, AB.offset(originCF, x - 1.6, y, 5.75), model, "ShutL_" .. k .. row .. col)
				AB.block(Vector3.new(0.8, 3.5, 0.3), SHUTTER, AB.offset(originCF, x + 1.6, y, 5.75), model, "ShutR_" .. k .. row .. col)
				-- Sill
				AB.block(Vector3.new(3.2, 0.3, 0.5), DARK_WD, AB.offset(originCF, x, y - 1.9, 5.85), model, "Sill_" .. k .. row .. col)
			end
		end

		-- Tile roof
		AB.block(Vector3.new(15, 0.8, 13), TILE, AB.offset(originCF, info.x, 24.5, 0), model, "Roof_" .. k)
		AB.block(Vector3.new(15, 0.5, 1.2), DARK_WD, AB.offset(originCF, info.x, 24.9, 0), model, "RoofRidge_" .. k)
	end

	-- Laundry line strung between the two buildings (across the gap, ~12 studs)
	local lineY = 17
	AB.block(Vector3.new(20, 0.1, 0.1), DARK_WD, AB.offset(originCF, 0, lineY, 5.6), model, "ClothesLine")

	-- Hanging clothes: shirts, sheets, socks
	local clothes = {
		{w = 2.5, h = 3, c = SHIRT_R, x = -8},
		{w = 4,   h = 4, c = SHIRT_W, x = -4.5},
		{w = 2.5, h = 3, c = SHIRT_B, x = -1},
		{w = 1.2, h = 1.5, c = SHIRT_Y, x = 1.5},
		{w = 3,   h = 3.5, c = SHIRT_G, x = 4},
		{w = 2.2, h = 2.8, c = SHIRT_W, x = 7},
	}
	for i, item in clothes do
		AB.block(Vector3.new(item.w, item.h, 0.15), item.c,
			AB.offset(originCF, item.x, lineY - item.h / 2 - 0.3, 5.65), model, "Cloth_" .. i)
		-- Clothespin (tiny brown block)
		AB.block(Vector3.new(0.2, 0.2, 0.2), DARK_WD,
			AB.offset(originCF, item.x, lineY + 0.1, 5.62), model, "Pin_" .. i)
	end

	-- A potted plant on one window sill (basil)
	AB.block(Vector3.new(1.4, 1.2, 1.4), Color3.fromRGB(160, 100, 70),
		AB.offset(originCF, -13, 17.5, 5.95), model, "BasilPot")
	AB.sphere(1.6, Color3.fromRGB(80, 140, 60),
		AB.offset(originCF, -13, 18.7, 5.95), model, "BasilLeaves")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
