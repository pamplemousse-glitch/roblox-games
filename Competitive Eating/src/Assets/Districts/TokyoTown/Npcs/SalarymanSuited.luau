-- Salaryman Suited — Tokyo pedestrian. R6 rig in black suit, white shirt, red tie.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME = "Salaryman"

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF, NAME, {
		skin  = Color3.fromRGB(255, 220, 180),
		shirt = Color3.fromRGB(35, 30, 40),
		pants = Color3.fromRGB(30, 25, 35),
	})
	local torso = rig:FindFirstChild("Torso")
	if torso then
		-- White shirt collar/chest
		local shirt = Instance.new("Part")
		shirt.Name = "Shirt"
		shirt.Size = Vector3.new(0.8, 1.4, 1.05)
		shirt.Color = Color3.fromRGB(245, 240, 230)
		shirt.Material = Enum.Material.SmoothPlastic
		shirt.Anchored = true
		shirt.CanCollide = false
		shirt.CFrame = torso.CFrame * CFrame.new(0, 0.2, 0)
		shirt.Parent = rig
		local w1 = Instance.new("WeldConstraint"); w1.Part0 = torso; w1.Part1 = shirt; w1.Parent = shirt
		-- Red tie
		local tie = Instance.new("Part")
		tie.Name = "Tie"
		tie.Size = Vector3.new(0.3, 1.2, 1.07)
		tie.Color = Color3.fromRGB(200, 50, 50)
		tie.Material = Enum.Material.SmoothPlastic
		tie.Anchored = true
		tie.CanCollide = false
		tie.CFrame = torso.CFrame * CFrame.new(0, 0.1, 0)
		tie.Parent = rig
		local w2 = Instance.new("WeldConstraint"); w2.Part0 = torso; w2.Part1 = tie; w2.Parent = tie
	end
	AB.r6Hat(rig, Vector3.new(2.05, 0.55, 1.05), Color3.fromRGB(30, 25, 25), 0.55, "Hair")
	AB.r6NameTag(rig, NAME)
	return rig
end
