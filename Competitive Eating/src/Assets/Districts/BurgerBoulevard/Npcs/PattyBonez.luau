-- PattyBonez — R15 retrofit (polish A). Skeletal biker, leather jacket, shades, red glow.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME     = "PattyBonez"
local SKULL    = Color3.fromRGB(235, 230, 215)
local LEATHER  = Color3.fromRGB(35, 35, 40)
local DENIM    = Color3.fromRGB(70, 80, 110)
local NEON_RED = Color3.fromRGB(255, 48, 48)
local WHITE    = Color3.fromRGB(245, 245, 240)
local CHROME   = Color3.fromRGB(176, 176, 176)
local DARK     = Color3.fromRGB(15, 15, 15)

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
		skin  = SKULL,    -- bony skin
		shirt = LEATHER,  -- leather jacket
		pants = DENIM,
	})
	local hrp = rig:FindFirstChild("HumanoidRootPart") :: BasePart
	if hrp then
		-- White t-shirt visible at neckline
		weldTo(rig, hrp, "Shirt",    Vector3.new(0.8, 1.4, 0.05), WHITE, CFrame.new(0, 0.3, 0.55))
		-- Popped collar
		weldTo(rig, hrp, "CollarL",  Vector3.new(0.3, 0.6, 0.4), LEATHER, CFrame.new(-0.7, 1.1, 0.35) * CFrame.Angles(0, 0, math.rad(15)))
		weldTo(rig, hrp, "CollarR",  Vector3.new(0.3, 0.6, 0.4), LEATHER, CFrame.new( 0.7, 1.1, 0.35) * CFrame.Angles(0, 0, math.rad(-15)))
		-- Chrome zipper
		weldTo(rig, hrp, "Zipper",   Vector3.new(0.1, 1.8, 0.05), CHROME, CFrame.new(-0.2, 0, 0.55))
		-- Red glow PointLight on torso (his thing)
		local glow = Instance.new("PointLight")
		glow.Color = NEON_RED; glow.Brightness = 1.0; glow.Range = 12
		glow.Parent = hrp
	end
	local head = rig:FindFirstChild("Head") :: BasePart
	if head then
		-- Eye sockets (dark hollows)
		weldTo(rig, head, "SocketL", Vector3.new(0.32, 0.32, 0.32), DARK, CFrame.new(-0.32, 0.1, 0.5), Enum.PartType.Ball)
		weldTo(rig, head, "SocketR", Vector3.new(0.32, 0.32, 0.32), DARK, CFrame.new( 0.32, 0.1, 0.5), Enum.PartType.Ball)
		-- Black bar shades
		weldTo(rig, head, "Shades",  Vector3.new(1.5, 0.35, 0.15), Color3.fromRGB(10, 10, 15), CFrame.new(0, 0.1, 0.6))
		-- Jaw line gap
		weldTo(rig, head, "Jaw",     Vector3.new(0.9, 0.05, 0.05), Color3.fromRGB(20, 20, 20), CFrame.new(0, -0.45, 0.55))
	end
	AB.r15NameTag(rig, "Patty Bonez")
	return rig
end
