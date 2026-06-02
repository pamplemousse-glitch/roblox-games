-- BakerWithApron — R6 rig in cream shirt + pink apron + brown pants + mustache + chef hat.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME  = "BakerWithApron"
local CREAM = Color3.fromRGB(255, 240, 220)
local PINK  = Color3.fromRGB(232, 130, 165)
local HAIR  = Color3.fromRGB(60, 45, 35)
local BREAD = Color3.fromRGB(212, 168, 82)
local DOUGH = Color3.fromRGB(220, 170, 110)

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
	local rig = AB.r6Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = Color3.fromRGB(235, 195, 165),
		shirt = CREAM,
		pants = Color3.fromRGB(92, 57, 36),
	})
	local torso = rig:FindFirstChild("Torso") :: BasePart
	if torso then
		-- Pink apron front + neck strap + waist tie
		weldTo(rig, torso, "Apron",      Vector3.new(1.8, 1.95, 0.1), PINK, CFrame.new(0, 0, 0.6))
		weldTo(rig, torso, "ApronStrap", Vector3.new(0.3, 0.9, 0.05), PINK, CFrame.new(0, 1.0, 0.6))
		weldTo(rig, torso, "ApronTie",   Vector3.new(2.05, 0.25, 1.05), PINK, CFrame.new(0, -0.85, 0))
		-- Flour-dust specks on apron
		for i = 1, 5 do
			local x = (math.random() - 0.5) * 1.4
			local y = (math.random() - 0.5) * 1.6
			weldTo(rig, torso, "Flour_" .. i, Vector3.new(0.12, 0.12, 0.12), CREAM, CFrame.new(x, y, 0.66), Enum.PartType.Ball)
		end
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Big bushy mustache
		weldTo(rig, head, "Mustache",  Vector3.new(1.3, 0.3, 0.3), HAIR, CFrame.new(0, -0.18, 0.45))
		weldTo(rig, head, "MustacheL", Vector3.new(0.35, 0.35, 0.35), HAIR, CFrame.new(-0.55, -0.18, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "MustacheR", Vector3.new(0.35, 0.35, 0.35), HAIR, CFrame.new( 0.55, -0.18, 0.5), Enum.PartType.Ball)
	end
	-- Hair + chef hat
	AB.r6Hat(rig, Vector3.new(2.1, 0.4, 1.1), HAIR,  0.55, "Hair")
	AB.r6Hat(rig, Vector3.new(1.6, 0.35, 1.6), CREAM, 1.0, "HatBand")
	AB.r6Hat(rig, Vector3.new(2.0, 1.4, 2.0), CREAM, 1.95, "HatPuff", Enum.PartType.Ball)
	-- Loaf of bread in right hand
	local rArm = rig:FindFirstChild("Right Arm") :: BasePart
	if rArm then
		weldTo(rig, rArm, "BreadLoaf", Vector3.new(0.9, 0.7, 2.2), BREAD, CFrame.new(0.2, -1.2, 0))
		weldTo(rig, rArm, "BreadEndA", Vector3.new(0.8, 0.7, 0.7), BREAD, CFrame.new(0.2, -1.2, -1.0), Enum.PartType.Ball)
		weldTo(rig, rArm, "BreadEndB", Vector3.new(0.8, 0.7, 0.7), BREAD, CFrame.new(0.2, -1.2,  1.0), Enum.PartType.Ball)
		for i = 1, 2 do
			weldTo(rig, rArm, "Slash_" .. i, Vector3.new(0.6, 0.08, 0.2), DOUGH,
				CFrame.new(0.2, -1.0, -0.4 + (i - 1) * 0.8) * CFrame.Angles(0, 0, math.rad(30)))
		end
	end
	AB.r6NameTag(rig, NAME)
	return rig
end
