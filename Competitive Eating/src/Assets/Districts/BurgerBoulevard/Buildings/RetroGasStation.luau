-- RetroGasStation — vintage gas pump, repurposed as condiment station.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CHROME   = Color3.fromRGB(176, 176, 176)
local TEAL_50S = Color3.fromRGB(127, 202, 194)
local CREAM    = Color3.fromRGB(255, 245, 232)
local NEON_RED = Color3.fromRGB(255, 48, 48)
local MUSTARD  = Color3.fromRGB(220, 175, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RetroGasStation", parent)

	-- Concrete pad
	local pad = AB.block(
		Vector3.new(20, 0.3, 16),
		Color3.fromRGB(180, 180, 175),
		AB.offset(originCF, 0, 0.15, 0),
		model,
		"Pad"
	)
	pad.Material = Enum.Material.Concrete

	-- Canopy posts (2 chrome columns)
	AB.cylinder(0.8, 10, CHROME, AB.offset(originCF, -7, 5, -2), model, "PostL")
	AB.cylinder(0.8, 10, CHROME, AB.offset(originCF,  7, 5, -2), model, "PostR")

	-- Canopy roof (teal slab)
	AB.block(
		Vector3.new(20, 0.8, 12),
		TEAL_50S,
		AB.offset(originCF, 0, 10.5, -1),
		model,
		"Canopy"
	)

	-- Canopy cream trim
	AB.block(Vector3.new(20, 0.5, 0.3), CREAM, AB.offset(originCF, 0, 10.0, 4.9), model, "TrimFront")
	AB.block(Vector3.new(20, 0.5, 0.3), CREAM, AB.offset(originCF, 0, 10.0, -6.9), model, "TrimBack")

	-- Gas pump body (mustard yellow, repurposed as condiment dispenser)
	local pumpBody = AB.block(
		Vector3.new(2.8, 5, 2),
		MUSTARD,
		AB.offset(originCF, -2, 2.5, 2),
		model,
		"PumpBody"
	)

	-- Pump top (rounded — sphere half)
	AB.sphere(2.8, MUSTARD, AB.offset(originCF, -2, 5.2, 2), model, "PumpTop")

	-- Pump display window
	AB.block(
		Vector3.new(2.2, 1.5, 0.1),
		Color3.fromRGB(40, 40, 50),
		AB.offset(originCF, -2, 3.5, 3.05),
		model,
		"PumpDisplay"
	)

	-- Pump nozzle hanging on side (a small cylinder)
	AB.cylinder(0.5, 1.5, CHROME, AB.offset(originCF, -0.4, 2.0, 2.0), model, "Nozzle")
	-- Hose (a curved cylinder, simplified as a thin straight one)
	AB.cylinder(0.2, 2.5, Color3.fromRGB(40, 40, 40), AB.offset(originCF, 0.6, 1.5, 2.0) * CFrame.Angles(0, 0, math.rad(-45)), model, "Hose")

	-- Ketchup pump (red, mirroring the gas pump)
	local ketchupBody = AB.block(
		Vector3.new(2.8, 5, 2),
		NEON_RED,
		AB.offset(originCF, 4, 2.5, 2),
		model,
		"KetchupBody"
	)
	AB.sphere(2.8, NEON_RED, AB.offset(originCF, 4, 5.2, 2), model, "KetchupTop")
	AB.block(
		Vector3.new(2.2, 1.5, 0.1),
		Color3.fromRGB(40, 40, 50),
		AB.offset(originCF, 4, 3.5, 3.05),
		model,
		"KetchupDisplay"
	)
	AB.cylinder(0.5, 1.5, CHROME, AB.offset(originCF, 5.6, 2.0, 2.0), model, "KetchupNozzle")

	-- "FUEL UP" neon sign hanging from canopy
	local sign = AB.block(
		Vector3.new(8, 1.6, 0.4),
		NEON_RED,
		AB.offset(originCF, 0, 9, 4.5),
		model,
		"FuelUpSign"
	)
	AB.neon(sign)
	AB.glow(sign, sign.Color, 2.5)

	AB.pivot(model, pad)
	AB.weldAll(model)
	return model
end
