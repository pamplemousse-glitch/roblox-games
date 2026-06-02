-- Bicycle Schoolgirl — R6 rig in sailor uniform, with a small static bicycle frame
-- below her (kept primitive — the bike isn't a rig).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME = "BicycleGirl"

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r6Rig(parent, originCF, NAME, {
		skin  = Color3.fromRGB(255, 220, 180),
		shirt = Color3.fromRGB(245, 240, 230),
		pants = Color3.fromRGB(35, 45, 80),
	})
	local torso = rig:FindFirstChild("Torso")
	if torso then
		local collar = Instance.new("Part")
		collar.Name = "SailorCollar"
		collar.Size = Vector3.new(2.05, 0.4, 1.05)
		collar.Color = Color3.fromRGB(50, 60, 100)
		collar.Material = Enum.Material.SmoothPlastic
		collar.Anchored = true
		collar.CanCollide = false
		collar.CFrame = torso.CFrame * CFrame.new(0, 0.8, 0)
		collar.Parent = rig
		local w = Instance.new("WeldConstraint"); w.Part0 = torso; w.Part1 = collar; w.Parent = collar
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
	-- Simple bicycle frame at her feet (decorative)
	local hrp = rig:FindFirstChild("HumanoidRootPart")
	if hrp then
		local function bikePart(name, size, color, offset, shape)
			local p = Instance.new("Part")
			p.Name = name
			p.Size = size
			p.Color = color
			p.Material = Enum.Material.SmoothPlastic
			p.Anchored = true
			p.CanCollide = false
			p.CFrame = hrp.CFrame * CFrame.new(offset)
			if shape then p.Shape = shape end
			p.Parent = rig
		end
		bikePart("BikeFrame",  Vector3.new(0.3, 0.3, 3.5), Color3.fromRGB(80, 130, 180), Vector3.new(0, -2.6, 0))
		bikePart("WheelFront", Vector3.new(2, 2, 0.3),     Color3.fromRGB(45, 40, 40),    Vector3.new(0, -3, 1.8))
		bikePart("WheelBack",  Vector3.new(2, 2, 0.3),     Color3.fromRGB(45, 40, 40),    Vector3.new(0, -3, -1.8))
		bikePart("Basket",     Vector3.new(1.2, 0.8, 1.0), Color3.fromRGB(180, 150, 100), Vector3.new(0, -1.6, 2.2))
	end
	AB.r6NameTag(rig, NAME)
	return rig
end
