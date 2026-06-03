-- Cookie — R15 retrofit (polish A). Teal uniform, pink hair, white apron, notepad.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Cookie"
local SKIN    = Color3.fromRGB(240, 205, 175)
local UNIFORM = Color3.fromRGB(127, 202, 194)
local APRON   = Color3.fromRGB(255, 245, 232)
local PINK    = Color3.fromRGB(240, 130, 170)
local DARK    = Color3.fromRGB(40, 30, 60)
local PANTS   = Color3.fromRGB(230, 195, 165)

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
		shirt = UNIFORM,
		pants = PANTS,   -- skirt+tights tone
	})
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Skirt flare (teal block beneath waist)
		weldTo(rig, hrp, "Skirt",  Vector3.new(2.2, 1.2, 1.4), UNIFORM, CFrame.new(0, -1.4, 0))
		-- White apron over front torso
		weldTo(rig, hrp, "Apron",  Vector3.new(1.6, 2.0, 0.1), APRON, CFrame.new(0, 0, 0.6))
		-- Pink bow at waist
		weldTo(rig, hrp, "Bow",    Vector3.new(0.6, 0.3, 0.2), PINK, CFrame.new(0, -1.0, 0.65))
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Pink hair (sphere wrap)
		weldTo(rig, head, "Hair",  Vector3.new(1.55, 1.55, 1.55), PINK, CFrame.new(0, 0.3, -0.15), Enum.PartType.Ball)
		weldTo(rig, head, "Bangs", Vector3.new(1.4, 0.5, 0.2), PINK, CFrame.new(0, 0.5, 0.5))
		-- Eyes + lips
		weldTo(rig, head, "EyeL",  Vector3.new(0.15, 0.15, 0.15), DARK, CFrame.new(-0.3, 0.05, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR",  Vector3.new(0.15, 0.15, 0.15), DARK, CFrame.new( 0.3, 0.05, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Lips",  Vector3.new(0.3, 0.08, 0.05), PINK, CFrame.new(0, -0.4, 0.55))
	end
	-- Teal diner cap on top of hair
	AB.r15Hat(rig, Vector3.new(1.2, 0.4, 1.2), UNIFORM, 1.4, "Cap", Enum.PartType.Cylinder)
	-- Notepad + pencil in right hand
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "Notepad", Vector3.new(0.6, 0.08, 0.8), APRON, CFrame.new(0, -0.3, 0.4))
		weldTo(rig, rHand, "Pencil",  Vector3.new(0.7, 0.1, 0.1), Color3.fromRGB(220, 200, 80),
			CFrame.new(0.3, -0.2, 0.7) * CFrame.Angles(0, 0, math.rad(-90)))
	end
	AB.r15NameTag(rig, "Cookie")
	return rig
end
