-- SoundClient.client.luau
-- All game audio: per-mob spatial sounds, player feedback, cave ambience, event loops.
-- Swap any ID in the tables below to change a sound — nothing else needs touching.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local SoundService      = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Remotes     = ReplicatedStorage:WaitForChild("Remotes")
local MobSound    = Remotes:WaitForChild("MobSound")
local HPUpdate    = Remotes:WaitForChild("HPUpdate")
local WeatherChanged = Remotes:WaitForChild("WeatherChanged")
local ZoneChanged    = Remotes:WaitForChild("ZoneChanged")

-- ─── SOUND ID CONFIG ─────────────────────────────────────────────────────────
-- { soundId, playbackSpeed }
-- All IDs are free Roblox audio library assets.

local MOB_SOUNDS = {
	cave_beetle = {
		spawn  = { 3703294979, 1.0 },  -- Night Insect Sounds   (skittery legs)
		attack = { 6204856270, 0.9 },  -- Crunch Sound          (mandible bite)
		hit    = { 6204856270, 1.2 },  -- Crunch (higher pitch) (shell crack)
		death  = { 8574340260, 0.8 },  -- Squish Sound          (crunch + collapse)
	},
	blind_fish = {
		spawn  = { 142431247,  1.0 },  -- Water Splash Sound    (wet flop)
		attack = { 242076158,  1.2 },  -- Snap                  (quick bite)
		hit    = { 7137631084, 0.9 },  -- Splash Water          (wet thud)
		death  = { 5930519356, 1.0 },  -- Water Splash Effect   (plop into water)
	},
	shadow_spore = {
		spawn  = { 624706518,  0.65 }, -- Whoosh (pitched down = darker entrance)
		attack = { 5032279145, 1.0 },  -- Monster Screech       (eerie shriek)
		hit    = { 2235655773, 1.0 },  -- Swoosh                (deflection)
		death  = { 3823529284, 1.0 },  -- Ghost "ooOOoo"        (spirit dissipates)
	},
	spore_beetle = {
		spawn  = { 510393264,  1.2 },  -- Flies Buzzing         (organic hum on arrival)
		attack = { 9113414329, 1.0 },  -- Bee Buzzing Actions   (stinger strike)
		hit    = { 6204856270, 1.6 },  -- Crunch (high pitch)   (lighter shell crack)
		death  = { 4607031412, 1.3 },  -- Pop Sound Effect      (spore burst)
	},
	cave_leech = {
		spawn  = { 7479635359, 0.8 },  -- Squishy Sounds        (wet slither)
		attack = { 8574340260, 0.7 },  -- Squish Sound          (suction snap)
		hit    = { 1540443426, 0.9 },  -- Splat Sound           (wet squish)
		death  = { 4607031412, 0.65 }, -- Pop Sound Effect      (slow wet pop)
	},
}

-- Event ambient loops  { soundId, playbackSpeed }
local EVENT_SOUNDS = {
	["Mycelium Surge"]       = { 8907104314, 1.0 },  -- Warden HeartBeat     (deep cave pulse)
	["Underground Spring"]   = { 2705020461, 1.0 },  -- Cave Ambience        (water flow loop)
	["Bioluminescent Bloom"] = { 1844266547, 1.0 },  -- Fairy Magic          (ethereal shimmer)
}

local CAVE_AMBIENT_ID   = 4764746601   -- Cave Water Sound FX  (always-on background drip)
local PLAYER_HURT_ID    = 7267875088   -- Damage Sound Effect
local PLAYER_DEATH_ID   = 5113982587   -- Death Audio

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function playSpatial(soundId: number, position: Vector3, speed: number, volume: number?)
	local part = Instance.new("Part")
	part.Anchored     = true
	part.CanCollide   = false
	part.Transparency = 1
	part.Size         = Vector3.new(1, 1, 1)
	part.Position     = position
	part.Parent       = workspace

	local s = Instance.new("Sound")
	s.SoundId            = "rbxassetid://" .. soundId
	s.PlaybackSpeed      = speed
	s.Volume             = volume or 0.75
	s.RollOffMaxDistance = 80
	s.Parent             = part
	s:Play()

	task.delay(math.max(s.TimeLength, 0.5) + 0.5, function()
		part:Destroy()
	end)
end

local function play2D(soundId: number, speed: number, volume: number?)
	local s = Instance.new("Sound")
	s.SoundId       = "rbxassetid://" .. soundId
	s.PlaybackSpeed = speed
	s.Volume        = volume or 0.75
	s.Parent        = SoundService
	s:Play()
	task.delay(math.max(s.TimeLength, 0.5) + 0.5, function()
		s:Destroy()
	end)
end

-- ─── CAVE AMBIENT (always on) ────────────────────────────────────────────────

local caveAmbient = Instance.new("Sound")
caveAmbient.SoundId       = "rbxassetid://" .. CAVE_AMBIENT_ID
caveAmbient.Looped        = true
caveAmbient.Volume        = 0.3
caveAmbient.PlaybackSpeed = 1.0
caveAmbient.Parent        = SoundService
caveAmbient:Play()

-- ─── CAVE EVENT LOOPS ────────────────────────────────────────────────────────

local eventLoop: Sound? = nil

local function stopEventLoop()
	if eventLoop then
		eventLoop:Stop()
		eventLoop:Destroy()
		eventLoop = nil
	end
end

WeatherChanged.OnClientEvent:Connect(function(event)
	stopEventLoop()
	if not event then return end
	local cfg = EVENT_SOUNDS[event.name or event]
	if not cfg then return end
	local s = Instance.new("Sound")
	s.SoundId       = "rbxassetid://" .. cfg[1]
	s.PlaybackSpeed = cfg[2]
	s.Volume        = 0.45
	s.Looped        = true
	s.Parent        = SoundService
	s:Play()
	eventLoop = s
end)

-- ─── MOB SOUNDS (3D spatial) ─────────────────────────────────────────────────

MobSound.OnClientEvent:Connect(function(mobType: string, soundType: string, position: Vector3)
	local mob = MOB_SOUNDS[mobType]
	if not mob then return end
	local cfg = mob[soundType]
	if not cfg then return end
	playSpatial(cfg[1], position, cfg[2])
end)

-- ─── PLAYER FEEDBACK ─────────────────────────────────────────────────────────

local lastHP = 100

HPUpdate.OnClientEvent:Connect(function(hp: number, _maxHp: number)
	if hp < lastHP then
		if hp <= 0 then
			play2D(PLAYER_DEATH_ID, 1.0, 0.9)
		else
			play2D(PLAYER_HURT_ID, 1.0, 0.6)
		end
	end
	lastHP = hp
end)

LocalPlayer.CharacterAdded:Connect(function()
	lastHP = 100
end)

-- ─── DEEP ZONE MUSIC ─────────────────────────────────────────────────────────
-- Position-based sub-zone music for The Deep (TheDeep is centered at z=-400).
-- One music track plays at a time; crossfades when sub-zone changes.

local DEEP_MUSIC = {
	-- Sub-zone id → { soundId, volume }
	water_grotto      = { 76563295380575, 0.35 },  -- Water Grotto (far back)
	bat_colony        = { 9112775175,     0.35 },  -- Bat Colony   (left)
	glowworm_ceiling  = { 9046865270,     0.35 },  -- Glowworm     (right)
	crystal_formation = { 1842660840,     0.35 },  -- Crystals     (center, far)
	central_spine     = { 139743346356072,0.30 },  -- Entrance corridor
}

local function getDeepSubZone(pos: Vector3): string
	if pos.Z < -540 then return "water_grotto" end
	if pos.X < -55  then return "bat_colony" end
	if pos.X >  55  then return "glowworm_ceiling" end
	if pos.Z < -460 then return "crystal_formation" end
	return "central_spine"
end

local zoneMusic: Sound? = nil
local currentZone: string = ""
local inTheDeep = false

local function stopZoneMusic()
	if zoneMusic then
		zoneMusic:Stop(); zoneMusic:Destroy(); zoneMusic = nil
	end
	currentZone = ""
end

local function playZoneMusic(subZoneId: string)
	if subZoneId == currentZone then return end
	stopZoneMusic()
	currentZone = subZoneId
	local cfg = DEEP_MUSIC[subZoneId]
	if not cfg then return end
	local s = Instance.new("Sound")
	s.SoundId       = "rbxassetid://" .. cfg[1]
	s.Volume        = cfg[2]
	s.Looped        = true
	s.PlaybackSpeed = 1.0
	s.Parent        = SoundService
	s:Play()
	zoneMusic = s
end

ZoneChanged.OnClientEvent:Connect(function(zoneName: string)
	if zoneName == "TheDeep" then
		inTheDeep = true
	else
		inTheDeep = false
		stopZoneMusic()
	end
end)

-- Poll position every 3 seconds while in TheDeep to pick sub-zone track
task.spawn(function()
	while true do
		task.wait(3)
		if not inTheDeep then continue end
		local char = LocalPlayer.Character
		if not char then continue end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then continue end
		playZoneMusic(getDeepSubZone(hrp.Position))
	end
end)
