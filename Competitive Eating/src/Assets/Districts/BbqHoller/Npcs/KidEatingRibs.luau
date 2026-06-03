-- KidEatingRibs — R15 retrofit (polish A)
-- Striped shirt + shorts, holding a sauce-coated rack of ribs up to mouth.
-- Preserves the striped shirt + sauce stains + rib rack + sparkle eyes.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME      = "KidEatingRibs"
local SKIN      = Color3.fromRGB(245, 210, 175)
local STRIPE_R  = Color3.fromRGB(220, 60, 60)
local STRIPE_W  = Color3.fromRGB(240, 235, 225)
local SHORTS    = Color3.fromRGB(55, 70, 100)
local SHOE      = Color3.fromRGB(220, 220, 225)
local HAIR      = Color3.fromRGB(180, 130, 70)
local RIB_MEAT  = Color3.fromRGB(140, 70, 45)
local RIB_DARK  = Color3.fromRGB(95, 45, 30)
local SAUCE     = Color3.fromRGB(140, 35, 30)
local BONE      = Color3.fromRGB(235, 225, 200)

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
	-- Slightly shorter kid scale via the default r15 rig + visual cues; the
	-- striped shirt and shorts read kid-ish even at the standard height.
	local rig = AB.r15Rig(parent, originCF * CFrame.new(0, -3, 0), NAME, {
		skin  = SKIN,
		shirt = STRIPE_R,
		pants = SHORTS,
	})

	local upperTorso = rig:FindFirstChild("UpperTorso") :: BasePart
	if upperTorso then
		-- White stripes across the torso (alternating bands)
		for i, y in {0.45, 0.0, -0.45} do
			weldTo(rig, upperTorso, "Stripe_" .. i, Vector3.new(2.05, 0.3, 1.05), STRIPE_W, CFrame.new(0, y, 0))
		end
		-- Sauce stains on the shirt
		weldTo(rig, upperTorso, "Stain_1", Vector3.new(0.4, 0.4, 0.4), SAUCE, CFrame.new(-0.5, -0.2, 0.55), Enum.PartType.Ball)
		weldTo(rig, upperTorso, "Stain_2", Vector3.new(0.4, 0.4, 0.4), SAUCE, CFrame.new( 0.55, 0.3, 0.55), Enum.PartType.Ball)
	end

	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Big happy eyes + sparkles
		weldTo(rig, head, "EyeL",   Vector3.new(0.32, 0.32, 0.32), Color3.new(0, 0, 0),  CFrame.new(-0.35, 0.15, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "EyeR",   Vector3.new(0.32, 0.32, 0.32), Color3.new(0, 0, 0),  CFrame.new( 0.35, 0.15, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "SparkL", Vector3.new(0.12, 0.12, 0.12), STRIPE_W, CFrame.new(-0.30, 0.20, 0.6), Enum.PartType.Ball)
		weldTo(rig, head, "SparkR", Vector3.new(0.12, 0.12, 0.12), STRIPE_W, CFrame.new( 0.40, 0.20, 0.6), Enum.PartType.Ball)
		-- Open mouth + sauce around it
		weldTo(rig, head, "MouthOpen",      Vector3.new(0.9, 0.45, 0.18), Color3.new(0, 0, 0), CFrame.new(0, -0.35, 0.5))
		weldTo(rig, head, "MouthSauceL",    Vector3.new(0.25, 0.25, 0.25), SAUCE, CFrame.new(-0.5, -0.4, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "MouthSauceR",    Vector3.new(0.25, 0.25, 0.25), SAUCE, CFrame.new( 0.5, -0.4, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "MouthSauceChin", Vector3.new(0.25, 0.25, 0.25), SAUCE, CFrame.new(0, -0.55, 0.5), Enum.PartType.Ball)
	end

	-- Messy hair + a stray tuft
	AB.r15Hat(rig, Vector3.new(2.0, 0.5, 2.0), HAIR, 0.6, "Hair", Enum.PartType.Ball)
	AB.r15Hat(rig, Vector3.new(0.6, 0.6, 0.6), HAIR, 1.1, "HairTuft", Enum.PartType.Ball)

	-- Sneakers welded to feet
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if lFoot then weldTo(rig, lFoot, "ShoeL", Vector3.new(1.1, 0.4, 1.4), SHOE, CFrame.new(0, -0.15, 0.1)) end
	if rFoot then weldTo(rig, rFoot, "ShoeR", Vector3.new(1.1, 0.4, 1.4), SHOE, CFrame.new(0, -0.15, 0.1)) end

	-- Rib rack held between both hands. We weld to the right hand and let the
	-- visual span overlap the left. R15 hand-origin Y compensation is already
	-- baked into the relative CFrames here.
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		local ribCF = CFrame.new(-1.2, -0.2, 0.6)
		weldTo(rig, rHand, "RibRack",  Vector3.new(3.2, 0.6, 1.4), RIB_MEAT, ribCF)
		weldTo(rig, rHand, "RibSauce", Vector3.new(3.3, 0.18, 1.5), SAUCE,    ribCF * CFrame.new(0, 0.4, 0))
		-- Dark grill marks
		for i, x in {-1.0, 0, 1.0} do
			weldTo(rig, rHand, "Grill_" .. i, Vector3.new(0.2, 0.62, 1.45), RIB_DARK, ribCF * CFrame.new(x, 0, 0))
		end
		-- Bones poking out
		for i = 1, 4 do
			weldTo(rig, rHand, "Bone_" .. i, Vector3.new(0.25, 0.9, 0.25), BONE,
				ribCF * CFrame.new(-1.8 + i * 0.12, -0.05, 0.4 + i * 0.1) * CFrame.Angles(0, 0, math.rad(90)),
				Enum.PartType.Cylinder)
		end
	end

	AB.r15NameTag(rig, "Kid")
	return rig
end
