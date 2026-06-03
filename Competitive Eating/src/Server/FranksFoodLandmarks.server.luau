-- FranksFoodLandmarks: 5 monumental food landmarks in the empty sand around
-- Frank's Fairground. Pure primitive build; parents under workspace.FranksFoodLandmarks
-- so AssetSpawner's `Districts:ClearAllChildren` doesn't wipe it.
--
-- Landmarks:
--   1. Giant pretzel arch          (0,   0, -120)
--   2. Lollipop forest cluster   (-200, 0,  100)
--   3. Broccoli grove            ( 200, 0,   80)
--   4. Soft-serve mountain       (-150, 0, -180)
--   5. Corn-dog watchtower       ( 180, 0, -100)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AB                = require(ReplicatedStorage.Common.AssetBuilder)

local PRETZEL_BROWN  = Color3.fromRGB(180, 130,  70)
local SALT_WHITE     = Color3.fromRGB(245, 240, 225)
local LOLLI_RED      = Color3.fromRGB(220,  60,  70)
local LOLLI_WHITE    = Color3.fromRGB(250, 245, 240)
local LOLLI_STICK    = Color3.fromRGB(230, 215, 190)
local LOLLI_BLUE     = Color3.fromRGB( 90, 170, 230)
local LOLLI_GREEN    = Color3.fromRGB(120, 200,  90)
local LOLLI_YELLOW   = Color3.fromRGB(245, 220,  90)
local BROCC_GREEN    = Color3.fromRGB( 80, 150,  70)
local BROCC_DARK     = Color3.fromRGB( 55, 110,  50)
local BROCC_STALK    = Color3.fromRGB(180, 200, 140)
local SOFT_CREAM     = Color3.fromRGB(250, 240, 220)
local SOFT_VANILLA   = Color3.fromRGB(245, 230, 200)
local SOFT_CONE      = Color3.fromRGB(210, 170, 110)
local CORNDOG_GOLD   = Color3.fromRGB(220, 165,  80)
local CORNDOG_STICK  = Color3.fromRGB(180, 140,  90)
local CORNDOG_DOG    = Color3.fromRGB(160,  80,  55)
local PLATFORM_WOOD  = Color3.fromRGB(120,  85,  55)

-- Idempotent reset
local existing = workspace:FindFirstChild("FranksFoodLandmarks")
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name   = "FranksFoodLandmarks"
root.Parent = workspace

-- ── 1. Giant pretzel arch ────────────────────────────────────────────────────
local function buildPretzelArch(cf: CFrame)
	local m = AB.model("PretzelArch", root)
	-- Two upright legs (cylinders) + curved top approximated by a stack of
	-- offset cylinders forming a half-circle arch.
	-- Legs: AB.cylinder applies its own 90° Z-rotation so the cylinder stands
	-- vertical by default. We pass plain offset CFrames here.
	AB.cylinder(6, 22, PRETZEL_BROWN, AB.offset(cf, -14, 11, 0), m, "LegLeft")
	AB.cylinder(6, 22, PRETZEL_BROWN, AB.offset(cf,  14, 11, 0), m, "LegRight")
	-- Top arch segments (8 thick blocks along a half-circle of radius 14)
	for i = 0, 8 do
		local t   = i / 8
		local ang = math.rad(180 * t)
		local x   = -math.cos(ang) * 14
		local y   = 22 + math.sin(ang) * 14
		AB.block(Vector3.new(5, 6, 6), PRETZEL_BROWN,
			cf * CFrame.new(x, y, 0) * CFrame.Angles(0, 0, ang),
			m, "ArchSeg_" .. i)
	end
	-- Knot bumps (the iconic pretzel crossings)
	AB.sphere(7, PRETZEL_BROWN, AB.offset(cf,   0, 38, 0), m, "KnotTop")
	AB.sphere(6, PRETZEL_BROWN, AB.offset(cf, -10, 12, 0), m, "KnotLeft")
	AB.sphere(6, PRETZEL_BROWN, AB.offset(cf,  10, 12, 0), m, "KnotRight")
	-- Salt grains scattered on top
	for i = 1, 12 do
		local x = math.random(-130, 130) / 10
		local y = 30 + math.random(0, 80) / 10
		AB.sphere(1.2, SALT_WHITE, AB.offset(cf, x, y, math.random(-25, 25) / 10), m, "Salt_" .. i)
	end
	AB.pivot(m, m:FindFirstChild("LegLeft") :: BasePart)
	AB.weldAll(m)
end
buildPretzelArch(CFrame.new(0, 0, -120))

-- ── 2. Lollipop forest cluster ───────────────────────────────────────────────
local lolliColors = { LOLLI_RED, LOLLI_BLUE, LOLLI_GREEN, LOLLI_YELLOW, LOLLI_WHITE }
local function buildLollipopForest(cf: CFrame)
	local m = AB.model("LollipopForest", root)
	local stickPart: BasePart? = nil
	for i = 1, 10 do
		local localX = math.random(-40, 40)
		local localZ = math.random(-40, 40)
		local height = math.random(12, 25)
		local cap    = lolliColors[((i - 1) % #lolliColors) + 1]
		local stripe = lolliColors[(i % #lolliColors) + 1]
		-- Stick
		local s = AB.cylinder(1.2, height, LOLLI_STICK, AB.offset(cf, localX, height / 2, localZ), m, "Stick_" .. i)
		if not stickPart then stickPart = s end
		-- Disc top (round candy face) — block to read frontally from all angles
		AB.cylinder(8, 1.2, cap,
			AB.offset(cf, localX, height + 0.6, localZ), m, "Disc_" .. i)
		-- Striped overlay (slightly larger second disc, rotated for 2-tone read)
		AB.cylinder(8.4, 0.4, stripe,
			AB.offset(cf, localX, height + 1.2, localZ, 45), m, "Stripe_" .. i)
	end
	AB.pivot(m, stickPart)
	AB.weldAll(m)
end
buildLollipopForest(CFrame.new(-200, 0, 100))

-- ── 3. Broccoli grove ────────────────────────────────────────────────────────
local function buildBroccoliGrove(cf: CFrame)
	local m = AB.model("BroccoliGrove", root)
	local firstPart: BasePart? = nil
	for i = 1, 8 do
		local localX = math.random(-35, 35)
		local localZ = math.random(-35, 35)
		local stalkH = math.random(8, 14)
		-- Stalk
		local s = AB.cylinder(3, stalkH, BROCC_STALK,
			AB.offset(cf, localX, stalkH / 2, localZ), m, "Stalk_" .. i)
		if not firstPart then firstPart = s end
		-- Crown (3-4 spheres for crinkle look)
		local crownY = stalkH + 3
		AB.sphere(8,  BROCC_GREEN, AB.offset(cf, localX,     crownY,     localZ),     m, "Crown_" .. i)
		AB.sphere(6,  BROCC_DARK,  AB.offset(cf, localX + 3, crownY + 1, localZ - 2), m, "CrownA_" .. i)
		AB.sphere(6,  BROCC_GREEN, AB.offset(cf, localX - 3, crownY + 1, localZ + 2), m, "CrownB_" .. i)
		AB.sphere(5,  BROCC_DARK,  AB.offset(cf, localX,     crownY + 3, localZ),     m, "CrownC_" .. i)
	end
	AB.pivot(m, firstPart)
	AB.weldAll(m)
end
buildBroccoliGrove(CFrame.new(200, 0, 80))

-- ── 4. Soft-serve mountain ───────────────────────────────────────────────────
local function buildSoftServeMountain(cf: CFrame)
	local m = AB.model("SoftServeMountain", root)
	-- Cone base (waffle-tan) — stack of widening cylinders gives a cone shape
	local base = AB.cylinder(16, 4, SOFT_CONE, AB.offset(cf, 0, 2, 0), m, "ConeBase")
	AB.cylinder(13, 3, SOFT_CONE, AB.offset(cf, 0,  5.5, 0), m, "ConeMid")
	AB.cylinder(10, 3, SOFT_CONE, AB.offset(cf, 0,  8.5, 0), m, "ConeUp")
	-- Soft-serve swirl: stacked, slightly-offset spheres, each smaller than the
	-- one below — gives the iconic ice-cream swirl silhouette.
	local swirlColors = { SOFT_CREAM, SOFT_VANILLA }
	local y = 11
	local diameters = { 16, 15, 14, 12.5, 11, 9.5, 8, 6.5, 5, 4 }
	for i, d in diameters do
		local off = math.sin(i * 0.9) * 1.2
		AB.sphere(d, swirlColors[((i - 1) % 2) + 1], AB.offset(cf, off, y, off * 0.5), m, "Swirl_" .. i)
		y += d * 0.45
	end
	-- Tippy peak
	AB.sphere(2.5, SOFT_CREAM, AB.offset(cf, 0, y, 0), m, "Tip")
	AB.pivot(m, base)
	AB.weldAll(m)
end
-- Moved from (-150, 0, -180) — was right on top of workspace.TeacupRide
-- which sits at (-155, 7, -165). Two competing tall ice-cream-like columns
-- next to the donut ride read as a broken overlap. Relocated to a clear
-- patch ~300 stud east of the spawn cluster.
buildSoftServeMountain(CFrame.new(280, 0, -240))

-- ── 5. Corn-dog watchtower ───────────────────────────────────────────────────
local function buildCorndogTower(cf: CFrame)
	local m = AB.model("CorndogTower", root)
	-- Stick (extends down + out top of dog)
	local stick = AB.cylinder(2, 48, CORNDOG_STICK, AB.offset(cf, 0, 24, 0), m, "Stick")
	-- Corn-dog batter body (vertical golden cylinder)
	AB.cylinder(12, 36, CORNDOG_GOLD, AB.offset(cf, 0, 22, 0), m, "BatterCylinder")
	-- Sub-bumps along surface for fried texture
	for i = 1, 14 do
		local angle = (i / 14) * math.pi * 2
		local h     = 6 + math.random(0, 28)
		local x     = math.cos(angle) * 6
		local z     = math.sin(angle) * 6
		AB.sphere(2.4, CORNDOG_GOLD, AB.offset(cf, x, h, z), m, "Bump_" .. i)
	end
	-- Hot-dog cap exposed at the top (pinker)
	AB.sphere(7, CORNDOG_DOG, AB.offset(cf, 0, 40, 0), m, "DogCap")
	-- Platform with railing on top
	AB.block(Vector3.new(14, 0.6, 14), PLATFORM_WOOD, AB.offset(cf, 0, 44, 0), m, "Platform")
	local railOffsets = { {7, 0}, {-7, 0}, {0, 7}, {0, -7} }
	for i, side in railOffsets do
		AB.block(Vector3.new(0.4, 3, 0.4), PLATFORM_WOOD,
			AB.offset(cf, side[1], 45.5, side[2]), m, "Railing_" .. i)
	end
	AB.block(Vector3.new(14, 0.3, 0.4), PLATFORM_WOOD, AB.offset(cf, 0, 46.8,  7), m, "RailTopN")
	AB.block(Vector3.new(14, 0.3, 0.4), PLATFORM_WOOD, AB.offset(cf, 0, 46.8, -7), m, "RailTopS")
	AB.block(Vector3.new(0.4, 0.3, 14), PLATFORM_WOOD, AB.offset(cf,  7, 46.8, 0), m, "RailTopE")
	AB.block(Vector3.new(0.4, 0.3, 14), PLATFORM_WOOD, AB.offset(cf, -7, 46.8, 0), m, "RailTopW")
	AB.pivot(m, stick)
	AB.weldAll(m)
end
buildCorndogTower(CFrame.new(180, 0, -100))

print("[FranksFoodLandmarks] spawned 5 landmarks: pretzel arch, lollipop forest, broccoli grove, soft-serve mountain, corn-dog tower")
