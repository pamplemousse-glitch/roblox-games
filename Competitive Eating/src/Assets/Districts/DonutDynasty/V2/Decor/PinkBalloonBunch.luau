-- PinkBalloonBunch — 5 helium balloons in shades of pink/cream/mint
-- tied to a gold weight on the ground.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CREAM  = Color3.fromRGB(255, 240, 220)
local MINT   = Color3.fromRGB(180, 230, 200)
local GOLD   = Color3.fromRGB(212, 168, 82)
local BROWN  = Color3.fromRGB(92,  57,  36)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PinkBalloonBunch", parent)

	-- Gold weight
	local weight = AB.cylinder(1.2, 0.6, GOLD,
		AB.offset(originCF, 0, 0.3, 0), model, "Weight")
	AB.cylinder(0.6, 0.3, BROWN, AB.offset(originCF, 0, 0.7, 0), model, "WeightKnot")

	-- Balloon configuration: { color, x, y, z }
	local balloons = {
		{PINK,  -1.5, 10, 0},
		{DEEP,   1.5, 10.5, 0.3},
		{CREAM,  0,   11.5, -1},
		{MINT,  -0.8, 12, 1},
		{PINK,   1.2, 12.5, -0.5},
	}

	for i, b in balloons do
		local col, bx, by, bz = b[1], b[2], b[3], b[4]
		-- Balloon body (slight oval = sphere + tiny stretch via two)
		AB.sphere(2.4, col, AB.offset(originCF, bx, by, bz), model, "Balloon_" .. i)
		-- Highlight (small pale dot)
		AB.sphere(0.5, CREAM, AB.offset(originCF, bx - 0.6, by + 0.6, bz + 0.6), model, "BalloonHi_" .. i)
		-- Knot
		AB.sphere(0.3, col, AB.offset(originCF, bx, by - 1.4, bz), model, "BalloonKnot_" .. i)
		-- String (thin cylinder)
		local stringLen = by - 1.6
		AB.cylinder(0.06, stringLen, CREAM,
			AB.offset(originCF, bx * 0.3, (by - 1.6) / 2 + 0.6, bz * 0.3), model, "String_" .. i)
	end

	-- Tiny ribbon at the bottom
	AB.sphere(0.4, DEEP, AB.offset(originCF, -0.4, 0.7, 0.3), model, "RibbonL")
	AB.sphere(0.4, DEEP, AB.offset(originCF, 0.4, 0.7, -0.3), model, "RibbonR")

	AB.pivot(model, weight)
	AB.weldAll(model)
	return model
end
