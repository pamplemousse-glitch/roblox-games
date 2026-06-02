-- Capsule Hotel Guest — R6 rig in grey-blue hoodie + dark jeans.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME = "Guest"

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = Color3.fromRGB(255, 220, 180),
		shirt = Color3.fromRGB(70, 90, 110),
		pants = Color3.fromRGB(60, 70, 110),
	})
	-- Hood block above head
	AB.r6Hat(rig, Vector3.new(2.2, 0.7, 1.2), Color3.fromRGB(50, 65, 85), 0.6, "Hood")
	AB.r6Hat(rig, Vector3.new(2.05, 0.4, 1.05), Color3.fromRGB(40, 30, 30), 0.3, "Hair")
	AB.r6NameTag(rig, NAME)
	return rig
end
