-- Riku — Tokyo NPC. R6 rig with indigo blue jacket + paper white apron.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME = "Riku"

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = Color3.fromRGB(245, 210, 175),
		shirt = Color3.fromRGB(60, 90, 140),
		pants = Color3.fromRGB(50, 50, 60),
	})
	local torso = rig:FindFirstChild("Torso")
	if torso then
		local apron = Instance.new("Part")
		apron.Name      = "Apron"
		apron.Size      = Vector3.new(1.4, 1.6, 1.1)
		apron.Color     = Color3.fromRGB(245, 240, 230)
		apron.Material  = Enum.Material.SmoothPlastic
		apron.Anchored  = true
		apron.CanCollide= false
		apron.CFrame    = torso.CFrame * CFrame.new(0, -0.1, -0.05)
		apron.Parent    = rig
		local w = Instance.new("WeldConstraint"); w.Part0 = torso; w.Part1 = apron; w.Parent = apron
	end
	AB.r6Hat(rig, Vector3.new(2.05, 0.55, 1.05), Color3.fromRGB(30, 25, 25), 0.55, "Hair")
	AB.r6NameTag(rig, NAME)
	return rig
end
