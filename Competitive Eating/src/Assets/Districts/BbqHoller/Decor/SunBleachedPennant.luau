-- Sun-Bleached Pennant — long string of triangle pennants in washed-out
-- colors. Each triangle is a wedge alternating between faded shades.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CORD       = Color3.fromRGB(35, 30, 25)
local POST       = Color3.fromRGB(70, 45, 22)
local FADED_RED  = Color3.fromRGB(190, 130, 120)
local FADED_BLU  = Color3.fromRGB(130, 160, 180)
local FADED_YEL  = Color3.fromRGB(220, 200, 150)
local FADED_GRN  = Color3.fromRGB(150, 180, 140)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SunBleachedPennant", parent)

	-- Two posts
	local postL = AB.block(Vector3.new(0.4, 9, 0.4), POST, AB.offset(originCF, -12, 4.5, 0), model, "PostL")
	AB.block(Vector3.new(0.4, 9, 0.4), POST, AB.offset(originCF,  12, 4.5, 0), model, "PostR")

	-- Straight cord between them
	AB.block(Vector3.new(24, 0.1, 0.1), CORD, AB.offset(originCF, 0, 8.5, 0), model, "Cord")

	-- 16 triangle pennants hanging from the cord
	local palette = {FADED_RED, FADED_BLU, FADED_YEL, FADED_GRN}
	for i = 1, 16 do
		local x = -11.25 + (i - 1) * (22.5 / 15)
		local col = palette[((i - 1) % 4) + 1]
		-- Pennant is a tall narrow wedge tip pointing down
		local pennant = AB.wedge(Vector3.new(0.1, 1.6, 1.0), col, AB.offset(originCF, x, 7.7, 0), model, "Pennant_" .. i)
		pennant.CFrame = pennant.CFrame * CFrame.Angles(math.rad(180), 0, 0)
	end

	AB.pivot(model, postL)
	AB.weldAll(model)
	return model
end
