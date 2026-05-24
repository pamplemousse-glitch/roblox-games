-- TutorialManager: guides new players through the core loop
-- Steps: spores → shop button → species tab → buy mushroom → done
-- Shown only when player has just the starting "button" species.

local TweenService = game:GetService("TweenService")

local TutorialManager = {}

local C_BG    = Color3.fromRGB(12, 10, 22)
local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_GOLD  = Color3.fromRGB(255, 200, 55)
local C_WHITE = Color3.fromRGB(215, 210, 250)
local C_MUTED = Color3.fromRGB(120, 112, 155)

local STEPS = {
	{ text = "🍄  Welcome! Your cave grows Spores automatically while you're here.",  sub = "Watch the counter above fill up!"                  },
	{ text = "💰  Time to spend! Open the Shop to see what's available.",              sub = "Tap the SHOP button →"                             },
	{ text = "🌿  Head to the SPECIES tab to discover new mushrooms.",                 sub = "Each one produces Spores passively!"               },
	{ text = "✨  Buy your first mushroom — it'll appear on a pedestal in your cave.", sub = "More species = more Spores per second!"            },
}

local step       = 0
local completed  = false
local panel      = nil
local titleLbl   = nil
local subLbl     = nil
local tw         = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- refs set on init
local shopBtnRef   = nil
local tabSpRef     = nil
local shopPanelRef = nil

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function corner(p, r)
	local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r) c.Parent = p
end

local function fadePanel(visible: boolean)
	if not panel then return end
	local target = visible and 0.08 or 1
	TweenService:Create(panel, tw, { BackgroundTransparency = target }):Play()
	for _, lbl in ipairs({ titleLbl, subLbl }) do
		if lbl then
			TweenService:Create(lbl, tw, { TextTransparency = visible and 0 or 1 }):Play()
		end
	end
	panel.Visible = true
	if not visible then
		task.delay(0.4, function() if panel then panel.Visible = false end end)
	end
end

local function showStep(n: number)
	if completed or not STEPS[n] then return end
	step = n
	local s = STEPS[n]
	if titleLbl then titleLbl.Text = s.text end
	if subLbl   then subLbl.Text   = s.sub  end
	fadePanel(true)
end

local function finish()
	if completed then return end
	completed = true
	if titleLbl then titleLbl.Text = "🎉  You're all set! Check back later to collect Spores." end
	if subLbl   then subLbl.Text   = "Tip: buy more species, upgrade your cave, and come back!" end
	fadePanel(true)
	task.delay(5, function() fadePanel(false) end)
end

-- ─── PUBLIC API ──────────────────────────────────────────────────────────────

function TutorialManager.init(gui: ScreenGui, getState, shopBtn, tabSp, shopPnl)
	shopBtnRef   = shopBtn
	tabSpRef     = tabSp
	shopPanelRef = shopPnl

	-- Build floating tip panel (anchored to bottom-centre, just above nav)
	panel = Instance.new("Frame")
	panel.Name              = "TutorialPanel"
	panel.Size              = UDim2.new(0, 420, 0, 72)
	panel.Position          = UDim2.new(0.5, -210, 1, -130)
	panel.BackgroundColor3  = C_BG
	panel.BackgroundTransparency = 1
	panel.BorderSizePixel   = 0
	panel.ZIndex            = 10
	panel.Visible           = false
	panel.Parent            = gui
	corner(panel, 12)

	-- Pulsing cyan border suggestion via a UIStroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = C_CYAN
	stroke.Thickness = 1.5
	stroke.Transparency = 0.4
	stroke.Parent = panel

	titleLbl = Instance.new("TextLabel")
	titleLbl.Size               = UDim2.new(1, -80, 0, 28)
	titleLbl.Position           = UDim2.new(0, 12, 0, 8)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text               = ""
	titleLbl.TextColor3         = C_GOLD
	titleLbl.TextSize           = 14
	titleLbl.Font               = Enum.Font.GothamBold
	titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
	titleLbl.TextWrapped        = true
	titleLbl.TextTransparency   = 1
	titleLbl.ZIndex             = 11
	titleLbl.Parent             = panel

	subLbl = Instance.new("TextLabel")
	subLbl.Size                 = UDim2.new(1, -80, 0, 20)
	subLbl.Position             = UDim2.new(0, 12, 0, 40)
	subLbl.BackgroundTransparency = 1
	subLbl.Text                 = ""
	subLbl.TextColor3           = C_MUTED
	subLbl.TextSize             = 12
	subLbl.Font                 = Enum.Font.Gotham
	subLbl.TextXAlignment       = Enum.TextXAlignment.Left
	subLbl.TextTransparency     = 1
	subLbl.ZIndex               = 11
	subLbl.Parent               = panel

	-- Skip button
	local skipBtn = Instance.new("TextButton")
	skipBtn.Size              = UDim2.new(0, 52, 0, 28)
	skipBtn.Position          = UDim2.new(1, -62, 0.5, -14)
	skipBtn.BackgroundTransparency = 1
	skipBtn.Text              = "Skip"
	skipBtn.TextColor3        = C_MUTED
	skipBtn.TextSize          = 12
	skipBtn.Font              = Enum.Font.Gotham
	skipBtn.ZIndex            = 12
	skipBtn.Parent            = panel
	skipBtn.Activated:Connect(function()
		completed = true
		fadePanel(false)
	end)
end

-- Called by GameClient when SyncData arrives
function TutorialManager.onSyncData(state)
	if completed then return end
	-- Only show tutorial if player has only the starting mushroom
	local onlyButton = #state.ownedSpecies <= 1
	if not onlyButton then
		completed = true
		fadePanel(false)
		return
	end
	if step == 0 then
		showStep(1)
		-- Auto-advance to step 2 after 8 seconds if still on step 1
		task.delay(8, function()
			if step == 1 and not completed then showStep(2) end
		end)
	end
end

-- Called by GameClient when shop opens
function TutorialManager.onShopOpened()
	if completed or step < 2 then return end
	if step == 2 then showStep(3) end
end

-- Called by GameClient when SPECIES tab selected
function TutorialManager.onSpeciesTabOpened()
	if completed or step < 3 then return end
	if step == 3 then showStep(4) end
end

-- Called by GameClient when a species is purchased
function TutorialManager.onSpeciesBought()
	if completed then return end
	finish()
end

return TutorialManager
