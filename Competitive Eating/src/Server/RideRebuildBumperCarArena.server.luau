-- RideRebuildBumperCarArena
-- Frank's Fairground ride-rebuild: BumperCarArena → "Classic Bumper Cars".
-- Belle-Époque themed arena, decorative only (no live bumper physics, no
-- RideController coupling — BumperCarArena has no entry in any of its tables).
--
-- Contract (per docs/BELLE_EPOQUE_RIDE_PLAYBOOK.md §11):
--   * No mcp__Roblox_Studio__* calls (orchestrator owns Studio).
--   * Pure primitives via AssetBuilder. No Meshy.
--   * Idempotent rebuild: clone old → ServerStorage, ClearAllChildren on the
--     same Model, rebuild children, re-pivot.
--   * Footprint = 2× original (read live from current model bbox).
--   * MANDATORY PivotAnchor pattern: invisible identity-rotation anchor at
--     the model origin is PrimaryPart so PivotTo() doesn't bake rotation.
--
-- Visual brief:
--   * Smooth deep_wood plank floor (NOT cocoa drink).
--   * Surrounding ivory + burgundy wall with antique_gold rim (NOT cocoa cup).
--   * 6-8 bumper cars: burgundy + ivory two-tone shells with rubber bumpers
--     and a single Seat each.
--   * Overhead string lights — crimson_glow + ivory bulbs.

local ServerStorage     = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AB = require(ReplicatedStorage.Common.AssetBuilder)

local RIDE_NAME   = "BumperCarArena"
local BACKUP_NAME = RIDE_NAME .. "_PreBelleEpoque_2026-06-03"
local SCALE       = 2
local CAR_COUNT   = 7

-- Belle-Époque palette (per playbook). Palettes.luau not present in src/Common;
-- inline here, promote later.
local C = {
	burgundy     = Color3.fromRGB(130,  30,  50),
	ivory        = Color3.fromRGB(245, 235, 205),
	antique_gold = Color3.fromRGB(200, 160,  80),
	deep_wood    = Color3.fromRGB(110,  75,  45),
	wood_plank   = Color3.fromRGB(160, 110,  70),
	wrought_iron = Color3.fromRGB( 40,  35,  40),
	cream        = Color3.fromRGB(230, 215, 180),
	crimson_glow = Color3.fromRGB(220,  60,  70),
}

task.wait(1)   -- let peer rebuild scripts settle this server tick

local m = workspace:FindFirstChild(RIDE_NAME)
if not m or not m:IsA("Model") then
	warn(string.format("[RideRebuild] %s missing in workspace; skipping rebuild", RIDE_NAME))
	return
end

local originalPivot: CFrame = m:GetPivot()

local _origCF, origSize = m:GetBoundingBox()
local origFootprint = math.max(origSize.X, origSize.Z, 1)
-- Clamp so a corrupt empty source model can't produce a 4096-stud arena.
local arenaDiameter = math.clamp(origFootprint * SCALE, 60, 240)

-- Back up existing children (replace prior backup if present).
local prior = ServerStorage:FindFirstChild(BACKUP_NAME)
if prior then prior:Destroy() end
local clone = m:Clone()
clone.Name   = BACKUP_NAME
clone.Parent = ServerStorage

m:ClearAllChildren()
m.PrimaryPart = nil

-- ── PivotAnchor (MANDATORY first) ──────────────────────────────────────────
-- Identity-rotation invisible part at model origin = PrimaryPart, so PivotTo()
-- doesn't un-rotate the model.
local pivotAnchor = AB.part({
	size = Vector3.new(0.1, 0.1, 0.1), color = Color3.new(1, 1, 1),
	cf = CFrame.new(0, 0, 0), canCollide = false, transparency = 1,
	name = "PivotAnchor",
}, m)
m.PrimaryPart = pivotAnchor

-- ── Build constants ────────────────────────────────────────────────────────
local O           = CFrame.new(0, 0, 0)
local FLOOR_THICK = 1.2
local WALL_HEIGHT = 9
local WALL_THICK  = 2.0
local PLANK_COUNT = 14
local SEGMENTS    = 24
local radius      = arenaDiameter / 2

-- ── 1. Floor: deep_wood plank disc + alternating planks on top ─────────────
AB.cylinder(arenaDiameter, FLOOR_THICK, C.deep_wood,
	O * CFrame.new(0, -FLOOR_THICK / 2, 0), m, "ArenaFloorDisc")

local plankWidth = arenaDiameter / PLANK_COUNT
local plankThick = 0.25
for i = 1, PLANK_COUNT do
	local cx    = -radius + plankWidth * (i - 0.5)
	-- Chord length at this row across the disc; guard against tiny negatives.
	local chord = 2 * math.sqrt(math.max(radius * radius - cx * cx, 0))
	if chord > 1 then
		local color = (i % 2 == 0) and C.wood_plank or C.deep_wood
		AB.block(Vector3.new(plankWidth - 0.05, plankThick, chord - 0.2),
			color, O * CFrame.new(cx, plankThick / 2 + 0.01, 0), m,
			string.format("Plank_%d", i))
	end
end

-- ── 2. Perimeter wall: burgundy wainscot + ivory upper + antique_gold rim ──
local wallRadius = radius + WALL_THICK / 2
local segChord   = (math.pi * arenaDiameter) / SEGMENTS + 0.6   -- overlap
local wainscotH  = 2.5
local upperH     = WALL_HEIGHT - wainscotH

AB.circleArrange(O, wallRadius, SEGMENTS, m, function(i, cf, _)
	AB.block(Vector3.new(segChord, wainscotH, WALL_THICK), C.burgundy,
		cf * CFrame.new(0, wainscotH / 2, 0), m,
		string.format("WallWainscot_%d", i))
	return AB.block(Vector3.new(segChord, upperH, WALL_THICK - 0.1), C.ivory,
		cf * CFrame.new(0, wainscotH + upperH / 2, 0), m,
		string.format("WallPanel_%d", i))
end)

AB.circleArrange(O * CFrame.new(0, WALL_HEIGHT + 0.5, 0), wallRadius, SEGMENTS, m,
	function(i, cf, _)
		return AB.block(Vector3.new(segChord, 1, WALL_THICK + 0.5),
			C.antique_gold, cf, m, string.format("WallRim_%d", i))
	end)

-- ── 3. Boarding entry — remove 2 adjacent segments at +X for a doorway ─────
local function despawnSegments(prefix: string, indices: { number })
	for _, i in ipairs(indices) do
		local seg = m:FindFirstChild(string.format(prefix, i))
		if seg then seg:Destroy() end
	end
end
despawnSegments("WallPanel_%d",    { 1, 2 })
despawnSegments("WallWainscot_%d", { 1, 2 })
despawnSegments("WallRim_%d",      { 1, 2 })

local doorCF = O * CFrame.new(wallRadius + 1, 0.5, 0)
AB.block(Vector3.new(8, 1, WALL_THICK + 2), C.deep_wood, doorCF, m, "EntryRamp")
AB.block(Vector3.new(8, 0.3, WALL_THICK + 2), C.antique_gold,
	doorCF * CFrame.new(0, 0.65, 0), m, "EntryRampTrim")

-- ── 4. Bumper cars ─────────────────────────────────────────────────────────
-- Burgundy squashed-sphere body, ivory upper deck, wrought_iron rubber bumper
-- ring, antique_gold trim, decorative steering column + wheel, and a Seat on
-- top. Scattered on two concentric rings to avoid clock-face placement.
local CAR_DIAM   = 9
local CAR_SQUASH = 0.55
local CAR_HY     = CAR_DIAM * CAR_SQUASH / 2
local carRingR   = math.max(radius - CAR_DIAM - 4, 6)

for i = 1, CAR_COUNT do
	local angle  = ((i - 1) / CAR_COUNT) * math.pi * 2
	local r      = carRingR * (i % 2 == 0 and 0.55 or 1.0)
	local x, z   = math.cos(angle) * r, math.sin(angle) * r
	local yawRad = math.rad(-math.deg(angle) + 90)   -- tangential
	local carCF  = CFrame.new(x, 0, z) * CFrame.Angles(0, yawRad, 0)
	local car    = AB.model(string.format("BumperCar_%d", i), m)

	-- Burgundy body (squashed sphere)
	local body = AB.sphere(CAR_DIAM, C.burgundy,
		carCF * CFrame.new(0, CAR_HY, 0), car, "Body")
	body.Size = Vector3.new(CAR_DIAM, CAR_DIAM * CAR_SQUASH, CAR_DIAM)

	-- Ivory upper deck (two-tone)
	AB.cylinder(CAR_DIAM - 1.2, 0.5, C.ivory,
		carCF * CFrame.new(0, CAR_HY + 0.15, 0), car, "UpperDeck")

	-- Antique_gold thin trim band
	AB.cylinder(CAR_DIAM + 0.15, 0.3, C.antique_gold,
		carCF * CFrame.new(0, CAR_HY - 0.05, 0), car, "TrimBand")

	-- Wrought_iron rubber bumper
	AB.cylinder(CAR_DIAM + 0.8, 0.9, C.wrought_iron,
		carCF * CFrame.new(0, CAR_HY - 0.6, 0), car, "RubberBumper")

	-- Steering column + wheel (decorative)
	AB.block(Vector3.new(0.4, 1.6, 0.4), C.wrought_iron,
		carCF * CFrame.new(0, CAR_HY + 0.9, -CAR_DIAM * 0.18), car,
		"SteeringColumn")
	AB.cylinder(1.6, 0.3, C.deep_wood,
		carCF * CFrame.new(0, CAR_HY + 1.7, -CAR_DIAM * 0.18)
			* CFrame.Angles(math.rad(90), 0, 0), car, "SteeringWheel")

	-- Rider Seat — real Roblox Seat so a player walking up can sit.
	-- Decorative ride: anchored, no propulsion.
	local seat = Instance.new("Seat")
	seat.Name          = "Seat"
	seat.Size          = Vector3.new(2.8, 0.6, 2.8)
	seat.Color         = C.cream
	seat.Material      = Enum.Material.SmoothPlastic
	seat.TopSurface    = Enum.SurfaceType.Smooth
	seat.BottomSurface = Enum.SurfaceType.Smooth
	seat.Anchored      = true
	seat.CanCollide    = true
	seat.CFrame        = carCF * CFrame.new(0, CAR_HY + 0.8, 0.4)
	seat.Parent        = car

	car.PrimaryPart = body
	AB.weldAll(car)
end

-- ── 5. Overhead string lights — crimson_glow + ivory bulbs ─────────────────
-- Two crossed strings at 90°, each in its own sub-model so duplicate named
-- children (LightCable, Bulb_*) don't clash.
local STRING_Y       = WALL_HEIGHT + 4
local BULBS_PER_LINE = 9
local cableThick     = 0.18

local function buildStringLights(tag: string, yawRad: number)
	local sub     = AB.model("StringLights_" .. tag, m)
	local cableCF = O * CFrame.new(0, STRING_Y, 0) * CFrame.Angles(0, yawRad, 0)
	local cable   = AB.block(Vector3.new(arenaDiameter - 4, cableThick, cableThick),
		C.wrought_iron, cableCF, sub, "LightCable")
	sub.PrimaryPart = cable
	for j = 1, BULBS_PER_LINE do
		local t          = (j - 0.5) / BULBS_PER_LINE
		local localX     = -((arenaDiameter - 4) / 2) + t * (arenaDiameter - 4)
		local bulbColor  = (j % 2 == 0) and C.ivory or C.crimson_glow
		local bulb = AB.sphere(0.9, bulbColor,
			cableCF * CFrame.new(localX, -0.5, 0), sub,
			string.format("Bulb_%d", j))
		bulb.Material = Enum.Material.Neon
		AB.glow(bulb, bulbColor, bulbColor == C.crimson_glow and 1.2 or 0.8)
	end
	AB.weldAll(sub)
end

buildStringLights("A", 0)
buildStringLights("B", math.rad(90))

-- ── Finish up ──────────────────────────────────────────────────────────────
AB.weldAll(m)
m:PivotTo(originalPivot)

print(string.format(
	"[RideRebuild] %s rebuilt as Classic Bumper Cars — arena Ø %d, %d cars, %d descendants",
	RIDE_NAME, arenaDiameter, CAR_COUNT, #m:GetDescendants()
))
