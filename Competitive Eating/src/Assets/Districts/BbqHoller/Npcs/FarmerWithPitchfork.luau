-- FarmerWithPitchfork — R15 retrofit (polish A)
-- Overalls, red plaid shirt, boots, straw hat, holding a pitchfork over
-- the shoulder. Preserves the overalls + straw hat + pitchfork identity.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME      = "FarmerWithPitchfork"
local SKIN      = Color3.fromRGB(220, 175, 135)
local OVERALL   = Color3.fromRGB(70, 95, 145)
local OVER_D    = Color3.fromRGB(50, 70, 105)
local SHIRT_R   = Color3.fromRGB(180, 50, 40)
local STRAW     = Color3.fromRGB(232, 200, 112)
local BAND_R    = Color3.fromRGB(170, 40, 40)
local BOOT      = Color3.fromRGB(60, 38, 25)
local HAIR      = Color3.fromRGB(150, 110, 60)
local STEEL     = Color3.fromRGB(135, 135, 140)
local DARK_WOOD = Color3.fromRGB(95, 65, 38)
local BUTTON    = Color3.fromRGB(220, 180, 60)

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
		shirt = SHIRT_R,    -- plaid shirt underneath
		pants = OVERALL,
	})

	local upperTorso = rig:FindFirstChild("UpperTorso") :: BasePart
	if upperTorso then
		-- Overall bib (denim square across the chest)
		weldTo(rig, upperTorso, "OverallBib",  Vector3.new(1.6, 1.05, 0.2), OVERALL, CFrame.new(0, -0.1, 0.55))
		weldTo(rig, upperTorso, "BibSeamL",    Vector3.new(0.15, 1.05, 0.22), OVER_D, CFrame.new(-0.8, -0.1, 0.55))
		weldTo(rig, upperTorso, "BibSeamR",    Vector3.new(0.15, 1.05, 0.22), OVER_D, CFrame.new( 0.8, -0.1, 0.55))
		-- Overall straps over shoulders
		weldTo(rig, upperTorso, "StrapL",      Vector3.new(0.5, 1.4, 0.3), OVERALL, CFrame.new(-0.8, 0.5, 0.4))
		weldTo(rig, upperTorso, "StrapR",      Vector3.new(0.5, 1.4, 0.3), OVERALL, CFrame.new( 0.8, 0.5, 0.4))
		-- Brass buttons on the straps
		weldTo(rig, upperTorso, "ButtonL", Vector3.new(0.28, 0.28, 0.28), BUTTON, CFrame.new(-0.8, -0.05, 0.65), Enum.PartType.Ball)
		weldTo(rig, upperTorso, "ButtonR", Vector3.new(0.28, 0.28, 0.28), BUTTON, CFrame.new( 0.8, -0.05, 0.65), Enum.PartType.Ball)
	end

	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Squinting eyes
		weldTo(rig, head, "EyeL", Vector3.new(0.35, 0.1, 0.1), Color3.new(0, 0, 0), CFrame.new(-0.4, 0.15, 0.5))
		weldTo(rig, head, "EyeR", Vector3.new(0.35, 0.1, 0.1), Color3.new(0, 0, 0), CFrame.new( 0.4, 0.15, 0.5))
		-- Piece of straw between the lips
		weldTo(rig, head, "Straw", Vector3.new(0.15, 0.15, 1.6), STRAW, CFrame.new(0.4, -0.3, 0.9))
	end

	-- Hair + straw hat (wide brim + crown + red band)
	AB.r15Hat(rig, Vector3.new(2.15, 0.3, 2.15), HAIR, 0.55, "Hair")
	AB.r15Hat(rig, Vector3.new(4.5, 0.3, 4.5), STRAW,  0.95, "HatBrim", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.5, 1.0, 2.5), STRAW,  1.5,  "HatCrown", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(2.55, 0.28, 2.55), BAND_R, 1.15, "HatBand", Enum.PartType.Cylinder)

	-- Boots welded to feet
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if lFoot then weldTo(rig, lFoot, "BootL", Vector3.new(1.4, 0.6, 1.6), BOOT, CFrame.new(0, -0.1, 0.1)) end
	if rFoot then weldTo(rig, rFoot, "BootR", Vector3.new(1.4, 0.6, 1.6), BOOT, CFrame.new(0, -0.1, 0.1)) end

	-- Pitchfork held in right hand, angled diagonally over the shoulder.
	-- R15 RightHand origin requires +1.2 Y compensation vs R6 Right Arm.
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		local handleCF = CFrame.new(0.3, 3.0, -0.4) * CFrame.Angles(math.rad(-35), 0, math.rad(-15))
		weldTo(rig, rHand, "PFHandle", Vector3.new(0.4, 9, 0.4), DARK_WOOD, handleCF)
		-- Pitchfork head: socket + 3 prongs aligned with the handle tilt
		local headOffset = CFrame.new(0.3, 3.0, -0.4) * CFrame.Angles(math.rad(-35), 0, math.rad(-15)) * CFrame.new(0, 4.6, 0)
		weldTo(rig, rHand, "Socket", Vector3.new(1.4, 0.6, 0.5), STEEL, headOffset)
		for i, x in {-0.5, 0, 0.5} do
			weldTo(rig, rHand, "Prong_" .. i, Vector3.new(0.18, 1.8, 0.18), STEEL,
				headOffset * CFrame.new(x, 1.0, 0))
		end
	end

	AB.r15NameTag(rig, "Farmer")
	return rig
end
