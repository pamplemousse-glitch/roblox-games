-- MarshmallowOttoman — soft cream-colored cylindrical seat with a
-- toasted golden top (suggesting a roasted marshmallow).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CREAM  = Color3.fromRGB(255, 240, 220)
local GOLD   = Color3.fromRGB(212, 168, 82)
local PINK   = Color3.fromRGB(255, 200, 214)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MarshmallowOttoman", parent)

	-- Body (puffy cylinder)
	local body = AB.cylinder(4.2, 3, CREAM,
		AB.offset(originCF, 0, 1.5, 0), model, "Body")

	-- Toasted top
	AB.cylinder(4.3, 0.6, GOLD,
		AB.offset(originCF, 0, 3.2, 0), model, "ToastedTop")

	-- Soft pillow rim
	AB.cylinder(4.5, 0.8, CREAM,
		AB.offset(originCF, 0, 2.9, 0), model, "TopRim")
	AB.cylinder(4.5, 0.8, CREAM,
		AB.offset(originCF, 0, 0.2, 0), model, "BottomRim")

	-- Pink tassel decoration
	AB.block(Vector3.new(0.3, 0.4, 0.3), PINK,
		AB.offset(originCF, 1.9, 1.7, 0), model, "Tassel")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
