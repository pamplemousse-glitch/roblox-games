-- GameClient.client.luau
-- Thin startup script: creates root GUI, initialises all UI modules,
-- wires the nav bar, and listens to RemoteEvents.
-- Heavy UI logic lives in src/Client/UI/*.luau modules.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ─── REMOTES ─────────────────────────────────────────────────────────────────

local Remotes          = ReplicatedStorage:WaitForChild("Remotes")
local UpdateSpores     = Remotes:WaitForChild("UpdateSpores")
local WeatherChanged   = Remotes:WaitForChild("WeatherChanged")
local SyncData         = Remotes:WaitForChild("SyncData")
local PurchaseUpgrade  = Remotes:WaitForChild("PurchaseUpgrade")
local UnlockSpecies    = Remotes:WaitForChild("UnlockSpecies")
local Sporulate        = Remotes:WaitForChild("Sporulate")
local MutationOccurred = Remotes:WaitForChild("MutationOccurred")
local ArrangeSwap      = Remotes:WaitForChild("ArrangeSwap")
local MerchantStock     = Remotes:WaitForChild("MerchantStock")
local MyceliumPulse     = Remotes:WaitForChild("MyceliumPulse")
local LoginStreakData   = Remotes:WaitForChild("LoginStreakData")
local ClaimStreakReward = Remotes:WaitForChild("ClaimStreakReward")
local DailyQuestData   = Remotes:WaitForChild("DailyQuestData")
local QuestProgress    = Remotes:WaitForChild("QuestProgress")
local ClaimQuestReward = Remotes:WaitForChild("ClaimQuestReward")

-- Phase 5–11 remotes
local TendingState      = Remotes:WaitForChild("TendingState")
local PetState          = Remotes:WaitForChild("PetState")
local HPUpdate          = Remotes:WaitForChild("HPUpdate")
local VatState          = Remotes:WaitForChild("VatState")
local JournalUpdated    = Remotes:WaitForChild("JournalUpdated")
local MilestoneReached  = Remotes:WaitForChild("MilestoneReached")
local ShowPortalMessage = Remotes:WaitForChild("ShowPortalMessage")
local ZoneChanged       = Remotes:WaitForChild("ZoneChanged")
local LeaderboardUpdated = Remotes:WaitForChild("LeaderboardUpdated")

-- ─── MODULES ─────────────────────────────────────────────────────────────────

local Client        = ReplicatedStorage:WaitForChild("Client")
local UI            = Client:WaitForChild("UI")
local Common        = ReplicatedStorage:WaitForChild("Common")

local Config          = require(Common:WaitForChild("Config"))
local buildCaveUI     = require(Client:WaitForChild("SharedCaveUI"))
local buildVaultUI    = require(Client:WaitForChild("VaultUI"))
local ArrangeMode     = require(Client:WaitForChild("ArrangeMode"))
local TutorialManager = require(Client:WaitForChild("TutorialManager"))
local SoundManager    = require(Client:WaitForChild("SoundManager"))
local HUD             = require(UI:WaitForChild("HUD"))
local ShopUI          = require(UI:WaitForChild("ShopUI"))
local MerchantUI      = require(UI:WaitForChild("MerchantUI"))
local LoginStreakUI   = require(UI:WaitForChild("LoginStreakUI"))
local DailyQuestUI   = require(UI:WaitForChild("DailyQuestUI"))
-- Phase 5–11 UI modules (self-contained, only need requiring for API access)
local TendingUI       = require(UI:WaitForChild("TendingUI"))
local PetDenUI        = require(UI:WaitForChild("PetDenUI"))
local VatUI           = require(UI:WaitForChild("VatUI"))
local JournalUI       = require(UI:WaitForChild("JournalUI"))

-- ─── SHARED STATE ────────────────────────────────────────────────────────────
-- All UI modules receive a reference to this table, so updates are instant.

local state = {
	spores = 0, lifetimeSpores = 0, sporesPerSec = 0,
	ownedSpecies = {}, upgrades = { Fertilizer=0, Lighting=0, Humidity=0 },
	prestigeLevel = 0, mutations = {}, weather = nil, vaultSlots = 0,
	isVIP = false, owns2xPass = false,
}

-- ─── PALETTE (local helpers for startup elements only) ───────────────────────

local C_BG    = Color3.fromRGB(12, 10, 22)
local C_PANEL = Color3.fromRGB(22, 18, 40)
local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_GREEN = Color3.fromRGB(70, 185, 110)
local C_GOLD  = Color3.fromRGB(255, 200, 55)

local function corner(p, r)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
end
local function fr(par, sz, pos, bg, al)
	local f = Instance.new("Frame"); f.Size = sz; f.Position = pos
	f.BackgroundColor3 = bg or C_PANEL; f.BackgroundTransparency = al or 0
	f.BorderSizePixel = 0; f.Parent = par; return f
end
local function lb(par, tx, sz, pos, col, ts, ax)
	local l = Instance.new("TextLabel"); l.Size = sz; l.Position = pos
	l.BackgroundTransparency = 1; l.Text = tx
	l.TextColor3 = col or Color3.new(1,1,1); l.TextSize = ts or 16
	l.Font = Enum.Font.GothamBold
	l.TextXAlignment = ax or Enum.TextXAlignment.Left; l.Parent = par; return l
end
local function btn(par, tx, sz, pos, bg, tc)
	local b = Instance.new("TextButton"); b.Size = sz; b.Position = pos
	b.BackgroundColor3 = bg or C_GREEN; b.BorderSizePixel = 0
	b.Text = tx; b.TextColor3 = tc or Color3.new(1,1,1)
	b.TextSize = 15; b.Font = Enum.Font.GothamBold
	b.Parent = par; corner(b, 6); return b
end

-- ─── ROOT GUI ────────────────────────────────────────────────────────────────

local gui = Instance.new("ScreenGui")
gui.Name = "FunGuyUI"; gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.Parent = PlayerGui

local cave  = buildCaveUI(gui)
local vault = buildVaultUI(gui, Config, function() return state end)

-- ─── INIT UI MODULES ────────────────────────────────────────────────────────

local hud       = HUD.init(gui, state, Config)
local shop      = ShopUI.init(gui, state, Config,
	{ PurchaseUpgrade = PurchaseUpgrade, UnlockSpecies = UnlockSpecies },
	TutorialManager, SoundManager)
local merchant  = MerchantUI.init(gui, state, Config, Remotes)
local streak    = LoginStreakUI.init(gui, ClaimStreakReward)
local quests    = DailyQuestUI.init(gui, ClaimQuestReward)

-- ─── MY CAVE BUTTONS ────────────────────────────────────────────────────────

local shopBtn     = btn(gui, "SHOP",
	UDim2.new(0,80,0,36), UDim2.new(1,-90,1,-96), C_GREEN)
local merchantBtn = btn(gui, "DEALS",
	UDim2.new(0,80,0,36), UDim2.new(1,-178,1,-96), C_PANEL)
local arrangeBtn  = btn(gui, "ARRANGE",
	UDim2.new(0,80,0,36), UDim2.new(1,-266,1,-96), C_PANEL)
local questsBtn   = btn(gui, "QUESTS",
	UDim2.new(0,80,0,36), UDim2.new(1,-354,1,-96), C_PANEL)
local petsBtn     = btn(gui, "PETS",
	UDim2.new(0,80,0,36), UDim2.new(1,-442,1,-96), C_PANEL)
local vatBtn      = btn(gui, "VAT",
	UDim2.new(0,80,0,36), UDim2.new(1,-530,1,-96), C_PANEL)
local journalBtn  = btn(gui, "JOURNAL",
	UDim2.new(0,80,0,36), UDim2.new(1,-618,1,-96), C_PANEL)

local arrangeHint = lb(gui, "↕  Tap a mushroom, then tap its destination",
	UDim2.new(0,380,0,24), UDim2.new(0.5,-190,1,-130),
	C_CYAN, 12, Enum.TextXAlignment.Center)
arrangeHint.BackgroundColor3 = C_BG
arrangeHint.BackgroundTransparency = 0.2; arrangeHint.Visible = false
corner(arrangeHint, 6)

local prestigeBtn = btn(gui, "SPORULATE",
	UDim2.new(0,200,0,40), UDim2.new(0.5,-100,1,-100), C_GOLD, C_BG)
prestigeBtn.TextSize = 16; prestigeBtn.Visible = false

-- Elements hidden when switching to THE CAVE tab
local myCaveElements = {
	hud.getFrame(), shopBtn, merchantBtn, arrangeBtn, questsBtn,
	petsBtn, vatBtn, journalBtn, prestigeBtn,
	shop.panel, merchant.panel, quests.panel,
}

-- ─── NAV BAR ────────────────────────────────────────────────────────────────

local nav     = fr(gui, UDim2.new(1,0,0,50), UDim2.new(0,0,1,-50), C_BG, 0.1)
local navMy   = btn(nav, "MY CAVE",  UDim2.new(0.5,-4,0,38), UDim2.new(0,4,0,6),   C_GREEN)
local navCave = btn(nav, "THE CAVE", UDim2.new(0.5,-4,0,38), UDim2.new(0.5,0,0,6), C_PANEL)

local function showMyCave()
	for _, el in ipairs(myCaveElements) do el.Visible = true end
	shop.hide(); merchant.hide(); cave.hide()
	navMy.BackgroundColor3 = C_GREEN; navCave.BackgroundColor3 = C_PANEL
end

local function showTheCave()
	for _, el in ipairs(myCaveElements) do el.Visible = false end
	arrangeHint.Visible = false
	ArrangeMode.deactivate()
	cave.show()
	navMy.BackgroundColor3 = C_PANEL; navCave.BackgroundColor3 = C_GREEN
end

navMy.Activated:Connect(function() SoundManager.click(); showMyCave() end)
navCave.Activated:Connect(function() SoundManager.click(); showTheCave() end)

-- ─── WIRE MODULES ───────────────────────────────────────────────────────────

ArrangeMode.init(arrangeBtn, arrangeHint, ArrangeSwap)
arrangeBtn.Activated:Connect(function() SoundManager.click(); ArrangeMode.toggle() end)

TutorialManager.init(gui, function() return state end,
	shopBtn, shop.tabSp, shop.panel)

shopBtn.Activated:Connect(function()
	if shop.isVisible() then
		SoundManager.close(); shop.hide()
	else
		merchant.hide(); quests.hide()
		SoundManager.panelOpen(); shop.show()
		TutorialManager.onShopOpened()
	end
end)

-- Myco NPC triggers this from NPCShopClient
local Bindables = ReplicatedStorage:WaitForChild("Bindables")
Bindables:WaitForChild("OpenShop").Event:Connect(function()
	merchant.hide(); quests.hide()
	SoundManager.panelOpen(); shop.show()
	TutorialManager.onShopOpened()
end)

merchantBtn.Activated:Connect(function()
	if merchant.isVisible() then
		SoundManager.close(); merchant.hide()
	else
		shop.hide(); quests.hide()
		SoundManager.panelOpen(); merchant.show()
	end
end)

questsBtn.Activated:Connect(function()
	if quests.isVisible() then
		SoundManager.close(); quests.hide()
	else
		shop.hide(); merchant.hide()
		SoundManager.panelOpen(); quests.show()
	end
end)

petsBtn.Activated:Connect(function()
	if PetDenUI.isVisible() then
		SoundManager.close(); PetDenUI.hide()
	else
		shop.hide(); merchant.hide(); quests.hide()
		VatUI.hide(); JournalUI.hide()
		SoundManager.panelOpen(); PetDenUI.show()
	end
end)

vatBtn.Activated:Connect(function()
	if VatUI.isVisible() then
		SoundManager.close(); VatUI.hide()
	else
		shop.hide(); merchant.hide(); quests.hide()
		PetDenUI.hide(); JournalUI.hide()
		SoundManager.panelOpen(); VatUI.show()
	end
end)

journalBtn.Activated:Connect(function()
	if JournalUI.isVisible() then
		SoundManager.close(); JournalUI.hide()
	else
		shop.hide(); merchant.hide(); quests.hide()
		PetDenUI.hide(); VatUI.hide()
		SoundManager.panelOpen(); JournalUI.show()
	end
end)

prestigeBtn.Activated:Connect(function()
	SoundManager.click()
	local nextLv = state.prestigeLevel + 1
	local slots  = (Config.VAULT_SLOTS_BY_PRESTIGE[nextLv] or 0) + (state.vaultSlots or 0)
	vault.show(slots, nextLv, function(selectedIds)
		Sporulate:FireServer(selectedIds)
	end)
end)

-- ─── REMOTE LISTENERS ───────────────────────────────────────────────────────

UpdateSpores.OnClientEvent:Connect(function(spores, lifetime, sps)
	state.spores = spores; state.lifetimeSpores = lifetime; state.sporesPerSec = sps
	hud.update()
	shop.rebuild()
	local req = Config.PRESTIGE_REQUIREMENTS[state.prestigeLevel + 1]
	if req and state.lifetimeSpores >= req then
		prestigeBtn.Visible = true
		prestigeBtn.Text = "SPORULATE  ×"
			.. (Config.PRESTIGE_MULTIPLIERS[state.prestigeLevel + 1] or "?")
	else
		prestigeBtn.Visible = false
	end
end)

WeatherChanged.OnClientEvent:Connect(function(event)
	hud.showWeather(event)
end)

MutationOccurred.OnClientEvent:Connect(function(speciesId, mutCount)
	hud.showMutation(speciesId, mutCount)
end)

SyncData.OnClientEvent:Connect(function(data)
	state.spores         = data.spores
	state.lifetimeSpores = data.lifetimeSpores
	state.ownedSpecies   = data.ownedSpecies
	state.upgrades       = data.upgrades
	state.prestigeLevel  = data.prestigeLevel
	state.mutations      = data.mutations
	state.vaultSlots     = data.vaultSlots or 0
	state.isVIP          = data.isVIP or false
	state.owns2xPass     = data.owns2xPass or false
	hud.update()
	shop.rebuild()
	TutorialManager.onSyncData(state)
end)

-- Merchant stock refresh (server broadcasts new stock every ~6 min)
MerchantStock.OnClientEvent:Connect(function(stockData)
	merchant.onStockUpdated(stockData)
	-- Flash the button so players notice
	merchantBtn.BackgroundColor3 = C_GOLD
	task.delay(2, function() merchantBtn.BackgroundColor3 = C_PANEL end)
end)

-- Mycelium Pulse (cooperative network bonus active)
MyceliumPulse.OnClientEvent:Connect(function(intensity: number)
	merchant.showPulseEffect(intensity)
end)

-- Login streak popup (fires once per session after data loads)
LoginStreakData.OnClientEvent:Connect(function(data)
	streak.show(data)
end)

-- Daily quest full refresh (on join or after UTC midnight reset)
DailyQuestData.OnClientEvent:Connect(function(data)
	quests.onQuestData(data)
	-- Badge on button if any quests are completable
	local hasDone = false
	for _, q in ipairs(data.quests or {}) do
		local prog = (data.completed or {})[q.id] or 0
		local claimed = (data.completed or {})[q.id .. "_claimed"]
		if prog >= q.amount and not claimed then hasDone = true; break end
	end
	questsBtn.BackgroundColor3 = hasDone and C_GOLD or C_PANEL
end)

-- Incremental quest progress (while player is in-session)
QuestProgress.OnClientEvent:Connect(function(update)
	quests.onQuestProgress(update)
	-- Flash quests button gold when a quest completes
	if update.progress >= update.goal then
		questsBtn.BackgroundColor3 = C_GOLD
	end
end)

-- ─── CAVE EVENTS ─────────────────────────────────────────────────────────────

local CaveEventActive  = Remotes:WaitForChild("CaveEventActive")
local activeHighlights = {}

local function clearMoleHighlights()
	for _, h in ipairs(activeHighlights) do
		if h and h.Parent then h:Destroy() end
	end
	activeHighlights = {}
end

-- Underground Spring: highlight MoleHole parts so players know to fish
CaveEventActive.OnClientEvent:Connect(function(eventName)
	clearMoleHighlights()
	if eventName ~= "Underground Spring" then return end
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name:match("^MoleHole_") then
			local h = Instance.new("Highlight")
			h.FillColor          = Color3.fromRGB(80, 210, 255)
			h.OutlineColor       = Color3.fromRGB(80, 210, 255)
			h.FillTransparency   = 0.45
			h.Parent             = obj
			table.insert(activeHighlights, h)
		end
	end
end)

-- Clear mole highlights when the cave event ends
WeatherChanged.OnClientEvent:Connect(function(event)
	if not event then clearMoleHighlights() end
end)

-- ─── PHASE 8: HP UPDATE ──────────────────────────────────────────────────────

HPUpdate.OnClientEvent:Connect(function(hp: number, maxHp: number)
	hud.updateHP(hp, maxHp)
end)

-- ─── PHASE 11: PORTAL BLOCKED TOAST ─────────────────────────────────────────

local toastLabel do
	local toastBg = Instance.new("Frame")
	toastBg.Name = "PortalToast"
	toastBg.Size = UDim2.new(0, 400, 0, 52)
	toastBg.Position = UDim2.new(0.5, -200, 0, 100)
	toastBg.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
	toastBg.BorderSizePixel = 0
	toastBg.Visible = false
	toastBg.ZIndex = 25
	toastBg.Parent = gui
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = toastBg

	toastLabel = Instance.new("TextLabel")
	toastLabel.Size = UDim2.new(1, -16, 1, 0)
	toastLabel.Position = UDim2.new(0, 8, 0, 0)
	toastLabel.BackgroundTransparency = 1
	toastLabel.Text = ""
	toastLabel.TextColor3 = Color3.new(1, 1, 1)
	toastLabel.TextSize = 14
	toastLabel.Font = Enum.Font.GothamBold
	toastLabel.TextWrapped = true
	toastLabel.ZIndex = 26
	toastLabel.Parent = toastBg

	ShowPortalMessage.OnClientEvent:Connect(function(msg: string)
		toastLabel.Text = msg
		toastBg.Visible = true
		toastBg.BackgroundTransparency = 0
		toastLabel.TextTransparency = 0
		task.delay(3, function()
			local ts = game:GetService("TweenService")
			ts:Create(toastBg, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
			ts:Create(toastLabel, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
			task.delay(0.5, function() toastBg.Visible = false end)
		end)
	end)
end

-- ─── ZONE CHANGED BANNER ─────────────────────────────────────────────────────

local zoneBannerBg = Instance.new("Frame")
zoneBannerBg.Name                  = "ZoneBanner"
zoneBannerBg.Size                  = UDim2.new(0, 200, 0, 34)
zoneBannerBg.Position              = UDim2.new(0.5, -100, 0, 58)
zoneBannerBg.BackgroundColor3      = Color3.fromRGB(12, 10, 22)
zoneBannerBg.BackgroundTransparency = 1
zoneBannerBg.BorderSizePixel       = 0
zoneBannerBg.ZIndex                = 20
zoneBannerBg.Parent                = gui
corner(zoneBannerBg, 8)

local zoneBannerLabel = lb(zoneBannerBg, "",
	UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0),
	C_CYAN, 14, Enum.TextXAlignment.Center)
zoneBannerLabel.ZIndex = 21
zoneBannerLabel.TextTransparency = 1

local ZONE_DISPLAY = {
	Hub         = "THE HUB",
	PersonalCave = "MY CAVE",
	TheDeep     = "THE DEEP",
}

ZoneChanged.OnClientEvent:Connect(function(zoneName: string)
	local display = ZONE_DISPLAY[zoneName]
	if not display then return end
	zoneBannerLabel.Text = display
	zoneBannerBg.BackgroundTransparency  = 0.25
	zoneBannerLabel.TextTransparency     = 0
	local ts = game:GetService("TweenService")
	task.delay(2, function()
		ts:Create(zoneBannerBg,   TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()
		ts:Create(zoneBannerLabel,TweenInfo.new(0.6), { TextTransparency = 1 }):Play()
	end)
end)

-- ─── HUB LEADERBOARD BILLBOARD ───────────────────────────────────────────────

local function fmtN(n: number): string
	if n >= 1e12 then return string.format("%.1fT", n / 1e12)
	elseif n >= 1e9  then return string.format("%.1fB", n / 1e9)
	elseif n >= 1e6  then return string.format("%.1fM", n / 1e6)
	elseif n >= 1e3  then return string.format("%.1fK", n / 1e3)
	else return tostring(math.floor(n)) end
end

local function updateHubBillboard(entries: { any })
	local hub  = workspace:FindFirstChild("Hub")
	if not hub then return end
	local wall = hub:FindFirstChild("LeaderboardWall")
	if not wall then return end
	local sg   = wall:FindFirstChildWhichIsA("SurfaceGui")
	if not sg  then return end

	for _, c in ipairs(sg:GetChildren()) do c:Destroy() end

	local layout = Instance.new("UIListLayout")
	layout.SortOrder  = Enum.SortOrder.LayoutOrder
	layout.Padding    = UDim.new(0.01, 0)
	layout.Parent     = sg

	local title = Instance.new("TextLabel")
	title.Size               = UDim2.new(1, 0, 0.13, 0)
	title.BackgroundTransparency = 1
	title.Text               = "TOP GROWERS"
	title.Font               = Enum.Font.GothamBlack
	title.TextScaled         = true
	title.TextColor3         = C_GOLD
	title.LayoutOrder        = 0
	title.Parent             = sg

	for i = 1, math.min(10, #entries) do
		local e   = entries[i]
		local row = Instance.new("TextLabel")
		row.Size               = UDim2.new(1, 0, 0.08, 0)
		row.BackgroundTransparency = 1
		row.Text               = string.format("#%d  %s   %s", e.rank, e.displayName, fmtN(e.peakSpores))
		row.Font               = Enum.Font.GothamBold
		row.TextScaled         = true
		row.TextColor3         = i == 1 and C_GOLD or Color3.fromRGB(215, 210, 250)
		row.LayoutOrder        = i
		row.Parent             = sg
	end
end

LeaderboardUpdated.OnClientEvent:Connect(updateHubBillboard)
