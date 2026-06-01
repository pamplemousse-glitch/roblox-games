-- Papel Picado String — long string of papel picado banners strung between
-- two thin wooden poles. Banners cycle through traditional fiesta colors and
-- show punched-out cutout dots. Two neon banners for night visibility.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local BOUG_PINK    = Color3.fromRGB(220, 80, 140)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local CREAM        = Color3.fromRGB(245, 230, 200)
local ROPE_TAN     = Color3.fromRGB(180, 150, 90)
local CUTOUT_DARK  = Color3.fromRGB(25, 20, 30)

local PAPEL_COLORS = {BOUG_PINK, FIESTA_YEL, PAPEL_GREEN, AGAVE_TEAL, TERRACOTTA, CREAM}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PapelPicadoString", parent)

	-- Two thin wooden poles (8 studs tall) at the ends
	local poleX = 8
	local leftPole = AB.cylinder(0.5, 8, WOOD_DARK,
		AB.offset(originCF, -poleX, 4, 0), model, "PoleL")
	AB.cylinder(0.5, 8, WOOD_DARK,
		AB.offset(originCF, poleX, 4, 0), model, "PoleR")

	-- Small decorative caps on the poles (small colored cubes)
	AB.block(Vector3.new(0.9, 0.6, 0.9), TERRACOTTA,
		AB.offset(originCF, -poleX, 8.3, 0), model, "PoleCapL")
	AB.block(Vector3.new(0.9, 0.6, 0.9), TERRACOTTA,
		AB.offset(originCF, poleX, 8.3, 0), model, "PoleCapR")
	-- Decorative finial spheres
	AB.sphere(0.45, BOUG_PINK,
		AB.offset(originCF, -poleX, 8.85, 0), model, "FinialL")
	AB.sphere(0.45, AGAVE_TEAL,
		AB.offset(originCF, poleX, 8.85, 0), model, "FinialR")

	-- Base anchors (small terracotta blocks at the foot of each pole)
	AB.block(Vector3.new(1.3, 0.4, 1.3), TERRACOTTA,
		AB.offset(originCF, -poleX, 0.2, 0), model, "PoleBaseL")
	AB.block(Vector3.new(1.3, 0.4, 1.3), TERRACOTTA,
		AB.offset(originCF, poleX, 0.2, 0), model, "PoleBaseR")

	-- Horizontal rope (~16 studs long) with slight sag — we use 3 segments to
	-- approximate the catenary curve.
	-- Top rope rests at y ~ 7.8 at the ends, sagging to ~7.3 in the middle.
	local ropeSegs = {
		{x1 = -poleX, y1 = 7.8, x2 = -poleX / 2, y2 = 7.4},
		{x1 = -poleX / 2, y1 = 7.4, x2 = poleX / 2, y2 = 7.3},
		{x1 = poleX / 2, y1 = 7.4, x2 = poleX, y2 = 7.8},
	}
	for i, seg in ropeSegs do
		local cx = (seg.x1 + seg.x2) / 2
		local cy = (seg.y1 + seg.y2) / 2
		local dx = seg.x2 - seg.x1
		local dy = seg.y2 - seg.y1
		local len = math.sqrt(dx * dx + dy * dy)
		local angle = math.atan2(dy, dx)
		AB.cylinder(0.15, len, ROPE_TAN,
			AB.offset(originCF, cx, cy, 0) * CFrame.Angles(0, 0, angle),
			model, "Rope_" .. i)
	end

	-- 9 papel picado rectangles hanging down at varying sag heights
	local papelCount = 9
	for i = 1, papelCount do
		local t = (i - 0.5) / papelCount
		local x = -poleX + t * (poleX * 2)
		-- Match the rope sag curve: parabolic sag, lowest in middle
		local sag = 4 * (t - 0.5) * (t - 0.5) -- 0 at center, 1 at edges
		local ropeY = 7.3 + sag * 0.5         -- 7.3 center to 7.8 edges
		local papelTopY = ropeY - 0.1
		local papelCenterY = papelTopY - 0.45
		local color = PAPEL_COLORS[((i - 1) % #PAPEL_COLORS) + 1]

		-- Main papel rectangle 1.2W × 0.9H × 0.05D
		local papel = AB.block(Vector3.new(1.2, 0.9, 0.05), color,
			AB.offset(originCF, x, papelCenterY, 0), model, "Papel_" .. i)

		-- Make 1st and last papel neon for night visibility
		if i == 2 or i == papelCount - 1 then
			AB.neon(papel)
			AB.glow(papel, color, 1.8)
		end

		-- Tiny cutout hole detail blocks (suggesting punched-out pattern)
		-- 3 cutouts arranged on each papel
		AB.block(Vector3.new(0.15, 0.15, 0.06), CUTOUT_DARK,
			AB.offset(originCF, x - 0.3, papelCenterY + 0.15, 0.01),
			model, "Cut_" .. i .. "_a")
		AB.block(Vector3.new(0.15, 0.15, 0.06), CUTOUT_DARK,
			AB.offset(originCF, x + 0.3, papelCenterY + 0.15, 0.01),
			model, "Cut_" .. i .. "_b")
		AB.block(Vector3.new(0.2, 0.1, 0.06), CUTOUT_DARK,
			AB.offset(originCF, x, papelCenterY - 0.15, 0.01),
			model, "Cut_" .. i .. "_c")

		-- Tiny knot at top connecting to rope
		AB.sphere(0.12, ROPE_TAN,
			AB.offset(originCF, x, papelTopY + 0.05, 0),
			model, "Knot_" .. i)

		-- Bottom fringe edge detail (small block)
		AB.block(Vector3.new(1.2, 0.08, 0.06),
			(i % 2 == 0) and CREAM or color,
			AB.offset(originCF, x, papelCenterY - 0.45, 0),
			model, "Fringe_" .. i)
	end

	-- Extra decorative small flag at left pole top
	AB.block(Vector3.new(0.7, 0.5, 0.04), BOUG_PINK,
		AB.offset(originCF, -poleX + 0.6, 7.5, 0), model, "EndFlagL")
	-- Extra decorative small flag at right pole top
	AB.block(Vector3.new(0.7, 0.5, 0.04), AGAVE_TEAL,
		AB.offset(originCF, poleX - 0.6, 7.5, 0), model, "EndFlagR")

	-- Pole side accents (small terracotta rings near pole tops)
	AB.cylinder(0.8, 0.2, TERRACOTTA,
		AB.offset(originCF, -poleX, 7.0, 0)
			* CFrame.Angles(math.rad(90), 0, 0), model, "RingL")
	AB.cylinder(0.8, 0.2, TERRACOTTA,
		AB.offset(originCF, poleX, 7.0, 0)
			* CFrame.Angles(math.rad(90), 0, 0), model, "RingR")

	AB.pivot(model, leftPole)
	AB.weldAll(model)
	return model
end
