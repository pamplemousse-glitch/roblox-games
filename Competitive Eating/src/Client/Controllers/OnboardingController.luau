-- Handles the first-play tutorial overlay.
-- Shows a one-time "how to play" screen before the player's first contest.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common    = ReplicatedStorage:WaitForChild("Common")
local Constants = require(Common:WaitForChild("Constants"))

local OnboardingController = {}

local remotes: { [string]: RemoteEvent } = {}
local localPlayer = Players.LocalPlayer
local playerGui   = localPlayer:WaitForChild("PlayerGui")

local tutorialShown = false

-- ── Build tutorial GUI ────────────────────────────────────────────────────────

local tutorialGui: ScreenGui

local function buildTutorial()
	tutorialGui = Instance.new("ScreenGui")
	tutorialGui.Name           = "TutorialGui"
	tutorialGui.ResetOnSpawn   = false
	tutorialGui.IgnoreGuiInset = true
	tutorialGui.Enabled        = false
	tutorialGui.Parent         = playerGui

	-- Light dim so the tutorial popup pops without darkening the whole world
	local dim = Instance.new("Frame")
	dim.Size              = UDim2.new(1, 0, 1, 0)
	dim.BackgroundColor3  = Color3.new(0, 0, 0)
	dim.BackgroundTransparency = 0.75  -- was 0.55 (too dark)
	dim.BorderSizePixel   = 0
	dim.Parent            = tutorialGui

	-- Panel
	local panel = Instance.new("Frame")
	panel.Size              = UDim2.fromOffset(440, 380)
	panel.Position          = UDim2.new(0.5, -220, 0.5, -190)
	panel.BackgroundColor3  = Color3.fromRGB(18, 18, 18)
	panel.BorderSizePixel   = 0
	panel.Parent            = tutorialGui
	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

	-- Title
	local title = Instance.new("TextLabel")
	title.Size              = UDim2.new(1, 0, 0, 54)
	title.BackgroundTransparency = 1
	title.TextColor3        = Color3.fromRGB(255, 220, 50)
	title.TextScaled        = true
	title.Font              = Enum.Font.GothamBold
	title.Text              = "HOW TO EAT"
	title.Parent            = panel

	-- Instructions list
	local steps = {
		"1. Join an arena and wait for the contest to start.",
		"2. When the ring appears, time your tap/click to land inside the GREEN zone.",
		"3. Hitting the GOLD zone gives a bonus bite!",
		"4. Keep your fill meter from reaching 100% or you'll be disqualified.",
		"5. Eat the most bites to win and earn coins.",
		"6. Spend coins in the SHOP to upgrade your stats.",
	}

	local body = Instance.new("TextLabel")
	body.Size              = UDim2.new(1, -32, 0, 260)
	body.Position          = UDim2.fromOffset(16, 56)
	body.BackgroundTransparency = 1
	body.TextColor3        = Color3.new(1, 1, 1)
	body.TextWrapped       = true
	body.TextScaled        = true
	body.Font              = Enum.Font.Gotham
	body.Text              = table.concat(steps, "\n\n")
	body.TextYAlignment    = Enum.TextYAlignment.Top
	body.TextXAlignment    = Enum.TextXAlignment.Left
	body.Parent            = panel

	-- Dismiss button
	local btn = Instance.new("TextButton")
	btn.Size              = UDim2.fromOffset(200, 44)
	btn.Position          = UDim2.new(0.5, -100, 1, -58)
	btn.BackgroundColor3  = Color3.fromRGB(60, 160, 60)
	btn.TextColor3        = Color3.new(1, 1, 1)
	btn.TextScaled        = true
	btn.Font              = Enum.Font.GothamBold
	btn.Text              = "LET'S EAT!"
	btn.BorderSizePixel   = 0
	btn.Parent            = panel
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		tutorialGui.Enabled = false
	end)
end

-- ── Init ─────────────────────────────────────────────────────────────────────

function OnboardingController.init(remotesFolder: Folder)
	remotes.StatsUpdate = remotesFolder:WaitForChild("StatsUpdate") :: RemoteEvent

	buildTutorial()

	-- Show tutorial only for truly new players (contestsPlayed == 0)
	remotes.StatsUpdate.OnClientEvent:Connect(function(stats: any, coins: any, tier: any)
		-- StatsUpdate fires on join with initial data — use this to check new player
		-- The server only sends firstContestDone in the data table; we proxy via contestsPlayed
		-- Since we don't replicate contestsPlayed directly, show the tutorial once per session
		-- for players who have no coins and no stat upgrades (heuristic for brand new).
		if tutorialShown then return end
		tutorialShown = true

		local allZero = true
		if stats then
			for _, v in stats do
				if v and v > 0 then allZero = false; break end
			end
		end

		if allZero and (coins or 0) == 0 then
			tutorialGui.Enabled = true
		end
	end)
end

return OnboardingController
