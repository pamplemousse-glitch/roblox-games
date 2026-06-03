-- GreaserWithComb — R15 retrofit (polish A). Leather jacket, slicked pompadour, holds comb, cigarette.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "GreaserWithComb"
local SKIN    = Color3.fromRGB(225, 185, 145)
local LEATHER = Color3.fromRGB(40, 40, 45)
local DENIM   = Color3.fromRGB(70, 80, 110)
local WHITE_T = Color3.fromRGB(245, 245, 240)
local HAIR_BL = Color3.fromRGB(20, 20, 25)
local DARK    = Color3.fromRGB(30, 30, 35)
local CHROME  = Color3.fromRGB(176, 176, 176)
local RED     = Color3.fromRGB(220, 50, 50)

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
		shirt = LEATHER,
		pants = DENIM,
	})
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- White t-shirt strip
		weldTo(rig, hrp, "Tee",        Vector3.new(0.8, 1.6, 0.05), WHITE_T, CFrame.new(0, 0.2, 0.55))
		-- Jacket collars
		weldTo(rig, hrp, "CollarL",    Vector3.new(0.3, 0.6, 0.4), LEATHER, CFrame.new(-0.7, 1.1, 0.35) * CFrame.Angles(0, 0, math.rad(15)))
		weldTo(rig, hrp, "CollarR",    Vector3.new(0.3, 0.6, 0.4), LEATHER, CFrame.new( 0.7, 1.1, 0.35) * CFrame.Angles(0, 0, math.rad(-15)))
		-- Chrome zipper
		weldTo(rig, hrp, "Zipper",     Vector3.new(0.1, 2.2, 0.05), CHROME, CFrame.new(-0.4, 0, 0.55))
		-- Stud buttons
		for i, y in {-0.6, 0, 0.6} do
			weldTo(rig, hrp, "Stud_" .. i, Vector3.new(0.1, 0.1, 0.1), CHROME, CFrame.new(-0.95, y, 0.55), Enum.PartType.Ball)
		end
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Huge pompadour
		weldTo(rig, head, "HairBack",   Vector3.new(1.5, 1.5, 1.5), HAIR_BL, CFrame.new(0, 0.55, -0.05), Enum.PartType.Ball)
		weldTo(rig, head, "Pompadour",  Vector3.new(1.2, 1.2, 1.2), HAIR_BL, CFrame.new(0, 1.05, 0.3), Enum.PartType.Ball)
		weldTo(rig, head, "PompFront",  Vector3.new(1.2, 0.5, 0.4), HAIR_BL, CFrame.new(0, 1.25, 0.4))
		-- Long sideburns
		weldTo(rig, head, "SideburnL",  Vector3.new(0.2, 1.0, 0.4), HAIR_BL, CFrame.new(-0.85, -0.45, 0.25))
		weldTo(rig, head, "SideburnR",  Vector3.new(0.2, 1.0, 0.4), HAIR_BL, CFrame.new( 0.85, -0.45, 0.25))
		-- Squinty cool eyes
		weldTo(rig, head, "EyeL",       Vector3.new(0.3, 0.08, 0.05), DARK, CFrame.new(-0.3, 0.1, 0.55))
		weldTo(rig, head, "EyeR",       Vector3.new(0.3, 0.08, 0.05), DARK, CFrame.new( 0.3, 0.1, 0.55))
		weldTo(rig, head, "Smirk",      Vector3.new(0.5, 0.08, 0.08), DARK, CFrame.new(0.15, -0.35, 0.55) * CFrame.Angles(0, 0, math.rad(-5)))
		-- Cigarette dangling
		weldTo(rig, head, "Cigarette",  Vector3.new(0.8, 0.07, 0.07), WHITE_T,
			CFrame.new(0.5, -0.35, 0.6) * CFrame.Angles(0, math.rad(90), 0))
		local tip = weldTo(rig, head, "CigTip", Vector3.new(0.08, 0.08, 0.08), RED, CFrame.new(0.9, -0.35, 0.6), Enum.PartType.Ball)
		tip.Material = Enum.Material.Neon
		local glow = Instance.new("PointLight"); glow.Color = RED; glow.Brightness = 0.4; glow.Range = 6; glow.Parent = tip
	end
	-- Comb in right hand (raised to hair)
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "Comb", Vector3.new(0.5, 0.08, 1.2), DARK, CFrame.new(0, -0.3, 0))
		for i = 0, 5 do
			weldTo(rig, rHand, "CombTooth_" .. i, Vector3.new(0.05, 0.4, 0.1), DARK,
				CFrame.new(0, 0, -0.5 + i * 0.18))
		end
	end
	AB.r15NameTag(rig, "Greaser")
	return rig
end
