-- VaultUI.luau
-- Returns build(gui, Config, getState) → { show(slotCount, onConfirm), hide() }

local TweenService = game:GetService("TweenService")
local C_BG    = Color3.fromRGB(12, 10, 22)
local C_PANEL = Color3.fromRGB(22, 18, 40)
local C_CYAN  = Color3.fromRGB(80, 210, 255)
local C_GREEN = Color3.fromRGB(70, 185, 110)
local C_GOLD  = Color3.fromRGB(255, 200, 55)
local C_WHITE = Color3.fromRGB(215, 210, 250)
local C_MUTED = Color3.fromRGB(120, 112, 155)
local C_RED   = Color3.fromRGB(220, 70, 70)
local TIER_COLORS = {
	Common=C_WHITE, Uncommon=C_GREEN,
	Rare=Color3.fromRGB(100,145,255), Epic=Color3.fromRGB(195,95,255), Mythic=C_GOLD,
}
local STARS = { "✦", "✦✦", "✦✦✦" }

local function corner(p, r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r) c.Parent=p end
local function fr(par,sz,pos,bg,al) local f=Instance.new("Frame") f.Size=sz f.Position=pos f.BackgroundColor3=bg or C_PANEL f.BackgroundTransparency=al or 0 f.BorderSizePixel=0 f.Parent=par return f end
local function lb(par,tx,sz,pos,col,ts,ax) local l=Instance.new("TextLabel") l.Size=sz l.Position=pos l.BackgroundTransparency=1 l.Text=tx l.TextColor3=col or C_WHITE l.TextSize=ts or 15 l.Font=Enum.Font.GothamBold l.TextXAlignment=ax or Enum.TextXAlignment.Left l.Parent=par return l end
local function btn(par,tx,sz,pos,bg,tc) local b=Instance.new("TextButton") b.Size=sz b.Position=pos b.BackgroundColor3=bg or C_GREEN b.BorderSizePixel=0 b.Text=tx b.TextColor3=tc or Color3.new(1,1,1) b.TextSize=15 b.Font=Enum.Font.GothamBold b.Parent=par corner(b,6) return b end

local function build(gui: ScreenGui, Config: table, getState: () -> table)

	-- Overlay dims the background
	local overlay = fr(gui, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), Color3.new(0,0,0), 0.6)
	overlay.Visible = false
	overlay.ZIndex = 10

	local panel = fr(overlay, UDim2.new(0,480,0.85,0), UDim2.new(0.5,-240,0.07,0), C_BG, 0.04)
	corner(panel, 14)
	local uiScale = Instance.new("UIScale"); uiScale.Scale = 1; uiScale.Parent = panel

	lb(panel, "SPORULATE",
		UDim2.new(1,0,0,32), UDim2.new(0,0,0,8), C_GOLD, 22, Enum.TextXAlignment.Center)
		.Font = Enum.Font.GothamBlack

	lb(panel, "Everything resets. Choose what survives.",
		UDim2.new(1,0,0,20), UDim2.new(0,0,0,42), C_MUTED, 13, Enum.TextXAlignment.Center)

	local multLabel = lb(panel, "",
		UDim2.new(1,0,0,20), UDim2.new(0,0,0,62), C_GREEN, 14, Enum.TextXAlignment.Center)

	local slotLabel = lb(panel, "",
		UDim2.new(1,0,0,20), UDim2.new(0,0,0,82), C_CYAN, 13, Enum.TextXAlignment.Center)

	-- Species scroll
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1,-20,1,-160)
	scroll.Position = UDim2.new(0,10,0,108)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.CanvasSize = UDim2.new(0,0,0,0)
	scroll.Parent = panel
	local layout = Instance.new("UIListLayout", scroll)
	layout.Padding = UDim.new(0,5)

	local cancelBtn  = btn(panel, "CANCEL",
		UDim2.new(0,130,0,36), UDim2.new(0.05,0,1,-48), C_RED)
	local confirmBtn = btn(panel, "CONFIRM RESET",
		UDim2.new(0,200,0,36), UDim2.new(1,-215,1,-48), C_GOLD, C_BG)

	-- State
	local selected = {}   -- { [speciesId] = true }
	local maxSlots = 0
	local confirmCallback = nil

	local function selectedCount()
		local n = 0
		for _ in pairs(selected) do n += 1 end
		return n
	end

	local function refreshSlotLabel()
		slotLabel.Text = selectedCount() .. " / " .. maxSlots .. " vault slots used"
	end

	local function populate(slotCount: number)
		maxSlots = slotCount
		selected = {}

		for _, c in ipairs(scroll:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end

		local state = getState()
		local rows = 0

		for _, id in ipairs(state.ownedSpecies) do
			if id == "button" then continue end -- starter can't be vaulted
			local sp = Config.SPECIES_BY_ID[id]
			if not sp then continue end
			rows += 1

			local mutCount = state.mutations[id] or 0
			local row = fr(scroll, UDim2.new(1,-6,0,52), UDim2.new(0,0,0,0), C_PANEL, 0)
			corner(row, 6)

			local tc = TIER_COLORS[sp.tier] or C_WHITE
			lb(row, sp.name, UDim2.new(0.5,0,0,20), UDim2.new(0,10,0,4), tc, 14)
			lb(row, sp.tier, UDim2.new(0.3,0,0,16), UDim2.new(0,10,0,26), C_MUTED, 12)

			if mutCount > 0 then
				lb(row, STARS[mutCount], UDim2.new(0,60,0,16), UDim2.new(0,200,0,26), C_GOLD, 13)
			end

			local sid = id
			local selectBtn = btn(row, "KEEP",
				UDim2.new(0,80,0,28), UDim2.new(1,-92,0.5,-14), C_PANEL)

			local function refresh()
				if selected[sid] then
					selectBtn.BackgroundColor3 = C_GREEN
					selectBtn.Text = "KEPT ✓"
				else
					local full = selectedCount() >= maxSlots
					selectBtn.BackgroundColor3 = full and C_MUTED or C_PANEL
					selectBtn.Text = "KEEP"
				end
				refreshSlotLabel()
			end

			selectBtn.Activated:Connect(function()
				if selected[sid] then
					selected[sid] = nil
				elseif selectedCount() < maxSlots then
					selected[sid] = true
				end
				refresh()
			end)

			refresh()
		end

		scroll.CanvasSize = UDim2.new(0,0,0,rows*57+10)
		refreshSlotLabel()
	end

	cancelBtn.Activated:Connect(function()
		overlay.Visible = false
	end)

	confirmBtn.Activated:Connect(function()
		overlay.Visible = false
		if confirmCallback then
			local ids = {}
			for id in pairs(selected) do table.insert(ids, id) end
			confirmCallback(ids)
		end
	end)

	return {
		show = function(slotCount: number, nextPrestigeLevel: number, onConfirm: (ids: {string}) -> ())
			confirmCallback = onConfirm
			local mult = Config.PRESTIGE_MULTIPLIERS[nextPrestigeLevel] or "?"
			multLabel.Text = "Gaining: permanent ×" .. mult .. " production multiplier"
			populate(slotCount)
			uiScale.Scale = 0.92
		overlay.Visible = true
		TweenService:Create(uiScale,
			TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ Scale = 1 }
		):Play()
		end,
		hide = function()
			overlay.Visible = false
		end,
	}
end

return build
