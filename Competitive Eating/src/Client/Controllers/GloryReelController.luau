-- Glory Reel: after every contest, condense the player's bite + chipmunk
-- events into a 5-sec stylized highlight overlay (animated text-callouts).
--
-- No video capture; the "reel" is a timeline of GloryEvent records replayed
-- as tweened text bursts. Last 10 reels kept in memory; no persistence.
--
-- Wired via:
--   • ContestController calls GloryReelController.recordBite(...) after each
--     SkillCheckResult fires (2-line hook in that controller)
--   • This controller listens to ContestPhaseChanged itself to manage the
--     buffer lifecycle (reset on "Active", flush on "Results")

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common         = ReplicatedStorage:WaitForChild("Common")
local GloryReelTypes = require(Common:WaitForChild("GloryReelTypes"))

type GloryEvent = GloryReelTypes.GloryEvent
type GloryReel  = GloryReelTypes.GloryReel

local GloryReelController = {}

local localPlayer = Players.LocalPlayer
local playerGui   = localPlayer:WaitForChild("PlayerGui")

local MAX_GALLERY     = 10
local REEL_DURATION   = 5.0
local MAX_HIGHLIGHTS  = 8

-- ── State ─────────────────────────────────────────────────────────────────────

local gallery      : { GloryReel } = {}
local nextReelId   = 1
local currentBuffer: { GloryEvent } = {}
local contestStart : number? = nil
local lastPhase    : string? = nil
local isPlaying    = false

-- ── UI refs ───────────────────────────────────────────────────────────────────

local buttonGui   : ScreenGui
local lastReelBtn : TextButton
local overlayGui  : ScreenGui
local overlayDim  : Frame
local overlayTitle: TextLabel
local overlayStage: Frame

-- ── UI build ──────────────────────────────────────────────────────────────────

local function buildButton()
	buttonGui = Instance.new("ScreenGui")
	buttonGui.Name           = "GloryReelBtnGui"
	buttonGui.ResetOnSpawn   = false
	buttonGui.IgnoreGuiInset = true
	buttonGui.DisplayOrder   = 5
	buttonGui.Parent         = playerGui

	local btn = Instance.new("TextButton")
	btn.Name              = "LastReelBtn"
	btn.Size              = UDim2.fromOffset(150, 44)
	btn.Position          = UDim2.new(1, -170, 1, -64)
	btn.AnchorPoint       = Vector2.new(0, 0)
	btn.BackgroundColor3  = Color3.fromRGB(220, 30, 80)
	btn.BorderSizePixel   = 0
	btn.TextColor3        = Color3.fromRGB(255, 240, 200)
	btn.TextScaled        = true
	btn.Font              = Enum.Font.LuckiestGuy
	btn.Text              = "▶ LAST REEL"
	btn.Visible           = false
	btn.AutoButtonColor   = true
	btn.Parent            = buttonGui
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke")
	stroke.Color     = Color3.fromRGB(255, 220, 80)
	stroke.Thickness = 2
	stroke.Parent    = btn

	lastReelBtn = btn
end

local function buildOverlay()
	overlayGui = Instance.new("ScreenGui")
	overlayGui.Name           = "GloryReelOverlay"
	overlayGui.ResetOnSpawn   = false
	overlayGui.IgnoreGuiInset = true
	overlayGui.DisplayOrder   = 20
	overlayGui.Enabled        = false
	overlayGui.Parent         = playerGui

	local dim = Instance.new("Frame")
	dim.Size                  = UDim2.fromScale(1, 1)
	dim.BackgroundColor3      = Color3.fromRGB(0, 0, 0)
	dim.BackgroundTransparency = 0.25
	dim.BorderSizePixel       = 0
	dim.Parent                = overlayGui
	overlayDim = dim

	local topBar = Instance.new("Frame")
	topBar.Size              = UDim2.new(1, 0, 0, 36)
	topBar.Position          = UDim2.fromScale(0, 0)
	topBar.BackgroundColor3  = Color3.fromRGB(15, 15, 15)
	topBar.BorderSizePixel   = 0
	topBar.Parent            = dim

	local bottomBar = topBar:Clone()
	bottomBar.Position = UDim2.new(0, 0, 1, -36)
	bottomBar.Parent   = dim

	local title = Instance.new("TextLabel")
	title.Name                  = "Title"
	title.Size                  = UDim2.fromOffset(560, 70)
	title.Position              = UDim2.new(0.5, -280, 0, 50)
	title.BackgroundTransparency = 1
	title.TextColor3            = Color3.fromRGB(255, 215, 0)
	title.TextStrokeColor3      = Color3.fromRGB(120, 20, 20)
	title.TextStrokeTransparency = 0
	title.TextScaled            = true
	title.Font                  = Enum.Font.LuckiestGuy
	title.Text                  = "★ GLORY REEL ★"
	title.Parent                = dim
	overlayTitle = title

	local stage = Instance.new("Frame")
	stage.Name              = "Stage"
	stage.Size              = UDim2.fromScale(1, 1)
	stage.BackgroundTransparency = 1
	stage.Parent            = dim
	overlayStage = stage
end

-- ── Callout styling ───────────────────────────────────────────────────────────

local KIND_STYLE: { [string]: { color: Color3, stroke: Color3, fallback: string } } = {
	PerfectBite  = { color = Color3.fromRGB(255, 220, 80), stroke = Color3.fromRGB(200, 30, 30), fallback = "PERFECT BITE!" },
	GoodBite     = { color = Color3.fromRGB(180, 240, 180), stroke = Color3.fromRGB(20, 80, 20),  fallback = "Good bite" },
	Miss         = { color = Color3.fromRGB(200, 200, 200), stroke = Color3.fromRGB(50, 50, 50),  fallback = "miss…" },
	ChipmunkSwat = { color = Color3.fromRGB(255, 140, 60),  stroke = Color3.fromRGB(80, 20, 0),   fallback = "CHIPMUNK SWAT!" },
	PlaceFinish  = { color = Color3.fromRGB(120, 220, 255), stroke = Color3.fromRGB(20, 40, 100), fallback = "FINISH" },
}

local function calloutText(e: GloryEvent): string
	if e.label then return e.label end
	if e.kind == "PerfectBite" and e.biteIndex then
		return string.format("PERFECT BITE #%d", e.biteIndex)
	end
	if e.kind == "PlaceFinish" and e.place then
		local suffix = "th"
		if e.place == 1 then suffix = "st"
		elseif e.place == 2 then suffix = "nd"
		elseif e.place == 3 then suffix = "rd" end
		return string.format("%d%s PLACE!", e.place, suffix)
	end
	return KIND_STYLE[e.kind].fallback
end

local function spawnCallout(e: GloryEvent, slotIndex: number, dwell: number)
	local style = KIND_STYLE[e.kind] or KIND_STYLE.GoodBite

	local yFrac = 0.32 + ((slotIndex - 1) % 4) * 0.12
	local xJitter = math.random(-60, 60)

	local lbl = Instance.new("TextLabel")
	lbl.Size                  = UDim2.fromOffset(60, 40)
	lbl.Position              = UDim2.new(0.5, xJitter - 30, yFrac, -20)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3            = style.color
	lbl.TextStrokeColor3      = style.stroke
	lbl.TextStrokeTransparency = 0
	lbl.TextScaled            = true
	lbl.Font                  = Enum.Font.LuckiestGuy
	lbl.Text                  = calloutText(e)
	lbl.Rotation              = math.random(-8, 8)
	lbl.TextTransparency      = 1
	lbl.Parent                = overlayStage

	local targetW = e.kind == "PerfectBite" and 540 or 380
	local targetH = e.kind == "PerfectBite" and 110 or 80
	local popIn = TweenService:Create(lbl,
		TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{
			Size              = UDim2.fromOffset(targetW, targetH),
			Position          = UDim2.new(0.5, xJitter - targetW/2, yFrac, -targetH/2),
			TextTransparency  = 0,
		}
	)
	popIn:Play()

	task.delay(dwell * 0.55, function()
		if not lbl.Parent then return end
		local drift = TweenService:Create(lbl,
			TweenInfo.new(dwell * 0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{
				Position              = UDim2.new(0.5, xJitter - targetW/2 - 40, yFrac - 0.08, -targetH/2),
				TextTransparency      = 1,
				TextStrokeTransparency = 1,
				Rotation              = lbl.Rotation + math.random(-30, 30),
			}
		)
		drift:Play()
		task.delay(dwell * 0.45 + 0.05, function()
			if lbl.Parent then lbl:Destroy() end
		end)
	end)
end

-- ── Highlight selection ───────────────────────────────────────────────────────

local PRIORITY = { PerfectBite = 1, ChipmunkSwat = 2, PlaceFinish = 3, GoodBite = 4, Miss = 5 }

local function pickHighlights(events: { GloryEvent }): { GloryEvent }
	if #events == 0 then
		return { { kind = "GoodBite", timestamp = 0, label = "NO REEL YET — EAT MORE!" } }
	end

	local picked: { GloryEvent } = {}
	local seen: { [GloryEvent]: boolean } = {}
	local function add(e: GloryEvent)
		if seen[e] then return end
		seen[e] = true
		table.insert(picked, e)
	end

	for _, e in events do
		if e.kind == "PerfectBite" or e.kind == "ChipmunkSwat" or e.kind == "PlaceFinish" then
			add(e)
		end
	end

	if #picked < 4 then
		for _, e in events do
			if #picked >= MAX_HIGHLIGHTS then break end
			add(e)
		end
	end

	while #picked > MAX_HIGHLIGHTS do table.remove(picked, #picked) end

	table.sort(picked, function(a, b)
		local ta = a.timestamp or 0
		local tb = b.timestamp or 0
		if ta == tb then
			return (PRIORITY[a.kind] or 9) < (PRIORITY[b.kind] or 9)
		end
		return ta < tb
	end)
	return picked
end

-- ── Replay ────────────────────────────────────────────────────────────────────

local function playReel(reel: GloryReel)
	if isPlaying then return end
	isPlaying = true

	for _, child in overlayStage:GetChildren() do
		child:Destroy()
	end

	overlayGui.Enabled        = true
	overlayDim.BackgroundTransparency = 1
	overlayTitle.TextTransparency = 1
	overlayTitle.TextStrokeTransparency = 1

	TweenService:Create(overlayDim, TweenInfo.new(0.25), { BackgroundTransparency = 0.25 }):Play()
	TweenService:Create(overlayTitle, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		TextTransparency       = 0,
		TextStrokeTransparency = 0,
	}):Play()

	local highlights = pickHighlights(reel.events)
	local n = math.max(1, #highlights)
	local slotDur = REEL_DURATION / n

	task.spawn(function()
		for i, e in highlights do
			spawnCallout(e, i, slotDur + 0.25)
			task.wait(slotDur)
		end
	end)

	task.delay(REEL_DURATION, function()
		TweenService:Create(overlayDim, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(overlayTitle, TweenInfo.new(0.25), {
			TextTransparency       = 1,
			TextStrokeTransparency = 1,
		}):Play()
		task.wait(0.4)
		overlayGui.Enabled = false
		isPlaying = false
	end)
end

-- ── Buffer API ────────────────────────────────────────────────────────────────

local function nowOffset(): number
	return contestStart and (os.clock() - contestStart) or 0
end

function GloryReelController.recordBite(hit: boolean, isGreat: boolean, biteIndex: number)
	if not contestStart then contestStart = os.clock() end
	local kind: GloryReelTypes.GloryEventKind
	if isGreat then
		kind = "PerfectBite"
	elseif hit then
		kind = "GoodBite"
	else
		kind = "Miss"
	end
	table.insert(currentBuffer, {
		kind      = kind,
		timestamp = nowOffset(),
		biteIndex = biteIndex,
	})
end

function GloryReelController.recordChipmunkSwat(biteIndex: number?)
	if not contestStart then contestStart = os.clock() end
	table.insert(currentBuffer, {
		kind      = "ChipmunkSwat",
		timestamp = nowOffset(),
		biteIndex = biteIndex,
	})
end

function GloryReelController.recordPlaceFinish(place: number)
	if not contestStart then contestStart = os.clock() end
	table.insert(currentBuffer, {
		kind      = "PlaceFinish",
		timestamp = nowOffset(),
		place     = place,
	})
end

function GloryReelController.flushToGallery()
	if #currentBuffer == 0 then return end
	local reel: GloryReel = {
		id        = nextReelId,
		createdAt = os.time(),
		events    = currentBuffer,
	}
	nextReelId = nextReelId + 1
	table.insert(gallery, 1, reel)
	while #gallery > MAX_GALLERY do
		table.remove(gallery)
	end
	currentBuffer = {}
	contestStart  = nil
	if lastReelBtn then lastReelBtn.Visible = true end
end

function GloryReelController.getGallery(): { GloryReel }
	return gallery
end

function GloryReelController.playLatest()
	if #gallery == 0 then return end
	playReel(gallery[1])
end

-- ── Phase wiring ──────────────────────────────────────────────────────────────

local function onPhaseChanged(_arenaId: number, state: string)
	if state == lastPhase then return end
	lastPhase = state

	if state == "Active" then
		currentBuffer = {}
		contestStart  = os.clock()
	elseif state == "Results" then
		GloryReelController.flushToGallery()
	elseif state == "Idle" then
		currentBuffer = {}
		contestStart  = nil
	end
end

-- ── Init ─────────────────────────────────────────────────────────────────────

function GloryReelController.init(remotesFolder: Folder)
	buildButton()
	buildOverlay()

	lastReelBtn.Activated:Connect(function()
		GloryReelController.playLatest()
	end)

	local phaseRemote = remotesFolder:WaitForChild("ContestPhaseChanged") :: RemoteEvent
	phaseRemote.OnClientEvent:Connect(function(arenaId: any, state: any)
		if typeof(state) == "string" then
			onPhaseChanged(tonumber(arenaId) or 0, state)
		end
	end)
end

return GloryReelController
