-- BBQJudge — R15 retrofit (polish A)
-- Official judge in navy blazer + bowtie, glasses, clipboard + pen.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME     = "BBQJudge"
local SKIN     = Color3.fromRGB(225, 190, 160)
local BLAZER   = Color3.fromRGB(40, 55, 95)
local BLAZER_D = Color3.fromRGB(28, 38, 65)
local SHIRT    = Color3.fromRGB(240, 235, 225)
local PANTS    = Color3.fromRGB(50, 50, 55)
local SHOE     = Color3.fromRGB(30, 25, 22)
local BOWTIE   = Color3.fromRGB(170, 30, 40)
local CLIP_W   = Color3.fromRGB(235, 230, 220)
local CLIP_M   = Color3.fromRGB(140, 140, 145)
local PEN      = Color3.fromRGB(45, 45, 50)
local HAIR     = Color3.fromRGB(70, 50, 38)
local GLASS    = Color3.fromRGB(200, 220, 230)
local IRON     = Color3.fromRGB(35, 30, 28)
local RIBBON_G = Color3.fromRGB(220, 180, 60)

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
		shirt = BLAZER,   -- blazer over shirt — torso reads as blazer
		pants = PANTS,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- White shirt collar peeking above the blazer
		weldTo(rig, hrp, "ShirtCollar", Vector3.new(1.4, 0.4, 0.4), SHIRT, CFrame.new(0, 1.2, 0.4))
		-- Lapels (dark navy edges down the front of the blazer)
		weldTo(rig, hrp, "LapelL", Vector3.new(0.5, 1.6, 0.2), BLAZER_D, CFrame.new(-0.65, 0.4, 0.55))
		weldTo(rig, hrp, "LapelR", Vector3.new(0.5, 1.6, 0.2), BLAZER_D, CFrame.new( 0.65, 0.4, 0.55))
		-- Gold ribbon on lapel
		weldTo(rig, hrp, "Ribbon", Vector3.new(0.3, 0.45, 0.15), RIBBON_G, CFrame.new(0.65, 0.9, 0.65))
		-- Bowtie center + wings
		weldTo(rig, hrp, "BowtieC", Vector3.new(0.7, 0.3, 0.15), BOWTIE, CFrame.new(0, 1.45, 0.55))
		weldTo(rig, hrp, "BowtieL", Vector3.new(0.25, 0.35, 0.35), BOWTIE, CFrame.new(-0.35, 1.45, 0.55), Enum.PartType.Ball)
		weldTo(rig, hrp, "BowtieR", Vector3.new(0.25, 0.35, 0.35), BOWTIE, CFrame.new( 0.35, 1.45, 0.55), Enum.PartType.Ball)
	end

	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Glasses (iron frames + tinted lenses)
		weldTo(rig, head, "GlassFrameL", Vector3.new(0.55, 0.45, 0.05), IRON, CFrame.new(-0.4, 0.05, 0.5))
		weldTo(rig, head, "GlassFrameR", Vector3.new(0.55, 0.45, 0.05), IRON, CFrame.new( 0.4, 0.05, 0.5))
		weldTo(rig, head, "GlassBridge", Vector3.new(0.3, 0.05, 0.05), IRON, CFrame.new(0, 0.05, 0.5))
		local lensL = weldTo(rig, head, "LensL", Vector3.new(0.45, 0.36, 0.04), GLASS, CFrame.new(-0.4, 0.05, 0.55))
		local lensR = weldTo(rig, head, "LensR", Vector3.new(0.45, 0.36, 0.04), GLASS, CFrame.new( 0.4, 0.05, 0.55))
		lensL.Transparency = 0.5
		lensR.Transparency = 0.5
		-- Mouth (slight pursed look)
		weldTo(rig, head, "Mouth", Vector3.new(0.7, 0.15, 0.18), Color3.new(0, 0, 0), CFrame.new(0, -0.35, 0.55))
	end

	-- Side-comb hair + main cap
	AB.r15Hat(rig, Vector3.new(2.05, 0.32, 2.05), HAIR, 0.55, "Hair")
	AB.r15Hat(rig, Vector3.new(0.2, 0.35, 1.8), Color3.fromRGB(50, 38, 28), 0.62, "HairPart")

	-- Shoes welded to feet
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if lFoot then weldTo(rig, lFoot, "ShoeL", Vector3.new(1.2, 0.5, 1.55), SHOE, CFrame.new(0, -0.1, 0.1)) end
	if rFoot then weldTo(rig, rFoot, "ShoeR", Vector3.new(1.2, 0.5, 1.55), SHOE, CFrame.new(0, -0.1, 0.1)) end

	-- Clipboard in left hand. R15 LeftHand origin is at local Y=-1.2 relative to
	-- the old R6 Left Arm reference, so accessory Y shifts by +1.2 to keep the
	-- world position equivalent to the previous build.
	local lHand = rig:FindFirstChild("LeftHand") :: BasePart
	if lHand then
		weldTo(rig, lHand, "Clipboard",    Vector3.new(1.8, 2.6, 0.25), CLIP_W, CFrame.new(0.2, -0.2, 0.7))
		weldTo(rig, lHand, "ClipboardTop", Vector3.new(1.9, 0.35, 0.35), CLIP_M, CFrame.new(0.2,  1.1, 0.72))
		for i, y in {-1.0, -0.5, 0.0, 0.4, 0.8} do
			weldTo(rig, lHand, "PaperLine_" .. i, Vector3.new(1.4, 0.05, 0.05), Color3.new(0, 0, 0), CFrame.new(0.2, y, 0.83))
		end
	end

	-- Pen in right hand
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "Pen", Vector3.new(0.2, 1.1, 0.2), PEN,
			CFrame.new(0, -0.1, 0.5) * CFrame.Angles(math.rad(-45), 0, 0))
	end

	AB.r15NameTag(rig, "BBQ Judge")
	return rig
end
