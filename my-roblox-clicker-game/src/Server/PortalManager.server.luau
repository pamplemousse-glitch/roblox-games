-- PortalManager — hub ↔ personal cave ↔ The Deep teleportation
-- Reads PortalType attribute on BaseParts to wire touch handlers dynamically.
local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService       = game:GetService("RunService")
local Workspace        = game:GetService("Workspace")

local DataManager  = require(script.Parent.DataManager)
local PlotManager  = require(script.Parent.PlotManager)

-- ── Zone spawn positions ─────────────────────────────────────────────────────
local HUB_SPAWN  = Vector3.new(0,  2, 410)   -- landing point in Hub
local DEEP_SPAWN = Vector3.new(0,  2, -405)  -- landing point in The Deep
local GROTTO_SPAWN = Vector3.new(0, 2, -530) -- landing point inside Water Grotto

-- Seconds before a player can use the same portal again
local PORTAL_COOLDOWN = 3

-- Per-player cooldown table  { [userId] = true|nil }
local onCooldown = {}

-- ── Helpers ──────────────────────────────────────────────────────────────────
local function teleport(player: Player, target: Vector3)
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	onCooldown[player.UserId] = true
	hrp.CFrame = CFrame.new(target)
	task.delay(PORTAL_COOLDOWN, function()
		onCooldown[player.UserId] = nil
	end)
end

local function notifyBlocked(player: Player, message: string)
	local remote = ReplicatedStorage:FindFirstChild("Remotes")
		and ReplicatedStorage.Remotes:FindFirstChild("ShowPortalMessage")
	if remote then
		remote:FireClient(player, message)
	end
end

-- Cave center for a player's assigned plot (used as teleport target)
local function caveSpawnFor(player: Player): Vector3
	local plot = PlotManager.getPlot(player)
	if not plot then return Vector3.new(0, 2, 2) end
	local spots = PlotManager.getRootSpots(plot)
	if #spots == 0 then return Vector3.new(0, 2, 2) end
	-- Land just south of the growing row, facing north toward plots
	local center = spots[math.ceil(#spots / 2)].Position
	return Vector3.new(center.X, center.Y + 2, center.Z + 10)
end

-- ── Portal handlers by type ──────────────────────────────────────────────────
local portalHandlers: { [string]: (player: Player) -> () } = {

	PersonalCave = function(player)
		teleport(player, caveSpawnFor(player))
		local zoneRemote = ReplicatedStorage:FindFirstChild("Remotes")
			and ReplicatedStorage.Remotes:FindFirstChild("ZoneChanged")
		if zoneRemote then zoneRemote:FireClient(player, "PersonalCave") end
	end,

	TheDeep = function(player)
		local data = DataManager.get(player)
		if not data then return end
		teleport(player, DEEP_SPAWN)
		local zoneRemote = ReplicatedStorage:FindFirstChild("Remotes")
			and ReplicatedStorage.Remotes:FindFirstChild("ZoneChanged")
		if zoneRemote then zoneRemote:FireClient(player, "TheDeep") end
	end,

	Hub = function(player)
		teleport(player, HUB_SPAWN)
		local zoneRemote = ReplicatedStorage:FindFirstChild("Remotes")
			and ReplicatedStorage.Remotes:FindFirstChild("ZoneChanged")
		if zoneRemote then zoneRemote:FireClient(player, "Hub") end
	end,

	WaterGrotto = function(player)
		local data = DataManager.get(player)
		if not data then return end

		-- Count journal discoveries (Phase 10 gate)
		local journal    = data.journal or {}
		local discovered = 0
		for _ in pairs(journal) do discovered += 1 end

		if discovered < 20 then
			notifyBlocked(player,
				("Water Grotto requires 20 discovered species (have %d) + Deepblood potion."):format(discovered))
			return
		end

		-- Check Deepblood potion (Phase 9)
		if not (data.brews and (data.brews["deepblood"] or 0) > 0) then
			notifyBlocked(player, "Need Deepblood potion (brew at Mycology Vat)")
			return
		end

		teleport(player, GROTTO_SPAWN)
	end,
}

-- ── Wire a single BasePart as a portal ───────────────────────────────────────
local function wirePortal(part: BasePart)
	local portalType = part:GetAttribute("PortalType") :: string?
	if not portalType then return end
	local handler = portalHandlers[portalType]
	if not handler then return end

	part.Touched:Connect(function(hit)
		local char = hit.Parent
		if not char then return end
		local player = Players:GetPlayerFromCharacter(char)
		if not player then return end
		if onCooldown[player.UserId] then return end
		handler(player)
	end)
end

-- ── Scan a folder for portal parts ───────────────────────────────────────────
local function wireFolder(folder: Folder | Instance)
	for _, v in ipairs(folder:GetDescendants()) do
		if v:IsA("BasePart") then
			wirePortal(v)
		end
	end
	-- Also wire parts added later (e.g., dynamically cloned caves)
	folder.DescendantAdded:Connect(function(v)
		if v:IsA("BasePart") then
			wirePortal(v)
		end
	end)
end

-- ── Water Grotto gate — separate touch handler on gate sign ──────────────────
local function wireWaterGrottoGate()
	local deep = Workspace:FindFirstChild("TheDeep")
	if not deep then return end
	local gateSign = deep:FindFirstChild("WaterGrotto_GateSign")
	if not gateSign or not gateSign:IsA("BasePart") then return end

	gateSign.Touched:Connect(function(hit)
		local char = hit.Parent
		local player = Players:GetPlayerFromCharacter(char)
		if not player or onCooldown[player.UserId] then return end
		portalHandlers.WaterGrotto(player)
	end)
end

-- ── Spawn players in Hub on join ─────────────────────────────────────────────
local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(char)
		task.wait(0.5)  -- character physics settle
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = CFrame.new(HUB_SPAWN)
		end
		-- Notify client of starting zone
		local zoneRemote = ReplicatedStorage:FindFirstChild("Remotes")
			and ReplicatedStorage.Remotes:FindFirstChild("ZoneChanged")
		if zoneRemote then zoneRemote:FireClient(player, "Hub") end
	end)
end

-- ── Boot ─────────────────────────────────────────────────────────────────────
task.defer(function()
	-- Wire all existing zone folders
	local foldersToWire = {"Hub", "PersonalCaveExtras", "TheDeep", "CaveEnvironment"}
	for _, name in ipairs(foldersToWire) do
		local folder = Workspace:FindFirstChild(name)
		if folder then wireFolder(folder) end
	end
	wireWaterGrottoGate()
end)

-- Wire cloned cave folders added at runtime (created by CaveInstancer or manually)
Workspace.ChildAdded:Connect(function(child)
	if not (child:IsA("Folder") or child:IsA("Model")) then return end
	local name = child.Name
	if name:match("^PersonalCaveExtras") or name:match("^CaveEnvironment") then
		wireFolder(child)
	end
end)

Players.PlayerAdded:Connect(onPlayerAdded)
for _, p in ipairs(Players:GetPlayers()) do
	onPlayerAdded(p)
end
