-- AccordionBusker — R15 retrofit (polish A)
-- Lorenzo: street musician with a big red accordion strapped to chest,
-- burgundy beret, scruffy beard, brown vest, floating music notes.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Lorenzo"
local SKIN    = Color3.fromRGB(240, 210, 175)
local SHIRT   = Color3.fromRGB(245, 240, 230)
local VEST    = Color3.fromRGB(60, 35, 20)
local PANTS   = Color3.fromRGB(40, 40, 50)
local HAIR    = Color3.fromRGB(60, 40, 35)
local BERET   = Color3.fromRGB(110, 30, 40)
local ACC_RED = Color3.fromRGB(180, 30, 40)
local ACC_BLK = Color3.fromRGB(35, 30, 30)
local BRASS   = Color3.fromRGB(200, 160, 80)
local IVORY   = Color3.fromRGB(245, 240, 220)
local BELLOW  = Color3.fromRGB(80, 60, 50)

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
		pants = PANTS,
	})

	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- Brown vest panels + brass buttons
		weldTo(rig, hrp, "VestFront", Vector3.new(2.1, 1.95, 0.12), VEST, CFrame.new(0, -0.05, 0.55))
		weldTo(rig, hrp, "VestBack",  Vector3.new(2.1, 1.95, 0.12), VEST, CFrame.new(0, -0.05, -0.55))
		for i, y in {0.55, 0.05, -0.45, -0.85} do
			weldTo(rig, hrp, "Button_" .. i, Vector3.new(0.12, 0.12, 0.12), BRASS, CFrame.new(0, y, 0.62), Enum.PartType.Ball)
		end
		-- ACCORDION strapped to chest
		weldTo(rig, hrp, "AccL",     Vector3.new(1.3, 2.2, 1.2), ACC_RED, CFrame.new(-1.7, -0.2, 1.4))
		weldTo(rig, hrp, "AccR",     Vector3.new(1.3, 2.2, 1.2), ACC_RED, CFrame.new( 1.7, -0.2, 1.4))
		weldTo(rig, hrp, "AccLEdge", Vector3.new(0.2, 2.2, 1.2), ACC_BLK, CFrame.new(-1.0, -0.2, 1.4))
		weldTo(rig, hrp, "AccREdge", Vector3.new(0.2, 2.2, 1.2), ACC_BLK, CFrame.new( 1.0, -0.2, 1.4))
		-- Bellows (folded stripes)
		for i, x in {-0.85, -0.45, -0.05, 0.35, 0.75} do
			weldTo(rig, hrp, "Bellow_" .. i, Vector3.new(0.35, 1.9, 1.0), BELLOW, CFrame.new(x, -0.2, 1.4))
		end
		-- Brass corner studs
		for k, sx in {-1, 1} do
			for j, sy in {-1, 1} do
				weldTo(rig, hrp, "BellowCorner_" .. k .. j, Vector3.new(0.2, 0.2, 0.2), BRASS,
					CFrame.new(sx * 1.2, -0.2 + sy * 0.95, 1.95), Enum.PartType.Ball)
			end
		end
		-- Mini button board (left side) + white keys (right side)
		for r = 1, 3 do
			for c = 1, 3 do
				weldTo(rig, hrp, "Btn_" .. r .. c, Vector3.new(0.1, 0.1, 0.1), IVORY,
					CFrame.new(-1.95 + (c - 1) * 0.18, 0.4 - (r - 1) * 0.4, 2.0), Enum.PartType.Ball)
			end
		end
		for k = 1, 5 do
			weldTo(rig, hrp, "Key_" .. k, Vector3.new(0.16, 0.4, 0.6), IVORY,
				CFrame.new(1.3 + (k - 1) * 0.18, -0.7, 2.0))
		end
		-- Brand badge (decorative)
		weldTo(rig, hrp, "Badge", Vector3.new(0.9, 0.5, 0.05), BRASS, CFrame.new(0, 0.4, 2.0))
		-- Shoulder straps
		weldTo(rig, hrp, "StrapL", Vector3.new(0.2, 3.5, 0.2), ACC_BLK,
			CFrame.new(-0.9, 1.2, 0.9) * CFrame.Angles(0, 0, math.rad(15)))
		weldTo(rig, hrp, "StrapR", Vector3.new(0.2, 3.5, 0.2), ACC_BLK,
			CFrame.new( 0.9, 1.2, 0.9) * CFrame.Angles(0, 0, math.rad(-15)))
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Scruffy beard + thick mustache
		weldTo(rig, head, "Beard",    Vector3.new(0.9, 0.9, 0.9), HAIR, CFrame.new(0, -0.6, 0.3), Enum.PartType.Ball)
		weldTo(rig, head, "Mustache", Vector3.new(1.3, 0.25, 0.4), HAIR, CFrame.new(0, -0.25, 0.5))
		-- Eyes closed (into the music)
		weldTo(rig, head, "EyeL", Vector3.new(0.35, 0.06, 0.1), Color3.fromRGB(60, 40, 35), CFrame.new(-0.4, 0.2, 0.5))
		weldTo(rig, head, "EyeR", Vector3.new(0.35, 0.06, 0.1), Color3.fromRGB(60, 40, 35), CFrame.new( 0.4, 0.2, 0.5))
	end
	-- Burgundy beret + tail
	AB.r15Hat(rig, Vector3.new(1.4, 1.0, 1.4), BERET, 0.75, "Beret", Enum.PartType.Ball)
	AB.r15Hat(rig, Vector3.new(0.18, 0.4, 0.18), BERET, 1.4, "BeretTail")

	-- Music notes floating above (neon glyphs welded to head so they ride with rig)
	if head then
		for i, off in {Vector3.new(-2, 2, 0), Vector3.new(2, 3, 0.4), Vector3.new(0, 4, 0.7)} do
			local note = weldTo(rig, head, "Note_" .. i, Vector3.new(0.28, 0.28, 0.28),
				Color3.fromRGB(255, 230, 100), CFrame.new(off.X, off.Y, off.Z), Enum.PartType.Ball)
			AB.neon(note)
			weldTo(rig, head, "NoteStem_" .. i, Vector3.new(0.06, 0.6, 0.06), Color3.fromRGB(255, 230, 100),
				CFrame.new(off.X, off.Y + 0.35, off.Z))
		end
	end

	AB.r15NameTag(rig, NAME)
	return rig
end
