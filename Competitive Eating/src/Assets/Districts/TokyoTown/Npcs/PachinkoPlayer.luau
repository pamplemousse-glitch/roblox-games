-- Pachinko Player — R6 rig in navy tracksuit, dark cap, grey hair.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME = "Player"

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = Color3.fromRGB(255, 220, 180),
		shirt = Color3.fromRGB(45, 55, 90),
		pants = Color3.fromRGB(45, 55, 90),
	})
	local torso = rig:FindFirstChild("Torso")
	if torso then
		-- White tracksuit stripe down the side
		for _, side in {-1, 1} do
			local stripe = Instance.new("Part")
			stripe.Name = "TrackStripe_" .. (side == -1 and "L" or "R")
			stripe.Size = Vector3.new(0.15, 1.8, 1.08)
			stripe.Color = Color3.fromRGB(245, 240, 230)
			stripe.Material = Enum.Material.SmoothPlastic
			stripe.Anchored = true
			stripe.CanCollide = false
			stripe.CFrame = torso.CFrame * CFrame.new(side * 0.95, 0, 0)
			stripe.Parent = rig
			local w = Instance.new("WeldConstraint"); w.Part0 = torso; w.Part1 = stripe; w.Parent = stripe
		end
	end
	AB.r6Hat(rig, Vector3.new(2.05, 0.4, 1.05), Color3.fromRGB(140, 135, 130), 0.45, "Hair")
	AB.r6Hat(rig, Vector3.new(2.15, 0.5, 1.15), Color3.fromRGB(60, 55, 60), 0.85, "Cap")
	AB.r6NameTag(rig, NAME)
	return rig
end
