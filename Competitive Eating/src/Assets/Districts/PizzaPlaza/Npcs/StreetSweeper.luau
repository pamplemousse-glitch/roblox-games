-- StreetSweeper — R15 retrofit (polish A)
-- Giovanni: municipal worker with orange high-vis vest + blue cap,
-- wide broom in both hands, cig + ember + reflective stripes.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Giovanni"
local SKIN    = Color3.fromRGB(235, 200, 165)
local SHIRT   = Color3.fromRGB(60, 70, 90)
local VEST_OR = Color3.fromRGB(255, 150, 50)
local STRIPE  = Color3.fromRGB(200, 200, 210)
local PANTS_GR= Color3.fromRGB(60, 75, 60)
local CAP     = Color3.fromRGB(40, 60, 100)
local HAIR    = Color3.fromRGB(70, 50, 35)
local BROOM_HD= Color3.fromRGB(180, 130, 70)
local BRSTLE  = Color3.fromRGB(220, 180, 130)
local WD      = Color3.fromRGB(110, 75, 45)

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
		pants = PANTS_GR,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Orange high-vis vest + 2 reflective stripes + zipper
		weldTo(rig, hrp, "Vest",      Vector3.new(2.1, 2.0, 1.05), VEST_OR, CFrame.new(0, 0, 0))
		weldTo(rig, hrp, "StripeTop", Vector3.new(2.15, 0.25, 1.1), STRIPE, CFrame.new(0, 0.6, 0))
		weldTo(rig, hrp, "StripeBot", Vector3.new(2.15, 0.25, 1.1), STRIPE, CFrame.new(0, -0.6, 0))
		weldTo(rig, hrp, "Zipper",    Vector3.new(0.1, 1.9, 0.1), Color3.fromRGB(180, 180, 190), CFrame.new(0, 0, 0.55))
		-- Dustpan on belt
		weldTo(rig, hrp, "Dustpan",   Vector3.new(0.9, 0.4, 0.7), Color3.fromRGB(180, 50, 50), CFrame.new(1.0, -0.9, 0.4))
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Stubble + tired eyes + cigarette with neon ember + smoke wisp
		weldTo(rig, head, "Stubble",   Vector3.new(1.4, 0.35, 0.4), Color3.fromRGB(120, 90, 70), CFrame.new(0, -0.4, 0.4))
		weldTo(rig, head, "EyeL",      Vector3.new(0.35, 0.08, 0.1), Color3.fromRGB(60, 40, 35), CFrame.new(-0.4, 0.1, 0.5))
		weldTo(rig, head, "EyeR",      Vector3.new(0.35, 0.08, 0.1), Color3.fromRGB(60, 40, 35), CFrame.new( 0.4, 0.1, 0.5))
		weldTo(rig, head, "Cig",       Vector3.new(0.6, 0.08, 0.08), Color3.fromRGB(240, 230, 200), CFrame.new(0.5, -0.4, 0.55))
		local ember = weldTo(rig, head, "CigEmber", Vector3.new(0.12, 0.12, 0.12), Color3.fromRGB(255, 100, 30),
			CFrame.new(0.85, -0.4, 0.55), Enum.PartType.Ball)
		AB.neon(ember)
		local smoke = weldTo(rig, head, "SmokeWisp", Vector3.new(0.18, 0.18, 0.18), Color3.fromRGB(240, 240, 240),
			CFrame.new(1.1, 0.05, 0.55), Enum.PartType.Ball)
		smoke.Transparency = 0.6
		-- Hair sticking out from sides of cap
		weldTo(rig, head, "HairL", Vector3.new(0.32, 0.32, 0.32), HAIR, CFrame.new(-0.85, 0.2, -0.1), Enum.PartType.Ball)
		weldTo(rig, head, "HairR", Vector3.new(0.32, 0.32, 0.32), HAIR, CFrame.new( 0.85, 0.2, -0.1), Enum.PartType.Ball)
	end
	-- Worker's cap (top + brim)
	AB.r15Hat(rig, Vector3.new(2.0, 0.5, 2.0), CAP, 0.85, "CapTop")
	AB.r15Hat(rig, Vector3.new(0.4, 0.1, 1.4), CAP, 0.6, "CapBrim")

	-- Yellow work gloves welded over both hands
	local lHand = rig:FindFirstChild("LeftHand") :: BasePart
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if lHand then weldTo(rig, lHand, "GloveL", Vector3.new(1.1, 0.5, 1.1), Color3.fromRGB(220, 180, 80), CFrame.new(0, 0, 0)) end
	if rHand then weldTo(rig, rHand, "GloveR", Vector3.new(1.1, 0.5, 1.1), Color3.fromRGB(220, 180, 80), CFrame.new(0, 0, 0)) end

	-- Broom held in right hand (handle + wide bristled head)
	if rHand then
		weldTo(rig, rHand, "BroomHandle", Vector3.new(0.3, 6, 0.3), WD,
			CFrame.new(0, 0.5, 1.5) * CFrame.Angles(math.rad(-30), 0, 0))
		weldTo(rig, rHand, "BroomHead",   Vector3.new(3, 0.5, 1.2), BROOM_HD,
			CFrame.new(0, 3.3, 4.0) * CFrame.Angles(math.rad(-30), 0, 0))
		weldTo(rig, rHand, "BristleBand", Vector3.new(3.1, 0.2, 1.3), Color3.fromRGB(180, 180, 190),
			CFrame.new(0, 3.5, 4.0) * CFrame.Angles(math.rad(-30), 0, 0))
		-- Bristles (7 rows)
		for i = -3, 3 do
			weldTo(rig, rHand, "Bristle_" .. (i + 4), Vector3.new(0.2, 0.8, 1),
				CFrame.new(i * 0.4, 2.7, 4.0) * CFrame.Angles(math.rad(-30), 0, 0))
		end
	end
	-- Swept debris pile (small, parked in front of HRP)
	if hrp then
		for i = 1, 5 do
			local trashCol = (i % 3 == 0) and Color3.fromRGB(220, 60, 50) or (i % 3 == 1) and Color3.fromRGB(240, 220, 80) or Color3.fromRGB(80, 80, 90)
			weldTo(rig, hrp, "Trash_" .. i, Vector3.new(0.25, 0.25, 0.25), trashCol,
				CFrame.new((math.random() - 0.5) * 2.0, -1.5, 3.5 + (math.random() - 0.5) * 0.6), Enum.PartType.Ball)
		end
	end

	AB.r15NameTag(rig, NAME)
	return rig
end
