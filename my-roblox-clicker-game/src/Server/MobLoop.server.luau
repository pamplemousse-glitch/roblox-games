-- MobLoop.server.luau
-- Manages mob spawning in The Deep on a timer.

local Workspace = game:GetService("Workspace")

local Config     = require(game.ReplicatedStorage.Common.Config)
local MobManager = require(script.Parent.MobManager)

local MAX_DEEP_MOBS = 6

-- ─── GET SPAWN MARKERS ───────────────────────────────────────────────────────

local function getSpawnMarkers(): { BasePart }
	local markers = {}
	local theDeep = Workspace:FindFirstChild("TheDeep")
	if not theDeep then return markers end

	for _, obj in ipairs(theDeep:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name:match("^MobSpawn_") then
			table.insert(markers, obj)
		end
	end
	return markers
end

local function getRandomMobType(): string
	local types = Config.MOB_TYPES
	return types[math.random(1, #types)].id
end

-- ─── INITIAL SPAWN ───────────────────────────────────────────────────────────

task.spawn(function()
	task.wait(6)  -- wait for world to load

	local markers = getSpawnMarkers()
	if #markers == 0 then
		warn("[MobLoop] No MobSpawn_ markers found in TheDeep — add them via execute_luau")
		return
	end

	-- Spawn 3 initial mobs
	local spawned = 0
	for i = 1, math.min(3, #markers) do
		local marker   = markers[i]
		local mobTypeId = getRandomMobType()
		local mobId    = MobManager.spawnMob(mobTypeId, marker.Position + Vector3.new(0, 2, 0))
		if mobId ~= "" then spawned += 1 end
	end

	-- Ongoing spawn loop
	while true do
		task.wait(Config.MOB_SPAWN_INTERVAL)

		if MobManager.getActiveMobCount() < MAX_DEEP_MOBS then
			local currentMarkers = getSpawnMarkers()
			if #currentMarkers > 0 then
				local marker    = currentMarkers[math.random(1, #currentMarkers)]
				local mobTypeId = getRandomMobType()
				MobManager.spawnMob(mobTypeId, marker.Position + Vector3.new(0, 2, 0))
			end
		end
	end
end)
