-- MercadoAtmosphereClient: when the local player enters the
-- MercadoAtmosphereZone workspace Part, lerp Lighting toward a Marigold-
-- Mexico-sunset preset (warm gold ColorShift_Top, sandy-ochre FogColor,
-- tightened fog band, slightly brighter ambient). When the player leaves,
-- lerp back to the captured baseline. Lighting is a single global instance
-- in Roblox, so we mutate it on the client only — this gives the per-district
-- feel without globally tinting the other zones.
--
-- Direct mirror of DonutAtmosphereClient.client.luau — same lerp loop, same
-- throttled zone check, same baseline-capture-on-startup pattern. Only the
-- preset values and the set of lerped properties differ. Donut/Tokyo lerp
-- Atmosphere; Mercado lerps ColorShift_Top + Fog + Brightness per session
-- brief. All three presets can coexist because each client captures its own
-- snapshot on startup and lerps against it.

local Lighting   = game:GetService("Lighting")
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local CHECK_INTERVAL  = 0.25  -- seconds between zone checks
local LERP_DURATION   = 1.5   -- seconds to fade in/out

-- ── Lighting presets ────────────────────────────────────────────────────────
type LightSnapshot = {
	ColorShift_Top: Color3,
	FogColor:       Color3,
	FogStart:       number,
	FogEnd:         number,
	Brightness:     number,
}

-- Mercado del Sol: Marigold Mexico sunset. Warm gold top tint over sandy
-- ochre fog; FogStart pushed in and FogEnd shortened so distant rooftops
-- gain that late-afternoon haze. Brightness bumped to 2.5 for the
-- sun-soaked plaza feel.
local MERCADO_PRESET: LightSnapshot = {
	ColorShift_Top = Color3.fromRGB(255, 175,  80),
	FogColor       = Color3.fromRGB(240, 215, 175),
	FogStart       = 200,
	FogEnd         = 620,
	Brightness     = 2.5,
}

local ZONES_ROOT_NAME = "MercadoAtmosphereZones"
local ZONE_NAME       = "MercadoAtmosphereZone"

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
	-- Backwards-compat: zone might be parked directly in workspace.
	local direct = workspace:FindFirstChild(ZONE_NAME)
	if direct and direct:IsA("BasePart") then return direct end
	return nil
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

	local zone = findZone()
	if not zone then return end

	local char = Players.LocalPlayer.Character
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local nowInZone = pointInZone(hrp.Position, zone)
	if nowInZone ~= inZone then
		inZone = nowInZone
		setTarget(inZone and MERCADO_PRESET or baseline)
	end
end)

-- Re-capture baseline on respawn (no-op for Lighting properties since they
-- persist across respawns, kept for parity with the Donut/Tokyo modules).
Players.LocalPlayer.CharacterAdded:Connect(function() end)
