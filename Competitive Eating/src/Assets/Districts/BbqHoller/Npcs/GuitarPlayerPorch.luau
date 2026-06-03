-- GuitarPlayerPorch — R15 retrofit (polish A)
-- Seated musician on a stool: jeans, denim vest over white shirt, scruffy
-- beard, cowboy hat. Holds an acoustic guitar across the lap. The seated
-- pose is approximated by sitting the rig on a stool prop welded to the HRP.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME      = "GuitarPlayerPorch"
local SKIN      = Color3.fromRGB(225, 180, 140)
local DENIM     = Color3.fromRGB(60, 80, 130)
local DENIM_D   = Color3.fromRGB(40, 55, 95)
local SHIRT_W   = Color3.fromRGB(245, 240, 225)
local PANTS     = Color3.fromRGB(55, 70, 100)
local BOOT      = Color3.fromRGB(70, 50, 30)
local HAT_BROWN = Color3.fromRGB(95, 65, 38)
local HAT_DARK  = Color3.fromRGB(60, 40, 22)
local HAIR      = Color3.fromRGB(95, 70, 45)
local BEARD     = Color3.fromRGB(75, 55, 35)
local GUITAR    = Color3.fromRGB(170, 105, 55)
local GUITAR_D  = Color3.fromRGB(110, 65, 30)
local STRING    = Color3.fromRGB(220, 220, 225)
local STOOL     = Color3.fromRGB(120, 85, 50)

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
	-- White shirt + jean torso. Seated pose: we still spawn a standing R15
	-- rig (the joint chain handles posing as data); the stool is welded under
	-- the LowerTorso to give the visual impression of sitting.
	local rig = AB.r15Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = SKIN,
		shirt = SHIRT_W,
		pants = PANTS,
	})

	local upperTorso = rig:FindFirstChild("UpperTorso") :: BasePart
	if upperTorso then
		-- Denim vest panels over the white shirt
		weldTo(rig, upperTorso, "VestL",    Vector3.new(0.55, 1.25, 0.25), DENIM,   CFrame.new(-0.75, 0, 0.5))
		weldTo(rig, upperTorso, "VestR",    Vector3.new(0.55, 1.25, 0.25), DENIM,   CFrame.new( 0.75, 0, 0.5))
		weldTo(rig, upperTorso, "VestBack", Vector3.new(2.0, 1.25, 0.15),  DENIM,   CFrame.new(0, 0, -0.55))
		weldTo(rig, upperTorso, "StitchL",  Vector3.new(0.08, 1.25, 0.1),  DENIM_D, CFrame.new(-0.5, 0, 0.6))
		weldTo(rig, upperTorso, "StitchR",  Vector3.new(0.08, 1.25, 0.1),  DENIM_D, CFrame.new( 0.5, 0, 0.6))
	end

	local lowerTorso = rig:FindFirstChild("LowerTorso") :: BasePart
	if lowerTorso then
		-- Stool / barrel underneath (welded so it travels with the rig)
		weldTo(rig, lowerTorso, "Stool",      Vector3.new(2.6, 2.0, 2.6), STOOL,    CFrame.new(0, -1.5, 0), Enum.PartType.Cylinder)
		weldTo(rig, lowerTorso, "StoolBand1", Vector3.new(2.7, 0.2, 2.7), HAT_DARK, CFrame.new(0, -2.4, 0), Enum.PartType.Cylinder)
		weldTo(rig, lowerTorso, "StoolBand2", Vector3.new(2.7, 0.2, 2.7), HAT_DARK, CFrame.new(0, -0.7, 0), Enum.PartType.Cylinder)
	end

	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Thin lines for concentrating eyes
		weldTo(rig, head, "EyeL", Vector3.new(0.35, 0.1, 0.1), Color3.new(0, 0, 0), CFrame.new(-0.4, 0.15, 0.5))
		weldTo(rig, head, "EyeR", Vector3.new(0.35, 0.1, 0.1), Color3.new(0, 0, 0), CFrame.new( 0.4, 0.15, 0.5))
		-- Scruffy beard
		weldTo(rig, head, "Beard", Vector3.new(1.6, 0.9, 1.3), BEARD, CFrame.new(0, -0.55, 0.15))
	end

	-- Hair + cowboy hat (slightly tipped is implied — we use a flat brim here
	-- because r15Hat welds straight to the head; the tilt was cosmetic only)
	AB.r15Hat(rig, Vector3.new(2.1, 0.3, 2.1), HAIR, 0.55, "Hair")
	AB.r15Hat(rig, Vector3.new(4.8, 0.3, 4.8), HAT_BROWN, 0.95, "HatBrim", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.6, 1.4, 2.6), HAT_BROWN, 1.85, "HatCrown", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.65, 0.28, 2.65), HAT_DARK, 1.25, "HatBand", Enum.PartType.Cylinder)

	-- Boots on the feet
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if lFoot then weldTo(rig, lFoot, "BootL", Vector3.new(1.3, 0.6, 1.6), BOOT, CFrame.new(0, -0.1, 0.1)) end
	if rFoot then weldTo(rig, rFoot, "BootR", Vector3.new(1.3, 0.6, 1.6), BOOT, CFrame.new(0, -0.1, 0.1)) end

	-- Acoustic guitar slung from the right hand, body across the lap. The
	-- whole guitar is welded to the right hand so it pose-rides with the
	-- strumming arm.
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		local guitarCF = CFrame.new(-0.2, -1.6, 0.6) * CFrame.Angles(0, 0, math.rad(20))
		weldTo(rig, rHand, "GuitarBody", Vector3.new(3.4, 3.4, 3.4), GUITAR, guitarCF, Enum.PartType.Ball)
		weldTo(rig, rHand, "SoundHole",  Vector3.new(0.9, 0.1, 0.9), GUITAR_D, guitarCF * CFrame.new(0, 0, 1.6), Enum.PartType.Cylinder)
		weldTo(rig, rHand, "Bridge",     Vector3.new(1.0, 0.2, 0.3), GUITAR_D, guitarCF * CFrame.new(-1.2, 0, 1.6))
		-- Neck (long block oriented along X)
		weldTo(rig, rHand, "Neck", Vector3.new(0.6, 0.6, 7.0), GUITAR_D,
			guitarCF * CFrame.new(2.5, 0, 1.4) * CFrame.Angles(0, math.rad(90), 0))
		for i = 1, 5 do
			weldTo(rig, rHand, "Fret_" .. i, Vector3.new(0.55, 0.1, 0.42), STRING,
				guitarCF * CFrame.new(2.0 + i * 1.1, 0, 1.4))
		end
		weldTo(rig, rHand, "Headstock", Vector3.new(1.4, 0.4, 0.6), GUITAR_D,
			guitarCF * CFrame.new(8.5, 0.2, 1.4))
		for i = 1, 3 do
			weldTo(rig, rHand, "PegT_" .. i, Vector3.new(0.2, 0.2, 0.2), STRING,
				guitarCF * CFrame.new(8.3 + (i - 1) * 0.4, 0.5, 1.4), Enum.PartType.Ball)
			weldTo(rig, rHand, "PegB_" .. i, Vector3.new(0.2, 0.2, 0.2), STRING,
				guitarCF * CFrame.new(8.3 + (i - 1) * 0.4, -0.5, 1.4), Enum.PartType.Ball)
		end
		for i = 1, 6 do
			local offY = -0.3 + (i - 1) * 0.12
			weldTo(rig, rHand, "String_" .. i, Vector3.new(8.5, 0.04, 0.04), STRING,
				guitarCF * CFrame.new(2.5, offY, 1.42))
		end
	end

	AB.r15NameTag(rig, "Musician")
	return rig
end
