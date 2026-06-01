-- Mercado Canopy — open-air market: tile floor, support pillars, multi-color
-- papel picado banners hanging in rows above.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local TILE_CREAM   = Color3.fromRGB(230, 215, 180)
local TILE_RED     = Color3.fromRGB(170, 75, 55)
local POST_WOOD    = Color3.fromRGB(105, 70, 40)

local BANNER_COLORS = {FIESTA_YEL, PAPEL_GREEN, AGAVE_TEAL, TERRACOTTA, Color3.fromRGB(220, 90, 130)}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MercadoCanopy", parent)

	-- Tile floor (24x24, checker pattern)
	local tilesPerSide = 6
	local tileSize = 4
	for ix = 0, tilesPerSide - 1 do
		for iz = 0, tilesPerSide - 1 do
			local x = (ix - (tilesPerSide - 1) / 2) * tileSize
			local z = (iz - (tilesPerSide - 1) / 2) * tileSize
			local checker = (ix + iz) % 2 == 0
			AB.block(
				Vector3.new(tileSize, 0.3, tileSize),
				checker and TILE_CREAM or TILE_RED,
				AB.offset(originCF, x, 0.15, z),
				model,
				string.format("Tile_%d_%d", ix, iz)
			)
		end
	end

	-- Support pillars at corners + midpoints
	for i, pos in {
		Vector3.new(-12, 0, -12), Vector3.new( 12, 0, -12),
		Vector3.new(-12, 0,  12), Vector3.new( 12, 0,  12),
		Vector3.new(  0, 0, -12), Vector3.new(  0, 0,  12),
	} do
		AB.block(Vector3.new(1.2, 14, 1.2), POST_WOOD,
			AB.offset(originCF, pos.X, 7, pos.Z), model, "Pillar_" .. i)
		-- Decorative top cap
		AB.block(Vector3.new(1.8, 0.4, 1.8), TERRACOTTA,
			AB.offset(originCF, pos.X, 14, pos.Z), model, "PillarCap_" .. i)
	end

	-- Cross beams between pillars (rough open-air pergola)
	for i, z in {-12, 0, 12} do
		AB.block(Vector3.new(26, 0.4, 0.6), POST_WOOD,
			AB.offset(originCF, 0, 14.2, z), model, "BeamX_" .. i)
	end
	AB.block(Vector3.new(0.6, 0.4, 26), POST_WOOD,
		AB.offset(originCF, -12, 14.2, 0), model, "BeamZ_L")
	AB.block(Vector3.new(0.6, 0.4, 26), POST_WOOD,
		AB.offset(originCF,  12, 14.2, 0), model, "BeamZ_R")

	-- Papel picado banners — rows of small colorful flags hanging from beams
	-- Two strings stretched between front and back beams, each ~10 flags long
	for row, zRow in {-6, 6} do
		for i = 1, 10 do
			local x = -11 + (i - 1) * 2.4
			local color = BANNER_COLORS[((i - 1) % #BANNER_COLORS) + 1]
			-- Flag: thin square hanging just under the beam line
			AB.part({
				size  = Vector3.new(1.8, 1.6, 0.05),
				color = color,
				cf    = AB.offset(originCF, x, 13.0, zRow),
				name  = string.format("PapelFlag_%d_%d", row, i),
			}, model)
			-- Cutout dots (small black holes by tiny dark squares overlaid)
			AB.part({
				size  = Vector3.new(0.3, 0.3, 0.06),
				color = Color3.fromRGB(30, 30, 30),
				cf    = AB.offset(originCF, x, 13.0, zRow - 0.04),
				name  = string.format("PapelDot_%d_%d", row, i),
			}, model)
		end
		-- The string (a thin dark line spanning the row)
		AB.block(Vector3.new(22, 0.06, 0.06), Color3.fromRGB(40, 40, 40),
			AB.offset(originCF, 0, 13.9, zRow), model, "Twine_" .. row)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
