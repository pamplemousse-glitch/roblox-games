-- HUD.luau
-- Manages the top HUD bar: spore counter, spores/sec, prestige badge,
-- weather event banner with countdown, and mutation notification popup.
-- Call HUD.init(gui, state, Config) → returns API table.

local TweenService = game:GetService("TweenService")

local HUD = {}

-- ─── PALETTE ─────────────────────────────────────────────────────────────────

local C_BG    = Color3.fromRGB(12, 10, 22)
local C_PANEL = Color3.fromRGB(22, 18, 40)
local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_GOLD  = Color3.fromRGB(255, 200, 55)
local C_WHITE = Color3.fromRGB(215, 210, 250)
local C_MUTED = Color3.fromRGB(120, 112, 155)

local TIER_COLORS = {
	Common   = C_WHITE,
	Uncommon = Color3.fromRGB(70, 185, 110),
	Rare     = Color3.fromRGB(100, 145, 255),
	Epic     = Color3.fromRGB(195, 95, 255),
	Mythic   = C_GOLD,
}

local MUTATION_STARS = { "✦", "✦✦", "✦✦✦" }

local EVENT_COLORS = {
	["Mycelium Surge"]       = Color3.fromRGB(255, 175,  50),  -- amber
	["Underground Spring"]   = Color3.fromRGB( 80, 210, 255),  -- cyan
	["Bioluminescent Bloom"] = Color3.fromRGB(195,  95, 255),  -- purple
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
	c.CornerRadius = UDim.new(0, r)
	c.Parent = p
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
	l.Parent = par
	return l
end

-- ─── INIT ────────────────────────────────────────────────────────────────────

function HUD.init(gui: ScreenGui, state: table, Config: table): table

	-- ── HUD card (top-left corner) ───────────────────────────────────────────
	local hudFrame = fr(gui, UDim2.new(0,210,0,88), UDim2.new(0,8,0,8), C_BG, 0.15)
	hudFrame.ZIndex = 2
	corner(hudFrame, 10)

	local sporeLabel = lb(hudFrame, "0 Spores",
		UDim2.new(1,-12,0,32), UDim2.new(0,10,0,6), C_CYAN, 22)
	sporeLabel.Font = Enum.Font.GothamBlack

	local spsLabel = lb(hudFrame, "+0/sec",
		UDim2.new(0,130,0,18), UDim2.new(0,10,0,42), C_MUTED, 13)

	local pBadge = lb(hudFrame, "",
		UDim2.new(1,-12,0,18), UDim2.new(0,10,0,42), C_GOLD, 11, Enum.TextXAlignment.Right)

	local vipBadge = lb(hudFrame, "VIP",
		UDim2.new(0,36,0,14), UDim2.new(1,-44,0,8), Color3.fromRGB(80, 255, 155), 11)
	vipBadge.Visible = false

	-- ── Cave event banner (top-right, independent of HUD card) ───────────────
	local weatherFrame = fr(gui, UDim2.new(0,260,0,52),
		UDim2.new(1,-268,0,8), C_PANEL, 0)
	corner(weatherFrame, 8); weatherFrame.Visible = false; weatherFrame.ZIndex = 2

	local weatherLbl = lb(weatherFrame, "",
		UDim2.new(1,-16,0,24), UDim2.new(0,8,0,4), C_GOLD, 13, Enum.TextXAlignment.Center)
	weatherLbl.TextWrapped = true

	local weatherTimer = lb(weatherFrame, "",
		UDim2.new(1,-16,0,16), UDim2.new(0,8,0,30), C_MUTED, 11, Enum.TextXAlignment.Center)

	-- Cave event countdown loop
	task.spawn(function()
		while true do
			task.wait(1)
			if state.weather then
				local rem = math.max(0, state.weather.endsAt - os.time())
				if rem > 0 then
					weatherTimer.Text = string.format("%d:%02d remaining",
						math.floor(rem / 60), rem % 60)
				else
					state.weather = nil
					weatherFrame.Visible = false
				end
			end
		end
	end)

	-- ── Mutation notification ─────────────────────────────────────────────────
	local notifFrame = fr(gui, UDim2.new(0,300,0,64),
		UDim2.new(1,-316,0,86), C_PANEL, 1)
	corner(notifFrame, 10); notifFrame.ZIndex = 8

	local notifTitle = lb(notifFrame, "",
		UDim2.new(1,-16,0,24), UDim2.new(0,12,0,6), C_GOLD, 15)
	notifTitle.Font = Enum.Font.GothamBlack
	notifTitle.TextTransparency = 1; notifTitle.ZIndex = 9

	local notifSub = lb(notifFrame, "",
		UDim2.new(1,-16,0,20), UDim2.new(0,12,0,34), C_MUTED, 13)
	notifSub.TextTransparency = 1; notifSub.ZIndex = 9

	local tw = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local notifActive = false

	-- ── HP Bar (sits below rate label with clear gap) ────────────────────────
	local hpBarBg = fr(hudFrame, UDim2.new(1,-20,0,8), UDim2.new(0,10,0,68), C_PANEL, 0)
	corner(hpBarBg, 4)

	local hpBar = fr(hpBarBg, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0),
		Color3.fromRGB(200, 50, 50), 0)
	corner(hpBar, 4)

	local hpLabel = lb(hudFrame, "HP: 100/100",
		UDim2.new(0,90,0,10), UDim2.new(1,-98,0,70), C_MUTED, 10, Enum.TextXAlignment.Right)

	local currentHP  = 100
	local maxHP      = 100

	-- ── Public API ────────────────────────────────────────────────────────────
	local api = {}

	function api.getFrame(): Frame
		return hudFrame
	end

	function api.update()
		sporeLabel.Text = fmt(state.spores) .. " Spores"
		spsLabel.Text   = "+" .. fmt(state.sporesPerSec) .. "/sec"
		pBadge.Text = state.prestigeLevel > 0
			and ("Prestige " .. state.prestigeLevel
				.. "  ×" .. (Config.PRESTIGE_MULTIPLIERS[state.prestigeLevel] or 1))
			or ""
		vipBadge.Visible = state.isVIP == true
	end

	function api.updateHP(hp: number, max: number)
		currentHP = hp; maxHP = max
		local ratio = math.clamp(hp / math.max(1, max), 0, 1)
		hpBar.Size = UDim2.new(ratio, 0, 1, 0)
		hpLabel.Text = "HP: " .. math.floor(hp) .. "/" .. math.floor(max)
	end

	function api.showWeather(event)
		state.weather = event
		if event then
			weatherFrame.Visible = true
			local color = EVENT_COLORS[event.name] or C_GOLD
			weatherLbl.TextColor3 = color
			weatherLbl.Text = event.name
		else
			weatherFrame.Visible = false
		end
	end

	function api.showMutation(speciesId: string, mutCount: number)
		local sp = Config.SPECIES_BY_ID[speciesId]
		if not sp then return end

		local tierColor = TIER_COLORS[sp.tier] or C_WHITE
		notifTitle.Text = (MUTATION_STARS[mutCount] or "✦")
			.. "  " .. sp.name .. "  MUTATED"
		notifTitle.TextColor3 = tierColor
		notifSub.Text = sp.tier
			.. " · Mutation " .. mutCount .. "/3"
			.. " · ×" .. (Config.MUTATION_MULTIPLIERS[sp.tier] ^ mutCount) .. " production"

		notifActive = true
		TweenService:Create(notifFrame, tw, { BackgroundTransparency = 0.08 }):Play()
		TweenService:Create(notifTitle, tw, { TextTransparency = 0 }):Play()
		TweenService:Create(notifSub,   tw, { TextTransparency = 0 }):Play()

		task.delay(4, function()
			if not notifActive then return end
			notifActive = false
			TweenService:Create(notifFrame, tw, { BackgroundTransparency = 1 }):Play()
			TweenService:Create(notifTitle, tw, { TextTransparency = 1 }):Play()
			TweenService:Create(notifSub,   tw, { TextTransparency = 1 }):Play()
		end)
	end

	return api
end

return HUD
