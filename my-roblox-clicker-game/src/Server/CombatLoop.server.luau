-- CombatLoop.server.luau
-- Boots CombatManager (wires PlayerAttack remote) and runs the mob aggro scan loop.
-- Mobs in range attack the nearest player every MOB_ATTACK_COOLDOWN seconds.

local Players       = game:GetService("Players")
local Config        = require(game.ReplicatedStorage.Common.Config)
local CombatManager = require(script.Parent.CombatManager)
local MobManager    = require(script.Parent.MobManager)

local MOB_ATTACK_COOLDOWN = 3  -- seconds between mob attacks per player per mob
local lastMobAttack = {}       -- [userId .. mobId] = os.time()

Players.PlayerRemoving:Connect(function(player)
	local prefix = tostring(player.UserId)
	for key in pairs(lastMobAttack) do
		if key:sub(1, #prefix) == prefix then
			lastMobAttack[key] = nil
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(2)

		local mobIds = MobManager.getActiveMobIds()
		for _, mobId in ipairs(mobIds) do
			local mobPart = MobManager.getMob(mobId)
			if not mobPart or not mobPart.Parent then continue end

			for _, player in ipairs(Players:GetPlayers()) do
				local char = player.Character
				if not char then continue end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if not hrp then continue end

				local dist = (mobPart.Position - hrp.Position).Magnitude
				if dist <= Config.MOB_AGGRO_RADIUS then
					local key  = tostring(player.UserId) .. mobId
					local last = lastMobAttack[key] or 0
					if os.time() - last >= MOB_ATTACK_COOLDOWN then
						lastMobAttack[key] = os.time()
						task.spawn(CombatManager.mobAttack, mobId, player)
					end
				end
			end
		end
	end
end)
