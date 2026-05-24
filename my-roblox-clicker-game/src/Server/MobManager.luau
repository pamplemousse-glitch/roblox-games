-- MobManager.luau
-- Framework for mob spawning and combat in The Deep.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(game.ReplicatedStorage.Common.Config)

local MobManager = {}

local function fireMobSound(mobType: string, soundType: string, position: Vector3)
	local remotes  = ReplicatedStorage:FindFirstChild("Remotes")
	local mobSound = remotes and remotes:FindFirstChild("MobSound")
	if mobSound then mobSound:FireAllClients(mobType, soundType, position) end
end

-- ─── STATE ────────────────────────────────────────────────────────────────────

local activeMobs = {}  -- [mobId] = { part, mobType, hp, maxHp }

local MOB_COLORS = {
	cave_beetle  = Color3.fromRGB(60,  40,  20),
	blind_fish   = Color3.fromRGB(100, 120, 160),
	shadow_spore = Color3.fromRGB(60,  20,  80),
	spore_beetle = Color3.fromRGB(180, 220, 60),
	cave_leech   = Color3.fromRGB(120, 30,  30),
}

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function generateMobId(): string
	return "mob_" .. os.time() .. "_" .. math.random(10000, 99999)
end

local function getMobConfig(mobTypeId: string): table?
	for _, mt in ipairs(Config.MOB_TYPES) do
		if mt.id == mobTypeId then return mt end
	end
	return nil
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

-- Spawns a mob visual (Part) at the given position.
-- parent: optional folder to parent the Part into (defaults to TheDeep).
-- group:  optional string tag for bulk despawn via despawnGroup().
-- Returns mobId string.
function MobManager.spawnMob(mobTypeId: string, position: Vector3, parent: Instance?, group: string?): string
	local mobCfg = getMobConfig(mobTypeId)
	if not mobCfg then return "" end

	local mobId = generateMobId()

	local part        = Instance.new("Part")
	part.Name         = "Mob_" .. mobId
	part.Shape        = Enum.PartType.Ball
	part.Size         = Vector3.new(2, 2, 2)
	part.Position     = position
	part.Anchored     = false
	part.CanCollide   = true
	part.CastShadow   = false
	part.Material     = Enum.Material.Neon
	part.Color        = MOB_COLORS[mobTypeId] or Color3.fromRGB(80, 80, 80)
	part:SetAttribute("MobId",   mobId)
	part:SetAttribute("MobType", mobTypeId)
	part:SetAttribute("HP",      mobCfg.hp)
	part:SetAttribute("MaxHP",   mobCfg.hp)
	if group then part:SetAttribute("MobGroup", group) end

	local theDeep = workspace:FindFirstChild("TheDeep")
	part.Parent = parent or theDeep or workspace

	-- Glow
	local light = Instance.new("PointLight")
	light.Brightness = 0.8
	light.Range      = 8
	light.Color      = MOB_COLORS[mobTypeId] or Color3.fromRGB(80, 80, 80)
	light.Parent     = part

	activeMobs[mobId] = {
		part    = part,
		mobType = mobTypeId,
		hp      = mobCfg.hp,
		maxHp   = mobCfg.hp,
		group   = group,
	}

	fireMobSound(mobTypeId, "spawn", position)
	return mobId
end

-- Destroys all active mobs that belong to the given group tag.
function MobManager.despawnGroup(group: string)
	for id, mob in pairs(activeMobs) do
		if mob.group == group then
			if mob.part and mob.part.Parent then
				mob.part:Destroy()
			end
			activeMobs[id] = nil
		end
	end
end

-- Applies damage to a mob. Returns drops table if killed, nil otherwise.
-- drops = { spores = number }
function MobManager.damageMob(mobId: string, damage: number, player: Player): table?
	local mob = activeMobs[mobId]
	if not mob then return nil end
	if not mob.part or not mob.part.Parent then
		activeMobs[mobId] = nil
		return nil
	end

	mob.hp -= damage
	mob.part:SetAttribute("HP", math.max(0, mob.hp))

	if mob.hp <= 0 then
		-- Killed: compute drops
		local mobCfg = getMobConfig(mob.mobType)
		local drops  = { spores = 0 }

		if mobCfg and mobCfg.drops then
			local sporeDrop = mobCfg.drops.spores
			if sporeDrop then
				drops.spores = math.random(sporeDrop.min, sporeDrop.max)
			end
		end

		local deathPos = mob.part.Position
		mob.part:Destroy()
		activeMobs[mobId] = nil
		fireMobSound(mob.mobType, "death", deathPos)
		return drops
	end

	fireMobSound(mob.mobType, "hit", mob.part.Position)
	return nil
end

-- Returns the mob Part, or nil if dead / not found.
function MobManager.getMob(mobId: string)
	local mob = activeMobs[mobId]
	if not mob then return nil end
	return mob.part
end

-- Returns the HP values (current, max) of a mob, or nil, nil if not found.
function MobManager.getMobHP(mobId: string)
	local mob = activeMobs[mobId]
	if not mob then return nil, nil end
	return mob.hp, mob.maxHp
end

-- Returns count of active mobs.
function MobManager.getActiveMobCount(): number
	local n = 0
	for id, mob in pairs(activeMobs) do
		if mob.part and mob.part.Parent then
			n += 1
		else
			activeMobs[id] = nil  -- clean up stale entries
		end
	end
	return n
end

-- Returns all active mob ids.
function MobManager.getActiveMobIds(): { string }
	local ids = {}
	for id, mob in pairs(activeMobs) do
		if mob.part and mob.part.Parent then
			table.insert(ids, id)
		else
			activeMobs[id] = nil
		end
	end
	return ids
end

return MobManager
