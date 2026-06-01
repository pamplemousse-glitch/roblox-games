-- MilkshakeMixer — classic Hamilton Beach malt-shake mixer with three spindles.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MilkshakeMixer", parent)

	local CHROME = Color3.fromRGB(176, 176, 176)
	local CREAM  = Color3.fromRGB(255, 245, 232)
	local GREEN  = Color3.fromRGB(130, 180, 130)
	local DARK   = Color3.fromRGB(40, 40, 45)
	local PINK_M = Color3.fromRGB(255, 200, 215)
	local BROWN_M = Color3.fromRGB(140, 80, 50)
	local WHITE_M = Color3.fromRGB(255, 250, 240)
	local GLASS  = Color3.fromRGB(220, 240, 255)

	-- Body / cylinder base
	local body = AB.cylinder(3, 0.6, CHROME, AB.offset(originCF, 0, 0.3, 0), model, "Base")
	body.Material = Enum.Material.Metal
	-- Main vertical post
	local post = AB.block(Vector3.new(0.6, 5, 2.5), GREEN, AB.offset(originCF, 0, 3, -0.4), model, "Post")
	post.Material = Enum.Material.SmoothPlastic
	-- Mixer head (cylinder protruding forward)
	AB.cylinder(2, 1.5, GREEN, AB.offset(originCF, 0, 4.5, 0.5) * CFrame.Angles(0, 0, math.rad(90)), model, "Head")
	-- Chrome cap
	AB.cylinder(1.8, 0.4, CHROME, AB.offset(originCF, 0, 4.5, 1.4) * CFrame.Angles(0, 0, math.rad(90)), model, "HeadCap")

	-- 3 spindles dropping from the head, each holding a chrome cup of different shake
	for i = -1, 1 do
		local x = i * 1
		AB.cylinder(0.2, 2.5, CHROME, AB.offset(originCF, x, 3.1, 0.5), model, "Spindle_" .. i)
		-- Chrome shake cup
		AB.cylinder(1, 2.2, CHROME, AB.offset(originCF, x, 1.8, 0.5), model, "Cup_" .. i)
		-- Shake content (different colors)
		local flavor = (i == -1) and PINK_M or (i == 0) and WHITE_M or BROWN_M
		AB.cylinder(0.85, 1.6, flavor, AB.offset(originCF, x, 1.6, 0.5), model, "Shake_" .. i)
	end

	-- Control switch (a small chrome lever)
	AB.cylinder(0.3, 0.6, CHROME, AB.offset(originCF, 0.6, 1.4, 0.3), model, "Switch")
	-- Power light
	local light = AB.sphere(0.2, Color3.fromRGB(255, 60, 60), AB.offset(originCF, -0.6, 1.4, 0.3), model, "PowerLight")
	AB.neon(light); AB.glow(light, Color3.fromRGB(255, 60, 60), 0.5)

	-- Brand plate
	local plate = AB.block(Vector3.new(1.2, 0.3, 0.1), CHROME, AB.offset(originCF, 0, 4.5, 1.6), model, "Plate")
	AB.billboard(plate, "MIX-MASTER", Vector2.new(80, 16), 0)

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
