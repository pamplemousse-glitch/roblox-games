-- PizzaSoundZoneClient: listen to workspace.PizzaSoundZones, attach Sounds
-- on enter, lerp Volume up on enter / down on exit. Sounds are parented to
-- the LocalPlayer's PlayerGui (so they live with the session, not the
-- character — won't get nuked on respawn) and stay loaded across re-entries
-- to avoid the 200-300 ms first-play stall.
--
-- Architectural mirror of DonutSoundZoneClient / TokyoSoundZoneClient: AABB
-- point-in-box (no rotation), throttled at 0.20s, 0.9s lerp on enter/exit.
-- Independent system — own zone root, own PlayerGui sound folder.
--
-- Sound palette is hand-curated from IDs already verified loadable in this
-- place by DonutSoundZoneClient + TokyoSoundZoneClient. Re-using the same
-- pool at different pitch/volume keeps the audio policy risk near zero.
-- District bed leans Italian-café: chatter + distant accordion-pulse +
-- warm Vespa-like rumble. Per-building layers re-skin oven hum, fountain
-- trickle, espresso steam, cup clink, etc. to fit each micro-zone's vibe.

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local CHECK_INTERVAL = 0.20  -- s — matches Donut / Tokyo cadence
local FADE_DURATION  = 0.9   -- s — fade-in (on enter) and fade-out (on exit)

local ZONES_ROOT_NAME    = "PizzaSoundZones"
local SOUNDS_FOLDER_NAME = "PizzaAmbientSounds"

-- ── Sound config ────────────────────────────────────────────────────────────
-- All sound IDs are taken from the known-safe pool proven loadable by Donut
-- and Tokyo's clients. To retune, swap the SoundId / pitch / volume here.
type LayerConfig = {
	name:       string,    -- zone Part name in workspace.PizzaSoundZones
	soundId:    string,    -- rbxassetid://…
	volume:     number,    -- peak volume when fully inside the zone
	pitch:      number?,   -- optional pitch / PlaybackSpeed
}

local DISTRICT_LAYERS: { LayerConfig } = {
	-- Café chatter bed (warmer + slightly slower than Tokyo's same bed).
	{ name = "District", soundId = "rbxassetid://9046219584", volume = 0.16, pitch = 0.95 },
	-- Distant accordion-like low pulse (pitched down so it sits under the bed).
	{ name = "District", soundId = "rbxassetid://2538528232", volume = 0.06, pitch = 0.8  },
	-- Faint Vespa rumble / motor-vehicle hum far in the distance.
	{ name = "District", soundId = "rbxassetid://9125402735", volume = 0.05, pitch = 0.85 },
}

local MICRO_LAYERS: { LayerConfig } = {
	-- Tony's Pizzeria — wood-oven roar (warm hum, low pitch) + faint cup clink.
	{ name = "TonysPizzeria",         soundId = "rbxassetid://9125402735", volume = 0.16, pitch = 0.75 }, -- oven roar
	{ name = "TonysPizzeria",         soundId = "rbxassetid://9112854440", volume = 0.06, pitch = 0.9  }, -- doorbell

	-- Mamma Carmela's Trattoria — dinner chatter + utensil clink + simmer.
	{ name = "MammaCarmelasTrattoria", soundId = "rbxassetid://9046219584", volume = 0.20, pitch = 1.05 }, -- patron chatter
	{ name = "MammaCarmelasTrattoria", soundId = "rbxassetid://5786458588", volume = 0.10, pitch = 1.1  }, -- fork / plate clink
	{ name = "MammaCarmelasTrattoria", soundId = "rbxassetid://9125402735", volume = 0.08, pitch = 1.0  }, -- sauce simmer

	-- Vinny's Slice Shop — quick-service: register ding + brighter chatter.
	{ name = "VinnysSliceShop",       soundId = "rbxassetid://9112854440", volume = 0.14, pitch = 1.1  }, -- register / bell
	{ name = "VinnysSliceShop",       soundId = "rbxassetid://9046219584", volume = 0.12, pitch = 1.15 }, -- counter chatter

	-- Romeo's Gelato Stand — bright chime + soft scoop / cup clink.
	{ name = "RomeosGelatoStand",     soundId = "rbxassetid://2865227271", volume = 0.16, pitch = 1.15 }, -- gelato chime
	{ name = "RomeosGelatoStand",     soundId = "rbxassetid://5786458588", volume = 0.06, pitch = 0.95 }, -- scoop tap

	-- Sal's Calzone Cart — sizzle (pitched up) + small crowd murmur.
	{ name = "SalsCalzoneCart",       soundId = "rbxassetid://9125402735", volume = 0.14, pitch = 1.25 }, -- fryer sizzle
	{ name = "SalsCalzoneCart",       soundId = "rbxassetid://9046219584", volume = 0.08, pitch = 1.0  }, -- street murmur

	-- Trevi Fountain — water trickle bed (calm) + tiny coin chime sparkle.
	{ name = "TreviFountain",         soundId = "rbxassetid://9125401391", volume = 0.18, pitch = 1.0  }, -- water trickle
	{ name = "TreviFountain",         soundId = "rbxassetid://2865227271", volume = 0.08, pitch = 1.25 }, -- coin sparkle
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
