-- FishingUI.client.luau
-- Stardew-style reel mini-game triggered by FishingBite remote.
-- Needle drifts left/right (random walk, speed grows over time).
-- Hold REEL button (or E key) to push needle toward center.
-- Win: keep needle in green zone for WIN_TIME seconds. Lose: TIMEOUT seconds pass.
-- Fires FishingResult(true/false) back to server. Shows loot popup on LootGranted.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local Remotes       = ReplicatedStorage:WaitForChild("Remotes")
local FishingBite   = Remotes:WaitForChild("FishingBite")
local FishingResult = Remotes:WaitForChild("FishingResult")
local LootGranted   = Remotes:WaitForChild("LootGranted")

local WIN_ZONE  = 0.25   -- needle within ±25% of bar range counts as "in zone"
local WIN_TIME  = 2      -- seconds needle must stay in zone to win
local TIMEOUT   = 12     -- seconds total before auto-fail

-- ─── BUILD GUI ───────────────────────────────────────────────────────────────

local gui = Instance.new("ScreenGui")
gui.Name           = "FishingUI"
gui.ResetOnSpawn   = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.Enabled        = false
gui.Parent         = PlayerGui

local overlay = Instance.new("Frame")
overlay.Size                  = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3      = Color3.fromRGB(5, 5, 15)
overlay.BackgroundTransparency = 0.40
overlay.BorderSizePixel       = 0
overlay.ZIndex                = 10
overlay.Parent                = gui

local card = Instance.new("Frame")
card.Size                 = UDim2.new(0, 430, 0, 268)
card.Position             = UDim2.new(0.5, -215, 0.5, -134)
card.BackgroundColor3     = Color3.fromRGB(18, 14, 35)
card.BackgroundTransparency = 0
card.BorderSizePixel      = 0
card.ZIndex               = 11
card.Parent               = overlay
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)

local function makeLbl(parent, text, y, h, col, size, font, ax)
	local l = Instance.new("TextLabel")
	l.Size                = UDim2.new(1, -24, 0, h)
	l.Position            = UDim2.new(0, 12, 0, y)
	l.BackgroundTransparency = 1
	l.Text                = text
	l.TextColor3          = col or Color3.fromRGB(215, 210, 250)
	l.TextSize            = size or 14
	l.Font                = font or Enum.Font.Gotham
	l.TextXAlignment      = ax or Enum.TextXAlignment.Center
	l.ZIndex              = 12
	l.Parent              = parent
	return l
end

local titleLbl    = makeLbl(card, "Something tugs at your lure!", 10, 28, Color3.fromRGB(255, 220, 100), 19, Enum.Font.GothamBlack)
local instructLbl = makeLbl(card, "Hold REEL (or E) — keep the needle in the green zone", 40, 22, Color3.fromRGB(140, 130, 180), 13)

local timerLbl = Instance.new("TextLabel")
timerLbl.Size                = UDim2.new(0, 58, 0, 24)
timerLbl.Position            = UDim2.new(1, -68, 0, 12)
timerLbl.BackgroundTransparency = 1
timerLbl.Text                = "12.0s"
timerLbl.TextColor3          = Color3.fromRGB(220, 80, 80)
timerLbl.TextSize            = 14
timerLbl.Font                = Enum.Font.GothamBold
timerLbl.TextXAlignment      = Enum.TextXAlignment.Right
timerLbl.ZIndex              = 12
timerLbl.Parent              = card

-- Reel bar
local barBg = Instance.new("Frame")
barBg.Size             = UDim2.new(1, -40, 0, 42)
barBg.Position         = UDim2.new(0, 20, 0, 72)
barBg.BackgroundColor3 = Color3.fromRGB(30, 24, 55)
barBg.BorderSizePixel  = 0
barBg.ZIndex           = 12
barBg.Parent           = card
Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 7)

-- Green zone: centered, width = WIN_ZONE of bar, position = (1-WIN_ZONE)/2
local greenZone = Instance.new("Frame")
greenZone.Size             = UDim2.new(WIN_ZONE, 0, 1, 0)
greenZone.Position         = UDim2.new((1 - WIN_ZONE) / 2, 0, 0, 0)
greenZone.BackgroundColor3 = Color3.fromRGB(55, 195, 95)
greenZone.BackgroundTransparency = 0.35
greenZone.BorderSizePixel  = 0
greenZone.ZIndex           = 13
greenZone.Parent           = barBg
Instance.new("UICorner", greenZone).CornerRadius = UDim.new(0, 5)

-- Needle: anchored center-left, X position driven by needle_pos
local needle = Instance.new("Frame")
needle.Size          = UDim2.new(0, 6, 1, 8)
needle.AnchorPoint   = Vector2.new(0.5, 0.5)
needle.Position      = UDim2.new(0.5, 0, 0.5, 0)
needle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
needle.BorderSizePixel = 0
needle.ZIndex        = 14
needle.Parent        = barBg
Instance.new("UICorner", needle).CornerRadius = UDim.new(0, 2)

-- Progress bar (time-in-zone indicator)
local progressBg = Instance.new("Frame")
progressBg.Size             = UDim2.new(1, -40, 0, 8)
progressBg.Position         = UDim2.new(0, 20, 0, 124)
progressBg.BackgroundColor3 = Color3.fromRGB(30, 24, 55)
progressBg.BorderSizePixel  = 0
progressBg.ZIndex           = 12
progressBg.Parent           = card
Instance.new("UICorner", progressBg).CornerRadius = UDim.new(0, 3)

local progressFill = Instance.new("Frame")
progressFill.Size             = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(55, 195, 95)
progressFill.BorderSizePixel  = 0
progressFill.ZIndex           = 13
progressFill.Parent           = progressBg
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 3)

local statusLbl = makeLbl(card, "Keep needle in green zone for 2 seconds!", 140, 22, Color3.fromRGB(140, 130, 180), 13)

-- REEL button
local reelBtn = Instance.new("TextButton")
reelBtn.Size             = UDim2.new(0, 220, 0, 48)
reelBtn.Position         = UDim2.new(0.5, -110, 0, 200)
reelBtn.BackgroundColor3 = Color3.fromRGB(55, 195, 95)
reelBtn.BorderSizePixel  = 0
reelBtn.Text             = "REEL"
reelBtn.TextColor3       = Color3.fromRGB(8, 20, 8)
reelBtn.TextSize         = 22
reelBtn.Font             = Enum.Font.GothamBlack
reelBtn.ZIndex           = 12
reelBtn.Parent           = card
Instance.new("UICorner", reelBtn).CornerRadius = UDim.new(0, 8)

-- Loot popup (separate from card, appears after game ends)
local lootFrame = Instance.new("Frame")
lootFrame.Size                 = UDim2.new(0, 300, 0, 88)
lootFrame.Position             = UDim2.new(0.5, -150, 0.25, 0)
lootFrame.BackgroundColor3     = Color3.fromRGB(18, 14, 35)
lootFrame.BackgroundTransparency = 1
lootFrame.BorderSizePixel      = 0
lootFrame.ZIndex               = 20
lootFrame.Parent               = gui
Instance.new("UICorner", lootFrame).CornerRadius = UDim.new(0, 12)

local lootTitle = Instance.new("TextLabel")
lootTitle.Size                = UDim2.new(1, -16, 0, 36)
lootTitle.Position            = UDim2.new(0, 8, 0, 8)
lootTitle.BackgroundTransparency = 1
lootTitle.Text                = ""
lootTitle.TextColor3          = Color3.fromRGB(255, 220, 100)
lootTitle.TextSize            = 17
lootTitle.Font                = Enum.Font.GothamBlack
lootTitle.TextXAlignment      = Enum.TextXAlignment.Center
lootTitle.ZIndex              = 21
lootTitle.Parent              = lootFrame

local lootSub = Instance.new("TextLabel")
lootSub.Size                = UDim2.new(1, -16, 0, 28)
lootSub.Position            = UDim2.new(0, 8, 0, 46)
lootSub.BackgroundTransparency = 1
lootSub.Text                = ""
lootSub.TextColor3          = Color3.fromRGB(150, 145, 195)
lootSub.TextSize            = 13
lootSub.Font                = Enum.Font.Gotham
lootSub.TextXAlignment      = Enum.TextXAlignment.Center
lootSub.ZIndex              = 21
lootSub.Parent              = lootFrame

-- ─── GAME STATE ──────────────────────────────────────────────────────────────

local gameActive  = false
local holding     = false
local needlePos   = 0     -- -1 to 1
local needleVel   = 0
local inZoneTime  = 0
local elapsed     = 0
local renderConn  = nil
local keyDown     = nil
local keyUp       = nil

local tw = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function hideGame()
	gameActive = false
	gui.Enabled = false
	if renderConn then renderConn:Disconnect(); renderConn = nil end
	if keyDown   then keyDown:Disconnect();    keyDown    = nil end
	if keyUp     then keyUp:Disconnect();      keyUp      = nil end
end

local function showLoot(titleText, subText)
	lootTitle.Text = titleText
	lootSub.Text   = subText or ""
	gui.Enabled    = true
	overlay.Visible = false
	card.Visible    = false
	TweenService:Create(lootFrame, tw, { BackgroundTransparency = 0.08 }):Play()
	task.delay(3, function()
		TweenService:Create(lootFrame, tw, { BackgroundTransparency = 1 }):Play()
		task.delay(0.3, function()
			if not gameActive then gui.Enabled = false end
			overlay.Visible = true
			card.Visible    = true
		end)
	end)
end

local function endGame(won: boolean)
	gameActive = false
	if renderConn then renderConn:Disconnect(); renderConn = nil end
	if keyDown   then keyDown:Disconnect();    keyDown    = nil end
	if keyUp     then keyUp:Disconnect();      keyUp      = nil end

	FishingResult:FireServer(won)

	if won then
		statusLbl.Text      = "Got one!"
		statusLbl.TextColor3 = Color3.fromRGB(55, 195, 95)
	else
		statusLbl.Text      = "It got away..."
		statusLbl.TextColor3 = Color3.fromRGB(220, 80, 80)
	end
	task.delay(0.9, hideGame)
end

local function startGame()
	if gameActive then return end
	gameActive   = true
	needlePos    = 0
	needleVel    = math.random() > 0.5 and 0.18 or -0.18
	inZoneTime   = 0
	elapsed      = 0
	holding      = false

	gui.Enabled      = true
	overlay.Visible  = true
	card.Visible     = true
	lootFrame.BackgroundTransparency = 1

	statusLbl.Text       = "Keep needle in green zone for 2 seconds!"
	statusLbl.TextColor3 = Color3.fromRGB(140, 130, 180)
	needle.Position      = UDim2.new(0.5, 0, 0.5, 0)
	progressFill.Size    = UDim2.new(0, 0, 1, 0)

	-- Hold detection: screen button
	reelBtn.MouseButton1Down:Connect(function() holding = true  end)
	reelBtn.MouseButton1Up:Connect(function()   holding = false end)

	-- Hold detection: E key (also released when fishing UI closes)
	keyDown = UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.E then holding = true end
	end)
	keyUp = UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.E then holding = false end
	end)

	renderConn = RunService.RenderStepped:Connect(function(dt)
		if not gameActive then return end
		elapsed += dt

		-- Timer display
		timerLbl.Text = string.format("%.1fs", math.max(0, TIMEOUT - elapsed))

		-- Random walk: drift magnitude grows over time (pressure increases)
		local driftMag = 0.07 + elapsed * 0.006
		needleVel += (math.random() * 2 - 1) * driftMag

		-- Player hold: push toward center
		if holding then
			local dir = needlePos >= 0 and -1 or 1
			needleVel += dir * 1.4 * dt
		end

		-- Damp and clamp
		needleVel = needleVel * 0.93
		needleVel = math.clamp(needleVel, -2.2, 2.2)

		-- Integrate position, bounce off walls
		needlePos += needleVel * dt
		if needlePos >  1 then needlePos =  1; needleVel = -needleVel * 0.5 end
		if needlePos < -1 then needlePos = -1; needleVel = -needleVel * 0.5 end

		-- Update needle visual: map -1..1 to 0..1 on bar
		needle.Position = UDim2.new((needlePos + 1) / 2, 0, 0.5, 0)

		-- In-zone logic
		if math.abs(needlePos) <= WIN_ZONE then
			inZoneTime += dt
			progressFill.Size = UDim2.new(math.min(1, inZoneTime / WIN_TIME), 0, 1, 0)
			statusLbl.Text       = string.format("Hold! (%.1f / %.1f)", inZoneTime, WIN_TIME)
			statusLbl.TextColor3 = Color3.fromRGB(55, 195, 95)
			if inZoneTime >= WIN_TIME then
				endGame(true)
				return
			end
		else
			-- Slowly drain progress when needle leaves zone
			inZoneTime = math.max(0, inZoneTime - dt * 0.6)
			progressFill.Size    = UDim2.new(math.min(1, inZoneTime / WIN_TIME), 0, 1, 0)
			statusLbl.Text       = "Keep needle in green zone!"
			statusLbl.TextColor3 = Color3.fromRGB(140, 130, 180)
		end

		if elapsed >= TIMEOUT then
			endGame(false)
		end
	end)
end

-- ─── REMOTE LISTENERS ────────────────────────────────────────────────────────

FishingBite.OnClientEvent:Connect(function(_biteAt, _depth)
	startGame()
end)

LootGranted.OnClientEvent:Connect(function(loot)
	local Config = require(game.ReplicatedStorage.Common.Config)
	if loot.type == "spores" then
		showLoot("+" .. tostring(loot.amount) .. " Spores!", "Nice catch!")
	elseif loot.type == "fragment" then
		local sp = Config.SPECIES_BY_ID[loot.speciesId]
		local name = sp and sp.name or loot.speciesId
		local done = (loot.count or 0) >= (loot.needed or 10)
		if done then
			showLoot("Species Unlocked!", name)
		else
			showLoot("Fragment: " .. name, tostring(loot.count) .. "/" .. tostring(loot.needed))
		end
	elseif loot.type == "catalyst" then
		showLoot("Mutation Catalyst!", "Guarantees your next mutation")
	end
end)
