-- BalletDancerKid — R6 rig in pink leotard + tutu disc + bun + ballet slipper accents.

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
	local rig = AB.r6Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin     = Color3.fromRGB(250, 220, 200),
		shirt    = DEEP,   -- pink leotard
		leftLeg  = Color3.fromRGB(250, 220, 200),  -- tights = skin
		rightLeg = Color3.fromRGB(250, 220, 200),
	})
	local torso = rig:FindFirstChild("Torso") :: BasePart
	if torso then
		-- Tutu disc at waist — tall flat cylinder
		weldTo(rig, torso, "Tutu",     Vector3.new(3.6, 0.4, 3.6), PINK, CFrame.new(0, -1.0, 0), Enum.PartType.Cylinder)
		weldTo(rig, torso, "TutuUnder",Vector3.new(3.6, 0.3, 3.6), DEEP, CFrame.new(0, -1.25, 0), Enum.PartType.Cylinder)
		-- Cream straps over shoulders
		weldTo(rig, torso, "StrapL", Vector3.new(0.2, 1.0, 0.95), Color3.fromRGB(255, 240, 220), CFrame.new(-0.55, 0.5, 0))
		weldTo(rig, torso, "StrapR", Vector3.new(0.2, 1.0, 0.95), Color3.fromRGB(255, 240, 220), CFrame.new( 0.55, 0.5, 0))
	end
	-- Ballet slipper detail (cylinder ring on each leg)
	for _, side in {"Left", "Right"} do
		local leg = rig:FindFirstChild(side .. " Leg") :: BasePart
		if leg then
			weldTo(rig, leg, "Slipper_" .. side, Vector3.new(1.05, 0.3, 1.05), PINK, CFrame.new(0, -0.85, 0))
			-- Ribbon laces wrap up shin
			for i = 1, 2 do
				weldTo(rig, leg, "Ribbon_" .. side .. "_" .. i, Vector3.new(1.08, 0.1, 0.1), DEEP,
					CFrame.new(0, -0.4 + (i - 1) * 0.4, 0) * CFrame.Angles(0, 0, math.rad(i * 30)))
			end
		end
	end
	-- Hair (bun back)
	AB.r6Hat(rig, Vector3.new(2.1, 0.7, 1.1), HAIR, 0.55, "Hair")
	-- Bun
	AB.r6Hat(rig, Vector3.new(0.9, 0.9, 0.9), HAIR, 1.1, "Bun", Enum.PartType.Ball)
	-- Pink flower on bun
	AB.r6Hat(rig, Vector3.new(0.35, 0.35, 0.35), DEEP, 1.55, "BunFlower", Enum.PartType.Ball)
	AB.r6NameTag(rig, NAME)
	return rig
end
