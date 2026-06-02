-- Akemi — Tokyo NPC. R6 rig with deep purple yukata + gold obi + vermilion kanzashi hair pin.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME = "Akemi"

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF, NAME, {
		skin  = Color3.fromRGB(255, 225, 200),
		shirt = Color3.fromRGB(95, 60, 110),
		pants = Color3.fromRGB(80, 45, 95),
	})
	local torso = rig:FindFirstChild("Torso")
	if torso then
		local obi = Instance.new("Part")
		obi.Name        = "Obi"
		obi.Size        = Vector3.new(2.05, 0.5, 1.05)
		obi.Color       = Color3.fromRGB(255, 180, 70)
		obi.Material    = Enum.Material.SmoothPlastic
		obi.Anchored    = true
		obi.CanCollide  = false
		obi.CFrame      = torso.CFrame * CFrame.new(0, -0.2, 0)
		obi.Parent      = rig
		local w = Instance.new("WeldConstraint"); w.Part0 = torso; w.Part1 = obi; w.Parent = obi
	end
	AB.r6Hat(rig, Vector3.new(2.05, 0.6, 1.05), Color3.fromRGB(20, 15, 15), 0.55, "Hair")
	AB.r6Hat(rig, Vector3.new(0.3, 0.5, 0.3), Color3.fromRGB(200, 50, 40), 1.0, "Kanzashi")
	AB.r6NameTag(rig, NAME)
	return rig
end
