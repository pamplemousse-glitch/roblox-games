-- Yumi — Tokyo NPC. R6 rig with pastel pink kimono + dark long hair.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME = "Yumi"

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = Color3.fromRGB(255, 220, 195),
		shirt = Color3.fromRGB(245, 195, 210),   -- pastel pink kimono top
		pants = Color3.fromRGB(220, 170, 185),   -- kimono skirt
	})
	-- Vermilion obi sash
	local head = rig:FindFirstChild("Head")
	local torso = rig:FindFirstChild("Torso")
	if torso then
		local obi = Instance.new("Part")
		obi.Name        = "Obi"
		obi.Size        = Vector3.new(2.05, 0.5, 1.05)
		obi.Color       = Color3.fromRGB(200, 50, 40)
		obi.Material    = Enum.Material.SmoothPlastic
		obi.Anchored    = true
		obi.CanCollide  = false
		obi.CFrame      = torso.CFrame * CFrame.new(0, -0.3, 0)
		obi.Parent      = rig
		local w = Instance.new("WeldConstraint"); w.Part0 = torso; w.Part1 = obi; w.Parent = obi
	end
	-- Long hair back panel
	AB.r6Hat(rig, Vector3.new(2.05, 2, 0.4), Color3.fromRGB(40, 30, 30), -0.6, "HairBack")
	AB.r6Hat(rig, Vector3.new(2.05, 0.6, 1.05), Color3.fromRGB(40, 30, 30), 0.6, "HairTop")
	-- Flower
	if head then
		AB.r6Hat(rig, Vector3.new(0.45, 0.45, 0.45), Color3.fromRGB(255, 180, 70), 0.2, "Flower", Enum.PartType.Ball)
	end
	AB.r6NameTag(rig, NAME)
	return rig
end
