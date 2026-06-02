-- Bowing Shopkeeper — R6 rig in navy happi coat + grey trousers + grey hair.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME = "Shopkeeper"

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF, NAME, {
		skin  = Color3.fromRGB(255, 220, 180),
		shirt = Color3.fromRGB(40, 50, 90),
		pants = Color3.fromRGB(80, 80, 90),
	})
	local torso = rig:FindFirstChild("Torso")
	if torso then
		-- White sash trim
		local trim = Instance.new("Part")
		trim.Name = "HappiTrim"
		trim.Size = Vector3.new(2.05, 0.3, 1.05)
		trim.Color = Color3.fromRGB(245, 240, 230)
		trim.Material = Enum.Material.SmoothPlastic
		trim.Anchored = true
		trim.CanCollide = false
		trim.CFrame = torso.CFrame * CFrame.new(0, 0.7, 0)
		trim.Parent = rig
		local w = Instance.new("WeldConstraint"); w.Part0 = torso; w.Part1 = trim; w.Parent = trim
	end
	AB.r6Hat(rig, Vector3.new(2.05, 0.35, 1.05), Color3.fromRGB(150, 145, 140), 0.45, "Hair")
	AB.r6NameTag(rig, NAME)
	return rig
end
