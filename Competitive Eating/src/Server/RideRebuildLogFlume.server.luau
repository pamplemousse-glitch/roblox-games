-- RideRebuildLogFlume: rebuild workspace.LogFlume as a Hot Dog Flume.
--
-- HARD CONSTRAINT: the boat is built programmatically by RideController
-- .buildLogFlume (lines 345-426). Its `wps` table is hardcoded (X=235,
-- Z=-445→-295, Y=23.5→0.5). workspace.LogFlume children are PURELY visual
-- scenery; the boat does not read them.
--
-- Theme: mustard-yellow water trench, darker mustard banks, ketchup-bottle
-- dispenser at the lift hill (wps[1]→wps[2]), bun pylons, splash pool.
-- Channel is built 2× wider than the original (~12 studs vs ~6).

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AB = require(ReplicatedStorage.Common.AssetBuilder)

-- Let other rebuild scripts settle first.
task.wait(1)

local m = workspace:FindFirstChild("LogFlume") :: Model?
if not m then
	warn("[RideRebuildLogFlume] workspace.LogFlume not found — skipping")
	return
end

-- ── Backup ───────────────────────────────────────────────────────────────────
local backup = m:Clone()
backup.Name = "LogFlume_PreFood_2026-06-03"
backup.Parent = ServerStorage

-- Capture original pivot so we can restore it after rebuild.
local originalPivot: CFrame
do
	local ok, cf = pcall(function() return m:GetPivot() end)
	originalPivot = ok and cf or CFrame.new(235, 12, -370)
end

m:ClearAllChildren()
m.PrimaryPart = nil

-- ── Constants ────────────────────────────────────────────────────────────────
-- Waypoint centerline (must mirror RideController.buildLogFlume's `wps`).
local WPS: { Vector3 } = {
	Vector3.new(235, 23.5, -445),
	Vector3.new(235, 21.0, -440),
	Vector3.new(235, 18.5, -435),
	Vector3.new(235, 15.0, -425),
	Vector3.new(235, 11.5, -415),
	Vector3.new(235,  8.0, -405),
	Vector3.new(235,  4.5, -395),
	Vector3.new(235,  1.5, -385),
	Vector3.new(235,  1.0, -375),
	Vector3.new(235,  1.0, -363),
	Vector3.new(235,  1.0, -351),
	Vector3.new(235,  1.0, -339),
	Vector3.new(235,  1.0, -327),
	Vector3.new(235,  1.0, -315),
	Vector3.new(235,  0.5, -295),
}

-- 2× channel size: the original channel read as ~6 studs wide and ~1 stud
-- thick. Doubled means a 12-stud-wide trench with 2-stud-thick floor and
-- 3-stud-tall banks flanking it (4 studs wide each).
local CHANNEL_WIDTH      = 12
local CHANNEL_FLOOR_THK  = 2
local BANK_HEIGHT        = 3
local BANK_WIDTH         = 4

local MUSTARD       = AB.colors.mustard                  -- bright mustard
local MUSTARD_DARK  = Color3.fromRGB(170, 130, 35)       -- deeper mustard for banks
local KETCHUP       = AB.colors.ketchup
local BUN_TAN       = AB.colors.bunTan
local CAP_WHITE     = Color3.fromRGB(245, 240, 230)
local DRIP_YELLOW   = Color3.fromRGB(235, 195, 70)

-- ── Helper: build one straight channel segment between two waypoints ─────────
local function buildSegment(i: number, a: Vector3, b: Vector3, parent: Instance)
	local delta = b - a
	local len = delta.Magnitude
	local mid = (a + b) * 0.5

	-- Drop the segment so the water surface sits a hair BELOW the waypoint
	-- centerline (which is where the boat hull center rides). The boat hull is
	-- 1.8 tall so the bottom of the hull lives 0.9 below the wp Y — put the
	-- water-surface top right around 0.5 below the wp Y so the boat looks like
	-- it's floating in it.
	local water_y_offset = -1.3

	-- Orient the segment along the direction so steep top sections slope.
	local lookCF = CFrame.lookAt(mid + Vector3.new(0, water_y_offset, 0), b + Vector3.new(0, water_y_offset, 0))

	-- Floor of the channel = mustard slab.
	local floor = Instance.new("Part")
	floor.Name = string.format("ChannelFloor_%02d", i)
	floor.Size = Vector3.new(CHANNEL_WIDTH, CHANNEL_FLOOR_THK, len)
	floor.Color = MUSTARD
	floor.Material = Enum.Material.SmoothPlastic
	floor.Anchored = true
	floor.CanCollide = true
	floor.TopSurface = Enum.SurfaceType.Smooth
	floor.BottomSurface = Enum.SurfaceType.Smooth
	floor.CFrame = lookCF * CFrame.new(0, -CHANNEL_FLOOR_THK * 0.5, 0)
	floor.Parent = parent

	-- Left + right banks: darker mustard ridges flanking the trench.
	local bankOffset = (CHANNEL_WIDTH + BANK_WIDTH) * 0.5
	for _, side in ipairs({ -1, 1 }) do
		local bank = Instance.new("Part")
		bank.Name = string.format("Bank_%s_%02d", side < 0 and "L" or "R", i)
		bank.Size = Vector3.new(BANK_WIDTH, BANK_HEIGHT, len)
		bank.Color = MUSTARD_DARK
		bank.Material = Enum.Material.SmoothPlastic
		bank.Anchored = true
		bank.CanCollide = false  -- decoration only; don't trap the player
		bank.TopSurface = Enum.SurfaceType.Smooth
		bank.BottomSurface = Enum.SurfaceType.Smooth
		bank.CFrame = lookCF * CFrame.new(side * bankOffset, BANK_HEIGHT * 0.5 - CHANNEL_FLOOR_THK * 0.5, 0)
		bank.Parent = parent
	end
end

-- ── Build all channel segments ───────────────────────────────────────────────
for i = 1, #WPS - 1 do
	buildSegment(i, WPS[i], WPS[i + 1], m)
end

-- ── Lift hill: ketchup-bottle dispenser at wps[1]→wps[2] ─────────────────────
-- The dispenser sits over the top of the channel near wps[1]. It is purely
-- visual; the boat doesn't interact with it.
local liftTop = WPS[1]
do
	-- Bottle body (red cylinder) standing tall behind/above the top waypoint.
	local body = AB.cylinder(
		8,   -- diameter
		14,  -- height (along X internally, but cylinder() rotates Z to stand up)
		KETCHUP,
		CFrame.new(liftTop + Vector3.new(0, 7, 6)),
		m,
		"KetchupBottleBody"
	)
	body.Material = Enum.Material.SmoothPlastic
	body.CanCollide = false

	-- Tapered shoulder (slightly smaller cylinder above body).
	local shoulder = AB.cylinder(
		5,
		2,
		KETCHUP,
		CFrame.new(liftTop + Vector3.new(0, 15, 6)),
		m,
		"KetchupBottleShoulder"
	)
	shoulder.Material = Enum.Material.SmoothPlastic
	shoulder.CanCollide = false

	-- White cap.
	local cap = AB.cylinder(
		4.5,
		2.5,
		CAP_WHITE,
		CFrame.new(liftTop + Vector3.new(0, 17.5, 6)),
		m,
		"KetchupBottleCap"
	)
	cap.Material = Enum.Material.SmoothPlastic
	cap.CanCollide = false

	-- Yellow drip nozzle pointing down toward the trench top.
	local nozzle = Instance.new("Part")
	nozzle.Name = "KetchupBottleNozzle"
	nozzle.Size = Vector3.new(1.6, 1.6, 3)
	nozzle.Color = DRIP_YELLOW
	nozzle.Material = Enum.Material.Neon
	nozzle.Shape = Enum.PartType.Cylinder
	nozzle.Anchored = true
	nozzle.CanCollide = false
	-- Lay the cylinder horizontal so its axis points toward the channel.
	nozzle.CFrame = CFrame.new(liftTop + Vector3.new(0, 21.5, 3))
		* CFrame.Angles(0, 0, math.rad(90))
		* CFrame.Angles(0, math.rad(90), 0)
		* CFrame.Angles(math.rad(35), 0, 0)
	nozzle.Parent = m

	-- A "drip" of mustard catching the eye where the nozzle "pours" into the
	-- trench — a small mustard sphere just above the lift-hill water surface.
	AB.sphere(2.5, MUSTARD, CFrame.new(liftTop + Vector3.new(0, 0.5, 0)), m, "MustardDrip")
		.Material = Enum.Material.Neon

	-- Label sign on the bottle: tag it via Attribute so partCentroid logic
	-- treats this as structural-ish (decorative, not floor).
	body:SetAttribute("Structural", true)
	shoulder:SetAttribute("Structural", true)
	cap:SetAttribute("Structural", true)
end

-- ── Splash pool at the bottom of the flume ───────────────────────────────────
do
	local endPt = WPS[#WPS]
	local pool = Instance.new("Part")
	pool.Name = "SplashPool"
	pool.Size = Vector3.new(24, 1.5, 16)
	pool.Color = MUSTARD
	pool.Material = Enum.Material.Neon
	pool.Anchored = true
	pool.CanCollide = false  -- avoid bumping disembarking riders
	pool.TopSurface = Enum.SurfaceType.Smooth
	pool.BottomSurface = Enum.SurfaceType.Smooth
	pool.CFrame = CFrame.new(endPt + Vector3.new(0, -0.5, 8))
	pool.Parent = m

	-- Pool rim
	for _, side in ipairs({ -1, 1 }) do
		local rim = AB.block(
			Vector3.new(BANK_WIDTH, BANK_HEIGHT + 1, 16),
			MUSTARD_DARK,
			CFrame.new(endPt + Vector3.new(side * (CHANNEL_WIDTH + BANK_WIDTH) * 0.5, 0.5, 8)),
			m,
			string.format("PoolRim_%s", side < 0 and "L" or "R")
		)
		rim.CanCollide = false
	end
	-- Pool back wall to close it.
	AB.block(
		Vector3.new(CHANNEL_WIDTH + BANK_WIDTH * 2, BANK_HEIGHT + 1, BANK_WIDTH),
		MUSTARD_DARK,
		CFrame.new(endPt + Vector3.new(0, 0.5, 16)),
		m,
		"PoolBackWall"
	).CanCollide = false
end

-- ── Bun-shaped support pylons (every 4th waypoint, decorative) ───────────────
for i = 3, #WPS - 2, 4 do
	local wp = WPS[i]
	if wp.Y > 4 then
		local h = wp.Y - 0.5
		for _, side in ipairs({ -1, 1 }) do
			local px = wp.X + side * (CHANNEL_WIDTH * 0.5 + BANK_WIDTH + 1.5)
			local pylon = AB.cylinder(3, h, BUN_TAN, CFrame.new(px, h * 0.5, wp.Z), m,
				string.format("BunPylon_%s_%02d", side < 0 and "L" or "R", i))
			pylon.Material = Enum.Material.SmoothPlastic
			pylon.CanCollide = false
		end
	end
end

-- ── Anchor / PrimaryPart ─────────────────────────────────────────────────────
-- Use the first channel-floor segment as the PrimaryPart so the model's pivot
-- is well-defined for any downstream :PivotTo / :GetPivot consumers.
local primary = m:FindFirstChild("ChannelFloor_01") :: BasePart?
if primary then
	m.PrimaryPart = primary
end

AB.weldAll(m)

-- Restore the original pivot so the model still anchors where RideController
-- and any AssetSpawner placement logic expects it. Since the waypoints are
-- absolute world coords (boat doesn't read this model), this is a no-op for
-- the boat — but it keeps the Model's reported pivot consistent for any
-- future ride-positioning logic.
pcall(function() m:PivotTo(originalPivot) end)

print(string.format(
	"[RideRebuildLogFlume] Rebuilt LogFlume as Hot Dog Flume — %d parts",
	#m:GetDescendants()
))
