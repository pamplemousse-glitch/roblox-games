-- Kenji — Tokyo sushi-shop worker. R6 rig in dark indigo shirt + vermilion hachimaki.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME = "Kenji"

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = Color3.fromRGB(255, 220, 180),
		shirt = Color3.fromRGB(60, 60, 90),
		pants = Color3.fromRGB(35, 30, 35),
	})
	AB.r6Hat(rig, Vector3.new(2.05, 0.3, 1.05), Color3.fromRGB(200, 50, 40), -0.3, "Headband")
	AB.r6Hat(rig, Vector3.new(2.05, 0.55, 1.05), Color3.fromRGB(35, 30, 30), 0.55, "Hair")
	AB.r6NameTag(rig, NAME)
	return rig
end
