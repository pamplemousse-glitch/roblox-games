-- StringLights — strand of 50s round bulbs on a cable, in alternating warm colors.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("StringLights", parent)
	local CABLE  = Color3.fromRGB(30, 30, 30)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local colors = {
		Color3.fromRGB(255, 220, 130),  -- warm yellow
		Color3.fromRGB(255, 100, 100),  -- red
		Color3.fromRGB(255, 200, 215),  -- pink
		Color3.fromRGB(127, 202, 194),  -- teal
		Color3.fromRGB(255, 220, 130),
		Color3.fromRGB(255, 100, 100),
		Color3.fromRGB(255, 200, 215),
		Color3.fromRGB(127, 202, 194),
		Color3.fromRGB(255, 220, 130),
		Color3.fromRGB(255, 100, 100),
	}

	-- Cable (sagging slightly — simulated with 3 segments at slight angles)
	AB.block(Vector3.new(8, 0.1, 0.1), CABLE, AB.offset(originCF, -4, 0.2, 0) * CFrame.Angles(0, 0, math.rad(-3)), model, "CableL")
	AB.block(Vector3.new(8, 0.1, 0.1), CABLE, AB.offset(originCF,  4, 0.2, 0) * CFrame.Angles(0, 0, math.rad(3)), model, "CableR")
	-- Hangers
	AB.cylinder(0.2, 0.6, CHROME, AB.offset(originCF, -8, 0.5, 0), model, "HangerL")
	AB.cylinder(0.2, 0.6, CHROME, AB.offset(originCF, 8, 0.5, 0), model, "HangerR")

	-- 10 bulbs along the string
	for i = 0, 9 do
		local x = -7.2 + i * 1.6
		local y = -0.6 - math.sin(i / 9 * math.pi) * 0.3  -- subtle sag
		local color = colors[i + 1]
		-- Socket
		AB.cylinder(0.25, 0.2, CHROME, AB.offset(originCF, x, y + 0.5, 0), model, "Sock_" .. i)
		-- Bulb
		local bulb = AB.sphere(0.5, color, AB.offset(originCF, x, y, 0), model, "Bulb_" .. i)
		AB.neon(bulb); AB.glow(bulb, color, 1.0)
	end

	AB.pivot(model, model:FindFirstChild("CableL"))
	AB.weldAll(model)
	return model
end
