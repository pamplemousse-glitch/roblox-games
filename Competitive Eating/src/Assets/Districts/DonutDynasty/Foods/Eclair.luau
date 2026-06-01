-- Eclair — cream-filled pastry log topped with a glossy chocolate slab.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CREAM     = Color3.fromRGB(255, 240, 220)
local CHOCOLATE = Color3.fromRGB(92, 57, 36)
local DOUGH     = Color3.fromRGB(225, 185, 130)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Eclair", parent)

	-- Pastry body — a horizontal cylinder log lying on its side
	-- cylinder() makes it stand up, so we rotate after with the cf arg
	local body = AB.part({
		size     = Vector3.new(6, 1.6, 1.6),
		color    = DOUGH,
		cf       = AB.offset(originCF, 0, 1.0, 0),
		shape    = Enum.PartType.Cylinder,
		name     = "Pastry",
	}, model)

	-- Cream filling visible as a lighter stripe along the side
	AB.block(
		Vector3.new(5.6, 0.4, 0.5),
		CREAM,
		AB.offset(originCF, 0, 1.0, 0.7),
		model,
		"CreamFilling"
	)

	-- Chocolate top glaze
	AB.block(
		Vector3.new(5.6, 0.3, 1.3),
		CHOCOLATE,
		AB.offset(originCF, 0, 1.85, 0),
		model,
		"ChocoTop"
	)

	-- A subtle gloss highlight on the chocolate
	local gloss = AB.block(
		Vector3.new(4.8, 0.05, 0.4),
		Color3.fromRGB(150, 100, 70),
		AB.offset(originCF, 0, 2.02, -0.2),
		model,
		"Gloss"
	)
	gloss.Material = Enum.Material.Glass

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
