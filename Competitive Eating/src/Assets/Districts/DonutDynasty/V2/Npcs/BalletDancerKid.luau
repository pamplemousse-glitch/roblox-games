-- BalletDancerKid — R15 rig in pink leotard + tutu disc + bun + ballet slipper accents.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME  = "BalletDancerKid"
local PINK  = Color3.fromRGB(255, 200, 214)
local DEEP  = Color3.fromRGB(232, 130, 165)
local HAIR  = Color3.fromRGB(70, 45, 30)

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
		skin     = Color3.fromRGB(250, 220, 200),
		shirt    = DEEP,   -- pink leotard
		leftLeg  = Color3.fromRGB(250, 220, 200),  -- tights = skin
		rightLeg = Color3.fromRGB(250, 220, 200),
	})
	-- Torso accessories ride on HumanoidRootPart so existing R6 Torso offsets work.
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Tutu disc at waist — tall flat cylinder
		weldTo(rig, hrp, "Tutu",     Vector3.new(3.6, 0.4, 3.6), PINK, CFrame.new(0, -1.0, 0), Enum.PartType.Cylinder)
		weldTo(rig, hrp, "TutuUnder",Vector3.new(3.6, 0.3, 3.6), DEEP, CFrame.new(0, -1.25, 0), Enum.PartType.Cylinder)
		-- Cream straps over shoulders
		weldTo(rig, hrp, "StrapL", Vector3.new(0.2, 1.0, 0.95), Color3.fromRGB(255, 240, 220), CFrame.new(-0.55, 0.5, 0))
		weldTo(rig, hrp, "StrapR", Vector3.new(0.2, 1.0, 0.95), Color3.fromRGB(255, 240, 220), CFrame.new( 0.55, 0.5, 0))
	end
	-- Ballet slipper detail. R6 leg was a single part centered at world Y=-2;
	-- R15 splits the leg into UpperLeg/LowerLeg/Foot. Slipper goes on the Foot
	-- (foot center Y=-2.8, slipper world Y=-2.85 → offset -0.05). Ribbons wrap
	-- the shin → attach to LowerLeg (center Y=-1.9 vs old leg center Y=-2.0,
	-- so each ribbon's Y offset shifts by -0.1).
	for _, side in {"Left", "Right"} do
		local foot     = rig:FindFirstChild(side .. "Foot")     :: BasePart
		local lowerLeg = rig:FindFirstChild(side .. "LowerLeg") :: BasePart
		if foot then
			weldTo(rig, foot, "Slipper_" .. side, Vector3.new(1.05, 0.3, 1.05), PINK, CFrame.new(0, -0.05, 0))
		end
		if lowerLeg then
			-- Ribbon laces wrap up shin
			for i = 1, 2 do
				weldTo(rig, lowerLeg, "Ribbon_" .. side .. "_" .. i, Vector3.new(1.08, 0.1, 0.1), DEEP,
					CFrame.new(0, -0.5 + (i - 1) * 0.4, 0) * CFrame.Angles(0, 0, math.rad(i * 30)))
			end
		end
	end
	-- Hair (bun back)
	AB.r15Hat(rig, Vector3.new(2.1, 0.7, 1.1), HAIR, 0.55, "Hair")
	-- Bun
	AB.r15Hat(rig, Vector3.new(0.9, 0.9, 0.9), HAIR, 1.1, "Bun", Enum.PartType.Ball)
	-- Pink flower on bun
	AB.r15Hat(rig, Vector3.new(0.35, 0.35, 0.35), DEEP, 1.55, "BunFlower", Enum.PartType.Ball)
	AB.r15NameTag(rig, NAME)
	return rig
end
