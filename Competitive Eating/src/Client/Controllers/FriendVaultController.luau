-- Minimal Friend Vault UI: balance label + deposit / withdraw buttons.
-- Server is authoritative — buttons just fire requests; server replies with the
-- new (success, balance, coins) tuple over the same RemoteEvent.

local Players = game:GetService("Players")

local FriendVaultController = {}

local DEPOSIT_AMOUNT  = 100
local WITHDRAW_AMOUNT = 100

local localPlayer = Players.LocalPlayer
local playerGui   = localPlayer:WaitForChild("PlayerGui")

local depositRemote: RemoteEvent
local withdrawRemote: RemoteEvent

local balanceLabel: TextLabel
local flashLabel: TextLabel
local currentBalance = 0

-- ── UI build ──────────────────────────────────────────────────────────────────

local function build()
	local gui = Instance.new("ScreenGui")
	gui.Name           = "FriendVaultGui"
	gui.ResetOnSpawn   = false
	gui.IgnoreGuiInset = true
	gui.Parent         = playerGui

	local panel = Instance.new("Frame")
	panel.Name             = "Panel"
	panel.Size             = UDim2.fromOffset(220, 130)
	panel.Position         = UDim2.new(1, -240, 0, 20)
	panel.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	panel.BorderSizePixel  = 0
	panel.Parent           = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = panel

	local title = Instance.new("TextLabel")
	title.Size                   = UDim2.new(1, -16, 0, 22)
	title.Position               = UDim2.fromOffset(8, 6)
	title.BackgroundTransparency = 1
	title.Text                   = "Friend Vault"
	title.TextColor3             = Color3.fromRGB(255, 220, 120)
	title.TextScaled             = true
	title.Font                   = Enum.Font.GothamBold
	title.TextXAlignment         = Enum.TextXAlignment.Left
	title.Parent                 = panel

	balanceLabel = Instance.new("TextLabel")
	balanceLabel.Name                  = "Balance"
	balanceLabel.Size                  = UDim2.new(1, -16, 0, 28)
	balanceLabel.Position              = UDim2.fromOffset(8, 30)
	balanceLabel.BackgroundTransparency = 1
	balanceLabel.Text                  = "0 / 10000"
	balanceLabel.TextColor3            = Color3.new(1, 1, 1)
	balanceLabel.TextScaled            = true
	balanceLabel.Font                  = Enum.Font.Gotham
	balanceLabel.TextXAlignment        = Enum.TextXAlignment.Left
	balanceLabel.Parent                = panel

	local function makeButton(name: string, text: string, posY: number, color: Color3): TextButton
		local btn = Instance.new("TextButton")
		btn.Name             = name
		btn.Size             = UDim2.new(1, -16, 0, 28)
		btn.Position         = UDim2.fromOffset(8, posY)
		btn.BackgroundColor3 = color
		btn.BorderSizePixel  = 0
		btn.Text             = text
		btn.TextColor3       = Color3.new(1, 1, 1)
		btn.TextScaled       = true
		btn.Font             = Enum.Font.GothamBold
		btn.AutoButtonColor  = true
		btn.Parent           = panel

		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 6)
		c.Parent = btn
		return btn
	end

	local depositBtn  = makeButton("Deposit",  "Deposit +"  .. DEPOSIT_AMOUNT,  64, Color3.fromRGB(60, 140, 80))
	local withdrawBtn = makeButton("Withdraw", "Withdraw -" .. WITHDRAW_AMOUNT, 96, Color3.fromRGB(140, 80, 60))

	flashLabel = Instance.new("TextLabel")
	flashLabel.Size                   = UDim2.new(1, -16, 0, 16)
	flashLabel.Position               = UDim2.new(0, 8, 1, -20)
	flashLabel.BackgroundTransparency = 1
	flashLabel.Text                   = ""
	flashLabel.TextColor3             = Color3.fromRGB(255, 120, 120)
	flashLabel.TextScaled             = true
	flashLabel.Font                   = Enum.Font.Gotham
	flashLabel.TextXAlignment         = Enum.TextXAlignment.Left
	flashLabel.Parent                 = panel

	depositBtn.Activated:Connect(function()
		depositRemote:FireServer(DEPOSIT_AMOUNT)
	end)
	withdrawBtn.Activated:Connect(function()
		withdrawRemote:FireServer(WITHDRAW_AMOUNT)
	end)
end

-- ── Server replies ────────────────────────────────────────────────────────────

local function flash(msg: string)
	if not flashLabel then return end
	flashLabel.Text = msg
	task.delay(2, function()
		if flashLabel and flashLabel.Text == msg then
			flashLabel.Text = ""
		end
	end)
end

local function onDepositReply(success: boolean, newBalance: number, _newCoins: number)
	currentBalance = newBalance or currentBalance
	balanceLabel.Text = string.format("%d / 10000", currentBalance)
	if not success then flash("Deposit failed") end
end

local function onWithdrawReply(success: boolean, newBalance: number, _newCoins: number)
	currentBalance = newBalance or currentBalance
	balanceLabel.Text = string.format("%d / 10000", currentBalance)
	if not success then flash("Withdraw failed") end
end

-- ── Init ──────────────────────────────────────────────────────────────────────

function FriendVaultController.init(remotesFolder: Folder)
	depositRemote  = remotesFolder:WaitForChild("DepositToVault")    :: RemoteEvent
	withdrawRemote = remotesFolder:WaitForChild("WithdrawFromVault") :: RemoteEvent

	build()

	depositRemote.OnClientEvent:Connect(onDepositReply)
	withdrawRemote.OnClientEvent:Connect(onWithdrawReply)
end

return FriendVaultController
