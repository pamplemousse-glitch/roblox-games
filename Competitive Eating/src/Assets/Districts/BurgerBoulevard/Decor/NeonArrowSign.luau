-- NeonArrowSign — googie-style arrow sign pointing right, with chasing-bulb effect.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("NeonArrowSign", parent)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local NEON_R = Color3.fromRGB(255, 48, 48)
	local CREAM  = Color3.fromRGB(255, 245, 232)
	local YELLOW = Color3.fromRGB(255, 220, 80)

	-- Pole
	AB.cylinder(0.3, 8, CHROME, AB.offset(originCF, 0, 4, 0), model, "Pole")
	-- Backing plate (large rectangle)
	local back = AB.block(Vector3.new(7, 2, 0.4), CREAM, AB.offset(originCF, 1, 7, 0), model, "Backing")
	-- Trim border
	AB.block(Vector3.new(7.2, 0.2, 0.5), CHROME, AB.offset(originCF, 1, 8.1, 0), model, "TrimT")
	AB.block(Vector3.new(7.2, 0.2, 0.5), CHROME, AB.offset(originCF, 1, 5.9, 0), model, "TrimB")
	-- Arrow point (wedge sticking off the right)
	AB.wedge(Vector3.new(2, 2, 0.4), CREAM, AB.offset(originCF, 5, 7, 0) * CFrame.Angles(0, math.rad(90), 0), model, "ArrowTip")
	-- Neon outline inside the rectangle
	local neonInner = AB.block(Vector3.new(6, 1.4, 0.5), NEON_R, AB.offset(originCF, 1, 7, 0.15), model, "NeonInner")
	AB.neon(neonInner); AB.glow(neonInner, NEON_R, 2.5)
	-- Bulbs (8 along the top + 8 along bottom for chasing-light effect)
	for i = 0, 7 do
		local bL = AB.sphere(0.3, YELLOW, AB.offset(originCF, -2 + i * 0.8, 8.1, 0.2), model, "BulbT_" .. i)
		AB.neon(bL); AB.glow(bL, YELLOW, 0.8)
		local bR = AB.sphere(0.3, YELLOW, AB.offset(originCF, -2 + i * 0.8, 5.9, 0.2), model, "BulbB_" .. i)
		AB.neon(bR); AB.glow(bR, YELLOW, 0.8)
	end
	-- Text
	AB.billboard(back, "DINER →", Vector2.new(200, 50), 0)

	AB.pivot(model, model:FindFirstChild("Pole"))
	AB.weldAll(model)
	return model
end
