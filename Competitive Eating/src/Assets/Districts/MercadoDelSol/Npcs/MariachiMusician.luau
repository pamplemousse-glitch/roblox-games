-- MariachiMusician — R15 retrofit (polish A): black charro suit, sombrero, guitarrón.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "MariachiMusician"
local SKIN       = Color3.fromRGB(210, 165, 130)
local BLACK      = Color3.fromRGB(30, 25, 25)
local CREAM      = Color3.fromRGB(245, 230, 200)
local FIESTA_YEL = Color3.fromRGB(255, 184, 52)
local BURGUNDY   = Color3.fromRGB(110, 30, 40)
local WOOD_DARK  = Color3.fromRGB(110, 75, 45)
local HAT_BAND   = Color3.fromRGB(140, 80, 50)

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
		shirt = BLACK,
		pants = BLACK,
	})

	-- Cream collar peeking + bolo tie + gold embroidery + guitarrón body
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		weldTo(rig, hrp, "Collar",         Vector3.new(1.6, 0.4, 1.05), CREAM, CFrame.new(0, 1.0, 0))
		weldTo(rig, hrp, "BoloTie",        Vector3.new(0.3, 0.3, 0.2),  BLACK, CFrame.new(0, 0.85, 0.55) * CFrame.Angles(0, 0, math.rad(45)))
		weldTo(rig, hrp, "GuitarronBody",  Vector3.new(2, 1.5, 0.6),    BURGUNDY,  CFrame.new(0, -0.5, 1.3))
		weldTo(rig, hrp, "GuitarronHole",  Vector3.new(0.5, 0.1, 0.5),  BLACK,     CFrame.new(0, -0.5, 1.65), Enum.PartType.Cylinder)
		weldTo(rig, hrp, "GuitarronNeck",  Vector3.new(0.3, 2.5, 0.25), WOOD_DARK, CFrame.new(-1.3, 0.7, 1.1) * CFrame.Angles(0, 0, math.rad(-30)))
		weldTo(rig, hrp, "GuitarronHead",  Vector3.new(0.5, 0.6, 0.25), HAT_BAND,  CFrame.new(-2.4, 1.7, 1.1))
	end

	-- Face: eyes + thick black mustache
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "Eye_L",    Vector3.new(0.18, 0.18, 0.18), BLACK, CFrame.new(-0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Eye_R",    Vector3.new(0.18, 0.18, 0.18), BLACK, CFrame.new( 0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Mustache", Vector3.new(1.2, 0.25, 0.2),   BLACK, CFrame.new(0, -0.35, 0.45))
		-- Black sombrero with yellow trim/band
		weldTo(rig, head, "HatBrim",     Vector3.new(0.3, 4.5, 4.5), BLACK,      CFrame.new(0, 0.85, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, head, "HatBrimTrim", Vector3.new(0.12, 4.6, 4.6), FIESTA_YEL, CFrame.new(0, 0.7, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, head, "HatCrown",    Vector3.new(1.2, 2.4, 2.4), BLACK,      CFrame.new(0, 1.6, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, head, "HatBand",     Vector3.new(0.25, 2.45, 2.45), FIESTA_YEL, CFrame.new(0, 1.1, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
	end

	-- Gold embroidery dots down each upper arm.
	local rUpper = rig:FindFirstChild("RightUpperArm") :: BasePart
	local lUpper = rig:FindFirstChild("LeftUpperArm")  :: BasePart
	for j = 1, 3 do
		if rUpper then
			weldTo(rig, rUpper, "Embroidery_R_" .. j, Vector3.new(0.25, 0.25, 0.25), FIESTA_YEL,
				CFrame.new(0.6, 0.5 - (j - 1) * 0.5, 0))
		end
		if lUpper then
			weldTo(rig, lUpper, "Embroidery_L_" .. j, Vector3.new(0.25, 0.25, 0.25), FIESTA_YEL,
				CFrame.new(-0.6, 0.5 - (j - 1) * 0.5, 0))
		end
	end

	AB.r15NameTag(rig, "Mariachi")
	return rig
end
