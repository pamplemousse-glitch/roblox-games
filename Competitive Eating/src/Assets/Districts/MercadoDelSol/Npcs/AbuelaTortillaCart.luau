-- AbuelaTortillaCart — R15 retrofit (polish A): terracotta dress, pink shawl, bun,
-- glasses, holding a tortilla stack + tortilla cart standing beside her.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME        = "AbuelaTortillaCart"
local SKIN_LIGHT  = Color3.fromRGB(220, 180, 150)
local HAIR_GRAY   = Color3.fromRGB(180, 175, 170)
local TERRACOTTA  = Color3.fromRGB(196, 95, 44)
local CREAM       = Color3.fromRGB(245, 230, 200)
local BOUG_PINK   = Color3.fromRGB(220, 80, 140)
local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local WOOD_LIGHT  = Color3.fromRGB(140, 100, 65)
local BLACK       = Color3.fromRGB(30, 25, 25)
local WHITE       = Color3.fromRGB(245, 240, 235)
local WRINKLE     = Color3.fromRGB(180, 140, 115)
local MOUTH_PINK  = Color3.fromRGB(160, 80, 70)

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
		skin  = SKIN_LIGHT,
		shirt = TERRACOTTA,
		pants = TERRACOTTA,
	})

	-- Cream apron + pink rebozo shawl draped over shoulders
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		weldTo(rig, hrp, "Apron",         Vector3.new(1.8, 1.95, 0.1),   CREAM,     CFrame.new(0, 0, 0.6))
		weldTo(rig, hrp, "Rebozo",        Vector3.new(2.6, 0.6, 1.25),   BOUG_PINK, CFrame.new(0, 1.2, 0))
		weldTo(rig, hrp, "RebozoDrape_L", Vector3.new(0.5, 1.4, 0.3),    BOUG_PINK, CFrame.new(-1.2, 0.5, 0.55))
		weldTo(rig, hrp, "RebozoDrape_R", Vector3.new(0.5, 1.4, 0.3),    BOUG_PINK, CFrame.new( 1.2, 0.5, 0.55))
	end

	-- Face: glasses + wrinkles + smile
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "Wrinkle_L",   Vector3.new(0.5, 0.06, 0.1), WRINKLE, CFrame.new(-0.4, 0.35, 0.5))
		weldTo(rig, head, "Wrinkle_R",   Vector3.new(0.5, 0.06, 0.1), WRINKLE, CFrame.new( 0.4, 0.35, 0.5))
		weldTo(rig, head, "GlassLens_L", Vector3.new(0.35, 0.35, 0.05), WHITE, CFrame.new(-0.35, 0.1, 0.55))
		weldTo(rig, head, "GlassLens_R", Vector3.new(0.35, 0.35, 0.05), WHITE, CFrame.new( 0.35, 0.1, 0.55))
		weldTo(rig, head, "GlassBridge", Vector3.new(0.25, 0.06, 0.05), BLACK, CFrame.new(0, 0.1, 0.55))
		weldTo(rig, head, "Eye_L",       Vector3.new(0.12, 0.12, 0.12), BLACK, CFrame.new(-0.35, 0.1, 0.57), Enum.PartType.Ball)
		weldTo(rig, head, "Eye_R",       Vector3.new(0.12, 0.12, 0.12), BLACK, CFrame.new( 0.35, 0.1, 0.57), Enum.PartType.Ball)
		weldTo(rig, head, "Mouth",       Vector3.new(0.4, 0.1, 0.12),   MOUTH_PINK, CFrame.new(0, -0.35, 0.5))
		-- Hair bun on top, gray cap behind
		weldTo(rig, head, "Bun",  Vector3.new(1.0, 1.0, 1.0), HAIR_GRAY, CFrame.new(0, 0.95, -0.1), Enum.PartType.Ball)
	end

	-- Hair cap dome
	AB.r15Hat(rig, Vector3.new(1.95, 1.95, 1.95), HAIR_GRAY, 0.15, "Hair", Enum.PartType.Ball)

	-- Tortilla stack held in both hands. R15 hand origin local Y=-1.2 — apply +1.2.
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		for i = 1, 4 do
			-- Cylinder lies along X; rotate 90° Z so disc faces up.
			weldTo(rig, rHand, "Tortilla_" .. i, Vector3.new(0.1, 1.5, 1.5), CREAM,
				CFrame.new(0, (i - 1) * 0.12, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		end
	end

	-- TORTILLA CART beside her — weld parts to HRP so they ride with the rig.
	if hrp then
		weldTo(rig, hrp, "CartBody",       Vector3.new(3, 2, 2),       WOOD_DARK,  CFrame.new(3.5, -1, 0))
		weldTo(rig, hrp, "CartTop",        Vector3.new(3.1, 0.15, 2.1),WOOD_LIGHT, CFrame.new(3.5, 0.1, 0))
		for i = 1, 6 do
			weldTo(rig, hrp, "CartTortilla_" .. i, Vector3.new(0.12, 1.4, 1.4), CREAM,
				CFrame.new(3.5, 0.25 + (i - 1) * 0.13, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		end
		weldTo(rig, hrp, "CartWheel_L", Vector3.new(0.3, 1.0, 1.0), BLACK, CFrame.new(3.5, -1.9, -0.9) * CFrame.Angles(0, math.rad(90), math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, hrp, "CartWheel_R", Vector3.new(0.3, 1.0, 1.0), BLACK, CFrame.new(3.5, -1.9,  0.9) * CFrame.Angles(0, math.rad(90), math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, hrp, "CanopyPole_L", Vector3.new(0.15, 2.2, 0.15), WOOD_DARK, CFrame.new(2.3, 1.2, 0))
		weldTo(rig, hrp, "CanopyPole_R", Vector3.new(0.15, 2.2, 0.15), WOOD_DARK, CFrame.new(4.7, 1.2, 0))
		weldTo(rig, hrp, "Canopy",       Vector3.new(3.4, 0.15, 2.3),  TERRACOTTA, CFrame.new(3.5, 2.3, 0))
	end

	AB.r15NameTag(rig, "Abuela Rosa")
	return rig
end
