-- Beer Keg — short fat steel keg lying on its side with a wooden tap. Classic.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STEEL     = Color3.fromRGB(150, 150, 155)
local STEEL_D   = Color3.fromRGB(110, 110, 115)
local DARK_WOOD = Color3.fromRGB(70, 45, 22)
local BRASS     = Color3.fromRGB(190, 145, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BeerKeg", parent)

	-- Keg body (vertical cylinder)
	local body = AB.cylinder(3.5, 4, STEEL, AB.offset(originCF, 0, 2, 0), model, "Body")
	-- Top + bottom rims
	AB.cylinder(3.7, 0.3, STEEL_D, AB.offset(originCF, 0, 3.9, 0), model, "RimTop")
	AB.cylinder(3.7, 0.3, STEEL_D, AB.offset(originCF, 0, 0.1, 0), model, "RimBot")
	-- Middle band
	AB.cylinder(3.6, 0.3, STEEL_D, AB.offset(originCF, 0, 2, 0), model, "RimMid")

	-- Top tap fitting (brass cap)
	AB.cylinder(0.9, 0.6, BRASS, AB.offset(originCF, 0, 4.2, 0), model, "TapCap")
	-- Wooden tap handle sticking up
	AB.block(Vector3.new(0.4, 1.8, 0.4), DARK_WOOD, AB.offset(originCF, 0, 5.4, 0), model, "TapHandle")
	AB.sphere(0.6, DARK_WOOD, AB.offset(originCF, 0, 6.5, 0), model, "TapKnob")

	-- Side spigot (small brass tube)
	AB.cylinder(0.4, 1.2, BRASS, AB.offset(originCF, 0, 1, 1.5) * CFrame.Angles(math.rad(90), 0, math.rad(90)), model, "Spigot")
	AB.cylinder(0.5, 0.4, BRASS, AB.offset(originCF, 0, 1, 2.0) * CFrame.Angles(math.rad(90), 0, math.rad(90)), model, "SpigotTip")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
