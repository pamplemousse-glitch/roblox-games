-- Memo — R15 retrofit (polish A): teal apron over white shirt, green ball cap, spatula.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME        = "Memo"
local SKIN        = Color3.fromRGB(215, 170, 130)
local SHIRT_WHITE = Color3.fromRGB(245, 240, 230)
local APRON_TEAL  = Color3.fromRGB(43, 140, 156)
local APRON_TRIM  = Color3.fromRGB(255, 184, 52)
local CAP_GREEN   = Color3.fromRGB(93, 168, 85)
local PANTS_DARK  = Color3.fromRGB(60, 50, 40)
local HAIR_BLACK  = Color3.fromRGB(35, 25, 20)
local BLACK       = Color3.fromRGB(30, 25, 25)
local METAL_GREY  = Color3.fromRGB(150, 150, 160)
local HANDLE_BRN  = Color3.fromRGB(100, 70, 50)
local MOUTH_PINK  = Color3.fromRGB(150, 80, 60)

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
		shirt = SHIRT_WHITE,
		pants = PANTS_DARK,
	})

	-- Teal apron + yellow pocket + neck straps
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		weldTo(rig, hrp, "Apron",  Vector3.new(1.9, 1.95, 0.1), APRON_TEAL, CFrame.new(0, 0, 0.6))
		weldTo(rig, hrp, "Pocket", Vector3.new(1.2, 0.4, 0.06), APRON_TRIM, CFrame.new(0, -0.6, 0.66))
		weldTo(rig, hrp, "StrapL", Vector3.new(0.15, 0.85, 0.1), APRON_TEAL, CFrame.new(-0.6, 1.0, 0.6))
		weldTo(rig, hrp, "StrapR", Vector3.new(0.15, 0.85, 0.1), APRON_TEAL, CFrame.new( 0.6, 1.0, 0.6))
	end

	-- Face: eyes + goatee + mouth
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "Eye_L",  Vector3.new(0.18, 0.18, 0.18), BLACK,      CFrame.new(-0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Eye_R",  Vector3.new(0.18, 0.18, 0.18), BLACK,      CFrame.new( 0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Goatee", Vector3.new(0.4, 0.4, 0.15),    HAIR_BLACK, CFrame.new(0, -0.5, 0.5))
		weldTo(rig, head, "Mouth",  Vector3.new(0.6, 0.1, 0.1),     MOUTH_PINK, CFrame.new(0, -0.3, 0.5))
	end

	-- Hair tuft + green ball cap (crown sphere + flat brim block + yellow emblem)
	AB.r15Hat(rig, Vector3.new(1.95, 1.95, 1.95), HAIR_BLACK, 0.3,  "Hair",     Enum.PartType.Ball)
	AB.r15Hat(rig, Vector3.new(2.0,  2.0,  2.0),  CAP_GREEN,  0.85, "CapCrown", Enum.PartType.Ball)
	if head then
		weldTo(rig, head, "CapBrim",   Vector3.new(2.0, 0.2, 1.2), CAP_GREEN,  CFrame.new(0, 0.95, 0.85))
		weldTo(rig, head, "CapEmblem", Vector3.new(0.6, 0.4, 0.1), APRON_TRIM, CFrame.new(0, 0.85, 0.97))
	end

	-- Spatula in right hand
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "SpatulaHandle", Vector3.new(0.2, 0.2, 1.5), HANDLE_BRN, CFrame.new(0, 0, -0.9))
		weldTo(rig, rHand, "SpatulaHead",   Vector3.new(1.0, 0.1, 0.8), METAL_GREY, CFrame.new(0, 0, -1.8))
	end

	AB.r15NameTag(rig, "Memo")
	return rig
end
