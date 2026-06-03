-- JukeboxDancer — R15 retrofit (polish A). Poodle skirt, sweater, auburn ponytail.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "JukeboxDancer"
local SKIN    = Color3.fromRGB(245, 215, 185)
local SKIRT   = Color3.fromRGB(255, 200, 215)
local SWEATER = Color3.fromRGB(245, 245, 240)
local HAIR_AU = Color3.fromRGB(160, 80, 50)
local DARK    = Color3.fromRGB(30, 30, 35)
local PINK    = Color3.fromRGB(255, 130, 180)
local TEAL    = Color3.fromRGB(127, 202, 194)

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
		shirt = SWEATER,
		pants = SKIN,  -- bare legs (skirt covers most)
	})
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Flaring pink poodle skirt
		weldTo(rig, hrp, "SkirtBot",   Vector3.new(3.0, 1.5, 3.0), SKIRT, CFrame.new(0, -2.0, 0), Enum.PartType.Cylinder)
		weldTo(rig, hrp, "SkirtTop",   Vector3.new(2.0, 1.0, 2.0), SKIRT, CFrame.new(0, -1.0, 0), Enum.PartType.Cylinder)
		-- Poodle applique on skirt
		weldTo(rig, hrp, "PoodleBody", Vector3.new(0.6, 0.6, 0.6), SWEATER, CFrame.new(0.4, -2.3, 1.5), Enum.PartType.Ball)
		weldTo(rig, hrp, "PoodleHead", Vector3.new(0.3, 0.3, 0.3), SWEATER, CFrame.new(0.8, -2.0, 1.5), Enum.PartType.Ball)
		weldTo(rig, hrp, "PoodleEar",  Vector3.new(0.15, 0.15, 0.15), SWEATER, CFrame.new(0.9, -1.8, 1.4), Enum.PartType.Ball)
		weldTo(rig, hrp, "PoodleTail", Vector3.new(0.2, 0.2, 0.2), SWEATER, CFrame.new(0.0, -2.1, 1.5), Enum.PartType.Ball)
		-- Pink leash
		weldTo(rig, hrp, "PoodleLeash", Vector3.new(0.05, 0.5, 0.05), PINK, CFrame.new(0.5, -1.5, 1.4) * CFrame.Angles(0, 0, math.rad(45)))
		-- Varsity "C" letter
		local letter = weldTo(rig, hrp, "VarsityC", Vector3.new(0.6, 0.6, 0.1), TEAL, CFrame.new(0, 0.2, 0.55))
		AB.billboard(letter, "C", Vector2.new(40, 40), 0)
		-- Neckline pink trim
		weldTo(rig, hrp, "NeckTrim",   Vector3.new(1.4, 0.15, 0.95), PINK, CFrame.new(0, 1.1, 0))
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Long auburn ponytail trailing back
		weldTo(rig, head, "PonytailHi", Vector3.new(0.6, 0.6, 0.6), HAIR_AU, CFrame.new(0, 0.6, -0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Ponytail1",  Vector3.new(0.7, 0.7, 0.7), HAIR_AU, CFrame.new(-0.2, -0.1, -1.4), Enum.PartType.Ball)
		weldTo(rig, head, "Ponytail2",  Vector3.new(0.6, 0.6, 0.6), HAIR_AU, CFrame.new(-0.4, -0.8, -2.0), Enum.PartType.Ball)
		weldTo(rig, head, "Ponytail3",  Vector3.new(0.5, 0.5, 0.5), HAIR_AU, CFrame.new(-0.5, -1.4, -2.6), Enum.PartType.Ball)
		-- Pink ribbon
		weldTo(rig, head, "Ribbon",     Vector3.new(0.6, 0.3, 0.6), PINK, CFrame.new(0, 0.7, -0.5))
		-- Hair top
		weldTo(rig, head, "HairFront",  Vector3.new(1.4, 0.5, 0.3), HAIR_AU, CFrame.new(0, 0.6, 0.4))
		-- Eyes + smile
		weldTo(rig, head, "EyeL",       Vector3.new(0.15, 0.15, 0.15), DARK, CFrame.new(-0.3, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR",       Vector3.new(0.15, 0.15, 0.15), DARK, CFrame.new( 0.3, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "Smile",      Vector3.new(0.5, 0.1, 0.08), PINK, CFrame.new(0, -0.4, 0.55))
	end
	AB.r15NameTag(rig, "JukeboxDancer")
	return rig
end
