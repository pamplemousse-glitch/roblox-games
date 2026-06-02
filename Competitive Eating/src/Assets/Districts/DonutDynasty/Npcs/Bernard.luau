-- Bernard — French boulanger. R15 rig with double-breasted chef coat + tall toque + mustache.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME   = "Bernard"
local CREAM  = Color3.fromRGB(255, 250, 245)
local BUTTON = Color3.fromRGB(212, 168, 82)
local HAIR   = Color3.fromRGB(50, 35, 25)

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
		skin  = Color3.fromRGB(235, 200, 170),
		shirt = CREAM,
		pants = Color3.fromRGB(70, 70, 80),
	})
	-- Welded torso accessories anchor to HumanoidRootPart (rig origin) so the
	-- original R6-Torso-relative offsets keep their world positions on R15.
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Double-breasted gold buttons (two columns, three rows)
		for i = 1, 3 do
			local y = 0.6 - (i - 1) * 0.55
			weldTo(rig, hrp, "BtnL_" .. i, Vector3.new(0.18, 0.18, 0.18), BUTTON, CFrame.new(-0.35, y, 0.55), Enum.PartType.Ball)
			weldTo(rig, hrp, "BtnR_" .. i, Vector3.new(0.18, 0.18, 0.18), BUTTON, CFrame.new( 0.35, y, 0.55), Enum.PartType.Ball)
		end
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Bushy mustache
		weldTo(rig, head, "Mustache",  Vector3.new(1.0, 0.18, 0.3), HAIR, CFrame.new(0, -0.18, 0.45))
		weldTo(rig, head, "MustacheL", Vector3.new(0.22, 0.22, 0.22), HAIR, CFrame.new(-0.45, -0.18, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "MustacheR", Vector3.new(0.22, 0.22, 0.22), HAIR, CFrame.new( 0.45, -0.18, 0.5), Enum.PartType.Ball)
	end
	AB.r15Hat(rig, Vector3.new(2.1, 0.4, 1.1), HAIR,  0.55, "Hair")
	-- Tall toque: band + shaft + puff
	AB.r15Hat(rig, Vector3.new(1.6, 0.3, 1.6), CREAM, 1.0, "ToqueBand")
	AB.r15Hat(rig, Vector3.new(1.4, 1.2, 1.4), CREAM, 1.8, "ToqueShaft", Enum.PartType.Cylinder)
	AB.r15Hat(rig, Vector3.new(1.9, 1.6, 1.9), CREAM, 2.7, "ToquePuff", Enum.PartType.Ball)
	AB.r15NameTag(rig, NAME)
	return rig
end
