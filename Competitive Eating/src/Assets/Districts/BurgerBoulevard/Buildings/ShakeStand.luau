-- ShakeStand — mid-century stand with milkshake icon.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CHROME     = Color3.fromRGB(176, 176, 176)
local TEAL_50S   = Color3.fromRGB(127, 202, 194)
local CREAM      = Color3.fromRGB(255, 245, 232)
local NEON_RED   = Color3.fromRGB(255, 48, 48)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ShakeStand", parent)

	-- Foundation
	local foundation = AB.block(
		Vector3.new(18, 0.5, 14),
		Color3.fromRGB(120, 120, 120),
		AB.offset(originCF, 0, 0.25, 0),
		model,
		"Foundation"
	)

	-- Counter walls (teal, half-height — it's an open-air stand)
	AB.block(Vector3.new(18, 4, 1),  TEAL_50S, AB.offset(originCF, 0, 2.5, -6.5),  model, "BackWall")
	AB.block(Vector3.new(1,  4, 14), TEAL_50S, AB.offset(originCF, -8.5, 2.5, 0), model, "LeftWall")
	AB.block(Vector3.new(1,  4, 14), TEAL_50S, AB.offset(originCF,  8.5, 2.5, 0), model, "RightWall")

	-- Open service counter front (just a low wall)
	AB.block(Vector3.new(18, 2, 1), TEAL_50S, AB.offset(originCF, 0, 1.5, 6.5), model, "Counter")
	-- Counter chrome top
	local counterTop = AB.block(
		Vector3.new(18, 0.3, 1.4),
		CHROME,
		AB.offset(originCF, 0, 2.7, 6.5),
		model,
		"CounterTop"
	)
	counterTop.Material   = Enum.Material.Metal
	counterTop.Reflectance = 0.3

	-- Roof posts (mid-century cantilever — 2 angled posts)
	AB.block(Vector3.new(0.6, 8, 0.6), CHROME, AB.offset(originCF, -7, 6, -5), model, "PostL")
	AB.block(Vector3.new(0.6, 8, 0.6), CHROME, AB.offset(originCF,  7, 6, -5), model, "PostR")

	-- Roof (slanted slab — single flat block, suggested with slight Z tilt via CFrame)
	local roof = AB.block(
		Vector3.new(22, 0.6, 18),
		CREAM,
		AB.offset(originCF, 0, 10, 1) * CFrame.Angles(math.rad(-8), 0, 0),
		model,
		"Roof"
	)
	roof.Material = Enum.Material.SmoothPlastic

	-- Giant milkshake icon on top (signature visual)
	-- Glass
	local iconGlass = AB.cylinder(
		2.0, 4.0,
		Color3.fromRGB(240, 240, 250),
		AB.offset(originCF, 0, 13, 0),
		model,
		"IconGlass"
	)
	iconGlass.Material     = Enum.Material.SmoothPlastic
	iconGlass.Reflectance  = 0.2
	-- Shake liquid
	AB.cylinder(1.8, 3.4, AB.colors.strawberry, AB.offset(originCF, 0, 12.9, 0), model, "IconShake")
	-- Whipped cream dome
	AB.sphere(2.2, CREAM, AB.offset(originCF, 0, 15.2, 0), model, "IconCream")
	-- Cherry
	AB.sphere(0.7, Color3.fromRGB(180, 30, 40), AB.offset(originCF, 0, 16.4, 0), model, "IconCherry")

	-- "SHAKES" neon sign
	local sign = AB.block(
		Vector3.new(9, 1.6, 0.4),
		NEON_RED,
		AB.offset(originCF, 0, 4.5, -6.0),
		model,
		"ShakesSign"
	)
	AB.neon(sign)
	AB.glow(sign, sign.Color, 2.0)

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
