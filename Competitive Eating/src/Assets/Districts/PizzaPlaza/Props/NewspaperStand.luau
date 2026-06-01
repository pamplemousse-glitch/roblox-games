-- Newspaper Stand — coin-op vending box with newspaper stack visible
-- through the window. Iron frame, red box, coin slot, paper title.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BOX_RED   = Color3.fromRGB(170, 35, 35)
local DK_RED    = Color3.fromRGB(110, 20, 25)
local IRON      = Color3.fromRGB(40, 40, 45)
local GLASS     = Color3.fromRGB(220, 240, 255)
local PAPER     = Color3.fromRGB(245, 240, 230)
local TXT_DK    = Color3.fromRGB(30, 30, 35)
local BRASS     = Color3.fromRGB(200, 160, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("NewspaperStand", parent)

	-- Pedestal legs
	for i, sx in {-1, 1} do
		AB.cylinder(0.4, 3, IRON, AB.offset(originCF, sx * 1, 1.5, 0), model, "Leg_" .. i)
	end
	-- Cross bar
	AB.cylinder(0.3, 2, IRON,
		AB.offset(originCF, 0, 1, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "CrossBar")

	-- Main box (red)
	AB.block(Vector3.new(3, 5, 2.4), BOX_RED, AB.offset(originCF, 0, 5.5, 0), model, "Box")
	-- Box trim (darker)
	AB.block(Vector3.new(3.1, 0.3, 2.5), DK_RED, AB.offset(originCF, 0, 7.8, 0), model, "BoxTopTrim")
	AB.block(Vector3.new(3.1, 0.3, 2.5), DK_RED, AB.offset(originCF, 0, 3.2, 0), model, "BoxBotTrim")
	-- Slope-back top (wedge)
	AB.wedge(Vector3.new(3, 1, 2.4), BOX_RED,
		AB.offset(originCF, 0, 8.3, 0) * CFrame.Angles(0, math.rad(180), 0), model, "TopWedge")

	-- Window
	local win = AB.block(Vector3.new(2.4, 3, 0.2), GLASS, AB.offset(originCF, 0, 5.7, 1.25), model, "Window")
	win.Transparency = 0.4
	-- Window frame
	AB.block(Vector3.new(2.6, 0.2, 0.3), IRON, AB.offset(originCF, 0, 7.2, 1.3), model, "WinFrameTop")
	AB.block(Vector3.new(2.6, 0.2, 0.3), IRON, AB.offset(originCF, 0, 4.2, 1.3), model, "WinFrameBot")
	AB.block(Vector3.new(0.2, 3, 0.3), IRON, AB.offset(originCF, -1.2, 5.7, 1.3), model, "WinFrameL")
	AB.block(Vector3.new(0.2, 3, 0.3), IRON, AB.offset(originCF,  1.2, 5.7, 1.3), model, "WinFrameR")

	-- Newspaper visible through window (folded paper)
	AB.block(Vector3.new(2, 2.4, 0.4), PAPER, AB.offset(originCF, 0, 5.7, 1.05), model, "Newspaper")
	-- Headline strip
	AB.block(Vector3.new(1.6, 0.4, 0.05), TXT_DK, AB.offset(originCF, 0, 6.5, 1.25), model, "Headline")
	-- Subheading lines
	for i = 1, 3 do
		AB.block(Vector3.new(1.6, 0.1, 0.05), Color3.fromRGB(110, 110, 110),
			AB.offset(originCF, 0, 6 - i * 0.25, 1.25), model, "SubLine_" .. i)
	end
	-- Masthead label "IL POMODORO" above headline
	AB.block(Vector3.new(1.6, 0.25, 0.05), DK_RED,
		AB.offset(originCF, 0, 6.85, 1.25), model, "Masthead")

	-- Coin slot at top
	AB.block(Vector3.new(0.8, 0.15, 0.4), IRON, AB.offset(originCF, 0, 7.4, 1.05), model, "CoinSlot")
	-- Handle
	AB.block(Vector3.new(1.2, 0.3, 0.3), BRASS, AB.offset(originCF, 0, 3.8, 1.3), model, "Handle")

	-- Roof brand sign
	AB.block(Vector3.new(3.2, 0.7, 0.6), DK_RED, AB.offset(originCF, 0, 8.7, 0.5), model, "BrandSign")
	AB.block(Vector3.new(2.4, 0.3, 0.05), PAPER, AB.offset(originCF, 0, 8.7, 0.85), model, "BrandText")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
