local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config           = require(game.ReplicatedStorage.Common.Config)
local DataManager      = require(script.Parent.DataManager)
local CaveManager      = require(script.Parent.CaveManager)
local AuraSystem       = require(script.Parent.AuraSystem)
local MushroomManager  = require(script.Parent.MushroomManager)
local WeatherState     = require(script.Parent.WeatherState)
local MyceliumPulse    = require(script.Parent.MyceliumPulse)
local MutationHook     = require(script.Parent.MutationHook)
local AnalyticsManager = require(script.Parent.AnalyticsManager)
local DeathManager     = require(script.Parent.DeathManager)
local VatManager       = require(script.Parent.VatManager)
local PlotManager      = require(script.Parent.PlotManager)
local MobManager       = require(script.Parent.MobManager)

-- activeEvent mirrors into WeatherState so other modules can read it without circular deps
local activeEvent = nil   -- { name, endsAt }

local Remotes          = ReplicatedStorage:WaitForChild("Remotes")
local UpdateSpores     = Remotes:WaitForChild("UpdateSpores")
local WeatherChanged   = Remotes:WaitForChild("WeatherChanged")  -- reused for cave events
local MutationOccurred = Remotes:WaitForChild("MutationOccurred")
local SyncData         = Remotes:WaitForChild("SyncData")
local ShowcaseUpdated  = Remotes:WaitForChild("ShowcaseUpdated")
local CaveEventActive  = Remotes:WaitForChild("CaveEventActive") -- fires to client on Spring

-- ─── SPORES/SEC ───────────────────────────────────────────────────────────────
-- Cave events no longer multiply base production; they have specific side effects.

local function getSporesPerSec(player: Player, data: table): number
	local prodMult     = Config.getProductionMultiplier(data.upgrades.Fertilizer, data.upgrades.Lighting)
	local prestigeMult = Config.PRESTIGE_MULTIPLIERS[data.prestigeLevel] or 1
	local auraBoosts   = AuraSystem.getBoosts(player)

	local total = 0
	for _, id in ipairs(data.ownedSpecies) do
		local species = Config.SPECIES_BY_ID[id]
		if not species then continue end

		local mutCount = data.mutations[id] or 0
		local mutBonus = mutCount > 0
			and Config.MUTATION_MULTIPLIERS[species.tier] ^ mutCount
			or 1

		local auraBonus  = auraBoosts[id] or 1
		total += species.sporesPerSec * mutBonus * auraBonus
	end

	local pulseMult = MyceliumPulse.getBoost(player)
	local vipMult   = data.isVIP      and Config.VIP_PASSIVE_MULT or 1
	local passMult  = data.owns2xPass and 2 or 1
	local vatMult   = VatManager.getProductionMult(player)
	return total * prodMult * prestigeMult * pulseMult * vipMult * passMult * vatMult * 0.10
end

-- ─── MUTATION TRIGGER ────────────────────────────────────────────────────────

local function isMutationEvent(name: string): boolean
	for _, n in ipairs(Config.MUTATION_TRIGGER_EVENTS) do
		if n == name then return true end
	end
	return false
end

local function tryMutation(player: Player, data: table, event: table)
	if not isMutationEvent(event.name) then return end

	local chance = Config.getMutationChance(data.upgrades.Humidity or 0)
	if math.random() > chance then return end

	-- Bloom triples all mutation tier weights
	local bloomMult  = (event.name == "Bioluminescent Bloom")
		and Config.BLOOM_MUTATION_WEIGHT_MULT or 1

	local candidates, totalWeight = {}, 0
	for _, id in ipairs(data.ownedSpecies) do
		local sp = Config.SPECIES_BY_ID[id]
		if sp and (data.mutations[id] or 0) < Config.MAX_MUTATIONS_PER_SPECIES then
			local w = (Config.MUTATION_TIER_WEIGHTS[sp.tier] or 1) * bloomMult
			table.insert(candidates, { id = id, weight = w })
			totalWeight += w
		end
	end
	if #candidates == 0 then return end

	local roll   = math.random() * totalWeight
	local chosen = candidates[#candidates]
	for _, c in ipairs(candidates) do
		roll -= c.weight
		if roll <= 0 then chosen = c; break end
	end

	data.mutations[chosen.id] = (data.mutations[chosen.id] or 0) + 1
	DataManager.save(player)

	local newCount = data.mutations[chosen.id]
	MutationHook.fire(player)
	MutationOccurred:FireClient(player, chosen.id, newCount)
	SyncData:FireClient(player, data)

	MushroomManager.updateVisuals(player, chosen.id, newCount)
	AuraSystem.update(player, data)

	CaveManager.update(player, data)
	ShowcaseUpdated:FireAllClients(CaveManager.getAll())
end

-- ─── MAIN TICK ───────────────────────────────────────────────────────────────

task.spawn(function()
	while true do
		task.wait(Config.TICK_RATE)

		-- Expire active event
		if activeEvent and os.time() >= activeEvent.endsAt then
			local expired     = activeEvent
			activeEvent       = nil
			WeatherState.current      = nil
			WeatherState.currentEvent = nil
			WeatherState.surgeActive  = false
			WeatherChanged:FireAllClients(nil)

			if expired.name == "Bioluminescent Bloom" then
				MobManager.despawnGroup("cave_bloom")
				for _, player in ipairs(Players:GetPlayers()) do
					local data = DataManager.get(player)
					if data then task.spawn(tryMutation, player, data, expired) end
				end
			elseif expired.name == "Underground Spring" then
				MobManager.despawnGroup("cave_spring")
			end
		end

		-- Accumulate spores
		for _, player in ipairs(Players:GetPlayers()) do
			local data = DataManager.get(player)
			if not data then continue end

			local sps    = getSporesPerSec(player, data)
			local earned = math.floor(sps * Config.TICK_RATE)
			earned       = DeathManager.applyDebtPenalty(player, earned)
			data.spores              += earned
			data.lifetimeSpores      += earned
			data.offlineEarningsRate  = sps
			if data.lifetimeSpores > (data.peakSpores or 0) then
				data.peakSpores = data.lifetimeSpores
			end

			UpdateSpores:FireClient(player, data.spores, data.lifetimeSpores, sps)
		end
	end
end)

-- ─── CAVE EVENT SCHEDULER ─────────────────────────────────────────────────────

task.spawn(function()
	while true do
		task.wait(math.random(Config.CAVE_EVENT_MIN_INTERVAL, Config.CAVE_EVENT_MAX_INTERVAL))

		-- Weighted random selection
		local totalWeight = 0
		for _, e in ipairs(Config.CAVE_EVENTS) do totalWeight += e.weight end

		local roll   = math.random() * totalWeight
		local chosen = Config.CAVE_EVENTS[1]
		for _, e in ipairs(Config.CAVE_EVENTS) do
			roll -= e.weight
			if roll <= 0 then chosen = e; break end
		end

		local endsAt = os.time() + Config.CAVE_EVENT_DURATION
		activeEvent  = { name = chosen.name, endsAt = endsAt }

		-- Mirror into shared WeatherState (SporeOrbManager reads .current/.surgeActive)
		WeatherState.currentEvent = chosen.name
		WeatherState.current      = { name = chosen.name, affectsTiers = {}, endsAt = endsAt }

		-- Per-event server-side effects
		if chosen.name == "Mycelium Surge" then
			WeatherState.surgeActive = true      -- SporeOrbManager doubles spawn density

		elseif chosen.name == "Underground Spring" then
			CaveEventActive:FireAllClients(chosen.name)  -- client highlights MoleHoles
			-- MoleFishing halves bite timer by checking WeatherState.currentEvent
			-- Spawn cave leeches near each player's tunnel
			for _, player in ipairs(Players:GetPlayers()) do
				local plot = PlotManager.getPlot(player)
				if not plot then continue end
				local spots = PlotManager.getRootSpots(plot)
				if #spots == 0 then continue end
				local tunnelPos = spots[1].Position + Vector3.new(0, 2, -15)
				MobManager.spawnMob("cave_leech", tunnelPos, nil, "cave_spring")
			end

		elseif chosen.name == "Bioluminescent Bloom" then
			-- Spawn spore beetles near each player's mushroom plots
			for _, player in ipairs(Players:GetPlayers()) do
				local plot = PlotManager.getPlot(player)
				if not plot then continue end
				local spots = PlotManager.getRootSpots(plot)
				if #spots == 0 then continue end
				local center = spots[math.ceil(#spots / 2)].Position
				for _ = 1, 2 do
					local offset = Vector3.new(math.random(-8, 8), 2, math.random(-4, 4))
					MobManager.spawnMob("spore_beetle", center + offset, nil, "cave_bloom")
				end
			end
		end
		-- Bioluminescent Bloom: 3× mutation weight also applied in tryMutation when event ends

		WeatherChanged:FireAllClients(activeEvent)
		for _, player in ipairs(Players:GetPlayers()) do
			AnalyticsManager.onCaveEvent(player, chosen.name)
		end
	end
end)
