-- KidWithElote — R15 retrofit (polish A): kid in green shirt + jeans, terracotta cap,
-- holding an elote on a stick. Kid scale = 0.7x via Humanoid BodyHeightScale.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME        = "KidWithElote"
local SKIN        = Color3.fromRGB(210, 165, 130)
local SHIRT_GREEN = Color3.fromRGB(93, 168, 85)
local JEANS_BLUE  = Color3.fromRGB(50, 80, 140)
local HAIR_BLACK  = Color3.fromRGB(40, 30, 25)
local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local KERNEL_GOLD = Color3.fromRGB(230, 160, 30)
local CREAM       = Color3.fromRGB(245, 230, 200)
local TERRACOTTA  = Color3.fromRGB(196, 95, 44)
local WHITE       = Color3.fromRGB(245, 240, 235)
local BLACK       = Color3.fromRGB(30, 25, 25)
local CHEEK_PINK  = Color3.fromRGB(230, 150, 150)

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
		shirt = SHIRT_GREEN,
		pants = JEANS_BLUE,
	})

	-- Face: eyes + cheeks + big smile with teeth
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "Eye_L",      Vector3.new(0.16, 0.16, 0.16), BLACK,      CFrame.new(-0.28, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Eye_R",      Vector3.new(0.16, 0.16, 0.16), BLACK,      CFrame.new( 0.28, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Cheek_L",    Vector3.new(0.18, 0.18, 0.08), CHEEK_PINK, CFrame.new(-0.5, -0.15, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Cheek_R",    Vector3.new(0.18, 0.18, 0.08), CHEEK_PINK, CFrame.new( 0.5, -0.15, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Teeth",      Vector3.new(0.7, 0.18, 0.12),  WHITE,      CFrame.new(0, -0.25, 0.5))
		weldTo(rig, head, "SmileLine",  Vector3.new(0.7, 0.06, 0.12),  BLACK,      CFrame.new(0, -0.16, 0.51))
	end

	-- Hair + terracotta cap on top
	AB.r15Hat(rig, Vector3.new(1.95, 1.95, 1.95), HAIR_BLACK, 0.15, "Hair", Enum.PartType.Ball)
	if head then
		weldTo(rig, head, "Cap",     Vector3.new(0.4, 1.6, 1.6), TERRACOTTA, CFrame.new(0, 0.9, 0)  * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, head, "CapBrim", Vector3.new(1.4, 0.15, 0.7), TERRACOTTA, CFrame.new(0, 0.75, 0.55))
	end

	-- Elote: wooden stick + corn cob + kernels + mayo + chili sprinkle
	-- Held in right hand: right hand local Y=-1.2, +1.2 keeps elote at world Y of hand height.
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "EloteStick", Vector3.new(2.0, 0.2, 0.2), WOOD_DARK,  CFrame.new(0, 0.6, 0)   * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, rHand, "Corn",       Vector3.new(1.8, 0.9, 0.9), FIESTA_YEL, CFrame.new(0, 1.8, 0)  * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		for i = 1, 6 do
			local angle = (i / 6) * math.pi * 2
			weldTo(rig, rHand, "Kernel_" .. i, Vector3.new(0.15, 0.15, 0.15), KERNEL_GOLD,
				CFrame.new(math.cos(angle) * 0.45, 1.6 + (i % 2) * 0.4, math.sin(angle) * 0.45),
				Enum.PartType.Ball)
		end
		weldTo(rig, rHand, "Mayo", Vector3.new(0.9, 0.2, 0.5), CREAM, CFrame.new(0, 2.8, 0))
		for i = 1, 4 do
			weldTo(rig, rHand, "Chili_" .. i, Vector3.new(0.12, 0.12, 0.12), TERRACOTTA,
				CFrame.new((i - 2) * 0.2, 2.6 + (i % 2) * 0.1, (i % 3 - 1) * 0.2),
				Enum.PartType.Ball)
		end
	end

	-- Kid scale — shrink rig to 0.8 via Humanoid scales.
	local humanoid = rig:FindFirstChildOfClass("Humanoid")
	if humanoid then
		for _, prop in {"BodyDepthScale", "BodyHeightScale", "BodyWidthScale", "HeadScale"} do
			local v = humanoid:FindFirstChild(prop)
			if not v then
				v = Instance.new("NumberValue")
				v.Name = prop
				v.Parent = humanoid
			end
			v.Value = 0.8
		end
	end

	AB.r15NameTag(rig, "Memito")
	return rig
end
