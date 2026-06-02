-- FairyGodmother — R6 rig in deep-pink bodice + pastel-pink skirt + tiara + glowing wand.

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
	local rig = AB.r6Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = Color3.fromRGB(250, 220, 200),
		shirt = DEEP,
		pants = PASTEL,
	})
	local torso = rig:FindFirstChild("Torso") :: BasePart
	if torso then
		-- Cream chest bow
		weldTo(rig, torso, "BowL", Vector3.new(0.55, 0.55, 0.4), CREAM, CFrame.new(-0.35, 0.5, 0.55), Enum.PartType.Ball)
		weldTo(rig, torso, "BowR", Vector3.new(0.55, 0.55, 0.4), CREAM, CFrame.new( 0.35, 0.5, 0.55), Enum.PartType.Ball)
		-- Gold waist trim
		weldTo(rig, torso, "Trim", Vector3.new(2.05, 0.25, 1.05), GOLD, CFrame.new(0, -0.9, 0))
	end
	-- Hair (silver bun back of head)
	AB.r6Hat(rig, Vector3.new(2.1, 0.55, 1.1), SILVER, 0.55, "Hair")
	-- Tiara
	AB.r6Hat(rig, Vector3.new(1.7, 0.25, 1.7), GOLD, 1.0, "Tiara")
	-- Tiara gem
	AB.r6Hat(rig, Vector3.new(0.35, 0.35, 0.35), NEONPK, 1.25, "TiaraGem", Enum.PartType.Ball)
	-- Wand: stick + glowing star tip held to right hand
	local rArm = rig:FindFirstChild("Right Arm") :: BasePart
	if rArm then
		weldTo(rig, rArm, "WandStick", Vector3.new(0.18, 2.6, 0.18), CREAM, CFrame.new(0.2, -1.4, 0.4), Enum.PartType.Cylinder)
		local star = weldTo(rig, rArm, "WandStar", Vector3.new(0.7, 0.7, 0.7), NEONPK, CFrame.new(0.2, -2.6, 0.4), Enum.PartType.Ball, Enum.Material.Neon)
		local light = Instance.new("PointLight"); light.Color = NEONPK; light.Brightness = 3; light.Range = 12; light.Parent = star
		for _, ang in {0, 45, 90, 135} do
			weldTo(rig, rArm, "WandRay_" .. ang, Vector3.new(1.1, 0.18, 0.18), NEONPK,
				CFrame.new(0.2, -2.6, 0.4) * CFrame.Angles(0, 0, math.rad(ang)), nil, Enum.Material.Neon)
		end
	end
	AB.r6NameTag(rig, NAME)
	return rig
end
