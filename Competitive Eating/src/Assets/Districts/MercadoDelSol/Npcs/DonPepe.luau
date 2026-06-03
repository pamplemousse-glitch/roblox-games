-- DonPepe — R15 retrofit (polish A): terracotta poncho, tan sombrero, gray mustache.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME        = "DonPepe"
local SKIN        = Color3.fromRGB(210, 165, 130)
local PONCHO_TERR = Color3.fromRGB(196, 95, 44)
local PONCHO_TRIM = Color3.fromRGB(255, 184, 52)
local PANTS_DARK  = Color3.fromRGB(70, 50, 35)
local HAT_TAN     = Color3.fromRGB(220, 190, 130)
local HAT_BAND    = Color3.fromRGB(140, 80, 50)
local MUSTACHE    = Color3.fromRGB(220, 215, 210)
local BLACK       = Color3.fromRGB(30, 25, 25)

-- weldTo: cf-relative welded accessory. Pass `shape` for spheres/cylinders.
-- For cylinders, the caller is responsible for any rotation (Roblox cylinders
-- lie along their X-axis), since r15Hat doesn't support rotation but BakerWithApron's
-- weldTo helper does via the offset CFrame argument.
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
		shirt = PONCHO_TERR,
		pants = PANTS_DARK,
	})

	-- Poncho trim stripe across chest
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		weldTo(rig, hrp, "PonchoTrim", Vector3.new(2.1, 0.35, 1.05), PONCHO_TRIM, CFrame.new(0, -0.5, 0))
	end

	-- Face: eyes + gray mustache
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		weldTo(rig, head, "Eye_L",    Vector3.new(0.18, 0.18, 0.18), BLACK,    CFrame.new(-0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Eye_R",    Vector3.new(0.18, 0.18, 0.18), BLACK,    CFrame.new( 0.35, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Mustache", Vector3.new(1.2, 0.25, 0.2),   MUSTACHE, CFrame.new(0, -0.35, 0.45))
		-- Sombrero: brim is a flat disc (cylinder rotated 90deg Z), crown stands upright.
		weldTo(rig, head, "HatBrim",  Vector3.new(0.3, 4.5, 4.5), HAT_TAN,
			CFrame.new(0, 0.85, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, head, "HatCrown", Vector3.new(1.2, 2.45, 2.45), HAT_TAN,
			CFrame.new(0, 1.6, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
		weldTo(rig, head, "HatBand",  Vector3.new(0.25, 2.5, 2.5), HAT_BAND,
			CFrame.new(0, 1.1, 0) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder)
	end

	AB.r15NameTag(rig, "Don Pepe")
	return rig
end
