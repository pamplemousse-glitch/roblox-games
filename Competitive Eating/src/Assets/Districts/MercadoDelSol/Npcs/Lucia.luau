-- Lucia — R15 retrofit (polish A): fiesta-yellow dress, floral apron, braid.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME        = "Lucia"
local SKIN        = Color3.fromRGB(225, 185, 145)
local DRESS_YEL   = Color3.fromRGB(255, 184, 52)
local APRON_WHITE = Color3.fromRGB(250, 245, 230)
local FLOWER_PINK = Color3.fromRGB(230, 130, 165)
local FLOWER_TEAL = Color3.fromRGB(43, 140, 156)
local HAIR_BLACK  = Color3.fromRGB(40, 25, 20)
local LIP_PINK    = Color3.fromRGB(210, 110, 130)
local EYE_BROWN   = Color3.fromRGB(60, 40, 25)

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
		shirt = DRESS_YEL,
		pants = DRESS_YEL,   -- dress drapes — color legs to match
	})

	-- White floral apron on the dress front.
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		weldTo(rig, hrp, "Apron", Vector3.new(1.8, 1.95, 0.1), APRON_WHITE, CFrame.new(0, 0, 0.6))
		-- Flower dots scattered on apron.
		weldTo(rig, hrp, "Flower_1", Vector3.new(0.3, 0.3, 0.08), FLOWER_PINK, CFrame.new(-0.5,  0.5, 0.66), Enum.PartType.Ball)
		weldTo(rig, hrp, "Flower_2", Vector3.new(0.3, 0.3, 0.08), FLOWER_TEAL, CFrame.new( 0.4,  0.7, 0.66), Enum.PartType.Ball)
		weldTo(rig, hrp, "Flower_3", Vector3.new(0.3, 0.3, 0.08), FLOWER_PINK, CFrame.new(-0.3, -0.5, 0.66), Enum.PartType.Ball)
		weldTo(rig, hrp, "Flower_4", Vector3.new(0.3, 0.3, 0.08), FLOWER_TEAL, CFrame.new( 0.55,-0.7, 0.66), Enum.PartType.Ball)
	end

	-- Face: eyes + lipstick smile
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "Eye_L", Vector3.new(0.16, 0.16, 0.16), EYE_BROWN, CFrame.new(-0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Eye_R", Vector3.new(0.16, 0.16, 0.16), EYE_BROWN, CFrame.new( 0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Mouth", Vector3.new(0.5, 0.15, 0.12),  LIP_PINK,  CFrame.new(0, -0.35, 0.5))
	end

	-- Hair: cap dome, single braid down the back, flower behind the ear.
	AB.r15Hat(rig, Vector3.new(1.95, 1.95, 1.95), HAIR_BLACK, 0.4, "Hair", Enum.PartType.Ball)
	if head then
		for i = 1, 4 do
			weldTo(rig, head, "Braid_" .. i, Vector3.new(0.5, 0.5, 0.5), HAIR_BLACK,
				CFrame.new(0, -0.3 - (i - 1) * 0.55, -0.9), Enum.PartType.Ball)
		end
		weldTo(rig, head, "HairFlower", Vector3.new(0.45, 0.45, 0.45), FLOWER_PINK,
			CFrame.new(-0.9, 0.5, 0.4), Enum.PartType.Ball)
	end

	AB.r15NameTag(rig, "Lucia")
	return rig
end
