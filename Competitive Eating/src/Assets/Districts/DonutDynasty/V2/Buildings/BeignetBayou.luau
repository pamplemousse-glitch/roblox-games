-- BeignetBayou — New Orleans-style French Quarter storefront with
-- a wrought-iron lacework balcony, shutter windows, a green awning,
-- and a neon "BEIGNET" sign in royal pink.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK    = Color3.fromRGB(255, 200, 214)
local DEEP    = Color3.fromRGB(232, 130, 165)
local CREAM   = Color3.fromRGB(255, 240, 220)
local BROWN   = Color3.fromRGB(92,  57,  36)
local GOLD    = Color3.fromRGB(212, 168, 82)
local MINT    = Color3.fromRGB(180, 230, 200)
local NEONPK  = Color3.fromRGB(255, 110, 170)
local IRON    = Color3.fromRGB(50, 50, 60)
local GLASS   = Color3.fromRGB(210, 235, 250)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BeignetBayou", parent)

	-- Foundation
	AB.block(Vector3.new(30, 0.5, 22), Color3.fromRGB(110, 100, 95),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Cream walls (two stories)
	AB.block(Vector3.new(30, 22, 1),  CREAM, AB.offset(originCF, 0,    11, -10.5), model, "BackWall")
	AB.block(Vector3.new(1,  22, 22), CREAM, AB.offset(originCF, -14.5, 11,  0),   model, "LeftWall")
	AB.block(Vector3.new(1,  22, 22), CREAM, AB.offset(originCF,  14.5, 11,  0),   model, "RightWall")
	-- Ground floor front
	AB.block(Vector3.new(9, 10, 1),  CREAM, AB.offset(originCF, -10.5, 5, 10.5), model, "FrontL")
	AB.block(Vector3.new(9, 10, 1),  CREAM, AB.offset(originCF,  10.5, 5, 10.5), model, "FrontR")
	AB.block(Vector3.new(12, 4, 1),  CREAM, AB.offset(originCF,  0,   8,  10.5), model, "FrontHeader")
	-- Second story front (with windows cut by inner panels)
	AB.block(Vector3.new(30, 12, 1), CREAM, AB.offset(originCF, 0,   16, 10.5), model, "UpperFront")

	-- Shutter windows on second story (2x)
	for i, x in {-9, 9} do
		-- Window glass behind shutters
		local g = AB.block(Vector3.new(4, 5, 0.2), GLASS,
			AB.offset(originCF, x, 16, 10.6), model, "Window2nd_" .. i)
		g.Transparency = 0.4
		g.Material = Enum.Material.Glass
		-- Mint shutters
		AB.block(Vector3.new(1.5, 5.2, 0.3), MINT,
			AB.offset(originCF, x - 2.5, 16, 10.7), model, "ShutterL_" .. i)
		AB.block(Vector3.new(1.5, 5.2, 0.3), MINT,
			AB.offset(originCF, x + 2.5, 16, 10.7), model, "ShutterR_" .. i)
		-- Shutter slats
		for j = 1, 5 do
			local sy = 13.8 + (j - 1) * 1
			AB.block(Vector3.new(1.4, 0.1, 0.32), DEEP,
				AB.offset(originCF, x - 2.5, sy, 10.78), model, "SlatL_" .. i .. "_" .. j)
			AB.block(Vector3.new(1.4, 0.1, 0.32), DEEP,
				AB.offset(originCF, x + 2.5, sy, 10.78), model, "SlatR_" .. i .. "_" .. j)
		end
	end

	-- Center door
	local door = AB.block(Vector3.new(4, 8, 0.4), BROWN,
		AB.offset(originCF, 0, 4, 10.7), model, "Door")
	AB.sphere(0.4, GOLD, AB.offset(originCF, 1.4, 4, 11), model, "DoorKnob")

	-- Wrought-iron balcony (lacework) — railing wraps front of second story
	AB.block(Vector3.new(30, 0.4, 4), IRON,
		AB.offset(originCF, 0, 10.5, 13), model, "BalconyFloor")
	-- Vertical iron rails along the front
	for i = 1, 30 do
		local x = -14.5 + (i - 1) * 1
		AB.block(Vector3.new(0.15, 3, 0.15), IRON,
			AB.offset(originCF, x, 12, 14.8), model, "Baluster_" .. i)
	end
	-- Top rail
	AB.block(Vector3.new(30, 0.25, 0.25), IRON,
		AB.offset(originCF, 0, 13.4, 14.8), model, "TopRail")
	-- Decorative scrollwork (rings between balusters)
	for i = 1, 10 do
		local x = -13.5 + (i - 1) * 3
		AB.sphere(0.8, IRON, AB.offset(originCF, x, 12, 14.8), model, "Scroll_" .. i)
	end
	-- Iron support brackets under the balcony
	for i, x in {-13, -7, 0, 7, 13} do
		AB.block(Vector3.new(0.3, 2.5, 1), IRON,
			AB.offset(originCF, x, 9.5, 12.5), model, "Bracket_" .. i)
	end

	-- Green awning (mint) over door
	AB.block(Vector3.new(12, 0.6, 4), MINT,
		AB.offset(originCF, 0, 8.5, 12.5), model, "Awning")
	for i, x in {-4, -1.3, 1.3, 4} do
		AB.block(Vector3.new(1.1, 0.65, 4), CREAM,
			AB.offset(originCF, x, 8.5, 12.5), model, "AwningStripe_" .. i)
	end

	-- Neon "BEIGNET" sign
	local sign = AB.block(Vector3.new(16, 2.2, 0.4), NEONPK,
		AB.offset(originCF, 0, 19, 11), model, "NeonSign")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 3)
	AB.block(Vector3.new(18, 3, 0.3), BROWN,
		AB.offset(originCF, 0, 19, 10.9), model, "SignBacking")

	-- Roof — flat with iron parapet
	AB.block(Vector3.new(32, 1, 24), BROWN,
		AB.offset(originCF, 0, 22.5, 0), model, "Roof")
	for i = 1, 16 do
		local x = -15 + (i - 1) * 2
		AB.block(Vector3.new(0.5, 1, 0.5), IRON,
			AB.offset(originCF, x, 23.5, 11.2), model, "Parapet_" .. i)
	end

	-- Hanging lantern (gold + neon flame)
	AB.block(Vector3.new(0.3, 2, 0.3), IRON,
		AB.offset(originCF, -10, 8.7, 13.2), model, "LanternHookL")
	AB.cylinder(1.2, 1.6, GOLD,
		AB.offset(originCF, -10, 7, 13.2), model, "LanternBodyL")
	local flameL = AB.sphere(0.8, NEONPK, AB.offset(originCF, -10, 7, 13.2), model, "LanternFlameL")
	AB.neon(flameL)
	AB.glow(flameL, NEONPK, 2)
	AB.block(Vector3.new(0.3, 2, 0.3), IRON,
		AB.offset(originCF, 10, 8.7, 13.2), model, "LanternHookR")
	AB.cylinder(1.2, 1.6, GOLD,
		AB.offset(originCF, 10, 7, 13.2), model, "LanternBodyR")
	local flameR = AB.sphere(0.8, NEONPK, AB.offset(originCF, 10, 7, 13.2), model, "LanternFlameR")
	AB.neon(flameR)
	AB.glow(flameR, NEONPK, 2)

	-- Powdered sugar puffs (beignet display) in side window
	for i = 1, 4 do
		local x = -13.8
		local z = -3 + (i - 1) * 2
		AB.block(Vector3.new(0.6, 0.6, 0.6), CREAM,
			AB.offset(originCF, x, 4, z), model, "Beignet_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
