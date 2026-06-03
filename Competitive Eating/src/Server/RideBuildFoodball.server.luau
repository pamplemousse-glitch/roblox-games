-- RideBuildFoodball: NEW basketball-style stall for Frank's Fairground.
-- The hoop is a giant glazed donut (frosted with sprinkles) mounted on a
-- backboard. The "basketball" is a meatball. Footprint ~25x15x25 stud.
-- Includes a Seat + ProximityPrompt for boarding.
-- Mini-game logic deferred to v1.1; this is the visual stall only.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AB                = require(ReplicatedStorage.Common.AssetBuilder)

task.wait(1.2)  -- give other rebuild scripts a head start

-- Position: empty pad south-east of Frank's plaza, clear of food landmarks
-- which scatter from (0,0,-120) outward.  Picked clear of pretzel arch.
local STALL_CF = CFrame.new(60, 0, -40) * CFrame.Angles(0, math.rad(180), 0)

local BACKBOARD_W   = 18
local BACKBOARD_H   = 12
local STALL_W       = 25
local STALL_D       = 25
local STALL_H       = 16
local DONUT_OUTER_R = 5    -- giant donut outer radius
local DONUT_TUBE_R  = 1.6  -- thickness of the donut ring

-- Palette
local PINK_FROST = Color3.fromRGB(240, 150, 180)
local DOUGH      = Color3.fromRGB(225, 180, 120)
local SPRINKLE_C = {
	Color3.fromRGB(255, 100, 130),
	Color3.fromRGB( 90, 200, 100),
	Color3.fromRGB(120, 180, 255),
	Color3.fromRGB(255, 220,  80),
	Color3.fromRGB(180, 100, 220),
}
local BACKBOARD  = Color3.fromRGB(235, 220, 195)  -- cream
local TRIM_GOLD  = Color3.fromRGB(220, 180,  60)
local NEON_RED   = Color3.fromRGB(255,  90, 100)
local MEAT_BROWN = Color3.fromRGB(140,  80,  50)
local PARM_WHITE = Color3.fromRGB(245, 230, 200)
local POST_DARK  = Color3.fromRGB( 70,  45,  30)
local FLOOR_WOOD = Color3.fromRGB(130,  90,  55)
local AWNING_RED = Color3.fromRGB(170,  35,  45)
local AWNING_CRM = Color3.fromRGB(238, 224, 196)

-- Idempotent rebuild
local existing = workspace:FindFirstChild("Foodball")
if existing then existing:Destroy() end

local m = AB.model("Foodball", workspace)

-- ── Floor pad ────────────────────────────────────────────────────────────────
local floor = AB.block(Vector3.new(STALL_W, 0.6, STALL_D), FLOOR_WOOD,
	STALL_CF * CFrame.new(0, 0.3, 0), m, "Floor")

-- ── Four corner posts + canopy ───────────────────────────────────────────────
for i, sx in ipairs({ -1, 1 }) do
	for j, sz in ipairs({ -1, 1 }) do
		AB.block(Vector3.new(0.8, STALL_H, 0.8), POST_DARK,
			STALL_CF * CFrame.new(sx * (STALL_W / 2 - 0.5), STALL_H / 2 + 0.6,
				sz * (STALL_D / 2 - 0.5)), m,
			"Post_" .. i .. "_" .. j)
	end
end
-- Striped awning front (faces +Z in local-stall space; front of the stall)
for i = 1, 7 do
	local col = (i % 2 == 0) and AWNING_RED or AWNING_CRM
	local x = -STALL_W / 2 + (i - 0.5) * (STALL_W / 7)
	AB.block(Vector3.new(STALL_W / 7 - 0.1, 0.4, 4), col,
		STALL_CF * CFrame.new(x, STALL_H + 0.4, STALL_D / 2 - 1.5)
			* CFrame.Angles(math.rad(-12), 0, 0), m, "Awning_" .. i)
end
-- Gold fringe under awning
AB.neon(AB.block(Vector3.new(STALL_W, 0.3, 0.3), TRIM_GOLD,
	STALL_CF * CFrame.new(0, STALL_H - 0.4, STALL_D / 2 + 1.0), m, "AwningFringe"))

-- ── Sign board ───────────────────────────────────────────────────────────────
local sign = AB.block(Vector3.new(STALL_W - 4, 3, 0.5), AWNING_CRM,
	STALL_CF * CFrame.new(0, STALL_H + 2.8, STALL_D / 2 - 1.6), m, "SignBoard")
AB.billboard(sign, "FOODBALL", Vector2.new(520, 100), 0)
AB.neon(AB.block(Vector3.new(STALL_W - 4, 0.25, 0.25), NEON_RED,
	STALL_CF * CFrame.new(0, STALL_H + 1.3, STALL_D / 2 - 1.4), m, "SignNeon"))

-- ── Backboard (mounted at the back of the stall, facing the court) ───────────
-- Local Z- is "back wall"; the backboard faces +Z (toward player).
local BB_Z = -STALL_D / 2 + 1.5
local BB_Y = 9
AB.block(Vector3.new(BACKBOARD_W, BACKBOARD_H, 0.6), BACKBOARD,
	STALL_CF * CFrame.new(0, BB_Y, BB_Z), m, "Backboard")
-- Gold trim around backboard
AB.block(Vector3.new(BACKBOARD_W + 0.6, 0.4, 0.7), TRIM_GOLD,
	STALL_CF * CFrame.new(0, BB_Y + BACKBOARD_H / 2, BB_Z), m, "BBTrimTop")
AB.block(Vector3.new(BACKBOARD_W + 0.6, 0.4, 0.7), TRIM_GOLD,
	STALL_CF * CFrame.new(0, BB_Y - BACKBOARD_H / 2, BB_Z), m, "BBTrimBot")
AB.block(Vector3.new(0.4, BACKBOARD_H, 0.7), TRIM_GOLD,
	STALL_CF * CFrame.new( BACKBOARD_W / 2, BB_Y, BB_Z), m, "BBTrimE")
AB.block(Vector3.new(0.4, BACKBOARD_H, 0.7), TRIM_GOLD,
	STALL_CF * CFrame.new(-BACKBOARD_W / 2, BB_Y, BB_Z), m, "BBTrimW")
-- Inner square (shot target)
AB.block(Vector3.new(5, 4, 0.2), AWNING_RED,
	STALL_CF * CFrame.new(0, BB_Y, BB_Z + 0.4), m, "BBTargetSquare")

-- ── Donut hoop ───────────────────────────────────────────────────────────────
-- Approximated as a flat ring of small spheres (dough underbelly) with a top
-- layer of pink frosting and sprinkles. Centered just in front of backboard.
local HOOP_Y = BB_Y - 1.5
local HOOP_Z = BB_Z + DONUT_TUBE_R + 0.4

local SEGMENTS = 18
for i = 1, SEGMENTS do
	local ang = (i - 1) / SEGMENTS * 2 * math.pi
	local lx  = math.cos(ang) * DONUT_OUTER_R
	local ly  = math.sin(ang) * DONUT_OUTER_R
	-- Donut dough ring (bottom layer)
	AB.sphere(DONUT_TUBE_R * 2, DOUGH,
		STALL_CF * CFrame.new(lx, HOOP_Y + ly, HOOP_Z), m, "DonutDough_" .. i)
	-- Pink frosting on top of each segment (slightly elevated, smaller)
	AB.sphere(DONUT_TUBE_R * 1.7, PINK_FROST,
		STALL_CF * CFrame.new(lx, HOOP_Y + ly, HOOP_Z + 0.55), m,
		"DonutFrost_" .. i)
end
-- Sprinkles scattered on the frosting layer
for i = 1, 30 do
	local ang = math.random() * 2 * math.pi
	local r   = DONUT_OUTER_R + (math.random() - 0.5) * DONUT_TUBE_R * 0.8
	local lx  = math.cos(ang) * r
	local ly  = math.sin(ang) * r
	local col = SPRINKLE_C[((i - 1) % #SPRINKLE_C) + 1]
	AB.block(Vector3.new(0.35, 0.18, 0.18), col,
		STALL_CF * CFrame.new(lx, HOOP_Y + ly, HOOP_Z + 0.95)
			* CFrame.Angles(0, 0, ang), m, "Sprinkle_" .. i)
end
-- Net (drape of cream cylinders below the hoop)
for i = 1, 8 do
	local ang = (i - 1) / 8 * 2 * math.pi
	local lx  = math.cos(ang) * (DONUT_OUTER_R - 0.5)
	local lz  = math.sin(ang) * (DONUT_OUTER_R - 0.5)
	AB.cylinder(0.2, 3, AWNING_CRM,
		STALL_CF * CFrame.new(lx, HOOP_Y - 2, HOOP_Z + lz), m, "Net_" .. i)
end

-- ── Meatball ball, resting on counter ────────────────────────────────────────
local COUNTER_Y = 3.2
AB.block(Vector3.new(STALL_W - 4, 1.4, 1.4), POST_DARK,
	STALL_CF * CFrame.new(0, COUNTER_Y, STALL_D / 2 - 2.5), m, "Counter")
AB.sphere(2.2, MEAT_BROWN,
	STALL_CF * CFrame.new(-3, COUNTER_Y + 1.6, STALL_D / 2 - 2.5), m, "Meatball")
-- Parmesan sprinkle accents on the meatball area
for i = 1, 5 do
	local x = -4 + math.random() * 2
	local z = STALL_D / 2 - 2.5 + (math.random() - 0.5) * 0.8
	AB.block(Vector3.new(0.3, 0.1, 0.3), PARM_WHITE,
		STALL_CF * CFrame.new(x, COUNTER_Y + 0.85, z), m,
		"Parm_" .. i)
end

-- ── Player Seat (boarding spot, beside counter) ──────────────────────────────
local seat = Instance.new("Seat")
seat.Name        = "Seat"
seat.Size        = Vector3.new(2, 1, 2)
seat.Anchored    = true
seat.Material    = Enum.Material.Fabric
seat.Color       = AWNING_RED
seat.TopSurface    = Enum.SurfaceType.Smooth
seat.BottomSurface = Enum.SurfaceType.Smooth
seat.CFrame      = STALL_CF * CFrame.new(4, 1.5, STALL_D / 2 - 4)
seat.Parent      = m

-- ── ProximityPrompt on the counter ───────────────────────────────────────────
local counter = m:FindFirstChild("Counter") :: BasePart
if counter then
	local pp = Instance.new("ProximityPrompt")
	pp.ActionText  = "Play Foodball"
	pp.ObjectText  = "Carnival Stall"
	pp.HoldDuration = 0
	pp.MaxActivationDistance = 12
	pp.RequiresLineOfSight   = false
	pp.Parent       = counter
end

-- Set PrimaryPart so future PivotTo / RideController hooks work cleanly
m.PrimaryPart = floor
AB.weldAll(m)

print(string.format("[RideBuildFoodball] built Foodball stall: %d parts", #m:GetChildren()))
