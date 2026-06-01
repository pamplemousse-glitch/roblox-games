-- Wine Rack — outdoor wooden rack with rows of wine bottles (red/white/rose).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WD        = Color3.fromRGB(110, 75, 45)
local DK_WD     = Color3.fromRGB(70, 45, 25)
local CORK      = Color3.fromRGB(195, 165, 120)
local RED_BTL   = Color3.fromRGB(110, 30, 40)
local WHITE_BTL = Color3.fromRGB(220, 215, 180)
local ROSE_BTL  = Color3.fromRGB(220, 140, 150)
local GREEN_BTL = Color3.fromRGB(40, 70, 45)
local LABEL_CR  = Color3.fromRGB(245, 230, 200)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WineRack", parent)

	-- Frame uprights
	AB.block(Vector3.new(0.4, 8, 2.5), DK_WD, AB.offset(originCF, -3.5, 4, 0), model, "FrameL")
	AB.block(Vector3.new(0.4, 8, 2.5), DK_WD, AB.offset(originCF,  3.5, 4, 0), model, "FrameR")
	-- Top + bottom cap
	AB.block(Vector3.new(7.4, 0.4, 2.6), WD, AB.offset(originCF, 0, 7.8, 0), model, "Top")
	AB.block(Vector3.new(7.4, 0.4, 2.6), WD, AB.offset(originCF, 0, 0.2, 0), model, "Bot")
	-- Back panel
	AB.block(Vector3.new(7, 8, 0.2), WD, AB.offset(originCF, 0, 4, -1.2), model, "BackPanel")

	-- 3 shelves (X-shaped dividers for diagonal bottle storage)
	for row = 0, 2 do
		local y = 1.5 + row * 2.2
		-- Horizontal shelf
		AB.block(Vector3.new(7, 0.2, 2.4), WD, AB.offset(originCF, 0, y, 0), model, "Shelf_" .. row)
		-- X dividers (3 X's per row)
		for c = -2, 2, 2 do
			AB.block(Vector3.new(0.15, 2, 2.4), DK_WD,
				AB.offset(originCF, c, y + 1, 0) * CFrame.Angles(0, 0, math.rad(45)), model, "DivA_" .. row .. "_" .. c)
			AB.block(Vector3.new(0.15, 2, 2.4), DK_WD,
				AB.offset(originCF, c, y + 1, 0) * CFrame.Angles(0, 0, math.rad(-45)), model, "DivB_" .. row .. "_" .. c)
		end

		-- Bottles lying on their side in the row (diagonal storage)
		local colors = {RED_BTL, WHITE_BTL, ROSE_BTL, GREEN_BTL, RED_BTL, WHITE_BTL}
		for c = 1, 6 do
			local x = -2.5 + (c - 1) * 1
			local color = colors[((c + row) % #colors) + 1]
			-- Bottle body
			AB.cylinder(0.4, 2, color,
				AB.offset(originCF, x, y + 1, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)),
				model, "Bottle_" .. row .. "_" .. c)
			-- Bottle neck
			AB.cylinder(0.25, 0.6, color,
				AB.offset(originCF, x, y + 1, 1.2) * CFrame.Angles(math.rad(90), 0, 0),
				model, "BottleNeck_" .. row .. "_" .. c)
			-- Cork
			AB.cylinder(0.2, 0.2, CORK,
				AB.offset(originCF, x, y + 1, 1.5) * CFrame.Angles(math.rad(90), 0, 0),
				model, "Cork_" .. row .. "_" .. c)
			-- Label
			AB.block(Vector3.new(0.65, 0.05, 0.6), LABEL_CR,
				AB.offset(originCF, x, y + 1.4, 0), model, "Label_" .. row .. "_" .. c)
		end
	end

	-- A "RISERVA" sign on top
	AB.block(Vector3.new(4, 1, 0.2), LABEL_CR, AB.offset(originCF, 0, 8.5, 0), model, "ReservaSign")
	AB.block(Vector3.new(4.2, 0.2, 0.3), DK_WD, AB.offset(originCF, 0, 9, 0), model, "ReservaSignTop")
	AB.block(Vector3.new(4.2, 0.2, 0.3), DK_WD, AB.offset(originCF, 0, 8, 0), model, "ReservaSignBot")
	AB.block(Vector3.new(2.5, 0.3, 0.05), Color3.fromRGB(110, 30, 40), AB.offset(originCF, 0, 8.5, 0.13), model, "ReservaText")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
