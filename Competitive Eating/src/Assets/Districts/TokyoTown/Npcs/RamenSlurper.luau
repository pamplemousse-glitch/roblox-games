-- Ramen Slurper — R6 rig, casual blue t-shirt + jeans.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME = "Slurper"

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF, NAME, {
		skin  = Color3.fromRGB(255, 220, 180),
		shirt = Color3.fromRGB(80, 120, 170),
		pants = Color3.fromRGB(60, 70, 110),
	})
	AB.r6Hat(rig, Vector3.new(2.05, 0.55, 1.05), Color3.fromRGB(40, 30, 30), 0.55, "Hair")
	AB.r6NameTag(rig, NAME)
	return rig
end
