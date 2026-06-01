-- Mariachi Bandstand — circular octagonal gazebo where mariachi bands play.
-- A tiered terracotta roof rises over a stucco platform ringed by 8 wooden
-- posts. String lights, papel picado, and 3 stylized mariachi figures with
-- instruments turn this into a visible focal point for the plaza.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA    = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL    = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN   = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL    = Color3.fromRGB(43, 140, 156)
local BOUG_PINK     = Color3.fromRGB(220, 80, 140)
local WOOD_DARK     = Color3.fromRGB(110, 75, 45)
local STUCCO_CREAM  = Color3.fromRGB(245, 230, 200)
local ROOF_TILE     = Color3.fromRGB(140, 65, 40)
local BURGUNDY      = Color3.fromRGB(110, 30, 40)
local SKIN_TONE     = Color3.fromRGB(220, 175, 130)
local BLACK_FELT    = Color3.fromRGB(35, 30, 30)
local BRASS         = Color3.fromRGB(220, 175, 60)
local WHITE_SHIRT   = Color3.fromRGB(240, 235, 220)

local PAPEL_COLORS = {FIESTA_YEL, AGAVE_TEAL, PAPEL_GREEN, BOUG_PINK, TERRACOTTA}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MariachiBandstand", parent)

	-- ── Platform base ────────────────────────────────────────────────────
	-- Center cylinder for the platform deck
	local deck = AB.cylinder(14, 1, STUCCO_CREAM,
		AB.offset(originCF, 0, 0.5, 0), model, "Deck")

	-- Octagonal platform ring (8 wedge blocks angled to form an octagon outline)
	for i = 1, 8 do
		local angle = (i - 1) * (math.pi * 2 / 8)
		local r = 7
		local x = r * math.cos(angle)
		local z = r * math.sin(angle)
		AB.wedge(
			Vector3.new(2.5, 0.9, 1.4),
			TERRACOTTA,
			AB.offset(originCF, x, 0.5, z) * CFrame.Angles(0, -angle + math.rad(90), 0),
			model,
			"PlatformWedge_" .. i
		)
	end

	-- Terracotta accent ring (thin trim around the platform edge)
	for i = 1, 16 do
		local a = (i - 1) * (math.pi * 2 / 16)
		AB.block(
			Vector3.new(0.4, 0.3, 1.3),
			TERRACOTTA,
			AB.offset(originCF, 7.2 * math.cos(a), 1.1, 7.2 * math.sin(a))
				* CFrame.Angles(0, -a, 0),
			model,
			"AccentRing_" .. i
		)
	end

	-- ── Front stairs (4 steps up) ────────────────────────────────────────
	for s = 1, 4 do
		local stepY = 0.25 + (s - 1) * 0.25
		local stepZ = 8 + (4 - s) * 0.6
		AB.block(
			Vector3.new(4 + (4 - s) * 0.3, 0.25, 0.6),
			STUCCO_CREAM,
			AB.offset(originCF, 0, stepY, stepZ),
			model,
			"Step_" .. s
		)
	end

	-- ── 8 ornate wooden support posts around the perimeter ──────────────
	local POST_R = 6.2
	for i = 1, 8 do
		local angle = (i - 1) * (math.pi * 2 / 8)
		local x = POST_R * math.cos(angle)
		local z = POST_R * math.sin(angle)
		-- Main post
		AB.cylinder(0.7, 10, WOOD_DARK,
			AB.offset(originCF, x, 6, z), model, "Post_" .. i)
		-- Decorative midpoint accent ring (terracotta)
		AB.cylinder(1.1, 0.4, TERRACOTTA,
			AB.offset(originCF, x, 6, z), model, "PostMidRing_" .. i)
		-- Top cap on each post
		AB.cylinder(1.0, 0.4, WOOD_DARK,
			AB.offset(originCF, x, 10.9, z), model, "PostCap_" .. i)
		-- Bottom base block
		AB.block(Vector3.new(1.0, 0.4, 1.0), WOOD_DARK,
			AB.offset(originCF, x, 1.2, z), model, "PostBase_" .. i)
	end

	-- ── Decorative railing between adjacent posts ───────────────────────
	for i = 1, 8 do
		local a1 = (i - 1) * (math.pi * 2 / 8)
		local a2 = i * (math.pi * 2 / 8)
		local x1, z1 = POST_R * math.cos(a1), POST_R * math.sin(a1)
		local x2, z2 = POST_R * math.cos(a2), POST_R * math.sin(a2)
		local mx, mz = (x1 + x2) / 2, (z1 + z2) / 2
		local segLen = math.sqrt((x2 - x1) ^ 2 + (z2 - z1) ^ 2)
		local segYaw = math.atan2(z2 - z1, x2 - x1)
		-- Skip the front segment (where stairs are) — leave open as entrance
		if i ~= 7 then
			-- Lower rail
			AB.block(Vector3.new(segLen - 0.6, 0.25, 0.25), WOOD_DARK,
				AB.offset(originCF, mx, 2.0, mz) * CFrame.Angles(0, -segYaw, 0),
				model, "RailLow_" .. i)
			-- Upper rail
			AB.block(Vector3.new(segLen - 0.6, 0.25, 0.25), WOOD_DARK,
				AB.offset(originCF, mx, 3.6, mz) * CFrame.Angles(0, -segYaw, 0),
				model, "RailHigh_" .. i)
			-- 3 small finial spindles between the rails
			for sp = 1, 3 do
				local t = sp / 4
				local sx = x1 + (x2 - x1) * t
				local sz = z1 + (z2 - z1) * t
				AB.block(Vector3.new(0.18, 1.5, 0.18), WOOD_DARK,
					AB.offset(originCF, sx, 2.8, sz),
					model, string.format("Spindle_%d_%d", i, sp))
				AB.sphere(0.3, TERRACOTTA,
					AB.offset(originCF, sx, 3.7, sz),
					model, string.format("SpindleFinial_%d_%d", i, sp))
			end
		end
	end

	-- ── Tiered roof ──────────────────────────────────────────────────────
	-- Lower roof tier: octagonal donut of wedges at height 11, angled inward
	for i = 1, 8 do
		local angle = (i - 1) * (math.pi * 2 / 8)
		local r = 7.5
		local x = r * math.cos(angle)
		local z = r * math.sin(angle)
		AB.wedge(
			Vector3.new(5, 2.5, 3.5),
			ROOF_TILE,
			AB.offset(originCF, x, 11.3, z)
				* CFrame.Angles(0, -angle + math.rad(90), math.rad(-25)),
			model,
			"RoofLower_" .. i
		)
	end

	-- Middle tier: smaller octagonal cylinder ring at height 14
	local midRoof = AB.cylinder(10, 1.2, ROOF_TILE,
		AB.offset(originCF, 0, 13.4, 0), model, "RoofMidBase")
	for i = 1, 8 do
		local angle = (i - 1) * (math.pi * 2 / 8)
		local r = 4.2
		local x = r * math.cos(angle)
		local z = r * math.sin(angle)
		AB.wedge(
			Vector3.new(3, 2, 2.5),
			ROOF_TILE,
			AB.offset(originCF, x, 14.5, z)
				* CFrame.Angles(0, -angle + math.rad(90), math.rad(-30)),
			model,
			"RoofMid_" .. i
		)
	end

	-- Upper finial spire: 4 stacked decreasing cylinders
	AB.cylinder(3.5, 1.0, ROOF_TILE,
		AB.offset(originCF, 0, 15.6, 0), model, "SpireRing1")
	AB.cylinder(2.5, 1.0, ROOF_TILE,
		AB.offset(originCF, 0, 16.4, 0), model, "SpireRing2")
	AB.cylinder(1.6, 1.0, ROOF_TILE,
		AB.offset(originCF, 0, 17.2, 0), model, "SpireRing3")
	AB.cylinder(0.8, 1.2, ROOF_TILE,
		AB.offset(originCF, 0, 18.0, 0), model, "SpireRing4")

	-- Top sun ornament: neon FIESTA_YEL sphere with radiating accent blocks
	local sun = AB.sphere(1.6, FIESTA_YEL,
		AB.offset(originCF, 0, 19.1, 0), model, "SunOrnament")
	AB.neon(sun)
	AB.glow(sun, FIESTA_YEL, 3)

	-- 8 sun rays around the ornament
	for r = 1, 8 do
		local a = (r - 1) * (math.pi * 2 / 8)
		local rx = math.cos(a) * 1.5
		local rz = math.sin(a) * 1.5
		local ray = AB.block(
			Vector3.new(1.2, 0.18, 0.18),
			FIESTA_YEL,
			AB.offset(originCF, rx, 19.1, rz) * CFrame.Angles(0, -a, 0),
			model, "SunRay_" .. r
		)
		AB.neon(ray)
	end

	-- Cross/star atop the sun (small radial accent)
	AB.block(Vector3.new(0.2, 1.2, 0.2), FIESTA_YEL,
		AB.offset(originCF, 0, 20.4, 0), model, "FinialV")
	AB.block(Vector3.new(0.8, 0.2, 0.2), FIESTA_YEL,
		AB.offset(originCF, 0, 20.4, 0), model, "FinialH")

	-- ── Hanging string lights between posts ─────────────────────────────
	-- 8 alternating bulbs around the perimeter just under the roof
	for i = 1, 8 do
		local angle = (i - 0.5) * (math.pi * 2 / 8)
		local x = (POST_R - 0.2) * math.cos(angle)
		local z = (POST_R - 0.2) * math.sin(angle)
		local color = (i % 2 == 0) and FIESTA_YEL or PAPEL_GREEN
		-- Tiny wire (thin block hanging from roof edge)
		AB.block(Vector3.new(0.08, 0.6, 0.08), WOOD_DARK,
			AB.offset(originCF, x, 9.8, z), model, "BulbWire_" .. i)
		local bulb = AB.sphere(0.55, color,
			AB.offset(originCF, x, 9.3, z), model, "Bulb_" .. i)
		AB.neon(bulb)
		AB.glow(bulb, color, 2)
	end

	-- ── Papel picado banner around underside of roof ────────────────────
	-- 8 small colorful rectangles between posts (rotates through palette)
	for i = 1, 8 do
		local angle = (i - 0.5) * (math.pi * 2 / 8)
		local r = 5.5
		local x = r * math.cos(angle)
		local z = r * math.sin(angle)
		local color = PAPEL_COLORS[((i - 1) % #PAPEL_COLORS) + 1]
		AB.block(
			Vector3.new(1.6, 1.0, 0.08),
			color,
			AB.offset(originCF, x, 10.4, z) * CFrame.Angles(0, -angle + math.rad(90), 0),
			model,
			"Papel_" .. i
		)
		-- Cut-out look: small darker accent
		AB.block(
			Vector3.new(0.6, 0.3, 0.06),
			STUCCO_CREAM,
			AB.offset(originCF, x, 10.4, z) * CFrame.Angles(0, -angle + math.rad(90), 0),
			model,
			"PapelCut_" .. i
		)
	end

	-- ── Spotlight beam from roof center pointing down ────────────────────
	-- 3 stacked translucent neon cones (cylinders) widening downward
	for b = 1, 3 do
		local diam = 1.5 + (b - 1) * 1.2
		local beam = AB.cylinder(diam, 1.6, FIESTA_YEL,
			AB.offset(originCF, 0, 9 - (b - 1) * 1.5, 0), model, "Spotlight_" .. b)
		AB.neon(beam)
		beam.Transparency = 0.55 + b * 0.08
		beam.CanCollide = false
	end

	-- ── Mariachi band: 3 stylized figures on the platform ───────────────
	-- Helper to build a small mariachi figure at (fx, fz) facing inward yaw deg
	local function buildMariachi(idx, fx, fz, instrument)
		local baseY = 1.2 -- standing on platform top
		-- Legs (black trousers)
		AB.block(Vector3.new(0.45, 1.2, 0.45), BLACK_FELT,
			AB.offset(originCF, fx - 0.3, baseY + 0.6, fz), model,
			"M" .. idx .. "_LegL")
		AB.block(Vector3.new(0.45, 1.2, 0.45), BLACK_FELT,
			AB.offset(originCF, fx + 0.3, baseY + 0.6, fz), model,
			"M" .. idx .. "_LegR")
		-- Torso (BURGUNDY mariachi jacket)
		AB.block(Vector3.new(1.4, 1.5, 0.8), BURGUNDY,
			AB.offset(originCF, fx, baseY + 2.0, fz), model,
			"M" .. idx .. "_Torso")
		-- White shirt collar accent
		AB.block(Vector3.new(0.4, 0.3, 0.8), WHITE_SHIRT,
			AB.offset(originCF, fx, baseY + 2.5, fz + 0.01), model,
			"M" .. idx .. "_Collar")
		-- Brass jacket buttons (2 small dots)
		AB.sphere(0.18, BRASS,
			AB.offset(originCF, fx - 0.3, baseY + 2.0, fz + 0.42), model,
			"M" .. idx .. "_Btn1")
		AB.sphere(0.18, BRASS,
			AB.offset(originCF, fx + 0.3, baseY + 2.0, fz + 0.42), model,
			"M" .. idx .. "_Btn2")
		-- Arms (BURGUNDY)
		AB.block(Vector3.new(0.4, 1.3, 0.4), BURGUNDY,
			AB.offset(originCF, fx - 0.9, baseY + 2.0, fz), model,
			"M" .. idx .. "_ArmL")
		AB.block(Vector3.new(0.4, 1.3, 0.4), BURGUNDY,
			AB.offset(originCF, fx + 0.9, baseY + 2.0, fz), model,
			"M" .. idx .. "_ArmR")
		-- Head (skin tone sphere)
		AB.sphere(0.7, SKIN_TONE,
			AB.offset(originCF, fx, baseY + 3.1, fz), model,
			"M" .. idx .. "_Head")
		-- Sombrero: wide black brim + black crown
		AB.cylinder(2.4, 0.18, BLACK_FELT,
			AB.offset(originCF, fx, baseY + 3.55, fz), model,
			"M" .. idx .. "_HatBrim")
		AB.cylinder(1.0, 0.7, BLACK_FELT,
			AB.offset(originCF, fx, baseY + 3.95, fz), model,
			"M" .. idx .. "_HatCrown")
		-- Brass band on the sombrero
		AB.cylinder(1.05, 0.15, BRASS,
			AB.offset(originCF, fx, baseY + 3.68, fz), model,
			"M" .. idx .. "_HatBand")

		-- Instrument
		if instrument == "guitarron" then
			-- Big oval BURGUNDY body
			AB.sphere(1.5, BURGUNDY,
				AB.offset(originCF, fx, baseY + 1.4, fz + 0.9), model,
				"M" .. idx .. "_Guitarron")
			-- Neck (wood)
			AB.block(Vector3.new(0.25, 1.6, 0.25), WOOD_DARK,
				AB.offset(originCF, fx, baseY + 2.6, fz + 0.9), model,
				"M" .. idx .. "_GtrNeck")
			-- Soundhole
			AB.sphere(0.4, BLACK_FELT,
				AB.offset(originCF, fx, baseY + 1.4, fz + 1.55), model,
				"M" .. idx .. "_GtrHole")
		elseif instrument == "violin" then
			-- Violin body (small wooden oval tucked under chin)
			AB.block(Vector3.new(0.6, 1.4, 0.3), WOOD_DARK,
				AB.offset(originCF, fx + 0.9, baseY + 2.8, fz + 0.4), model,
				"M" .. idx .. "_ViolinBody")
			-- Bow (thin wood stick held by arm)
			AB.block(Vector3.new(1.5, 0.08, 0.08), WHITE_SHIRT,
				AB.offset(originCF, fx + 1.6, baseY + 2.6, fz + 0.4)
					* CFrame.Angles(0, math.rad(20), 0), model,
				"M" .. idx .. "_Bow")
			-- Neck
			AB.block(Vector3.new(0.12, 0.6, 0.12), BLACK_FELT,
				AB.offset(originCF, fx + 1.0, baseY + 3.6, fz + 0.4), model,
				"M" .. idx .. "_ViolinNeck")
		elseif instrument == "trumpet" then
			-- Golden trumpet held forward
			AB.cylinder(0.3, 1.6, BRASS,
				AB.offset(originCF, fx, baseY + 2.2, fz + 1.0)
					* CFrame.Angles(0, 0, math.rad(90)), model,
				"M" .. idx .. "_TrumpetBody")
			-- Bell (flared end)
			AB.cylinder(0.9, 0.4, BRASS,
				AB.offset(originCF, fx, baseY + 2.2, fz + 1.9), model,
				"M" .. idx .. "_TrumpetBell")
			-- Valves (3 small bumps on top)
			for v = 1, 3 do
				AB.block(Vector3.new(0.18, 0.3, 0.18), BRASS,
					AB.offset(originCF, fx, baseY + 2.45, fz + 1.0 + (v - 2) * 0.25),
					model, "M" .. idx .. "_TrumpetValve_" .. v)
			end
		end
	end

	-- 3 figures arranged on the platform, slightly facing audience (+z)
	buildMariachi(1, -2.5, -1.0, "guitarron")
	buildMariachi(2,  0.0, -2.0, "violin")
	buildMariachi(3,  2.5, -1.0, "trumpet")

	AB.pivot(model, deck)
	AB.weldAll(model)
	return model
end
