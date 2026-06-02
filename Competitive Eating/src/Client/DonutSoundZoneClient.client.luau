-- DonutSoundZoneClient: listen to workspace.DonutSoundZones, attach Sounds
-- on enter, lerp Volume up on enter / down on exit. Sounds are parented to
-- the LocalPlayer's PlayerGui (so they live with the session, not the
-- character — won't get nuked on respawn) and stay loaded across re-entries
-- to avoid the 200-300 ms first-play stall.
--
-- Architectural mirror of TokyoSoundZoneClient: simple AABB point-in-box
-- (no rotation), throttled at 0.20s, 0.9s lerp on enter/exit. Independent
-- from the Tokyo system — own zone root, own PlayerGui sound folder.
--
-- All retune levers live in DISTRICT_LAYERS / MICRO_LAYERS below; sound IDs,
-- per-layer volume, and pitch are all swappable in one place.

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local CHECK_INTERVAL = 0.20  -- s — same cadence as Tokyo (small micro-zones)
local FADE_DURATION  = 0.9   -- s — both fade-in (on enter) and fade-out (on exit)

local ZONES_ROOT_NAME    = "DonutSoundZones"
local SOUNDS_FOLDER_NAME = "DonutAmbientSounds"

-- ── Sound config ────────────────────────────────────────────────────────────
-- Looped ambient layers. The "District" layer plays anywhere in Donut Dynasty;
-- the per-building layers stack on top when the player enters a micro-zone.
-- Audio IDs verified loadable in this place via ContentProvider:PreloadAsync
-- (most older free SFX no longer pass the new audio-distribution policy, so
-- the palette is intentionally small — re-used at different pitch/volume
-- per zone). To retune, swap the SoundId here — nothing else needs to change.
type LayerConfig = {
	name:       string,    -- zone Part name in workspace.DonutSoundZones
	soundId:    string,    -- rbxassetid://…
	volume:     number,    -- peak volume when fully inside the zone
	pitch:      number?,   -- optional pitch / PlaybackSpeed
}

local DISTRICT_LAYERS: { LayerConfig } = {
	-- Warm cozy bakery bed. Distinct hum from Tokyo's 9125402735 (uses the
	-- neighbor 9125401391 instead) so the two districts feel different even
	-- where the palette overlaps. Kept quiet — this is wallpaper, not music.
	{ name = "District", soundId = "rbxassetid://9125401391", volume = 0.07, pitch = 0.9 },
}

local MICRO_LAYERS: { LayerConfig } = {
	-- DonutShop (V1) — bakery door bell + low oven hum.
	{ name = "DonutShop",         soundId = "rbxassetid://9112854440", volume = 0.14 },              -- bakery bell loop
	{ name = "DonutShop",         soundId = "rbxassetid://9125402735", volume = 0.10, pitch = 0.8 }, -- warm oven hum

	-- SweetheartDonuts (V2) — same bakery palette, slightly brighter bell.
	{ name = "SweetheartDonuts",  soundId = "rbxassetid://9112854440", volume = 0.14, pitch = 1.05 },-- bakery bell loop, brighter
	{ name = "SweetheartDonuts",  soundId = "rbxassetid://9125402735", volume = 0.10, pitch = 0.85 },-- warm oven hum

	-- GlazeFountain V1 — soft icing chime + faint trickle bed.
	{ name = "GlazeFountainV1",   soundId = "rbxassetid://2865227271", volume = 0.16, pitch = 0.95 },-- soft chime
	{ name = "GlazeFountainV1",   soundId = "rbxassetid://9125401391", volume = 0.06, pitch = 1.05 },-- gentle trickle bed

	-- GlazeFountain V2 — same palette, chime up a touch for the V2 sparkle.
	{ name = "GlazeFountainV2",   soundId = "rbxassetid://2865227271", volume = 0.16, pitch = 1.1 }, -- soft chime, brighter
	{ name = "GlazeFountainV2",   soundId = "rbxassetid://9125401391", volume = 0.06, pitch = 1.0 }, -- gentle trickle bed

	-- CoffeeKiosk (V1) — espresso steam hiss (hum pitched up) + faint cup tick.
	{ name = "CoffeeKiosk",       soundId = "rbxassetid://9125402735", volume = 0.12, pitch = 1.25 },-- espresso steam
	{ name = "CoffeeKiosk",       soundId = "rbxassetid://9112854440", volume = 0.04, pitch = 0.7 }, -- distant cup clink

	-- HotChocolateStand (V2) — same steam palette, a notch softer (it's a cart).
	{ name = "HotChocolateStand", soundId = "rbxassetid://9125402735", volume = 0.10, pitch = 1.35 },-- hot chocolate steam
	{ name = "HotChocolateStand", soundId = "rbxassetid://9112854440", volume = 0.04, pitch = 0.75 },-- distant cup clink
}

-- ── State ───────────────────────────────────────────────────────────────────
type LayerState = {
	cfg:        LayerConfig,
	sound:      Sound,
	currentVol: number,
	targetVol:  number,
	fadeFrom:   number,
	fadeStart:  number?,
}

local layerStates: { LayerState } = {}
local zoneActive: { [string]: boolean } = {}

-- ── Setup ───────────────────────────────────────────────────────────────────
local function soundsParent(): Instance
	-- PlayerGui survives respawns; PlayerScripts don't run UI but do parent
	-- cleanly. Keeps the sound graph independent from any Tokyo folder.
	local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
	local holder = pg:FindFirstChild(SOUNDS_FOLDER_NAME)
	if not holder then
		holder = Instance.new("Folder")
		holder.Name = SOUNDS_FOLDER_NAME
		holder.Parent = pg
	end
	return holder
end

local function buildLayer(cfg: LayerConfig, parent: Instance): LayerState
	local s = Instance.new("Sound")
	s.Name          = cfg.name .. "_" .. cfg.soundId:match("(%d+)$")
	s.SoundId       = cfg.soundId
	s.Looped        = true
	s.Volume        = 0
	s.PlaybackSpeed = cfg.pitch or 1
	s.RollOffMode   = Enum.RollOffMode.Linear
	s.Parent        = parent
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
		for name in zoneActive do zoneActive[name] = false end
		for _, st in layerStates do setTarget(st, 0) end
		cachedZones = {}
		lastZonesRoot = nil
		return
	end

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
	if pg and not pg:FindFirstChild(SOUNDS_FOLDER_NAME) then
		initLayers()
		for name, inside in zoneActive do
			if inside then
				for _, st in layerStates do
					if st.cfg.name == name then setTarget(st, st.cfg.volume) end
				end
			end
		end
	end
end)
