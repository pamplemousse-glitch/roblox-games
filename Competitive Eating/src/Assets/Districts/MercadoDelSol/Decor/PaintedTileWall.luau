-- Painted Tile Wall — decorative talavera-tile wall section with a 6x4 mosaic
-- pattern, scalloped terracotta cap, wooden base trim, and a central painted
-- floral medallion.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local BOUG_PINK    = Color3.fromRGB(220, 80, 140)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local CREAM        = Color3.fromRGB(245, 230, 200)
local TILE_AZURE   = Color3.fromRGB(60, 130, 200)
local TILE_RUST    = Color3.fromRGB(180, 80, 50)
local LEAF_GREEN   = Color3.fromRGB(75, 145, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PaintedTileWall", parent)

	-- Cream stucco backing wall
	local backing = AB.block(Vector3.new(10, 6, 0.6), CREAM,
		AB.offset(originCF, 0, 3, 0), model, "Backing")

	-- Tile mosaic grid 6 cols × 4 rows
	-- Wall area for tiles: width 9, height 4.5, centered
	-- Each tile ~1.4 wide × 1.05 tall
	local cols, rows = 6, 4
	local tileW, tileH = 1.4, 1.05
	local startX = -(cols - 1) * (tileW + 0.05) / 2
	local startY = 1.6
	for row = 1, rows do
		for col = 1, cols do
			local x = startX + (col - 1) * (tileW + 0.05)
			local y = startY + (row - 1) * (tileH + 0.05)
			local isCenter = (col == 3 or col == 4) and (row == 2 or row == 3)
			local zOffset = isCenter and 0.4 or 0.35

			-- Determine pattern color
			local color
			local checker = (row + col) % 2 == 0
			if isCenter then
				color = CREAM
			elseif row == 1 and col == cols then
				color = FIESTA_YEL
			elseif row == rows and col == 1 then
				color = FIESTA_YEL
			elseif col == 1 or col == cols then
				color = checker and TILE_AZURE or AGAVE_TEAL
			elseif row == 1 or row == rows then
				color = checker and BOUG_PINK or TILE_AZURE
			else
				color = checker and TILE_AZURE or CREAM
			end

			AB.block(Vector3.new(tileW, tileH, 0.15), color,
				AB.offset(originCF, x, y, zOffset), model,
				string.format("Tile_%d_%d", row, col))

			-- Cream tiles get a rust stripe across them
			if color == CREAM and not isCenter then
				AB.block(Vector3.new(tileW, 0.18, 0.06), TILE_RUST,
					AB.offset(originCF, x, y, zOffset + 0.06), model,
					string.format("Stripe_%d_%d", row, col))
			end
		end
	end

	-- Top scalloped terracotta cap (5 small blocks)
	for i = 1, 5 do
		local x = -4 + (i - 1) * 2
		AB.block(Vector3.new(1.8, 0.6, 1), TERRACOTTA,
			AB.offset(originCF, x, 6.3, 0.2), model, "ScallopBase_" .. i)
		AB.cylinder(0.9, 1.1, TERRACOTTA,
			AB.offset(originCF, x, 6.7, 0.2)
				* CFrame.Angles(math.rad(90), 0, 0), model, "ScallopTop_" .. i)
	end

	-- Bottom wooden base trim
	AB.block(Vector3.new(10.4, 0.7, 0.9), WOOD_DARK,
		AB.offset(originCF, 0, 0.35, 0.15), model, "BaseTrim")
	-- Trim accent line
	AB.block(Vector3.new(10.4, 0.15, 0.95), TERRACOTTA,
		AB.offset(originCF, 0, 0.7, 0.18), model, "TrimAccent")

	-- Central painted bird/flower medallion (4-5 accent blocks forming stylized motif)
	-- Center petal cluster
	local centerY = 3.15
	local centerZ = 0.5
	-- Center disc
	AB.cylinder(1.2, 0.1, FIESTA_YEL,
		AB.offset(originCF, 0, centerY, centerZ)
			* CFrame.Angles(math.rad(90), 0, 0), model, "MedallionCenter")
	-- Make medallion center neon for night visibility
	local medCenter = model:FindFirstChild("MedallionCenter") :: BasePart
	if medCenter then
		AB.neon(medCenter)
		AB.glow(medCenter, FIESTA_YEL, 1.5)
	end
	-- Four petals around it
	for i = 1, 4 do
		local angle = (i - 1) * math.pi / 2
		local px = math.cos(angle) * 0.7
		local py = math.sin(angle) * 0.7
		AB.sphere(0.55, BOUG_PINK,
			AB.offset(originCF, px, centerY + py, centerZ), model, "Petal_" .. i)
	end
	-- Tiny leaves at diagonals
	for i = 1, 4 do
		local angle = (i - 1) * math.pi / 2 + math.pi / 4
		local px = math.cos(angle) * 0.85
		local py = math.sin(angle) * 0.85
		AB.block(Vector3.new(0.4, 0.25, 0.08), LEAF_GREEN,
			AB.offset(originCF, px, centerY + py, centerZ - 0.02, math.deg(angle) + 90),
			model, "Leaf_" .. i)
	end
	-- Center dot
	AB.sphere(0.3, TILE_RUST,
		AB.offset(originCF, 0, centerY, centerZ + 0.05), model, "MedallionDot")

	-- Side decorative motif dots (small accent tiles)
	for i, side in {-1, 1} do
		AB.sphere(0.25, BOUG_PINK,
			AB.offset(originCF, side * 3.8, 3.15, 0.45), model, "SideDot_" .. i)
	end

	AB.pivot(model, backing)
	AB.weldAll(model)
	return model
end
