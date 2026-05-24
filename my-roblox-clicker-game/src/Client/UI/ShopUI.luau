-- ShopUI.luau
-- Manages the CAVE SHOP panel: Upgrades tab + Species tab.
-- Call ShopUI.init(gui, state, Config, remotes, TutorialManager) → API table.

local TweenService = game:GetService("TweenService")

local ShopUI = {}

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

-- ─── HELPERS ─────────────────────────────────────────────────────────────────

local function fmt(n: number): string
	if n >= 1e12 then return string.format("%.2fT", n/1e12)
	elseif n >= 1e9  then return string.format("%.2fB", n/1e9)
	elseif n >= 1e6  then return string.format("%.2fM", n/1e6)
	elseif n >= 1e3  then return string.format("%.1fK", n/1e3)
	else return tostring(math.floor(n)) end
end

local function corner(p: Instance, r: number)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r); c.Parent = p
end

local function fr(par, sz, pos, bg, al)
	local f = Instance.new("Frame")
	f.Size = sz; f.Position = pos
	f.BackgroundColor3 = bg or C_PANEL
	f.BackgroundTransparency = al or 0
	f.BorderSizePixel = 0; f.Parent = par
	return f
end

local function lb(par, tx, sz, pos, col, ts, ax)
	local l = Instance.new("TextLabel")
	l.Size = sz; l.Position = pos
	l.BackgroundTransparency = 1; l.Text = tx
	l.TextColor3 = col or C_WHITE; l.TextSize = ts or 16
	l.Font = Enum.Font.GothamBold
	l.TextXAlignment = ax or Enum.TextXAlignment.Left
	l.Parent = par; return l
end

local function btn(par, tx, sz, pos, bg, tc)
	local b = Instance.new("TextButton")
	b.Size = sz; b.Position = pos
	b.BackgroundColor3 = bg or C_GREEN
	b.BorderSizePixel = 0; b.Text = tx
	b.TextColor3 = tc or Color3.new(1,1,1)
	b.TextSize = 15; b.Font = Enum.Font.GothamBold
	b.Parent = par; corner(b, 6); return b
end

local function makeScroll(parent: Instance): ScrollingFrame
	local s = Instance.new("ScrollingFrame")
	s.Size = UDim2.new(1,-16,1,-100)
	s.Position = UDim2.new(0,8,0,86)
	s.BackgroundTransparency = 1
	s.BorderSizePixel = 0
	s.ScrollBarThickness = 4
	s.CanvasSize = UDim2.new(0,0,0,0)
	s.Parent = parent
	local l = Instance.new("UIListLayout", s)
	l.Padding = UDim.new(0, 5)
	return s
end

-- ─── INIT ────────────────────────────────────────────────────────────────────

function ShopUI.init(gui: ScreenGui, state: table, Config: table,
	remotes: table, TutorialManager, SoundManager): table

	local PurchaseUpgrade = remotes.PurchaseUpgrade
	local UnlockSpecies   = remotes.UnlockSpecies

	-- ── Panel ────────────────────────────────────────────────────────────────
	local shopPanel = fr(gui, UDim2.new(0,450,0.72,0),
		UDim2.new(0.5,-225,0.1,0), C_BG, 0.04)
	corner(shopPanel, 14); shopPanel.Visible = false; shopPanel.ZIndex = 5

	local titleLbl = lb(shopPanel, "CAVE SHOP",
		UDim2.new(1,0,0,34), UDim2.new(0,0,0,8),
		C_CYAN, 20, Enum.TextXAlignment.Center)
	titleLbl.Font = Enum.Font.GothamBlack; titleLbl.ZIndex = 6

	local tabUp = btn(shopPanel, "UPGRADES",
		UDim2.new(0.46,0,0,30), UDim2.new(0.02,0,0,48), C_GREEN)
	local tabSp = btn(shopPanel, "SPECIES",
		UDim2.new(0.46,0,0,30), UDim2.new(0.52,0,0,48), C_PANEL)

	local upScroll = makeScroll(shopPanel)
	local spScroll = makeScroll(shopPanel); spScroll.Visible = false

	local uiScale = Instance.new("UIScale"); uiScale.Scale = 1; uiScale.Parent = shopPanel

	local closeBtn = btn(shopPanel, "X",
		UDim2.new(0,30,0,30), UDim2.new(1,-38,0,8), C_RED)
	closeBtn.TextSize = 16
	closeBtn.Activated:Connect(function()
		shopPanel.Visible = false
	end)

	-- ── Helper: is species owned ─────────────────────────────────────────────
	local function isOwned(id: string): boolean
		for _, o in ipairs(state.ownedSpecies) do
			if o == id then return true end
		end
		return false
	end

	-- ── Upgrades tab ─────────────────────────────────────────────────────────
	local UPGRADE_DEFS = {
		{ name = "Fertilizer", desc = "+15% production / lv" },
		{ name = "Lighting",   desc = "+10% yield / lv"      },
		{ name = "Humidity",   desc = "+5% mutation / lv"    },
	}

	local function buildUpgradeTab()
		for _, c in ipairs(upScroll:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end
		for _, u in ipairs(UPGRADE_DEFS) do
			local lv  = state.upgrades[u.name] or 0
			local row = fr(upScroll, UDim2.new(1,-6,0,66),
				UDim2.new(0,0,0,0), C_PANEL, 0); corner(row, 8)
			lb(row, u.name, UDim2.new(0.55,0,0,20), UDim2.new(0,12,0,6),  C_WHITE, 15)
			lb(row, u.desc, UDim2.new(0.55,0,0,16), UDim2.new(0,12,0,28), C_MUTED, 12)
			lb(row, "Lv " .. lv .. "/20",
				UDim2.new(0,70,0,20), UDim2.new(0,240,0,8), C_CYAN, 13)
			if lv < 20 then
				local cost  = Config.getUpgradeCost(u.name, lv + 1)
				local uname = u.name
				btn(row, fmt(cost), UDim2.new(0,110,0,28),
					UDim2.new(1,-122,0.5,-14),
					state.spores >= cost and C_GREEN or C_MUTED)
					.Activated:Connect(function()
						PurchaseUpgrade:FireServer(uname)
						if SoundManager then SoundManager.purchase() end
					end)
			else
				lb(row, "MAX", UDim2.new(0,80,0,28),
					UDim2.new(1,-122,0.5,-14), C_GOLD, 14, Enum.TextXAlignment.Center)
			end
		end
		upScroll.CanvasSize = UDim2.new(0,0,0, #UPGRADE_DEFS * 72 + 20)
	end

	-- ── Species tab ──────────────────────────────────────────────────────────
	local function buildSpeciesTab()
		for _, c in ipairs(spScroll:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end
		for _, sp in ipairs(Config.SPECIES) do
			local owned = isOwned(sp.id)
			local row   = fr(spScroll, UDim2.new(1,-6,0,52),
				UDim2.new(0,0,0,0), C_PANEL, 0); corner(row, 6)
			local tc = TIER_COLORS[sp.tier] or C_WHITE
			lb(row, sp.name,
				UDim2.new(0.55,0,0,20), UDim2.new(0,10,0,4), tc, 14)
			lb(row, sp.tier .. "  " .. sp.sporesPerSec .. "/sec",
				UDim2.new(0.55,0,0,16), UDim2.new(0,10,0,26), C_MUTED, 12)
			if owned then
				lb(row, "OWNED", UDim2.new(0,80,0,26),
					UDim2.new(1,-100,0.5,-13), C_GREEN, 13, Enum.TextXAlignment.Center)
			else
				local sid = sp.id
				btn(row, fmt(sp.unlockCost), UDim2.new(0,100,0,28),
					UDim2.new(1,-112,0.5,-14),
					state.spores >= sp.unlockCost and C_GREEN or C_MUTED)
					.Activated:Connect(function()
						UnlockSpecies:FireServer(sid)
						if SoundManager then SoundManager.speciesUnlock() end
						if TutorialManager then
							TutorialManager.onSpeciesBought()
						end
					end)
			end
		end
		spScroll.CanvasSize = UDim2.new(0,0,0, #Config.SPECIES * 56 + 10)
	end

	-- ── Tab switching ────────────────────────────────────────────────────────
	local activeTab = "upgrades"

	local function showTab(name: string)
		activeTab = name
		upScroll.Visible = name == "upgrades"
		spScroll.Visible = name == "species"
		tabUp.BackgroundColor3 = name == "upgrades" and C_GREEN or C_PANEL
		tabSp.BackgroundColor3 = name == "species"  and C_GREEN or C_PANEL
		if name == "upgrades" then buildUpgradeTab() else buildSpeciesTab() end
	end

	tabUp.Activated:Connect(function() showTab("upgrades") end)
	tabSp.Activated:Connect(function()
		showTab("species")
		if TutorialManager then TutorialManager.onSpeciesTabOpened() end
	end)

	-- ── Public API ────────────────────────────────────────────────────────────
	local api = {}
	api.panel = shopPanel
	api.tabSp = tabSp

	function api.show()
		uiScale.Scale = 0.92
		shopPanel.Visible = true
		TweenService:Create(uiScale,
			TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ Scale = 1 }
		):Play()
		showTab(activeTab)
	end

	function api.hide()
		shopPanel.Visible = false
	end

	function api.isVisible(): boolean
		return shopPanel.Visible
	end

	-- Call after state changes (SyncData / UpdateSpores) to refresh prices
	function api.rebuild()
		if shopPanel.Visible then showTab(activeTab) end
	end

	return api
end

return ShopUI
