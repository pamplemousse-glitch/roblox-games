-- ChickenwichExpress — fast-food order window stand. Yellow + red, chicken-themed,
-- with a small ordering window and a giant chicken mascot above.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local YELLOW    = Color3.fromRGB(245, 195, 70)
local NEON_RED  = Color3.fromRGB(255, 48, 48)
local CREAM     = Color3.fromRGB(255, 245, 232)
local CHROME    = Color3.fromRGB(176, 176, 176)
local DARK_RED  = Color3.fromRGB(150, 30, 30)
local BEAK      = Color3.fromRGB(255, 150, 30)
local CHICKEN   = Color3.fromRGB(255, 240, 220)
local FEATHER   = Color3.fromRGB(240, 220, 180)
local SKY       = Color3.fromRGB(135, 206, 235)
local BLACK     = Color3.fromRGB(30, 30, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ChickenwichExpress", parent)

	-- Foundation
	local foundation = AB.block(Vector3.new(18, 0.6, 16), Color3.fromRGB(100, 100, 100), AB.offset(originCF, 0, 0.3, 0), model, "Foundation")
	foundation.Material = Enum.Material.Concrete

	-- Main building (yellow box)
	AB.block(Vector3.new(18, 7, 1),  YELLOW, AB.offset(originCF, 0, 4, -7.5), model, "BackWall")
	AB.block(Vector3.new(1,  7, 16), YELLOW, AB.offset(originCF, -8.5, 4, 0), model, "LeftWall")
	AB.block(Vector3.new(1,  7, 16), YELLOW, AB.offset(originCF,  8.5, 4, 0), model, "RightWall")

	-- Front: left+right walls + order-window opening
	AB.block(Vector3.new(5, 7, 1), YELLOW, AB.offset(originCF, -6.5, 4, 7.5), model, "FrontLeft")
	AB.block(Vector3.new(5, 7, 1), YELLOW, AB.offset(originCF,  6.5, 4, 7.5), model, "FrontRight")
	AB.block(Vector3.new(8, 1.5, 1), YELLOW, AB.offset(originCF, 0, 6.75, 7.5), model, "FrontHeader")

	-- Order window glass
	local glass = AB.block(Vector3.new(7, 4.5, 0.3), SKY, AB.offset(originCF, 0, 3.75, 7.55), model, "OrderGlass")
	glass.Material = Enum.Material.Glass; glass.Transparency = 0.4
	-- Window mullion + frame
	AB.block(Vector3.new(0.4, 4.5, 0.4), CHROME, AB.offset(originCF, 0, 3.75, 7.7), model, "WindowMullion")
	AB.block(Vector3.new(7.4, 0.4, 0.5), CHROME, AB.offset(originCF, 0, 5.95, 7.7), model, "WindowFrameTop")
	AB.block(Vector3.new(7.4, 0.4, 0.5), CHROME, AB.offset(originCF, 0, 1.55, 7.7), model, "WindowFrameBot")

	-- Counter ledge (where orders come out)
	AB.block(Vector3.new(7.4, 0.4, 1.5), CHROME, AB.offset(originCF, 0, 1.55, 8.4), model, "CounterLedge")

	-- Red horizontal stripe + flat roof
	AB.block(Vector3.new(18.2, 1, 17), NEON_RED, AB.offset(originCF, 0, 8, 0), model, "RoofBand")
	AB.block(Vector3.new(19, 0.5, 17.4), BLACK, AB.offset(originCF, 0, 8.75, 0), model, "Roof").Material = Enum.Material.Slate

	-- Side menu board panel (yellow + red, vertical)
	AB.block(Vector3.new(3.5, 6, 0.3), CREAM, AB.offset(originCF, 7, 5, 7.85), model, "MenuPanelR")
	AB.block(Vector3.new(3.5, 6, 0.3), CREAM, AB.offset(originCF, -7, 5, 7.85), model, "MenuPanelL")
	AB.billboard(model:FindFirstChild("MenuPanelR"), "CHICKEN\nWICH\n$5.99", Vector2.new(120, 180), 0)
	AB.billboard(model:FindFirstChild("MenuPanelL"), "FRIES\n$2.49", Vector2.new(120, 180), 0)

	-- Giant chicken mascot on roof (cartoon style)
	-- Body
	AB.sphere(7, CHICKEN, AB.offset(originCF, 0, 12, 0), model, "ChickenBody")
	-- Head
	AB.sphere(4.5, CHICKEN, AB.offset(originCF, 0, 16, 1.5), model, "ChickenHead")
	-- Beak
	AB.wedge(Vector3.new(1.5, 1.5, 2.5), BEAK, AB.offset(originCF, 0, 15.6, 3.8) * CFrame.Angles(0, math.rad(180), 0), model, "ChickenBeak")
	-- Eyes
	AB.sphere(0.8, BLACK, AB.offset(originCF, -1.2, 16.8, 3), model, "EyeL")
	AB.sphere(0.8, BLACK, AB.offset(originCF,  1.2, 16.8, 3), model, "EyeR")
	-- Comb (red top)
	AB.sphere(1.2, NEON_RED, AB.offset(originCF, 0, 18.5, 1.5), model, "Comb1")
	AB.sphere(0.9, NEON_RED, AB.offset(originCF, -0.8, 18.2, 1.5), model, "Comb2")
	AB.sphere(0.9, NEON_RED, AB.offset(originCF,  0.8, 18.2, 1.5), model, "Comb3")
	-- Wattle
	AB.sphere(0.6, NEON_RED, AB.offset(originCF, 0, 14.6, 3.4), model, "Wattle")
	-- Wings
	AB.sphere(2.5, FEATHER, AB.offset(originCF, -4, 11.5, 0.5), model, "WingL")
	AB.sphere(2.5, FEATHER, AB.offset(originCF,  4, 11.5, 0.5), model, "WingR")

	-- Chicken holding a sandwich (a stacked cylinder burger between his wings)
	AB.cylinder(2.5, 0.5, AB.colors.bunTan, AB.offset(originCF, 0, 9.5, 4.2), model, "MascotBunBot")
	AB.cylinder(2.7, 0.4, AB.colors.burgerBrown, AB.offset(originCF, 0, 9.9, 4.2), model, "MascotPatty")
	AB.cylinder(2.5, 0.5, AB.colors.bunTan, AB.offset(originCF, 0, 10.3, 4.2), model, "MascotBunTop")

	-- "CHICKENWICH" neon storefront sign (above order window)
	local marquee = AB.block(Vector3.new(14, 2.5, 0.4), DARK_RED, AB.offset(originCF, 0, 8.5, 7.7), model, "MarqueeBack")
	local marqueeNeon = AB.block(Vector3.new(13, 1.8, 0.5), NEON_RED, AB.offset(originCF, 0, 8.5, 7.95), model, "MarqueeNeon")
	AB.neon(marqueeNeon); AB.glow(marqueeNeon, NEON_RED, 2.5)
	AB.billboard(marquee, "CHICKENWICH EXPRESS", Vector2.new(360, 50), 0)

	-- Bulb border around marquee
	for i = 0, 6 do
		local bulb = AB.sphere(0.4, CREAM, AB.offset(originCF, -6 + i * 2, 9.6, 7.9), model, "MBulb_T_" .. i)
		AB.neon(bulb); AB.glow(bulb, CREAM, 0.8)
	end

	-- Side trash can + drive-thru lane marker
	AB.cylinder(2, 2.5, NEON_RED, AB.offset(originCF, -10, 1.25, 6), model, "TrashL")
	AB.cylinder(2, 2.5, YELLOW, AB.offset(originCF, 10, 1.25, 6), model, "TrashR")
	-- Order spike + clipboard
	AB.cylinder(0.4, 1.2, CHROME, AB.offset(originCF, 0, 2.9, 8.6), model, "OrderSpike")

	-- Entry steps
	AB.block(Vector3.new(8, 0.5, 1.5), CHROME, AB.offset(originCF, 0, 0.85, 8.3), model, "Step1")
	AB.block(Vector3.new(8, 0.5, 1.5), CHROME, AB.offset(originCF, 0, 0.35, 9.6), model, "Step2")

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
