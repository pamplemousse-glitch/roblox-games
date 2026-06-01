-- Red Paper Lantern String — 6 red paper lanterns hung from a wood beam
-- on two short posts. Standalone prop, drop anywhere outside a shop.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local LANTERN_RED = Color3.fromRGB(220, 70, 60)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local STONE       = Color3.fromRGB(120, 115, 105)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RedPaperLanternString", parent)

	-- Two stone bases
	for i, x in {-9, 9} do
		AB.block(Vector3.new(1.4, 0.6, 1.4), STONE,
			AB.offset(originCF, x, 0.3, 0), model, "Base_" .. i)
	end
	-- Two wood posts
	for i, x in {-9, 9} do
		AB.cylinder(0.6, 9, DARK_WOOD,
			AB.offset(originCF, x, 5, 0), model, "Post_" .. i)
	end
	-- Top crossbeam
	AB.block(Vector3.new(20, 0.5, 0.5), DARK_WOOD,
		AB.offset(originCF, 0, 9.2, 0), model, "Crossbeam")

	-- 6 hanging lanterns
	for i = 1, 6 do
		local x = (i - 3.5) * 2.8
		local lantern = AB.cylinder(1.4, 1.8, LANTERN_RED,
			AB.offset(originCF, x, 7.2, 0), model, "Lantern_" .. i)
		AB.neon(lantern)
		AB.glow(lantern, LANTERN_Y, 2)
		-- Caps
		AB.cylinder(1.45, 0.18, DARK_WOOD, AB.offset(originCF, x, 8.15, 0), model, "CapT_" .. i)
		AB.cylinder(1.45, 0.18, DARK_WOOD, AB.offset(originCF, x, 6.25, 0), model, "CapB_" .. i)
		-- Rope
		AB.block(Vector3.new(0.08, 0.7, 0.08), DARK_WOOD,
			AB.offset(originCF, x, 8.6, 0), model, "Rope_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
