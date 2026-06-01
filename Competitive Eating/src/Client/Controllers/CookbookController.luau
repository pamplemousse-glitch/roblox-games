-- Cookbook UI: a 4×5 grid showing every food in the game.
-- Locked foods render as grayed silhouettes; eaten foods show the first-eaten
-- date in full color. A floating button toggles the panel. Bonus % is shown
-- at the top.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common    = ReplicatedStorage:WaitForChild("Common")
local Constants = require(Common:WaitForChild("Constants"))

local CookbookController = {}

local remotes: { [string]: RemoteEvent } = {}
local localPlayer = Players.LocalPlayer
local playerGui   = localPlayer:WaitForChild("PlayerGui")

-- ── State ─────────────────────────────────────────────────────────────────────

local currentCookbook: { [string]: { firstEatenDate: string, timesEaten: number } } = {}
local currentBonus: number = 0
local panelOpen = false

-- ── UI refs ───────────────────────────────────────────────────────────────────

local cookbookGui: ScreenGui
local panel: Frame
local toggleBtn: TextButton
local bonusLabel: TextLabel
local cells: { { food: string, container: Frame, nameLabel: TextLabel, dateLabel: TextLabel, icon: Frame } } = {}

-- ── Theme ─────────────────────────────────────────────────────────────────────

local TIER_COLORS = {
	Color3.fromRGB(220, 140, 60),    -- Tier 1 — bun/mustard
	Color3.fromRGB(80, 170, 220),    -- Tier 2 — water/cool
	Color3.fromRGB(200, 90, 130),    -- Tier 3 — pink heat
	Color3.fromRGB(255, 215, 80),    -- Tier 4 — championship gold
}

local LOCKED_COLOR  = Color3.fromRGB(55, 55, 60)
local LOCKED_TEXT   = Color3.fromRGB(120, 120, 125)
local UNLOCKED_TEXT = Color3.new(1, 1, 1)

-- ── Build UI ──────────────────────────────────────────────────────────────────

local CELL_W   = 88
local CELL_H   = 110
local CELL_GAP = 6
local TIER_GAP = 14

local function buildToggleButton()
	toggleBtn = Instance.new("TextButton")
	toggleBtn.Name              = "CookbookToggle"
	toggleBtn.Size              = UDim2.fromOffset(56, 56)
	toggleBtn.Position          = UDim2.new(0, 20, 0, 80)
	toggleBtn.BackgroundColor3  = Color3.fromRGB(40, 30, 20)
	toggleBtn.TextColor3        = Color3.fromRGB(255, 215, 120)
	toggleBtn.TextScaled        = true
	toggleBtn.Font              = Enum.Font.GothamBold
	toggleBtn.Text              = "BOOK"
	toggleBtn.BorderSizePixel   = 0
	toggleBtn.AutoButtonColor   = true
	toggleBtn.Parent            = cookbookGui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = toggleBtn
end

local function buildCell(parent: Frame, food: string, xOffset: number)
	local cell = Instance.new("Frame")
	cell.Name              = "Cell_" .. food
	cell.Size              = UDim2.fromOffset(CELL_W, CELL_H)
	cell.Position          = UDim2.fromOffset(xOffset, 0)
	cell.BackgroundColor3  = LOCKED_COLOR
	cell.BorderSizePixel   = 0
	cell.Parent            = parent
	Instance.new("UICorner", cell).CornerRadius = UDim.new(0, 6)

	-- Icon area (colored square — placeholder for art assets)
	local icon = Instance.new("Frame")
	icon.Name              = "Icon"
	icon.Size              = UDim2.fromOffset(CELL_W - 16, 50)
	icon.Position          = UDim2.fromOffset(8, 8)
	icon.BackgroundColor3  = Color3.fromRGB(80, 80, 85)
	icon.BorderSizePixel   = 0
	icon.Parent            = cell
	Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 4)

	-- Food name
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name                  = "Name"
	nameLabel.Size                  = UDim2.fromOffset(CELL_W - 8, 26)
	nameLabel.Position              = UDim2.fromOffset(4, 62)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3            = LOCKED_TEXT
	nameLabel.TextScaled            = true
	nameLabel.Font                  = Enum.Font.GothamSemibold
	nameLabel.Text                  = food
	nameLabel.TextWrapped           = true
	nameLabel.Parent                = cell

	-- First-eaten date (or "???" when locked)
	local dateLabel = Instance.new("TextLabel")
	dateLabel.Name                  = "Date"
	dateLabel.Size                  = UDim2.fromOffset(CELL_W - 8, 14)
	dateLabel.Position              = UDim2.fromOffset(4, 92)
	dateLabel.BackgroundTransparency = 1
	dateLabel.TextColor3            = LOCKED_TEXT
	dateLabel.TextScaled            = true
	dateLabel.Font                  = Enum.Font.Gotham
	dateLabel.Text                  = "???"
	dateLabel.Parent                = cell

	table.insert(cells, {
		food       = food,
		container  = cell,
		nameLabel  = nameLabel,
		dateLabel  = dateLabel,
		icon       = icon,
	})
end

local function buildPanel()
	local rowWidth   = (CELL_W + CELL_GAP) * 5 - CELL_GAP
	local panelW     = rowWidth + 32
	local headerH    = 80
	local tierLabelH = 22
	local panelH     = headerH + Constants.TIER_COUNT * (tierLabelH + CELL_H + TIER_GAP) + 16

	panel = Instance.new("Frame")
	panel.Name              = "Panel"
	panel.Size              = UDim2.fromOffset(panelW, panelH)
	panel.Position          = UDim2.new(0.5, -panelW / 2, 0.5, -panelH / 2)
	panel.BackgroundColor3  = Color3.fromRGB(24, 22, 28)
	panel.BackgroundTransparency = 0.05
	panel.BorderSizePixel   = 0
	panel.Visible           = false
	panel.Parent            = cookbookGui
	Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

	-- Title
	local title = Instance.new("TextLabel")
	title.Size              = UDim2.fromOffset(panelW - 32, 36)
	title.Position          = UDim2.fromOffset(16, 12)
	title.BackgroundTransparency = 1
	title.TextColor3        = Color3.fromRGB(255, 215, 120)
	title.TextScaled        = true
	title.Font              = Enum.Font.GothamBold
	title.Text              = "FRANK'S COOKBOOK"
	title.TextXAlignment    = Enum.TextXAlignment.Left
	title.Parent            = panel

	-- Bonus label (top-right)
	bonusLabel = Instance.new("TextLabel")
	bonusLabel.Size              = UDim2.fromOffset(180, 28)
	bonusLabel.Position          = UDim2.new(1, -196, 0, 16)
	bonusLabel.BackgroundTransparency = 1
	bonusLabel.TextColor3        = Color3.fromRGB(120, 230, 140)
	bonusLabel.TextScaled        = true
	bonusLabel.Font              = Enum.Font.GothamBold
	bonusLabel.Text              = "+0% coin bonus"
	bonusLabel.TextXAlignment    = Enum.TextXAlignment.Right
	bonusLabel.Parent            = panel

	-- Close button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size              = UDim2.fromOffset(28, 28)
	closeBtn.Position          = UDim2.new(1, -36, 0, 48)
	closeBtn.BackgroundColor3  = Color3.fromRGB(60, 40, 40)
	closeBtn.TextColor3        = Color3.new(1, 1, 1)
	closeBtn.TextScaled        = true
	closeBtn.Font              = Enum.Font.GothamBold
	closeBtn.Text              = "X"
	closeBtn.BorderSizePixel   = 0
	closeBtn.Parent            = panel
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)
	closeBtn.MouseButton1Click:Connect(function()
		CookbookController.setOpen(false)
	end)

	-- Tier rows
	local y = 80
	for tierIdx, foods in Constants.TIER_FOODS do
		local tierName  = Constants.TIER_NAMES[tierIdx] or ("Tier " .. tierIdx)
		local tierColor = TIER_COLORS[tierIdx] or Color3.new(1, 1, 1)

		local header = Instance.new("TextLabel")
		header.Size              = UDim2.fromOffset(panelW - 32, tierLabelH)
		header.Position          = UDim2.fromOffset(16, y)
		header.BackgroundTransparency = 1
		header.TextColor3        = tierColor
		header.TextScaled        = true
		header.Font              = Enum.Font.GothamBold
		header.Text              = string.format("TIER %d — %s", tierIdx, tierName)
		header.TextXAlignment    = Enum.TextXAlignment.Left
		header.Parent            = panel

		local rowFrame = Instance.new("Frame")
		rowFrame.Size              = UDim2.fromOffset(rowWidth, CELL_H)
		rowFrame.Position          = UDim2.fromOffset(16, y + tierLabelH)
		rowFrame.BackgroundTransparency = 1
		rowFrame.Parent            = panel

		for foodIdx, food in foods do
			local xOff = (foodIdx - 1) * (CELL_W + CELL_GAP)
			buildCell(rowFrame, food, xOff)
		end

		y = y + tierLabelH + CELL_H + TIER_GAP
	end
end

-- ── State application ─────────────────────────────────────────────────────────

local function tierIndexOf(food: string): number?
	for tierIdx, foods in Constants.TIER_FOODS do
		for _, f in foods do
			if f == food then return tierIdx end
		end
	end
	return nil
end

local function applyCookbookState()
	for _, cell in cells do
		local entry = currentCookbook[cell.food]
		if entry then
			local tierIdx = tierIndexOf(cell.food)
			local tint    = tierIdx and TIER_COLORS[tierIdx] or Color3.new(1, 1, 1)
			cell.container.BackgroundColor3 = Color3.fromRGB(45, 38, 32)
			cell.icon.BackgroundColor3      = tint
			cell.nameLabel.TextColor3       = UNLOCKED_TEXT
			cell.dateLabel.TextColor3       = Color3.fromRGB(200, 200, 200)
			cell.dateLabel.Text             = "First: " .. (entry.firstEatenDate or "?")
		else
			cell.container.BackgroundColor3 = LOCKED_COLOR
			cell.icon.BackgroundColor3      = Color3.fromRGB(80, 80, 85)
			cell.nameLabel.TextColor3       = LOCKED_TEXT
			cell.dateLabel.TextColor3       = LOCKED_TEXT
			cell.dateLabel.Text             = "???"
		end
	end
	if bonusLabel then
		bonusLabel.Text = string.format("+%d%% coin bonus", math.floor(currentBonus * 100 + 0.5))
	end
end

-- ── Public API ────────────────────────────────────────────────────────────────

function CookbookController.setOpen(open: boolean)
	panelOpen = open
	if panel then panel.Visible = open end
end

function CookbookController.toggle()
	CookbookController.setOpen(not panelOpen)
end

-- ── Init ──────────────────────────────────────────────────────────────────────

function CookbookController.init(remotesFolder: Folder)
	remotes.CookbookUpdate = remotesFolder:WaitForChild("CookbookUpdate") :: RemoteEvent

	cookbookGui = Instance.new("ScreenGui")
	cookbookGui.Name           = "CookbookGui"
	cookbookGui.ResetOnSpawn   = false
	cookbookGui.IgnoreGuiInset = true
	cookbookGui.DisplayOrder   = 5
	cookbookGui.Parent         = playerGui

	buildToggleButton()
	buildPanel()
	applyCookbookState()

	toggleBtn.MouseButton1Click:Connect(CookbookController.toggle)

	remotes.CookbookUpdate.OnClientEvent:Connect(function(cookbook: any, bonus: any)
		if type(cookbook) == "table" then
			currentCookbook = cookbook
		end
		if type(bonus) == "number" then
			currentBonus = bonus
		end
		applyCookbookState()
	end)
end

return CookbookController
