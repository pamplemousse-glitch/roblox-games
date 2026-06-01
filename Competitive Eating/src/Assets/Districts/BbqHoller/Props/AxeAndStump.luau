-- Axe and Stump — chopping block (round log stump) with an axe buried in it.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local LOG       = Color3.fromRGB(120, 80, 45)
local LOG_DARK  = Color3.fromRGB(90, 60, 35)
local RING      = Color3.fromRGB(195, 165, 120)
local DARK_WOOD = Color3.fromRGB(70, 45, 22)
local STEEL     = Color3.fromRGB(140, 140, 145)
local BLADE     = Color3.fromRGB(200, 200, 210)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("AxeAndStump", parent)

	-- Stump (vertical cylinder)
	local stump = AB.cylinder(3.6, 3.2, LOG, AB.offset(originCF, 0, 1.6, 0), model, "Stump")
	-- Bark texture: dark vertical streaks
	for i = 1, 6 do
		local angle = (i / 6) * math.pi * 2
		AB.block(Vector3.new(0.2, 3.2, 0.4), LOG_DARK,
			AB.offset(originCF, math.cos(angle) * 1.78, 1.6, math.sin(angle) * 1.78),
			model, "Bark_" .. i)
	end
	-- Tree rings (top)
	for i = 1, 3 do
		local r = 0.4 + i * 0.5
		AB.cylinder(r * 2, 0.05, (i % 2 == 0) and LOG_DARK or RING, AB.offset(originCF, 0, 3.22, 0), model, "Ring_" .. i)
	end
	-- Top surface (lighter)
	AB.cylinder(3.55, 0.06, RING, AB.offset(originCF, 0, 3.2, 0), model, "TopFace")

	-- Axe handle (angled stick sticking out of the stump)
	local handle = AB.block(Vector3.new(0.4, 4, 0.4), DARK_WOOD, AB.offset(originCF, 0, 5, 0.6), model, "Handle")
	handle.CFrame = handle.CFrame * CFrame.Angles(math.rad(-30), 0, 0)
	-- Handle grip wrap (dark band near bottom)
	AB.block(Vector3.new(0.5, 0.4, 0.5), LOG_DARK, AB.offset(originCF, 0, 6.6, 1.5), model, "Grip")

	-- Axe head (chunky block)
	local head = AB.block(Vector3.new(1.4, 0.8, 0.6), STEEL, AB.offset(originCF, 0, 3.6, 0.2), model, "AxeHead")
	head.CFrame = head.CFrame * CFrame.Angles(math.rad(-30), 0, 0)
	-- Blade edge (wedge)
	local blade = AB.wedge(Vector3.new(0.6, 0.8, 1.4), BLADE, AB.offset(originCF, -0.9, 3.5, 0.2), model, "Blade")
	blade.CFrame = blade.CFrame * CFrame.Angles(math.rad(-30), math.rad(-90), 0)

	-- Wood chips around base
	for i, p in {Vector3.new(-2, 0.1, 0.8), Vector3.new(2.2, 0.1, -0.3), Vector3.new(0.5, 0.1, -2.2), Vector3.new(-1.5, 0.1, -1.5)} do
		AB.block(Vector3.new(0.6, 0.2, 0.4), LOG, originCF * CFrame.new(p) * CFrame.Angles(0, math.rad(i * 37), 0), model, "Chip_" .. i)
	end

	AB.pivot(model, stump)
	AB.weldAll(model)
	return model
end
