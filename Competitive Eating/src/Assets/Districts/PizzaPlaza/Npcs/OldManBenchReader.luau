-- OldManBenchReader — R15 retrofit (polish A)
-- Nonno Giuseppe: elderly man in flat cap + brown cardigan, holding open
-- newspaper, beside him a small wooden bench + coffee cup.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Nonno Giuseppe"
local SKIN    = Color3.fromRGB(235, 200, 165)
local CAP     = Color3.fromRGB(100, 80, 60)
local CARDIGAN= Color3.fromRGB(120, 90, 60)
local SHIRT   = Color3.fromRGB(245, 240, 230)
local PANTS   = Color3.fromRGB(60, 60, 70)
local HAIR    = Color3.fromRGB(180, 180, 185)
local PAPER   = Color3.fromRGB(245, 240, 230)
local TXT_DK  = Color3.fromRGB(40, 40, 45)
local WD      = Color3.fromRGB(110, 75, 45)

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
		shirt = CARDIGAN,
		pants = PANTS,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Shirt collar + cardigan buttons
		weldTo(rig, hrp, "Collar", Vector3.new(0.95, 0.4, 0.25), SHIRT, CFrame.new(0, 0.95, 0.55))
		for i, y in {0.3, -0.2, -0.7} do
			weldTo(rig, hrp, "Button_" .. i, Vector3.new(0.13, 0.13, 0.13),
				Color3.fromRGB(80, 60, 50), CFrame.new(0, y, 0.62), Enum.PartType.Ball)
		end
		-- Bench beneath / behind (visual cue — Nonno is "seated"). Park behind HRP.
		weldTo(rig, hrp, "BenchSeat", Vector3.new(5, 0.3, 1.5), WD, CFrame.new(0, -1.7, -0.5))
		weldTo(rig, hrp, "BenchBack", Vector3.new(5, 1.8, 0.3), WD, CFrame.new(0, -0.7, -1.3))
		weldTo(rig, hrp, "BenchLegL", Vector3.new(0.3, 2.4, 1.5), Color3.fromRGB(80, 50, 30), CFrame.new(-2, -2.7, -0.5))
		weldTo(rig, hrp, "BenchLegR", Vector3.new(0.3, 2.4, 1.5), Color3.fromRGB(80, 50, 30), CFrame.new( 2, -2.7, -0.5))
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Glasses + grey mustache
		weldTo(rig, head, "GlassL",      Vector3.new(0.4, 0.4, 0.05), TXT_DK, CFrame.new(-0.4, 0.1, 0.5))
		weldTo(rig, head, "GlassR",      Vector3.new(0.4, 0.4, 0.05), TXT_DK, CFrame.new( 0.4, 0.1, 0.5))
		weldTo(rig, head, "GlassBridge", Vector3.new(0.4, 0.04, 0.04), TXT_DK, CFrame.new(0, 0.1, 0.5))
		weldTo(rig, head, "Mustache",    Vector3.new(1.2, 0.25, 0.35), HAIR, CFrame.new(0, -0.4, 0.45))
	end
	-- Grey side hair + flat cap (body + brim)
	AB.r15Hat(rig, Vector3.new(1.85, 0.4, 1.85), HAIR, 0.35, "HairSides")
	AB.r15Hat(rig, Vector3.new(2.0, 0.5, 2.0), CAP,    0.85, "CapBody")
	AB.r15Hat(rig, Vector3.new(0.4, 0.1, 1.4), CAP,    0.55, "CapBrim")

	-- Newspaper held open across both hands (welded to HRP for stability)
	if hrp then
		weldTo(rig, hrp, "Newspaper", Vector3.new(3.0, 2.2, 0.1), PAPER,
			CFrame.new(0, 0.0, 1.4) * CFrame.Angles(math.rad(-15), 0, 0))
		weldTo(rig, hrp, "Fold", Vector3.new(0.05, 2.2, 0.12), Color3.fromRGB(180, 175, 170),
			CFrame.new(0, 0.0, 1.4) * CFrame.Angles(math.rad(-15), 0, 0))
		weldTo(rig, hrp, "Masthead", Vector3.new(2.6, 0.35, 0.04), Color3.fromRGB(180, 30, 40),
			CFrame.new(0, 0.85, 1.45) * CFrame.Angles(math.rad(-15), 0, 0))
		weldTo(rig, hrp, "Headline", Vector3.new(2.4, 0.22, 0.04), TXT_DK,
			CFrame.new(0, 0.35, 1.45) * CFrame.Angles(math.rad(-15), 0, 0))
		for i = 1, 3 do
			weldTo(rig, hrp, "NewsLine_" .. i, Vector3.new(2.2, 0.06, 0.04), Color3.fromRGB(110, 110, 110),
				CFrame.new(0, 0.1 - i * 0.2, 1.45) * CFrame.Angles(math.rad(-15), 0, 0))
		end
		-- Coffee cup beside on bench (right of him)
		weldTo(rig, hrp, "Cup",       Vector3.new(0.55, 0.85, 0.55), PAPER, CFrame.new(2.1, -1.2, -0.3))
		weldTo(rig, hrp, "CupCoffee", Vector3.new(0.45, 0.12, 0.45), Color3.fromRGB(60, 35, 20), CFrame.new(2.1, -0.75, -0.3))
	end

	AB.r15NameTag(rig, NAME)
	return rig
end
