-- BbqAtmosphereClient: when the local player enters the BbqAtmosphereZone
-- workspace Part, lerp Lighting toward a smoky golden-hour preset (warm
-- sunset ColorShift_Top, hazy gray-tan FogColor, FogStart/FogEnd pushed
-- in to feel like smoke layered along the holler). On exit, lerp back to
-- the captured baseline.
--
-- Mirrors DonutAtmosphereClient's snapshot / lerp / throttled-zone-check
-- architecture, but operates on Lighting properties (not on the
-- Atmosphere child) so the BBQ smoky-fog preset coexists cleanly with
-- Donut/Tokyo's Atmosphere-property presets without fighting them.

local Lighting   = game:GetService("Lighting")
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local ZONE_NAME       = "BbqAtmosphereZone"
local CHECK_INTERVAL  = 0.25
local LERP_DURATION   = 1.5   -- per playbook: ~1.5s fade

-- ── Lighting presets ────────────────────────────────────────────────────────
type LightSnapshot = {
	ColorShift_Top: Color3,
	FogColor:       Color3,
	FogStart:       number,
	FogEnd:         number,
	Brightness:     number,
}

-- BBQ Holler: smoky golden hour. ColorShift_Top is a warm sunset, FogColor
-- a hazy gray-tan, FogStart/End pulled in so the smoke reads close. Higher
-- Brightness keeps the golden hour feeling sunlit, not washed out.
local BBQ_PRESET: LightSnapshot = {
	ColorShift_Top = Color3.fromRGB(255, 160,  80),
	FogColor       = Color3.fromRGB(210, 195, 170),
	FogStart       = 120,
	FogEnd         = 520,
	Brightness     = 2.3,
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

-- ── State ───────────────────────────────────────────────────────────────────
local baseline = snapshot()
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

	local zone = workspace:FindFirstChild(ZONE_NAME)
	if not zone or not zone:IsA("BasePart") then return end

	local char = Players.LocalPlayer.Character
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local nowInZone = pointInZone(hrp.Position, zone)
	if nowInZone ~= inZone then
		inZone = nowInZone
		setTarget(inZone and BBQ_PRESET or baseline)
	end
end)
