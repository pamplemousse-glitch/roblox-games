-- Lamppost50s — googie-style lamppost with a curved arm and a teardrop bulb housing.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Lamppost50s", parent)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local DARK   = Color3.fromRGB(50, 50, 55)
	local TEAL   = Color3.fromRGB(127, 202, 194)
	local NEON_W = Color3.fromRGB(255, 240, 180)

	-- Base + decorative socket
	AB.cylinder(1.2, 0.6, DARK, AB.offset(originCF, 0, 0.3, 0), model, "Base")
	AB.cylinder(1, 1.5, CHROME, AB.offset(originCF, 0, 1.4, 0), model, "Socket")
	-- Tall pole
	local pole = AB.cylinder(0.4, 14, CHROME, AB.offset(originCF, 0, 9, 0), model, "Pole")
	pole.Material = Enum.Material.Metal
	-- Decorative teal collar
	AB.cylinder(0.8, 0.5, TEAL, AB.offset(originCF, 0, 6, 0), model, "Collar")

	-- Curved arm (cheat with 2 blocks at angles)
	AB.cylinder(0.3, 3, CHROME, AB.offset(originCF, 1.5, 15.5, 0) * CFrame.Angles(0, 0, math.rad(60)), model, "ArmStub")
	AB.cylinder(0.3, 2.5, CHROME, AB.offset(originCF, 3, 16, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "ArmHoriz")

	-- Teardrop housing (sphere + cone)
	local housing = AB.sphere(1.8, CHROME, AB.offset(originCF, 4, 15.5, 0), model, "Housing")
	-- Bulb (neon glow)
	local bulb = AB.sphere(1.4, NEON_W, AB.offset(originCF, 4, 14.5, 0), model, "Bulb")
	AB.neon(bulb); AB.glow(bulb, NEON_W, 2.0)

	-- Decorative finial top
	AB.sphere(0.6, CHROME, AB.offset(originCF, 0, 16.5, 0), model, "Finial")
	AB.cylinder(0.2, 1, CHROME, AB.offset(originCF, 0, 17.3, 0), model, "FinialSpike")

	AB.pivot(model, pole)
	AB.weldAll(model)
	return model
end
