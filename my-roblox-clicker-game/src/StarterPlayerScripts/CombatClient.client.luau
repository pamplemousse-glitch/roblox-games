-- CombatClient.client.luau
-- Weapon hotbar (keys 1/2), mob click-to-attack, visual hit flash.
-- Server owns all validation. This script only fires the remote and shows feedback.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")

local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer.PlayerGui
local Mouse        = LocalPlayer:GetMouse()
local Remotes      = ReplicatedStorage:WaitForChild("Remotes")
local PlayerAttack = Remotes:WaitForChild("PlayerAttack")

-- ─── WEAPON SLOTS ────────────────────────────────────────────────────────────
-- Melee + ranged; everyone starts with both.
-- flyagaric_flask (DOT) will be added via a WeaponGranted remote in a future phase.

local WEAPONS = {
	{ id = "truffle_trowel",  label = "Trowel",    key = "[1]", color = Color3.fromRGB(160, 110, 60) },
	{ id = "spore_launcher",  label = "Spore Gun",  key = "[2]", color = Color3.fromRGB(80, 180, 100) },
}

local equippedIdx   = 1
local clientCoolend = 0   -- tick() deadline for client-side spam gate

-- ─── HOTBAR UI ───────────────────────────────────────────────────────────────

local screenGui = Instance.new("ScreenGui")
screenGui.Name            = "WeaponHotbar"
screenGui.ResetOnSpawn    = false
screenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
screenGui.Parent          = PlayerGui

local hotbar = Instance.new("Frame")
hotbar.Name                = "Hotbar"
hotbar.Size                = UDim2.new(0, #WEAPONS * 110, 0, 54)
hotbar.Position            = UDim2.new(0.5, -#WEAPONS * 55, 1, -72)
hotbar.BackgroundTransparency = 1
hotbar.Parent              = screenGui

local slotButtons = {}

local function refreshHotbar()
	for i, entry in ipairs(slotButtons) do
		local selected = i == equippedIdx
		entry.btn.BackgroundColor3 = selected
			and Color3.fromRGB(70, 45, 100)
			or  Color3.fromRGB(25, 18, 35)
		entry.stroke.Color = selected
			and Color3.fromRGB(200, 140, 255)
			or  Color3.fromRGB(70, 55, 85)
	end
end

for i, wep in ipairs(WEAPONS) do
	local btn = Instance.new("TextButton")
	btn.Size               = UDim2.new(0, 104, 0, 50)
	btn.Position           = UDim2.new(0, (i - 1) * 110, 0, 0)
	btn.BackgroundColor3   = Color3.fromRGB(25, 18, 35)
	btn.BorderSizePixel    = 0
	btn.Text               = wep.label .. "\n" .. wep.key
	btn.TextColor3         = Color3.new(1, 1, 1)
	btn.TextSize           = 13
	btn.Font               = Enum.Font.GothamBold
	btn.Parent             = hotbar

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent       = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color     = Color3.fromRGB(70, 55, 85)
	stroke.Thickness = 2
	stroke.Parent    = btn

	local dot = Instance.new("Frame")
	dot.Size             = UDim2.new(0, 8, 0, 8)
	dot.Position         = UDim2.new(0.5, -4, 0, 4)
	dot.BackgroundColor3 = wep.color
	dot.BorderSizePixel  = 0
	dot.Parent           = btn
	local dc = Instance.new("UICorner")
	dc.CornerRadius = UDim.new(1, 0)
	dc.Parent       = dot

	local idx = i
	btn.Activated:Connect(function()
		equippedIdx = idx
		refreshHotbar()
	end)

	slotButtons[i] = { btn = btn, stroke = stroke }
end

refreshHotbar()

-- ─── KEYBOARD SHORTCUTS ──────────────────────────────────────────────────────

local KEY_MAP = {
	[Enum.KeyCode.One] = 1,
	[Enum.KeyCode.Two] = 2,
}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	local slot = KEY_MAP[input.KeyCode]
	if slot and WEAPONS[slot] then
		equippedIdx = slot
		refreshHotbar()
	end
end)

-- ─── ATTACK INPUT ────────────────────────────────────────────────────────────

local function flashMob(part: BasePart)
	local orig = part.Color
	part.Color = Color3.new(1, 1, 1)
	task.delay(0.08, function()
		if part and part.Parent then
			part.Color = orig
		end
	end)
end

Mouse.Button1Down:Connect(function()
	local target = Mouse.Target
	if not target then return end
	local mobId = target:GetAttribute("MobId")
	if not mobId then return end

	-- Conservative client gate — server is the real authority
	local now = tick()
	if now < clientCoolend then return end
	clientCoolend = now + 0.3

	local weaponId = WEAPONS[equippedIdx].id
	PlayerAttack:FireServer(weaponId, mobId)
	flashMob(target)
end)
