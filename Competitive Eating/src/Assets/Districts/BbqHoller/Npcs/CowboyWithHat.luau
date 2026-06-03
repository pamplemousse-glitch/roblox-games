-- CowboyWithHat — R15 retrofit (polish A)
-- Plaid shirt, jeans, bandana, brown cowboy hat, boot spurs, handlebar
-- mustache. Preserves the cowboy hat + bandana + plaid signature.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "CowboyWithHat"
local SKIN       = Color3.fromRGB(220, 175, 135)
local HAT_BROWN  = Color3.fromRGB(95, 65, 38)
local HAT_DARK   = Color3.fromRGB(60, 40, 22)
local PLAID_RED  = Color3.fromRGB(160, 40, 40)
local PLAID_DARK = Color3.fromRGB(110, 28, 28)
local JEANS      = Color3.fromRGB(60, 80, 130)
local BOOT       = Color3.fromRGB(95, 60, 30)
local BANDANA    = Color3.fromRGB(220, 60, 60)
local SPUR       = Color3.fromRGB(190, 145, 60)
local HAIR       = Color3.fromRGB(105, 75, 45)

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
		shirt = PLAID_RED,
		pants = JEANS,
	})

	local upperTorso = rig:FindFirstChild("UpperTorso") :: BasePart
	if upperTorso then
		-- Horizontal plaid bands across the chest
		weldTo(rig, upperTorso, "PlaidH_1", Vector3.new(2.1, 0.18, 1.05), PLAID_DARK, CFrame.new(0,  0.35, 0))
		weldTo(rig, upperTorso, "PlaidH_2", Vector3.new(2.1, 0.18, 1.05), PLAID_DARK, CFrame.new(0, -0.15, 0))
		-- Vertical plaid stripes
		weldTo(rig, upperTorso, "PlaidV_L", Vector3.new(0.18, 1.25, 1.05), PLAID_DARK, CFrame.new(-0.55, 0, 0))
		weldTo(rig, upperTorso, "PlaidV_C", Vector3.new(0.18, 1.25, 1.05), PLAID_DARK, CFrame.new( 0,    0, 0))
		weldTo(rig, upperTorso, "PlaidV_R", Vector3.new(0.18, 1.25, 1.05), PLAID_DARK, CFrame.new( 0.55, 0, 0))
	end

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Bandana around the neck + tail
		weldTo(rig, hrp, "Bandana",     Vector3.new(2.0, 0.5, 1.3), BANDANA, CFrame.new(0, 1.45, 0))
		weldTo(rig, hrp, "BandanaTail", Vector3.new(0.55, 1.1, 0.3), BANDANA, CFrame.new(0, 1.05, -0.7))
		-- Belt + brass buckle
		weldTo(rig, hrp, "Belt",        Vector3.new(2.2, 0.4, 1.1), HAT_DARK, CFrame.new(0, -1.15, 0))
		weldTo(rig, hrp, "BeltBuckle",  Vector3.new(0.75, 0.55, 0.18), SPUR, CFrame.new(0, -1.15, 0.55))
	end

	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Eyes
		weldTo(rig, head, "EyeL", Vector3.new(0.22, 0.22, 0.22), Color3.new(0, 0, 0), CFrame.new(-0.4, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR", Vector3.new(0.22, 0.22, 0.22), Color3.new(0, 0, 0), CFrame.new( 0.4, 0.1, 0.5), Enum.PartType.Ball)
		-- Handlebar mustache
		weldTo(rig, head, "Mustache", Vector3.new(1.6, 0.28, 0.28), HAIR, CFrame.new(0, -0.2, 0.45))
	end

	-- Hair fringe under the hat
	AB.r15Hat(rig, Vector3.new(2.15, 0.3, 2.15), HAIR, 0.55, "Hair")
	-- Cowboy hat: wide brim + tall crown
	AB.r15Hat(rig, Vector3.new(4.8, 0.3, 4.8), HAT_BROWN, 0.95, "HatBrim", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.6, 1.4, 2.6), HAT_BROWN, 1.85, "HatCrown", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.65, 0.28, 2.65), HAT_DARK, 1.25, "HatBand", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(0.5, 0.3, 2.5), HAT_DARK, 2.55, "HatCrease")

	-- Boots + spurs welded to the feet
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if lFoot then
		weldTo(rig, lFoot, "BootL", Vector3.new(1.3, 0.75, 1.65), BOOT, CFrame.new(0, -0.1, 0.1))
		weldTo(rig, lFoot, "SpurL", Vector3.new(0.4, 0.4, 0.4), SPUR, CFrame.new(0, -0.1, -0.65), Enum.PartType.Ball)
	end
	if rFoot then
		weldTo(rig, rFoot, "BootR", Vector3.new(1.3, 0.75, 1.65), BOOT, CFrame.new(0, -0.1, 0.1))
		weldTo(rig, rFoot, "SpurR", Vector3.new(0.4, 0.4, 0.4), SPUR, CFrame.new(0, -0.1, -0.65), Enum.PartType.Ball)
	end

	AB.r15NameTag(rig, "Cowboy")
	return rig
end
