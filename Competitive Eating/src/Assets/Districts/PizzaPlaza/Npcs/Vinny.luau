-- Vinny — R15 retrofit (polish A)
-- Slick young Brooklyn slice-shop guy in a white tank + yellow apron,
-- slick hair, shades, gold chain, holding a slice and a cash roll.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Vinny"
local SKIN    = Color3.fromRGB(245, 215, 175)
local TANK    = Color3.fromRGB(245, 240, 230)
local APRON   = Color3.fromRGB(240, 200, 80)
local JEANS   = Color3.fromRGB(60, 80, 130)
local HAIR    = Color3.fromRGB(30, 25, 25)
local PEPP    = Color3.fromRGB(200, 50, 50)
local CRUST   = Color3.fromRGB(220, 180, 110)
local CHAIN_G = Color3.fromRGB(220, 180, 60)
local CASH_G  = Color3.fromRGB(120, 180, 130)

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
		shirt = TANK,
		pants = JEANS,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Yellow apron over tank top
		weldTo(rig, hrp, "Apron",       Vector3.new(1.85, 2.0, 0.12), APRON, CFrame.new(0, -0.2, 0.6))
		weldTo(rig, hrp, "ApronStrapL", Vector3.new(0.3, 1.0, 0.1), APRON, CFrame.new(-0.7, 1.2, 0.6))
		weldTo(rig, hrp, "ApronStrapR", Vector3.new(0.3, 1.0, 0.1), APRON, CFrame.new( 0.7, 1.2, 0.6))
		-- Gold chain + pendant
		weldTo(rig, hrp, "Chain",   Vector3.new(1.3, 0.15, 0.15), CHAIN_G, CFrame.new(0, 1.0, 0.55))
		weldTo(rig, hrp, "Pendant", Vector3.new(0.4, 0.4, 0.4), CHAIN_G, CFrame.new(0, 0.6, 0.65), Enum.PartType.Ball)
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Sunglasses (cool, black) + earring
		weldTo(rig, head, "Shades",  Vector3.new(1.7, 0.3, 0.15), Color3.fromRGB(30, 30, 35), CFrame.new(0, 0.1, 0.5))
		weldTo(rig, head, "Smirk",   Vector3.new(0.7, 0.1, 0.1), Color3.fromRGB(150, 80, 80), CFrame.new(0.1, -0.3, 0.5))
		weldTo(rig, head, "Earring", Vector3.new(0.14, 0.14, 0.14), CHAIN_G, CFrame.new(-0.85, 0, 0.05), Enum.PartType.Ball)
	end
	-- Slick back-swept hair
	AB.r15Hat(rig, Vector3.new(1.9, 0.6, 1.6), HAIR, 0.5, "HairTop")
	AB.r15Hat(rig, Vector3.new(1.6, 0.5, 1.2), HAIR, 0.4, "HairBack")

	-- Pizza slice in right hand
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "Slice",     Vector3.new(0.3, 1.2, 1.5), CRUST, CFrame.new(0, 0.1, 0.8))
		weldTo(rig, rHand, "SlicePep1", Vector3.new(0.22, 0.1, 0.22), PEPP, CFrame.new(0.1, 0.3, 0.7), Enum.PartType.Ball)
		weldTo(rig, rHand, "SlicePep2", Vector3.new(0.22, 0.1, 0.22), PEPP, CFrame.new(-0.15, 0.3, 0.85), Enum.PartType.Ball)
	end
	-- Cash roll in left hand
	local lHand = rig:FindFirstChild("LeftHand") :: BasePart
	if lHand then
		weldTo(rig, lHand, "CashRoll", Vector3.new(0.8, 0.5, 0.5), CASH_G, CFrame.new(0, 0.1, 0.5))
		weldTo(rig, lHand, "CashBand", Vector3.new(0.85, 0.18, 0.55), Color3.fromRGB(220, 60, 80), CFrame.new(0, 0.1, 0.5))
	end

	AB.r15NameTag(rig, NAME)
	return rig
end
