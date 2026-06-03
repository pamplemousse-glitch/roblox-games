-- FashionWoman — R15 retrofit (polish A)
-- Bianca: chic Italian in red dress, big shades, pearl necklace,
-- designer handbag (gold + black).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Bianca"
local SKIN    = Color3.fromRGB(245, 215, 175)
local DRESS_R = Color3.fromRGB(180, 30, 50)
local DRESS_T = Color3.fromRGB(220, 50, 70)
local HAIR    = Color3.fromRGB(60, 35, 25)
local SHOE_R  = Color3.fromRGB(150, 20, 30)
local BAG_GLD = Color3.fromRGB(200, 160, 80)
local BAG_BLK = Color3.fromRGB(35, 30, 30)
local LIPS    = Color3.fromRGB(180, 30, 40)

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
		skin     = SKIN,
		shirt    = DRESS_R,
		pants    = DRESS_R,
		leftLeg  = SKIN,  -- bare legs / heels feel
		rightLeg = SKIN,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Bodice highlight + black belt + gold buckle + pearl necklace
		weldTo(rig, hrp, "Bodice",     Vector3.new(2.1, 1.0, 1.05), DRESS_T, CFrame.new(0, 0.6, 0))
		weldTo(rig, hrp, "Belt",       Vector3.new(2.1, 0.25, 1.05), BAG_BLK, CFrame.new(0, -0.3, 0))
		weldTo(rig, hrp, "BeltBuckle", Vector3.new(0.55, 0.4, 0.1), BAG_GLD, CFrame.new(0, -0.3, 0.55))
		for i = -1, 1 do
			weldTo(rig, hrp, "Pearl_" .. (i + 2), Vector3.new(0.13, 0.13, 0.13),
				Color3.fromRGB(245, 240, 230), CFrame.new(i * 0.3, 1.0, 0.55), Enum.PartType.Ball)
		end
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Designer sunglasses (big, black + gold accents) + lips + pearl earrings
		weldTo(rig, head, "Shades",       Vector3.new(1.7, 0.45, 0.2), BAG_BLK, CFrame.new(0, 0.1, 0.5))
		weldTo(rig, head, "ShadeAccentL", Vector3.new(0.12, 0.12, 0.3), BAG_GLD, CFrame.new(-0.65, 0.1, 0.55))
		weldTo(rig, head, "ShadeAccentR", Vector3.new(0.12, 0.12, 0.3), BAG_GLD, CFrame.new( 0.65, 0.1, 0.55))
		weldTo(rig, head, "Lips",         Vector3.new(0.5, 0.13, 0.1), LIPS, CFrame.new(0, -0.4, 0.5))
		weldTo(rig, head, "EarringL",     Vector3.new(0.18, 0.18, 0.18), Color3.fromRGB(245, 240, 230), CFrame.new(-0.85, -0.1, 0.05), Enum.PartType.Ball)
		weldTo(rig, head, "EarringR",     Vector3.new(0.18, 0.18, 0.18), Color3.fromRGB(245, 240, 230), CFrame.new( 0.85, -0.1, 0.05), Enum.PartType.Ball)
	end
	-- Long flowing hair (back curtain + top + side strands via hats)
	AB.r15Hat(rig, Vector3.new(1.9, 2.5, 0.6), HAIR, 0.0, "HairLong")
	AB.r15Hat(rig, Vector3.new(2.2, 1.0, 2.0), HAIR, 0.6, "HairTop", Enum.PartType.Ball)

	-- Red high-heel shoes (welded to feet so they ride along)
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	if lFoot then
		weldTo(rig, lFoot, "HeelL", Vector3.new(0.95, 0.4, 1.15), SHOE_R, CFrame.new(0, -0.05, 0.1))
		weldTo(rig, lFoot, "HeelSpikeL", Vector3.new(0.12, 0.6, 0.12), SHOE_R, CFrame.new(0, -0.45, -0.4))
	end
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if rFoot then
		weldTo(rig, rFoot, "HeelR", Vector3.new(0.95, 0.4, 1.15), SHOE_R, CFrame.new(0, -0.05, 0.1))
		weldTo(rig, rFoot, "HeelSpikeR", Vector3.new(0.12, 0.6, 0.12), SHOE_R, CFrame.new(0, -0.45, -0.4))
	end

	-- Designer handbag hanging from left hand (gold + black)
	local lHand = rig:FindFirstChild("LeftHand") :: BasePart
	if lHand then
		weldTo(rig, lHand, "BagHandle",     Vector3.new(0.08, 0.08, 1.8), BAG_GLD, CFrame.new(0, -0.6, 0))
		weldTo(rig, lHand, "Bag",           Vector3.new(1.3, 1.5, 0.7), BAG_BLK, CFrame.new(0, -1.6, 0))
		weldTo(rig, lHand, "BagBuckle",     Vector3.new(0.55, 0.4, 0.1), BAG_GLD, CFrame.new(0, -1.6, 0.4))
		weldTo(rig, lHand, "BagTassel",     Vector3.new(0.08, 0.7, 0.08), BAG_GLD, CFrame.new(-0.4, -2.4, 0))
		weldTo(rig, lHand, "BagTasselBall", Vector3.new(0.18, 0.18, 0.18), BAG_GLD, CFrame.new(-0.4, -2.8, 0), Enum.PartType.Ball)
	end

	AB.r15NameTag(rig, NAME)
	return rig
end
