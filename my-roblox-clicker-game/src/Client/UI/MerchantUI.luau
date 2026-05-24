-- MerchantUI.luau
-- Rotating Spore Merchant panel. Shows 4 discounted species slots
-- (one per tier) that refresh every 6 minutes server-side.
-- A countdown timer creates urgency. Bought items fire PurchaseMerchant.

local TweenService = game:GetService("TweenService")

local MerchantUI = {}

-- ─── PALETTE ─────────────────────────────────────────────────────────────────

local C_BG    = Color3.fromRGB(12, 10, 22)
local C_PANEL = Color3.fromRGB(22, 18, 40)
local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_GREEN = Color3.fromRGB(70, 185, 110)
local C_GOLD  = Color3.fromRGB(255, 200, 55)
local C_WHITE = Color3.fromRGB(215, 210, 250)
local C_MUTED = Color3.fromRGB(120, 112, 155)
local C_RED   = Color3.fromRGB(220, 70, 70)

local TIER_COLORS = {
	Common   = C_WHITE,
	Uncommon = Color3.fromRGB(70, 185, 110),
	Rare     = Color3.fromRGB(100, 145, 255),
	Epic     = Color3.fromRGB(195, 95, 255),
	Mythic   = C_GOLD,
}

local TIER_DISCOUNT_LABEL = {
	Common   = "20% OFF",
	Uncommon = "15% OFF",
	Rare     = "10% OFF",
	Epic     = "5% OFF",
	Mythic   = "",
}

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function fmt(n: number): string
	if n >= 1e12 then return string.format("%.2fT", n/1e12)
	elseif n >= 1e9  then return string.format("%.2fB", n/1e9)
	elseif n >= 1e6  then return string.format("%.2fM", n/1e6)
	elseif n >= 1e3  then return string.format("%.1fK", n/1e3)
	else return tostring(math.floor(n)) end
end

local function corner(p: Instance, r: number)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
end
local function stroke(p: Instance, col: Color3, thick: number)
	local s = Instance.new("UIStroke"); s.Color = col; s.Thickness = thick; s.Parent = p
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
	l.TextXAlignment = ax or Enum.TextXAlignment.Left
	l.Parent = par; return l
end
local function btn(par, tx, sz, pos, bg, tc)
	local b = Instance.new("TextButton"); b.Size = sz; b.Position = pos
	b.BackgroundColor3 = bg or C_GREEN; b.BorderSizePixel = 0
	b.Text = tx; b.TextColor3 = tc or Color3.new(1,1,1)
	b.TextSize = 14; b.Font = Enum.Font.GothamBold
	b.Parent = par; corner(b, 6); return b
end

-- ─── INIT ────────────────────────────────────────────────────────────────────

function MerchantUI.init(gui: ScreenGui, state: table, Config: table, Remotes: Folder): table

	local PurchaseMerchant = Remotes:WaitForChild("PurchaseMerchant")

	-- ── Panel ────────────────────────────────────────────────────────────────
	local panel = fr(gui, UDim2.new(0,450,0,380),
		UDim2.new(0.5,-225,0.5,-200), C_BG, 0.04)
	corner(panel, 14); stroke(panel, C_GOLD, 1); panel.Visible = false; panel.ZIndex = 5
	local uiScale = Instance.new("UIScale"); uiScale.Scale = 1; uiScale.Parent = panel

	-- Header
	lb(panel, "🍄  SPORE MERCHANT",
		UDim2.new(1,0,0,32), UDim2.new(0,0,0,10),
		C_GOLD, 18, Enum.TextXAlignment.Center).Font = Enum.Font.GothamBlack

	lb(panel, "Rotating deals · refreshes every 6 minutes",
		UDim2.new(1,0,0,18), UDim2.new(0,0,0,40),
		C_MUTED, 12, Enum.TextXAlignment.Center)

	-- Countdown bar
	local countdownLbl = lb(panel, "Next refresh: --:--",
		UDim2.new(1,-20,0,20), UDim2.new(0,10,0,60),
		C_CYAN, 13, Enum.TextXAlignment.Center)

	-- Divider
	local div = Instance.new("Frame"); div.Size = UDim2.new(1,-20,0,1)
	div.Position = UDim2.new(0,10,0,86); div.BackgroundColor3 = C_PANEL
	div.BorderSizePixel = 0; div.Parent = panel

	-- Stock scroll
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1,-16,1,-100)
	scroll.Position = UDim2.new(0,8,0,94)
	scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4; scroll.CanvasSize = UDim2.new(0,0,0,0)
	scroll.Parent = panel
	local layout = Instance.new("UIListLayout", scroll)
	layout.Padding = UDim.new(0, 8)

	-- Close
	local closeBtn = btn(panel, "X",
		UDim2.new(0,30,0,30), UDim2.new(1,-38,0,8), C_RED)
	closeBtn.TextSize = 16
	closeBtn.Activated:Connect(function() panel.Visible = false end)

	-- ── State ────────────────────────────────────────────────────────────────
	local nextRefreshAt: number = 0
	local currentStock:  { any } = {}

	-- ── Build stock rows ─────────────────────────────────────────────────────
	local function isOwned(id: string): boolean
		for _, o in ipairs(state.ownedSpecies) do
			if o == id then return true end
		end
		return false
	end

	local function buildRows()
		for _, c in ipairs(scroll:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end

		if #currentStock == 0 then
			local empty = lb(scroll, "No deals right now — check back soon!",
				UDim2.new(1,-10,0,40), UDim2.new(0,5,0,0), C_MUTED, 14, Enum.TextXAlignment.Center)
			empty.TextWrapped = true
			scroll.CanvasSize = UDim2.new(0,0,0,50)
			return
		end

		for _, item in ipairs(currentStock) do
			local owned   = isOwned(item.id)
			local tc      = TIER_COLORS[item.tier] or C_WHITE
			local row     = fr(scroll, UDim2.new(1,-6,0,72), UDim2.new(0,0,0,0), C_PANEL, 0)
			corner(row, 8)

			-- Tier accent strip on the left
			local accent = Instance.new("Frame"); accent.Size = UDim2.new(0,4,1,0)
			accent.Position = UDim2.new(0,0,0,0); accent.BackgroundColor3 = tc
			accent.BorderSizePixel = 0; accent.Parent = row
			corner(accent, 4)

			-- Species name + tier
			lb(row, item.name, UDim2.new(0.52,0,0,22), UDim2.new(0,14,0,8), tc, 15)
			lb(row, item.tier .. "  ·  " .. item.sporesPerSec .. " spores/sec",
				UDim2.new(0.52,0,0,16), UDim2.new(0,14,0,32), C_MUTED, 12)

			-- Discount badge
			local disc = TIER_DISCOUNT_LABEL[item.tier] or ""
			if disc ~= "" then
				local badge = lb(row, disc, UDim2.new(0,70,0,18), UDim2.new(0,14,0,50),
					C_GOLD, 11, Enum.TextXAlignment.Center)
				badge.BackgroundColor3 = Color3.fromRGB(60, 45, 10)
				badge.BackgroundTransparency = 0
				corner(badge, 4)
			end

			-- Price + buy button
			if owned then
				lb(row, "OWNED", UDim2.new(0,90,0,30), UDim2.new(1,-106,0.5,-15),
					C_GREEN, 13, Enum.TextXAlignment.Center)
			else
				local canAfford = state.spores >= item.cost
				local sid = item.id
				local buyBtn = btn(row, fmt(item.cost),
					UDim2.new(0,100,0,32), UDim2.new(1,-114,0.5,-16),
					canAfford and C_GREEN or C_MUTED)
				buyBtn.Activated:Connect(function()
					if state.spores >= item.cost then
						PurchaseMerchant:FireServer(sid)
					end
				end)
			end
		end

		scroll.CanvasSize = UDim2.new(0,0,0, math.max(#currentStock, 1) * 80 + 10)
	end

	-- ── Countdown tick ───────────────────────────────────────────────────────
	task.spawn(function()
		while true do
			task.wait(1)
			if nextRefreshAt > 0 then
				local rem = math.max(0, nextRefreshAt - os.time())
				countdownLbl.Text = string.format(
					"Next refresh in  %d:%02d", math.floor(rem/60), rem%60)
				if rem == 0 then
					countdownLbl.Text = "Refreshing…"
				end
			end
		end
	end)

	-- ── Mycelium Pulse flash ─────────────────────────────────────────────────
	local pulseFrame = fr(gui, UDim2.new(1,0,0,40), UDim2.new(0,0,0.5,-20),
		C_CYAN, 0.6)
	pulseFrame.ZIndex = 20; pulseFrame.Visible = false
	lb(pulseFrame, "⚡  MYCELIUM NETWORK ACTIVE  —  +20% Spores/sec for 60s  ⚡",
		UDim2.new(1,0,1,0), UDim2.new(0,0,0,0),
		C_BG, 15, Enum.TextXAlignment.Center).Font = Enum.Font.GothamBlack

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
		buildRows()
	end

	function api.hide()
		panel.Visible = false
	end

	function api.isVisible(): boolean
		return panel.Visible
	end

	function api.onStockUpdated(data: table)
		currentStock  = data.stock or {}
		nextRefreshAt = data.nextRefreshAt or 0
		if panel.Visible then buildRows() end
	end

	function api.showPulseEffect(intensity: number)
		pulseFrame.Visible = true
		TweenService:Create(pulseFrame,
			TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundTransparency = 0.1 }
		):Play()
		task.delay(3.5, function()
			TweenService:Create(pulseFrame,
				TweenInfo.new(0.6, Enum.EasingStyle.Quad),
				{ BackgroundTransparency = 1 }
			):Play()
			task.delay(0.7, function() pulseFrame.Visible = false end)
		end)
	end

	return api
end

return MerchantUI
