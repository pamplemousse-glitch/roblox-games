-- Sushi Chef — Itamae in white chef coat + vermilion hachimaki. R6 rig.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME = "Itamae"

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF, NAME, {
		skin  = Color3.fromRGB(255, 220, 180),
		shirt = Color3.fromRGB(245, 240, 230),
		pants = Color3.fromRGB(220, 215, 200),
	})
	AB.r6Hat(rig, Vector3.new(2.05, 0.3, 1.05), Color3.fromRGB(200, 50, 40), -0.3, "Hachimaki")
	AB.r6Hat(rig, Vector3.new(2.05, 0.5, 1.05), Color3.fromRGB(30, 25, 25), 0.55, "Hair")
	AB.r6NameTag(rig, NAME)
	return rig
end
