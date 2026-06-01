-- TournamentController: minimal v1 listener for "Road to The Bear" progress.
-- Surfaces a small HUD card on stage completion + bearPreview cue.
-- A full journal UI is v1.1; this just ensures progress is visible.

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local TournamentController = {}

local remotes: { [string]: RemoteEvent } = {}
local localPlayer = Players.LocalPlayer
local playerGui   = localPlayer:WaitForChild("PlayerGui")

local gui: ScreenGui
local card: Frame
local title: TextLabel
local body: TextLabel

local function buildToast()
	gui = Instance.new("ScreenGui")
	gui.Name           = "TournamentGui"
	gui.ResetOnSpawn   = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder   = 30
	gui.Parent         = playerGui

	card = Instance.new("Frame")
	card.Size              = UDim2.fromOffset(340, 96)
	card.Position          = UDim2.new(0.5, -170, 0, -120) -- offscreen by default
	card.BackgroundColor3  = Color3.fromRGB(30, 20, 50)
	card.BorderSizePixel   = 0
	card.Parent            = gui
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

	title = Instance.new("TextLabel")
	title.Size              = UDim2.new(1, -16, 0, 32)
	title.Position          = UDim2.fromOffset(8, 8)
	title.BackgroundTransparency = 1
	title.TextColor3        = Color3.fromRGB(255, 200, 80)
	title.Font              = Enum.Font.GothamBold
	title.TextScaled        = true
	title.Text              = ""
	title.TextXAlignment    = Enum.TextXAlignment.Left
	title.Parent            = card

	body = Instance.new("TextLabel")
	body.Size              = UDim2.new(1, -16, 0, 48)
	body.Position          = UDim2.fromOffset(8, 42)
	body.BackgroundTransparency = 1
	body.TextColor3        = Color3.new(1, 1, 1)
	body.Font              = Enum.Font.Gotham
	body.TextScaled        = true
	body.Text              = ""
	body.TextWrapped       = true
	body.TextXAlignment    = Enum.TextXAlignment.Left
	body.Parent            = card
end

local function showToast(titleText: string, bodyText: string, duration: number?)
	title.Text = titleText
	body.Text  = bodyText
	card.Position = UDim2.new(0.5, -170, 0, -120)
	TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -170, 0, 20),
	}):Play()
	task.delay(duration or 4, function()
		if title.Text ~= titleText then return end -- newer toast replaced us
		TweenService:Create(card, TweenInfo.new(0.3), {
			Position = UDim2.new(0.5, -170, 0, -120),
		}):Play()
	end)
end

local function onUpdate(payload: any)
	if typeof(payload) ~= "table" then return end
	if payload.bearPreview then
		showToast("THE BEAR APPROACHES", "Arc complete. Boss fight coming soon.", 6)
		return
	end
	if payload.stageCompleted then
		local reward = payload.stageCompleted.reward and payload.stageCompleted.reward.title or "Stage cleared"
		showToast("Stage " .. tostring(payload.stageCompleted.id) .. " complete", reward, 5)
		return
	end
	-- Quiet progress update — no toast. The journal UI (v1.1) will render this.
end

function TournamentController.init(remotesFolder: Folder)
	remotes.TournamentProgressUpdate = remotesFolder:WaitForChild("TournamentProgressUpdate") :: RemoteEvent
	buildToast()
	remotes.TournamentProgressUpdate.OnClientEvent:Connect(onUpdate)
end

return TournamentController
