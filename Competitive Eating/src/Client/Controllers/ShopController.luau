-- Upgrade shop UI: shows all 4 stats, current level, cost, buy button.
-- Fires PurchaseUpgrade to server; updates on StatsUpdate.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")

local Common    = ReplicatedStorage:WaitForChild("Common")
local Constants = require(Common:WaitForChild("Constants"))
local Utils     = require(Common:WaitForChild("Utils"))
local Types     = require(Common:WaitForChild("Types"))

local ShopController = {}

local remotes: { [string]: RemoteEvent } = {}
local localPlayer = Players.LocalPlayer
local playerGui   = localPlayer:WaitForChild("PlayerGui")

local currentStats: Types.PlayerStats = {
	StomachCapacity = 0, JawSpeed = 0, SwallowRate = 0, Focus = 0
}
local currentCoins    = 0
local highestTier     = 1
local shopOpen        = false

-- ── Build shop UI ─────────────────────────────────────────────────────────────

local shopGui: ScreenGui
local shopPanel: Frame
local coinLabel: TextLabel
local toggleBtn: TextButton
local statRows: { [string]: { level: TextLabel, cost: TextLabel, btn: TextButton } } = {}

local PANEL_W = 440
local PANEL_H = 360
local ROW_H   = 64

local function makeStatRow(stat: string, index: number, parent: Frame)
	local y = (index - 1) * ROW_H + 10

	-- Background row
	local row = Instance.new("Frame")
	row.Size              = UDim2.new(1, -16, 0, ROW_H - 6)
	row.Position          = UDim2.fromOffset(8, y)
	row.BackgroundColor3  = Color3.fromRGB(35, 35, 35)
	row.BorderSizePixel   = 0
	row.Parent            = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

	-- Stat name (left half)
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size              = UDim2.fromOffset(180, ROW_H - 18)
	nameLabel.Position          = UDim2.new(0, 14, 0.5, -(ROW_H - 18) / 2)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3        = Color3.new(1, 1, 1)
	nameLabel.TextScaled        = true
	nameLabel.Font              = Enum.Font.GothamBold
	nameLabel.Text              = Constants.STAT_DISPLAY[stat] or stat
	nameLabel.TextXAlignment    = Enum.TextXAlignment.Left
	nameLabel.Parent            = row

	-- Level display
	local lvlLabel = Instance.new("TextLabel")
	lvlLabel.Size              = UDim2.fromOffset(60, 22)
	lvlLabel.Position          = UDim2.fromOffset(202, 8)
	lvlLabel.BackgroundTransparency = 1
	lvlLabel.TextColor3        = Color3.fromRGB(180, 220, 255)
	lvlLabel.TextScaled        = true
	lvlLabel.Font              = Enum.Font.GothamBold
	lvlLabel.Text              = "Lv 0"
	lvlLabel.TextXAlignment    = Enum.TextXAlignment.Left
	lvlLabel.Parent            = row

	-- Cost label (below level)
	local costLabel = Instance.new("TextLabel")
	costLabel.Size              = UDim2.fromOffset(60, 18)
	costLabel.Position          = UDim2.fromOffset(202, 32)
	costLabel.BackgroundTransparency = 1
	costLabel.TextColor3        = Color3.fromRGB(255, 220, 80)
	costLabel.TextScaled        = true
	costLabel.Font              = Enum.Font.Gotham
	costLabel.Text              = "50c"
	costLabel.TextXAlignment    = Enum.TextXAlignment.Left
	costLabel.Parent            = row

	-- Buy button (right side)
	local btn = Instance.new("TextButton")
	btn.Size              = UDim2.fromOffset(80, 36)
	btn.Position          = UDim2.new(1, -94, 0.5, -18)
	btn.BackgroundColor3  = Color3.fromRGB(60, 160, 60)
	btn.TextColor3        = Color3.new(1, 1, 1)
	btn.TextScaled        = true
	btn.Font              = Enum.Font.GothamBold
	btn.Text              = "BUY"
	btn.BorderSizePixel   = 0
	btn.Parent            = row
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

	btn.MouseButton1Click:Connect(function()
		remotes.PurchaseUpgrade:FireServer(stat)
	end)

	statRows[stat] = { level = lvlLabel, cost = costLabel, btn = btn }
end

local function buildShopGui()
	shopGui = Instance.new("ScreenGui")
	shopGui.Name           = "ShopGui"
	shopGui.ResetOnSpawn   = false
	shopGui.IgnoreGuiInset = true
	shopGui.Enabled        = false
	shopGui.DisplayOrder   = 100  -- above all toggle buttons (Cookbook=5, PhotoMode=50)
	shopGui.Parent         = playerGui

	-- Dark overlay — only visible while the shop panel is open
	local overlay = Instance.new("Frame")
	overlay.Name              = "Overlay"
	overlay.Size              = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3  = Color3.new(0, 0, 0)
	overlay.BackgroundTransparency = 0.5
	overlay.BorderSizePixel   = 0
	overlay.Visible           = false
	overlay.Parent            = shopGui

	-- Panel
	local panel = Instance.new("Frame")
	panel.Name              = "Panel"
	panel.Size              = UDim2.fromOffset(PANEL_W, PANEL_H)
	panel.Position          = UDim2.new(0.5, -PANEL_W / 2, 0.5, -PANEL_H / 2)
	panel.BackgroundColor3  = Color3.fromRGB(20, 20, 20)
	panel.BorderSizePixel   = 0
	panel.Visible           = false   -- closed by default; ShopController.open() shows it
	panel.Parent            = shopGui
	shopPanel = panel
	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

	-- Title — capped width so the coin counter has room
	local title = Instance.new("TextLabel")
	title.Size              = UDim2.fromOffset(220, 32)
	title.Position          = UDim2.fromOffset(12, 8)
	title.BackgroundTransparency = 1
	title.TextColor3        = Color3.fromRGB(255, 220, 80)
	title.TextScaled        = true
	title.Font              = Enum.Font.GothamBold
	title.Text              = "UPGRADE SHOP"
	title.TextXAlignment    = Enum.TextXAlignment.Left
	title.Parent            = panel

	-- Coin display — top-right of panel
	local coinLbl = Instance.new("TextLabel")
	coinLbl.Size              = UDim2.fromOffset(80, 24)
	coinLbl.Position          = UDim2.new(1, -130, 0, 12)
	coinLbl.BackgroundTransparency = 1
	coinLbl.TextColor3        = Color3.fromRGB(255, 220, 80)
	coinLbl.TextScaled        = true
	coinLbl.Font              = Enum.Font.Gotham
	coinLbl.Text              = "0 coins"
	coinLbl.TextXAlignment    = Enum.TextXAlignment.Right
	coinLbl.Parent            = panel
	coinLabel = coinLbl

	-- Stat rows container
	local rowsFrame = Instance.new("Frame")
	rowsFrame.Size              = UDim2.new(1, 0, 1, -50)
	rowsFrame.Position          = UDim2.fromOffset(0, 46)
	rowsFrame.BackgroundTransparency = 1
	rowsFrame.BorderSizePixel   = 0
	rowsFrame.Parent            = panel

	for i, stat in Constants.STAT_NAMES do
		makeStatRow(stat, i, rowsFrame)
	end

	-- Close button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size              = UDim2.fromOffset(28, 28)
	closeBtn.Position          = UDim2.new(1, -34, 0, 6)
	closeBtn.BackgroundColor3  = Color3.fromRGB(180, 40, 40)
	closeBtn.TextColor3        = Color3.new(1, 1, 1)
	closeBtn.TextScaled        = true
	closeBtn.Font              = Enum.Font.GothamBold
	closeBtn.Text              = "✕"
	closeBtn.BorderSizePixel   = 0
	closeBtn.Parent            = shopGui
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 14)
	closeBtn.Position = UDim2.new(0.5, PANEL_W / 2 - 34, 0.5, -PANEL_H / 2 + 6)

	closeBtn.MouseButton1Click:Connect(function()
		ShopController.close()
	end)

	-- ── Shop toggle button (always visible outside of Active phase) ─────────
	toggleBtn = Instance.new("TextButton")
	toggleBtn.Size              = UDim2.fromOffset(90, 36)
	toggleBtn.Position          = UDim2.new(1, -100, 1, -50)
	toggleBtn.BackgroundColor3  = Color3.fromRGB(50, 130, 200)
	toggleBtn.TextColor3        = Color3.new(1, 1, 1)
	toggleBtn.TextScaled        = true
	toggleBtn.Font              = Enum.Font.GothamBold
	toggleBtn.Text              = "SHOP"
	toggleBtn.BorderSizePixel   = 0
	toggleBtn.Parent            = shopGui
	toggleBtn.Visible           = true
	Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

	-- Keep button visible even when panel is closed
	shopGui.Enabled = true -- always visible for toggle button

	toggleBtn.MouseButton1Click:Connect(function()
		if shopOpen then
			ShopController.close()
		else
			ShopController.open()
		end
	end)
end

-- ── Refresh UI from current data ──────────────────────────────────────────────

local function refreshRows()
	coinLabel.Text = currentCoins .. " coins"
	for _, stat in Constants.STAT_NAMES do
		local row   = statRows[stat]
		if not row then continue end
		local level = currentStats[stat] or 0
		local cost  = Utils.upgradeCost(level)
		local maxed = level >= Constants.STAT_MAX_LEVEL

		row.level.Text = "Lv " .. level
		row.cost.Text  = maxed and "MAX" or (cost .. "c")

		local canAfford = not maxed and currentCoins >= cost
		row.btn.BackgroundColor3 = canAfford
			and Color3.fromRGB(60, 160, 60)
			or  Color3.fromRGB(80, 80, 80)
		row.btn.Text   = maxed and "—" or "BUY"
		row.btn.Active = canAfford
	end
end

-- ── Public API ────────────────────────────────────────────────────────────────

function ShopController.open()
	shopOpen = true
	shopPanel.Visible = true
	local overlay = shopGui:FindFirstChild("Overlay")
	if overlay then overlay.Visible = true end
	refreshRows()
end

function ShopController.close()
	shopOpen = false
	shopPanel.Visible = false
	local overlay = shopGui:FindFirstChild("Overlay")
	if overlay then overlay.Visible = false end
end

-- ── Init ─────────────────────────────────────────────────────────────────────

function ShopController.init(remotesFolder: Folder)
	remotes.PurchaseUpgrade     = remotesFolder:WaitForChild("PurchaseUpgrade")     :: RemoteEvent
	remotes.StatsUpdate         = remotesFolder:WaitForChild("StatsUpdate")         :: RemoteEvent
	remotes.ContestPhaseChanged = remotesFolder:WaitForChild("ContestPhaseChanged") :: RemoteEvent
	remotes.OpenShop            = remotesFolder:WaitForChild("OpenShop")            :: RemoteEvent
	remotes.OpenPrizeBooth      = remotesFolder:WaitForChild("OpenPrizeBooth")      :: RemoteEvent

	buildShopGui()
	shopPanel.Visible = false

	remotes.StatsUpdate.OnClientEvent:Connect(function(stats: any, coins: any, tier: any)
		currentStats  = stats
		currentCoins  = coins
		highestTier   = tier
		if shopOpen then refreshRows() end
	end)

	remotes.ContestPhaseChanged.OnClientEvent:Connect(function(_arenaId: any, state: any)
		if state == "Active" then
			toggleBtn.Visible = false
			ShopController.close()
		else
			toggleBtn.Visible = true
		end
	end)

	-- NPC vendor proximity prompts route through these.
	remotes.OpenShop.OnClientEvent:Connect(function()
		ShopController.open()
	end)
	remotes.OpenPrizeBooth.OnClientEvent:Connect(function()
		ShopController.open()
	end)
end

return ShopController
