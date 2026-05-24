-- JournalUI.client.luau
-- 5×7 grid of all 35 species. Discovered = colored; undiscovered = silhouette.
-- Shows milestone progress at 5, 10, 20, 35.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local Remotes         = ReplicatedStorage:WaitForChild("Remotes")
local JournalUpdated  = Remotes:WaitForChild("JournalUpdated")
local MilestoneReached = Remotes:WaitForChild("MilestoneReached")

local Config = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("Config"))

-- ─── PALETTE ─────────────────────────────────────────────────────────────────

local C_BG    = Color3.fromRGB(12, 10, 22)
local C_PANEL = Color3.fromRGB(22, 18, 40)
local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_GREEN = Color3.fromRGB(70, 185, 110)
local C_GREY  = Color3.fromRGB(40, 35, 60)
local C_GOLD  = Color3.fromRGB(255, 200, 55)
local C_WHITE = Color3.fromRGB(215, 210, 250)
local C_MUTED = Color3.fromRGB(120, 112, 155)

local TIER_COLORS = {
	Common   = Color3.fromRGB(180, 255, 190),
	Uncommon = Color3.fromRGB(70, 185, 110),
	Rare     = Color3.fromRGB(100, 145, 255),
	Epic     = Color3.fromRGB(195, 95, 255),
	Mythic   = Color3.fromRGB(255, 200, 55),
}

local MILESTONES = {5, 10, 20, 35}

local function corner(p, r)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
end

-- ─── BUILD UI ────────────────────────────────────────────────────────────────

local gui = Instance.new("ScreenGui")
gui.Name = "JournalUI"; gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local panel = Instance.new("Frame")
panel.Name = "JournalPanel"
panel.Size = UDim2.new(0, 420, 0, 560)
panel.Position = UDim2.new(0.5, -210, 0.5, -280)
panel.BackgroundColor3 = C_PANEL
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 15
panel.Parent = gui
corner(panel, 12)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -16, 0, 28)
titleLbl.Position = UDim2.new(0, 8, 0, 8)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Mushroom Journal"
titleLbl.TextColor3 = C_CYAN
titleLbl.TextSize = 18
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.ZIndex = 16
titleLbl.Parent = panel

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 8)
closeBtn.BackgroundColor3 = C_GREY
closeBtn.Text = "X"
closeBtn.TextColor3 = C_WHITE
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 16
closeBtn.Parent = panel
corner(closeBtn, 5)

local countLbl = Instance.new("TextLabel")
countLbl.Size = UDim2.new(1, -16, 0, 18)
countLbl.Position = UDim2.new(0, 8, 0, 38)
countLbl.BackgroundTransparency = 1
countLbl.Text = "0 / 35 discovered"
countLbl.TextColor3 = C_MUTED
countLbl.TextSize = 13
countLbl.Font = Enum.Font.Gotham
countLbl.TextXAlignment = Enum.TextXAlignment.Left
countLbl.ZIndex = 16
countLbl.Parent = panel

-- Milestone bar
local milestoneBar = Instance.new("Frame")
milestoneBar.Size = UDim2.new(1, -16, 0, 20)
milestoneBar.Position = UDim2.new(0, 8, 0, 58)
milestoneBar.BackgroundColor3 = C_BG
milestoneBar.BorderSizePixel = 0
milestoneBar.ZIndex = 16
milestoneBar.Parent = panel
corner(milestoneBar, 4)

local milestoneLabels = {}
for _, m in ipairs(MILESTONES) do
	local pct = m / 35
	local ml  = Instance.new("TextLabel")
	ml.Size = UDim2.new(0, 28, 1, 0)
	ml.Position = UDim2.new(pct, -14, 0, 0)
	ml.BackgroundTransparency = 1
	ml.Text = tostring(m)
	ml.TextColor3 = C_MUTED
	ml.TextSize = 10
	ml.Font = Enum.Font.Gotham
	ml.TextXAlignment = Enum.TextXAlignment.Center
	ml.ZIndex = 17
	ml.Parent = milestoneBar
	milestoneLabels[m] = ml
end

-- Grid of species
local gridScroll = Instance.new("ScrollingFrame")
gridScroll.Size = UDim2.new(1, -10, 1, -90)
gridScroll.Position = UDim2.new(0, 5, 0, 86)
gridScroll.BackgroundTransparency = 1
gridScroll.BorderSizePixel = 0
gridScroll.ScrollBarThickness = 4
gridScroll.ScrollBarImageColor3 = C_CYAN
gridScroll.ZIndex = 16
gridScroll.Parent = panel

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize    = UDim2.new(0, 72, 0, 80)
gridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
gridLayout.Parent = gridScroll

local gridPad = Instance.new("UIPadding")
gridPad.PaddingLeft = UDim.new(0, 6)
gridPad.PaddingTop  = UDim.new(0, 6)
gridPad.Parent = gridScroll

-- Milestone toast
local toastFrame = Instance.new("Frame")
toastFrame.Size = UDim2.new(0, 300, 0, 60)
toastFrame.Position = UDim2.new(0.5, -150, 0, 90)
toastFrame.BackgroundColor3 = C_GOLD
toastFrame.BorderSizePixel = 0
toastFrame.Visible = false
toastFrame.ZIndex = 30
toastFrame.Parent = gui
corner(toastFrame, 10)

local toastLbl = Instance.new("TextLabel")
toastLbl.Size = UDim2.new(1, -16, 1, 0)
toastLbl.Position = UDim2.new(0, 8, 0, 0)
toastLbl.BackgroundTransparency = 1
toastLbl.Text = ""
toastLbl.TextColor3 = C_BG
toastLbl.TextSize = 15
toastLbl.Font = Enum.Font.GothamBold
toastLbl.TextWrapped = true
toastLbl.ZIndex = 31
toastLbl.Parent = toastFrame

-- ─── STATE ────────────────────────────────────────────────────────────────────

local journalData = {}  -- { [speciesId] = true }
local speciesCards = {} -- [speciesId] = Frame

local function rebuildGrid()
	for _, card in pairs(speciesCards) do card:Destroy() end
	speciesCards = {}

	local discovered = 0
	for _ in pairs(journalData) do discovered += 1 end

	countLbl.Text = discovered .. " / " .. #Config.SPECIES .. " discovered"

	-- Update milestone labels
	for _, m in ipairs(MILESTONES) do
		local ml = milestoneLabels[m]
		if ml then
			ml.TextColor3 = (discovered >= m) and C_GOLD or C_MUTED
		end
	end

	for _, sp in ipairs(Config.SPECIES) do
		local isDiscovered = journalData[sp.id] == true
		local tierColor    = TIER_COLORS[sp.tier] or C_WHITE

		local card = Instance.new("Frame")
		card.Size = UDim2.new(0, 72, 0, 80)
		card.BackgroundColor3 = isDiscovered and C_BG or C_GREY
		card.BorderSizePixel = 0
		card.ZIndex = 17
		card.Parent = gridScroll
		corner(card, 8)
		speciesCards[sp.id] = card

		-- Color dot (tier indicator)
		local dot = Instance.new("Frame")
		dot.Size = UDim2.new(0, 36, 0, 36)
		dot.Position = UDim2.new(0.5, -18, 0, 6)
		dot.BackgroundColor3 = isDiscovered and tierColor or Color3.fromRGB(30, 25, 45)
		dot.BorderSizePixel = 0
		dot.ZIndex = 18
		dot.Parent = card
		corner(dot, 18)

		local nameLbl = Instance.new("TextLabel")
		nameLbl.Size = UDim2.new(1, -4, 0, 14)
		nameLbl.Position = UDim2.new(0, 2, 0, 46)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = isDiscovered and sp.name or "???"
		nameLbl.TextColor3 = isDiscovered and C_WHITE or C_MUTED
		nameLbl.TextSize = 9
		nameLbl.Font = Enum.Font.Gotham
		nameLbl.TextWrapped = true
		nameLbl.TextXAlignment = Enum.TextXAlignment.Center
		nameLbl.ZIndex = 18
		nameLbl.Parent = card

		local tierLbl = Instance.new("TextLabel")
		tierLbl.Size = UDim2.new(1, -4, 0, 12)
		tierLbl.Position = UDim2.new(0, 2, 0, 62)
		tierLbl.BackgroundTransparency = 1
		tierLbl.Text = isDiscovered and sp.tier or ""
		tierLbl.TextColor3 = isDiscovered and tierColor or C_MUTED
		tierLbl.TextSize = 8
		tierLbl.Font = Enum.Font.Gotham
		tierLbl.TextXAlignment = Enum.TextXAlignment.Center
		tierLbl.ZIndex = 18
		tierLbl.Parent = card
	end

	-- Update canvas size
	local rows = math.ceil(#Config.SPECIES / 5)
	gridScroll.CanvasSize = UDim2.new(0, 0, 0, rows * 86 + 12)
end

local function showToast(msg: string)
	toastLbl.Text = msg
	toastFrame.Visible = true
	toastFrame.BackgroundTransparency = 0
	toastLbl.TextTransparency = 0

	task.delay(3, function()
		TweenService:Create(toastFrame, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(toastLbl,   TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
		task.delay(0.5, function() toastFrame.Visible = false end)
	end)
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

local JournalUI = {}

function JournalUI.show()
	panel.Visible = true
	rebuildGrid()
end

function JournalUI.hide()
	panel.Visible = false
end

function JournalUI.isVisible(): boolean
	return panel.Visible
end

closeBtn.Activated:Connect(function()
	JournalUI.hide()
end)

-- ─── REMOTE LISTENERS ─────────────────────────────────────────────────────────

JournalUpdated.OnClientEvent:Connect(function(data: table)
	journalData = data or {}
	if panel.Visible then rebuildGrid() end
end)

MilestoneReached.OnClientEvent:Connect(function(count: number, reward: table)
	local rewardText = ""
	if reward.spores and reward.spores > 0 then
		local n = reward.spores
		if n >= 1e6 then rewardText = string.format("%.1fM spores", n/1e6)
		elseif n >= 1e3 then rewardText = string.format("%.1fK spores", n/1e3)
		else rewardText = tostring(n) .. " spores" end
	end
	showToast("Journal Milestone! " .. count .. " species discovered — +" .. rewardText)
end)

return JournalUI
