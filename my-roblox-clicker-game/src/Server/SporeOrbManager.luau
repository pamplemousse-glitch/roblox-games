-- SporeOrbManager: spawns collectible spore orbs near each mushroom.
-- Orbs drift upward and despawn after ORB_LIFETIME seconds.
-- Walking through an orb grants bonus spores (≈5× that species' passive rate).
-- During weather events, orb values scale with the event multiplier.
-- Collection is server-authoritative via Touched — no client trust needed.
-- Uses Janitor for safe cleanup of connections + despawn timers per orb.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local Packages     = ReplicatedStorage:WaitForChild("Packages")
local Janitor      = require(Packages:WaitForChild("Janitor"))

local Config       = require(game.ReplicatedStorage.Common.Config)
local DataManager  = require(script.Parent.DataManager)
local PlotManager  = require(script.Parent.PlotManager)
local WeatherState = require(script.Parent.WeatherState)

local SporeOrbManager = {}

-- ─── CONSTANTS ────────────────────────────────────────────────────────────────

local ORB_DIAMETER       = 1.4   -- studs
local ORB_SPAWN_DIST     = 3.5   -- max horizontal offset from mushroom root
local ORB_MAX_PER_SHROOM = 1     -- max live orbs per mushroom model at once
local ORB_PLOT_CAP       = 10    -- max total orbs in any one plot
local ORB_INTERVAL       = 10    -- seconds between spawn ticks per player
local ORB_LIFETIME       = 20    -- seconds before uncollected orb auto-despawns
local ORB_RISE           = 5     -- studs the orb floats upward over its lifetime
local ORB_VALUE_MUL      = 5     -- orb worth = species.sporesPerSec * this

local TIER_COLOR = {
	Common   = Color3.fromRGB(180, 255, 190),
	Uncommon = Color3.fromRGB(90,  255, 140),
	Rare     = Color3.fromRGB(90,  140, 255),
	Epic     = Color3.fromRGB(210,  90, 255),
	Mythic   = Color3.fromRGB(255, 210,  40),
}

-- ─── STATE ────────────────────────────────────────────────────────────────────

-- playerLoops[userId] = true while the loop is running; nil to stop it
local playerLoops: { [number]: boolean } = {}

-- Callback table fired when any orb is collected.
-- Register with: SporeOrbManager.addOrbCallback(fn)
-- Legacy single-slot kept for backwards compat: SporeOrbManager.onOrbCollected
SporeOrbManager.onOrbCollected          = nil  -- legacy (MyceliumPulseLoop uses this)
SporeOrbManager.onOrbCollectedCallbacks = {}   -- multi-callback table

function SporeOrbManager.addOrbCallback(fn: (player: Player, value: number) -> ())
	table.insert(SporeOrbManager.onOrbCollectedCallbacks, fn)
end

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function countOrbs(plot: Folder, speciesId: string?): number
	local n = 0
	for _, child in ipairs(plot:GetChildren()) do
		if child:IsA("Part") and child.Name == "SporeOrb" then
			if not speciesId or child:GetAttribute("SpeciesId") == speciesId then
				n += 1
			end
		end
	end
	return n
end

local function findModel(plot: Folder, speciesId: string): Model?
	for _, child in ipairs(plot:GetChildren()) do
		if child:IsA("Model") and child:GetAttribute("SpeciesId") == speciesId then
			return child
		end
	end
	return nil
end

local function weatherMultiplierForTier(tier: string): number
	local w = WeatherState.current
	if not w or not w.affectsTiers then return 1 end
	for _, t in ipairs(w.affectsTiers) do
		if t == tier then return w.multiplier end
	end
	return 1
end

-- ─── SPAWN ONE ORB ───────────────────────────────────────────────────────────

local Remotes      = ReplicatedStorage:WaitForChild("Remotes")
local OrbCollected = Remotes:WaitForChild("OrbCollected")

local function spawnOrb(player: Player, plot: Folder, speciesId: string)
	local model = findModel(plot, speciesId)
	if not model then return end
	local root = model.PrimaryPart or model:FindFirstChild("Root")
	if not root then return end

	local species = Config.SPECIES_BY_ID[speciesId]
	if not species then return end

	local weatherMul = weatherMultiplierForTier(species.tier)
	local value      = math.max(1, math.floor(species.sporesPerSec * ORB_VALUE_MUL * weatherMul))
	local color      = TIER_COLOR[species.tier] or Color3.fromRGB(180, 255, 180)

	local angle    = math.random() * math.pi * 2
	local dist     = 1.2 + math.random() * ORB_SPAWN_DIST
	local spawnPos = root.Position + Vector3.new(
		math.cos(angle) * dist, 1.2, math.sin(angle) * dist
	)

	-- ── Build orb Part ────────────────────────────────────────────────────────
	local orb        = Instance.new("Part")
	orb.Name         = "SporeOrb"
	orb.Shape        = Enum.PartType.Ball
	orb.Size         = Vector3.new(ORB_DIAMETER, ORB_DIAMETER, ORB_DIAMETER)
	orb.Position     = spawnPos
	orb.Anchored     = true
	orb.CanCollide   = false
	orb.CastShadow   = false
	orb.Material     = Enum.Material.Neon
	orb.Color        = color
	orb:SetAttribute("SpeciesId", speciesId)
	orb:SetAttribute("OrbValue",  value)
	orb:SetAttribute("OwnerId",   player.UserId)
	orb.Parent = plot

	-- Glow particle
	local pe         = Instance.new("ParticleEmitter")
	pe.Color         = ColorSequence.new(color)
	pe.Size          = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(1, 0),
	})
	pe.Lifetime      = NumberRange.new(0.5, 1.2)
	pe.Rate          = 10
	pe.SpreadAngle   = Vector2.new(180, 180)
	pe.LightEmission = 0.8
	pe.Parent        = orb

	local light      = Instance.new("PointLight")
	light.Brightness = 1.4; light.Range = 9; light.Color = color
	light.Parent     = orb

	-- Float upward
	TweenService:Create(
		orb,
		TweenInfo.new(ORB_LIFETIME, Enum.EasingStyle.Linear),
		{ Position = spawnPos + Vector3.new(0, ORB_RISE, 0) }
	):Play()

	-- Pulse scale
	local function pulse()
		if not orb.Parent then return end
		local big = Vector3.new(ORB_DIAMETER * 1.18, ORB_DIAMETER * 1.18, ORB_DIAMETER * 1.18)
		local sml = Vector3.new(ORB_DIAMETER * 0.88, ORB_DIAMETER * 0.88, ORB_DIAMETER * 0.88)
		TweenService:Create(orb, TweenInfo.new(0.7, Enum.EasingStyle.Sine), { Size = big }):Play()
		task.delay(0.7, function()
			if not orb.Parent then return end
			TweenService:Create(orb, TweenInfo.new(0.7, Enum.EasingStyle.Sine), { Size = sml }):Play()
			task.delay(0.7, pulse)
		end)
	end
	pulse()

	-- ── ProximityPrompt (keyboard/gamepad) ───────────────────────────────────
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText            = "Collect"
	prompt.ObjectText            = "+" .. value .. " Spores"
	prompt.MaxActivationDistance = 8
	prompt.HoldDuration          = 0
	prompt.RequiresLineOfSight   = false
	prompt.Parent                = orb

	-- ── Janitor: manages orb lifetime and connection cleanup ──────────────────
	local j         = Janitor.new()
	local collected = false
	j:add(orb,    "Destroy")
	j:add(prompt, "Destroy")

	local function collect(p: Player)
		if collected or not orb.Parent then return end
		if p.UserId ~= player.UserId then return end
		collected = true

		local data = DataManager.get(player)
		if data then
			data.spores         += value
			data.lifetimeSpores += value
			-- Phase 9: Gain ingredient on orb collect
			data.ingredients = data.ingredients or {}
			data.ingredients[speciesId] = (data.ingredients[speciesId] or 0) + 1
		end

		OrbCollected:FireClient(player, orb.Position, color, value)

		if SporeOrbManager.onOrbCollected then
			task.spawn(SporeOrbManager.onOrbCollected, player)
		end
		for _, fn in ipairs(SporeOrbManager.onOrbCollectedCallbacks) do
			task.spawn(fn, player, value)
		end

		j:destroy()
	end

	-- ProximityPrompt: "E to collect" on approach
	j:add(prompt.Triggered:Connect(collect), "Disconnect")

	-- Touched: walk-through collection (mobile / gamepad movement)
	j:add(orb.Touched:Connect(function(hit)
		local p = Players:GetPlayerFromCharacter(hit.Parent)
		if p then collect(p) end
	end), "Disconnect")

	-- Auto-despawn after lifetime
	j:add(task.delay(ORB_LIFETIME, function() j:destroy() end), true)
end

-- ─── PER-PLAYER SPAWN LOOP ───────────────────────────────────────────────────

function SporeOrbManager.startForPlayer(player: Player)
	local userId = player.UserId
	if playerLoops[userId] then return end
	playerLoops[userId] = true

	task.spawn(function()
		task.wait(math.random() * ORB_INTERVAL)  -- stagger start

		while playerLoops[userId] do
			local data = DataManager.get(player)
			local plot = PlotManager.getPlot(player)

			if data and plot and countOrbs(plot) < ORB_PLOT_CAP then
				-- Mycelium Surge doubles orb density by allowing 2 orbs per species
				local maxPerShroom = WeatherState.surgeActive and 2 or ORB_MAX_PER_SHROOM
				for _, speciesId in ipairs(data.ownedSpecies) do
					if countOrbs(plot) >= ORB_PLOT_CAP then break end
					if countOrbs(plot, speciesId) < maxPerShroom then
						spawnOrb(player, plot, speciesId)
					end
				end
			end

			task.wait(ORB_INTERVAL)
		end
	end)
end

function SporeOrbManager.stopForPlayer(player: Player)
	playerLoops[player.UserId] = nil
end

return SporeOrbManager
