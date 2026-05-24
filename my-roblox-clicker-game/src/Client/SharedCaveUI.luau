local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

local Remotes            = ReplicatedStorage:WaitForChild("Remotes")
local LeaderboardUpdated       = Remotes:WaitForChild("LeaderboardUpdated")
local SeasonLeaderboardUpdated = Remotes:WaitForChild("SeasonLeaderboardUpdated")
local ShowcaseUpdated          = Remotes:WaitForChild("ShowcaseUpdated")

local LocalPlayer = Players.LocalPlayer

-- ─── COLORS (matches GameClient palette) ─────────────────────────────────────

local C_BG    = Color3.fromRGB(12, 10, 22)
local C_PANEL = Color3.fromRGB(22, 18, 40)
local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_GREEN = Color3.fromRGB(70, 185, 110)
local C_GOLD  = Color3.fromRGB(255, 200, 55)
local C_WHITE = Color3.fromRGB(215, 210, 250)
local C_MUTED = Color3.fromRGB(120, 112, 155)

local TIER_COLORS = {
	Common   = C_WHITE,
	Uncommon = C_GREEN,
	Rare     = Color3.fromRGB(100, 145, 255),
	Epic     = Color3.fromRGB(195, 95, 255),
	Mythic   = C_GOLD,
}

local function fmt(n: number): string
	if n >= 1e12 then return string.format("%.2fT", n / 1e12)
	elseif n >= 1e9 then return string.format("%.2fB", n / 1e9)
	elseif n >= 1e6 then return string.format("%.2fM", n / 1e6)
	elseif n >= 1e3 then return string.format("%.1fK", n / 1e3)
	else return tostring(math.floor(n))
	end
end

local function corner(p: Instance, r: number)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
end

local function makeFrame(parent, size, pos, bg, alpha)
	local f = Instance.new("Frame")
	f.Size = size; f.Position = pos
	f.BackgroundColor3 = bg or C_PANEL
	f.BackgroundTransparency = alpha or 0
	f.BorderSizePixel = 0; f.Parent = parent
	return f
end

local function makeLabel(parent, text, size, pos, color, tsize, align)
	local l = Instance.new("TextLabel")
	l.Size = size; l.Position = pos
	l.BackgroundTransparency = 1; l.Text = text
	l.TextColor3 = color or C_WHITE; l.TextSize = tsize or 15
	l.Font = Enum.Font.GothamBold
	l.TextXAlignment = align or Enum.TextXAlignment.Left
	l.Parent = parent; return l
end

-- ─── BUILD FUNCTION ──────────────────────────────────────────────────────────

local function build(gui: ScreenGui)
	local panel = makeFrame(gui, UDim2.new(1, 0, 1, -94), UDim2.new(0, 0, 0, 76), C_BG, 0)
	panel.Visible = false

	makeLabel(panel, "THE CAVE",
		UDim2.new(1, 0, 0, 36), UDim2.new(0, 0, 0, 6),
		C_CYAN, 22, Enum.TextXAlignment.Center).Font = Enum.Font.GothamBlack

	-- ── Left: Leaderboard ─────────────────────────────────────────────────────
	local lbFrame = makeFrame(panel, UDim2.new(0.46, -8, 1, -56), UDim2.new(0, 8, 0, 48), C_PANEL, 0)
	corner(lbFrame, 10)

	makeLabel(lbFrame, "LEADERBOARD",
		UDim2.new(1, 0, 0, 22), UDim2.new(0, 0, 0, 6),
		C_GOLD, 13, Enum.TextXAlignment.Center)

	-- Tab buttons
	local tabAll = Instance.new("TextButton")
	tabAll.Size = UDim2.new(0.5, -5, 0, 20)
	tabAll.Position = UDim2.new(0, 6, 0, 29)
	tabAll.Text = "ALL-TIME"
	tabAll.TextSize = 11
	tabAll.Font = Enum.Font.GothamBold
	tabAll.BorderSizePixel = 0
	tabAll.Parent = lbFrame
	corner(tabAll, 4)

	local tabSeason = Instance.new("TextButton")
	tabSeason.Size = UDim2.new(0.5, -5, 0, 20)
	tabSeason.Position = UDim2.new(0.5, -1, 0, 29)
	tabSeason.Text = "THIS SEASON"
	tabSeason.TextSize = 11
	tabSeason.Font = Enum.Font.GothamBold
	tabSeason.BorderSizePixel = 0
	tabSeason.Parent = lbFrame
	corner(tabSeason, 4)

	local lbScroll = Instance.new("ScrollingFrame")
	lbScroll.Size = UDim2.new(1, -12, 1, -58)
	lbScroll.Position = UDim2.new(0, 6, 0, 54)
	lbScroll.BackgroundTransparency = 1
	lbScroll.BorderSizePixel = 0
	lbScroll.ScrollBarThickness = 3
	lbScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	lbScroll.Parent = lbFrame
	local lbLayout = Instance.new("UIListLayout", lbScroll)
	lbLayout.Padding = UDim.new(0, 4)

	-- ── Right: Player Showcases ───────────────────────────────────────────────
	local scFrame = makeFrame(panel, UDim2.new(0.54, -8, 1, -56), UDim2.new(0.46, 4, 0, 48), C_PANEL, 0)
	corner(scFrame, 10)

	makeLabel(scFrame, "GROWERS ONLINE",
		UDim2.new(1, 0, 0, 24), UDim2.new(0, 0, 0, 8),
		C_CYAN, 14, Enum.TextXAlignment.Center)

	local scScroll = Instance.new("ScrollingFrame")
	scScroll.Size = UDim2.new(1, -12, 1, -42)
	scScroll.Position = UDim2.new(0, 6, 0, 38)
	scScroll.BackgroundTransparency = 1
	scScroll.BorderSizePixel = 0
	scScroll.ScrollBarThickness = 3
	scScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scScroll.Parent = scFrame
	local scLayout = Instance.new("UIListLayout", scScroll)
	scLayout.Padding = UDim.new(0, 6)

	-- Trade Post placeholder removed until feature is built

	-- ── Leaderboard tabs ─────────────────────────────────────────────────────
	local activeTab   = "alltime"
	local lastAllTime = {}
	local lastSeason  = {}

	local function setTabStyle(isAllTime: boolean)
		tabAll.BackgroundColor3    = isAllTime and C_GOLD or C_PANEL
		tabAll.TextColor3          = isAllTime and C_BG   or C_MUTED
		tabSeason.BackgroundColor3 = isAllTime and C_PANEL or Color3.fromRGB(80, 210, 120)
		tabSeason.TextColor3       = isAllTime and C_MUTED or C_BG
	end
	setTabStyle(true)

	local function renderEntries(entries)
		for _, c in ipairs(lbScroll:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end
		for _, e in ipairs(entries) do
			local isMe = e.userId == LocalPlayer.UserId
			local row = makeFrame(lbScroll, UDim2.new(1, -4, 0, 36), UDim2.new(0,0,0,0),
				isMe and Color3.fromRGB(30, 50, 30) or C_BG, 0)
			corner(row, 6)
			makeLabel(row, "#" .. e.rank,
				UDim2.new(0, 28, 1, 0), UDim2.new(0, 6, 0, 0), C_GOLD, 13)
			makeLabel(row, e.displayName,
				UDim2.new(0, 130, 1, 0), UDim2.new(0, 36, 0, 0), C_WHITE, 13)
			makeLabel(row, fmt(e.peakSpores),
				UDim2.new(0, 80, 1, 0), UDim2.new(1, -86, 0, 0), C_CYAN, 13, Enum.TextXAlignment.Right)
		end
		lbScroll.CanvasSize = UDim2.new(0, 0, 0, #entries * 40 + 10)
	end

	local function refreshLeaderboard(entries)
		lastAllTime = entries or {}
		if activeTab == "alltime" then renderEntries(lastAllTime) end
	end

	local function refreshSeasonLeaderboard(entries)
		lastSeason = entries or {}
		if activeTab == "season" then renderEntries(lastSeason) end
	end

	tabAll.Activated:Connect(function()
		if activeTab == "alltime" then return end
		activeTab = "alltime"
		setTabStyle(true)
		renderEntries(lastAllTime)
	end)

	tabSeason.Activated:Connect(function()
		if activeTab == "season" then return end
		activeTab = "season"
		setTabStyle(false)
		renderEntries(lastSeason)
	end)

	-- ── Showcase update ───────────────────────────────────────────────────────
	local function refreshShowcases(showcases)
		for _, c in ipairs(scScroll:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end
		for _, sc in ipairs(showcases) do
			local card = makeFrame(scScroll, UDim2.new(1, -4, 0, 82), UDim2.new(0,0,0,0), C_BG, 0)
			corner(card, 8)

			local nameColor = sc.userId == LocalPlayer.UserId and C_GREEN or C_WHITE
			makeLabel(card, sc.displayName,
				UDim2.new(1, -10, 0, 20), UDim2.new(0, 8, 0, 4), nameColor, 14)
			if sc.prestigeLevel and sc.prestigeLevel > 0 then
				makeLabel(card, "Prestige " .. sc.prestigeLevel,
					UDim2.new(0, 80, 0, 16), UDim2.new(1, -86, 0, 6), C_GOLD, 11)
			end

			for i, sp in ipairs(sc.species or {}) do
				local tc = TIER_COLORS[sp.tier] or C_WHITE
				makeLabel(card, sp.name,
					UDim2.new(0.6, 0, 0, 17), UDim2.new(0, 8, 0, 22 + (i - 1) * 19), tc, 12)
				makeLabel(card, sp.tier,
					UDim2.new(0, 70, 0, 17), UDim2.new(1, -76, 0, 22 + (i - 1) * 19), tc, 11, Enum.TextXAlignment.Right)
			end
		end
		scScroll.CanvasSize = UDim2.new(0, 0, 0, #showcases * 88 + 10)
	end

	LeaderboardUpdated.OnClientEvent:Connect(refreshLeaderboard)
	SeasonLeaderboardUpdated.OnClientEvent:Connect(refreshSeasonLeaderboard)
	ShowcaseUpdated.OnClientEvent:Connect(refreshShowcases)

	return {
		show = function() panel.Visible = true end,
		hide = function() panel.Visible = false end,
	}
end

return build
