-- Schoolgirl Bento — R6 sailor-uniform schoolgirl.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME = "Schoolgirl"

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF, NAME, {
		skin  = Color3.fromRGB(255, 220, 180),
		shirt = Color3.fromRGB(245, 240, 230),    -- white sailor top
		pants = Color3.fromRGB(35, 45, 80),       -- navy skirt
	})
	local torso = rig:FindFirstChild("Torso")
	if torso then
		-- Navy sailor collar across top of shoulders
		local collar = Instance.new("Part")
		collar.Name = "SailorCollar"
		collar.Size = Vector3.new(2.05, 0.4, 1.05)
		collar.Color = Color3.fromRGB(50, 60, 100)
		collar.Material = Enum.Material.SmoothPlastic
		collar.Anchored = true
		collar.CanCollide = false
		collar.CFrame = torso.CFrame * CFrame.new(0, 0.8, 0)
		collar.Parent = rig
		local w1 = Instance.new("WeldConstraint"); w1.Part0 = torso; w1.Part1 = collar; w1.Parent = collar
		-- Red tie ribbon
		local tie = Instance.new("Part")
		tie.Name = "Tie"
		tie.Size = Vector3.new(0.7, 0.4, 1.07)
		tie.Color = Color3.fromRGB(200, 50, 50)
		tie.Material = Enum.Material.SmoothPlastic
		tie.Anchored = true
		tie.CanCollide = false
		tie.CFrame = torso.CFrame * CFrame.new(0, 0.55, 0)
		tie.Parent = rig
		local w2 = Instance.new("WeldConstraint"); w2.Part0 = torso; w2.Part1 = tie; w2.Parent = tie
	end
	AB.r6Hat(rig, Vector3.new(2.05, 1.5, 0.5), Color3.fromRGB(40, 30, 30), -0.3, "HairBack")
	AB.r6Hat(rig, Vector3.new(2.05, 0.5, 1.05), Color3.fromRGB(40, 30, 30), 0.55, "HairTop")
	AB.r6NameTag(rig, NAME)
	return rig
end
