-- Charcoal Pile — irregular pile of black charcoal lumps with faint ember glow.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CHARCOAL   = Color3.fromRGB(35, 28, 25)
local CHARCOAL_2 = Color3.fromRGB(50, 40, 35)
local EMBER      = Color3.fromRGB(255, 128, 48)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CharcoalPile", parent)

	-- Base disc (flat pile spread)
	local base = AB.cylinder(4, 0.4, CHARCOAL, AB.offset(originCF, 0, 0.2, 0), model, "Base")

	-- Irregular lumps stacked
	local lumps = {
		{Vector3.new( 0,    0.6,  0),    1.4},
		{Vector3.new( 1.2,  0.5,  0.5),  1.1},
		{Vector3.new(-1.0,  0.4,  0.8),  1.0},
		{Vector3.new( 0.6,  0.8, -0.9),  1.2},
		{Vector3.new(-0.8,  0.5, -0.6),  0.9},
		{Vector3.new( 0.2,  1.2,  0.2),  1.0},
		{Vector3.new(-1.4,  0.3, -0.3),  0.8},
		{Vector3.new( 1.3,  0.3, -1.1),  0.9},
	}
	for i, l in lumps do
		local col = (i % 2 == 0) and CHARCOAL_2 or CHARCOAL
		local s = AB.sphere(l[2], col, originCF * CFrame.new(l[1]), model, "Lump_" .. i)
		s.Material = Enum.Material.Slate
	end

	-- A couple of faint embers peeking through
	for i, p in {Vector3.new(0.3, 0.8, 0.4), Vector3.new(-0.4, 0.7, -0.3)} do
		local em = AB.sphere(0.3, EMBER, originCF * CFrame.new(p), model, "Ember_" .. i)
		AB.neon(em)
		AB.glow(em, EMBER, 1.2)
	end

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
