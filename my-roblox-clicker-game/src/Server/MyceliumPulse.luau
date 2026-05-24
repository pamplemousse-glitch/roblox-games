-- MyceliumPulse: cooperative network bonus.
-- When PULSE_PLAYER_THRESHOLD or more players have collected orbs
-- within the last PULSE_ACTIVITY_WINDOW seconds, the Mycelium Network
-- goes "active" and pulses every PULSE_INTERVAL seconds, giving all
-- active players +PULSE_BOOST spores/sec for PULSE_DURATION seconds.
--
-- SporeOrbManager calls MyceliumPulse.recordActivity(player) on each collect.
-- SporeLoop reads MyceliumPulse.getBoost(player) each tick.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

local Config = require(game.ReplicatedStorage.Common.Config)

local MyceliumPulse = {}

-- ─── STATE ────────────────────────────────────────────────────────────────────

-- lastActivity[userId] = os.time() of most recent orb collect
local lastActivity: { [number]: number } = {}

-- boostUntil[userId] = os.time() when current pulse boost expires (0 = no boost)
local boostUntil: { [number]: number } = {}

-- ─── ACTIVITY TRACKING ────────────────────────────────────────────────────────

function MyceliumPulse.recordActivity(player: Player)
	lastActivity[player.UserId] = os.time()
end

local function getActiveCount(): number
	local threshold = os.time() - Config.PULSE_ACTIVITY_WINDOW
	local count = 0
	for _, player in ipairs(Players:GetPlayers()) do
		local t = lastActivity[player.UserId] or 0
		if t >= threshold then
			count += 1
		end
	end
	return count
end

-- ─── BOOST QUERY (called by SporeLoop each tick) ──────────────────────────────

function MyceliumPulse.getBoost(player: Player): number
	local until_ = boostUntil[player.UserId] or 0
	if os.time() < until_ then
		return 1 + Config.PULSE_BOOST
	end
	return 1
end

-- ─── PULSE LOOP (started by MyceliumPulseLoop.server.luau) ───────────────────

function MyceliumPulse.startLoop(MyceliumPulseRemote: RemoteEvent)
	task.spawn(function()
		while true do
			task.wait(Config.PULSE_INTERVAL)

			local activeCount = getActiveCount()
			if activeCount >= Config.PULSE_PLAYER_THRESHOLD then
				local expiry = os.time() + Config.PULSE_DURATION

				-- Apply boost to all currently active players
				local threshold = os.time() - Config.PULSE_ACTIVITY_WINDOW
				for _, player in ipairs(Players:GetPlayers()) do
					local t = lastActivity[player.UserId] or 0
					if t >= threshold then
						boostUntil[player.UserId] = expiry
					end
				end

				-- Notify clients (intensity 1.0 = standard pulse)
				MyceliumPulseRemote:FireAllClients(1.0)
			end
		end
	end)
end

-- ─── CLEANUP on player leave ──────────────────────────────────────────────────

Players.PlayerRemoving:Connect(function(player: Player)
	lastActivity[player.UserId] = nil
	boostUntil[player.UserId]   = nil
end)

return MyceliumPulse
