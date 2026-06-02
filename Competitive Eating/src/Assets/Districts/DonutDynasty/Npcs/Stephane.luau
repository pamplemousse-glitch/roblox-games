-- Stéphane — head chef. R15 rig with cream coat + gold trim + silver hair + handlebar mustache + tall toque.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME   = "Stephane"
local CREAM  = Color3.fromRGB(255, 245, 235)
local GOLD   = Color3.fromRGB(212, 168, 82)
local SILVER = Color3.fromRGB(180, 180, 180)

local function weldTo(parent: Model, base: BasePart, name: string, size: Vector3, color: Color3, offset: CFrame, shape: Enum.PartType?): Part
	local p = Instance.new("Part")
	p.Name = name; p.Size = size; p.Color = color
	p.Material = Enum.Material.SmoothPlastic
	p.Anchored = true; p.CanCollide = false
	p.CFrame   = base.CFrame * offset
	if shape then p.Shape = shape end
	p.Parent   = parent
	local w = Instance.new("WeldConstraint"); w.Part0 = base; w.Part1 = p; w.Parent = p
	return p
end

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r15Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = Color3.fromRGB(225, 190, 160),
		shirt = CREAM,
		pants = Color3.fromRGB(50, 45, 55),
	})
	-- Torso accessories ride on HumanoidRootPart so existing R6 Torso offsets work.
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Gold lapel seam down the center + gold waist trim
		weldTo(rig, hrp, "LapelSeam", Vector3.new(0.18, 1.95, 0.05), GOLD, CFrame.new(0, 0, 0.55))
		weldTo(rig, hrp, "WaistTrim", Vector3.new(2.05, 0.22, 1.05), GOLD, CFrame.new(0, -0.9, 0))
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Sideburns
		weldTo(rig, head, "SideburnL", Vector3.new(0.15, 0.4, 0.3), SILVER, CFrame.new(-0.55, -0.1, 0.1))
		weldTo(rig, head, "SideburnR", Vector3.new(0.15, 0.4, 0.3), SILVER, CFrame.new( 0.55, -0.1, 0.1))
		-- Handlebar mustache (bar + curled balls on ends)
		weldTo(rig, head, "Mustache",  Vector3.new(1.0, 0.18, 0.25), SILVER, CFrame.new(0, -0.18, 0.45))
		weldTo(rig, head, "MustacheL", Vector3.new(0.28, 0.28, 0.28), SILVER, CFrame.new(-0.55, -0.12, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "MustacheR", Vector3.new(0.28, 0.28, 0.28), SILVER, CFrame.new( 0.55, -0.12, 0.5), Enum.PartType.Ball)
	end
	AB.r15Hat(rig, Vector3.new(2.1, 0.4, 1.1), SILVER, 0.55, "Hair")
	-- Toque with gold band, tall shaft, puff
	AB.r15Hat(rig, Vector3.new(1.7, 0.35, 1.7), GOLD,  1.0, "ToqueBand")
	AB.r15Hat(rig, Vector3.new(1.5, 1.4, 1.5), CREAM, 1.95, "ToqueShaft", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.0, 1.6, 2.0), CREAM, 2.85, "ToquePuff", Enum.PartType.Ball)
	AB.r15NameTag(rig, NAME)
	return rig
end
