-- DancingCouple — R15 retrofit (polish A): two R15 rigs (Lupita + Diego) under
-- a single Model wrapper. Lupita = cream blouse + pink skirt + braids. Diego =
-- cream charro shirt + terracotta sash + black sombrero. Hands meet at center.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME        = "DancingCouple"
local SKIN_LIGHT  = Color3.fromRGB(220, 180, 150)
local SKIN_MED    = Color3.fromRGB(210, 165, 130)
local BOUG_PINK   = Color3.fromRGB(220, 80, 140)
local CREAM       = Color3.fromRGB(245, 230, 200)
local HAIR_BLACK  = Color3.fromRGB(40, 30, 25)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN = Color3.fromRGB(93, 168, 85)
local TERRACOTTA  = Color3.fromRGB(196, 95, 44)
local BLACK       = Color3.fromRGB(30, 25, 25)
local LIP_PINK    = Color3.fromRGB(210, 110, 130)
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
	local model = AB.model(NAME, parent)

	-- ── Lupita: x = -1.5, pink skirt ──────────────────────────────────────
	local lupitaCF = originCF * CFrame.new(-1.5, 0, 0)
	local lupita = AB.r15Rig(model, lupitaCF * CFrame.new(0, -3, 0), "Lupita", {
		skin  = SKIN_LIGHT,
		shirt = CREAM,
		pants = BOUG_PINK,
	})
	local lHrp = lupita:FindFirstChild("HumanoidRootPart") :: BasePart
	if lHrp then
		-- Skirt flares (sphere-on-hip)
		weldTo(lupita, lHrp, "Skirt", Vector3.new(3.0, 1.4, 1.4), BOUG_PINK, CFrame.new(0, -1.3, 0), Enum.PartType.Ball)
		-- Embroidered flowers on skirt
		weldTo(lupita, lHrp, "Flower1", Vector3.new(0.25, 0.25, 0.25), FIESTA_YEL,  CFrame.new(-0.6, -1.2, 0.7), Enum.PartType.Ball)
		weldTo(lupita, lHrp, "Flower2", Vector3.new(0.25, 0.25, 0.25), PAPEL_GREEN, CFrame.new( 0.6, -1.2, 0.7), Enum.PartType.Ball)
		weldTo(lupita, lHrp, "Flower3", Vector3.new(0.25, 0.25, 0.25), FIESTA_YEL,  CFrame.new(-0.4, -1.7, 0.7), Enum.PartType.Ball)
		weldTo(lupita, lHrp, "Flower4", Vector3.new(0.25, 0.25, 0.25), PAPEL_GREEN, CFrame.new( 0.5, -1.7, 0.7), Enum.PartType.Ball)
	end
	local lHead = lupita:FindFirstChild("Head") :: BasePart
	if lHead then
		weldTo(lupita, lHead, "Eye_L", Vector3.new(0.15, 0.15, 0.15), BLACK,    CFrame.new(-0.3, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(lupita, lHead, "Eye_R", Vector3.new(0.15, 0.15, 0.15), BLACK,    CFrame.new( 0.3, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(lupita, lHead, "Mouth", Vector3.new(0.5, 0.15, 0.12),  LIP_PINK, CFrame.new(0, -0.35, 0.5))
		-- Side braids
		for i = 1, 3 do
			weldTo(lupita, lHead, "BraidL_" .. i, Vector3.new(0.35, 0.35, 0.35), HAIR_BLACK,
				CFrame.new(-0.85, -0.1 - (i - 1) * 0.45, 0), Enum.PartType.Ball)
			weldTo(lupita, lHead, "BraidR_" .. i, Vector3.new(0.35, 0.35, 0.35), HAIR_BLACK,
				CFrame.new( 0.85, -0.1 - (i - 1) * 0.45, 0), Enum.PartType.Ball)
		end
	end
	-- Hair cap
	AB.r15Hat(lupita, Vector3.new(1.95, 1.95, 1.95), HAIR_BLACK, 0.2, "Hair", Enum.PartType.Ball)

	-- ── Diego: x = +1.5, charro shirt + sombrero ──────────────────────────
	local diegoCF = originCF * CFrame.new(1.5, 0, 0)
	local diego = AB.r15Rig(model, diegoCF * CFrame.new(0, -3, 0), "Diego", {
		skin  = SKIN_MED,
		shirt = CREAM,
		pants = BLACK,
	})
	local dHrp = diego:FindFirstChild("HumanoidRootPart") :: BasePart
	if dHrp then
		-- Terracotta cummerbund sash + yellow diagonal trim.
		weldTo(diego, dHrp, "Sash",      Vector3.new(2.1, 0.6, 1.05), TERRACOTTA, CFrame.new(0, -0.75, 0))
		weldTo(diego, dHrp, "SashTrim",  Vector3.new(2.2, 0.2, 1.07), FIESTA_YEL, CFrame.new(0, -0.5, 0))
	end
	local dHead = diego:FindFirstChild("Head") :: BasePart
	if dHead then
		weldTo(diego, dHead, "Eye_L",    Vector3.new(0.18, 0.18, 0.18), BLACK,      CFrame.new(-0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(diego, dHead, "Eye_R",    Vector3.new(0.18, 0.18, 0.18), BLACK,      CFrame.new( 0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(diego, dHead, "Mustache", Vector3.new(0.9, 0.18, 0.18),  HAIR_BLACK, CFrame.new(0, -0.3, 0.45))
		weldTo(diego, dHead, "Mouth",    Vector3.new(0.5, 0.1, 0.12),   MOUTH_PINK, CFrame.new(0, -0.5, 0.45))
		-- Small black sombrero
		weldTo(diego, dHead, "HatBrim",  Vector3.new(0.25, 3.5, 3.5), BLACK,       CFrame.new(0, 0.85, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(diego, dHead, "HatCrown", Vector3.new(1.0, 1.8, 1.8),  BLACK,       CFrame.new(0, 1.5, 0)  * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(diego, dHead, "HatBand",  Vector3.new(0.18, 1.85, 1.85), FIESTA_YEL, CFrame.new(0, 1.05, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
	end

	-- Nametag on Lupita's head
	if lHead then
		AB.billboard(lHead, "Lupita & Diego", Vector2.new(240, 36), 2.5)
	end

	return model
end
