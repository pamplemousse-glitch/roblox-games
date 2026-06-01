-- Mamma Carmela's Trattoria — rustic stucco trattoria, vine-covered walls,
-- amber-glow windows, red terra-cotta tile roof, hanging hand-painted sign.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STUCCO    = Color3.fromRGB(240, 220, 180)
local VINE      = Color3.fromRGB(80, 140, 60)
local LEAF      = Color3.fromRGB(120, 180, 80)
local TILE_RED  = Color3.fromRGB(170, 80, 60)
local AMBER     = Color3.fromRGB(255, 195, 100)
local DARK_WD   = Color3.fromRGB(80, 50, 30)
local TRIM      = Color3.fromRGB(110, 30, 40)
local WIN_FRM   = Color3.fromRGB(60, 35, 20)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MammaCarmelasTrattoria", parent)

	-- Foundation (cobblestone)
	AB.block(Vector3.new(32, 0.5, 24), Color3.fromRGB(110, 105, 100),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Walls (warm stucco)
	AB.block(Vector3.new(32, 16, 1), STUCCO, AB.offset(originCF, 0, 8, -11.5), model, "BackWall")
	AB.block(Vector3.new(1, 16, 24), STUCCO, AB.offset(originCF, -15.5, 8, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 16, 24), STUCCO, AB.offset(originCF,  15.5, 8, 0), model, "RightWall")
	-- Front facade in segments (door + windows)
	AB.block(Vector3.new(8, 16, 1), STUCCO, AB.offset(originCF, -12, 8, 11.5), model, "FrontFarL")
	AB.block(Vector3.new(8, 16, 1), STUCCO, AB.offset(originCF,  12, 8, 11.5), model, "FrontFarR")
	AB.block(Vector3.new(4, 6, 1), STUCCO, AB.offset(originCF, -6, 13, 11.5), model, "FrontWinAboveL")
	AB.block(Vector3.new(4, 6, 1), STUCCO, AB.offset(originCF,  6, 13, 11.5), model, "FrontWinAboveR")
	AB.block(Vector3.new(4, 2, 1), STUCCO, AB.offset(originCF, -6, 3, 11.5), model, "FrontWinBelowL")
	AB.block(Vector3.new(4, 2, 1), STUCCO, AB.offset(originCF,  6, 3, 11.5), model, "FrontWinBelowR")
	AB.block(Vector3.new(6, 4, 1), STUCCO, AB.offset(originCF, 0, 14, 11.5), model, "FrontHeader")

	-- Amber-glow windows (neon)
	for i, x in {-6, 6} do
		local w = AB.block(Vector3.new(4, 5, 0.3), AMBER, AB.offset(originCF, x, 7.5, 11.6), model, "Window_" .. i)
		AB.neon(w)
		AB.glow(w, w.Color, 1.8)
		-- Wooden shutters (open)
		AB.block(Vector3.new(1.2, 5, 0.3), WIN_FRM, AB.offset(originCF, x - 2.8, 7.5, 11.7), model, "ShutterL_" .. i)
		AB.block(Vector3.new(1.2, 5, 0.3), WIN_FRM, AB.offset(originCF, x + 2.8, 7.5, 11.7), model, "ShutterR_" .. i)
		-- Window frame
		AB.block(Vector3.new(4.4, 0.3, 0.5), WIN_FRM, AB.offset(originCF, x, 5, 11.7), model, "WinSill_" .. i)
		AB.block(Vector3.new(4.4, 0.3, 0.5), WIN_FRM, AB.offset(originCF, x, 10, 11.7), model, "WinTop_" .. i)
		-- Flower box under window
		AB.block(Vector3.new(4, 0.8, 0.8), DARK_WD, AB.offset(originCF, x, 4.5, 12.1), model, "FlowerBox_" .. i)
		AB.sphere(0.6, Color3.fromRGB(220, 60, 80), AB.offset(originCF, x - 1.2, 5.1, 12.1), model, "Geranium1_" .. i)
		AB.sphere(0.6, Color3.fromRGB(220, 60, 80), AB.offset(originCF, x + 1.2, 5.1, 12.1), model, "Geranium2_" .. i)
		AB.sphere(0.6, Color3.fromRGB(220, 60, 80), AB.offset(originCF, x,       5.1, 12.1), model, "Geranium3_" .. i)
	end

	-- Arched door (dark wood)
	AB.block(Vector3.new(4, 7, 1), DARK_WD, AB.offset(originCF, 0, 3.5, 11.5), model, "DoorBody")
	AB.block(Vector3.new(4.5, 0.5, 1), DARK_WD, AB.offset(originCF, 0, 7, 11.5), model, "DoorTop")
	AB.sphere(2, DARK_WD, AB.offset(originCF, 0, 7, 11.5), model, "DoorArch")
	AB.sphere(0.3, AB.colors.cheese, AB.offset(originCF, 1.5, 3.5, 11.8), model, "DoorHandle")

	-- Hanging hand-painted sign (carved wood)
	AB.block(Vector3.new(0.4, 3, 0.4), DARK_WD, AB.offset(originCF, 0, 15.5, 13.5), model, "SignPost")
	AB.block(Vector3.new(8, 2.5, 0.6), AMBER, AB.offset(originCF, 0, 12.5, 13.5), model, "SignBoard")
	AB.block(Vector3.new(8.4, 0.4, 0.8), DARK_WD, AB.offset(originCF, 0, 13.8, 13.5), model, "SignFrameTop")
	AB.block(Vector3.new(8.4, 0.4, 0.8), DARK_WD, AB.offset(originCF, 0, 11.2, 13.5), model, "SignFrameBot")
	-- Sign chains
	AB.block(Vector3.new(0.2, 1, 0.2), Color3.fromRGB(80, 70, 60), AB.offset(originCF, -3.8, 14.2, 13.5), model, "ChainL")
	AB.block(Vector3.new(0.2, 1, 0.2), Color3.fromRGB(80, 70, 60), AB.offset(originCF,  3.8, 14.2, 13.5), model, "ChainR")

	-- Terra-cotta tile roof (sloped via two wedges + cap)
	AB.block(Vector3.new(34, 1, 26), TILE_RED, AB.offset(originCF, 0, 16.5, 0), model, "RoofBase")
	for i, z in {-9, -3, 3, 9} do
		AB.cylinder(0.8, 34, TILE_RED, AB.offset(originCF, 0, 17.1, z), model, "TileRow_" .. i)
	end
	-- Roof ridge
	AB.block(Vector3.new(34, 0.8, 1.2), TRIM, AB.offset(originCF, 0, 17.5, 0), model, "RoofRidge")

	-- Vine on left wall (climbing up)
	for i = 1, 6 do
		AB.cylinder(0.3, 2.2, VINE, AB.offset(originCF, -15.2, 4 + i * 2, -4 + i * 2.2), model, "Vine_" .. i)
	end
	-- Vine leaves (scatter)
	for i = 1, 14 do
		local x = -15 + math.random() * 1
		local y = 3 + math.random() * 12
		local z = -10 + math.random() * 20
		AB.sphere(0.7, LEAF, AB.offset(originCF, x, y, z), model, "Leaf_" .. i)
	end

	-- Chimney
	AB.block(Vector3.new(2.6, 4, 2.6), STUCCO, AB.offset(originCF, -10, 19, -7), model, "Chimney")
	AB.block(Vector3.new(3, 0.4, 3), TILE_RED, AB.offset(originCF, -10, 21.2, -7), model, "ChimneyCap")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
