-- TokyoSoundZoneClient: listen to workspace.TokyoSoundZones, attach Sounds
-- on enter, lerp Volume up on enter / down on exit. Sounds are parented to
-- the LocalPlayer's PlayerGui (so they live with the session, not the
-- character — won't get nuked on respawn) and stay loaded across re-entries
-- to avoid the 200-300 ms first-play stall.
--
-- Zones are simple AABBs (axis-aligned, since the spawner sets no rotation).
-- Per-frame work is just a couple of vector compares against ≤5 boxes —
-- cheaper than a Region3 query.
--
-- Architectural mirror of TokyoAtmosphereClient: throttled point-in-box
-- check, smooth lerp every Heartbeat. Cleanup on PlayerRemoving handled
-- implicitly (PlayerGui dies with the player).

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local CHECK_INTERVAL = 0.20  -- s — slightly tighter than atmosphere because
                             -- micro-zones are smaller and you can sprint through one
local FADE_DURATION  = 0.9   -- s — both fade-in (on enter) and fade-out (on exit)

local ZONES_ROOT_NAME = "TokyoSoundZones"

-- ── Sound config ────────────────────────────────────────────────────────────
-- Looped ambient layers. The "district" layer plays anywhere in Tokyo Town;
-- the per-building layers stack on top when the player enters a micro-zone.
-- Asset IDs are public Roblox-uploaded loops; if any feel wrong on playtest,
-- swap the SoundId here — the rest of the system needs no changes.
type LayerConfig = {
	name:       string,    -- zone Part name in workspace.TokyoSoundZones
	soundId:    string,    -- rbxassetid://…
	volume:     number,    -- peak volume when fully inside the zone
	pitch:      number?,   -- optional pitch / PlaybackSpeed
	rollOffDistance: number?,
}

local DISTRICT_LAYERS: { LayerConfig } = {
	-- Tokyo street bed: crowd chatter + faint taiko + neon hum, all looping.
	-- Three quiet stacked loops feel "alive" without one obvious melody.
	{ name = "District", soundId = "rbxassetid://9046219584", volume = 0.18 },                -- crowd chatter bed
	{ name = "District", soundId = "rbxassetid://2538528232", volume = 0.08, pitch = 0.85 },  -- distant taiko pulse
	{ name = "District", soundId = "rbxassetid://9125402735", volume = 0.06 },                -- neon / electric hum
}

local MICRO_LAYERS: { LayerConfig } = {
	-- DaikonRamen / SushiDaiko: slurp + chopstick clink + sizzle
	{ name = "DaikonRamen",    soundId = "rbxassetid://5786458588", volume = 0.22 },               -- chopstick / utensil tick
	{ name = "DaikonRamen",    soundId = "rbxassetid://3199934562", volume = 0.18, pitch = 0.9 },  -- soft slurp / pop
	{ name = "SushiDaiko",     soundId = "rbxassetid://418460422",  volume = 0.20 },               -- knock / cutting board tap
	{ name = "SushiDaiko",     soundId = "rbxassetid://5786458588", volume = 0.18, pitch = 1.1 },  -- chopstick clink
	-- IzakayaLantern: muted laughter + sake pour + glass clink
	{ name = "IzakayaLantern", soundId = "rbxassetid://9046219584", volume = 0.26 },               -- crowd / laughter bed (louder than district)
	{ name = "IzakayaLantern", soundId = "rbxassetid://6890470776", volume = 0.14 },               -- light glass clink
	-- TakoyakiCart: oil sizzle + spatula tap
	{ name = "TakoyakiCart",   soundId = "rbxassetid://418460422",  volume = 0.20, pitch = 1.3 },  -- spatula tap (knock pitched up)
	{ name = "TakoyakiCart",   soundId = "rbxassetid://9125402735", volume = 0.16, pitch = 1.2 },  -- sizzle bed
}

-- ── State ───────────────────────────────────────────────────────────────────
type LayerState = {
	cfg:        LayerConfig,
	sound:      Sound,
	currentVol: number,   -- last applied volume (drives fade lerp)
	targetVol:  number,   -- where we're heading (0 outside zone, cfg.volume inside)
	fadeFrom:   number,
	fadeStart:  number?,  -- nil when no fade in flight
}

local layerStates: { LayerState } = {}
local zoneActive: { [string]: boolean } = {}  -- zone name -> currently inside

-- ── Setup ───────────────────────────────────────────────────────────────────
local function soundsParent(): Instance
	-- Parent under PlayerGui so the sound container persists across respawns
	-- (PlayerGui lives with the Player, not the Character).
	local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
	local holder = pg:FindFirstChild("TokyoAmbientSounds")
	if not holder then
		holder = Instance.new("Folder")
		holder.Name = "TokyoAmbientSounds"
		holder.Parent = pg
	end
	return holder
end

local function buildLayer(cfg: LayerConfig, parent: Instance): LayerState
	local s = Instance.new("Sound")
	s.Name        = cfg.name .. "_" .. cfg.soundId:match("(%d+)$")
	s.SoundId     = cfg.soundId
	s.Looped      = true
	s.Volume      = 0
	s.PlaybackSpeed = cfg.pitch or 1
	s.RollOffMode = Enum.RollOffMode.Linear
	s.Parent      = parent
	-- Pre-play silent so re-entering a zone is instant (no decode stall).
	s:Play()
	return {
		cfg = cfg,
		sound = s,
		currentVol = 0,
		targetVol  = 0,
		fadeFrom   = 0,
		fadeStart  = nil,
	}
end

local function initLayers()
	-- Idempotent: rebuild if we lost PlayerGui to a respawn edge case.
	for _, st in layerStates do st.sound:Destroy() end
	table.clear(layerStates)
	local parent = soundsParent()
	for _, cfg in DISTRICT_LAYERS do table.insert(layerStates, buildLayer(cfg, parent)) end
	for _, cfg in MICRO_LAYERS    do table.insert(layerStates, buildLayer(cfg, parent)) end
end

-- ── Zone test ───────────────────────────────────────────────────────────────
local function pointInZone(pos: Vector3, zone: BasePart): boolean
	local rel = zone.CFrame:PointToObjectSpace(pos)
	local half = zone.Size * 0.5
	return math.abs(rel.X) <= half.X
	   and math.abs(rel.Y) <= half.Y
	   and math.abs(rel.Z) <= half.Z
end

local function findZonesRoot(): Folder?
	local r = workspace:FindFirstChild(ZONES_ROOT_NAME)
	return r and r:IsA("Folder") and r or nil
end

-- ── Fade driver ─────────────────────────────────────────────────────────────
local function setTarget(st: LayerState, target: number)
	if math.abs(target - st.targetVol) < 1e-4 and st.fadeStart == nil then return end
	st.fadeFrom  = st.currentVol
	st.targetVol = target
	st.fadeStart = os.clock()
end

local function tickFades(now: number)
	for _, st in layerStates do
		if st.fadeStart then
			local t = (now - st.fadeStart) / FADE_DURATION
			if t >= 1 then
				st.currentVol = st.targetVol
				st.fadeStart  = nil
			else
				st.currentVol = st.fadeFrom + (st.targetVol - st.fadeFrom) * t
			end
			st.sound.Volume = st.currentVol
		end
	end
end

-- ── Main loop ───────────────────────────────────────────────────────────────
initLayers()

local lastCheck = 0
local cachedZones: { [string]: BasePart } = {}
local lastZonesRoot: Folder? = nil

RunService.Heartbeat:Connect(function()
	local now = os.clock()
	tickFades(now)

	if now - lastCheck < CHECK_INTERVAL then return end
	lastCheck = now

	local root = findZonesRoot()
	if not root then
		-- Server hasn't spawned zones yet (or AssetSpawner is mid-respawn).
		-- Drop all layers to silence; resume when zones reappear.
		for name in zoneActive do zoneActive[name] = false end
		for _, st in layerStates do setTarget(st, 0) end
		cachedZones = {}
		lastZonesRoot = nil
		return
	end

	-- Re-cache zone Parts if the root was recreated.
	if root ~= lastZonesRoot then
		cachedZones = {}
		for _, z in root:GetChildren() do
			if z:IsA("BasePart") then cachedZones[z.Name] = z end
		end
		lastZonesRoot = root
	end

	local char = Players.LocalPlayer.Character
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		for name in zoneActive do
			if zoneActive[name] then zoneActive[name] = false end
		end
		for _, st in layerStates do setTarget(st, 0) end
		return
	end

	local pos = hrp.Position

	-- Update zone occupancy (only flip targets on edges to avoid retriggering fades each tick).
	for name, zone in cachedZones do
		local inside = pointInZone(pos, zone)
		if inside ~= zoneActive[name] then
			zoneActive[name] = inside
			for _, st in layerStates do
				if st.cfg.name == name then
					setTarget(st, inside and st.cfg.volume or 0)
				end
			end
		end
	end
end)

-- Rebuild sound holders on respawn — PlayerGui survives, but if anything
-- nukes the folder externally we want to recover gracefully.
Players.LocalPlayer.CharacterAdded:Connect(function()
	local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
	if pg and not pg:FindFirstChild("TokyoAmbientSounds") then
		initLayers()
		-- Re-target any zones we believe we're in.
		for name, inside in zoneActive do
			if inside then
				for _, st in layerStates do
					if st.cfg.name == name then setTarget(st, st.cfg.volume) end
				end
			end
		end
	end
end)
