-- Tony — R15 retrofit (polish A)
-- Owner of Tony's Pizzeria. Big mustache, white chef's hat, stained
-- red apron, holding a pizza peel with pepperoni pizza.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Tony"
local SKIN    = Color3.fromRGB(245, 215, 175)
local SHIRT   = Color3.fromRGB(245, 240, 230)
local APRON   = Color3.fromRGB(200, 40, 40)
local PANTS   = Color3.fromRGB(60, 60, 70)
local HAIR    = Color3.fromRGB(50, 35, 30)
local HAT     = Color3.fromRGB(255, 255, 250)
local STAIN   = Color3.fromRGB(170, 30, 30)
local WD      = Color3.fromRGB(110, 75, 45)
local PEEL    = Color3.fromRGB(180, 180, 190)

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
		shirt = SHIRT,
		pants = PANTS,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Red apron + straps + stain
		weldTo(rig, hrp, "Apron",      Vector3.new(2.0, 2.4, 0.15), APRON, CFrame.new(0, 0, 0.6))
		weldTo(rig, hrp, "ApronStrapL", Vector3.new(0.35, 1.0, 0.1), APRON, CFrame.new(-0.7, 1.2, 0.6))
		weldTo(rig, hrp, "ApronStrapR", Vector3.new(0.35, 1.0, 0.1), APRON, CFrame.new( 0.7, 1.2, 0.6))
		weldTo(rig, hrp, "ApronStain", Vector3.new(0.5, 0.35, 0.05), STAIN, CFrame.new(0.3, -0.4, 0.66))
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Big mustache + eyebrows
		weldTo(rig, head, "Mustache",  Vector3.new(1.5, 0.35, 0.45), HAIR, CFrame.new(0, -0.2, 0.45))
		weldTo(rig, head, "BrowL",     Vector3.new(0.42, 0.16, 0.1), HAIR, CFrame.new(-0.4, 0.3, 0.48))
		weldTo(rig, head, "BrowR",     Vector3.new(0.42, 0.16, 0.1), HAIR, CFrame.new( 0.4, 0.3, 0.48))
		weldTo(rig, head, "EyeL",      Vector3.new(0.2, 0.2, 0.2), Color3.fromRGB(30, 25, 20), CFrame.new(-0.4, 0.05, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR",      Vector3.new(0.2, 0.2, 0.2), Color3.fromRGB(30, 25, 20), CFrame.new( 0.4, 0.05, 0.5), Enum.PartType.Ball)
	end
	-- Chef's hat (band + puff)
	AB.r15Hat(rig, Vector3.new(2.2, 0.6, 2.2), HAT, 0.55, "HatBase")
	AB.r15Hat(rig, Vector3.new(2.2, 2.0, 2.2), HAT, 1.6, "HatPuff", Enum.PartType.Ball)

	-- Pizza peel held in right hand. R15 RightHand at local Y=-1.2 — +1.2 shift baked in below.
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		-- Peel stick (long, tilts forward & down out of the hand)
		weldTo(rig, rHand, "PeelStick", Vector3.new(0.3, 6, 0.3), WD,
			CFrame.new(0, 1.0, 1.0) * CFrame.Angles(math.rad(-60), 0, 0))
		-- Peel head (flat paddle at end of stick)
		weldTo(rig, rHand, "PeelHead", Vector3.new(2.4, 0.2, 2.4), PEEL,
			CFrame.new(0, 3.7, 3.0) * CFrame.Angles(math.rad(-60), 0, 0))
		-- Pizza on the peel
		weldTo(rig, rHand, "PeelPizza", Vector3.new(2.0, 0.2, 2.0), AB.colors.pizzaCrust,
			CFrame.new(0, 3.85, 3.1) * CFrame.Angles(math.rad(-60), 0, 0))
		weldTo(rig, rHand, "PeelPepperoni1", Vector3.new(0.35, 0.1, 0.35), AB.colors.pizzaRed,
			CFrame.new(-0.4, 3.95, 3.0) * CFrame.Angles(math.rad(-60), 0, 0), Enum.PartType.Ball)
		weldTo(rig, rHand, "PeelPepperoni2", Vector3.new(0.35, 0.1, 0.35), AB.colors.pizzaRed,
			CFrame.new( 0.4, 3.95, 3.1) * CFrame.Angles(math.rad(-60), 0, 0), Enum.PartType.Ball)
	end

	AB.r15NameTag(rig, NAME)
	return rig
end
