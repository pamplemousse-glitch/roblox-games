-- Japanese Flag Bunting — string of small Japanese flags (white with red
-- circle) strung along a wood crossbeam between two short posts.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local VERMILION   = Color3.fromRGB(200, 50, 40)
local STONE       = Color3.fromRGB(120, 115, 105)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("JapaneseFlagBunting", parent)

	-- Two stone bases + posts
	for i, x in {-10, 10} do
		AB.block(Vector3.new(1.4, 0.5, 1.4), STONE,
			AB.offset(originCF, x, 0.25, 0), model, "Base_" .. i)
		AB.cylinder(0.5, 8, WARM_WOOD,
			AB.offset(originCF, x, 4.5, 0), model, "Post_" .. i)
		-- Decorative top finial (small dark ball)
		AB.sphere(0.7, DARK_WOOD,
			AB.offset(originCF, x, 8.7, 0), model, "PostFinial_" .. i)
	end

	-- Rope crossbeam (sagging slightly via 3 segments)
	for j, segData in {
		{cf = AB.offset(originCF, -6.7, 7.6, 0) * CFrame.Angles(0, 0, math.rad(-5))},
		{cf = AB.offset(originCF,  0,   7.2, 0)},
		{cf = AB.offset(originCF,  6.7, 7.6, 0) * CFrame.Angles(0, 0, math.rad(5))},
	} do
		AB.cylinder(0.1, 7, DARK_WOOD,
			segData.cf * CFrame.Angles(0, 0, math.rad(90)),
			model, "Rope_" .. j)
	end

	-- 9 small flags hanging below the rope (each is a white panel with a red dot)
	for i = 1, 9 do
		local x = (i - 5) * 2.0
		local saggedY = 7.2 + math.abs(i - 5) * 0.05
		-- Tiny pole/string above flag
		AB.block(Vector3.new(0.06, 0.4, 0.06), DARK_WOOD,
			AB.offset(originCF, x, saggedY - 0.2, 0), model, "FlagString_" .. i)
		-- Flag face (white)
		AB.block(Vector3.new(1.4, 1, 0.08), PAPER_WHITE,
			AB.offset(originCF, x, saggedY - 0.9, 0), model, "FlagFace_" .. i)
		-- Red dot
		local dot = AB.cylinder(0.55, 0.1, VERMILION,
			AB.offset(originCF, x, saggedY - 0.9, 0.05), model, "FlagDot_" .. i)
		if i == 5 then
			AB.neon(dot)
			AB.glow(dot, VERMILION, 1.5)
		end
	end

	-- Two corner accent tassels (yellow rope balls)
	for i, x in {-10, 10} do
		AB.sphere(0.5, LANTERN_Y,
			AB.offset(originCF, x, 7.4, 0), model, "Tassel_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
