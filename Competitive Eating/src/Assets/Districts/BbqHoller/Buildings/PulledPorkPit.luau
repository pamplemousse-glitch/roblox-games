-- Pulled Pork Pit — open dirt pit with stone-ring border, neon open fire,
-- pig roasting on a horizontal spit with two upright posts, small shade lean-to
-- behind. Less of a building, more of a cooking station.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DIRT      = Color3.fromRGB(75, 55, 35)
local STONE     = Color3.fromRGB(110, 100, 92)
local STONE_D   = Color3.fromRGB(80, 72, 65)
local CHARCOAL  = Color3.fromRGB(35, 30, 28)
local EMBER     = Color3.fromRGB(255, 128, 48)
local FIRE_YEL  = Color3.fromRGB(255, 210, 90)
local SMOKE     = Color3.fromRGB(200, 200, 205)
local PORK      = Color3.fromRGB(195, 130, 100)
local PORK_DARK = Color3.fromRGB(140, 80, 60)
local STEEL     = Color3.fromRGB(120, 120, 125)
local DARK_WOOD = Color3.fromRGB(70, 45, 22)
local PLANK     = Color3.fromRGB(107, 68, 35)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PulledPorkPit", parent)

	-- Dirt mound base (squat, slightly sunken-feeling)
	local mound = AB.block(Vector3.new(24, 1.4, 18), DIRT, AB.offset(originCF, 0, 0.7, 0), model, "Mound")

	-- Stone ring around the pit (8 chunky stones in a circle)
	AB.circleArrange(AB.offset(originCF, 0, 1.6, 0), 6.5, 10, model, function(i, cf)
		local col = (i % 2 == 0) and STONE or STONE_D
		return AB.block(Vector3.new(2.5, 1.6, 1.8), col, cf, model, "Stone_" .. i)
	end)

	-- Charcoal bed inside the ring
	AB.cylinder(10, 0.6, CHARCOAL, AB.offset(originCF, 0, 1.8, 0), model, "CharcoalBed")

	-- Open fire (neon flames + ember dome)
	for i = 1, 8 do
		local angle = (i / 8) * math.pi * 2
		local r = 2 + math.sin(i * 1.3) * 0.6
		local h = 1.6 + math.cos(i * 0.7) * 0.7
		local flame = AB.sphere(1.6 + math.sin(i) * 0.4, (i % 2 == 0) and FIRE_YEL or EMBER,
			AB.offset(originCF, math.cos(angle) * r, 2.4 + h * 0.5, math.sin(angle) * r),
			model, "Flame_" .. i)
		AB.neon(flame)
		AB.glow(flame, EMBER, 3)
		flame.Transparency = 0.15
	end
	-- Central tall flame
	local core = AB.sphere(2.2, FIRE_YEL, AB.offset(originCF, 0, 3.4, 0), model, "FlameCore")
	AB.neon(core)
	AB.glow(core, EMBER, 4)
	core.Transparency = 0.1

	-- Smoke wisps rising
	for i = 1, 5 do
		local puff = AB.sphere(1.8 + i * 0.3, SMOKE,
			AB.offset(originCF, math.sin(i) * 0.8, 6 + (i - 1) * 1.8, math.cos(i) * 0.6),
			model, "Smoke_" .. i)
		puff.Material     = Enum.Material.Neon
		puff.Transparency = 0.3 + (i - 1) * 0.12
	end

	-- Spit posts (Y-shaped uprights)
	AB.block(Vector3.new(0.6, 6, 0.6), DARK_WOOD, AB.offset(originCF, -7, 4.5, 0), model, "PostL")
	AB.block(Vector3.new(0.6, 6, 0.6), DARK_WOOD, AB.offset(originCF,  7, 4.5, 0), model, "PostR")
	AB.cylinder(0.3, 16, STEEL, AB.offset(originCF, 0, 7.1, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Spit")

	-- Pig on the spit (oval body + 4 leg stubs + head + tail)
	AB.sphere(3.2, PORK, AB.offset(originCF, 0, 6.8, 0), model, "PigBody")
	-- Crisp dark skin streaks
	AB.sphere(2.6, PORK_DARK, AB.offset(originCF, -0.6, 6.6, 0.6), model, "PigSkin1")
	AB.sphere(2.0, PORK_DARK, AB.offset(originCF, 0.8, 7.1, -0.5), model, "PigSkin2")
	AB.sphere(1.5, PORK, AB.offset(originCF, 3.2, 6.8, 0), model, "PigHead")
	-- Pig snout + ears
	AB.cylinder(0.9, 0.6, PORK_DARK, AB.offset(originCF, 4.0, 6.8, 0), model, "Snout")
	AB.block(Vector3.new(0.4, 0.8, 0.5), PORK, AB.offset(originCF, 3.0, 7.8, 0.6), model, "EarL")
	AB.block(Vector3.new(0.4, 0.8, 0.5), PORK, AB.offset(originCF, 3.0, 7.8, -0.6), model, "EarR")
	-- Curly tail
	AB.sphere(0.5, PORK_DARK, AB.offset(originCF, -3.2, 7.4, 0), model, "Tail")
	-- Stubby legs
	for i, p in {Vector3.new(-1.2, 5.4, 1.4), Vector3.new(1.2, 5.4, 1.4), Vector3.new(-1.2, 5.4, -1.4), Vector3.new(1.2, 5.4, -1.4)} do
		AB.block(Vector3.new(0.6, 1.2, 0.6), PORK_DARK, originCF * CFrame.new(p), model, "Leg_" .. i)
	end

	-- Shade lean-to behind the pit (two posts + slanted plank roof)
	AB.block(Vector3.new(0.5, 9, 0.5), DARK_WOOD, AB.offset(originCF, -10, 5, -10), model, "LeanPostL")
	AB.block(Vector3.new(0.5, 9, 0.5), DARK_WOOD, AB.offset(originCF,  10, 5, -10), model, "LeanPostR")
	local leanRoof = AB.block(Vector3.new(22, 0.4, 8), PLANK, AB.offset(originCF, 0, 9.2, -10), model, "LeanRoof")
	leanRoof.CFrame = leanRoof.CFrame * CFrame.Angles(math.rad(-15), 0, 0)
	-- Plank stripes on lean-to
	for i = -4, 4 do
		AB.block(Vector3.new(1.6, 0.3, 8), DARK_WOOD, leanRoof.CFrame * CFrame.new(i * 2.4, 0.3, 0), model, "Plank_" .. i + 5)
	end

	AB.pivot(model, mound)
	AB.weldAll(model)
	return model
end
