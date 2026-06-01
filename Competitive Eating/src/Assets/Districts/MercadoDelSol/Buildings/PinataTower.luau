-- Piñata Tower — a tall pole with a chain of 6 colorful piñatas hanging
-- on ropes at descending heights. Each piñata is a 7-pointed star approximated
-- by a sphere with cones (small blocks) radiating out.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local POLE_DARK    = Color3.fromRGB(70, 50, 35)
local ROPE_TAN     = Color3.fromRGB(180, 150, 90)
local TERRACOTTA   = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL   = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN  = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL   = Color3.fromRGB(43, 140, 156)
local FLOWER_PINK  = Color3.fromRGB(230, 130, 165)
local FLOWER_PURP  = Color3.fromRGB(140, 90, 175)

local PINATA_COLORS = {FIESTA_YEL, AGAVE_TEAL, PAPEL_GREEN, FLOWER_PINK, TERRACOTTA, FLOWER_PURP}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PinataTower", parent)

	-- Foundation base
	local base = AB.cylinder(4, 1, Color3.fromRGB(140, 130, 120),
		AB.offset(originCF, 0, 0.5, 0), model, "Base")

	-- Tall pole
	AB.cylinder(0.8, 28, POLE_DARK,
		AB.offset(originCF, 0, 14, 0), model, "Pole")

	-- Top crossbar (T-shape so piñatas can hang in a row)
	AB.block(Vector3.new(12, 0.6, 0.6), POLE_DARK,
		AB.offset(originCF, 0, 27.5, 0), model, "Crossbar")

	-- Small decorative finial at the very top
	AB.sphere(1.2, FIESTA_YEL,
		AB.offset(originCF, 0, 28.5, 0), model, "Finial")
	AB.glow(model:FindFirstChild("Finial") :: BasePart, FIESTA_YEL, 1.5)

	-- 6 piñatas hanging from the crossbar at varied heights
	for i = 1, 6 do
		local x = -5 + (i - 1) * 2
		local hangHeight = 20 - ((i - 1) % 3) * 2.5
		local color = PINATA_COLORS[i]

		-- Rope from crossbar down to the piñata
		local ropeLen = 27.5 - hangHeight
		AB.part({
			size  = Vector3.new(0.15, ropeLen, 0.15),
			color = ROPE_TAN,
			cf    = AB.offset(originCF, x, 27.5 - ropeLen / 2, 0),
			name  = "Rope_" .. i,
		}, model)

		-- Piñata body (sphere)
		local body = AB.sphere(2.2, color,
			AB.offset(originCF, x, hangHeight, 0), model, "PinataBody_" .. i)

		-- Spike points (8 small protrusions in a ring around the equator)
		for s = 1, 8 do
			local a = (s - 1) * math.pi / 4
			local sx = math.cos(a) * 1.5
			local sz = math.sin(a) * 1.5
			AB.part({
				size  = Vector3.new(0.5, 0.5, 0.5),
				color = i % 2 == 0 and FIESTA_YEL or FLOWER_PINK,
				cf    = AB.offset(originCF, x + sx, hangHeight, sz)
				        * CFrame.Angles(0, -a, 0),
				name  = string.format("Spike_%d_%d", i, s),
			}, model)
		end

		-- Top + bottom spike accents (different color, vertical)
		AB.part({size=Vector3.new(0.5,0.6,0.5), color=PAPEL_GREEN,
			cf=AB.offset(originCF, x, hangHeight+1.4, 0), name="SpikeTop_"..i}, model)
		AB.part({size=Vector3.new(0.5,0.6,0.5), color=PAPEL_GREEN,
			cf=AB.offset(originCF, x, hangHeight-1.4, 0), name="SpikeBot_"..i}, model)

		-- Streamer tail at the bottom
		for t = 1, 3 do
			AB.part({
				size  = Vector3.new(0.15, 1.6, 0.15),
				color = PINATA_COLORS[((i + t) % #PINATA_COLORS) + 1],
				cf    = AB.offset(originCF, x + (t - 2) * 0.3, hangHeight - 2.6, 0),
				name  = string.format("Streamer_%d_%d", i, t),
			}, model)
		end
	end

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
