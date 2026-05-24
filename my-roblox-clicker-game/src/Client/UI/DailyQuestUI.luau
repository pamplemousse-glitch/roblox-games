-- DailyQuestUI.luau
-- Daily quest panel: 3 quest cards with progress bars and a Claim button per card.
-- Toggled via a QUESTS button in the nav bar (wired in GameClient).

local TweenService = game:GetService("TweenService")

local DailyQuestUI = {}

-- ─── PALETTE ─────────────────────────────────────────────────────────────────

local C_BG    = Color3.fromRGB(12, 10, 22)
local C_PANEL = Color3.fromRGB(22, 18, 40)
local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_GREEN = Color3.fromRGB(70, 185, 110)
local C_GOLD  = Color3.fromRGB(255, 200, 55)
local C_WHITE = Color3.fromRGB(215, 210, 250)
local C_MUTED = Color3.fromRGB(120, 112, 155)
local C_RED   = Color3.fromRGB(220, 70, 70)

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function fmt(n: number): string
	if n >= 1e6 then return string.format("%.1fM", n/1e6)
	elseif n >= 1e3 then return string.format("%.1fK", n/1e3)
	else return tostring(math.floor(n)) end
end

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
	l.TextColor3 = col or C_WHITE; l.TextSize = ts or 16
	l.Font = Enum.Font.GothamBold
	l.TextXAlignment = ax or Enum.TextXAlignment.Left; l.Parent = par; return l
end
local function btn(par, tx, sz, pos, bg, tc)
	local b = Instance.new("TextButton"); b.Size = sz; b.Position = pos
	b.BackgroundColor3 = bg or C_GREEN; b.BorderSizePixel = 0
	b.Text = tx; b.TextColor3 = tc or Color3.new(1,1,1)
	b.TextSize = 13; b.Font = Enum.Font.GothamBold
	b.Parent = par; corner(b, 6); return b
end

-- ─── INIT ─────────────────────────────────────────────────────────────────────

function DailyQuestUI.init(gui: ScreenGui, ClaimQuestReward: RemoteEvent): table

	-- ── Panel ─────────────────────────────────────────────────────────────────
	local panel = fr(gui, UDim2.new(0,420,0,380),
		UDim2.new(0.5,-210,0.5,-200), C_BG, 0.04)
	corner(panel, 14)
	local s = Instance.new("UIStroke"); s.Color = C_CYAN; s.Thickness = 1; s.Parent = panel
	panel.Visible = false; panel.ZIndex = 5
	local uiScale = Instance.new("UIScale"); uiScale.Scale = 1; uiScale.Parent = panel

	-- Header
	local header = lb(panel, "📋  DAILY QUESTS",
		UDim2.new(1,0,0,32), UDim2.new(0,0,0,10),
		C_CYAN, 18, Enum.TextXAlignment.Center)
	header.Font = Enum.Font.GothamBlack

	-- Resets at label (updated on open)
	local resetLbl = lb(panel, "Resets at UTC midnight",
		UDim2.new(1,0,0,18), UDim2.new(0,0,0,42),
		C_MUTED, 12, Enum.TextXAlignment.Center)

	-- Countdown to midnight
	task.spawn(function()
		while true do
			task.wait(30)
			local now     = os.time()
			local todayStart = math.floor(now / 86400) * 86400
			local midnight   = todayStart + 86400
			local rem = midnight - now
			local h = math.floor(rem / 3600)
			local m = math.floor((rem % 3600) / 60)
			resetLbl.Text = string.format("Resets in  %dh %02dm", h, m)
		end
	end)

	-- Divider
	fr(panel, UDim2.new(1,-20,0,1), UDim2.new(0,10,0,64), C_PANEL, 0)

	-- Quest card scroll
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1,-16,1,-80)
	scroll.Position = UDim2.new(0,8,0,72)
	scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4; scroll.CanvasSize = UDim2.new(0,0,0,0)
	scroll.Parent = panel

	local layout = Instance.new("UIListLayout", scroll)
	layout.Padding = UDim.new(0, 10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	-- Close
	local closeBtn = btn(panel, "✕",
		UDim2.new(0,30,0,30), UDim2.new(1,-38,0,8), C_RED)
	closeBtn.TextSize = 16
	closeBtn.Activated:Connect(function() panel.Visible = false end)

	-- ── State ─────────────────────────────────────────────────────────────────
	local questCards = {}   -- { [questId] = { progressBar, progressLbl, claimBtn } }
	local currentQuests = {}
	local currentCompleted = {}

	-- ── Build quest cards ─────────────────────────────────────────────────────
	local function buildCards()
		for _, child in ipairs(scroll:GetChildren()) do
			if child:IsA("Frame") then child:Destroy() end
		end
		questCards = {}

		if #currentQuests == 0 then
			local empty = Instance.new("TextLabel")
			empty.Size = UDim2.new(1,-10,0,60); empty.Position = UDim2.new(0,5,0,0)
			empty.BackgroundTransparency = 1; empty.Text = "No quests yet — check back soon!"
			empty.TextColor3 = C_MUTED; empty.TextSize = 14; empty.Font = Enum.Font.GothamBold
			empty.TextXAlignment = Enum.TextXAlignment.Center; empty.Parent = scroll
			scroll.CanvasSize = UDim2.new(0,0,0,70)
			return
		end

		for i, quest in ipairs(currentQuests) do
			local progress  = currentCompleted[quest.id]    or 0
			local claimKey  = quest.id .. "_claimed"
			local isClaimed = currentCompleted[claimKey] == true
			local isDone    = progress >= quest.amount

			local card = fr(scroll, UDim2.new(1,-6,0,88), UDim2.new(0,0,0,0), C_PANEL, 0)
			card.LayoutOrder = i; corner(card, 10)

			-- Left cyan accent
			local accent = fr(card, UDim2.new(0,4,1,0), UDim2.new(0,0,0,0), C_CYAN, 0)
			corner(accent, 4)

			-- Quest label
			lb(card, quest.label,
				UDim2.new(0.72,0,0,20), UDim2.new(0,14,0,8), C_WHITE, 14)

			-- Reward chip
			lb(card, "+" .. fmt(quest.reward) .. " 🍄",
				UDim2.new(0,100,0,18), UDim2.new(1,-114,0,8),
				C_GOLD, 12, Enum.TextXAlignment.Center)

			-- Progress bar background
			local barBg = fr(card, UDim2.new(1,-20,0,8), UDim2.new(0,10,0,34), C_BG, 0)
			corner(barBg, 4)

			-- Progress bar fill
			local fill = fr(barBg, UDim2.new(0,0,1,0), UDim2.new(0,0,0,0), C_CYAN, 0)
			corner(fill, 4)
			local pct = math.clamp(progress / quest.amount, 0, 1)
			fill.Size = UDim2.new(pct, 0, 1, 0)
			if isDone or isClaimed then
				fill.BackgroundColor3 = C_GREEN
			end

			-- Progress text
			local progLbl = lb(card, fmt(progress) .. " / " .. fmt(quest.amount),
				UDim2.new(0.5,0,0,16), UDim2.new(0,14,0,46), C_MUTED, 11)

			-- Claim button
			local claimBtn
			if isClaimed then
				claimBtn = btn(card, "✓  DONE",
					UDim2.new(0,90,0,26), UDim2.new(1,-104,0,54), C_MUTED)
				claimBtn.Active = false
			elseif isDone then
				claimBtn = btn(card, "CLAIM  →",
					UDim2.new(0,90,0,26), UDim2.new(1,-104,0,54), C_GOLD, C_BG)
				local qid = quest.id
				claimBtn.Activated:Connect(function()
					ClaimQuestReward:FireServer(qid)
					claimBtn.Text = "✓  CLAIMED"
					claimBtn.BackgroundColor3 = C_GREEN
					fill.BackgroundColor3 = C_GREEN
				end)
			else
				claimBtn = btn(card, fmt(progress) .. "/" .. fmt(quest.amount),
					UDim2.new(0,90,0,26), UDim2.new(1,-104,0,54), C_PANEL)
				claimBtn.Active = false
			end

			questCards[quest.id] = {
				fill     = fill,
				progLbl  = progLbl,
				claimBtn = claimBtn,
				quest    = quest,
			}
		end

		scroll.CanvasSize = UDim2.new(0,0,0, math.max(#currentQuests, 1) * 98 + 10)
	end

	-- ── Public API ────────────────────────────────────────────────────────────
	local api = {}
	api.panel = panel

	function api.show()
		uiScale.Scale = 0.92
		panel.Visible = true
		TweenService:Create(uiScale,
			TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ Scale = 1 }
		):Play()
		buildCards()
	end

	function api.hide()
		panel.Visible = false
	end

	function api.isVisible(): boolean
		return panel.Visible
	end

	--- Called when server sends full quest data (on join or reset).
	function api.onQuestData(data: table)
		currentQuests    = data.quests    or {}
		currentCompleted = data.completed or {}
		if panel.Visible then buildCards() end
	end

	--- Called when server sends incremental progress update.
	function api.onQuestProgress(update: table)
		-- update: { questId, progress, goal }
		currentCompleted[update.questId] = update.progress

		local card = questCards[update.questId]
		if not card then return end

		local pct = math.clamp(update.progress / update.goal, 0, 1)
		TweenService:Create(card.fill,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad),
			{ Size = UDim2.new(pct, 0, 1, 0) }
		):Play()

		card.progLbl.Text = fmt(update.progress) .. " / " .. fmt(update.goal)

		if update.progress >= update.goal then
			-- Rebuild cards so the Claim button gets properly wired
			buildCards()
		end
	end

	return api
end

return DailyQuestUI
