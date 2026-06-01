-- Neon Heart Sign — glowing pink/red heart-shaped sign, with "AMORE" below.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 100, 200)
local RED    = Color3.fromRGB(255, 60, 60)
local FRAME  = Color3.fromRGB(35, 35, 40)
local CHAIN  = Color3.fromRGB(80, 80, 90)
local NEON_W = Color3.fromRGB(255, 255, 230)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("NeonHeartSign", parent)

	-- Heart shape (2 spheres + 1 wedge)
	local b1 = AB.sphere(1.4, RED, AB.offset(originCF, -0.7, 4, 0), model, "HeartL")
	AB.neon(b1)
	AB.glow(b1, b1.Color, 2.5)
	local b2 = AB.sphere(1.4, RED, AB.offset(originCF, 0.7, 4, 0), model, "HeartR")
	AB.neon(b2)
	AB.glow(b2, b2.Color, 2.5)
	-- Bottom triangle
	local b3 = AB.wedge(Vector3.new(0.5, 2.2, 2.6), RED,
		AB.offset(originCF, 0, 2.2, 0) * CFrame.Angles(math.rad(180), 0, math.rad(90)), model, "HeartTip")
	AB.neon(b3)
	AB.glow(b3, b3.Color, 2.5)

	-- Pink inner highlight (smaller, slightly forward)
	local b4 = AB.sphere(0.6, PINK, AB.offset(originCF, -0.4, 4.2, 0.5), model, "HeartHLL")
	AB.neon(b4)
	local b5 = AB.sphere(0.6, PINK, AB.offset(originCF, 0.4, 4.2, 0.5), model, "HeartHLR")
	AB.neon(b5)

	-- "AMORE" text underneath (small white neon)
	local txt = AB.block(Vector3.new(2.4, 0.6, 0.2), NEON_W,
		AB.offset(originCF, 0, 1, 0), model, "Amore")
	AB.neon(txt)
	AB.glow(txt, txt.Color, 1.5)
	-- Frame around text
	AB.block(Vector3.new(2.6, 0.2, 0.3), FRAME, AB.offset(originCF, 0, 1.4, 0), model, "AmoreFrameTop")
	AB.block(Vector3.new(2.6, 0.2, 0.3), FRAME, AB.offset(originCF, 0, 0.6, 0), model, "AmoreFrameBot")

	-- Hanging chains
	AB.cylinder(0.08, 1.5, CHAIN, AB.offset(originCF, -1.5, 6, 0), model, "ChainL")
	AB.cylinder(0.08, 1.5, CHAIN, AB.offset(originCF,  1.5, 6, 0), model, "ChainR")

	-- Power cord trailing down
	AB.cylinder(0.1, 5, FRAME,
		AB.offset(originCF, 1.5, 2.5, -0.3) * CFrame.Angles(math.rad(20), 0, math.rad(20)),
		model, "Cord")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
