-- Vending Machine Single — one self-contained machine, drop along sidewalks.
-- Vary its color via the random-ish seed from originCF position.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DARK_METAL  = Color3.fromRGB(55, 55, 65)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)

local COLORS = {
	Color3.fromRGB(50, 130, 200),
	Color3.fromRGB(220, 50, 60),
	Color3.fromRGB(40, 160, 80),
	Color3.fromRGB(240, 180, 40),
	Color3.fromRGB(150, 80, 180),
}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("VendingMachineSingle", parent)

	-- Pick deterministic color from world X coord
	local px = originCF.Position.X
	local color = COLORS[((math.floor(math.abs(px)) % #COLORS) + 1)]

	-- Body
	AB.block(Vector3.new(4.5, 9, 2.6), color,
		AB.offset(originCF, 0, 4.7, 0), model, "Body")

	-- Top glowing brand sign
	local brand = AB.block(Vector3.new(3.6, 0.6, 0.4), LANTERN_Y,
		AB.offset(originCF, 0, 8.9, 1.4), model, "Brand")
	AB.neon(brand)
	AB.glow(brand, LANTERN_Y, 1.2)

	-- Window
	local window = AB.block(Vector3.new(3.6, 4, 0.3), PAPER_WHITE,
		AB.offset(originCF, 0, 6.5, 1.4), model, "Window")
	AB.neon(window)
	AB.glow(window, PAPER_WHITE, 1.5)
	-- 4 product columns inside
	for j = 1, 4 do
		AB.block(Vector3.new(0.65, 3.4, 0.35), color,
			AB.offset(originCF, -1.2 + (j - 1) * 0.8, 6.5, 1.5), model, "Slot_" .. j)
	end

	-- Control panel
	AB.block(Vector3.new(4, 3, 0.3), DARK_METAL,
		AB.offset(originCF, 0, 3.2, 1.4), model, "Panel")
	-- Coin slot
	AB.block(Vector3.new(0.4, 0.3, 0.4), IRON_BLACK,
		AB.offset(originCF, 1.4, 4.2, 1.5), model, "CoinSlot")
	-- Dispense slot
	AB.block(Vector3.new(1.8, 0.5, 0.4), IRON_BLACK,
		AB.offset(originCF, 0, 1.6, 1.5), model, "DispenseSlot")
	-- Buttons grid (4 small white squares)
	for j = 0, 3 do
		AB.block(Vector3.new(0.35, 0.3, 0.4), PAPER_WHITE,
			AB.offset(originCF, -1.2 + j * 0.8, 3.4, 1.5), model, "Button_" .. j)
	end

	-- Side dark strip
	AB.block(Vector3.new(0.2, 9, 2.7), IRON_BLACK,
		AB.offset(originCF, -2.3, 4.7, 0), model, "SideStripL")
	AB.block(Vector3.new(0.2, 9, 2.7), IRON_BLACK,
		AB.offset(originCF,  2.3, 4.7, 0), model, "SideStripR")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
