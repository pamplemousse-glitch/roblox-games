-- RibbonStreamer — a hanging banner-style cloth streamer (alternating
-- deep-pink and cream segments) suspended from two gold finials.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CREAM  = Color3.fromRGB(255, 240, 220)
local GOLD   = Color3.fromRGB(212, 168, 82)
local BROWN  = Color3.fromRGB(92,  57,  36)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RibbonStreamer", parent)

	-- Two side poles
	for i, x in {-12, 12} do
		AB.cylinder(0.4, 12, BROWN, AB.offset(originCF, x, 6, 0), model, "Pole_" .. i)
		AB.sphere(0.9, GOLD, AB.offset(originCF, x, 12.5, 0), model, "Finial_" .. i)
		AB.cylinder(1.2, 0.3, GOLD, AB.offset(originCF, x, 0.15, 0), model, "PoleBase_" .. i)
	end

	-- Top rope arch (slightly drooping — 7 segments)
	local segCount = 7
	for i = 1, segCount do
		local t = (i - 1) / (segCount - 1)
		local x = -12 + t * 24
		-- Sag: y dips lower in the middle
		local y = 11.5 - math.sin(t * math.pi) * 1.5
		AB.sphere(0.3, CREAM, AB.offset(originCF, x, y, 0), model, "Rope_" .. i)
	end

	-- Hanging triangular flag pennants
	local pennantColors = {DEEP, CREAM, PINK, CREAM, DEEP, CREAM, PINK}
	for i = 1, 7 do
		local t = (i - 1) / 6
		local x = -10 + t * 20
		local y = 11.5 - math.sin(t * math.pi) * 1.5
		local col = pennantColors[i]
		-- Flag (wedge hanging down)
		AB.wedge(Vector3.new(0.2, 2.5, 2),
			col,
			AB.offset(originCF, x, y - 1.5, 0) * CFrame.Angles(math.rad(180), 0, 0),
			model, "Flag_" .. i)
		-- Knot at top
		AB.sphere(0.3, GOLD, AB.offset(originCF, x, y - 0.2, 0), model, "FlagKnot_" .. i)
	end

	-- Bow at center
	AB.sphere(1.4, DEEP, AB.offset(originCF, -1.2, 11.8, 0), model, "BowL")
	AB.sphere(1.4, DEEP, AB.offset(originCF, 1.2, 11.8, 0), model, "BowR")
	AB.block(Vector3.new(0.7, 0.7, 0.7), CREAM, AB.offset(originCF, 0, 11.8, 0), model, "BowKnot")
	-- Bow tails
	AB.block(Vector3.new(0.5, 3, 0.2), DEEP,
		AB.offset(originCF, -0.4, 9.5, 0) * CFrame.Angles(0, 0, math.rad(15)), model, "BowTailL")
	AB.block(Vector3.new(0.5, 3, 0.2), DEEP,
		AB.offset(originCF, 0.4, 9.5, 0) * CFrame.Angles(0, 0, math.rad(-15)), model, "BowTailR")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
