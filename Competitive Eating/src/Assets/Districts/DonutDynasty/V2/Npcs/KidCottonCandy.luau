-- KidCottonCandy — R15 rig (child colors) holding an oversized pink cotton-candy swirl on a stick.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME  = "KidCottonCandy"
local MINT  = Color3.fromRGB(180, 230, 200)
local PINK  = Color3.fromRGB(255, 200, 214)
local DEEP  = Color3.fromRGB(232, 130, 165)
local CREAM = Color3.fromRGB(255, 240, 220)
local STICK = Color3.fromRGB(92, 57, 36)
local HAIR  = Color3.fromRGB(220, 160, 60)

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
		skin  = Color3.fromRGB(248, 220, 195),
		shirt = MINT,
		pants = Color3.fromRGB(100, 80, 90),
	})
	-- Torso accessories ride on HumanoidRootPart so existing R6 Torso offsets work.
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Heart on shirt (two balls + a wedge would be heavy — use two balls + small block as point)
		weldTo(rig, hrp, "HeartL", Vector3.new(0.4, 0.4, 0.4), DEEP, CFrame.new(-0.18, 0.25, 0.55), Enum.PartType.Ball)
		weldTo(rig, hrp, "HeartR", Vector3.new(0.4, 0.4, 0.4), DEEP, CFrame.new( 0.18, 0.25, 0.55), Enum.PartType.Ball)
		weldTo(rig, hrp, "HeartP", Vector3.new(0.35, 0.35, 0.2), DEEP, CFrame.new(0, -0.05, 0.55))
	end
	-- Curly hair tufts
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "HairL", Vector3.new(0.85, 0.85, 0.85), HAIR, CFrame.new(-0.5, 0.4, 0), Enum.PartType.Ball)
		weldTo(rig, head, "HairR", Vector3.new(0.85, 0.85, 0.85), HAIR, CFrame.new( 0.5, 0.4, 0), Enum.PartType.Ball)
		weldTo(rig, head, "HairB", Vector3.new(0.85, 0.85, 0.85), HAIR, CFrame.new(0, 0.45, -0.45), Enum.PartType.Ball)
		-- Rosy cheeks
		weldTo(rig, head, "CheekL", Vector3.new(0.2, 0.2, 0.1), PINK, CFrame.new(-0.45, -0.05, 0.45), Enum.PartType.Ball)
		weldTo(rig, head, "CheekR", Vector3.new(0.2, 0.2, 0.1), PINK, CFrame.new( 0.45, -0.05, 0.45), Enum.PartType.Ball)
	end
	-- Cotton candy swirl held in right hand. Originally anchored to the R6 "Right
	-- Arm" (centered at local Y=0); R15 RightHand is centered at local Y=-1.2,
	-- so each offset's Y shifts by +1.2 to preserve world position.
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "Stick",  Vector3.new(0.2, 2.5, 0.2), STICK, CFrame.new(0,  0.7, 0.3), Enum.PartType.Cylinder)
		weldTo(rig, rHand, "CCMain", Vector3.new(2.0, 2.0, 2.0), PINK,  CFrame.new(0, -1.1, 0.3), Enum.PartType.Ball)
		weldTo(rig, rHand, "CCL",    Vector3.new(1.3, 1.3, 1.3), DEEP,  CFrame.new(-0.6, -0.8, 0.3), Enum.PartType.Ball)
		weldTo(rig, rHand, "CCR",    Vector3.new(1.3, 1.3, 1.3), CREAM, CFrame.new( 0.6, -0.8, 0.3), Enum.PartType.Ball)
		weldTo(rig, rHand, "CCTop",  Vector3.new(1.1, 1.1, 1.1), DEEP,  CFrame.new(0, -1.6, 0.3), Enum.PartType.Ball)
	end
	AB.r15NameTag(rig, NAME)
	return rig
end
