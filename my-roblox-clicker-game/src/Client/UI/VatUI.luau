-- VatUI.client.luau
-- Mycology Vat panel: brew potions from ingredients, use potions.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local Remotes    = ReplicatedStorage:WaitForChild("Remotes")
local BrewPotion = Remotes:WaitForChild("BrewPotion")
local UsePotion  = Remotes:WaitForChild("UsePotion")
local VatState   = Remotes:WaitForChild("VatState")

local Config = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("Config"))

local SoundService = game:GetService("SoundService")
local function playVatSound(id: number)
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://" .. id
	s.Volume = 0.7; s.Parent = SoundService; s:Play()
	task.delay(math.max(s.TimeLength, 0.5) + 0.3, function() s:Destroy() end)
end
local VAT_BREW_START_ID    = 7322736504
local VAT_BREW_DONE_ID     = 9126073011
local VAT_USE_POTION_ID    = 1481574895

-- ─── PALETTE ─────────────────────────────────────────────────────────────────

local C_BG    = Color3.fromRGB(12, 10, 22)
local C_PANEL = Color3.fromRGB(22, 18, 40)
local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_GREEN = Color3.fromRGB(70, 185, 110)
local C_GREY  = Color3.fromRGB(60, 55, 80)
local C_GOLD  = Color3.fromRGB(255, 200, 55)
local C_WHITE = Color3.fromRGB(215, 210, 250)
local C_MUTED = Color3.fromRGB(120, 112, 155)

local function corner(p, r)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
end

-- ─── BUILD UI ────────────────────────────────────────────────────────────────

local gui = Instance.new("ScreenGui")
gui.Name = "VatUI"; gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local panel = Instance.new("Frame")
panel.Name = "VatPanel"
panel.Size = UDim2.new(0, 360, 0, 500)
panel.Position = UDim2.new(0.5, -180, 0.5, -250)
panel.BackgroundColor3 = C_PANEL
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 15
panel.Parent = gui
corner(panel, 12)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -16, 0, 30)
titleLbl.Position = UDim2.new(0, 8, 0, 8)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Mycology Vat"
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

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -48)
scrollFrame.Position = UDim2.new(0, 5, 0, 44)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = C_CYAN
scrollFrame.ZIndex = 16
scrollFrame.Parent = panel

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = scrollFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingLeft  = UDim.new(0, 6)
listPadding.PaddingTop   = UDim.new(0, 6)
listPadding.PaddingRight = UDim.new(0, 6)
listPadding.Parent = scrollFrame

-- ─── STATE ────────────────────────────────────────────────────────────────────

local vatData = { ingredients = {}, brews = {} }

local function canBrewRecipe(recipe: table): boolean
	for ingredId, needed in pairs(recipe.ingredients) do
		if (vatData.ingredients[ingredId] or 0) < needed then return false end
	end
	return true
end

local function buildIngredientText(recipe: table): string
	local parts = {}
	for ingredId, needed in pairs(recipe.ingredients) do
		local have = vatData.ingredients[ingredId] or 0
		table.insert(parts, ingredId .. ": " .. have .. "/" .. needed)
	end
	return table.concat(parts, "  |  ")
end

local recipeRows  = {}
local brewRows    = {}

local function rebuild()
	-- Clear old rows
	for _, r in ipairs(recipeRows)  do r:Destroy() end
	for _, r in ipairs(brewRows)    do r:Destroy() end
	recipeRows = {}
	brewRows   = {}

	local layoutOrder = 1

	-- Section: Recipes
	local recipeHeader = Instance.new("TextLabel")
	recipeHeader.Size = UDim2.new(1, -12, 0, 22)
	recipeHeader.BackgroundTransparency = 1
	recipeHeader.Text = "Recipes"
	recipeHeader.TextColor3 = C_GOLD
	recipeHeader.TextSize = 14
	recipeHeader.Font = Enum.Font.GothamBold
	recipeHeader.TextXAlignment = Enum.TextXAlignment.Left
	recipeHeader.LayoutOrder = layoutOrder
	recipeHeader.ZIndex = 17
	recipeHeader.Parent = scrollFrame
	table.insert(recipeRows, recipeHeader)
	layoutOrder += 1

	for _, recipe in ipairs(Config.VAT_RECIPES) do
		local canBrew = canBrewRecipe(recipe)

		local row = Instance.new("Frame")
		row.Name = "Recipe_" .. recipe.id
		row.Size = UDim2.new(1, -12, 0, 68)
		row.BackgroundColor3 = C_BG
		row.BorderSizePixel = 0
		row.LayoutOrder = layoutOrder
		row.ZIndex = 17
		row.Parent = scrollFrame
		corner(row, 8)
		table.insert(recipeRows, row)
		layoutOrder += 1

		local nameLbl = Instance.new("TextLabel")
		nameLbl.Size = UDim2.new(1, -16, 0, 20)
		nameLbl.Position = UDim2.new(0, 8, 0, 6)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = recipe.name
		nameLbl.TextColor3 = canBrew and C_GREEN or C_WHITE
		nameLbl.TextSize = 14
		nameLbl.Font = Enum.Font.GothamBold
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left
		nameLbl.ZIndex = 18
		nameLbl.Parent = row

		local ingredLbl = Instance.new("TextLabel")
		ingredLbl.Size = UDim2.new(1, -100, 0, 16)
		ingredLbl.Position = UDim2.new(0, 8, 0, 28)
		ingredLbl.BackgroundTransparency = 1
		ingredLbl.Text = buildIngredientText(recipe)
		ingredLbl.TextColor3 = C_MUTED
		ingredLbl.TextSize = 11
		ingredLbl.Font = Enum.Font.Gotham
		ingredLbl.TextXAlignment = Enum.TextXAlignment.Left
		ingredLbl.TextTruncate = Enum.TextTruncate.AtEnd
		ingredLbl.ZIndex = 18
		ingredLbl.Parent = row

		local brewBtn = Instance.new("TextButton")
		brewBtn.Size = UDim2.new(0, 80, 0, 28)
		brewBtn.Position = UDim2.new(1, -90, 0, 20)
		brewBtn.BackgroundColor3 = canBrew and C_GREEN or C_GREY
		brewBtn.BorderSizePixel = 0
		brewBtn.Text = "Brew"
		brewBtn.TextColor3 = Color3.new(1, 1, 1)
		brewBtn.TextSize = 13
		brewBtn.Font = Enum.Font.GothamBold
		brewBtn.ZIndex = 18
		brewBtn.Parent = row
		corner(brewBtn, 5)

		local effectLbl = Instance.new("TextLabel")
		effectLbl.Size = UDim2.new(1, -100, 0, 14)
		effectLbl.Position = UDim2.new(0, 8, 0, 48)
		effectLbl.BackgroundTransparency = 1
		local eff = Config.POTION_EFFECTS[recipe.output]
		effectLbl.Text = eff and ("Effect: " .. eff.type .. (eff.duration and " " .. eff.duration .. "s" or "")) or ""
		effectLbl.TextColor3 = C_MUTED
		effectLbl.TextSize = 10
		effectLbl.Font = Enum.Font.Gotham
		effectLbl.TextXAlignment = Enum.TextXAlignment.Left
		effectLbl.ZIndex = 18
		effectLbl.Parent = row

		if canBrew then
			brewBtn.Activated:Connect(function()
				playVatSound(VAT_BREW_START_ID)
				BrewPotion:FireServer(recipe.id)
			end)
		end
	end

	-- Section: Potions inventory
	local hasBrew = false
	for _, v in pairs(vatData.brews) do if v > 0 then hasBrew = true; break end end

	if hasBrew then
		local brewHeader = Instance.new("TextLabel")
		brewHeader.Size = UDim2.new(1, -12, 0, 22)
		brewHeader.BackgroundTransparency = 1
		brewHeader.Text = "Potions Inventory"
		brewHeader.TextColor3 = C_GOLD
		brewHeader.TextSize = 14
		brewHeader.Font = Enum.Font.GothamBold
		brewHeader.TextXAlignment = Enum.TextXAlignment.Left
		brewHeader.LayoutOrder = layoutOrder
		brewHeader.ZIndex = 17
		brewHeader.Parent = scrollFrame
		table.insert(brewRows, brewHeader)
		layoutOrder += 1

		for potionId, count in pairs(vatData.brews) do
			if count > 0 then
				local eff = Config.POTION_EFFECTS[potionId]

				local row = Instance.new("Frame")
				row.Size = UDim2.new(1, -12, 0, 50)
				row.BackgroundColor3 = C_BG
				row.BorderSizePixel = 0
				row.LayoutOrder = layoutOrder
				row.ZIndex = 17
				row.Parent = scrollFrame
				corner(row, 8)
				table.insert(brewRows, row)
				layoutOrder += 1

				local pNameLbl = Instance.new("TextLabel")
				pNameLbl.Size = UDim2.new(1, -100, 0, 20)
				pNameLbl.Position = UDim2.new(0, 8, 0, 6)
				pNameLbl.BackgroundTransparency = 1
				pNameLbl.Text = potionId .. " ×" .. count
				pNameLbl.TextColor3 = C_CYAN
				pNameLbl.TextSize = 13
				pNameLbl.Font = Enum.Font.GothamBold
				pNameLbl.TextXAlignment = Enum.TextXAlignment.Left
				pNameLbl.ZIndex = 18
				pNameLbl.Parent = row

				local pEffLbl = Instance.new("TextLabel")
				pEffLbl.Size = UDim2.new(1, -100, 0, 16)
				pEffLbl.Position = UDim2.new(0, 8, 0, 26)
				pEffLbl.BackgroundTransparency = 1
				pEffLbl.Text = eff and (eff.type .. (eff.duration and " " .. eff.duration .. "s" or "")) or "Unknown effect"
				pEffLbl.TextColor3 = C_MUTED
				pEffLbl.TextSize = 11
				pEffLbl.Font = Enum.Font.Gotham
				pEffLbl.TextXAlignment = Enum.TextXAlignment.Left
				pEffLbl.ZIndex = 18
				pEffLbl.Parent = row

				local useBtn = Instance.new("TextButton")
				useBtn.Size = UDim2.new(0, 80, 0, 28)
				useBtn.Position = UDim2.new(1, -90, 0, 11)
				useBtn.BackgroundColor3 = C_GOLD
				useBtn.BorderSizePixel = 0
				useBtn.Text = "Use"
				useBtn.TextColor3 = C_BG
				useBtn.TextSize = 13
				useBtn.Font = Enum.Font.GothamBold
				useBtn.ZIndex = 18
				useBtn.Parent = row
				corner(useBtn, 5)

				useBtn.Activated:Connect(function()
					playVatSound(VAT_USE_POTION_ID)
					UsePotion:FireServer(potionId)
				end)
			end
		end
	end

	-- Update canvas size
	local contentHeight = listLayout.AbsoluteContentSize.Y + 20
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

local VatUI = {}

function VatUI.show()
	panel.Visible = true
	rebuild()
end

function VatUI.hide()
	panel.Visible = false
end

function VatUI.isVisible(): boolean
	return panel.Visible
end

closeBtn.Activated:Connect(function()
	VatUI.hide()
end)

-- ─── REMOTE LISTENER ─────────────────────────────────────────────────────────

VatState.OnClientEvent:Connect(function(data: table)
	local newData = data or { ingredients = {}, brews = {} }
	-- Play completion sound if any brew count increased
	for potionId, count in pairs(newData.brews or {}) do
		if (count or 0) > (vatData.brews[potionId] or 0) then
			playVatSound(VAT_BREW_DONE_ID); break
		end
	end
	vatData = newData
	if panel.Visible then rebuild() end
end)

return VatUI
