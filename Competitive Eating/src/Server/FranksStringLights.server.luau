-- FranksStringLights: festive string-light arcs strung between Frank's ride
-- landmarks. Each arc is 8 small neon spheres in a catenary curve between
-- two anchor poles. Pure primitive; parents under workspace.FranksStringLights.
--
-- Ride coordinates here are the BEST GUESS from the polish prompt. The
-- orchestrator should verify against the live .rbxl before merge — if any
-- ride has moved >50 stud the corresponding arcs will look wrong but will
-- not break anything (still spawn).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AB                = require(ReplicatedStorage.Common.AssetBuilder)

local POLE_BROWN = Color3.fromRGB(110,  75,  45)
local AMBER      = Color3.fromRGB(255, 180,  70)
local PINK       = Color3.fromRGB(255, 120, 170)
local LIME       = Color3.fromRGB(150, 240, 110)
local SKY_BLUE   = Color3.fromRGB(120, 200, 255)
local WARM_GOLD  = Color3.fromRGB(255, 220, 130)

local BULB_COLORS = { AMBER, PINK, LIME, SKY_BLUE, WARM_GOLD }

-- Idempotent reset
local existing = workspace:FindFirstChild("FranksStringLights")
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name   = "FranksStringLights"
root.Parent = workspace

-- Catenary-ish curve (parabolic approximation) between two world points.
-- sag = how many studs the cable dips below the line at midpoint.
local function bulbAlongArc(parent: Instance, p0: Vector3, p1: Vector3, sag: number, count: number, name: string)
	for i = 1, count do
		local t      = (i - 0.5) / count
		local mid    = p0:Lerp(p1, t)
		-- parabolic dip: 4*sag*t*(1-t) is max sag at t=0.5
		local dip    = 4 * sag * t * (1 - t)
		local pos    = mid - Vector3.new(0, dip, 0)
		local color  = BULB_COLORS[((i - 1) % #BULB_COLORS) + 1]
		local bulb   = AB.sphere(1.6, color, CFrame.new(pos), parent, name .. "_Bulb_" .. i)
		bulb.Material   = Enum.Material.Neon
		bulb.CanCollide = false
		AB.glow(bulb, color, 2)
	end
end

-- Build one arc: two thin poles + bulbs strung between their tops.
-- Returns the arc model.
local function buildArc(name: string, from: Vector3, to: Vector3, topY: number, sag: number, bulbCount: number): Model?
	local dx, dz = to.X - from.X, to.Z - from.Z
	local horizDist = math.sqrt(dx * dx + dz * dz)
	if horizDist > 200 then
		-- Too long for an arc to read right; skip silently.
		warn(string.format("[FranksStringLights] skipping %s (horiz dist=%.0f > 200)", name, horizDist))
		return nil
	end

	local m = AB.model(name, root)
	-- Pole supports at endpoints (1 × 15 × 1 stud thin posts)
	local poleSize = Vector3.new(1, 15, 1)
	local pole0 = AB.block(poleSize, POLE_BROWN, CFrame.new(from.X, 7.5, from.Z), m, "PoleA")
	AB.block(poleSize, POLE_BROWN, CFrame.new(to.X,   7.5, to.Z),   m, "PoleB")
	-- Bulb arc between pole tops (Y = topY)
	bulbAlongArc(m, Vector3.new(from.X, topY, from.Z), Vector3.new(to.X, topY, to.Z), sag, bulbCount, name)
	AB.pivot(m, pole0)
	return m
end

-- Ride landmark coordinates (BEST GUESS from prompt — orchestrator verify).
local Carousel       = Vector3.new(   0, 0,    0)
local PirateShip     = Vector3.new( -80, 0,    0)
local SwingCarousel  = Vector3.new(  60, 0,    0)
local MiniTrain      = Vector3.new(-240, 0, -355)
local BigWheel       = Vector3.new(-120, 0,  -60) -- approximate
local ScreamerEntry  = Vector3.new( 200, 0, -100) -- station-side guess

-- Define 12 candidate arcs. Anything >200 stud is auto-skipped by buildArc.
local arcs = {
	{ "Arc_Carousel_PirateShip",   Carousel,      PirateShip,    18, 4, 8 },
	{ "Arc_Carousel_SwingCarousel",Carousel,      SwingCarousel, 18, 3, 7 },
	{ "Arc_PirateShip_BigWheel",   PirateShip,    BigWheel,      18, 4, 8 },
	{ "Arc_SwingCarousel_BigWheel",SwingCarousel, BigWheel,      18, 4, 9 },
	{ "Arc_Carousel_BigWheel",     Carousel,      BigWheel,      20, 5, 9 },
	{ "Arc_BigWheel_Scream",       BigWheel,      ScreamerEntry, 18, 4, 8 },
	{ "Arc_Swing_Scream",          SwingCarousel, ScreamerEntry, 18, 5, 10 },
	{ "Arc_PirateShip_Train",      PirateShip,    MiniTrain,     20, 6, 10 },
	-- A few decorative loops back-to-back to fill the central area
	{ "Arc_Carousel_East",         Carousel,      Vector3.new( 90, 0,  60), 18, 3, 7 },
	{ "Arc_Carousel_West",         Carousel,      Vector3.new(-90, 0,  60), 18, 3, 7 },
	{ "Arc_Carousel_South",        Carousel,      Vector3.new(  0, 0,  90), 18, 3, 7 },
	{ "Arc_Carousel_North",        Carousel,      Vector3.new(  0, 0, -90), 18, 3, 7 },
}

local spawned = 0
local skipped = 0
for _, arc in arcs do
	local result = buildArc(arc[1], arc[2], arc[3], arc[4], arc[5], arc[6])
	if result then spawned += 1 else skipped += 1 end
end

print(string.format(
	"[FranksStringLights] spawned %d arcs (skipped %d > 200 stud)",
	spawned, skipped
))
