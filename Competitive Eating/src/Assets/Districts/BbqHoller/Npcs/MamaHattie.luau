-- MamaHattie — R15 retrofit (polish A)
-- Matriarch in red gingham dress, yellow straw apron, red headscarf, wooden
-- spoon. Preserves the headscarf + apron + spoon identity.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME   = "MamaHattie"
local SKIN   = Color3.fromRGB(165, 110, 75)
local DRESS  = Color3.fromRGB(140, 35, 35)
local CHECK  = Color3.fromRGB(245, 240, 225)
local APRON  = Color3.fromRGB(232, 200, 112)
local SCARF  = Color3.fromRGB(160, 40, 40)
local SHOE   = Color3.fromRGB(50, 32, 22)
local HAIR   = Color3.fromRGB(40, 30, 25)
local SPOON  = Color3.fromRGB(180, 130, 70)

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
		pants = DRESS,    -- long dress reads as dress on the leg chain too
	})

	local lowerTorso = rig:FindFirstChild("LowerTorso") :: BasePart
	if lowerTorso then
		-- Wider skirt over the legs
		weldTo(rig, lowerTorso, "Skirt", Vector3.new(3.6, 2.6, 2.4), DRESS, CFrame.new(0, -1.7, 0))
		-- A few light gingham check accents on the skirt
		weldTo(rig, lowerTorso, "Check_1", Vector3.new(0.7, 0.7, 0.05), CHECK, CFrame.new(-0.9, -1.0, 1.2))
		weldTo(rig, lowerTorso, "Check_2", Vector3.new(0.7, 0.7, 0.05), CHECK, CFrame.new( 0.9, -2.0, 1.2))
		weldTo(rig, lowerTorso, "Check_3", Vector3.new(0.7, 0.7, 0.05), CHECK, CFrame.new(-0.9, -2.4, 1.2))
		weldTo(rig, lowerTorso, "Check_4", Vector3.new(0.7, 0.7, 0.05), CHECK, CFrame.new( 0.0, -1.6, 1.2))
	end

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Yellow apron over the front + straps over shoulders
		weldTo(rig, hrp, "Apron",       Vector3.new(1.9, 2.2, 0.12), APRON, CFrame.new(0, -0.05, 0.6))
		weldTo(rig, hrp, "ApronStrapL", Vector3.new(0.3, 0.9, 0.05), APRON, CFrame.new(-0.55, 1.1, 0.6))
		weldTo(rig, hrp, "ApronStrapR", Vector3.new(0.3, 0.9, 0.05), APRON, CFrame.new( 0.55, 1.1, 0.6))
	end

	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Eyes + warm smile
		weldTo(rig, head, "EyeL", Vector3.new(0.22, 0.22, 0.22), Color3.new(0, 0, 0), CFrame.new(-0.4, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR", Vector3.new(0.22, 0.22, 0.22), Color3.new(0, 0, 0), CFrame.new( 0.4, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Smile", Vector3.new(0.85, 0.2, 0.18), Color3.fromRGB(160, 60, 60), CFrame.new(0, -0.3, 0.5))
		-- Hair bun peeking out from under the scarf
		weldTo(rig, head, "Bun", Vector3.new(1.2, 1.2, 1.2), HAIR, CFrame.new(0, 0.4, -0.7), Enum.PartType.Ball)
	end

	-- Red headscarf
	AB.r15Hat(rig, Vector3.new(2.3, 0.9, 2.3), SCARF, 0.65, "Scarf")

	-- Shoes welded to feet
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if lFoot then weldTo(rig, lFoot, "ShoeL", Vector3.new(1.0, 0.5, 1.4), SHOE, CFrame.new(0, -0.1, 0.1)) end
	if rFoot then weldTo(rig, rFoot, "ShoeR", Vector3.new(1.0, 0.5, 1.4), SHOE, CFrame.new(0, -0.1, 0.1)) end

	-- Wooden spoon in right hand
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "SpoonHandle", Vector3.new(0.3, 2.0, 0.3), SPOON, CFrame.new(0, -0.8, 0))
		weldTo(rig, rHand, "SpoonBowl",   Vector3.new(0.85, 0.4, 0.85), SPOON, CFrame.new(0, -1.9, 0), Enum.PartType.Ball)
	end

	AB.r15NameTag(rig, "Mama Hattie")
	return rig
end
