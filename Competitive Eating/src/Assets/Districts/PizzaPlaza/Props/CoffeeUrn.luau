-- Coffee Urn — large stainless steel cafe urn with spigot, on a pedestal,
-- next to a stack of cups and sugar.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STEEL     = Color3.fromRGB(170, 170, 175)
local DK_STEEL  = Color3.fromRGB(110, 110, 115)
local CHROME    = Color3.fromRGB(220, 220, 230)
local BRASS     = Color3.fromRGB(200, 160, 80)
local CUP_WHT   = Color3.fromRGB(245, 235, 220)
local COFFEE    = Color3.fromRGB(60, 35, 20)
local WD        = Color3.fromRGB(110, 75, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CoffeeUrn", parent)

	-- Wooden pedestal table
	AB.block(Vector3.new(5, 0.4, 4), WD, AB.offset(originCF, 0, 3, 0), model, "Pedestal")
	for i, sx in {-1, 1} do
		for j, sz in {-1, 1} do
			AB.cylinder(0.4, 3, WD,
				AB.offset(originCF, sx * 2, 1.5, sz * 1.5), model, "PedLeg_" .. i .. j)
		end
	end

	-- Urn body (large cylinder)
	AB.cylinder(3, 5, STEEL, AB.offset(originCF, 0, 6, 0), model, "UrnBody")
	-- Top dome
	AB.sphere(1.6, STEEL, AB.offset(originCF, 0, 9, 0), model, "UrnDome")
	-- Brass band
	AB.cylinder(3.1, 0.4, BRASS, AB.offset(originCF, 0, 7, 0), model, "UrnBand")
	-- Bottom band
	AB.cylinder(3.1, 0.4, DK_STEEL, AB.offset(originCF, 0, 3.5, 0), model, "UrnBaseBand")
	-- Brass eagle / handle on top
	AB.cylinder(0.4, 1, BRASS, AB.offset(originCF, 0, 10, 0), model, "UrnFinial")
	AB.sphere(0.6, BRASS, AB.offset(originCF, 0, 10.7, 0), model, "UrnFinialBall")

	-- Side handles (cylinders curved)
	for i, sx in {-1, 1} do
		AB.cylinder(0.3, 2.4, CHROME,
			AB.offset(originCF, sx * 1.6, 6, 0), model, "UrnHandle_" .. i)
		AB.sphere(0.3, BRASS, AB.offset(originCF, sx * 1.6, 7.1, 0), model, "HandleTopBall_" .. i)
		AB.sphere(0.3, BRASS, AB.offset(originCF, sx * 1.6, 4.9, 0), model, "HandleBotBall_" .. i)
	end

	-- Spigot
	AB.cylinder(0.4, 1.2, BRASS, AB.offset(originCF, 0, 4.2, 1.7), model, "SpigotBody")
	AB.cylinder(0.3, 0.8, BRASS,
		AB.offset(originCF, 0, 4.2, 2.4) * CFrame.Angles(math.rad(90), 0, 0), model, "SpigotSpout")
	AB.sphere(0.35, CHROME, AB.offset(originCF, 0, 4.6, 1.7), model, "SpigotKnob")

	-- Cup stack beside urn (4 white cups)
	for i = 1, 4 do
		AB.cylinder(0.7, 0.6, CUP_WHT,
			AB.offset(originCF, 3, 3.5 + (i - 1) * 0.4, 0), model, "Cup_" .. i)
	end
	-- One cup with coffee
	AB.cylinder(0.7, 0.6, CUP_WHT, AB.offset(originCF, -3, 3.5, 0), model, "FilledCup")
	AB.cylinder(0.6, 0.15, COFFEE, AB.offset(originCF, -3, 3.7, 0), model, "CoffeeSurface")
	-- Steam wisps
	local s1 = AB.sphere(0.4, Color3.fromRGB(240, 240, 240), AB.offset(originCF, -3, 4.2, 0), model, "CupSteam1"); s1.Transparency = 0.55
	local s2 = AB.sphere(0.5, Color3.fromRGB(240, 240, 240), AB.offset(originCF, -3, 4.8, 0.1), model, "CupSteam2"); s2.Transparency = 0.7

	-- Sugar bowl (small)
	AB.cylinder(0.8, 0.6, CUP_WHT, AB.offset(originCF, 1.7, 3.5, -1), model, "SugarBowl")
	AB.cylinder(0.7, 0.15, Color3.fromRGB(245, 240, 220), AB.offset(originCF, 1.7, 3.75, -1), model, "Sugar")
	-- Sugar spoon
	AB.block(Vector3.new(0.1, 0.05, 1), CHROME, AB.offset(originCF, 1.7, 3.9, -1), model, "SugarSpoon")

	-- Brass label "CAFFE" on the urn body
	AB.block(Vector3.new(1.4, 0.6, 0.1), BRASS, AB.offset(originCF, 0, 6, 1.7), model, "UrnLabel")

	-- Drip pan under spigot
	AB.cylinder(1, 0.15, DK_STEEL,
		AB.offset(originCF, 0, 3.4, 2.6) * CFrame.Angles(0, 0, math.rad(90)), model, "DripPan")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
