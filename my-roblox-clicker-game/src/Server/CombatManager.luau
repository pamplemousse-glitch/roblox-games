-- CombatManager.luau
-- Handles player attacks on mobs and mob attacks on players.
-- Validates weapon range, cooldowns, and mob ownership.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config       = require(game.ReplicatedStorage.Common.Config)
local DataManager  = require(script.Parent.DataManager)
local MobManager   = require(script.Parent.MobManager)
local DeathManager = require(script.Parent.DeathManager)

local CombatManager = {}

-- ─── STATE ────────────────────────────────────────────────────────────────────

local combatCooldowns = {}  -- [userId .. weaponId] = lastFiredAt (os.clock())
local activeDots      = {}  -- [mobId] = { tickDamage, ticksLeft, player, token }

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function getWeaponConfig(weaponId: string): table?
	for _, w in ipairs(Config.WEAPONS) do
		if w.id == weaponId then return w end
	end
	return nil
end

local function getPlayerPosition(player: Player): Vector3?
	local char = player.Character
	if not char then return nil end
	local hrp  = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end
	return hrp.Position
end

local function applyDot(mobId: string, tickDamage: number, duration: number, player: Player)
	local token = {}  -- unique reference; old loops bail when this changes
	activeDots[mobId] = { tickDamage = tickDamage, ticksLeft = math.ceil(duration), player = player, token = token }
	task.spawn(function()
		while true do
			task.wait(1)
			local dot = activeDots[mobId]
			if not dot or dot.token ~= token then break end

			local dotDrops = MobManager.damageMob(mobId, dot.tickDamage, dot.player)
			dot.ticksLeft -= 1

			if dotDrops or dot.ticksLeft <= 0 then
				if activeDots[mobId] and activeDots[mobId].token == token then
					activeDots[mobId] = nil
				end
				if dotDrops then
					local data = DataManager.get(dot.player)
					if data and dotDrops.spores and dotDrops.spores > 0 then
						data.spores         += dotDrops.spores
						data.lifetimeSpores += dotDrops.spores
						data.mobKills        = (data.mobKills or 0) + 1
						DataManager.save(dot.player)
					end
				end
				break
			end
		end
	end)
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

-- Player attacks a mob. Validates weapon, range, cooldown.
-- Returns drops table if mob killed, nil otherwise.
function CombatManager.playerAttack(player: Player, weaponId: string, targetMobId: string): table?
	local weaponCfg = getWeaponConfig(weaponId)
	if not weaponCfg then return nil end

	-- Ownership check (server-authoritative — client cannot spoof a weapon they don't own)
	local data = DataManager.get(player)
	if not data then return nil end
	local hasWeapon = false
	for _, w in ipairs(data.weapons or {}) do
		if w == weaponId then hasWeapon = true; break end
	end
	if not hasWeapon then return nil end

	-- Cooldown check
	local cooldownKey = player.UserId .. weaponId
	local lastFired   = combatCooldowns[cooldownKey] or 0
	if os.clock() - lastFired < weaponCfg.cooldown then return nil end
	combatCooldowns[cooldownKey] = os.clock()

	-- Range check
	local mobPart = MobManager.getMob(targetMobId)
	if not mobPart then return nil end

	local playerPos = getPlayerPosition(player)
	if not playerPos then return nil end

	local dist = (mobPart.Position - playerPos).Magnitude
	if dist > weaponCfg.range then return nil end

	-- Apply damage
	local drops = MobManager.damageMob(targetMobId, weaponCfg.damage, player)
	if drops then
		-- Mob killed: cancel any running DOT and grant drops
		activeDots[targetMobId] = nil
		if drops.spores and drops.spores > 0 then
			data.spores         += drops.spores
			data.lifetimeSpores += drops.spores
			data.mobKills        = (data.mobKills or 0) + 1
			-- Unlock Flyagaric Flask at 10 kills
			if data.mobKills == 10 then
				local hasFlask = false
				for _, w in ipairs(data.weapons or {}) do
					if w == "flyagaric_flask" then hasFlask = true; break end
				end
				if not hasFlask then
					table.insert(data.weapons, "flyagaric_flask")
					local Remotes2    = ReplicatedStorage:FindFirstChild("Remotes")
					local LootGranted = Remotes2 and Remotes2:FindFirstChild("LootGranted")
					if LootGranted then
						LootGranted:FireClient(player, { label = "Flyagaric Flask unlocked!", spores = 0 })
					end
				end
			end
			DataManager.save(player)
		end
	elseif weaponCfg.isDot then
		applyDot(targetMobId, weaponCfg.dotTickDamage, weaponCfg.dotDuration, player)
	end

	return drops
end

-- Mob attacks a player. Applies HP damage and triggers death if HP <= 0.
function CombatManager.mobAttack(mobId: string, player: Player)
	local data = DataManager.get(player)
	if not data then return end

	-- Get mob config for damage value
	local mobPart = MobManager.getMob(mobId)
	if not mobPart then return end
	local mobTypeId = mobPart:GetAttribute("MobType") or ""

	local damage = 10  -- default
	for _, mt in ipairs(Config.MOB_TYPES) do
		if mt.id == mobTypeId then damage = mt.damage; break end
	end

	data.playerHP = math.max(0, (data.playerHP or Config.PLAYER_MAX_HP) - damage)

	local Remotes   = ReplicatedStorage:FindFirstChild("Remotes")
	local HPUpdate  = Remotes and Remotes:FindFirstChild("HPUpdate")
	if HPUpdate then
		HPUpdate:FireClient(player, data.playerHP, data.maxPlayerHP or Config.PLAYER_MAX_HP)
	end

	-- Mob attack sound (spatial at mob position) + player hurt sound (personal)
	local MobSound = Remotes and Remotes:FindFirstChild("MobSound")
	if MobSound and mobPart then
		MobSound:FireAllClients(mobTypeId, "attack", mobPart.Position)
	end

	if data.playerHP <= 0 then
		DeathManager.onPlayerDied(player)
	end
end

-- Wire the PlayerAttack remote
local function wireAttackRemote()
	local Remotes      = ReplicatedStorage:WaitForChild("Remotes")
	local PlayerAttack = Remotes:WaitForChild("PlayerAttack")

	PlayerAttack.OnServerEvent:Connect(function(player: Player, weaponId: unknown, targetMobId: unknown)
		if type(weaponId)    ~= "string" then return end
		if type(targetMobId) ~= "string" then return end
		CombatManager.playerAttack(player, weaponId, targetMobId)
	end)
end

task.spawn(wireAttackRemote)

return CombatManager
