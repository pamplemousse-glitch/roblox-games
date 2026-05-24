-- PetLoop.server.luau
-- Handles cricket spawning, SetActivePets remote, and PetState sync on join.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")

local Config      = require(game.ReplicatedStorage.Common.Config)
local DataManager = require(script.Parent.DataManager)
local PetManager  = require(script.Parent.PetManager)

local Remotes        = ReplicatedStorage:WaitForChild("Remotes")
local SetActivePets  = Remotes:WaitForChild("SetActivePets")
local PetState       = Remotes:WaitForChild("PetState")
local PetCaught      = Remotes:WaitForChild("PetCaught")

-- ─── CRICKET SPAWN LOGIC ─────────────────────────────────────────────────────

local playerLoops = {}  -- [userId] = true

-- Find all CricketRock parts in workspace
local function getCricketRocks(): { BasePart }
	local rocks = {}
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name:match("^CricketRock_") then
			table.insert(rocks, obj)
		end
	end
	return rocks
end

-- Activate a ProximityPrompt on a cricket rock for a limited time,
-- then roll catch chance when triggered by the given player.
local function activateCricketRock(rock: BasePart, player: Player)
	-- Don't double-activate
	if rock:FindFirstChildWhichIsA("ProximityPrompt") then return end

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText            = "Catch Cricket"
	prompt.KeyboardKeyCode       = Enum.KeyCode.E
	prompt.MaxActivationDistance = 6
	prompt.HoldDuration          = 0
	prompt.RequiresLineOfSight   = false
	prompt.Parent                = rock

	local despawned = false

	-- Only the target player can catch this cricket
	local conn
	conn = prompt.Triggered:Connect(function(trigPlayer: Player)
		if trigPlayer.UserId ~= player.UserId then return end
		if despawned then return end
		despawned = true
		conn:Disconnect()
		prompt:Destroy()

		if math.random() < Config.CRICKET_CATCH_CHANCE then
			local petId = PetManager.addPet(player, "cricket", "common")
			PetCaught:FireClient(player, petId, "cricket", "common")
			PetState:FireClient(player, PetManager.getOwned(player))
		end
	end)

	-- Auto-despawn
	task.delay(Config.CRICKET_DESPAWN_TIME, function()
		if not despawned then
			despawned = true
			if conn then conn:Disconnect() end
			if prompt and prompt.Parent then prompt:Destroy() end
		end
	end)
end

local function startCricketLoop(player: Player)
	local userId = player.UserId
	playerLoops[userId] = true

	task.spawn(function()
		while playerLoops[userId] do
			local interval = Config.CRICKET_SPAWN_INTERVAL + math.random(-30, 30)
			task.wait(math.max(30, interval))

			if not playerLoops[userId] then break end

			local rocks = getCricketRocks()
			if #rocks == 0 then continue end

			-- Pick a random rock that has no active prompt
			local available = {}
			for _, rock in ipairs(rocks) do
				if not rock:FindFirstChildWhichIsA("ProximityPrompt") then
					table.insert(available, rock)
				end
			end

			if #available > 0 then
				local chosen = available[math.random(1, #available)]
				activateCricketRock(chosen, player)
			end
		end
	end)
end

-- ─── REMOTE HANDLERS ─────────────────────────────────────────────────────────

SetActivePets.OnServerEvent:Connect(function(player: Player, petIds: unknown)
	if type(petIds) ~= "table" then return end

	-- Sanitize input
	local cleanIds = {}
	for _, id in ipairs(petIds) do
		if type(id) == "string" then
			table.insert(cleanIds, id)
		end
	end

	PetManager.setActive(player, cleanIds)
	PetState:FireClient(player, PetManager.getOwned(player))
end)

-- ─── PLAYER LIFECYCLE ────────────────────────────────────────────────────────

Players.PlayerAdded:Connect(function(player: Player)
	-- Wait for data to load
	task.wait(3)
	local data = DataManager.get(player)
	if data then
		PetState:FireClient(player, PetManager.getOwned(player))
	end
	startCricketLoop(player)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	playerLoops[player.UserId] = nil
end)

-- Handle players already in server at script load
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(function()
		startCricketLoop(player)
	end)
end
