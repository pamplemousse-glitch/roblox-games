-- Wagon Wheel — old wooden wagon wheel leaning against the ground.
-- Outer rim ring, hub, 8 spokes.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WOOD      = Color3.fromRGB(120, 80, 45)
local DARK_WOOD = Color3.fromRGB(70, 45, 22)
local METAL     = Color3.fromRGB(95, 90, 85)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WagonWheel", parent)

	-- The whole wheel leans backward — rotate around X
	local wheelCF = AB.offset(originCF, 0, 3, 0) * CFrame.Angles(math.rad(15), 0, 0)

	-- Outer rim (cylinder ring, thin)
	local rim = AB.cylinder(6, 0.5, DARK_WOOD, wheelCF * CFrame.Angles(math.rad(90), 0, 0), model, "Rim")
	-- Inner rim (slightly smaller for thickness)
	AB.cylinder(5.6, 0.55, WOOD, wheelCF * CFrame.Angles(math.rad(90), 0, 0), model, "RimInner")
	-- Iron tire band
	AB.cylinder(6.2, 0.2, METAL, wheelCF * CFrame.Angles(math.rad(90), 0, 0), model, "TireBand")

	-- Hub (center cap)
	AB.cylinder(1.2, 0.8, DARK_WOOD, wheelCF * CFrame.Angles(math.rad(90), 0, 0), model, "Hub")

	-- 8 spokes radiating from hub
	for i = 1, 8 do
		local angle = (i / 8) * math.pi * 2
		local spoke = AB.block(Vector3.new(0.25, 2.4, 0.25), WOOD,
			wheelCF * CFrame.Angles(0, 0, angle) * CFrame.new(0, 1.4, 0),
			model, "Spoke_" .. i)
	end

	-- Pivot uses the rim
	AB.pivot(model, rim)
	AB.weldAll(model)
	return model
end
