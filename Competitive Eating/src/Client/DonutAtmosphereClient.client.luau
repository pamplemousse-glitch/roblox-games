-- DonutAtmosphereClient: when the local player enters the DonutAtmosphereZone
-- workspace Part, lerp Lighting.Atmosphere to a brighter, sweeter, candy-pink
-- tint. When the player leaves, lerp back to the captured baseline.
-- Atmosphere is a single global instance in Roblox, so we mutate it on the
-- client only — this gives the per-district feel without globally
-- desaturating the other zones.
--
-- Direct mirror of TokyoAtmosphereClient.client.luau — same lerp loop, same
-- throttled zone check, same baseline-capture-on-startup pattern. Only the
-- preset values differ. Two presets can coexist (Tokyo + Donut) because each
-- client script captures its own snapshot on startup and lerps against it.

local Lighting   = game:GetService("Lighting")
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local ZONE_NAME       = "DonutAtmosphereZone"
local CHECK_INTERVAL  = 0.25  -- seconds between zone checks
local LERP_DURATION   = 1.2   -- seconds to fade in/out

-- ── Atmosphere presets ──────────────────────────────────────────────────────
type AtmoSnapshot = {
	Density: number,
	Offset:  number,
	Color:   Color3,
	Decay:   Color3,
	Glare:   number,
	Haze:    number,
}

-- Donut Dynasty: clean candy-bright sky. Lower density than Tokyo (~0.18 vs
-- 0.40), pinker Color so distant rooftops pick up a sugar-pink hue, higher
-- Glare for the sunlit-frosting sparkle, low Haze so silhouettes stay crisp.
local DONUT_PRESET: AtmoSnapshot = {
	Density = 0.18,
	Offset  = 0.0,
	Color   = Color3.fromRGB(255, 220, 230),
	Decay   = Color3.fromRGB(190, 160, 175),
	Glare   = 0.45,
	Haze    = 0.6,
}

local function ensureAtmosphere(): Atmosphere
	local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
	if not atmo then
		atmo = Instance.new("Atmosphere")
		atmo.Parent = Lighting
	end
	return atmo
end

local function snapshot(atmo: Atmosphere): AtmoSnapshot
	return {
		Density = atmo.Density,
		Offset  = atmo.Offset,
		Color   = atmo.Color,
		Decay   = atmo.Decay,
		Glare   = atmo.Glare,
		Haze    = atmo.Haze,
	}
end

local function lerpColor(a: Color3, b: Color3, t: number): Color3
	return Color3.new(
		a.R + (b.R - a.R) * t,
		a.G + (b.G - a.G) * t,
		a.B + (b.B - a.B) * t
	)
end

local function lerpSnapshot(a: AtmoSnapshot, b: AtmoSnapshot, t: number): AtmoSnapshot
	return {
		Density = a.Density + (b.Density - a.Density) * t,
		Offset  = a.Offset  + (b.Offset  - a.Offset)  * t,
		Color   = lerpColor(a.Color, b.Color, t),
		Decay   = lerpColor(a.Decay, b.Decay, t),
		Glare   = a.Glare + (b.Glare - a.Glare) * t,
		Haze    = a.Haze  + (b.Haze  - a.Haze)  * t,
	}
end

local function applySnapshot(atmo: Atmosphere, s: AtmoSnapshot)
	atmo.Density = s.Density
	atmo.Offset  = s.Offset
	atmo.Color   = s.Color
	atmo.Decay   = s.Decay
	atmo.Glare   = s.Glare
	atmo.Haze    = s.Haze
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
local atmo     = ensureAtmosphere()
local baseline = snapshot(atmo)
local inZone   = false
local lerpStart: number? = nil
local fromSnap: AtmoSnapshot = baseline
local toSnap:   AtmoSnapshot = baseline

local function setTarget(target: AtmoSnapshot)
	fromSnap   = snapshot(atmo)
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
			applySnapshot(atmo, toSnap)
			lerpStart = nil
		else
			applySnapshot(atmo, lerpSnapshot(fromSnap, toSnap, t))
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
		setTarget(inZone and DONUT_PRESET or baseline)
	end
end)

-- Re-capture baseline if the zone Part is recreated by a re-spawn
Players.LocalPlayer.CharacterAdded:Connect(function()
	atmo = ensureAtmosphere()
end)
