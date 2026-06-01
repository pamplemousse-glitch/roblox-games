-- Ramen Shop — small wood + paper-screen storefront with a red noren curtain
-- across the doorway and a glowing yellow lantern sign.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION   = Color3.fromRGB(200, 50, 40)
local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RamenShop", parent)

	-- Foundation
	AB.block(Vector3.new(28, 0.4, 22), Color3.fromRGB(100, 100, 100),
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")

	-- Back wall (warm wood)
	AB.block(Vector3.new(28, 14, 1), WARM_WOOD,
		AB.offset(originCF, 0, 7, -10.5), model, "BackWall")

	-- Side walls
	AB.block(Vector3.new(1, 14, 22), WARM_WOOD, AB.offset(originCF, -13.5, 7, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 14, 22), WARM_WOOD, AB.offset(originCF,  13.5, 7, 0), model, "RightWall")

	-- Front facade with central doorway gap (gap is 8 studs wide)
	AB.block(Vector3.new(10, 14, 1), WARM_WOOD, AB.offset(originCF, -9, 7, 10.5), model, "FrontLeft")
	AB.block(Vector3.new(10, 14, 1), WARM_WOOD, AB.offset(originCF,  9, 7, 10.5), model, "FrontRight")
	AB.block(Vector3.new(8, 3, 1),   WARM_WOOD, AB.offset(originCF, 0, 12.5, 10.5), model, "FrontHeader")

	-- Paper-screen shoji windows (two on front)
	for i, x in {-9, 9} do
		AB.block(Vector3.new(4.5, 4, 0.6), PAPER_WHITE,
			AB.offset(originCF, x, 6, 10.7), model, "Shoji_" .. i)
		-- Wood grid (vertical mullion)
		AB.block(Vector3.new(0.15, 4, 0.7), DARK_WOOD,
			AB.offset(originCF, x, 6, 10.8), model, "ShojiMullionV_" .. i)
		-- Wood grid (horizontal mullion)
		AB.block(Vector3.new(4.5, 0.15, 0.7), DARK_WOOD,
			AB.offset(originCF, x, 6, 10.8), model, "ShojiMullionH_" .. i)
	end

	-- Red noren curtain across the doorway (3 vertical panels)
	for i, x in {-2.5, 0, 2.5} do
		AB.block(Vector3.new(2.2, 3, 0.2), VERMILION,
			AB.offset(originCF, x, 9.5, 11.1), model, "Noren_" .. i)
	end
	-- Noren top rod
	AB.block(Vector3.new(8.4, 0.3, 0.4), DARK_WOOD,
		AB.offset(originCF, 0, 11.1, 11.1), model, "NorenRod")

	-- Glowing lantern sign hanging above the doorway
	local lantern = AB.cylinder(2.4, 3.2, LANTERN_Y,
		AB.offset(originCF, 0, 15.5, 11.4), model, "Lantern")
	AB.neon(lantern)
	AB.glow(lantern, lantern.Color, 2.5)
	-- Vermilion ribbon stripes around the lantern
	for i, y in {14.6, 16.4} do
		AB.cylinder(2.45, 0.25, VERMILION,
			AB.offset(originCF, 0, y, 11.4), model, "LanternStripe_" .. i)
	end
	-- Tassel rope to roof
	AB.block(Vector3.new(0.12, 1.5, 0.12), DARK_WOOD,
		AB.offset(originCF, 0, 17.5, 11.4), model, "LanternRope")

	-- Pitched tile-style roof
	AB.block(Vector3.new(30, 1, 24), VERMILION,
		AB.offset(originCF, 0, 14.5, 0), model, "Roof")
	-- Upturned eaves (a hint of pagoda overhang)
	for i, z in {-12.5, 12.5} do
		AB.block(Vector3.new(30, 0.6, 1.5), DARK_WOOD,
			AB.offset(originCF, 0, 14.2, z), model, "Eave_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
