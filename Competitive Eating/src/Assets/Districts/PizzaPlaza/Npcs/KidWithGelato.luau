-- KidWithGelato — R15 retrofit (polish A)
-- Mia: small child in pink shirt + blue overalls, curly brown hair,
-- holding a triple-scoop gelato cone with a cherry on top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Mia"
local SKIN    = Color3.fromRGB(245, 215, 175)
local SHIRT   = Color3.fromRGB(255, 180, 200)
local OVERALL = Color3.fromRGB(80, 120, 180)
local HAIR    = Color3.fromRGB(120, 80, 50)
local SHOE    = Color3.fromRGB(220, 60, 60)
local CONE    = Color3.fromRGB(220, 180, 110)
local SCOOP1  = Color3.fromRGB(255, 130, 150)
local SCOOP2  = Color3.fromRGB(180, 220, 130)
local SCOOP3  = Color3.fromRGB(120, 80, 50)
local STAIN_P = Color3.fromRGB(255, 130, 150)

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
		pants = OVERALL,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Blue overalls front + straps + silver buttons
		weldTo(rig, hrp, "OverallFront", Vector3.new(1.8, 1.7, 0.12), OVERALL, CFrame.new(0, -0.3, 0.55))
		weldTo(rig, hrp, "StrapL",       Vector3.new(0.3, 1.0, 0.1), OVERALL, CFrame.new(-0.55, 0.9, 0.55))
		weldTo(rig, hrp, "StrapR",       Vector3.new(0.3, 1.0, 0.1), OVERALL, CFrame.new( 0.55, 0.9, 0.55))
		weldTo(rig, hrp, "Button1",      Vector3.new(0.13, 0.13, 0.13), Color3.fromRGB(200, 200, 210), CFrame.new(-0.55, 0.3, 0.62), Enum.PartType.Ball)
		weldTo(rig, hrp, "Button2",      Vector3.new(0.13, 0.13, 0.13), Color3.fromRGB(200, 200, 210), CFrame.new( 0.55, 0.3, 0.62), Enum.PartType.Ball)
		weldTo(rig, hrp, "Stain",        Vector3.new(0.18, 0.18, 0.18), STAIN_P, CFrame.new(0.4, -0.5, 0.62), Enum.PartType.Ball)
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Big white eyes + dark pupils + rosy cheeks + toothy grin
		weldTo(rig, head, "EyeWhiteL", Vector3.new(0.3, 0.3, 0.3), Color3.fromRGB(245, 240, 230), CFrame.new(-0.35, 0.05, 0.45), Enum.PartType.Ball)
		weldTo(rig, head, "EyeWhiteR", Vector3.new(0.3, 0.3, 0.3), Color3.fromRGB(245, 240, 230), CFrame.new( 0.35, 0.05, 0.45), Enum.PartType.Ball)
		weldTo(rig, head, "PupilL",    Vector3.new(0.16, 0.16, 0.16), Color3.fromRGB(60, 40, 35), CFrame.new(-0.35, 0.05, 0.55), Enum.PartType.Ball)
		weldTo(rig, head, "PupilR",    Vector3.new(0.16, 0.16, 0.16), Color3.fromRGB(60, 40, 35), CFrame.new( 0.35, 0.05, 0.55), Enum.PartType.Ball)
		weldTo(rig, head, "Grin",      Vector3.new(0.85, 0.3, 0.1), Color3.fromRGB(245, 240, 230), CFrame.new(0, -0.45, 0.5))
		weldTo(rig, head, "CheekL",    Vector3.new(0.2, 0.2, 0.2), Color3.fromRGB(255, 160, 160), CFrame.new(-0.6, -0.25, 0.45), Enum.PartType.Ball)
		weldTo(rig, head, "CheekR",    Vector3.new(0.2, 0.2, 0.2), Color3.fromRGB(255, 160, 160), CFrame.new( 0.6, -0.25, 0.45), Enum.PartType.Ball)
	end
	-- Curly brown hair (top + 2 side buns)
	AB.r15Hat(rig, Vector3.new(1.3, 1.0, 1.3), HAIR, 0.7, "Hair", Enum.PartType.Ball)
	AB.r15Hat(rig, Vector3.new(0.6, 0.6, 0.6), HAIR, 0.4, "HairBunL", Enum.PartType.Ball)
	AB.r15Hat(rig, Vector3.new(0.6, 0.6, 0.6), HAIR, 0.4, "HairBunR", Enum.PartType.Ball)

	-- Red sneakers (welded to feet)
	local lFoot = rig:FindFirstChild("LeftFoot") :: BasePart
	if lFoot then
		weldTo(rig, lFoot, "SneakerL", Vector3.new(1.05, 0.45, 1.25), SHOE, CFrame.new(0, -0.05, 0.1))
	end
	local rFoot = rig:FindFirstChild("RightFoot") :: BasePart
	if rFoot then
		weldTo(rig, rFoot, "SneakerR", Vector3.new(1.05, 0.45, 1.25), SHOE, CFrame.new(0, -0.05, 0.1))
	end

	-- Gelato cone held in right hand (cone + 3 scoops + cherry + drip)
	local rHand = rig:FindFirstChild("RightHand") :: BasePart
	if rHand then
		weldTo(rig, rHand, "Cone",         Vector3.new(0.6, 1.5, 0.6), CONE, CFrame.new(0, 0.55, 0.5))
		weldTo(rig, rHand, "Scoop3Choc",   Vector3.new(0.7, 0.7, 0.7), SCOOP3, CFrame.new(0, 1.7, 0.5), Enum.PartType.Ball)
		weldTo(rig, rHand, "Scoop2Pist",   Vector3.new(0.65, 0.65, 0.65), SCOOP2, CFrame.new(0, 2.2, 0.5), Enum.PartType.Ball)
		weldTo(rig, rHand, "Scoop1Strawb", Vector3.new(0.6, 0.6, 0.6), SCOOP1, CFrame.new(0, 2.7, 0.5), Enum.PartType.Ball)
		weldTo(rig, rHand, "Cherry",       Vector3.new(0.2, 0.2, 0.2), Color3.fromRGB(220, 30, 50), CFrame.new(0, 3.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, rHand, "CherryStem",   Vector3.new(0.06, 0.3, 0.06), Color3.fromRGB(80, 140, 60), CFrame.new(0, 3.3, 0.5))
		weldTo(rig, rHand, "Drip",         Vector3.new(0.12, 0.4, 0.12), SCOOP1, CFrame.new(0.35, 1.6, 0.6))
	end

	AB.r15NameTag(rig, NAME)
	return rig
end
