-- BeatnikWithShake — R15 retrofit (polish A). Black turtleneck, beret, holds milkshake.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "BeatnikWithShake"
local SKIN    = Color3.fromRGB(220, 175, 130)
local BLACK   = Color3.fromRGB(25, 25, 30)
local PINK_M  = Color3.fromRGB(255, 200, 215)
local WHITE   = Color3.fromRGB(245, 245, 240)
local RED     = Color3.fromRGB(220, 50, 50)
local DARK    = Color3.fromRGB(30, 30, 35)
local BERET_B = Color3.fromRGB(45, 35, 50)
local WOOD    = Color3.fromRGB(120, 70, 40)

local function weldTo(parent: Model, base: BasePart, name: string, size: Vector3, color: Color3, offset: CFrame, shape: Enum.PartType?): Part
	local p = Instance.new("Part")
	p.Name = name; p.Size = size; p.Color = color
	p.Material = Enum.Material.SmoothPlastic
	p.Anchored = true; p.CanCollide = false
	p.CFrame = base.CFrame * offset
	if shape then p.Shape = shape end
	p.Parent = parent
	local w = Instance.new("WeldConstraint"); w.Part0 = base; w.Part1 = p; w.Parent = p
	return p
end

return function(parent: Instance, originCF: CFrame): Model
	local rig = AB.r15Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = SKIN,
		shirt = BLACK,
		pants = BLACK,  -- black slacks
	})
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Turtleneck collar (raised black)
		weldTo(rig, hrp, "TurtleneckCollar", Vector3.new(0.9, 0.7, 0.9), BLACK, CFrame.new(0, 1.4, 0), Enum.PartType.Cylinder)
		-- Belt
		weldTo(rig, hrp, "Belt", Vector3.new(1.8, 0.3, 1.0), DARK, CFrame.new(0, -1.1, 0))
		-- Bongos under left arm
		weldTo(rig, hrp, "BongoL", Vector3.new(0.7, 0.8, 0.7), WOOD, CFrame.new(-1.6, -1.0, 0), Enum.PartType.Cylinder)
		weldTo(rig, hrp, "BongoR", Vector3.new(0.6, 0.8, 0.6), WOOD, CFrame.new(-2.1, -1.0, 0), Enum.PartType.Cylinder)
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Beret tilted
		weldTo(rig, head, "Beret",      Vector3.new(2.0, 0.4, 2.0), BERET_B, CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(-12), 0, math.rad(8)), Enum.PartType.Cylinder)
		weldTo(rig, head, "BeretStem",  Vector3.new(0.25, 0.25, 0.25), BERET_B, CFrame.new(0, 1.0, 0), Enum.PartType.Ball)
		-- Goatee + mustache
		weldTo(rig, head, "Goatee",     Vector3.new(0.4, 0.4, 0.2), DARK, CFrame.new(0, -0.4, 0.55))
		weldTo(rig, head, "Mustache",   Vector3.new(0.8, 0.08, 0.1), DARK, CFrame.new(0, -0.1, 0.55))
		-- Beatnik shades (black bar)
		weldTo(rig, head, "Shades",     Vector3.new(1.5, 0.3, 0.1), DARK, CFrame.new(0, 0.1, 0.55))
		-- Sideburns
		weldTo(rig, head, "SideburnL",  Vector3.new(0.15, 0.5, 0.3), DARK, CFrame.new(-0.55, -0.1, 0.15))
		weldTo(rig, head, "SideburnR",  Vector3.new(0.15, 0.5, 0.3), DARK, CFrame.new( 0.55, -0.1, 0.15))
	end
	-- Milkshake in right hand
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		local glass = weldTo(rig, rHand, "ShakeGlass", Vector3.new(1.8, 0.9, 0.9), Color3.fromRGB(220, 240, 255),
			CFrame.new(0, -0.6, 0) * CFrame.Angles(0, 0, math.rad(90)))
		glass.Shape = Enum.PartType.Cylinder
		glass.Material = Enum.Material.Glass; glass.Transparency = 0.45
		local content = weldTo(rig, rHand, "ShakeContent", Vector3.new(1.5, 0.7, 0.7), PINK_M,
			CFrame.new(0, -0.6, 0) * CFrame.Angles(0, 0, math.rad(90)))
		content.Shape = Enum.PartType.Cylinder
		weldTo(rig, rHand, "Whip",     Vector3.new(0.8, 0.8, 0.8), WHITE, CFrame.new(0, 0.5, 0), Enum.PartType.Ball)
		weldTo(rig, rHand, "Cherry",   Vector3.new(0.2, 0.2, 0.2), RED,   CFrame.new(0, 1.0, 0), Enum.PartType.Ball)
		weldTo(rig, rHand, "Straw",    Vector3.new(0.1, 2.0, 0.1), RED,   CFrame.new(0.15, 0.7, 0))
	end
	AB.r15NameTag(rig, "Beatnik")
	return rig
end
