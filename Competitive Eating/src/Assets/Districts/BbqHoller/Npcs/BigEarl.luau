-- BigEarl — R15 retrofit (polish A)
-- Barrel-chested pitmaster: cream apron with sauce splotches, red kerchief,
-- big mustache. Preserves the apron + sauce + kerchief identity.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME     = "BigEarl"
local SKIN     = Color3.fromRGB(225, 180, 140)
local APRON    = Color3.fromRGB(240, 235, 215)
local SHIRT    = Color3.fromRGB(85, 65, 50)
local PANTS    = Color3.fromRGB(55, 40, 30)
local BOOT     = Color3.fromRGB(45, 28, 18)
local KERCHIEF = Color3.fromRGB(160, 40, 40)
local SAUCE    = Color3.fromRGB(110, 30, 25)
local HAIR     = Color3.fromRGB(35, 25, 20)

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
		shirt = SHIRT,
		pants = PANTS,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Cream apron over the front + neck loop straps + waist tie
		weldTo(rig, hrp, "Apron",       Vector3.new(2.0, 2.2, 0.12), APRON, CFrame.new(0, -0.05, 0.6))
		weldTo(rig, hrp, "ApronStrapL", Vector3.new(0.3, 0.95, 0.05), APRON, CFrame.new(-0.6, 1.1, 0.6))
		weldTo(rig, hrp, "ApronStrapR", Vector3.new(0.3, 0.95, 0.05), APRON, CFrame.new( 0.6, 1.1, 0.6))
		weldTo(rig, hrp, "ApronTie",    Vector3.new(2.2, 0.25, 1.05), KERCHIEF, CFrame.new(0, -0.85, 0))
		-- Sauce splotches on the apron
		weldTo(rig, hrp, "Sauce_1", Vector3.new(0.6, 0.6, 0.6), SAUCE, CFrame.new(-0.5,  0.0, 0.66), Enum.PartType.Ball)
		weldTo(rig, hrp, "Sauce_2", Vector3.new(0.6, 0.6, 0.6), SAUCE, CFrame.new( 0.55,-0.5, 0.66), Enum.PartType.Ball)
		weldTo(rig, hrp, "Sauce_3", Vector3.new(0.5, 0.5, 0.5), SAUCE, CFrame.new( 0.15, 0.6, 0.66), Enum.PartType.Ball)
		-- Red kerchief around the neck
		weldTo(rig, hrp, "Kerchief", Vector3.new(2.4, 0.5, 1.3), KERCHIEF, CFrame.new(0, 1.45, 0))
	end

	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Big bushy mustache
		weldTo(rig, head, "Mustache",  Vector3.new(1.4, 0.32, 0.3), HAIR, CFrame.new(0, -0.2, 0.45))
		weldTo(rig, head, "MustacheL", Vector3.new(0.35, 0.35, 0.35), HAIR, CFrame.new(-0.6, -0.2, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "MustacheR", Vector3.new(0.35, 0.35, 0.35), HAIR, CFrame.new( 0.6, -0.2, 0.5), Enum.PartType.Ball)
		-- Eyes
		weldTo(rig, head, "EyeL", Vector3.new(0.22, 0.22, 0.22), Color3.new(0, 0, 0), CFrame.new(-0.4, 0.15, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR", Vector3.new(0.22, 0.22, 0.22), Color3.new(0, 0, 0), CFrame.new( 0.4, 0.15, 0.5), Enum.PartType.Ball)
	end

	-- Dark hair fringe
	AB.r15Hat(rig, Vector3.new(2.1, 0.4, 2.1), HAIR, 0.6, "Hair")

	-- Boots welded to feet
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if lFoot then weldTo(rig, lFoot, "BootL", Vector3.new(1.4, 0.55, 1.6), BOOT, CFrame.new(0, -0.08, 0.1)) end
	if rFoot then weldTo(rig, rFoot, "BootR", Vector3.new(1.4, 0.55, 1.6), BOOT, CFrame.new(0, -0.08, 0.1)) end

	AB.r15NameTag(rig, "Big Earl")
	return rig
end
