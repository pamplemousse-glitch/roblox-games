-- BbqSoundZoneClient: listen to workspace.BbqSoundZones, attach Sounds on
-- enter, lerp Volume up on enter / down on exit. Sounds parented to the
-- LocalPlayer's PlayerGui (so they survive respawn) and stay loaded across
-- re-entries to avoid the 200-300 ms first-play stall.
--
-- Architectural mirror of DonutSoundZoneClient / TokyoSoundZoneClient:
-- simple AABB point-in-box, throttled at 0.20s, 0.9s lerp on enter/exit.
-- Independent of the Tokyo / Donut systems — own zone root, own PlayerGui
-- sound folder.
--
-- Sound IDs are hand-curated from the Tokyo + Donut known-safe pools
-- (these IDs are already verified loadable in this experience via
-- ContentProvider:PreloadAsync). They're re-used at different pitch /
-- volume to evoke a country-bluegrass + crackling-fire + cicada bed.

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local CHECK_INTERVAL = 0.20
local FADE_DURATION  = 0.9

local ZONES_ROOT_NAME    = "BbqSoundZones"
local SOUNDS_FOLDER_NAME = "BbqAmbientSounds"

-- ── Sound config ────────────────────────────────────────────────────────────
type LayerConfig = {
	name:       string,
	soundId:    string,
	volume:     number,
	pitch:      number?,
}

-- District bed: low warm hum (distant cow / open holler), a low pulsed
-- pluck (slow banjo / front-porch jam), and a faint cicada chirp.
local DISTRICT_LAYERS: { LayerConfig } = {
	{ name = "District", soundId = "rbxassetid://9125401391", volume = 0.08, pitch = 0.7  }, -- warm low hum (distant cow lowing)
	{ name = "District", soundId = "rbxassetid://2865227271", volume = 0.05, pitch = 0.65 }, -- slow plucked banjo-ish chime
	{ name = "District", soundId = "rbxassetid://5786458588", volume = 0.04, pitch = 1.4  }, -- faint cicada chirp tick
}

local MICRO_LAYERS: { LayerConfig } = {
	-- SmokehouseSmokyJoes — oak smoke crackle + low fire hum.
	{ name = "SmokehouseSmokyJoes", soundId = "rbxassetid://9125402735", volume = 0.18, pitch = 0.7 },  -- low smoker hum
	{ name = "SmokehouseSmokyJoes", soundId = "rbxassetid://3199934562", volume = 0.12, pitch = 1.2 },  -- crackle pop
	-- RibShack — gritty crowd murmur + grill sizzle.
	{ name = "RibShack",            soundId = "rbxassetid://9046219584", volume = 0.18 },                -- crowd murmur bed
	{ name = "RibShack",            soundId = "rbxassetid://9125402735", volume = 0.14, pitch = 1.25 }, -- grill sizzle
	-- BrisketBarn — slow deep fire bed + slow chime.
	{ name = "BrisketBarn",         soundId = "rbxassetid://9125402735", volume = 0.14, pitch = 0.6 },  -- slow deep fire
	{ name = "BrisketBarn",         soundId = "rbxassetid://2865227271", volume = 0.08, pitch = 0.75 }, -- slow chime
	-- PitBossBBQTruck — diesel idle + grill sizzle, pitched to feel like a truck.
	{ name = "PitBossBBQTruck",     soundId = "rbxassetid://9125401391", volume = 0.16, pitch = 0.5 },  -- diesel idle hum
	{ name = "PitBossBBQTruck",     soundId = "rbxassetid://9125402735", volume = 0.12, pitch = 1.1 },  -- grill sizzle
	-- HayBarn — louder cicadas + wood creak.
	{ name = "HayBarn",             soundId = "rbxassetid://5786458588", volume = 0.18, pitch = 1.6 },  -- cicada chirp louder
	{ name = "HayBarn",             soundId = "rbxassetid://418460422",  volume = 0.10, pitch = 0.7 },  -- slow wood creak / knock
	-- GiantPigStatue — banjo pluck stinger + breeze hum.
	{ name = "GiantPigStatue",      soundId = "rbxassetid://2865227271", volume = 0.16, pitch = 0.85 }, -- banjo pluck
	{ name = "GiantPigStatue",      soundId = "rbxassetid://9125401391", volume = 0.07, pitch = 0.9 },  -- soft breeze hum
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
