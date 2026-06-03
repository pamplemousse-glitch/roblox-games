-- FarmgirlIcedTea — R15 retrofit (polish A)
-- Tan sun dress, wide-brim straw hat with red band, pigtail hair, holding a
-- glass of iced tea with a lemon slice on top. Preserves dress + hat + glass.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "FarmgirlIcedTea"
local SKIN    = Color3.fromRGB(238, 200, 175)
local DRESS   = Color3.fromRGB(220, 175, 140)
local DRESS_S = Color3.fromRGB(180, 130, 100)
local STRAW   = Color3.fromRGB(232, 200, 112)
local HAT_BD  = Color3.fromRGB(170, 30, 40)
local SANDAL  = Color3.fromRGB(105, 70, 40)
local HAIR    = Color3.fromRGB(190, 130, 80)
local GLASS   = Color3.fromRGB(220, 240, 250)
local TEA     = Color3.fromRGB(140, 95, 50)
local LEMON   = Color3.fromRGB(245, 220, 90)

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
		shirt = DRESS,
		pants = DRESS,    -- single-piece sun dress reads as dress on legs too
	})

	local lowerTorso = rig:FindFirstChild("LowerTorso") :: BasePart
	if lowerTorso then
		-- Skirt flare (wider near the bottom)
		weldTo(rig, lowerTorso, "SkirtMid", Vector3.new(3.5, 0.8, 2.0), DRESS, CFrame.new(0, -1.1, 0))
		weldTo(rig, lowerTorso, "SkirtBot", Vector3.new(4.0, 0.9, 2.4), DRESS, CFrame.new(0, -1.8, 0))
		-- Dress dots
		weldTo(rig, lowerTorso, "DressDot_1", Vector3.new(0.25, 0.25, 0.25), DRESS_S, CFrame.new(-0.9, -1.2, 0.95), Enum.PartType.Ball)
		weldTo(rig, lowerTorso, "DressDot_2", Vector3.new(0.25, 0.25, 0.25), DRESS_S, CFrame.new( 0,    -1.4, 0.95), Enum.PartType.Ball)
		weldTo(rig, lowerTorso, "DressDot_3", Vector3.new(0.25, 0.25, 0.25), DRESS_S, CFrame.new( 0.9, -1.2, 0.95), Enum.PartType.Ball)
	end

	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Closed-happy crescent eyes
		weldTo(rig, head, "EyeL", Vector3.new(0.4, 0.1, 0.1), Color3.new(0, 0, 0), CFrame.new(-0.4, 0.15, 0.5))
		weldTo(rig, head, "EyeR", Vector3.new(0.4, 0.1, 0.1), Color3.new(0, 0, 0), CFrame.new( 0.4, 0.15, 0.5))
		-- Smile
		weldTo(rig, head, "Smile", Vector3.new(0.8, 0.18, 0.18), Color3.new(0, 0, 0), CFrame.new(0, -0.3, 0.5))
		-- Cheek blush
		weldTo(rig, head, "CheekL", Vector3.new(0.3, 0.3, 0.3), HAT_BD, CFrame.new(-0.7, -0.1, 0.45), Enum.PartType.Ball)
		weldTo(rig, head, "CheekR", Vector3.new(0.3, 0.3, 0.3), HAT_BD, CFrame.new( 0.7, -0.1, 0.45), Enum.PartType.Ball)
		-- Pigtails on either side of the head
		weldTo(rig, head, "HairPigL", Vector3.new(1.1, 1.1, 1.1), HAIR, CFrame.new(-0.95, -0.2, -0.2), Enum.PartType.Ball)
		weldTo(rig, head, "HairPigR", Vector3.new(1.1, 1.1, 1.1), HAIR, CFrame.new( 0.95, -0.2, -0.2), Enum.PartType.Ball)
	end

	-- Hair fringe + wide-brim straw sun hat with red band
	AB.r15Hat(rig, Vector3.new(2.05, 0.3, 2.05), HAIR, 0.55, "Hair")
	AB.r15Hat(rig, Vector3.new(4.5, 0.3, 4.5), STRAW,  0.95, "HatBrim", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.4, 1.1, 2.4), STRAW,  1.55, "HatCrown", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.45, 0.28, 2.45), HAT_BD, 1.2, "HatBand", Enum.PartType.Cylinder)

	-- Sandals welded to feet
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if lFoot then weldTo(rig, lFoot, "SandalL", Vector3.new(1.15, 0.25, 1.35), SANDAL, CFrame.new(0, -0.18, 0.1)) end
	if rFoot then weldTo(rig, rFoot, "SandalR", Vector3.new(1.15, 0.25, 1.35), SANDAL, CFrame.new(0, -0.18, 0.1)) end

	-- Glass of iced tea in right hand. R15 RightHand origin = old R6 Right Arm
	-- baseline + 1.2 studs Y; offsets are written relative to the new hand
	-- center so no extra shift is needed here.
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		local cup = weldTo(rig, rHand, "Glass", Vector3.new(1.3, 1.8, 1.3), GLASS,
			CFrame.new(0.2, -0.2, 0.6), Enum.PartType.Cylinder)
		cup.Transparency = 0.4
		cup.Reflectance  = 0.2
		weldTo(rig, rHand, "Tea", Vector3.new(1.15, 1.4, 1.15), TEA,
			CFrame.new(0.2, -0.3, 0.6), Enum.PartType.Cylinder)
		weldTo(rig, rHand, "Lemon", Vector3.new(0.7, 0.15, 0.7), LEMON,
			CFrame.new(0.2, 0.75, 0.6), Enum.PartType.Cylinder)
	end

	AB.r15NameTag(rig, "Farmgirl")
	return rig
end
