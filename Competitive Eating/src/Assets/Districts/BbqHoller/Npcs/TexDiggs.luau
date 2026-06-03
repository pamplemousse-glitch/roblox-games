-- TexDiggs — R15 retrofit (polish A)
-- Lean cowboy: cream shirt + denim jeans, dark vest, brass belt buckle,
-- red kerchief, black cowboy hat, boot spurs. Preserves the lean cowboy
-- silhouette + buckle + spurs.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME     = "TexDiggs"
local SKIN     = Color3.fromRGB(215, 170, 130)
local SHIRT    = Color3.fromRGB(230, 220, 195)
local VEST     = Color3.fromRGB(60, 60, 80)
local DENIM    = Color3.fromRGB(70, 90, 130)
local BOOT     = Color3.fromRGB(60, 35, 20)
local HAT      = Color3.fromRGB(35, 25, 22)
local BUCKLE   = Color3.fromRGB(220, 180, 60)
local KERCHIEF = Color3.fromRGB(160, 40, 40)
local STUBBLE  = Color3.fromRGB(60, 50, 45)

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
		pants = DENIM,
	})

	local upperTorso = rig:FindFirstChild("UpperTorso") :: BasePart
	if upperTorso then
		-- Vest panels (open in the middle, dark fabric on left/right + back)
		weldTo(rig, upperTorso, "VestL",    Vector3.new(0.7, 1.25, 0.3), VEST, CFrame.new(-0.65, 0, 0.5))
		weldTo(rig, upperTorso, "VestR",    Vector3.new(0.7, 1.25, 0.3), VEST, CFrame.new( 0.65, 0, 0.5))
		weldTo(rig, upperTorso, "VestBack", Vector3.new(2.0, 1.25, 0.2), VEST, CFrame.new(0, 0, -0.55))
	end

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Red kerchief at the neck
		weldTo(rig, hrp, "Kerchief",    Vector3.new(2.0, 0.5, 1.3), KERCHIEF, CFrame.new(0, 1.45, 0))
		-- Belt + brass buckle below the torso
		weldTo(rig, hrp, "Belt",        Vector3.new(2.2, 0.4, 1.1), HAT, CFrame.new(0, -1.15, 0))
		weldTo(rig, hrp, "BeltBuckle",  Vector3.new(0.75, 0.55, 0.18), BUCKLE, CFrame.new(0, -1.15, 0.55))
	end

	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "EyeL", Vector3.new(0.22, 0.22, 0.22), Color3.new(0, 0, 0), CFrame.new(-0.4, 0.15, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR", Vector3.new(0.22, 0.22, 0.22), Color3.new(0, 0, 0), CFrame.new( 0.4, 0.15, 0.5), Enum.PartType.Ball)
		-- Stubble on the chin
		weldTo(rig, head, "Stubble", Vector3.new(1.3, 0.22, 0.25), STUBBLE, CFrame.new(0, -0.35, 0.5))
	end

	-- Black cowboy hat: wide brim + tall crown + red hat band
	AB.r15Hat(rig, Vector3.new(4.6, 0.25, 4.6), HAT,      0.85, "HatBrim",  Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.8, 1.6, 2.8), HAT,       1.85, "HatCrown", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.85, 0.35, 2.85), KERCHIEF, 1.2, "HatBand", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.4, 0.2, 0.6), HAT, 0.85, "BrimDip")

	-- Boots + brass spurs at the heels
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if lFoot then
		weldTo(rig, lFoot, "BootL", Vector3.new(1.3, 0.9, 1.55), BOOT, CFrame.new(0, -0.1, 0.1))
		weldTo(rig, lFoot, "SpurL", Vector3.new(0.35, 0.35, 0.35), BUCKLE, CFrame.new(0, -0.1, -0.7), Enum.PartType.Ball)
	end
	if rFoot then
		weldTo(rig, rFoot, "BootR", Vector3.new(1.3, 0.9, 1.55), BOOT, CFrame.new(0, -0.1, 0.1))
		weldTo(rig, rFoot, "SpurR", Vector3.new(0.35, 0.35, 0.35), BUCKLE, CFrame.new(0, -0.1, -0.7), Enum.PartType.Ball)
	end

	AB.r15NameTag(rig, "Tex Diggs")
	return rig
end
