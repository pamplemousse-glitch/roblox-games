-- SmashRiley — R15 retrofit (polish A). White apron, red bandana, spatula, chef cap, ketchup stain.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "SmashRiley"
local SKIN    = Color3.fromRGB(225, 185, 145)
local APRON   = Color3.fromRGB(255, 245, 232)
local BANDANA = Color3.fromRGB(255, 48, 48)
local PANTS   = Color3.fromRGB(60, 60, 70)
local CHROME  = Color3.fromRGB(176, 176, 176)
local KETCHUP = Color3.fromRGB(180, 30, 30)
local CHEF_W  = Color3.fromRGB(248, 248, 248)
local DARK    = Color3.fromRGB(30, 30, 35)

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
		shirt = APRON,
		pants = PANTS,
	})
	-- Torso accessories ride on HumanoidRootPart.
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- White apron front, red ketchup stain, neck straps
		weldTo(rig, hrp, "Apron",      Vector3.new(1.8, 1.95, 0.1), APRON, CFrame.new(0, 0, 0.6))
		weldTo(rig, hrp, "KetchupStain", Vector3.new(0.5, 0.5, 0.5), KETCHUP, CFrame.new(0.5, 0.1, 0.65), Enum.PartType.Ball)
		weldTo(rig, hrp, "StrapL",     Vector3.new(0.3, 0.8, 0.15), BANDANA, CFrame.new(-0.7, 1.2, 0.55))
		weldTo(rig, hrp, "StrapR",     Vector3.new(0.3, 0.8, 0.15), BANDANA, CFrame.new( 0.7, 1.2, 0.55))
		-- Belt + chrome buckle
		weldTo(rig, hrp, "Belt",       Vector3.new(2.05, 0.4, 1.05), DARK,   CFrame.new(0, -1.1, 0))
		local buckle = weldTo(rig, hrp, "Buckle", Vector3.new(0.4, 0.5, 0.1), CHROME, CFrame.new(0, -1.1, 0.55))
		buckle.Material = Enum.Material.Metal; buckle.Reflectance = 0.4
		-- Apron pocket + pen
		weldTo(rig, hrp, "AprPocket",  Vector3.new(0.6, 0.7, 0.05), APRON:Lerp(DARK, 0.1), CFrame.new(-0.5, -0.3, 0.66))
		weldTo(rig, hrp, "PocketPen",  Vector3.new(0.1, 0.7, 0.1), BANDANA, CFrame.new(-0.5, 0, 0.7))
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Eyes + smile + red bandana wrap
		weldTo(rig, head, "EyeL",     Vector3.new(0.13, 0.13, 0.13), DARK, CFrame.new(-0.3, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR",     Vector3.new(0.13, 0.13, 0.13), DARK, CFrame.new( 0.3, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Smile",    Vector3.new(0.6, 0.08, 0.1), DARK, CFrame.new(0, -0.3, 0.55))
		weldTo(rig, head, "Bandana",  Vector3.new(1.5, 0.5, 1.5), BANDANA, CFrame.new(0, 0.5, 0))
		weldTo(rig, head, "BandanaKnot", Vector3.new(0.4, 0.4, 0.4), BANDANA, CFrame.new(0, 0.6, -0.9), Enum.PartType.Ball)
		-- Stubble dots
		weldTo(rig, head, "Stubble1", Vector3.new(0.06, 0.06, 0.06), DARK, CFrame.new(-0.3, -0.45, 0.45), Enum.PartType.Ball)
		weldTo(rig, head, "Stubble2", Vector3.new(0.06, 0.06, 0.06), DARK, CFrame.new( 0.2, -0.5, 0.47), Enum.PartType.Ball)
	end
	-- Chef cap stack on top of head
	AB.r15Hat(rig, Vector3.new(1.2, 0.8, 1.2), CHEF_W, 1.0, "CapBand", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(1.5, 1.5, 1.5), CHEF_W, 1.9, "CapPoof1", Enum.PartType.Ball)
	AB.r15Hat(rig, Vector3.new(1.2, 1.2, 1.2), CHEF_W, 2.4, "CapPoof2", Enum.PartType.Ball)
	-- Spatula in right hand (R15 RightHand is at local Y=-1.2 so all Y offsets +1.2 vs R6).
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "SpatulaHandle", Vector3.new(1.6, 0.15, 0.15), Color3.fromRGB(140, 90, 50),
			CFrame.new(0, -0.6, 0) * CFrame.Angles(0, 0, math.rad(-90)))
		local spat = weldTo(rig, rHand, "SpatulaBlade", Vector3.new(0.9, 0.08, 1.2), CHROME, CFrame.new(0, -1.5, 0))
		spat.Material = Enum.Material.Metal; spat.Reflectance = 0.5
	end
	AB.r15NameTag(rig, "Smash Riley")
	return rig
end
