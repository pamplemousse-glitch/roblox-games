-- Papel Picado Banner — horizontal rope strung between two wooden poles, with
-- 5 colorful papel picado rectangles hanging beneath, each with notch holes.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA  = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL  = Color3.fromRGB(43, 140, 156)
local BOUG_PINK   = Color3.fromRGB(220, 80, 140)
local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local ROPE_TAN    = Color3.fromRGB(200, 175, 120)
local NOTCH_BLACK = Color3.fromRGB(20, 18, 16)

local FLAG_COLORS = {FIESTA_YEL, PAPEL_GREEN, AGAVE_TEAL, BOUG_PINK, TERRACOTTA}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PapelPicadoBanner", parent)

	-- Two wooden end poles
	local leftPole = AB.cylinder(0.4, 10, WOOD_DARK,
		AB.offset(originCF, -5, 5, 0), model, "PoleLeft")
	AB.cylinder(0.4, 10, WOOD_DARK,
		AB.offset(originCF,  5, 5, 0), model, "PoleRight")

	-- Horizontal rope spanning between poles
	AB.cylinder(0.2, 10, ROPE_TAN,
		AB.offset(originCF, 0, 9.7, 0) * CFrame.Angles(0, 0, math.rad(90)),
		model, "Rope")

	-- 5 papel picado flags hanging from the rope
	for i = 1, 5 do
		local x = -4 + (i - 1) * 2
		local color = FLAG_COLORS[i]
		local flag = AB.block(Vector3.new(1.5, 1, 0.1), color,
			AB.offset(originCF, x, 8.7, 0), model, "Flag_" .. i)
		AB.neon(flag)

		-- Two notch holes punched in the bottom edge
		AB.block(Vector3.new(0.3, 0.3, 0.15), NOTCH_BLACK,
			AB.offset(originCF, x - 0.35, 8.3, 0), model, "Notch_" .. i .. "_a")
		AB.block(Vector3.new(0.3, 0.3, 0.15), NOTCH_BLACK,
			AB.offset(originCF, x + 0.35, 8.3, 0), model, "Notch_" .. i .. "_b")
	end

	AB.pivot(model, leftPole)
	AB.weldAll(model)
	return model
end
