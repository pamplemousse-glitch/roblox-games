-- SkinnyJoe — R15 retrofit (polish A)
-- Gangly farmhand: red plaid shirt, denim overalls, straw-yellow ball cap,
-- buck-tooth grin. Preserves the overalls + cap + grin identity.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME     = "SkinnyJoe"
local SKIN     = Color3.fromRGB(240, 200, 165)
local PLAID    = Color3.fromRGB(160, 40, 40)
local PLAID_HL = Color3.fromRGB(70, 25, 25)
local DENIM    = Color3.fromRGB(70, 90, 130)
local CAP      = Color3.fromRGB(232, 200, 112)
local BOOT     = Color3.fromRGB(55, 35, 22)
local HAIR     = Color3.fromRGB(180, 130, 70)
local BTN      = Color3.fromRGB(220, 180, 60)
local TOOTH    = Color3.fromRGB(240, 230, 200)
local GRIN     = Color3.fromRGB(160, 60, 60)

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
		shirt = PLAID,
		pants = DENIM,
	})

	local upperTorso = rig:FindFirstChild("UpperTorso") :: BasePart
	if upperTorso then
		-- Plaid pattern: dark cross stripes on the shirt
		weldTo(rig, upperTorso, "PlaidH1", Vector3.new(2.05, 0.18, 1.05), PLAID_HL, CFrame.new(0,  0.3, 0))
		weldTo(rig, upperTorso, "PlaidH2", Vector3.new(2.05, 0.18, 1.05), PLAID_HL, CFrame.new(0, -0.3, 0))
		weldTo(rig, upperTorso, "PlaidV1", Vector3.new(0.2, 1.2, 1.05), PLAID_HL, CFrame.new(-0.5, 0, 0))
		weldTo(rig, upperTorso, "PlaidV2", Vector3.new(0.2, 1.2, 1.05), PLAID_HL, CFrame.new( 0.5, 0, 0))
		-- Overall bib over the chest
		weldTo(rig, upperTorso, "OverallBib", Vector3.new(1.5, 1.05, 0.25), DENIM, CFrame.new(0, -0.1, 0.55))
		-- Bib straps
		weldTo(rig, upperTorso, "StrapL", Vector3.new(0.3, 1.3, 0.3), DENIM, CFrame.new(-0.6, 0.55, 0.4))
		weldTo(rig, upperTorso, "StrapR", Vector3.new(0.3, 1.3, 0.3), DENIM, CFrame.new( 0.6, 0.55, 0.4))
		-- Brass buttons on the bib
		weldTo(rig, upperTorso, "BibBtnL", Vector3.new(0.22, 0.22, 0.22), BTN, CFrame.new(-0.45, -0.15, 0.65), Enum.PartType.Ball)
		weldTo(rig, upperTorso, "BibBtnR", Vector3.new(0.22, 0.22, 0.22), BTN, CFrame.new( 0.45, -0.15, 0.65), Enum.PartType.Ball)
	end

	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Big round eyes
		weldTo(rig, head, "EyeL", Vector3.new(0.25, 0.25, 0.25), Color3.new(0, 0, 0), CFrame.new(-0.45, 0.15, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR", Vector3.new(0.25, 0.25, 0.25), Color3.new(0, 0, 0), CFrame.new( 0.45, 0.15, 0.5), Enum.PartType.Ball)
		-- Buck tooth + grin
		weldTo(rig, head, "Tooth", Vector3.new(0.3, 0.45, 0.1), TOOTH, CFrame.new(0, -0.2, 0.5))
		weldTo(rig, head, "Grin",  Vector3.new(0.9, 0.15, 0.18), GRIN, CFrame.new(0, -0.4, 0.5))
	end

	-- Shaggy hair sticking out + straw-yellow ball cap
	AB.r15Hat(rig, Vector3.new(2.05, 0.4, 2.05), HAIR, 0.55, "Hair")
	AB.r15Hat(rig, Vector3.new(2.4, 0.9, 2.4), CAP, 1.05, "CapCrown", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.8, 0.3, 1.6), CAP, 0.7, "CapBrim")

	-- Comically oversized boots
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if lFoot then weldTo(rig, lFoot, "BootL", Vector3.new(1.5, 0.85, 1.8), BOOT, CFrame.new(0, -0.05, 0.15)) end
	if rFoot then weldTo(rig, rFoot, "BootR", Vector3.new(1.5, 0.85, 1.8), BOOT, CFrame.new(0, -0.05, 0.15)) end

	AB.r15NameTag(rig, "Skinny Joe")
	return rig
end
