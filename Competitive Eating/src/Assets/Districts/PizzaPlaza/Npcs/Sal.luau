-- Sal — R15 retrofit (polish A)
-- Calzone cart vendor. Striped shirt, paper boat hat, basket of calzones,
-- cigar in mouth, gold belt buckle.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Sal"
local SKIN    = Color3.fromRGB(245, 215, 175)
local STRIPE_R= Color3.fromRGB(200, 40, 40)
local STRIPE_W= Color3.fromRGB(245, 240, 230)
local PANTS   = Color3.fromRGB(80, 50, 30)
local HAIR    = Color3.fromRGB(60, 40, 35)
local CALZONE = Color3.fromRGB(220, 180, 100)
local BASKET  = Color3.fromRGB(190, 140, 80)
local BANDANA = Color3.fromRGB(80, 140, 60)

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
		shirt = STRIPE_W,
		pants = PANTS,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- 3 red horizontal stripes on torso
		weldTo(rig, hrp, "Stripe_1", Vector3.new(2.05, 0.5, 1.05), STRIPE_R, CFrame.new(0,  0.7, 0))
		weldTo(rig, hrp, "Stripe_2", Vector3.new(2.05, 0.5, 1.05), STRIPE_R, CFrame.new(0,  0.0, 0))
		weldTo(rig, hrp, "Stripe_3", Vector3.new(2.05, 0.5, 1.05), STRIPE_R, CFrame.new(0, -0.7, 0))
		-- Belt + gold buckle
		weldTo(rig, hrp, "Belt",   Vector3.new(2.05, 0.25, 1.05), Color3.fromRGB(40, 30, 25), CFrame.new(0, -1.1, 0))
		weldTo(rig, hrp, "Buckle", Vector3.new(0.6, 0.4, 0.1), Color3.fromRGB(220, 180, 60), CFrame.new(0, -1.1, 0.55))
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- 5 o'clock shadow / stubble + thick eyebrows
		weldTo(rig, head, "Stubble", Vector3.new(1.4, 0.35, 0.35), Color3.fromRGB(80, 60, 50), CFrame.new(0, -0.4, 0.4))
		weldTo(rig, head, "BrowL",   Vector3.new(0.45, 0.18, 0.1), HAIR, CFrame.new(-0.4, 0.35, 0.48))
		weldTo(rig, head, "BrowR",   Vector3.new(0.45, 0.18, 0.1), HAIR, CFrame.new( 0.4, 0.35, 0.48))
		weldTo(rig, head, "EyeL",    Vector3.new(0.22, 0.22, 0.22), Color3.fromRGB(30, 25, 20), CFrame.new(-0.4, 0.05, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR",    Vector3.new(0.22, 0.22, 0.22), Color3.fromRGB(30, 25, 20), CFrame.new( 0.4, 0.05, 0.5), Enum.PartType.Ball)
		-- Cigar in mouth (small dark brown) + glowing ember
		weldTo(rig, head, "Cigar", Vector3.new(0.8, 0.12, 0.12), Color3.fromRGB(80, 50, 30), CFrame.new(0.4, -0.45, 0.6))
		local ember = weldTo(rig, head, "CigarEmber", Vector3.new(0.14, 0.14, 0.14), Color3.fromRGB(255, 100, 30),
			CFrame.new(0.85, -0.45, 0.6), Enum.PartType.Ball)
		AB.neon(ember)
	end
	-- Paper boat hat (brim + crown wedges)
	AB.r15Hat(rig, Vector3.new(2.4, 0.5, 1.8), STRIPE_W, 0.5, "HatBrim")
	AB.r15Hat(rig, Vector3.new(1.8, 1.2, 0.5), STRIPE_W, 1.2, "HatCrown")

	-- Basket of calzones carried between both hands (welded to HRP for a stable look)
	if hrp then
		weldTo(rig, hrp, "Basket",     Vector3.new(2.8, 0.9, 1.8), BASKET, CFrame.new(0, -1.6, 1.6))
		weldTo(rig, hrp, "BasketRim",  Vector3.new(3.0, 0.2, 2.0), Color3.fromRGB(130, 90, 50), CFrame.new(0, -1.1, 1.6))
		weldTo(rig, hrp, "Calzone1",   Vector3.new(0.7, 0.7, 0.7), CALZONE, CFrame.new(-0.75, -0.85, 1.6), Enum.PartType.Ball)
		weldTo(rig, hrp, "Calzone2",   Vector3.new(0.7, 0.7, 0.7), CALZONE, CFrame.new(0,    -0.85, 1.6), Enum.PartType.Ball)
		weldTo(rig, hrp, "Calzone3",   Vector3.new(0.7, 0.7, 0.7), CALZONE, CFrame.new( 0.75, -0.85, 1.6), Enum.PartType.Ball)
		weldTo(rig, hrp, "CalzCrust1", Vector3.new(0.55, 0.2, 0.55), Color3.fromRGB(180, 130, 70), CFrame.new(-0.75, -0.6, 1.6), Enum.PartType.Ball)
		weldTo(rig, hrp, "CalzCrust2", Vector3.new(0.55, 0.2, 0.55), Color3.fromRGB(180, 130, 70), CFrame.new(0,    -0.6, 1.6), Enum.PartType.Ball)
		weldTo(rig, hrp, "Bandana",    Vector3.new(2.85, 0.18, 1.85), BANDANA, CFrame.new(0, -1.2, 1.6))
	end

	AB.r15NameTag(rig, NAME)
	return rig
end
