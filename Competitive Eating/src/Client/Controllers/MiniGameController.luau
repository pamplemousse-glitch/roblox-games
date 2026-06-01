-- Orchestrates all 5 carnival mini-game UIs.
-- Wires stall ProximityPrompts → StartMiniGame remote.
-- Routes MiniGameChallenge events to the correct UI sub-module.
-- Passes stall Model to each UI so cameras lock onto pre-built geometry.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local Controllers = script.Parent

local MiniGameController = {}

local remotes: { [string]: RemoteEvent } = {}
local localPlayer = Players.LocalPlayer
local playerGui   = localPlayer:WaitForChild("PlayerGui")

local pendingStall: Model?  -- set when ProximityPrompt fires, consumed by MiniGameChallenge

local STALL_GAME_MAP = {
	Stall_RingToss    = "RingToss",
	Stall_HighStriker = "HighStriker",
	Stall_BalloonDart = "BalloonDart",
	Stall_DuckPond    = "DuckPond",
	Stall_SkeeBall    = "SkeeBall",
	Stall_RingToss_R    = "RingToss",
	Stall_BalloonDart_R = "BalloonDart",
	Stall_DuckPond_R    = "DuckPond",
	-- Stall_HighStriker_R was deleted from workspace; removed to avoid 30s WaitForChild timeout
	-- Stall_SkeeBall is the right-side stall (X=100); no _R variant exists
}

-- Fallback: if pendingStall was lost, find the canonical stall by gameType
local CANONICAL_STALL: { [string]: string } = {
	RingToss    = "Stall_RingToss",
	HighStriker = "Stall_HighStriker",
	BalloonDart = "Stall_BalloonDart",
	DuckPond    = "Stall_DuckPond",
	SkeeBall    = "Stall_SkeeBall",
}

-- ── Shared overlay ────────────────────────────────────────────────────────────

local overlayGui: ScreenGui

local function buildOverlay(): ScreenGui
	local gui = Instance.new("ScreenGui")
	gui.Name           = "MiniGameGui"
	gui.ResetOnSpawn   = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder   = 20
	gui.Enabled        = false
	gui.Parent         = playerGui
	return gui
end

local function clearOverlay()
	overlayGui.Enabled = false
	for _, child in overlayGui:GetChildren() do child:Destroy() end
end

-- ── Reward popup ──────────────────────────────────────────────────────────────

local function showRewardPopup(won: boolean, coins: number, message: string)
	local popup = Instance.new("Frame")
	popup.Size              = UDim2.fromOffset(340, 120)
	popup.Position          = UDim2.new(0.5, -170, 0.12, 0)
	popup.BackgroundColor3  = won and Color3.fromRGB(20, 80, 20) or Color3.fromRGB(70, 20, 20)
	popup.BackgroundTransparency = 0.1
	popup.BorderSizePixel   = 0
	popup.Parent            = playerGui
	Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 10)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1,-16,0.55,0); lbl.Position = UDim2.fromOffset(8,8)
	lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1,1,1)
	lbl.TextScaled = true; lbl.Font = Enum.Font.GothamBold
	lbl.TextWrapped = true; lbl.Text = message; lbl.Parent = popup

	if won and coins > 0 then
		local tl = Instance.new("TextLabel")
		tl.Size = UDim2.new(1,-16,0.4,0); tl.Position = UDim2.new(0,8,0.55,0)
		tl.BackgroundTransparency = 1; tl.TextColor3 = Color3.fromRGB(255,220,60)
		tl.TextScaled = true; tl.Font = Enum.Font.GothamBold
		tl.Text = "+ " .. coins .. " coin" .. (coins ~= 1 and "s" or "")
		tl.Parent = popup
	end

	task.delay(3, function()
		if popup and popup.Parent then
			TweenService:Create(popup, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
			task.delay(0.5, function() if popup and popup.Parent then popup:Destroy() end end)
		end
	end)
end

-- ── UI sub-modules ────────────────────────────────────────────────────────────

local RingTossUI    = require(Controllers.RingTossUI)
local HighStrikerUI = require(Controllers.HighStrikerUI)
local DuckPondUI    = require(Controllers.DuckPondUI)
local BalloonDartUI = require(Controllers.BalloonDartUI)
local SkeeBallUI    = require(Controllers.SkeeBallUI)

local function cancelAll()
	RingTossUI.cancel(); HighStrikerUI.cancel()
	DuckPondUI.cancel(); BalloonDartUI.cancel(); SkeeBallUI.cancel()
end

-- ── Result handler ────────────────────────────────────────────────────────────

local function onMiniGameResult(payload: any)
	if type(payload) ~= "table" then return end
	cancelAll(); clearOverlay()
	showRewardPopup(payload.won == true, tonumber(payload.coins) or 0, tostring(payload.message or ""))
end

-- ── ProximityPrompt wiring ────────────────────────────────────────────────────

local function wireStall(stall: Model, gameType: string)
	local function connectPrompt(desc: Instance)
		if not desc:IsA("ProximityPrompt") then return end
		(desc :: ProximityPrompt).Triggered:Connect(function()
			pendingStall = stall
			remotes.StartMiniGame:FireServer({ gameType = gameType })
		end)
	end
	-- Wire prompts already present (handles fully-replicated stalls)
	for _, desc in stall:GetDescendants() do connectPrompt(desc) end
	-- Wire prompts that arrive after replication lag
	stall.DescendantAdded:Connect(connectPrompt)
end

local function wireAllStalls()
	for stallName, gameType in STALL_GAME_MAP do
		task.spawn(function()
			local s = workspace:FindFirstChild(stallName)
			if not s then s = workspace:WaitForChild(stallName, 30) end
			if s and s:IsA("Model") then wireStall(s :: Model, gameType) end
		end)
	end
end

-- ── Init ─────────────────────────────────────────────────────────────────────

function MiniGameController.init(remotesFolder: Folder)
	remotes.StartMiniGame     = remotesFolder:WaitForChild("StartMiniGame")     :: RemoteEvent
	remotes.MiniGameChallenge = remotesFolder:WaitForChild("MiniGameChallenge") :: RemoteEvent
	remotes.MiniGameThrow     = remotesFolder:WaitForChild("MiniGameThrow")     :: RemoteEvent
	remotes.MiniGameResult    = remotesFolder:WaitForChild("MiniGameResult")    :: RemoteEvent

	overlayGui = buildOverlay()

	remotes.MiniGameChallenge.OnClientEvent:Connect(function(challenge: any)
		if type(challenge) ~= "table" then return end

		local stall = pendingStall :: Model?
		pendingStall = nil

		-- Fallback if pendingStall wasn't set (e.g. server-initiated challenge)
		if not stall then
			local name = CANONICAL_STALL[challenge.gameType]
			if name then stall = workspace:FindFirstChild(name) :: Model? end
		end

		cancelAll(); clearOverlay()
		overlayGui.Enabled = true

		local gt = challenge.gameType
		if gt == "RingToss"    then RingTossUI.show(overlayGui, challenge, remotes.MiniGameThrow, stall)
		elseif gt == "HighStriker" then HighStrikerUI.show(overlayGui, challenge, remotes.MiniGameThrow, stall)
		elseif gt == "DuckPond"    then DuckPondUI.show(overlayGui, challenge, remotes.MiniGameThrow, stall)
		elseif gt == "BalloonDart" then BalloonDartUI.show(overlayGui, challenge, remotes.MiniGameThrow, stall)
		elseif gt == "SkeeBall"    then SkeeBallUI.show(overlayGui, challenge, remotes.MiniGameThrow, stall)
		end
	end)

	remotes.MiniGameResult.OnClientEvent:Connect(onMiniGameResult)

	wireAllStalls()
end

return MiniGameController
