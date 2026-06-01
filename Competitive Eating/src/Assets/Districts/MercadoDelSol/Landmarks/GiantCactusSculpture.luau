-- Giant Cactus Sculpture — 40-stud-tall saguaro cactus sculpture with two
-- branching arms, ribbed detail, white spines, and a crown of glowing pink
-- flowers. Surrounded by a small desert vignette of rocks, prickly pears,
-- a barrel cactus, and a tiny sun-bleached skull at the base.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CACTUS_GREEN  = Color3.fromRGB(80, 140, 70)
local CACTUS_DEEP   = Color3.fromRGB(50, 100, 50)
local CACTUS_FLOWER = Color3.fromRGB(220, 80, 140) -- pink
local BOUG_PINK     = Color3.fromRGB(220, 80, 140)
local FIESTA_YEL    = Color3.fromRGB(255, 184, 52)
local ADOBE_TAN     = Color3.fromRGB(200, 170, 120)
local ROCK_GREY     = Color3.fromRGB(130, 125, 120)
local ROCK_DARK     = Color3.fromRGB(95, 90, 85)
local SPINE_WHITE   = Color3.fromRGB(245, 240, 225)
local SKULL_BONE    = Color3.fromRGB(235, 225, 200)
local LIZARD_GREEN  = Color3.fromRGB(120, 160, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GiantCactusSculpture", parent)

	-- ── Sandy base ──────────────────────────────────────────────────────
	local sandBase = AB.cylinder(10, 0.5, ADOBE_TAN,
		AB.offset(originCF, 0, 0.25, 0), model, "SandBase")
	-- Slightly raised inner sand mound
	AB.cylinder(7, 0.4, ADOBE_TAN,
		AB.offset(originCF, 0, 0.55, 0), model, "SandMound")

	-- ── Main saguaro trunk ──────────────────────────────────────────────
	-- 30 studs tall, 4 stud diameter, centered at y=15.5 (base of trunk at y=0.5)
	AB.cylinder(4, 30, CACTUS_GREEN,
		AB.offset(originCF, 0, 15.5, 0), model, "TrunkMain")
	-- Rounded top cap on the trunk
	AB.sphere(4, CACTUS_GREEN,
		AB.offset(originCF, 0, 30.5, 0), model, "TrunkCap")

	-- Ribbed look — 6 vertical CACTUS_DEEP stripes around the trunk
	for r = 1, 6 do
		local a = (r - 1) * (math.pi * 2 / 6)
		local rx = math.cos(a) * 1.95
		local rz = math.sin(a) * 1.95
		AB.block(
			Vector3.new(0.25, 28, 0.25),
			CACTUS_DEEP,
			AB.offset(originCF, rx, 15, rz),
			model,
			"TrunkRib_" .. r
		)
	end

	-- ── Left arm: starts at y=14, sticks out left 6 studs, then up 10 ──
	-- Horizontal segment
	AB.cylinder(2.4, 6, CACTUS_GREEN,
		AB.offset(originCF, -4, 14, 0) * CFrame.Angles(0, 0, math.rad(90)),
		model, "LeftArmH")
	-- Elbow joint
	AB.sphere(2.4, CACTUS_GREEN,
		AB.offset(originCF, -6.5, 14, 0), model, "LeftArmElbow")
	-- Vertical segment (10 studs up from y=14 → top at y=24)
	AB.cylinder(2.4, 10, CACTUS_GREEN,
		AB.offset(originCF, -6.5, 19, 0), model, "LeftArmV")
	-- Rounded top cap
	AB.sphere(2.4, CACTUS_GREEN,
		AB.offset(originCF, -6.5, 24, 0), model, "LeftArmCap")

	-- Left arm ribs (vertical segment, 5 stripes)
	for r = 1, 5 do
		local a = (r - 1) * (math.pi * 2 / 5)
		local rx = math.cos(a) * 1.2
		local rz = math.sin(a) * 1.2
		AB.block(
			Vector3.new(0.2, 9, 0.2),
			CACTUS_DEEP,
			AB.offset(originCF, -6.5 + rx, 19, rz),
			model,
			"LArmRib_" .. r
		)
	end
	-- Left arm horizontal ribs (along the X axis, 4 short stripes)
	for r = 1, 4 do
		local a = (r - 1) * (math.pi * 2 / 4)
		local ry = math.cos(a) * 1.2
		local rz = math.sin(a) * 1.2
		AB.block(
			Vector3.new(5, 0.2, 0.2),
			CACTUS_DEEP,
			AB.offset(originCF, -4, 14 + ry, rz),
			model,
			"LArmHRib_" .. r
		)
	end

	-- ── Right arm: starts at y=20, sticks out right 5 studs, then up 8 ─
	-- Horizontal segment
	AB.cylinder(2.2, 5, CACTUS_GREEN,
		AB.offset(originCF, 3.5, 20, 0) * CFrame.Angles(0, 0, math.rad(90)),
		model, "RightArmH")
	-- Elbow joint
	AB.sphere(2.2, CACTUS_GREEN,
		AB.offset(originCF, 5.5, 20, 0), model, "RightArmElbow")
	-- Vertical segment (8 studs up from y=20 → top at y=28)
	AB.cylinder(2.2, 8, CACTUS_GREEN,
		AB.offset(originCF, 5.5, 24, 0), model, "RightArmV")
	-- Rounded top cap
	AB.sphere(2.2, CACTUS_GREEN,
		AB.offset(originCF, 5.5, 28, 0), model, "RightArmCap")

	-- Right arm vertical ribs
	for r = 1, 5 do
		local a = (r - 1) * (math.pi * 2 / 5)
		local rx = math.cos(a) * 1.1
		local rz = math.sin(a) * 1.1
		AB.block(
			Vector3.new(0.2, 7, 0.2),
			CACTUS_DEEP,
			AB.offset(originCF, 5.5 + rx, 24, rz),
			model,
			"RArmRib_" .. r
		)
	end
	-- Right arm horizontal ribs
	for r = 1, 4 do
		local a = (r - 1) * (math.pi * 2 / 4)
		local ry = math.cos(a) * 1.1
		local rz = math.sin(a) * 1.1
		AB.block(
			Vector3.new(4, 0.2, 0.2),
			CACTUS_DEEP,
			AB.offset(originCF, 3.5, 20 + ry, rz),
			model,
			"RArmHRib_" .. r
		)
	end

	-- ── White spines along trunk + arms ─────────────────────────────────
	-- Trunk spines: 6 vertical lines × 6 spines each = 36 trunk spines
	for line = 1, 6 do
		local a = (line - 1) * (math.pi * 2 / 6) + math.rad(30) -- offset between ribs
		local sx = math.cos(a) * 2.05
		local sz = math.sin(a) * 2.05
		for s = 1, 6 do
			local sy = 4 + (s - 1) * 4.2
			AB.block(
				Vector3.new(0.2, 0.2, 0.2),
				SPINE_WHITE,
				AB.offset(originCF, sx, sy, sz),
				model,
				string.format("TrunkSpine_%d_%d", line, s)
			)
		end
	end
	-- Left arm vertical spines
	for line = 1, 4 do
		local a = (line - 1) * (math.pi * 2 / 4) + math.rad(45)
		local sx = math.cos(a) * 1.25
		local sz = math.sin(a) * 1.25
		for s = 1, 4 do
			local sy = 15 + (s - 1) * 2.0
			AB.block(
				Vector3.new(0.2, 0.2, 0.2),
				SPINE_WHITE,
				AB.offset(originCF, -6.5 + sx, sy, sz),
				model,
				string.format("LArmSpine_%d_%d", line, s)
			)
		end
	end
	-- Right arm vertical spines
	for line = 1, 4 do
		local a = (line - 1) * (math.pi * 2 / 4) + math.rad(45)
		local sx = math.cos(a) * 1.15
		local sz = math.sin(a) * 1.15
		for s = 1, 3 do
			local sy = 22 + (s - 1) * 2.0
			AB.block(
				Vector3.new(0.2, 0.2, 0.2),
				SPINE_WHITE,
				AB.offset(originCF, 5.5 + sx, sy, sz),
				model,
				string.format("RArmSpine_%d_%d", line, s)
			)
		end
	end

	-- ── Crown of pink/red flowers at the top of the trunk ───────────────
	-- 6 flowers arranged around top of trunk + arm caps
	local flowerPositions = {
		Vector3.new(0,    32.0,  0),    -- trunk center top
		Vector3.new(1.3,  31.3,  0.8),  -- trunk top-right
		Vector3.new(-1.3, 31.3, -0.8),  -- trunk top-left
		Vector3.new(0.5,  31.5, -1.2),  -- trunk top-back
		Vector3.new(-6.5, 25.5,  0),    -- left arm top
		Vector3.new(5.5,  29.2,  0),    -- right arm top
	}
	for i, p in flowerPositions do
		-- Make some flowers neon for nighttime glow (every other one)
		local makeNeon = (i % 2 == 1)
		-- Flower center sphere (pink)
		local center = AB.sphere(0.9, CACTUS_FLOWER,
			AB.offset(originCF, p.X, p.Y, p.Z), model, "FlowerC_" .. i)
		if makeNeon then
			AB.neon(center)
			AB.glow(center, CACTUS_FLOWER, 2)
		end
		-- 5 petals radiating around the center
		for petal = 1, 5 do
			local pa = (petal - 1) * (math.pi * 2 / 5)
			local px = math.cos(pa) * 0.7
			local pz = math.sin(pa) * 0.7
			local petalPart = AB.block(
				Vector3.new(0.45, 0.4, 0.35),
				BOUG_PINK,
				AB.offset(originCF, p.X + px, p.Y, p.Z + pz)
					* CFrame.Angles(0, -pa, 0),
				model,
				string.format("FlowerP_%d_%d", i, petal)
			)
			if makeNeon then
				AB.neon(petalPart)
			end
		end
		-- 3 tiny FIESTA_YEL stamens at the center
		for st = 1, 3 do
			local sa = (st - 1) * (math.pi * 2 / 3)
			local stx = math.cos(sa) * 0.18
			local stz = math.sin(sa) * 0.18
			AB.sphere(0.18, FIESTA_YEL,
				AB.offset(originCF, p.X + stx, p.Y + 0.4, p.Z + stz),
				model, string.format("FlowerStamen_%d_%d", i, st))
		end
	end

	-- ── Surrounding rocks (5 scattered around the base) ─────────────────
	local rocks = {
		{x = 4.5,  z = 2.0,  size = 1.4, color = ROCK_GREY},
		{x = -4.2, z = 2.8,  size = 1.1, color = ROCK_DARK},
		{x = 3.0,  z = -4.0, size = 1.6, color = ROCK_GREY},
		{x = -3.5, z = -3.5, size = 0.9, color = ROCK_DARK},
		{x = 0,    z = 4.8,  size = 1.2, color = ROCK_GREY},
	}
	for i, rk in rocks do
		AB.block(
			Vector3.new(rk.size, rk.size * 0.6, rk.size * 0.8),
			rk.color,
			AB.offset(originCF, rk.x, 0.7 + rk.size * 0.3, rk.z)
				* CFrame.Angles(math.rad(i * 13), math.rad(i * 37), math.rad(i * 7)),
			model,
			"Rock_" .. i
		)
	end

	-- ── Small surrounding cacti ─────────────────────────────────────────
	-- Prickly pear (stacked oval pads), placed to the left-front
	local pp_base = Vector3.new(-3.0, 0.5, 3.5)
	-- Pad 1 (largest, bottom)
	AB.block(Vector3.new(1.6, 2.0, 0.45), CACTUS_GREEN,
		AB.offset(originCF, pp_base.X, pp_base.Y + 1.0, pp_base.Z)
			* CFrame.Angles(0, 0, math.rad(5)),
		model, "PP_Pad1")
	-- Pad 2 (top-left)
	AB.block(Vector3.new(1.3, 1.7, 0.45), CACTUS_GREEN,
		AB.offset(originCF, pp_base.X - 0.7, pp_base.Y + 2.4, pp_base.Z)
			* CFrame.Angles(0, math.rad(15), math.rad(-25)),
		model, "PP_Pad2")
	-- Pad 3 (top-right)
	AB.block(Vector3.new(1.2, 1.5, 0.45), CACTUS_GREEN,
		AB.offset(originCF, pp_base.X + 0.8, pp_base.Y + 2.3, pp_base.Z)
			* CFrame.Angles(0, math.rad(-15), math.rad(25)),
		model, "PP_Pad3")
	-- A couple tiny pink flower buds on the pads
	local ppBud1 = AB.sphere(0.35, CACTUS_FLOWER,
		AB.offset(originCF, pp_base.X - 1.0, pp_base.Y + 3.2, pp_base.Z),
		model, "PP_Bud1")
	AB.neon(ppBud1)
	AB.glow(ppBud1, CACTUS_FLOWER, 1.5)
	AB.sphere(0.3, FIESTA_YEL,
		AB.offset(originCF, pp_base.X + 1.2, pp_base.Y + 3.1, pp_base.Z),
		model, "PP_Bud2")
	-- A few white spines on the pads
	for s = 1, 6 do
		local px = pp_base.X + (s - 3.5) * 0.4
		local py = pp_base.Y + 1.0 + (s % 2) * 0.4
		AB.block(Vector3.new(0.15, 0.15, 0.5), SPINE_WHITE,
			AB.offset(originCF, px, py, pp_base.Z + 0.25),
			model, "PP_Spine_" .. s)
	end

	-- Barrel cactus (short stout cylinder), placed front-right
	local bc_x, bc_z = 3.5, 3.8
	AB.cylinder(2.2, 2.4, CACTUS_GREEN,
		AB.offset(originCF, bc_x, 1.7, bc_z), model, "BarrelCactus")
	-- Barrel ribs
	for r = 1, 6 do
		local a = (r - 1) * (math.pi * 2 / 6)
		local rx = math.cos(a) * 1.1
		local rz = math.sin(a) * 1.1
		AB.block(Vector3.new(0.18, 2.2, 0.18), CACTUS_DEEP,
			AB.offset(originCF, bc_x + rx, 1.7, bc_z + rz),
			model, "BC_Rib_" .. r)
	end
	-- Top flower on barrel cactus
	local bcFlower = AB.sphere(0.55, CACTUS_FLOWER,
		AB.offset(originCF, bc_x, 3.1, bc_z), model, "BC_Flower")
	AB.neon(bcFlower)
	AB.glow(bcFlower, CACTUS_FLOWER, 1.5)
	-- Tiny barrel spines
	for s = 1, 8 do
		local a = (s - 1) * (math.pi * 2 / 8)
		AB.block(Vector3.new(0.15, 0.15, 0.4), SPINE_WHITE,
			AB.offset(originCF, bc_x + math.cos(a) * 1.2, 2.0 + (s % 2) * 0.5, bc_z + math.sin(a) * 1.2)
				* CFrame.Angles(0, -a, 0),
			model, "BC_Spine_" .. s)
	end

	-- Tiny third cactus: a small barrel/bud behind the main trunk
	local sm_x, sm_z = -2.5, -4.0
	AB.cylinder(1.2, 1.6, CACTUS_GREEN,
		AB.offset(originCF, sm_x, 1.3, sm_z), model, "SmallCactus")
	AB.sphere(0.3, CACTUS_FLOWER,
		AB.offset(originCF, sm_x, 2.2, sm_z), model, "SmallCactusFlower")

	-- ── Sun-bleached skull at the base (small character detail) ─────────
	-- Skull dome
	AB.sphere(0.8, SKULL_BONE,
		AB.offset(originCF, 2.5, 1.0, -2.0), model, "Skull")
	-- Eye sockets (dark recesses)
	AB.sphere(0.2, ROCK_DARK,
		AB.offset(originCF, 2.3, 1.05, -1.65), model, "SkullEyeL")
	AB.sphere(0.2, ROCK_DARK,
		AB.offset(originCF, 2.7, 1.05, -1.65), model, "SkullEyeR")
	-- Jaw / teeth
	AB.block(Vector3.new(0.7, 0.25, 0.6), SKULL_BONE,
		AB.offset(originCF, 2.5, 0.65, -1.85), model, "SkullJaw")
	-- Tiny horns suggesting a cow skull
	AB.block(Vector3.new(0.15, 0.5, 0.15), SKULL_BONE,
		AB.offset(originCF, 2.0, 1.4, -2.1)
			* CFrame.Angles(0, 0, math.rad(-30)),
		model, "SkullHornL")
	AB.block(Vector3.new(0.15, 0.5, 0.15), SKULL_BONE,
		AB.offset(originCF, 3.0, 1.4, -2.1)
			* CFrame.Angles(0, 0, math.rad(30)),
		model, "SkullHornR")

	-- ── Tiny lizard sunning on a rock ───────────────────────────────────
	-- Body
	AB.block(Vector3.new(0.8, 0.18, 0.35), LIZARD_GREEN,
		AB.offset(originCF, -4.2, 1.35, 2.8), model, "LizardBody")
	-- Head
	AB.sphere(0.3, LIZARD_GREEN,
		AB.offset(originCF, -4.7, 1.4, 2.8), model, "LizardHead")
	-- Tail (thin tapered block)
	AB.block(Vector3.new(0.7, 0.12, 0.18), LIZARD_GREEN,
		AB.offset(originCF, -3.5, 1.35, 2.8), model, "LizardTail")
	-- 4 tiny legs
	for i, off in {
		Vector3.new(-0.3, 0,  0.2),
		Vector3.new(-0.3, 0, -0.2),
		Vector3.new( 0.3, 0,  0.2),
		Vector3.new( 0.3, 0, -0.2),
	} do
		AB.block(Vector3.new(0.12, 0.2, 0.12), LIZARD_GREEN,
			AB.offset(originCF, -4.2 + off.X, 1.15, 2.8 + off.Z),
			model, "LizardLeg_" .. i)
	end

	AB.pivot(model, sandBase)
	AB.weldAll(model)
	return model
end
