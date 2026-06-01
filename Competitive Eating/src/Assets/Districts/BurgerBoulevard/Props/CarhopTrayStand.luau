-- CarhopTrayStand — a server tray on a tall chrome stand, with a burger + shake sitting on it.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CarhopTrayStand", parent)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local RED    = Color3.fromRGB(220, 50, 50)
	local PINK   = Color3.fromRGB(255, 200, 215)

	-- Base disc
	AB.cylinder(2, 0.3, CHROME, AB.offset(originCF, 0, 0.15, 0), model, "Base").Material = Enum.Material.Metal
	-- Central pole
	AB.cylinder(0.4, 4.5, CHROME, AB.offset(originCF, 0, 2.55, 0), model, "Pole").Material = Enum.Material.Metal
	-- Tray (round, slightly bigger)
	local tray = AB.cylinder(3, 0.2, CHROME, AB.offset(originCF, 0, 5, 0), model, "Tray")
	tray.Material = Enum.Material.Metal
	tray.Reflectance = 0.15
	-- Edge lip
	AB.cylinder(3.1, 0.4, CHROME, AB.offset(originCF, 0, 5.1, 0), model, "TrayLip")
	-- Food on tray: burger + shake
	-- Burger (cylinder stack)
	AB.cylinder(1.1, 0.3, AB.colors.bunTan, AB.offset(originCF, -0.7, 5.3, 0), model, "BurgerBunBot")
	AB.cylinder(1.2, 0.25, AB.colors.burgerBrown, AB.offset(originCF, -0.7, 5.55, 0), model, "BurgerPatty")
	AB.cylinder(1.0, 0.2, AB.colors.cheese, AB.offset(originCF, -0.7, 5.75, 0), model, "BurgerCheese")
	AB.cylinder(1.05, 0.15, AB.colors.lettuce, AB.offset(originCF, -0.7, 5.9, 0), model, "BurgerLettuce")
	AB.sphere(1.1, AB.colors.bunTan, AB.offset(originCF, -0.7, 6.1, 0), model, "BurgerBunTop")
	-- Milkshake glass (transparent + pink content)
	local glass = AB.cylinder(0.8, 1.6, Color3.fromRGB(220, 240, 255), AB.offset(originCF, 0.9, 6, 0), model, "Glass")
	glass.Material = Enum.Material.Glass; glass.Transparency = 0.4
	AB.cylinder(0.65, 1.3, PINK, AB.offset(originCF, 0.9, 5.95, 0), model, "ShakeContent")
	-- Whipped cream
	AB.sphere(0.7, Color3.fromRGB(245, 245, 240), AB.offset(originCF, 0.9, 6.9, 0), model, "Whip")
	-- Cherry
	AB.sphere(0.2, RED, AB.offset(originCF, 0.9, 7.3, 0), model, "Cherry")
	-- Straw
	AB.cylinder(0.1, 1.5, RED, AB.offset(originCF, 1.1, 7, 0), model, "Straw")

	AB.pivot(model, model:FindFirstChild("Base"))
	AB.weldAll(model)
	return model
end
