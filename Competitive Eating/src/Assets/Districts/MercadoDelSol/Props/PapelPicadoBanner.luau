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
		-- Center decorative cutout (sun motif suggestion)
		AB.block(Vector3.new(0.2, 0.2, 0.15), NOTCH_BLACK,
			AB.offset(originCF, x, 8.9, 0), model, "NotchTop_" .. i)
		-- Scalloped fringe at the bottom (3 tiny accent blocks below each flag)
		for s = 1, 3 do
			AB.block(Vector3.new(0.15, 0.15, 0.12), color,
				AB.offset(originCF, x - 0.4 + (s - 1) * 0.4, 8.1, 0),
				model, "Fringe_" .. i .. "_" .. s)
		end
	end

	-- Decorative pole caps (top of each pole)
	local capL = AB.sphere(0.6, FIESTA_YEL,
		AB.offset(originCF, -5, 10.2, 0), model, "CapL")
	AB.neon(capL)
	AB.glow(capL, FIESTA_YEL, 1.2)
	local capR = AB.sphere(0.6, BOUG_PINK,
		AB.offset(originCF,  5, 10.2, 0), model, "CapR")
	AB.neon(capR)
	AB.glow(capR, BOUG_PINK, 1.2)

	-- Small wooden base wedges at each pole foot
	AB.block(Vector3.new(1.2, 0.4, 1.2), WOOD_DARK,
		AB.offset(originCF, -5, 0.2, 0), model, "BaseL")
	AB.block(Vector3.new(1.2, 0.4, 1.2), WOOD_DARK,
		AB.offset(originCF,  5, 0.2, 0), model, "BaseR")

	-- Second smaller string of mini flags above the rope (decorative layer)
	AB.cylinder(0.12, 9, ROPE_TAN,
		AB.offset(originCF, 0, 10.4, 0) * CFrame.Angles(0, 0, math.rad(90)),
		model, "RopeUpper")
	for i = 1, 4 do
		local mx = -3 + (i - 1) * 2
		local mc = FLAG_COLORS[((i - 1) % #FLAG_COLORS) + 2 > #FLAG_COLORS and 1 or ((i - 1) % #FLAG_COLORS) + 2]
		AB.block(Vector3.new(0.8, 0.5, 0.08), mc,
			AB.offset(originCF, mx, 9.9, 0), model, "MiniFlag_" .. i)
	end

	AB.pivot(model, leftPole)
	AB.weldAll(model)
	return model
end
