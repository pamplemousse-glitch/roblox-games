-- FairyGodmother — R15 rig in deep-pink bodice + pastel-pink skirt + tiara + glowing wand.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "FairyGodmother"
local PASTEL  = Color3.fromRGB(255, 200, 214)
local DEEP    = Color3.fromRGB(232, 130, 165)
local CREAM   = Color3.fromRGB(255, 240, 220)
local GOLD    = Color3.fromRGB(212, 168, 82)
local NEONPK  = Color3.fromRGB(255, 110, 170)
local SILVER  = Color3.fromRGB(220, 220, 230)

local function weldTo(parent: Model, base: BasePart, name: string, size: Vector3, color: Color3, offset: CFrame, shape: Enum.PartType?, material: Enum.Material?): Part
	local p = Instance.new("Part")
	p.Name = name; p.Size = size; p.Color = color
	p.Material   = material or Enum.Material.SmoothPlastic
	p.Anchored   = true; p.CanCollide = false
	p.CFrame     = base.CFrame * offset
	if shape then p.Shape = shape end
	p.Parent     = parent
	local w = Instance.new("WeldConstraint"); w.Part0 = base; w.Part1 = p; w.Parent = p
	return p
end

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r15Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = Color3.fromRGB(250, 220, 200),
		shirt = DEEP,
		pants = PASTEL,
	})
	-- Torso accessories ride on HumanoidRootPart so existing R6 Torso offsets work.
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Cream chest bow
		weldTo(rig, hrp, "BowL", Vector3.new(0.55, 0.55, 0.4), CREAM, CFrame.new(-0.35, 0.5, 0.55), Enum.PartType.Ball)
		weldTo(rig, hrp, "BowR", Vector3.new(0.55, 0.55, 0.4), CREAM, CFrame.new( 0.35, 0.5, 0.55), Enum.PartType.Ball)
		-- Gold waist trim
		weldTo(rig, hrp, "Trim", Vector3.new(2.05, 0.25, 1.05), GOLD, CFrame.new(0, -0.9, 0))
	end
	-- Hair (silver bun back of head)
	AB.r15Hat(rig, Vector3.new(2.1, 0.55, 1.1), SILVER, 0.55, "Hair")
	-- Tiara
	AB.r15Hat(rig, Vector3.new(1.7, 0.25, 1.7), GOLD, 1.0, "Tiara")
	-- Tiara gem
	AB.r15Hat(rig, Vector3.new(0.35, 0.35, 0.35), NEONPK, 1.25, "TiaraGem", Enum.PartType.Ball)
	-- Wand: stick + glowing star tip held in right hand. R6 "Right Arm" was at
	-- local Y=0; R15 RightHand is at local Y=-1.2, so each offset's Y shifts
	-- by +1.2 to preserve the wand's original world position.
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "WandStick", Vector3.new(0.18, 2.6, 0.18), CREAM, CFrame.new(0.2, -0.2, 0.4), Enum.PartType.Cylinder)
		local star = weldTo(rig, rHand, "WandStar", Vector3.new(0.7, 0.7, 0.7), NEONPK, CFrame.new(0.2, -1.4, 0.4), Enum.PartType.Ball, Enum.Material.Neon)
		local light = Instance.new("PointLight"); light.Color = NEONPK; light.Brightness = 3; light.Range = 12; light.Parent = star
		for _, ang in {0, 45, 90, 135} do
			weldTo(rig, rHand, "WandRay_" .. ang, Vector3.new(1.1, 0.18, 0.18), NEONPK,
				CFrame.new(0.2, -1.4, 0.4) * CFrame.Angles(0, 0, math.rad(ang)), nil, Enum.Material.Neon)
		end
	end
	AB.r15NameTag(rig, NAME)
	return rig
end
