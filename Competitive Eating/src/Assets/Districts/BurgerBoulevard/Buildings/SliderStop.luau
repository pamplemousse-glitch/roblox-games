-- SliderStop — small mid-century walk-up burger stand. White tile box with
-- red trim, slider menu board, single order window.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TILE_WHITE = Color3.fromRGB(245, 240, 230)
local NEON_RED   = Color3.fromRGB(255, 48, 48)
local CHROME     = Color3.fromRGB(176, 176, 176)
local TEAL       = Color3.fromRGB(127, 202, 194)
local CREAM      = Color3.fromRGB(255, 245, 232)
local BLACK      = Color3.fromRGB(35, 35, 35)
local SKY        = Color3.fromRGB(135, 206, 235)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SliderStop", parent)

	-- Foundation
	local foundation = AB.block(Vector3.new(16, 0.6, 14), Color3.fromRGB(95, 95, 95), AB.offset(originCF, 0, 0.3, 0), model, "Foundation")
	foundation.Material = Enum.Material.Concrete

	-- White-tile main building (small box)
	AB.block(Vector3.new(16, 7, 1),  TILE_WHITE, AB.offset(originCF, 0, 4, -6.5), model, "BackWall")
	AB.block(Vector3.new(1,  7, 14), TILE_WHITE, AB.offset(originCF, -7.5, 4, 0), model, "LeftWall")
	AB.block(Vector3.new(1,  7, 14), TILE_WHITE, AB.offset(originCF,  7.5, 4, 0), model, "RightWall")

	-- Front wall sections (door + window)
	AB.block(Vector3.new(5, 7, 1), TILE_WHITE, AB.offset(originCF, -5.5, 4, 6.5), model, "FrontLeft")
	AB.block(Vector3.new(5, 7, 1), TILE_WHITE, AB.offset(originCF,  5.5, 4, 6.5), model, "FrontRight")
	-- Header above center
	AB.block(Vector3.new(6, 2, 1), TILE_WHITE, AB.offset(originCF, 0, 6.5, 6.5), model, "FrontHeader")

	-- Order window (the iconic slider-stand counter window)
	local window = AB.block(Vector3.new(5, 3, 0.4), SKY, AB.offset(originCF, 0, 4, 6.7), model, "OrderWindow")
	window.Material = Enum.Material.Glass
	window.Transparency = 0.4
	window.Reflectance = 0.2
	-- Window frame
	AB.block(Vector3.new(5.4, 0.4, 0.5), CHROME, AB.offset(originCF, 0, 5.6, 6.75), model, "WinTop")
	AB.block(Vector3.new(5.4, 0.4, 0.5), CHROME, AB.offset(originCF, 0, 2.4, 6.75), model, "WinBot")
	AB.block(Vector3.new(0.4, 3.2, 0.5), CHROME, AB.offset(originCF, -2.5, 4, 6.75), model, "WinL")
	AB.block(Vector3.new(0.4, 3.2, 0.5), CHROME, AB.offset(originCF,  2.5, 4, 6.75), model, "WinR")

	-- Service counter ledge (where you pick up sliders)
	AB.block(Vector3.new(5.4, 0.4, 1.2), CHROME, AB.offset(originCF, 0, 2.4, 7.3), model, "CounterLedge")

	-- Red horizontal stripe along upper wall (50s detail)
	AB.block(Vector3.new(16.2, 0.8, 1.1), NEON_RED, AB.offset(originCF, 0, 7.5, -6.5), model, "BackStripe")
	AB.block(Vector3.new(16.2, 0.8, 1.1), NEON_RED, AB.offset(originCF, 0, 7.5,  6.5), model, "FrontStripe")
	AB.block(Vector3.new(1.1, 0.8, 14.2), NEON_RED, AB.offset(originCF, -7.5, 7.5, 0), model, "LeftStripe")
	AB.block(Vector3.new(1.1, 0.8, 14.2), NEON_RED, AB.offset(originCF,  7.5, 7.5, 0), model, "RightStripe")

	-- Flat tar roof
	AB.block(Vector3.new(17, 0.5, 15), BLACK, AB.offset(originCF, 0, 7.85, 0), model, "Roof").Material = Enum.Material.Slate

	-- Rooftop sign — vertical pylon "SLIDER STOP"
	AB.block(Vector3.new(4, 6, 0.8), CREAM, AB.offset(originCF, 0, 11, 6.5), model, "SignBody")
	-- Sign frame
	AB.block(Vector3.new(4.4, 0.5, 1), CHROME, AB.offset(originCF, 0, 14, 6.5), model, "SignTopTrim")
	AB.block(Vector3.new(4.4, 0.5, 1), CHROME, AB.offset(originCF, 0, 8, 6.5), model, "SignBotTrim")
	-- Mini neon slider icon (mini burger circles)
	local bun = AB.cylinder(2.4, 0.6, AB.colors.bunTan, AB.offset(originCF, 0, 12.4, 7), model, "SignBun")
	local pat = AB.cylinder(2.6, 0.4, AB.colors.burgerBrown, AB.offset(originCF, 0, 12, 7), model, "SignPatty")
	local bot = AB.cylinder(2.4, 0.6, AB.colors.bunTan, AB.offset(originCF, 0, 11.6, 7), model, "SignBunBot")
	-- "SLIDERS" text via BillboardGui anchor
	local txt = AB.block(Vector3.new(0.2, 0.2, 0.2), CREAM, AB.offset(originCF, 0, 9.4, 7.1), model, "TextAnchor")
	txt.Transparency = 1
	AB.billboard(txt, "SLIDERS", Vector2.new(200, 50), 0)

	-- Vertical fluorescent neon tubes flanking the order window
	local tL = AB.block(Vector3.new(0.4, 3.5, 0.4), NEON_RED, AB.offset(originCF, -3.4, 4, 6.85), model, "TubeL")
	AB.neon(tL); AB.glow(tL, NEON_RED, 1.5)
	local tR = AB.block(Vector3.new(0.4, 3.5, 0.4), NEON_RED, AB.offset(originCF,  3.4, 4, 6.85), model, "TubeR")
	AB.neon(tR); AB.glow(tR, NEON_RED, 1.5)

	-- Menu board outside (slanted)
	local menu = AB.block(Vector3.new(3, 4, 0.3), BLACK, AB.offset(originCF, 5.5, 4, 8.4) * CFrame.Angles(math.rad(15), 0, 0), model, "MenuBoard")
	menu.Material = Enum.Material.SmoothPlastic
	AB.billboard(menu, "SLIDERS\n10/$5", Vector2.new(140, 80), 0)

	-- Tip jar / order spike
	AB.cylinder(0.6, 1.4, CHROME, AB.offset(originCF, -2.4, 2.9, 7.6), model, "OrderSpike")

	-- "GRILL HOT" hanging tag sign
	local hot = AB.block(Vector3.new(3, 1, 0.2), NEON_RED, AB.offset(originCF, -5.5, 5.4, 7.4), model, "HotSign")
	AB.neon(hot); AB.glow(hot, NEON_RED, 1.6)

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
