-- DonaRosa — R15 retrofit (polish A): green dress, red shawl, silver bun, rosary.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME        = "DonaRosa"
local SKIN        = Color3.fromRGB(215, 170, 130)
local DRESS_GREEN = Color3.fromRGB(93, 168, 85)
local SHAWL_RED   = Color3.fromRGB(180, 50, 50)
local SHAWL_TRIM  = Color3.fromRGB(255, 184, 52)
local HAIR_GREY   = Color3.fromRGB(180, 175, 170)
local HAIR_DARK   = Color3.fromRGB(60, 45, 40)
local EYE_DARK    = Color3.fromRGB(50, 35, 25)
local MOUTH_PINK  = Color3.fromRGB(160, 90, 70)
local ROSARY_GOLD = Color3.fromRGB(220, 180, 70)

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
		skin  = SKIN,
		shirt = DRESS_GREEN,
		pants = DRESS_GREEN,
	})

	-- Shawl across shoulders + yellow trim + embroidery dots
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		weldTo(rig, hrp, "Shawl",     Vector3.new(2.6, 1.4, 1.3), SHAWL_RED,  CFrame.new(0, 0.9, 0))
		weldTo(rig, hrp, "ShawlTrim", Vector3.new(2.65, 0.2, 1.35), SHAWL_TRIM, CFrame.new(0, 0.2, 0))
		-- Embroidered floral dots on shawl
		weldTo(rig, hrp, "Embroidery_1", Vector3.new(0.22, 0.22, 0.08), SHAWL_TRIM, CFrame.new(-0.85, 1.05, 0.55), Enum.PartType.Ball)
		weldTo(rig, hrp, "Embroidery_2", Vector3.new(0.22, 0.22, 0.08), SHAWL_TRIM, CFrame.new( 0.85, 1.05, 0.55), Enum.PartType.Ball)
		weldTo(rig, hrp, "Embroidery_3", Vector3.new(0.22, 0.22, 0.08), SHAWL_TRIM, CFrame.new( 0,    1.4,  0.55), Enum.PartType.Ball)
		weldTo(rig, hrp, "Embroidery_4", Vector3.new(0.22, 0.22, 0.08), SHAWL_TRIM, CFrame.new(-0.85, 1.4,  0.55), Enum.PartType.Ball)
		weldTo(rig, hrp, "Embroidery_5", Vector3.new(0.22, 0.22, 0.08), SHAWL_TRIM, CFrame.new( 0.85, 1.4,  0.55), Enum.PartType.Ball)
	end

	-- Face: kind eyes, wrinkle hints, warm smile
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "Eye_L",     Vector3.new(0.16, 0.16, 0.16), EYE_DARK,   CFrame.new(-0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Eye_R",     Vector3.new(0.16, 0.16, 0.16), EYE_DARK,   CFrame.new( 0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Wrinkle_L", Vector3.new(0.2, 0.05, 0.05),  HAIR_DARK,  CFrame.new(-0.55, 0.0, 0.5))
		weldTo(rig, head, "Wrinkle_R", Vector3.new(0.2, 0.05, 0.05),  HAIR_DARK,  CFrame.new( 0.55, 0.0, 0.5))
		weldTo(rig, head, "Mouth",     Vector3.new(0.7, 0.12, 0.12),  MOUTH_PINK, CFrame.new(0, -0.4, 0.5))
		-- Silver bun + streak
		weldTo(rig, head, "Bun",        Vector3.new(1.0, 1.0, 1.0), HAIR_GREY, CFrame.new(0, 0.7, -0.9),  Enum.PartType.Ball)
		weldTo(rig, head, "HairStreak", Vector3.new(0.3, 1.2, 1.6), HAIR_DARK, CFrame.new(0.7, 0.15, -0.2))
	end

	-- Hair cap
	AB.r15Hat(rig, Vector3.new(1.9, 1.9, 1.9), HAIR_GREY, 0.1, "Hair", Enum.PartType.Ball)

	-- Rosary draped from hands
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		for i = 1, 5 do
			weldTo(rig, rHand, "Bead_" .. i, Vector3.new(0.18, 0.18, 0.18), ROSARY_GOLD,
				CFrame.new(-0.1 + (i - 1) * 0.05, -(i - 1) * 0.18, 0.3), Enum.PartType.Ball)
		end
		weldTo(rig, rHand, "Cross", Vector3.new(0.12, 0.5, 0.05), ROSARY_GOLD,
			CFrame.new(0.15, -1.0, 0.3))
	end

	AB.r15NameTag(rig, "Doña Rosa")
	return rig
end
