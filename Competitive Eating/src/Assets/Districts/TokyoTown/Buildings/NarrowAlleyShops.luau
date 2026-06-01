-- Narrow Alley Shops — backdrop strip of 4 tiny tightly-packed shop fronts.
-- Each ~6 studs wide, alternating warm wood + dark wood + bamboo green facades,
-- with shoji windows + small noren + a vertical neon plaque.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION   = Color3.fromRGB(200, 50, 40)
local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local BAMBOO      = Color3.fromRGB(140, 180, 100)
local STONE       = Color3.fromRGB(120, 115, 105)
local TEAL        = Color3.fromRGB(60, 130, 130)
local INDIGO      = Color3.fromRGB(60, 60, 110)

local SHOP_BG = {WARM_WOOD, DARK_WOOD, TEAL, INDIGO}
local PLAQUE  = {VERMILION, LANTERN_Y, PAPER_WHITE, VERMILION}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("NarrowAlleyShops", parent)

	-- Stone strip foundation
	AB.block(Vector3.new(28, 0.4, 10), STONE,
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")

	-- Common back wall
	AB.block(Vector3.new(28, 12, 1), DARK_WOOD,
		AB.offset(originCF, 0, 6, -4.5), model, "BackWall")
	-- Side walls
	AB.block(Vector3.new(1, 12, 10), DARK_WOOD, AB.offset(originCF, -13.5, 6, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 12, 10), DARK_WOOD, AB.offset(originCF,  13.5, 6, 0), model, "RightWall")

	-- 4 narrow shop fronts (centers 7 apart, each 6 wide)
	for i = 1, 4 do
		local cx = (i - 2.5) * 7
		local bg = SHOP_BG[i]
		local plq = PLAQUE[i]

		-- Facade panel
		AB.block(Vector3.new(6.5, 12, 0.6), bg,
			AB.offset(originCF, cx, 6, 4.5), model, "Shop_" .. i .. "_Facade")
		-- Dividing dark wood post (right side of each shop)
		AB.block(Vector3.new(0.5, 12, 0.7), DARK_WOOD,
			AB.offset(originCF, cx + 3.25, 6, 4.55), model, "Shop_" .. i .. "_Divider")

		-- Doorway (a darker rectangle)
		AB.block(Vector3.new(2.5, 7, 0.3), Color3.fromRGB(30, 25, 25),
			AB.offset(originCF, cx, 3.5, 4.7), model, "Shop_" .. i .. "_Door")
		-- Doorway frame
		AB.block(Vector3.new(2.8, 0.3, 0.4), DARK_WOOD, AB.offset(originCF, cx, 7.1, 4.75), model, "Shop_" .. i .. "_DoorTop")

		-- Mini noren over doorway (2 panels)
		for j, dx in {-0.6, 0.6} do
			AB.block(Vector3.new(1.0, 1.4, 0.15), VERMILION,
				AB.offset(originCF, cx + dx, 7.6, 4.85), model, "Shop_" .. i .. "_Noren_" .. j)
		end

		-- Small shoji window above door
		AB.block(Vector3.new(2.5, 2, 0.4), PAPER_WHITE,
			AB.offset(originCF, cx, 10, 4.75), model, "Shop_" .. i .. "_Window")
		AB.block(Vector3.new(0.15, 2, 0.5), DARK_WOOD, AB.offset(originCF, cx, 10, 4.85), model, "Shop_" .. i .. "_WinMull")

		-- Vertical neon plaque on right side of facade
		local plaque = AB.block(Vector3.new(0.4, 4, 1), plq,
			AB.offset(originCF, cx + 2.8, 5, 4.85), model, "Shop_" .. i .. "_Plaque")
		AB.neon(plaque)
		AB.glow(plaque, plq, 1.5)
		AB.block(Vector3.new(0.45, 4.3, 1.2), DARK_WOOD,
			AB.offset(originCF, cx + 2.8, 5, 4.85), model, "Shop_" .. i .. "_PlaqueBorder")

		-- Small awning over each shop
		AB.block(Vector3.new(6.5, 0.3, 1.5), VERMILION,
			AB.offset(originCF, cx, 8.4, 5.25), model, "Shop_" .. i .. "_Awning")
		-- Awning trim
		AB.block(Vector3.new(6.5, 0.35, 0.2), PAPER_WHITE,
			AB.offset(originCF, cx, 8.4, 5.95), model, "Shop_" .. i .. "_AwningTrim")
	end

	-- Shared sloped roof above all
	AB.block(Vector3.new(30, 1, 12), DARK_WOOD,
		AB.offset(originCF, 0, 12.4, 0), model, "Roof")
	AB.block(Vector3.new(30, 0.3, 1), VERMILION,
		AB.offset(originCF, 0, 13.0, 0), model, "RoofRidge")
	-- Roof tile lines
	for i = -3, 3 do
		AB.block(Vector3.new(0.15, 0.3, 12.1), Color3.fromRGB(50, 35, 25),
			AB.offset(originCF, i * 4, 13.0, 0), model, "RoofTile_" .. (i + 4))
	end

	-- A few small potted bamboo plants in front of the shops
	for i, x in {-10, -3, 3, 10} do
		AB.block(Vector3.new(1.2, 0.8, 1.2), DARK_WOOD,
			AB.offset(originCF, x, 0.9, 5.6), model, "Pot_" .. i)
		AB.cylinder(0.4, 2.5, BAMBOO,
			AB.offset(originCF, x, 2.5, 5.6), model, "PottedBamboo_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
