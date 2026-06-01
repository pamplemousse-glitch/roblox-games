-- StarBurstSign — atomic-age starburst (sputnik-style) decoration.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("StarBurstSign", parent)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local NEON_R = Color3.fromRGB(255, 48, 48)
	local NEON_Y = Color3.fromRGB(245, 220, 80)
	local NEON_T = Color3.fromRGB(127, 202, 194)

	-- Center hub
	local hub = AB.sphere(1, CHROME, AB.offset(originCF, 0, 0, 0), model, "Hub")
	hub.Material = Enum.Material.Metal

	-- 12 rays in alternating colors (around XY-plane)
	for i = 0, 11 do
		local angle = (i / 12) * 2 * math.pi
		local color = (i % 3 == 0) and NEON_R or (i % 3 == 1) and NEON_Y or NEON_T
		local cf = AB.offset(originCF, math.cos(angle) * 2.5, math.sin(angle) * 2.5, 0) * CFrame.Angles(0, 0, math.rad(math.deg(angle)))
		-- Ray
		local ray = AB.block(Vector3.new(3, 0.3, 0.3), color, cf, model, "Ray_" .. i)
		AB.neon(ray); AB.glow(ray, color, 1.2)
		-- Tip ball
		local tip = AB.sphere(0.3, color, AB.offset(originCF, math.cos(angle) * 4.2, math.sin(angle) * 4.2, 0), model, "Tip_" .. i)
		AB.neon(tip); AB.glow(tip, color, 1.0)
	end

	-- 6 more rays out of plane (Z axis) for 3D starburst effect
	for i = 0, 5 do
		local angle = (i / 6) * 2 * math.pi
		local color = (i % 2 == 0) and NEON_R or NEON_T
		local cf = AB.offset(originCF, math.cos(angle) * 1.5, math.sin(angle) * 1.5, math.cos(angle) * 1.5) * CFrame.Angles(0, math.rad(math.deg(angle) + 30), 0)
		local ray = AB.block(Vector3.new(2, 0.25, 0.25), color, cf, model, "RayZ_" .. i)
		AB.neon(ray); AB.glow(ray, color, 0.8)
	end

	AB.pivot(model, hub)
	AB.weldAll(model)
	return model
end
