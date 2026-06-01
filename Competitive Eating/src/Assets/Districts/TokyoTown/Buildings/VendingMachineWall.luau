-- Vending Machine Wall — a side-street backdrop: row of colorful vending
-- machines under a tin awning, against a graffiti-style stucco wall. Each
-- machine has a glowing display window + product columns + coin slot.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STUCCO      = Color3.fromRGB(140, 130, 120)
local DARK_METAL  = Color3.fromRGB(55, 55, 65)
local TIN_GREY    = Color3.fromRGB(120, 120, 130)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local STONE       = Color3.fromRGB(120, 115, 105)
local VERMILION   = Color3.fromRGB(200, 50, 40)

local MACHINE_COLORS = {
	Color3.fromRGB(50, 130, 200),   -- blue
	Color3.fromRGB(220, 50, 60),    -- red Coke-style
	Color3.fromRGB(40, 160, 80),    -- green
	Color3.fromRGB(240, 180, 40),   -- yellow
	Color3.fromRGB(150, 80, 180),   -- purple
	Color3.fromRGB(60, 60, 70),     -- dark / cigarette style
}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("VendingMachineWall", parent)

	-- Stone foundation strip
	AB.block(Vector3.new(38, 0.4, 8), STONE,
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")

	-- Stucco back wall (tall, weathered)
	AB.block(Vector3.new(38, 14, 1), STUCCO,
		AB.offset(originCF, 0, 7, -3.5), model, "BackWall")
	-- Wall stain strips
	for i, x in {-15, -5, 5, 15} do
		AB.block(Vector3.new(0.4, 14, 1.05), Color3.fromRGB(100, 90, 80),
			AB.offset(originCF, x, 7, -3.5), model, "WallStain_" .. i)
	end

	-- Side walls (short — for depth feel)
	AB.block(Vector3.new(1, 14, 8), STUCCO, AB.offset(originCF, -18.5, 7, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 14, 8), STUCCO, AB.offset(originCF,  18.5, 7, 0), model, "RightWall")

	-- Tin corrugated awning over machines
	AB.block(Vector3.new(38, 0.4, 5), TIN_GREY,
		AB.offset(originCF, 0, 10, 0), model, "Awning")
	-- Corrugation ridges
	for i = -18, 18, 1 do
		AB.block(Vector3.new(0.3, 0.5, 5.05), DARK_METAL,
			AB.offset(originCF, i, 10.2, 0), model, "AwningRidge_" .. (i + 18))
	end
	-- Awning struts
	for i, x in {-17, -5, 5, 17} do
		AB.cylinder(0.4, 3, DARK_METAL,
			AB.offset(originCF, x, 11.5, 0), model, "AwningStrut_" .. i)
	end

	-- 6 vending machines in a row (centers 6 studs apart)
	for i = 1, 6 do
		local x = (i - 3.5) * 6
		local color = MACHINE_COLORS[i]
		-- Body
		AB.block(Vector3.new(5, 9, 3), color,
			AB.offset(originCF, x, 5, 0), model, "Machine_" .. i)
		-- Window (top half)
		local window = AB.block(Vector3.new(4, 4, 0.3), PAPER_WHITE,
			AB.offset(originCF, x, 7, 1.55), model, "MachineWin_" .. i)
		AB.neon(window)
		AB.glow(window, PAPER_WHITE, 1.5)
		-- Product columns inside window (4 small slots)
		for j = 1, 4 do
			AB.block(Vector3.new(0.7, 3.4, 0.4), color,
				AB.offset(originCF, x - 1.3 + (j - 1) * 0.8, 7, 1.65), model, "Slot_" .. i .. "_" .. j)
		end
		-- Bottom controls panel (darker)
		AB.block(Vector3.new(4.5, 3.5, 0.4), DARK_METAL,
			AB.offset(originCF, x, 3.5, 1.55), model, "MachinePanel_" .. i)
		-- Coin slot (small black rectangle)
		AB.block(Vector3.new(0.4, 0.3, 0.45), IRON_BLACK,
			AB.offset(originCF, x + 1.6, 4.5, 1.65), model, "CoinSlot_" .. i)
		-- Item dispense slot (wider black rectangle near base)
		AB.block(Vector3.new(2, 0.6, 0.45), IRON_BLACK,
			AB.offset(originCF, x, 2, 1.65), model, "DispenseSlot_" .. i)
		-- Brand sign on top of machine (small neon)
		local brand = AB.block(Vector3.new(3, 0.6, 0.4), LANTERN_Y,
			AB.offset(originCF, x, 9.2, 1.55), model, "MachineBrand_" .. i)
		AB.neon(brand)
		AB.glow(brand, LANTERN_Y, 1.2)
	end

	-- Hanging string lights between awning struts
	for i = 1, 7 do
		local x = -18 + (i - 1) * 6
		local bulb = AB.sphere(0.45, LANTERN_Y,
			AB.offset(originCF, x, 9.5, 0), model, "StringBulb_" .. i)
		AB.neon(bulb)
		AB.glow(bulb, LANTERN_Y, 1.2)
		-- Tiny cord
		AB.block(Vector3.new(0.05, 0.4, 0.05), DARK_METAL,
			AB.offset(originCF, x, 9.9, 0), model, "BulbCord_" .. i)
	end

	-- Vermilion graffiti tag on stucco
	local tag = AB.block(Vector3.new(3, 2.5, 0.1), VERMILION,
		AB.offset(originCF, -12, 11, -3.4), model, "Graffiti")
	AB.neon(tag)
	tag.Transparency = 0.15

	-- Small piles of recycle bottles between machines
	for i = 1, 5 do
		local x = (i - 3) * 6 + 3
		AB.cylinder(0.5, 1.0, Color3.fromRGB(180, 220, 230),
			AB.offset(originCF, x, 1.1, 1.8), model, "Bottle_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
