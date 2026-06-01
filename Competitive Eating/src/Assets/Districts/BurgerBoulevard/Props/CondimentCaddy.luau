-- CondimentCaddy — diner-table caddy holding ketchup, mustard, salt + pepper,
-- napkin dispenser, and a sugar canister.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CondimentCaddy", parent)

	local CHROME = Color3.fromRGB(176, 176, 176)
	local KETCHUP = Color3.fromRGB(200, 30, 30)
	local MUSTARD = Color3.fromRGB(220, 175, 50)
	local CREAM   = Color3.fromRGB(255, 245, 232)
	local DARK    = Color3.fromRGB(40, 40, 45)
	local GLASS   = Color3.fromRGB(220, 240, 255)

	-- Chrome caddy base (a small tray)
	local tray = AB.block(Vector3.new(3, 0.3, 2), CHROME, AB.offset(originCF, 0, 0.2, 0), model, "Tray")
	tray.Material = Enum.Material.Metal
	-- Tray edge lip
	AB.block(Vector3.new(3.2, 0.5, 0.2), CHROME, AB.offset(originCF, 0, 0.5, 0.95), model, "LipF")
	AB.block(Vector3.new(3.2, 0.5, 0.2), CHROME, AB.offset(originCF, 0, 0.5, -0.95), model, "LipB")
	AB.block(Vector3.new(0.2, 0.5, 2.2), CHROME, AB.offset(originCF, 1.55, 0.5, 0), model, "LipR")
	AB.block(Vector3.new(0.2, 0.5, 2.2), CHROME, AB.offset(originCF, -1.55, 0.5, 0), model, "LipL")

	-- Ketchup bottle (red squeeze bottle)
	AB.cylinder(0.7, 1.6, KETCHUP, AB.offset(originCF, -1, 1.3, 0.4), model, "KetchupBody")
	AB.cylinder(0.4, 0.4, CHROME, AB.offset(originCF, -1, 2.3, 0.4), model, "KetchupCap")
	-- Mustard bottle (yellow)
	AB.cylinder(0.7, 1.6, MUSTARD, AB.offset(originCF, 0, 1.3, 0.4), model, "MustardBody")
	AB.cylinder(0.4, 0.4, CHROME, AB.offset(originCF, 0, 2.3, 0.4), model, "MustardCap")

	-- Salt + pepper shakers (glass)
	local salt = AB.cylinder(0.5, 1.1, GLASS, AB.offset(originCF, 1, 1, -0.3), model, "Salt")
	salt.Material = Enum.Material.Glass; salt.Transparency = 0.3
	AB.cylinder(0.4, 0.2, CHROME, AB.offset(originCF, 1, 1.7, -0.3), model, "SaltCap")
	local pepper = AB.cylinder(0.5, 1.1, DARK, AB.offset(originCF, 1, 1, 0.5), model, "Pepper")
	AB.cylinder(0.4, 0.2, CHROME, AB.offset(originCF, 1, 1.7, 0.5), model, "PepperCap")

	-- Napkin dispenser (rectangular chrome with napkins inside)
	local napBody = AB.block(Vector3.new(0.8, 1.2, 1.6), CHROME, AB.offset(originCF, -0.5, 1.1, -0.3), model, "NapkinBody")
	napBody.Material = Enum.Material.Metal
	AB.block(Vector3.new(0.2, 1, 1.4), CREAM, AB.offset(originCF, -0.5, 1.1, -0.3), model, "Napkins")

	-- Sugar canister (small chrome jar)
	AB.cylinder(0.6, 1.2, GLASS, AB.offset(originCF, 1.2, 1.1, 0.2), model, "Sugar"):Destroy()
	-- (replace with a single glass canister positioned to one side)
	local sugar = AB.cylinder(0.5, 1, GLASS, AB.offset(originCF, -1.3, 1, -0.5), model, "SugarJar")
	sugar.Material = Enum.Material.Glass; sugar.Transparency = 0.3
	AB.cylinder(0.4, 0.3, CHROME, AB.offset(originCF, -1.3, 1.6, -0.5), model, "SugarCap")

	-- Small "TIP" jar (front of caddy, a little glass jar)
	local tip = AB.cylinder(0.4, 0.9, GLASS, AB.offset(originCF, 0.3, 1, -0.7), model, "TipJar")
	tip.Material = Enum.Material.Glass; tip.Transparency = 0.3

	AB.pivot(model, tray)
	AB.weldAll(model)
	return model
end
