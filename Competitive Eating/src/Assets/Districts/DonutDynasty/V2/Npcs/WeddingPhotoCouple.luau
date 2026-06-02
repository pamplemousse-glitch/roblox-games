-- WeddingPhotoCouple — pair of R15 rigs (Bride + Groom) standing on an aisle, ready for a photo.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "WeddingPhotoCouple"
local CREAM   = Color3.fromRGB(255, 240, 220)
local PINK    = Color3.fromRGB(255, 200, 214)
local DEEP    = Color3.fromRGB(232, 130, 165)
local MINT    = Color3.fromRGB(180, 230, 200)
local TUX     = Color3.fromRGB(60, 45, 35)
local HAIR_B  = Color3.fromRGB(220, 200, 160)
local HAIR_G  = Color3.fromRGB(60, 40, 30)
local GOLD    = Color3.fromRGB(212, 168, 82)

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
	local wrapper = Instance.new("Model")
	wrapper.Name   = NAME
	wrapper.Parent = parent

	-- Aisle base (sits on ground, y=0.1; originCF.Y=6 → offset -5.9)
	local aisle = Instance.new("Part")
	aisle.Name = "Aisle"; aisle.Size = Vector3.new(8, 0.2, 4); aisle.Color = CREAM
	aisle.Material = Enum.Material.SmoothPlastic; aisle.Anchored = true; aisle.CanCollide = false
	aisle.CFrame = originCF * CFrame.new(0, -5.9, 0); aisle.Parent = wrapper

	-- Bride: cream dress, light updo, veil, bouquet. Torso accessories ride on
	-- HumanoidRootPart so the original R6-Torso offsets keep their world Y.
	local bride = AB.r15Rig(wrapper, originCF * CFrame.new(-2, -3, 0), "Bride", {
		skin = Color3.fromRGB(248, 218, 198), shirt = CREAM, pants = CREAM,
	})
	local bHrp = bride:FindFirstChild("HumanoidRootPart") :: BasePart
	if bHrp then
		weldTo(bride, bHrp, "Belt", Vector3.new(2.05, 0.25, 1.05), PINK, CFrame.new(0, -0.9, 0))
		-- Veil hanging behind torso
		weldTo(bride, bHrp, "Veil", Vector3.new(2.3, 2.6, 0.15), CREAM, CFrame.new(0, 0.5, -0.6))
		-- Bouquet held in right hand area
		weldTo(bride, bHrp, "BouquetStems", Vector3.new(0.5, 0.2, 0.5), MINT, CFrame.new(1.05, -0.4, 0.8), Enum.PartType.Cylinder)
		weldTo(bride, bHrp, "BouquetA", Vector3.new(0.55, 0.55, 0.55), PINK, CFrame.new(0.95, -0.15, 0.85), Enum.PartType.Ball)
		weldTo(bride, bHrp, "BouquetB", Vector3.new(0.55, 0.55, 0.55), DEEP, CFrame.new(1.20, -0.15, 0.85), Enum.PartType.Ball)
		weldTo(bride, bHrp, "BouquetC", Vector3.new(0.55, 0.55, 0.55), PINK, CFrame.new(1.05,  0.10, 0.95), Enum.PartType.Ball)
	end
	AB.r15Hat(bride, Vector3.new(2.1, 0.6, 1.1), HAIR_B, 0.55, "BrideHair")
	AB.r15Hat(bride, Vector3.new(1.4, 0.2, 1.4), GOLD,   1.0,  "Tiara")
	AB.r15Hat(bride, Vector3.new(0.7, 0.7, 0.7), HAIR_B, 1.3,  "Bun", Enum.PartType.Ball)
	AB.r15NameTag(bride, "Bride")

	-- Groom: brown tux, pink bowtie, white shirt strip
	local groom = AB.r15Rig(wrapper, originCF * CFrame.new(2, -3, 0), "Groom", {
		skin = Color3.fromRGB(230, 195, 170), shirt = TUX, pants = TUX,
	})
	local gHrp = groom:FindFirstChild("HumanoidRootPart") :: BasePart
	if gHrp then
		-- White shirt strip + pink bowtie
		weldTo(groom, gHrp, "Shirt",     Vector3.new(0.7, 1.6, 0.1), CREAM, CFrame.new(0, 0.2, 0.55))
		weldTo(groom, gHrp, "BowtieL",   Vector3.new(0.35, 0.35, 0.3), PINK, CFrame.new(-0.3, 0.85, 0.6), Enum.PartType.Ball)
		weldTo(groom, gHrp, "BowtieR",   Vector3.new(0.35, 0.35, 0.3), PINK, CFrame.new( 0.3, 0.85, 0.6), Enum.PartType.Ball)
		weldTo(groom, gHrp, "BowKnot",   Vector3.new(0.22, 0.22, 0.2), PINK, CFrame.new(0, 0.85, 0.6))
		weldTo(groom, gHrp, "LapelFlw",  Vector3.new(0.3, 0.3, 0.3), DEEP, CFrame.new(-0.5, 0.4, 0.6), Enum.PartType.Ball)
	end
	AB.r15Hat(groom, Vector3.new(2.1, 0.55, 1.1), HAIR_G, 0.55, "GroomHair")
	AB.r15NameTag(groom, "Groom")

	wrapper.PrimaryPart = bride.PrimaryPart
	return wrapper
end
