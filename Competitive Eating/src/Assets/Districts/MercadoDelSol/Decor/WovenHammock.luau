-- Woven Hammock — colorful sagging hammock strung between two wooden posts,
-- with rope ties, tassels, a cream pillow, a draped terracotta blanket, and a
-- small tropical leaf overhead on one post.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local BOUG_PINK    = Color3.fromRGB(220, 80, 140)
local WOOD_DARK    = Color3.fromRGB(110, 75, 45)
local CREAM        = Color3.fromRGB(245, 230, 200)
local ROPE_TAN     = Color3.fromRGB(180, 150, 90)
local CANDLE_FLAME = Color3.fromRGB(255, 200, 90)

local STRIPE_COLORS = {BOUG_PINK, FIESTA_YEL, PAPEL_GREEN, AGAVE_TEAL}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WovenHammock", parent)

	-- Two wooden posts (8 studs tall), 12 studs apart
	local postX = 6
	local leftPost = AB.cylinder(0.9, 8, WOOD_DARK,
		AB.offset(originCF, -postX, 4, 0), model, "PostL")
	AB.cylinder(0.9, 8, WOOD_DARK,
		AB.offset(originCF, postX, 4, 0), model, "PostR")

	-- Decorative post caps (small terracotta cubes)
	AB.block(Vector3.new(1.2, 0.5, 1.2), TERRACOTTA,
		AB.offset(originCF, -postX, 8.25, 0), model, "PostCapL")
	AB.block(Vector3.new(1.2, 0.5, 1.2), TERRACOTTA,
		AB.offset(originCF, postX, 8.25, 0), model, "PostCapR")
	AB.sphere(0.5, FIESTA_YEL,
		AB.offset(originCF, -postX, 8.7, 0), model, "PostFinialL")
	AB.sphere(0.5, FIESTA_YEL,
		AB.offset(originCF, postX, 8.7, 0), model, "PostFinialR")

	-- Hammock body — 9 segments in a sag curve
	-- y = 5 - sin((i/8)*pi) * 2 where i goes 0..8
	local segCount = 9
	for i = 0, segCount - 1 do
		local t = i / (segCount - 1)
		-- x interpolates from -postX+0.6 to postX-0.6
		local x = (-postX + 0.6) + t * ((postX - 0.6) - (-postX + 0.6))
		-- sag with sine curve, lowest in middle
		local y = 5 - math.sin(t * math.pi) * 2
		local color = STRIPE_COLORS[(i % #STRIPE_COLORS) + 1]
		-- Tilt the segment slightly to follow the curve
		local nextT = (i + 1) / (segCount - 1)
		local nextY = 5 - math.sin(nextT * math.pi) * 2
		local slope = math.atan2(nextY - y, 1.4) -- approximate tilt
		AB.block(Vector3.new(1.7, 0.22, 2.8),
			color,
			AB.offset(originCF, x, y, 0) * CFrame.Angles(0, 0, slope),
			model, "HammockSeg_" .. (i + 1))
		-- Tiny weave detail line on top of each segment
		AB.block(Vector3.new(1.7, 0.05, 0.15),
			CREAM,
			AB.offset(originCF, x, y + 0.15, 0) * CFrame.Angles(0, 0, slope),
			model, "Weave_" .. (i + 1))
	end

	-- Rope ties at each post end (thin tan cylinder going from post to hammock end)
	for side, sx in {-1, 1} do
		local sideLabel = (side == 1) and "L" or "R"
		AB.cylinder(0.18, 1.6, ROPE_TAN,
			AB.offset(originCF, sx * (postX - 0.3), 5.5, 0)
				* CFrame.Angles(0, 0, math.rad(45)), model, "RopeTie_" .. sideLabel)
		-- Rope ring around the post
		AB.cylinder(1.2, 0.25, ROPE_TAN,
			AB.offset(originCF, sx * postX, 5.8, 0)
				* CFrame.Angles(math.rad(90), 0, 0), model, "RopeRing_" .. sideLabel)
	end

	-- Tassels hanging from each end (3 short colorful threads per end)
	local tasselColors = {BOUG_PINK, FIESTA_YEL, PAPEL_GREEN}
	for side, sx in {-1, 1} do
		local sideLabel = (side == 1) and "L" or "R"
		for i, c in tasselColors do
			local offset = (i - 2) * 0.3
			AB.block(Vector3.new(0.12, 0.9, 0.12), c,
				AB.offset(originCF, sx * (postX - 0.8), 4.3, offset),
				model, "Tassel_" .. sideLabel .. "_" .. i)
			-- Tassel tip ball
			AB.sphere(0.2, c,
				AB.offset(originCF, sx * (postX - 0.8), 3.85, offset),
				model, "TasselTip_" .. sideLabel .. "_" .. i)
		end
	end

	-- Pillow on the hammock (small flat block, CREAM) — placed near one end
	AB.block(Vector3.new(1.8, 0.5, 1.2), CREAM,
		AB.offset(originCF, -3.5, 3.7, 0), model, "Pillow")
	-- Pillow accent stripe
	AB.block(Vector3.new(1.85, 0.15, 0.3), BOUG_PINK,
		AB.offset(originCF, -3.5, 3.95, 0), model, "PillowStripe")

	-- Blanket draped (small folded rectangle in TERRACOTTA)
	AB.block(Vector3.new(2.2, 0.3, 2.4), TERRACOTTA,
		AB.offset(originCF, 2.0, 3.3, 0), model, "Blanket")
	-- Blanket fringe
	for i = 1, 3 do
		local fz = -1.0 + (i - 1) * 1.0
		AB.block(Vector3.new(0.25, 0.4, 0.1), FIESTA_YEL,
			AB.offset(originCF, 3.0, 3.1, fz), model, "BlanketFringe_" .. i)
	end

	-- Small tropical leaf overhead on one post (PAPEL_GREEN wedges)
	for i = 1, 4 do
		local angle = (i - 1) * math.pi / 2
		AB.wedge(Vector3.new(0.3, 1.4, 0.8), PAPEL_GREEN,
			AB.offset(originCF, postX + 0.3, 8.9 + (i % 2) * 0.2, 0)
				* CFrame.Angles(0, angle, math.rad(20)),
			model, "Leaf_" .. i)
	end
	-- Leaf stem
	AB.cylinder(0.2, 0.8, WOOD_DARK,
		AB.offset(originCF, postX + 0.3, 8.8, 0), model, "LeafStem")

	-- Small lantern hanging from left post for night visibility (NEON)
	AB.cylinder(0.6, 0.6, FIESTA_YEL,
		AB.offset(originCF, -postX + 0.6, 7.6, 0), model, "LanternBody")
	local lantGlow = AB.sphere(0.45, CANDLE_FLAME,
		AB.offset(originCF, -postX + 0.6, 7.6, 0), model, "LanternGlow")
	AB.neon(lantGlow)
	AB.glow(lantGlow, CANDLE_FLAME, 2.2)
	AB.cylinder(0.08, 0.8, ROPE_TAN,
		AB.offset(originCF, -postX + 0.6, 8.2, 0), model, "LanternRope")

	AB.pivot(model, leftPost)
	AB.weldAll(model)
	return model
end
