-- PetDenUI.client.luau
-- Shows owned pets in a grid with 2 active slots.
-- Fires SetActivePets to server when active selection changes.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local Remotes       = ReplicatedStorage:WaitForChild("Remotes")
local SetActivePets = Remotes:WaitForChild("SetActivePets")
local PetState      = Remotes:WaitForChild("PetState")

-- ─── PALETTE ─────────────────────────────────────────────────────────────────

local C_BG    = Color3.fromRGB(12, 10, 22)
local C_PANEL = Color3.fromRGB(22, 18, 40)
local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_GREEN = Color3.fromRGB(70, 185, 110)
local C_GOLD  = Color3.fromRGB(255, 200, 55)
local C_GREY  = Color3.fromRGB(60, 55, 80)
local C_WHITE = Color3.fromRGB(215, 210, 250)
local C_MUTED = Color3.fromRGB(120, 112, 155)

local PET_COLORS = {
	mole    = Color3.fromRGB(130, 100, 70),
	cricket = Color3.fromRGB(80, 160, 80),
}

local function corner(p, r)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
end

-- ─── BUILD PANEL ─────────────────────────────────────────────────────────────

local gui = Instance.new("ScreenGui")
gui.Name = "PetDenUI"; gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local panel = Instance.new("Frame")
panel.Name = "PetDenPanel"
panel.Size = UDim2.new(0, 340, 0, 420)
panel.Position = UDim2.new(0.5, -170, 0.5, -210)
panel.BackgroundColor3 = C_PANEL
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 15
panel.Parent = gui
corner(panel, 12)

-- Title bar
local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -16, 0, 30)
titleLbl.Position = UDim2.new(0, 8, 0, 8)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Pet Den"
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

-- Active slots label
local activeLbl = Instance.new("TextLabel")
activeLbl.Size = UDim2.new(1, -16, 0, 20)
activeLbl.Position = UDim2.new(0, 8, 0, 44)
activeLbl.BackgroundTransparency = 1
activeLbl.Text = "Active Pets (up to 2)"
activeLbl.TextColor3 = C_MUTED
activeLbl.TextSize = 13
activeLbl.Font = Enum.Font.GothamBold
activeLbl.TextXAlignment = Enum.TextXAlignment.Left
activeLbl.ZIndex = 16
activeLbl.Parent = panel

-- Active slots display (2 fixed frames)
local activeFrames = {}
for i = 1, 2 do
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0, 130, 0, 40)
	f.Position = UDim2.new(0, 10 + (i-1)*150, 0, 68)
	f.BackgroundColor3 = C_GREY
	f.BorderSizePixel = 0
	f.ZIndex = 16
	f.Parent = panel
	corner(f, 6)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1,-8, 1, 0)
	lbl.Position = UDim2.new(0, 4, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = "Empty Slot"
	lbl.TextColor3 = C_MUTED
	lbl.TextSize = 13
	lbl.Font = Enum.Font.Gotham
	lbl.ZIndex = 17
	lbl.Parent = f

	activeFrames[i] = { frame = f, label = lbl }
end

-- Separator
local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, -20, 0, 1)
sep.Position = UDim2.new(0, 10, 0, 115)
sep.BackgroundColor3 = C_GREY
sep.BorderSizePixel = 0
sep.ZIndex = 16
sep.Parent = panel

-- Owned pets grid container
local ownedLbl = Instance.new("TextLabel")
ownedLbl.Size = UDim2.new(1, -16, 0, 20)
ownedLbl.Position = UDim2.new(0, 8, 0, 120)
ownedLbl.BackgroundTransparency = 1
ownedLbl.Text = "Owned Pets"
ownedLbl.TextColor3 = C_MUTED
ownedLbl.TextSize = 13
ownedLbl.Font = Enum.Font.GothamBold
ownedLbl.TextXAlignment = Enum.TextXAlignment.Left
ownedLbl.ZIndex = 16
ownedLbl.Parent = panel

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -148)
scrollFrame.Position = UDim2.new(0, 5, 0, 145)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = C_CYAN
scrollFrame.ZIndex = 16
scrollFrame.Parent = panel

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 90, 0, 90)
gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
gridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
gridLayout.Parent = scrollFrame

local gridPadding = Instance.new("UIPadding")
gridPadding.PaddingLeft = UDim.new(0, 6)
gridPadding.PaddingTop  = UDim.new(0, 6)
gridPadding.Parent = scrollFrame

-- Empty state label
local emptyLbl = Instance.new("TextLabel")
emptyLbl.Size = UDim2.new(1, -16, 1, -148)
emptyLbl.Position = UDim2.new(0, 8, 0, 148)
emptyLbl.BackgroundTransparency = 1
emptyLbl.Text = "No pets yet — fish mole holes or catch crickets!"
emptyLbl.TextColor3 = C_MUTED
emptyLbl.TextSize = 13
emptyLbl.Font = Enum.Font.Gotham
emptyLbl.TextWrapped = true
emptyLbl.ZIndex = 16
emptyLbl.Parent = panel

-- ─── STATE ────────────────────────────────────────────────────────────────────

local petsData   = { owned = {}, active = {} }
local petCards   = {}  -- [petId] = Frame
local activeSet  = {}  -- [petId] = true

local function isActive(petId: string): boolean
	for _, id in ipairs(petsData.active or {}) do
		if id == petId then return true end
	end
	return false
end

local function buildActiveDisplay()
	local active = petsData.active or {}
	local owned  = petsData.owned  or {}

	-- Build lookup
	local ownedById = {}
	for _, pet in ipairs(owned) do
		ownedById[pet.id] = pet
	end

	for i = 1, 2 do
		local frame = activeFrames[i]
		local id    = active[i]
		if id and ownedById[id] then
			local pet = ownedById[id]
			frame.label.Text = pet.species:sub(1,1):upper() .. pet.species:sub(2) .. " (" .. pet.variant .. ")"
			frame.frame.BackgroundColor3 = PET_COLORS[pet.species] or C_GREY
		else
			frame.label.Text = "Empty Slot"
			frame.frame.BackgroundColor3 = C_GREY
		end
	end
end

local function toggleActive(petId: string)
	local active = petsData.active or {}
	local newActive = {}

	local found = false
	for _, id in ipairs(active) do
		if id == petId then found = true
		else table.insert(newActive, id) end
	end

	if not found then
		if #newActive < 2 then
			table.insert(newActive, petId)
		end
	end

	petsData.active = newActive
	SetActivePets:FireServer(newActive)
	buildActiveDisplay()

	-- Refresh card colors
	for pid, card in pairs(petCards) do
		card.BackgroundColor3 = isActive(pid) and C_GREEN or C_GREY
	end
end

local function rebuildGrid()
	-- Clear old cards
	for _, card in pairs(petCards) do
		card:Destroy()
	end
	petCards = {}

	local owned = petsData.owned or {}
	emptyLbl.Visible = #owned == 0

	for _, pet in ipairs(owned) do
		local card = Instance.new("TextButton")
		card.Size = UDim2.new(0, 90, 0, 90)
		card.BackgroundColor3 = isActive(pet.id) and C_GREEN or C_GREY
		card.BorderSizePixel = 0
		card.Text = ""
		card.ZIndex = 17
		card.Parent = scrollFrame
		corner(card, 8)

		local circle = Instance.new("Frame")
		circle.Size = UDim2.new(0, 48, 0, 48)
		circle.Position = UDim2.new(0.5, -24, 0, 6)
		circle.BackgroundColor3 = PET_COLORS[pet.species] or C_GREY
		circle.BorderSizePixel = 0
		circle.ZIndex = 18
		circle.Parent = card
		corner(circle, 24)

		local nameLbl = Instance.new("TextLabel")
		nameLbl.Size = UDim2.new(1, -4, 0, 18)
		nameLbl.Position = UDim2.new(0, 2, 0, 58)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = pet.species:sub(1,1):upper() .. pet.species:sub(2)
		nameLbl.TextColor3 = C_WHITE
		nameLbl.TextSize = 11
		nameLbl.Font = Enum.Font.GothamBold
		nameLbl.TextXAlignment = Enum.TextXAlignment.Center
		nameLbl.ZIndex = 18
		nameLbl.Parent = card

		local varLbl = Instance.new("TextLabel")
		varLbl.Size = UDim2.new(1, -4, 0, 14)
		varLbl.Position = UDim2.new(0, 2, 0, 74)
		varLbl.BackgroundTransparency = 1
		varLbl.Text = pet.variant
		varLbl.TextColor3 = C_MUTED
		varLbl.TextSize = 10
		varLbl.Font = Enum.Font.Gotham
		varLbl.TextXAlignment = Enum.TextXAlignment.Center
		varLbl.ZIndex = 18
		varLbl.Parent = card

		petCards[pet.id] = card

		card.Activated:Connect(function()
			toggleActive(pet.id)
		end)
	end

	-- Update canvas size
	local rows = math.ceil(#owned / 3)
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, rows * 98 + 12)
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

local PetDenUI = {}

function PetDenUI.show()
	panel.Visible = true
end

function PetDenUI.hide()
	panel.Visible = false
end

function PetDenUI.isVisible(): boolean
	return panel.Visible
end

closeBtn.Activated:Connect(function()
	PetDenUI.hide()
end)

-- ─── REMOTE LISTENER ─────────────────────────────────────────────────────────

PetState.OnClientEvent:Connect(function(data: table)
	petsData = data or { owned = {}, active = {} }
	rebuildGrid()
	buildActiveDisplay()
end)

return PetDenUI
