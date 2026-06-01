-- Espresso Cart — small wooden push-cart with a brass espresso machine,
-- pastry display, and a steaming cup.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WOOD      = Color3.fromRGB(110, 75, 45)
local DK_WD     = Color3.fromRGB(80, 50, 30)
local BRASS     = Color3.fromRGB(200, 160, 80)
local STEEL     = Color3.fromRGB(170, 170, 175)
local CHROME    = Color3.fromRGB(220, 220, 230)
local CUP       = Color3.fromRGB(245, 235, 220)
local ESPR      = Color3.fromRGB(60, 35, 20)
local STEAM     = Color3.fromRGB(240, 240, 240)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("EspressoCart", parent)

	-- Cart body
	AB.block(Vector3.new(6, 3, 3), WOOD, AB.offset(originCF, 0, 2.5, 0), model, "Body")
	-- Top counter
	AB.block(Vector3.new(6.2, 0.4, 3.2), STEEL, AB.offset(originCF, 0, 4.2, 0), model, "Counter")
	-- Side trim
	AB.block(Vector3.new(6.4, 0.3, 3.4), DK_WD, AB.offset(originCF, 0, 1.2, 0), model, "BottomTrim")

	-- Espresso machine on top (brass + chrome boxy)
	AB.block(Vector3.new(3, 2.5, 2), BRASS, AB.offset(originCF, -0.5, 5.6, 0), model, "Machine")
	-- Steam wand
	AB.cylinder(0.2, 1.5, CHROME, AB.offset(originCF, 0.8, 5.3, 0.8), model, "SteamWand")
	-- Group head + portafilter
	AB.cylinder(0.7, 0.8, CHROME, AB.offset(originCF, -0.5, 4.6, 0.9), model, "GroupHead")
	AB.cylinder(0.5, 0.8, DK_WD, AB.offset(originCF, -0.5, 4.2, 1.2), model, "Portafilter")
	-- Chrome dome on top
	AB.sphere(1.4, CHROME, AB.offset(originCF, -0.5, 7.2, 0), model, "Dome")
	-- Brass eagle / finial
	AB.sphere(0.6, BRASS, AB.offset(originCF, -0.5, 8.1, 0), model, "Eagle")

	-- Cup under group head
	AB.cylinder(0.7, 0.7, CUP, AB.offset(originCF, -0.5, 4.6, 1.4) * CFrame.Angles(0, 0, math.rad(90)), model, "Cup")
	AB.cylinder(0.6, 0.2, ESPR, AB.offset(originCF, -0.5, 4.85, 1.4) * CFrame.Angles(0, 0, math.rad(90)), model, "Crema")
	-- Steam wisps
	local s1 = AB.sphere(0.6, STEAM, AB.offset(originCF, -0.5, 5.4, 1.4), model, "Steam1"); s1.Transparency = 0.5
	local s2 = AB.sphere(0.8, STEAM, AB.offset(originCF, -0.5, 6.0, 1.5), model, "Steam2"); s2.Transparency = 0.7

	-- Pastry display (glass case)
	local glass = AB.block(Vector3.new(2.5, 1.5, 2), Color3.fromRGB(200, 220, 235),
		AB.offset(originCF, 2, 5.2, 0), model, "PastryGlass")
	glass.Transparency = 0.5
	-- Pastries inside
	AB.sphere(0.5, Color3.fromRGB(220, 180, 100), AB.offset(originCF, 1.5, 5.2, 0), model, "Pastry1")
	AB.sphere(0.5, Color3.fromRGB(180, 130, 70), AB.offset(originCF, 2.5, 5.2, 0), model, "Pastry2")
	AB.block(Vector3.new(0.8, 0.4, 0.6), Color3.fromRGB(240, 220, 180), AB.offset(originCF, 2, 5.2, -0.5), model, "Pastry3")

	-- Wheels
	for i, sx in {-1, 1} do
		AB.cylinder(2, 0.4, DK_WD,
			AB.offset(originCF, sx * 2.5, 1, 1.7) * CFrame.Angles(math.rad(90), 0, 0), model, "Wheel_" .. i)
		AB.sphere(0.4, BRASS, AB.offset(originCF, sx * 2.5, 1, 1.7), model, "Hub_" .. i)
	end
	-- Back wheels (smaller)
	for i, sx in {-1, 1} do
		AB.cylinder(1.4, 0.3, DK_WD,
			AB.offset(originCF, sx * 2.5, 0.7, -1.7) * CFrame.Angles(math.rad(90), 0, 0), model, "BackWheel_" .. i)
	end

	-- Push handle
	AB.cylinder(0.3, 4, WOOD,
		AB.offset(originCF, -4.5, 3.5, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)), model, "Handle")
	AB.cylinder(0.3, 1.8, WOOD, AB.offset(originCF, -3.2, 3.5, 0), model, "HandleStem")

	-- "CAFFE" small sign
	local sign = AB.block(Vector3.new(2, 0.7, 0.2), Color3.fromRGB(255, 60, 60),
		AB.offset(originCF, 0, 4.7, 1.6), model, "CaffeSign")
	AB.neon(sign)

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
