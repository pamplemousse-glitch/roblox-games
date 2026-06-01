-- White Tile Alley Marking — ground tile inlay decor: a runway of white tiles
-- bordered by dark grout lines + sparse vermilion tile accents. Lays flat.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TILE_WHITE  = Color3.fromRGB(240, 235, 220)
local TILE_DARK   = Color3.fromRGB(70, 70, 75)
local GROUT       = Color3.fromRGB(50, 50, 55)
local VERMILION   = Color3.fromRGB(200, 50, 40)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WhiteTileAlleyMarking", parent)

	-- Outer dark border strip
	AB.block(Vector3.new(20, 0.15, 5), TILE_DARK,
		AB.offset(originCF, 0, 0.08, 0), model, "Border")

	-- Inner white tile field — 10x4 grid of small tiles separated by thin grout
	for col = 0, 9 do
		for row = 0, 3 do
			local x = -9 + col * 2
			local z = -1.5 + row * 1
			local tileColor = TILE_WHITE
			-- Sparse vermilion accent tiles
			if (col == 2 and row == 1) or (col == 5 and row == 2) or (col == 7 and row == 0) then
				tileColor = VERMILION
			end
			AB.block(Vector3.new(1.85, 0.2, 0.85), tileColor,
				AB.offset(originCF, x, 0.18, z), model, "Tile_" .. col .. "_" .. row)
		end
	end

	-- Grout lines (horizontal)
	for row = 0, 4 do
		local z = -2 + row * 1
		AB.block(Vector3.new(20.1, 0.21, 0.1), GROUT,
			AB.offset(originCF, 0, 0.18, z), model, "GroutH_" .. row)
	end
	-- Grout lines (vertical)
	for col = 0, 10 do
		local x = -10 + col * 2
		AB.block(Vector3.new(0.1, 0.21, 5.1), GROUT,
			AB.offset(originCF, x, 0.18, 0), model, "GroutV_" .. col)
	end

	-- Center glowing arrow accent (3 small yellow neon arrow segments)
	for i, x in {-2, 0, 2} do
		local arrow = AB.block(Vector3.new(1.2, 0.22, 0.3), LANTERN_Y,
			AB.offset(originCF, x, 0.3, 0), model, "ArrowSeg_" .. i)
		AB.neon(arrow)
	end
	-- Arrow tip (vermilion wedge)
	AB.wedge(Vector3.new(0.6, 0.22, 0.8), VERMILION,
		AB.offset(originCF, 3.4, 0.32, 0) * CFrame.Angles(0, math.rad(-90), 0),
		model, "ArrowTip")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
