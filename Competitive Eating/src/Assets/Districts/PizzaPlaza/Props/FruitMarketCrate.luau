-- Fruit Market Crate — wooden crate stacked with bright fresh fruit
-- (tomatoes, lemons, eggplant, oranges), price sign on the front.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CRATE_WD  = Color3.fromRGB(160, 120, 75)
local DK_WD     = Color3.fromRGB(80, 50, 30)
local TOMATO    = Color3.fromRGB(220, 60, 50)
local LEMON     = Color3.fromRGB(240, 220, 80)
local ORANGE    = Color3.fromRGB(240, 150, 60)
local EGGPLANT  = Color3.fromRGB(80, 40, 100)
local SIGN_CR   = Color3.fromRGB(245, 230, 200)
local SIGN_TXT  = Color3.fromRGB(110, 30, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("FruitMarketCrate", parent)

	-- Crate body — slatted wood look (top open)
	-- Floor
	AB.block(Vector3.new(4, 0.3, 4), DK_WD, AB.offset(originCF, 0, 1.5, 0), model, "CrateFloor")
	-- Side slats
	for i, sx in {-1, 1} do
		for k, y in {2, 3, 4} do
			AB.block(Vector3.new(0.2, 0.6, 4), CRATE_WD, AB.offset(originCF, sx * 2, y, 0), model, "SideSlat_" .. i .. "_" .. k)
		end
	end
	for i, sz in {-1, 1} do
		for k, y in {2, 3, 4} do
			AB.block(Vector3.new(4, 0.6, 0.2), CRATE_WD, AB.offset(originCF, 0, y, sz * 2), model, "EndSlat_" .. i .. "_" .. k)
		end
	end
	-- Corner posts
	for i, sx in {-1, 1} do
		for j, sz in {-1, 1} do
			AB.block(Vector3.new(0.4, 3.5, 0.4), DK_WD,
				AB.offset(originCF, sx * 2, 3, sz * 2), model, "Post_" .. i .. j)
		end
	end

	-- Tomatoes (red sphere pile)
	for i = 1, 8 do
		local x = (math.random() - 0.5) * 2.6
		local z = (math.random() - 0.5) * 2.6
		local y = 4.5 + math.random() * 0.5
		AB.sphere(0.7 + math.random() * 0.2, TOMATO, AB.offset(originCF, x - 0.8, y, z), model, "Tomato_" .. i)
	end
	-- Lemons (cluster on one side)
	for i = 1, 5 do
		AB.sphere(0.55, LEMON,
			AB.offset(originCF, 1 + (i - 3) * 0.5, 4.7, 1.2 - i * 0.3), model, "Lemon_" .. i)
	end
	-- Oranges
	for i = 1, 4 do
		AB.sphere(0.6, ORANGE,
			AB.offset(originCF, 0.5 + (i - 2) * 0.6, 4.4, -1.3), model, "Orange_" .. i)
	end
	-- Eggplant (purple ovoids)
	AB.sphere(1.0, EGGPLANT, AB.offset(originCF, -1.2, 4.7, -0.8), model, "Eggplant1")
	AB.sphere(0.9, EGGPLANT, AB.offset(originCF, -1.5, 4.7,  0.5), model, "Eggplant2")
	-- Eggplant stems (green spheres)
	AB.sphere(0.2, Color3.fromRGB(80, 140, 60), AB.offset(originCF, -1.2, 5.5, -0.8), model, "EggStem1")
	AB.sphere(0.2, Color3.fromRGB(80, 140, 60), AB.offset(originCF, -1.5, 5.5,  0.5), model, "EggStem2")

	-- Price sign on the front (chalkboard style)
	AB.block(Vector3.new(2.4, 1.4, 0.2), SIGN_CR, AB.offset(originCF, 0, 5.5, 2.15), model, "PriceSign")
	AB.block(Vector3.new(2.6, 0.25, 0.3), DK_WD, AB.offset(originCF, 0, 6.2, 2.2), model, "PriceFrameTop")
	AB.block(Vector3.new(2.6, 0.25, 0.3), DK_WD, AB.offset(originCF, 0, 4.8, 2.2), model, "PriceFrameBot")
	-- "€1" scribble
	AB.block(Vector3.new(1.5, 0.3, 0.05), SIGN_TXT, AB.offset(originCF, 0, 5.5, 2.27), model, "PriceText")
	-- Tag string + clip
	AB.block(Vector3.new(0.1, 1.2, 0.1), DK_WD, AB.offset(originCF, 0, 6.8, 2.15), model, "PriceString")

	-- Burlap sack leaning beside crate
	AB.block(Vector3.new(1.4, 1.6, 1.2), Color3.fromRGB(180, 155, 110),
		AB.offset(originCF, 3, 0.8, 0), model, "BurlapSack")
	AB.sphere(0.4, Color3.fromRGB(150, 110, 60),
		AB.offset(originCF, 3, 1.7, 0), model, "SackTop")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
