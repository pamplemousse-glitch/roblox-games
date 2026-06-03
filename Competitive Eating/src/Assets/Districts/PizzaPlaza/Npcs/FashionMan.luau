-- FashionMan — R15 retrofit (polish A)
-- Marcello: dapper Italian in navy suit, fedora, red tie, pencil mustache,
-- espresso cup in right hand.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Marcello"
local SKIN    = Color3.fromRGB(240, 210, 175)
local SUIT    = Color3.fromRGB(40, 50, 80)
local SHIRT   = Color3.fromRGB(245, 240, 230)
local TIE_RED = Color3.fromRGB(180, 30, 40)
local HAIR    = Color3.fromRGB(40, 30, 25)
local HAT     = Color3.fromRGB(60, 50, 40)
local HAT_BND = Color3.fromRGB(35, 30, 25)
local CUP_W   = Color3.fromRGB(245, 235, 220)
local ESPR    = Color3.fromRGB(60, 35, 20)

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
		shirt = SUIT,
		pants = SUIT,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- White shirt + collar visible at top
		weldTo(rig, hrp, "Collar", Vector3.new(1.0, 0.45, 0.25), SHIRT, CFrame.new(0, 0.95, 0.55))
		weldTo(rig, hrp, "ShirtV", Vector3.new(0.4, 1.2, 0.15), SHIRT, CFrame.new(0, 0.4, 0.6))
		-- Red tie
		weldTo(rig, hrp, "Tie",    Vector3.new(0.35, 1.5, 0.18), TIE_RED, CFrame.new(0, 0.1, 0.62))
		weldTo(rig, hrp, "TieKnot",Vector3.new(0.45, 0.35, 0.2), TIE_RED, CFrame.new(0, 0.85, 0.62))
		-- Lapels (navy wedges)
		weldTo(rig, hrp, "LapelL", Vector3.new(0.55, 1.4, 0.15), SUIT, CFrame.new(-0.45, 0.4, 0.6))
		weldTo(rig, hrp, "LapelR", Vector3.new(0.55, 1.4, 0.15), SUIT, CFrame.new( 0.45, 0.4, 0.6))
		-- Pocket square + silver button
		weldTo(rig, hrp, "PocketSquare", Vector3.new(0.35, 0.3, 0.08), SHIRT, CFrame.new(-0.7, 0.3, 0.62))
		weldTo(rig, hrp, "JktButton",    Vector3.new(0.14, 0.14, 0.14), Color3.fromRGB(200, 200, 210),
			CFrame.new(0.5, -0.4, 0.62), Enum.PartType.Ball)
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Sharp brows + dark eyes + smirk + pencil mustache
		weldTo(rig, head, "BrowL",    Vector3.new(0.4, 0.18, 0.08), HAIR, CFrame.new(-0.4, 0.35, 0.48))
		weldTo(rig, head, "BrowR",    Vector3.new(0.4, 0.18, 0.08), HAIR, CFrame.new( 0.4, 0.35, 0.48))
		weldTo(rig, head, "EyeL",     Vector3.new(0.18, 0.18, 0.18), Color3.fromRGB(30, 25, 20), CFrame.new(-0.4, 0.05, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR",     Vector3.new(0.18, 0.18, 0.18), Color3.fromRGB(30, 25, 20), CFrame.new( 0.4, 0.05, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Smirk",    Vector3.new(0.5, 0.08, 0.08), Color3.fromRGB(160, 100, 90), CFrame.new(0.1, -0.4, 0.5))
		weldTo(rig, head, "Mustache", Vector3.new(1.0, 0.1, 0.15), HAIR, CFrame.new(0, -0.25, 0.5))
	end
	-- Slick hair + fedora (brim, crown, band, pinch)
	AB.r15Hat(rig, Vector3.new(2.0, 0.7, 1.5), HAIR,    0.5, "HairTop")
	AB.r15Hat(rig, Vector3.new(2.4, 0.5, 2.4), HAT,     1.05, "HatBrim")
	AB.r15Hat(rig, Vector3.new(1.5, 1.3, 1.5), HAT,     1.95, "HatCrown")
	AB.r15Hat(rig, Vector3.new(1.55, 0.2, 1.55), HAT_BND, 1.45, "HatBand")

	-- Espresso cup in right hand
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "Saucer",     Vector3.new(0.7, 0.1, 0.7), CUP_W, CFrame.new(0, 0.0, 0.55))
		weldTo(rig, rHand, "Cup",        Vector3.new(0.55, 0.55, 0.55), CUP_W, CFrame.new(0, 0.35, 0.55))
		weldTo(rig, rHand, "CupCoffee",  Vector3.new(0.5, 0.1, 0.5), ESPR, CFrame.new(0, 0.6, 0.55))
		weldTo(rig, rHand, "CupHandle",  Vector3.new(0.18, 0.18, 0.18), CUP_W, CFrame.new(0.45, 0.35, 0.55), Enum.PartType.Ball)
		local steam = weldTo(rig, rHand, "Steam", Vector3.new(0.4, 0.4, 0.4),
			Color3.fromRGB(240, 240, 240), CFrame.new(0, 1.2, 0.55), Enum.PartType.Ball)
		steam.Transparency = 0.6
	end

	AB.r15NameTag(rig, NAME)
	return rig
end
