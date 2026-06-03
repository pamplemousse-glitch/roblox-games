-- FranksOnboarding: first-impression onboarding aids for new players.
-- * Glowing green pavement arrows from spawn toward the first contest area
-- * "PRESS E TO EAT" BillboardGui over 3 known-position contest tables
-- * Tutorial welcome sign at spawn
--
-- All parented under workspace.FranksOnboarding so AssetSpawner's
-- `Districts:ClearAllChildren` pass doesn't wipe it.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AB                = require(ReplicatedStorage.Common.AssetBuilder)

local ARROW_GREEN = Color3.fromRGB( 50, 220,  50)
local SIGN_FRAME  = Color3.fromRGB(110,  75,  45)
local SIGN_POLE   = Color3.fromRGB( 80,  50,  30)
local WHITE       = Color3.fromRGB(255, 255, 255)

-- Idempotent reset
local existing = workspace:FindFirstChild("FranksOnboarding")
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name   = "FranksOnboarding"
root.Parent = workspace

-- ── 1. Pavement arrows from spawn toward first contest area ──────────────────
-- Path runs from approx (0, 5, 50) toward (0, 5, -50) i.e. roughly the
-- carousel/contest cluster. 6 arrows, each rotated to point forward.
local arrowsModel = AB.model("PavementArrows", root)

local START_X, START_Z = 0, 50
local END_X,   END_Z   =  0, -50
local ARROW_COUNT      = 6
for i = 1, ARROW_COUNT do
	local t = (i - 0.5) / ARROW_COUNT
	local x = START_X + (END_X - START_X) * t
	local z = START_Z + (END_Z - START_Z) * t
	-- Compute yaw from start→end. Path is straight along -Z, so yaw = 0.
	local dx, dz = END_X - START_X, END_Z - START_Z
	local yaw    = math.atan2(dx, -dz) -- 0 when path runs -Z
	-- Shaft of arrow (3 × 0.2 × 6 block)
	local shaft = AB.block(
		Vector3.new(3, 0.2, 6),
		ARROW_GREEN,
		CFrame.new(x, 0.6, z) * CFrame.Angles(0, yaw, 0),
		arrowsModel,
		"ArrowShaft_" .. i
	)
	shaft.Material = Enum.Material.Neon
	shaft.CanCollide = false
	-- Arrow tip wedges (2 wedges form the chevron)
	local tipCF = CFrame.new(x, 0.6, z) * CFrame.Angles(0, yaw, 0) * CFrame.new(0, 0, -3.5)
	local wL = AB.wedge(Vector3.new(2, 0.2, 2), ARROW_GREEN,
		tipCF * CFrame.new(-1, 0, 0) * CFrame.Angles(0, math.rad(180), 0),
		arrowsModel, "ArrowTipL_" .. i)
	wL.Material = Enum.Material.Neon
	wL.CanCollide = false
	local wR = AB.wedge(Vector3.new(2, 0.2, 2), ARROW_GREEN,
		tipCF * CFrame.new(1, 0, 0),
		arrowsModel, "ArrowTipR_" .. i)
	wR.Material = Enum.Material.Neon
	wR.CanCollide = false
	AB.glow(shaft, ARROW_GREEN, 1.5)
end

-- ── 2. PRESS E TO EAT floating BillboardGuis over contest tables ─────────────
local promptsModel = AB.model("EatPrompts", root)

local function makeEatPrompt(name: string, anchorPos: Vector3)
	local anchor = Instance.new("Part")
	anchor.Name        = name .. "_Anchor"
	anchor.Size        = Vector3.new(0.2, 0.2, 0.2)
	anchor.Position    = anchorPos
	anchor.Anchored    = true
	anchor.CanCollide  = false
	anchor.Transparency = 1
	anchor.Parent      = promptsModel

	local bb = Instance.new("BillboardGui")
	bb.Name           = "EatPromptGui"
	bb.Adornee        = anchor
	bb.Size           = UDim2.fromOffset(220, 60)
	bb.StudsOffset    = Vector3.new(0, 0, 0)
	bb.AlwaysOnTop    = true
	bb.MaxDistance    = 80
	bb.Parent         = anchor

	local lbl = Instance.new("TextLabel")
	lbl.Size                     = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency   = 1
	lbl.Text                     = "PRESS E TO EAT"
	lbl.TextColor3               = WHITE
	lbl.TextStrokeColor3         = Color3.new(0, 0, 0)
	lbl.TextStrokeTransparency   = 0
	lbl.Font                     = Enum.Font.GothamBlack
	lbl.TextScaled               = true
	lbl.Parent                   = bb
end

-- 3 known-position contest tables (BEST GUESS — orchestrator verify).
makeEatPrompt("Table_Center", Vector3.new(  0, 10, 0))
makeEatPrompt("Table_East",   Vector3.new( 40, 10, 0))
makeEatPrompt("Table_West",   Vector3.new(-40, 10, 0))

-- ── 3. Tutorial sign at spawn ────────────────────────────────────────────────
local signModel = AB.model("WelcomeSign", root)

local SIGN_POS = Vector3.new(0, 0, 60) -- a few studs south of spawn, in player view
-- Pole
AB.block(Vector3.new(0.8, 14, 0.8), SIGN_POLE,
	CFrame.new(SIGN_POS.X, 7, SIGN_POS.Z), signModel, "SignPole")
-- Frame
local frame = AB.block(Vector3.new(20, 8, 0.6), SIGN_FRAME,
	CFrame.new(SIGN_POS.X, 14, SIGN_POS.Z), signModel, "SignBoard")
-- Decorative trim (top + bottom rail)
AB.block(Vector3.new(20.6, 0.6, 0.8), SIGN_POLE,
	CFrame.new(SIGN_POS.X, 18.2, SIGN_POS.Z), signModel, "SignTrimTop")
AB.block(Vector3.new(20.6, 0.6, 0.8), SIGN_POLE,
	CFrame.new(SIGN_POS.X,  9.8, SIGN_POS.Z), signModel, "SignTrimBot")
-- Side trim posts
AB.block(Vector3.new(0.6, 8.6, 0.8), SIGN_POLE,
	CFrame.new(SIGN_POS.X - 10.1, 14, SIGN_POS.Z), signModel, "SignTrimLeft")
AB.block(Vector3.new(0.6, 8.6, 0.8), SIGN_POLE,
	CFrame.new(SIGN_POS.X + 10.1, 14, SIGN_POS.Z), signModel, "SignTrimRight")
AB.pivot(signModel, frame)

-- BillboardGui on the frame (large, 2-line headline)
local welcomeGui = Instance.new("SurfaceGui")
welcomeGui.Name        = "WelcomeGui"
welcomeGui.Face        = Enum.NormalId.Back  -- face toward -Z (spawn area)
welcomeGui.LightInfluence = 0
welcomeGui.Adornee     = frame
welcomeGui.SizingMode  = Enum.SurfaceGuiSizingMode.PixelsPerStud
welcomeGui.PixelsPerStud = 50
welcomeGui.Parent      = frame

local title = Instance.new("TextLabel")
title.Size                   = UDim2.fromScale(1, 0.45)
title.Position               = UDim2.fromScale(0, 0.05)
title.BackgroundTransparency = 1
title.Text                   = "WELCOME TO FRANK'S FAIRGROUND"
title.TextColor3             = Color3.fromRGB(255, 220, 130)
title.TextStrokeColor3       = Color3.new(0, 0, 0)
title.TextStrokeTransparency = 0
title.Font                   = Enum.Font.GothamBlack
title.TextScaled             = true
title.Parent                 = welcomeGui

local sub = Instance.new("TextLabel")
sub.Size                     = UDim2.fromScale(1, 0.45)
sub.Position                 = UDim2.fromScale(0, 0.5)
sub.BackgroundTransparency   = 1
sub.Text                     = "Walk to a contest table & press E"
sub.TextColor3               = WHITE
sub.TextStrokeColor3         = Color3.new(0, 0, 0)
sub.TextStrokeTransparency   = 0
sub.Font                     = Enum.Font.GothamBold
sub.TextScaled               = true
sub.Parent                   = welcomeGui

-- Also add a BillboardGui above the sign for far-distance readability
local farBB = Instance.new("BillboardGui")
farBB.Name        = "WelcomeFarGui"
farBB.Adornee     = frame
farBB.Size        = UDim2.fromOffset(400, 80)
farBB.StudsOffset = Vector3.new(0, 6, 0)
farBB.AlwaysOnTop = true
farBB.MaxDistance = 200
farBB.Parent      = frame

local farLbl = Instance.new("TextLabel")
farLbl.Size                   = UDim2.fromScale(1, 1)
farLbl.BackgroundTransparency = 1
farLbl.Text                   = "WELCOME — Press E at a table"
farLbl.TextColor3             = Color3.fromRGB(255, 220, 130)
farLbl.TextStrokeColor3       = Color3.new(0, 0, 0)
farLbl.TextStrokeTransparency = 0
farLbl.Font                   = Enum.Font.GothamBlack
farLbl.TextScaled             = true
farLbl.Parent                 = farBB

print("[FranksOnboarding] spawned: 6 pavement arrows, 3 EAT prompts, welcome sign")
