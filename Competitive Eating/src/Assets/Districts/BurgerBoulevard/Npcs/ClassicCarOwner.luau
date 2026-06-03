-- ClassicCarOwner — R15 retrofit (polish A). Hawaiian shirt, aviators, gray hair, car keys.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "ClassicCarOwner"
local SKIN    = Color3.fromRGB(225, 175, 130)
local HAWAII  = Color3.fromRGB(220, 50, 50)
local LEAF    = Color3.fromRGB(120, 200, 90)
local SHORTS  = Color3.fromRGB(245, 240, 220)
local HAIR_GR = Color3.fromRGB(150, 145, 145)
local DARK    = Color3.fromRGB(30, 30, 35)
local CHROME  = Color3.fromRGB(176, 176, 176)
local YELLOW  = Color3.fromRGB(245, 220, 80)
local SHOE_BR = Color3.fromRGB(110, 70, 50)
local BELT    = Color3.fromRGB(70, 50, 35)

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
	-- White shorts on upper legs, skin on lower legs — use legs override.
	local rig = AB.r15Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin     = SKIN,
		shirt    = HAWAII,
		pants    = SHORTS,
	})
	-- Override lower legs to skin (shorts only cover upper leg)
	for _, n in {"RightLowerLeg", "LeftLowerLeg"} do
		local p = rig:FindFirstChild(n) :: BasePart?
		if p then p.Color = SKIN end
	end
	-- Brown loafers on feet
	for _, n in {"RightFoot", "LeftFoot"} do
		local p = rig:FindFirstChild(n) :: BasePart?
		if p then p.Color = SHOE_BR end
	end
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Belt + yellow buckle
		weldTo(rig, hrp, "Belt",   Vector3.new(2.2, 0.3, 1.1), BELT, CFrame.new(0, -1.1, 0))
		weldTo(rig, hrp, "Buckle", Vector3.new(0.4, 0.4, 0.15), YELLOW, CFrame.new(0, -1.1, 0.6))
		-- Leaf prints on Hawaiian shirt
		for i, info in {{x=-0.6, y=0.6}, {x=0.5, y=0.1}, {x=-0.2, y=-0.5}, {x=0.7, y=-0.7}, {x=-0.5, y=-0.7}} do
			weldTo(rig, hrp, "Leaf_" .. i, Vector3.new(0.4, 0.6, 0.05), LEAF,
				CFrame.new(info.x, info.y, 0.55) * CFrame.Angles(0, 0, math.rad(i * 30)))
		end
		-- Open V-neck collars
		weldTo(rig, hrp, "CollarL", Vector3.new(0.3, 0.7, 0.4), HAWAII, CFrame.new(-0.6, 1.1, 0.4) * CFrame.Angles(0, 0, math.rad(20)))
		weldTo(rig, hrp, "CollarR", Vector3.new(0.3, 0.7, 0.4), HAWAII, CFrame.new( 0.6, 1.1, 0.4) * CFrame.Angles(0, 0, math.rad(-20)))
		-- Belly bulge
		weldTo(rig, hrp, "Belly",   Vector3.new(2.3, 1.5, 1.4), HAWAII, CFrame.new(0, -0.4, 0))
	end
	-- Forearm skin (short sleeves)
	for _, n in {"RightLowerArm", "LeftLowerArm"} do
		local p = rig:FindFirstChild(n) :: BasePart?
		if p then p.Color = SKIN end
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Receding gray hair
		weldTo(rig, head, "Hair",       Vector3.new(1.3, 0.4, 1.3), HAIR_GR, CFrame.new(0, 0.55, -0.1))
		weldTo(rig, head, "HairSideL",  Vector3.new(0.2, 0.7, 1.2), HAIR_GR, CFrame.new(-0.85, 0.1, -0.1))
		weldTo(rig, head, "HairSideR",  Vector3.new(0.2, 0.7, 1.2), HAIR_GR, CFrame.new( 0.85, 0.1, -0.1))
		-- Aviator sunglasses
		weldTo(rig, head, "ShadeL",     Vector3.new(0.55, 0.35, 0.1), DARK, CFrame.new(-0.35, 0, 0.55))
		weldTo(rig, head, "ShadeR",     Vector3.new(0.55, 0.35, 0.1), DARK, CFrame.new( 0.35, 0, 0.55))
		weldTo(rig, head, "ShadeBridge", Vector3.new(0.2, 0.08, 0.08), CHROME, CFrame.new(0, 0, 0.57))
		weldTo(rig, head, "Mustache",   Vector3.new(0.8, 0.15, 0.15), HAIR_GR, CFrame.new(0, -0.5, 0.55))
		weldTo(rig, head, "Smile",      Vector3.new(0.5, 0.1, 0.08), DARK, CFrame.new(0, -0.8, 0.55))
	end
	-- Car keys dangling from right hand
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "KeyRing", Vector3.new(0.1, 0.4, 0.4), CHROME, CFrame.new(0, -0.3, 0) * CFrame.Angles(0, math.rad(90), 0), Enum.PartType.Cylinder)
		weldTo(rig, rHand, "Key1",    Vector3.new(0.15, 0.8, 0.05), CHROME, CFrame.new(-0.1, -0.8, 0))
		weldTo(rig, rHand, "Key2",    Vector3.new(0.15, 0.7, 0.05), CHROME, CFrame.new( 0.1, -0.7, 0))
		weldTo(rig, rHand, "KeyFob",  Vector3.new(0.2, 0.2, 0.2), HAWAII, CFrame.new(0.1, -0.45, 0), Enum.PartType.Ball)
	end
	AB.r15NameTag(rig, "ClassicCarOwner")
	return rig
end
