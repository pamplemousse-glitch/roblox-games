-- GiantDonutTower — 80-stud-tall stacked-donut landmark. Five donut
-- tiers in different glaze colors arranged around a central pole, each
-- with sprinkles. Glowing neon-pink core lights the whole tower.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CREAM  = Color3.fromRGB(255, 240, 220)
local BROWN  = Color3.fromRGB(92,  57,  36)
local GOLD   = Color3.fromRGB(212, 168, 82)
local MINT   = Color3.fromRGB(180, 230, 200)
local NEONPK = Color3.fromRGB(255, 110, 170)
local DOUGH  = Color3.fromRGB(220, 170, 110)
local CHOC   = Color3.fromRGB(110, 60, 30)
local STRAW  = Color3.fromRGB(245, 80, 120)

local function buildDonutLayer(model: Model, originCF: CFrame, y: number, glaze: Color3, ringRadius: number, segmentCount: number, name: string)
	-- Donut body (ring of dough spheres)
	AB.circleArrange(AB.offset(originCF, 0, y, 0), ringRadius, segmentCount, model, function(i, cf, _)
		return AB.sphere(ringRadius * 0.7, DOUGH, cf, model, name .. "_Body_" .. i)
	end)
	-- Glaze ring on top
	AB.circleArrange(AB.offset(originCF, 0, y + ringRadius * 0.35, 0), ringRadius, segmentCount, model, function(i, cf, _)
		return AB.sphere(ringRadius * 0.55, glaze, cf, model, name .. "_Glaze_" .. i)
	end)
	-- Sprinkles
	local sprinkleCols = {NEONPK, MINT, GOLD, CREAM, DEEP}
	for i = 1, 20 do
		local a = (i / 20) * math.pi * 2
		local r = ringRadius + (math.random() - 0.5) * 0.6
		AB.block(Vector3.new(0.4, 1, 0.4), sprinkleCols[((i - 1) % #sprinkleCols) + 1],
			AB.offset(originCF, math.cos(a) * r, y + ringRadius * 0.5, math.sin(a) * r, a * 30),
			model, name .. "_Sprinkle_" .. i)
	end
end

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GiantDonutTower", parent)

	-- Wide stone base platform
	AB.cylinder(28, 1.6, BROWN, AB.offset(originCF, 0, 0.8, 0), model, "BasePlatform")
	AB.cylinder(26, 0.8, GOLD, AB.offset(originCF, 0, 1.8, 0), model, "BaseGold")
	AB.cylinder(24, 1, CREAM, AB.offset(originCF, 0, 2.6, 0), model, "BaseCream")

	-- Decorative ring of mint planters around base
	for i = 1, 8 do
		local a = (i / 8) * math.pi * 2
		AB.block(Vector3.new(2, 1.4, 2), GOLD,
			AB.offset(originCF, math.cos(a) * 13, 3.8, math.sin(a) * 13), model, "Planter_" .. i)
		AB.sphere(2.2, MINT,
			AB.offset(originCF, math.cos(a) * 13, 5.3, math.sin(a) * 13), model, "PlanterShrub_" .. i)
	end

	-- Central glowing core pole (neon pink)
	local core = AB.cylinder(2.4, 72, NEONPK,
		AB.offset(originCF, 0, 40, 0), model, "GlowCore")
	AB.neon(core)
	core.Transparency = 0.25
	AB.glow(core, NEONPK, 5)

	-- Tier 1: pink glaze (y = 10, ring radius 11) — sphere segments 18
	buildDonutLayer(model, originCF, 11, PINK, 11, 18, "Tier1")
	-- Tier 2: chocolate (y = 25, ring radius 9.5)
	buildDonutLayer(model, originCF, 25, CHOC, 9.5, 16, "Tier2")
	-- Tier 3: strawberry (y = 39, ring radius 8)
	buildDonutLayer(model, originCF, 39, STRAW, 8, 14, "Tier3")
	-- Tier 4: mint (y = 51, ring radius 6.5)
	buildDonutLayer(model, originCF, 51, MINT, 6.5, 12, "Tier4")
	-- Tier 5: cream (y = 61, ring radius 5)
	buildDonutLayer(model, originCF, 61, CREAM, 5, 10, "Tier5")

	-- Top finial: gold cone + giant cherry
	AB.cylinder(3.5, 1, GOLD, AB.offset(originCF, 0, 67, 0), model, "FinialBase")
	AB.wedge(Vector3.new(3, 4, 3), GOLD,
		AB.offset(originCF, -0.7, 69, 0), model, "FinialConeA")
	AB.wedge(Vector3.new(3, 4, 3), GOLD,
		AB.offset(originCF, -0.7, 69, 0) * CFrame.Angles(0, math.rad(180), 0), model, "FinialConeB")
	-- Cherry sphere
	local cherry = AB.sphere(4, NEONPK, AB.offset(originCF, 0, 74, 0), model, "Cherry")
	AB.neon(cherry)
	AB.glow(cherry, NEONPK, 6)
	cherry.Transparency = 0.15
	-- Cherry stem
	AB.cylinder(0.4, 3, BROWN, AB.offset(originCF, 0, 77, 0), model, "CherryStem")
	-- Cherry leaf
	AB.wedge(Vector3.new(0.3, 1.6, 1.4), MINT,
		AB.offset(originCF, 0.5, 78, 0) * CFrame.Angles(0, 0, math.rad(45)), model, "CherryLeaf")

	-- Total height: ~80 studs

	-- Spotlights at base pointing up
	for i = 1, 4 do
		local a = (i / 4) * math.pi * 2
		local lamp = AB.cylinder(1.2, 0.6, GOLD,
			AB.offset(originCF, math.cos(a) * 10, 4, math.sin(a) * 10), model, "Spotlight_" .. i)
		local bulb = AB.sphere(0.9, NEONPK,
			AB.offset(originCF, math.cos(a) * 10, 4.7, math.sin(a) * 10), model, "SpotBulb_" .. i)
		AB.neon(bulb)
		AB.glow(bulb, NEONPK, 3)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
