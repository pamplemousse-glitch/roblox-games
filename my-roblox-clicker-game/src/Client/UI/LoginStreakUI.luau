-- LoginStreakUI.luau
-- Login streak popup: shows on first join each day.
-- Displays current streak, day marker (1-7), reward description, and a Claim button.

local TweenService = game:GetService("TweenService")

local LoginStreakUI = {}

-- ─── PALETTE ─────────────────────────────────────────────────────────────────

local C_BG    = Color3.fromRGB(12, 10, 22)
local C_PANEL = Color3.fromRGB(22, 18, 40)
local C_GOLD  = Color3.fromRGB(255, 200, 55)
local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_GREEN = Color3.fromRGB(70, 185, 110)
local C_WHITE = Color3.fromRGB(215, 210, 250)
local C_MUTED = Color3.fromRGB(120, 112, 155)
local C_RED   = Color3.fromRGB(220, 70, 70)

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

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
	l.TextXAlignment = ax or Enum.TextXAlignment.Center; l.Parent = par; return l
end
local function btn(par, tx, sz, pos, bg, tc)
	local b = Instance.new("TextButton"); b.Size = sz; b.Position = pos
	b.BackgroundColor3 = bg or C_GREEN; b.BorderSizePixel = 0
	b.Text = tx; b.TextColor3 = tc or Color3.new(1,1,1)
	b.TextSize = 15; b.Font = Enum.Font.GothamBold
	b.Parent = par; corner(b, 8); return b
end

-- ─── DAY DOT BUILDER ─────────────────────────────────────────────────────────

-- Builds 7 circular day indicators. currentDay is 1-7.
local function buildDayDots(parent: Instance, currentDay: number)
	local labels = { "1", "2", "3", "4", "5", "6", "7★" }
	local dotSize = UDim2.new(0, 34, 0, 34)
	local spacing = 40

	for i = 1, 7 do
		local x = (i - 1) * spacing + 10
		local dot = fr(parent, dotSize, UDim2.new(0, x, 0.5, -17), C_PANEL, 0)
		corner(dot, 17)

		if i < currentDay then
			-- Past days: green fill
			dot.BackgroundColor3 = C_GREEN
			lb(dot, "✓", UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C_BG, 16)
		elseif i == currentDay then
			-- Today: gold fill + glow stroke
			dot.BackgroundColor3 = C_GOLD
			lb(dot, labels[i], UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C_BG, 13)
			local s = Instance.new("UIStroke"); s.Color = Color3.new(1,1,1)
			s.Thickness = 2; s.Parent = dot
		else
			-- Future: dim
			dot.BackgroundColor3 = C_PANEL
			lb(dot, labels[i], UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C_MUTED, 11)
		end
	end
end

-- ─── INIT ─────────────────────────────────────────────────────────────────────

function LoginStreakUI.init(gui: ScreenGui, ClaimStreakReward: RemoteEvent): table
	-- ── Backdrop ──────────────────────────────────────────────────────────────
	local backdrop = fr(gui, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0),
		Color3.new(0,0,0), 0.5)
	backdrop.ZIndex = 30; backdrop.Visible = false

	-- ── Panel ─────────────────────────────────────────────────────────────────
	local panel = fr(backdrop, UDim2.new(0,360,0,300),
		UDim2.new(0.5,-180,0.5,-150), C_BG, 0.04)
	panel.ZIndex = 31
	corner(panel, 16)
	local s = Instance.new("UIStroke"); s.Color = C_GOLD; s.Thickness = 1.5; s.Parent = panel

	-- Header
	local header = lb(panel, "🔥  LOGIN STREAK",
		UDim2.new(1,0,0,34), UDim2.new(0,0,0,12),
		C_GOLD, 20)
	header.Font = Enum.Font.GothamBlack

	-- Streak counter
	local streakLbl = lb(panel, "Day 1",
		UDim2.new(1,0,0,28), UDim2.new(0,0,0,46),
		C_WHITE, 26)
	streakLbl.Font = Enum.Font.GothamBlack

	local longestLbl = lb(panel, "Best: 1",
		UDim2.new(1,0,0,18), UDim2.new(0,0,0,78),
		C_MUTED, 12)

	-- Day dots row
	local dotRow = fr(panel, UDim2.new(1,-20,0,50), UDim2.new(0,10,0,102), C_BG, 1)

	-- Divider
	local div = fr(panel, UDim2.new(1,-20,0,1), UDim2.new(0,10,0,158), C_PANEL, 0)

	-- Today's reward label
	lb(panel, "TODAY'S REWARD",
		UDim2.new(1,0,0,18), UDim2.new(0,0,0,166),
		C_MUTED, 11)

	local rewardLbl = lb(panel, "—",
		UDim2.new(1,-20,0,28), UDim2.new(0,10,0,184),
		C_CYAN, 18)

	-- Claim / Already Claimed button
	local claimBtn = btn(panel, "CLAIM REWARD",
		UDim2.new(1,-40,0,42), UDim2.new(0,20,0,220), C_GOLD, C_BG)
	claimBtn.TextSize = 16
	claimBtn.Font = Enum.Font.GothamBlack

	-- Close (small X)
	local closeBtn = btn(panel, "✕",
		UDim2.new(0,28,0,28), UDim2.new(1,-36,0,8), C_RED)
	closeBtn.TextSize = 14

	-- ── State ─────────────────────────────────────────────────────────────────
	local claimed = false

	-- ── Close logic ───────────────────────────────────────────────────────────
	local function close()
		TweenService:Create(backdrop,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad),
			{ BackgroundTransparency = 1 }
		):Play()
		TweenService:Create(panel,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad),
			{ BackgroundTransparency = 1 }
		):Play()
		task.delay(0.25, function() backdrop.Visible = false end)
	end

	closeBtn.Activated:Connect(close)

	claimBtn.Activated:Connect(function()
		if claimed then close(); return end
		ClaimStreakReward:FireServer()
		claimed = true
		claimBtn.Text = "✓  CLAIMED"
		claimBtn.BackgroundColor3 = C_GREEN
		task.delay(1.5, close)
	end)

	-- ── Public API ────────────────────────────────────────────────────────────
	local api = {}

	function api.show(data: table)
		-- data: { streak, longest, rewardDay, rewardLabel, canClaim }
		streakLbl.Text  = "Day " .. data.streak
		longestLbl.Text = "Best: " .. data.longest

		-- Clear and rebuild day dots
		for _, child in ipairs(dotRow:GetChildren()) do
			if child:IsA("Frame") then child:Destroy() end
		end
		buildDayDots(dotRow, data.rewardDay)

		rewardLbl.Text = data.rewardLabel

		if data.canClaim then
			claimed = false
			claimBtn.Text = "CLAIM REWARD"
			claimBtn.BackgroundColor3 = C_GOLD
			claimBtn.Active = true
		else
			claimed = true
			claimBtn.Text = "✓  ALREADY CLAIMED TODAY"
			claimBtn.BackgroundColor3 = C_MUTED
		end

		backdrop.BackgroundTransparency = 0.5
		backdrop.Visible = true
		panel.BackgroundTransparency  = 0.04

		-- Pop-in tween
		panel.Size = UDim2.new(0,360,0,270)
		panel.Position = UDim2.new(0.5,-180,0.5,-135)
		TweenService:Create(panel,
			TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ Size = UDim2.new(0,360,0,300), Position = UDim2.new(0.5,-180,0.5,-150) }
		):Play()
	end

	return api
end

return LoginStreakUI
