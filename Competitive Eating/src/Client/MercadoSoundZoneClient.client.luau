-- MercadoSoundZoneClient: listen to workspace.MercadoSoundZones, attach Sounds
-- on enter, lerp Volume up on enter / down on exit. Sounds are parented to
-- the LocalPlayer's PlayerGui (so they live with the session, not the
-- character — won't get nuked on respawn) and stay loaded across re-entries
-- to avoid the 200-300 ms first-play stall.
--
-- Architectural mirror of DonutSoundZoneClient: simple AABB point-in-box
-- (no rotation), throttled at 0.20s, 0.9s lerp on enter/exit. Independent
-- from the Donut/Tokyo systems — own zone root, own PlayerGui sound folder.
--
-- All retune levers live in DISTRICT_LAYERS / MICRO_LAYERS below; sound IDs,
-- per-layer volume, and pitch are all swappable in one place. SoundIds were
-- hand-curated from the known-safe DonutSoundZoneClient + TokyoSoundZoneClient
-- pools (those IDs have been verified loadable in this place via
-- ContentProvider:PreloadAsync). The Mercado theme is mariachi guitar +
-- Spanish market chatter + festival drum, re-using the same audio palette at
-- different pitch / volume for distinct district feel.

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local CHECK_INTERVAL = 0.20  -- s — small micro-zones cadence (mirrors Donut)
local FADE_DURATION  = 0.9   -- s — both fade-in (on enter) and fade-out (on exit)

local ZONES_ROOT_NAME    = "MercadoSoundZones"
local SOUNDS_FOLDER_NAME = "MercadoAmbientSounds"

-- ── Sound config ────────────────────────────────────────────────────────────
-- Looped ambient layers. The "District" layer plays anywhere in Mercado del
-- Sol; the per-building layers stack on top when the player enters a micro-
-- zone. Audio IDs are picked from the known-working Donut/Tokyo palette to
-- avoid the new audio-distribution policy block on older free SFX.
type LayerConfig = {
	name:       string,    -- zone Part name in workspace.MercadoSoundZones
	soundId:    string,    -- rbxassetid://…
	volume:     number,    -- peak volume when fully inside the zone
	pitch:      number?,   -- optional pitch / PlaybackSpeed
}

local DISTRICT_LAYERS: { LayerConfig } = {
	-- Warm mariachi guitar bed (Tokyo's 9125401391 hum re-pitched up for
	-- the brighter Latin-guitar feel). Distinct from Donut's pitch-0.9 by
	-- coming in pitch 1.15 so the two districts feel different.
	{ name = "District", soundId = "rbxassetid://9125401391", volume = 0.09, pitch = 1.15 },
	-- Distant Spanish market chatter — re-uses Tokyo's crowd chatter bed
	-- but quieter so it sits under the guitar.
	{ name = "District", soundId = "rbxassetid://9046219584", volume = 0.10 },
}

local MICRO_LAYERS: { LayerConfig } = {
	-- TaqueriaElSol — sizzling griddle (sizzle bed pitched down) + tortilla press tick.
	{ name = "TaqueriaElSol",    soundId = "rbxassetid://9125402735", volume = 0.14, pitch = 1.15 }, -- griddle sizzle bed
	{ name = "TaqueriaElSol",    soundId = "rbxassetid://418460422",  volume = 0.16, pitch = 0.95 }, -- tortilla press knock

	-- BurritoCasa — kitchen clatter (utensil tick) + warm steam hum.
	{ name = "BurritoCasa",      soundId = "rbxassetid://5786458588", volume = 0.16 },               -- utensil clatter
	{ name = "BurritoCasa",      soundId = "rbxassetid://9125402735", volume = 0.10, pitch = 0.9 },  -- warm kitchen steam

	-- QuesadillaStand — flat-top grill hiss + small tap from tortilla turn.
	{ name = "QuesadillaStand",  soundId = "rbxassetid://9125402735", volume = 0.13, pitch = 1.25 }, -- grill hiss
	{ name = "QuesadillaStand",  soundId = "rbxassetid://418460422",  volume = 0.10, pitch = 1.1 },  -- tortilla flip tap

	-- EloteTruck — order-call chatter (re-uses crowd chatter, brighter pitch)
	-- + soft steam off the corn.
	{ name = "EloteTruck",       soundId = "rbxassetid://9046219584", volume = 0.18, pitch = 1.1 },  -- order calls
	{ name = "EloteTruck",       soundId = "rbxassetid://9125402735", volume = 0.08, pitch = 1.3 },  -- corn steam

	-- CantinaStainedGlass — late-evening mariachi room tone + faint glass clink.
	{ name = "CantinaStainedGlass", soundId = "rbxassetid://9125401391", volume = 0.14, pitch = 0.95 }, -- slow guitar bed
	{ name = "CantinaStainedGlass", soundId = "rbxassetid://6890470776", volume = 0.10, pitch = 0.9 },  -- glass clink

	-- MariachiBandstand — louder guitar + festival-drum thump (taiko pulse pitched up).
	{ name = "MariachiBandstand", soundId = "rbxassetid://9125401391", volume = 0.22, pitch = 1.2 },   -- bright guitar
	{ name = "MariachiBandstand", soundId = "rbxassetid://2538528232", volume = 0.16, pitch = 1.15 },  -- festival drum
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
