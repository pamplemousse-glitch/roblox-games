-- TendingUI.client.luau
-- Tending panel: shows Water / Nutrients / Pollinate slots per species.
-- Triggered by ProximityPrompt on RootSpots.
-- Reads TendingState remote for cooldown display.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local Remotes      = ReplicatedStorage:WaitForChild("Remotes")
local TendSlot     = Remotes:WaitForChild("TendSlot")
local TendingState = Remotes:WaitForChild("TendingState")

local Config = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("Config"))

-- ─── STATE ────────────────────────────────────────────────────────────────────

local tendingData  = {}    -- copy of server state: { [speciesId] = { water=ts, nutrients=ts, pollinate=ts } }
local currentSpecies = nil
local autoCloseTimer = nil

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local C_BG    = Color3.fromRGB(12, 10, 22)
local C_PANEL = Color3.fromRGB(22, 18, 40)
local C_GREEN = Color3.fromRGB(70, 185, 110)
local C_GREY  = Color3.fromRGB(80, 75, 100)
local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_WHITE = Color3.fromRGB(215, 210, 250)

local function corner(p, r)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
end

local SLOT_LABELS = { water = "Water", nutrients = "Nutrients", pollinate = "Pollinate" }

-- ─── BUILD UI ────────────────────────────────────────────────────────────────

local gui = Instance.new("ScreenGui")
gui.Name = "TendingUI"; gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local panel = Instance.new("Frame")
panel.Name = "TendPanel"
panel.Size = UDim2.new(0, 280, 0, 180)
panel.Position = UDim2.new(0.5, -140, 0.5, -90)
panel.BackgroundColor3 = C_PANEL
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 20
panel.Parent = gui
corner(panel, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -16, 0, 28)
title.Position = UDim2.new(0, 8, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Tend Mushroom"
title.TextColor3 = C_CYAN
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.ZIndex = 21
title.Parent = panel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 8)
closeBtn.BackgroundColor3 = C_GREY
closeBtn.Text = "X"
closeBtn.TextColor3 = C_WHITE
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 21
closeBtn.Parent = panel
corner(closeBtn, 5)

local slotButtons = {}
local slotOrder = { "water", "nutrients", "pollinate" }

for i, slotId in ipairs(slotOrder) do
	local btn = Instance.new("TextButton")
	btn.Name = slotId
	btn.Size = UDim2.new(1, -20, 0, 36)
	btn.Position = UDim2.new(0, 10, 0, 40 + (i - 1) * 44)
	btn.BackgroundColor3 = C_GREEN
	btn.BorderSizePixel = 0
	btn.Text = SLOT_LABELS[slotId] .. " — Ready"
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamBold
	btn.ZIndex = 21
	btn.Parent = panel
	corner(btn, 6)

	slotButtons[slotId] = btn

	btn.Activated:Connect(function()
		if not currentSpecies then return end

		-- Check cooldown locally before firing (server re-validates)
		local speciesData = tendingData[currentSpecies] or {}
		local lastTime    = speciesData[slotId] or 0
		if os.time() - lastTime < Config.TENDING_DURATION then return end

		TendSlot:FireServer(currentSpecies, slotId)
		-- Optimistically mark as tended
		tendingData[currentSpecies]         = tendingData[currentSpecies] or {}
		tendingData[currentSpecies][slotId] = os.time()
		refreshPanel()

		-- Auto-close after selection
		task.delay(1, function()
			if panel.Visible then panel.Visible = false end
		end)
	end)
end

closeBtn.Activated:Connect(function()
	panel.Visible = false
end)

-- ─── REFRESH SLOT DISPLAY ────────────────────────────────────────────────────

function refreshPanel()
	if not currentSpecies then return end

	local sp = Config.SPECIES_BY_ID[currentSpecies]
	title.Text = "Tend: " .. (sp and sp.name or currentSpecies)

	local speciesData = tendingData[currentSpecies] or {}
	local now = os.time()

	for _, slotId in ipairs(slotOrder) do
		local btn     = slotButtons[slotId]
		local lastTime = speciesData[slotId] or 0
		local elapsed  = now - lastTime
		local cooldown = Config.TENDING_DURATION

		if elapsed >= cooldown then
			btn.Text = SLOT_LABELS[slotId] .. " — Ready"
			btn.BackgroundColor3 = C_GREEN
		else
			local remaining = cooldown - elapsed
			local mins = math.floor(remaining / 60)
			local secs = remaining % 60
			btn.Text = SLOT_LABELS[slotId] .. string.format("  %d:%02d", mins, secs)
			btn.BackgroundColor3 = C_GREY
		end
	end
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

local TendingUI = {}

function TendingUI.showFor(speciesId: string)
	currentSpecies = speciesId
	refreshPanel()
	panel.Visible = true

	-- Auto-close after 5s if no selection
	if autoCloseTimer then
		task.cancel(autoCloseTimer)
	end
	autoCloseTimer = task.delay(5, function()
		panel.Visible = false
	end)
end

function TendingUI.onStateUpdate(state: table)
	tendingData = state or {}
	if panel.Visible then refreshPanel() end
end

-- Countdown updater
task.spawn(function()
	while true do
		task.wait(1)
		if panel.Visible then refreshPanel() end
	end
end)

-- ─── REMOTE LISTENER ─────────────────────────────────────────────────────────

TendingState.OnClientEvent:Connect(function(state: table)
	TendingUI.onStateUpdate(state)
end)

-- ─── PROXIMITY PROMPT WATCHER ─────────────────────────────────────────────────
-- Scans RootSpot ProximityPrompts; resolves species from nearest model.

local function getSpeciesAtSpot(rootSpot: BasePart): string?
	local plot = rootSpot.Parent
	if not plot then return nil end

	local bestId   = nil
	local bestDist = math.huge

	for _, child in ipairs(plot:GetChildren()) do
		if child:IsA("Model") then
			local speciesId = child:GetAttribute("SpeciesId")
			if speciesId then
				local primary = child.PrimaryPart or child:FindFirstChild("Root") or child:FindFirstChildWhichIsA("BasePart")
				if primary then
					local dist = (primary.Position - rootSpot.Position).Magnitude
					if dist < bestDist then
						bestDist = dist
						bestId   = speciesId
					end
				end
			end
		end
	end
	return bestId
end

local function wireRootSpotPrompt(part: BasePart)
	if not part.Name:match("^RootSpot_") then return end

	local prompt = part:FindFirstChildWhichIsA("ProximityPrompt")
	if not prompt then
		-- Create one (in case it wasn't added via execute_luau yet)
		local p = Instance.new("ProximityPrompt")
		p.ActionText = "Tend"
		p.KeyboardKeyCode = Enum.KeyCode.E
		p.MaxActivationDistance = 7
		p.HoldDuration = 0
		p.RequiresLineOfSight = false
		p.Parent = part
		prompt = p
	end

	prompt.Triggered:Connect(function()
		local speciesId = getSpeciesAtSpot(part)
		if speciesId then
			TendingUI.showFor(speciesId)
		end
	end)
end

-- Wire all existing and future RootSpots
local function scanForRootSpots()
	for _, desc in ipairs(workspace:GetDescendants()) do
		if desc:IsA("BasePart") and desc.Name:match("^RootSpot_") then
			wireRootSpotPrompt(desc)
		end
	end
end

task.defer(scanForRootSpots)

workspace.DescendantAdded:Connect(function(desc)
	if desc:IsA("BasePart") and desc.Name:match("^RootSpot_") then
		task.defer(function() wireRootSpotPrompt(desc) end)
	end
end)

return TendingUI
