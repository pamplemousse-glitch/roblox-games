-- PizzaAtmosphereClient: when the local player enters PizzaAtmosphereZone,
-- lerp Lighting toward a Tuscan-sunset preset (warm amber ColorShift_Top,
-- pale cream FogColor, FogStart=200/FogEnd=600, Brightness=2.4). On exit,
-- lerp back to the captured baseline.
--
-- Mirrors DonutAtmosphereClient's loop + throttled zone check + baseline-
-- capture-on-startup pattern. Only the target preset and the specific
-- Lighting properties differ — Pizza lerps the ColorShift / Fog / Brightness
-- pipeline rather than the Atmosphere instance, since the Tuscan sunset is
-- more about warm directional tint than fog colour.

local Lighting   = game:GetService("Lighting")
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local ZONE_NAME       = "PizzaAtmosphereZone"
local ZONES_ROOT_NAME = "PizzaAtmosphereZones"
local CHECK_INTERVAL  = 0.25  -- seconds between zone checks
local LERP_DURATION   = 1.5   -- seconds to fade in/out (playbook-spec ~1.5s)

-- ── Lighting preset ──────────────────────────────────────────────────────────
type LightSnapshot = {
	ColorShift_Top: Color3,
	FogColor:       Color3,
	FogStart:       number,
	FogEnd:         number,
	Brightness:     number,
}

-- Pizza Plaza: Tuscan sunset. Warm amber directional tint up top + pale cream
-- fog low and far so distant tiled roofs pick up a buttery haze.
local PIZZA_PRESET: LightSnapshot = {
	ColorShift_Top = Color3.fromRGB(255, 200, 130),
	FogColor       = Color3.fromRGB(235, 220, 195),
	FogStart       = 200,
	FogEnd         = 600,
	Brightness     = 2.4,
}

local function snapshot(): LightSnapshot
	return {
		ColorShift_Top = Lighting.ColorShift_Top,
		FogColor       = Lighting.FogColor,
		FogStart       = Lighting.FogStart,
		FogEnd         = Lighting.FogEnd,
		Brightness     = Lighting.Brightness,
	}
end

local function lerpColor(a: Color3, b: Color3, t: number): Color3
	return Color3.new(
		a.R + (b.R - a.R) * t,
		a.G + (b.G - a.G) * t,
		a.B + (b.B - a.B) * t
	)
end

local function lerpSnapshot(a: LightSnapshot, b: LightSnapshot, t: number): LightSnapshot
	return {
		ColorShift_Top = lerpColor(a.ColorShift_Top, b.ColorShift_Top, t),
		FogColor       = lerpColor(a.FogColor,       b.FogColor,       t),
		FogStart       = a.FogStart   + (b.FogStart   - a.FogStart)   * t,
		FogEnd         = a.FogEnd     + (b.FogEnd     - a.FogEnd)     * t,
		Brightness     = a.Brightness + (b.Brightness - a.Brightness) * t,
	}
end

local function applySnapshot(s: LightSnapshot)
	Lighting.ColorShift_Top = s.ColorShift_Top
	Lighting.FogColor       = s.FogColor
	Lighting.FogStart       = s.FogStart
	Lighting.FogEnd         = s.FogEnd
	Lighting.Brightness     = s.Brightness
end

-- ── Zone test ───────────────────────────────────────────────────────────────
local function pointInZone(pos: Vector3, zone: BasePart): boolean
	local rel = zone.CFrame:PointToObjectSpace(pos)
	local half = zone.Size * 0.5
	return math.abs(rel.X) <= half.X
	   and math.abs(rel.Y) <= half.Y
	   and math.abs(rel.Z) <= half.Z
end

local function findZone(): BasePart?
	local root = workspace:FindFirstChild(ZONES_ROOT_NAME)
	if root then
		local z = root:FindFirstChild(ZONE_NAME)
		if z and z:IsA("BasePart") then return z end
	end
	-- Backward-compat: also accept the zone directly under workspace.
	local direct = workspace:FindFirstChild(ZONE_NAME)
	if direct and direct:IsA("BasePart") then return direct end
	return nil
end

-- ── State ───────────────────────────────────────────────────────────────────
local baseline: LightSnapshot = snapshot()
local inZone   = false
local lerpStart: number? = nil
local fromSnap: LightSnapshot = baseline
local toSnap:   LightSnapshot = baseline

local function setTarget(target: LightSnapshot)
	fromSnap   = snapshot()
	toSnap     = target
	lerpStart  = os.clock()
end

-- ── Main loop ───────────────────────────────────────────────────────────────
local lastCheck = 0

RunService.Heartbeat:Connect(function()
	local now = os.clock()

	-- Drive the lerp every frame for smoothness
	if lerpStart then
		local t = (now - lerpStart) / LERP_DURATION
		if t >= 1 then
			applySnapshot(toSnap)
			lerpStart = nil
		else
			applySnapshot(lerpSnapshot(fromSnap, toSnap, t))
		end
	end

	-- Throttled zone check
	if now - lastCheck < CHECK_INTERVAL then return end
	lastCheck = now

	local zone = findZone()
	if not zone then return end

	local char = Players.LocalPlayer.Character
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local nowInZone = pointInZone(hrp.Position, zone)
	if nowInZone ~= inZone then
		inZone = nowInZone
		setTarget(inZone and PIZZA_PRESET or baseline)
	end
end)

-- Re-capture baseline isn't needed (Lighting persists); nothing to refresh on respawn.
