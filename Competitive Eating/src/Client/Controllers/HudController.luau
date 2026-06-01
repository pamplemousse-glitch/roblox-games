-- Renders fill meter, scoreboard, timer, results overlay, coin counter, and DQ feedback.

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common    = ReplicatedStorage:WaitForChild("Common")
local Constants = require(Common:WaitForChild("Constants"))
local Types     = require(Common:WaitForChild("Types"))

require(script.Parent:WaitForChild("PhotoModeController"))  -- self-inits, owns its own ScreenGui

local HudController = {}

local remotes: { [string]: RemoteEvent } = {}
local localPlayer = Players.LocalPlayer
local playerGui   = localPlayer:WaitForChild("PlayerGui")

-- ── HUD element refs ──────────────────────────────────────────────────────────

local hudGui: ScreenGui
local fillBar: Frame
local fillBarFill: Frame
local fillLabel: TextLabel
local timerLabel: TextLabel
local boardFrame: Frame
local phaseLabel: TextLabel
local coinLabel: TextLabel
local dqLabel: TextLabel
local biteLabel: TextLabel

-- ── Results overlay refs ──────────────────────────────────────────────────────

local resultsGui: ScreenGui
local resultsOutro = ""   -- captured from ContestPhaseChanged "Results" announcement arg

-- ── Build HUD ─────────────────────────────────────────────────────────────────

local function buildHud()
	hudGui = Instance.new("ScreenGui")
	hudGui.Name           = "HudGui"
	hudGui.ResetOnSpawn   = false
	hudGui.IgnoreGuiInset = true
	hudGui.Enabled        = false
	hudGui.Parent         = playerGui

	-- ── Fill meter (left side, vertical) ────────────────────────────────────
	local meterBg = Instance.new("Frame")
	meterBg.Name              = "MeterBg"
	meterBg.Size              = UDim2.fromOffset(28, 200)
	meterBg.Position          = UDim2.new(0, 20, 0.5, -100)
	meterBg.BackgroundColor3  = Color3.fromRGB(40, 40, 40)
	meterBg.BorderSizePixel   = 0
	meterBg.Parent            = hudGui
	fillBar = meterBg

	local fill = Instance.new("Frame")
	fill.Name              = "Fill"
	fill.Size              = UDim2.new(1, 0, 0, 0)
	fill.Position          = UDim2.new(0, 0, 1, 0)
	fill.AnchorPoint       = Vector2.new(0, 1)
	fill.BackgroundColor3  = Color3.fromRGB(80, 200, 80)
	fill.BorderSizePixel   = 0
	fill.Parent            = meterBg
	fillBarFill = fill

	-- Danger line at 90%
	local dangerLine = Instance.new("Frame")
	dangerLine.Size              = UDim2.new(1, 0, 0, 2)
	dangerLine.Position          = UDim2.new(0, 0, 1 - Constants.FILL_DANGER, 0)
	dangerLine.BackgroundColor3  = Color3.fromRGB(255, 80, 0)
	dangerLine.BorderSizePixel   = 0
	dangerLine.Parent            = meterBg

	-- Fill % label
	local lbl = Instance.new("TextLabel")
	lbl.Size                = UDim2.fromOffset(60, 20)
	lbl.Position            = UDim2.new(0, 32, 0.5, -100)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3          = Color3.new(1, 1, 1)
	lbl.TextScaled          = true
	lbl.Font                = Enum.Font.Gotham
	lbl.Text                = "0%"
	lbl.Parent              = hudGui
	fillLabel = lbl

	-- ── Bite counter (above fill meter) ──────────────────────────────────────
	local bite = Instance.new("TextLabel")
	bite.Name               = "BiteLabel"
	bite.Size               = UDim2.fromOffset(60, 30)
	bite.Position           = UDim2.new(0, 12, 0.5, -138)
	bite.BackgroundTransparency = 1
	bite.TextColor3         = Color3.fromRGB(255, 255, 100)
	bite.TextScaled         = true
	bite.Font               = Enum.Font.GothamBold
	bite.Text               = ""
	bite.Parent             = hudGui
	biteLabel = bite

	-- ── Timer (top center) ────────────────────────────────────────────────────
	local timer = Instance.new("TextLabel")
	timer.Name              = "Timer"
	timer.Size              = UDim2.fromOffset(120, 40)
	timer.Position          = UDim2.new(0.5, -60, 0, 10)
	timer.BackgroundTransparency = 1
	timer.TextColor3        = Color3.new(1, 1, 1)
	timer.TextScaled        = true
	timer.Font              = Enum.Font.GothamBold
	timer.Text              = ""
	timer.Parent            = hudGui
	timerLabel = timer

	-- ── Phase / announcement label ────────────────────────────────────────────
	local phase = Instance.new("TextLabel")
	phase.Name              = "Phase"
	phase.Size              = UDim2.fromOffset(500, 60)
	phase.Position          = UDim2.new(0.5, -250, 0.35, 0)
	phase.BackgroundTransparency = 1
	phase.TextColor3        = Color3.fromRGB(255, 220, 50)
	phase.TextScaled        = true
	phase.Font              = Enum.Font.GothamBold
	phase.Text              = ""
	phase.Parent            = hudGui
	phaseLabel = phase

	-- ── Coin counter (top right, always visible during contest) ──────────────
	local coin = Instance.new("TextLabel")
	coin.Name               = "CoinLabel"
	coin.Size               = UDim2.fromOffset(160, 36)
	coin.Position           = UDim2.new(1, -170, 0, 10)
	coin.BackgroundColor3   = Color3.fromRGB(20, 20, 20)
	coin.BackgroundTransparency = 0.4
	coin.BorderSizePixel    = 0
	coin.TextColor3         = Color3.fromRGB(255, 215, 0)
	coin.TextScaled         = true
	coin.Font               = Enum.Font.GothamBold
	coin.Text               = "Coins: 0"
	coin.Parent             = hudGui
	coinLabel = coin

	-- ── DQ label (shown when fill hits 100%) ─────────────────────────────────
	local dq = Instance.new("TextLabel")
	dq.Name                 = "DQLabel"
	dq.Size                 = UDim2.new(1, 0, 0, 80)
	dq.Position             = UDim2.new(0, 0, 0.4, 0)
	dq.BackgroundTransparency = 1
	dq.TextColor3           = Color3.fromRGB(255, 40, 40)
	dq.TextScaled           = true
	dq.Font                 = Enum.Font.GothamBold
	dq.Text                 = "DISQUALIFIED"
	dq.Visible              = false
	dq.Parent               = hudGui
	dqLabel = dq

	-- ── Contestant scoreboard (right side) ───────────────────────────────────
	local board = Instance.new("Frame")
	board.Name              = "Board"
	board.Size              = UDim2.fromOffset(180, 160)
	board.Position          = UDim2.new(1, -195, 0.5, -80)
	board.BackgroundColor3  = Color3.fromRGB(20, 20, 20)
	board.BackgroundTransparency = 0.4
	board.BorderSizePixel   = 0
	board.Parent            = hudGui
	boardFrame = board
	Instance.new("UIListLayout", board).Padding = UDim.new(0, 2)
end

-- ── Results overlay ───────────────────────────────────────────────────────────

local function buildResultsGui()
	resultsGui = Instance.new("ScreenGui")
	resultsGui.Name           = "ResultsGui"
	resultsGui.ResetOnSpawn   = false
	resultsGui.IgnoreGuiInset = true
	resultsGui.Enabled        = false
	resultsGui.DisplayOrder   = 10
	resultsGui.Parent         = playerGui

	-- Full-screen dim
	local bg = Instance.new("Frame")
	bg.Size                  = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3      = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 0.45
	bg.BorderSizePixel       = 0
	bg.Parent                = resultsGui

	-- Content card
	local card = Instance.new("Frame")
	card.Name              = "Card"
	card.Size              = UDim2.fromOffset(460, 360)
	card.Position          = UDim2.new(0.5, -230, 0.5, -180)
	card.BackgroundColor3  = Color3.fromRGB(18, 18, 18)
	card.BackgroundTransparency = 0.08
	card.BorderSizePixel   = 0
	card.Parent            = resultsGui
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

	-- "RESULTS" title
	local title = Instance.new("TextLabel")
	title.Size              = UDim2.new(1, -20, 0, 48)
	title.Position          = UDim2.new(0, 10, 0, 6)
	title.BackgroundTransparency = 1
	title.TextColor3        = Color3.fromRGB(255, 215, 0)
	title.TextScaled        = true
	title.Font              = Enum.Font.GothamBold
	title.Text              = "RESULTS"
	title.Parent            = card

	-- George Shea outro
	local outro = Instance.new("TextLabel")
	outro.Name              = "Outro"
	outro.Size              = UDim2.new(1, -20, 0, 44)
	outro.Position          = UDim2.new(0, 10, 0, 56)
	outro.BackgroundTransparency = 1
	outro.TextColor3        = Color3.fromRGB(200, 200, 200)
	outro.TextScaled        = true
	outro.Font              = Enum.Font.Gotham
	outro.Text              = ""
	outro.TextWrapped       = true
	outro.Parent            = card

	-- Divider
	local div = Instance.new("Frame")
	div.Size              = UDim2.new(1, -20, 0, 2)
	div.Position          = UDim2.new(0, 10, 0, 106)
	div.BackgroundColor3  = Color3.fromRGB(70, 70, 70)
	div.BorderSizePixel   = 0
	div.Parent            = card

	-- Leaderboard list
	local list = Instance.new("Frame")
	list.Name              = "List"
	list.Size              = UDim2.new(1, -20, 0, 184)
	list.Position          = UDim2.new(0, 10, 0, 116)
	list.BackgroundTransparency = 1
	list.Parent            = card
	local layout = Instance.new("UIListLayout", list)
	layout.Padding = UDim.new(0, 4)

	-- Coins earned
	local coinsLbl = Instance.new("TextLabel")
	coinsLbl.Name           = "CoinsEarned"
	coinsLbl.Size           = UDim2.new(1, -20, 0, 36)
	coinsLbl.Position       = UDim2.new(0, 10, 0, 312)
	coinsLbl.BackgroundTransparency = 1
	coinsLbl.TextColor3     = Color3.fromRGB(255, 215, 0)
	coinsLbl.TextScaled     = true
	coinsLbl.Font           = Enum.Font.GothamBold
	coinsLbl.Text           = ""
	coinsLbl.Parent         = card
end

local function showResults(results: { any }, coinsEarned: number)
	resultsGui.Enabled = true

	local card     = resultsGui:FindFirstChild("Card") :: Frame
	local outro    = card:FindFirstChild("Outro")      :: TextLabel
	local list     = card:FindFirstChild("List")       :: Frame
	local coinsLbl = card:FindFirstChild("CoinsEarned") :: TextLabel

	outro.Text = resultsOutro ~= "" and ('"' .. resultsOutro .. '"') or ""

	-- Clear previous rows
	for _, child in list:GetChildren() do
		if child:IsA("TextLabel") then child:Destroy() end
	end

	-- Populate leaderboard
	for _, entry in results do
		local nameStr: string
		if entry.npcName then
			nameStr = entry.npcName
		else
			local uid = entry.userId
			local p   = uid and Players:GetPlayerByUserId(uid)
			nameStr = p and p.DisplayName or ("Player " .. tostring(uid))
		end

		local isMe = (entry.userId == localPlayer.UserId)

		local row = Instance.new("TextLabel")
		row.Size               = UDim2.new(1, 0, 0, 38)
		row.BackgroundTransparency = isMe and 0.55 or 1
		row.BackgroundColor3   = Color3.fromRGB(50, 110, 200)
		row.TextColor3         = isMe and Color3.fromRGB(255, 255, 120) or Color3.new(1, 1, 1)
		row.TextScaled         = true
		row.Font               = isMe and Enum.Font.GothamBold or Enum.Font.Gotham
		local biteSuffix = entry.isDqd and (string.format("%d bites — DQ (overstuffed)", entry.bites)) or string.format("%d bites", entry.bites)
		row.Text               = string.format("#%d  %-14s  %s", entry.place, nameStr:sub(1, 14), biteSuffix)
		if entry.isDqd then
			row.TextColor3 = Color3.fromRGB(255, 130, 130)
		end
		row.TextXAlignment     = Enum.TextXAlignment.Left
		row.Parent             = list
	end

	-- Coins line
	if coinsEarned and coinsEarned > 0 then
		coinsLbl.Text = string.format("+ %d coins earned!", coinsEarned)
	else
		coinsLbl.Text = "Better luck next time!"
	end

	-- Auto-dismiss after results phase ends
	task.delay(Constants.RESULTS_DURATION, function()
		if resultsGui then resultsGui.Enabled = false end
	end)
end

-- ── Fill meter update ─────────────────────────────────────────────────────────

local myFill       = 0
local myArena      = 0
local wasDqd       = false
local dangerPulseTask: thread? = nil

local function stopDangerPulse()
	if dangerPulseTask then
		task.cancel(dangerPulseTask)
		dangerPulseTask = nil
	end
end

local function startDangerPulse()
	if dangerPulseTask then return end
	dangerPulseTask = task.spawn(function()
		local bright = Color3.fromRGB(255, 60, 60)
		local dim    = Color3.fromRGB(140, 15, 15)
		while true do
			TweenService:Create(fillBarFill, TweenInfo.new(0.25), {BackgroundColor3 = dim}):Play()
			task.wait(0.25)
			TweenService:Create(fillBarFill, TweenInfo.new(0.25), {BackgroundColor3 = bright}):Play()
			task.wait(0.25)
		end
	end)
end

local function updateFillMeter(fill: number)
	myFill = fill
	local pct = math.clamp(fill, 0, 1)

	TweenService:Create(fillBarFill, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, pct, 0)}):Play()

	if pct >= Constants.FILL_DANGER then
		startDangerPulse()
	else
		stopDangerPulse()
		local color: Color3
		if pct < Constants.FILL_CAUTION then
			color = Color3.fromRGB(80, 200, 80)
		else
			color = Color3.fromRGB(240, 180, 0)
		end
		fillBarFill.BackgroundColor3 = color
	end

	fillLabel.Text = math.floor(pct * 100) .. "%"

	if fill >= Constants.FILL_OVERFLOW and not wasDqd then
		wasDqd = true
		dqLabel.Visible = true
	end
end

local function updateBoard(snapshot: Types.FillSnapshot)
	for _, child in boardFrame:GetChildren() do
		if child:IsA("TextLabel") then child:Destroy() end
	end

	local entries: { { key: string, fill: number, bites: number } } = {}
	for key, fill in snapshot.fill do
		table.insert(entries, { key = key, fill = fill, bites = snapshot.bites[key] or 0 })
	end
	table.sort(entries, function(a, b) return a.bites > b.bites end)

	for i, entry in entries do
		if i > 8 then break end
		local name: string
		if entry.key:sub(1, 4) == "npc_" then
			name = entry.key:sub(5)
		else
			local uid = tonumber(entry.key)
			local p   = uid and Players:GetPlayerByUserId(uid)
			name = p and p.DisplayName or ("Player " .. entry.key)
		end

		local row = Instance.new("TextLabel")
		row.Size               = UDim2.new(1, 0, 0, 18)
		row.BackgroundTransparency = 1
		row.TextColor3         = Color3.new(1, 1, 1)
		row.TextScaled         = true
		row.Font               = Enum.Font.Gotham
		row.Text               = string.format("%d. %s  %d", i, name:sub(1, 12), entry.bites)
		row.TextXAlignment     = Enum.TextXAlignment.Left
		row.Parent             = boardFrame
	end

	timerLabel.Text = string.format("%.0fs", math.max(0, snapshot.timeLeft))

	local myKey = tostring(localPlayer.UserId)
	if snapshot.fill[myKey] then
		updateFillMeter(snapshot.fill[myKey])
	end
	if snapshot.bites[myKey] and biteLabel then
		local bites = snapshot.bites[myKey]
		biteLabel.Text = bites > 0 and (tostring(bites) .. " bites") or ""
	end
end

-- ── Phase announcements ───────────────────────────────────────────────────────

local countdownTask: thread? = nil

local function onPhaseChanged(arenaId: number, state: string, _tier: any, food: any, announcement: any, _unused: any, seatCount: any, queueTimeLeft: any)
	-- Ignore broadcasts for arenas the local player isn't in
	-- (server broadcasts every arena's state to every player; we only render our own).
	-- Exception: the first Queuing broadcast (myArena is nil) is how we learn we joined.
	if myArena ~= nil and myArena ~= arenaId and state ~= "Idle" then
		return
	end

	-- Cancel any running local countdown or danger pulse
	if countdownTask then
		task.cancel(countdownTask)
		countdownTask = nil
	end
	if state ~= "Active" then
		stopDangerPulse()
		if fillBarFill then
			fillBarFill.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
		end
	end

	if state == "Idle" then
		hudGui.Enabled     = false
		resultsGui.Enabled = false
		dqLabel.Visible    = false
		wasDqd             = false
		myArena            = nil
		if biteLabel then biteLabel.Text = "" end
		if timerLabel then timerLabel.Text = "" end
		if phaseLabel then phaseLabel.Text = "" end
		return
	end

	hudGui.Enabled = true
	myArena        = arenaId

	if state == "Queuing" then
		local seats   = tonumber(seatCount) or 0
		local tLeft   = tonumber(queueTimeLeft) or 0
		phaseLabel.Text = string.format("Arena %d  •  Waiting (%d/%d seated)", arenaId, seats, Constants.SEATS_PER_ARENA)
		timerLabel.Text = tostring(math.floor(tLeft)) .. "s"

		-- Local countdown between server re-broadcasts (re-syncs every 3s)
		countdownTask = task.spawn(function()
			local t = tLeft
			while t > 0 do
				task.wait(1)
				t = t - 1
				if timerLabel then timerLabel.Text = math.max(0, math.floor(t)) .. "s" end
			end
		end)

	elseif state == "Countdown" then
		phaseLabel.Text = tostring(announcement or "Get ready!")
		timerLabel.Text = tostring(Constants.COUNTDOWN_DURATION)

		-- Local 5-4-3-2-1
		countdownTask = task.spawn(function()
			for i = Constants.COUNTDOWN_DURATION, 1, -1 do
				if timerLabel then timerLabel.Text = tostring(i) end
				task.wait(1)
			end
			if timerLabel then timerLabel.Text = "" end
		end)

	elseif state == "Active" then
		phaseLabel.Text = food and ("🍴 " .. tostring(food):upper()) or ""
		dqLabel.Visible = false
		wasDqd          = false
		if biteLabel then biteLabel.Text = "" end

	elseif state == "Results" then
		phaseLabel.Text = ""
		dqLabel.Visible = false
		wasDqd          = false
		resultsOutro    = tostring(announcement or "")
	end
end

-- ── Init ─────────────────────────────────────────────────────────────────────

function HudController.init(remotesFolder: Folder)
	remotes.FillUpdate          = remotesFolder:WaitForChild("FillUpdate")          :: RemoteEvent
	remotes.ContestPhaseChanged = remotesFolder:WaitForChild("ContestPhaseChanged") :: RemoteEvent
	remotes.ShowResults         = remotesFolder:WaitForChild("ShowResults")         :: RemoteEvent
	remotes.StatsUpdate         = remotesFolder:WaitForChild("StatsUpdate")         :: RemoteEvent

	buildHud()
	buildResultsGui()

	remotes.FillUpdate.OnClientEvent:Connect(function(snapshot: any)
		if snapshot.arenaId == myArena then
			updateBoard(snapshot)
		end
	end)

	remotes.ContestPhaseChanged.OnClientEvent:Connect(function(...)
		onPhaseChanged(...)
	end)

	remotes.ShowResults.OnClientEvent:Connect(function(results: any, coinsEarned: any)
		showResults(results, coinsEarned or 0)
	end)

	remotes.StatsUpdate.OnClientEvent:Connect(function(_stats: any, coins: any, _tier: any)
		if coinLabel then
			coinLabel.Text = "Coins: " .. tostring(coins or 0)
		end
	end)
end

return HudController
