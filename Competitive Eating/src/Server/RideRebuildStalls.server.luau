-- RideRebuildStalls: rebuild Frank's 5 carnival mini-game stalls at 1.5x
-- footprint with Belle-Epoque carnival palette (burgundy / cream / antique
-- gold) + Neon accent strips. Pure-primitive AssetBuilder build.
--
-- Stalls handled (all canonical + any "_R" right-side twins found):
--   Stall_RingToss, Stall_HighStriker, Stall_DuckPond,
--   Stall_BalloonDart, Stall_SkeeBall  (+ _R variants if present)
--
-- Contract preserved (per src/Client/Controllers/MiniGameController.luau):
--   - Model name unchanged
--   - At least one ProximityPrompt descendant (wired to StartMiniGame on click)
--   - Original world pivot preserved (PivotTo)
-- No other client/server code reads stall sub-part names.

local ServerStorage     = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AB                = require(ReplicatedStorage.Common.AssetBuilder)

task.wait(1)  -- let peer rebuild scripts settle

-- Belle-Epoque palette + neon accents
local BURGUNDY  = Color3.fromRGB(110,  30,  40)
local CREAM     = Color3.fromRGB(238, 224, 196)
local GOLD      = Color3.fromRGB(220, 180,  60)
local DARK_WOOD = Color3.fromRGB( 80,  50,  30)
local NEON_RED  = Color3.fromRGB(255,  80,  90)
local NEON_GOLD = Color3.fromRGB(255, 220, 110)
local WATER     = Color3.fromRGB( 90, 170, 220)
local POND_TRIM = Color3.fromRGB( 60, 110, 180)
local BALLOON_R = Color3.fromRGB(220,  60,  60)
local BALLOON_B = Color3.fromRGB( 70, 110, 220)
local BALLOON_Y = Color3.fromRGB(240, 210,  80)
local DUCK_YEL  = Color3.fromRGB(250, 220,  80)
local DUCK_BILL = Color3.fromRGB(240, 120,  40)
local BELL_BRZ  = Color3.fromRGB(180, 130,  60)

local STALLS = {
	"Stall_RingToss", "Stall_HighStriker", "Stall_DuckPond",
	"Stall_BalloonDart", "Stall_SkeeBall",
	"Stall_RingToss_R", "Stall_BalloonDart_R", "Stall_DuckPond_R",
}

-- ── Shared stall scaffolding ─────────────────────────────────────────────────
-- 1.5x footprint of original ~10x8x10. Each stall fits ~15x12x15.
local W, D, H = 15, 15, 12

-- Carnival-classic façade: striped awning roof + signboard + counter + posts.
-- Returns the canonical Counter part (anchor for PrimaryPart).
local function buildFacade(m: Model, title: string)
	-- Floor pad (subtle, ground-flush)
	local floor = AB.block(Vector3.new(W, 0.6, D), DARK_WOOD,
		CFrame.new(0, 0.3, 0), m, "Floor")
	-- Back wall — burgundy panel
	AB.block(Vector3.new(W, H - 2, 0.6), BURGUNDY,
		CFrame.new(0, (H - 2) / 2 + 0.6, -D / 2 + 0.3), m, "BackWall")
	-- Side walls — cream
	AB.block(Vector3.new(0.6, H - 2, D), CREAM,
		CFrame.new( W / 2 - 0.3, (H - 2) / 2 + 0.6, 0), m, "WallE")
	AB.block(Vector3.new(0.6, H - 2, D), CREAM,
		CFrame.new(-W / 2 + 0.3, (H - 2) / 2 + 0.6, 0), m, "WallW")
	-- Counter (front rail)
	local counter = AB.block(Vector3.new(W - 0.6, 1.4, 1.4), DARK_WOOD,
		CFrame.new(0, 2.2, D / 2 - 0.9), m, "Counter")
	-- Striped awning (5 alternating burgundy/cream wedges along front)
	for i = 1, 6 do
		local stripeColor = (i % 2 == 0) and BURGUNDY or CREAM
		local x = -W / 2 + (i - 0.5) * (W / 6)
		AB.block(Vector3.new(W / 6 - 0.1, 0.4, 4),
			stripeColor, CFrame.new(x, H + 0.2, D / 2 - 1.2)
				* CFrame.Angles(math.rad(-15), 0, 0), m, "Awning_" .. i)
	end
	-- Awning gold fringe
	AB.neon(AB.block(Vector3.new(W, 0.3, 0.3), NEON_GOLD,
		CFrame.new(0, H - 0.4, D / 2 + 0.9), m, "AwningFringe"))
	-- Gold trim corners
	for _, sx in ipairs({ -1, 1 }) do
		AB.block(Vector3.new(0.5, H, 0.5), GOLD,
			CFrame.new(sx * (W / 2 - 0.25), H / 2 + 0.6, D / 2 - 0.25), m,
			"GoldPost_" .. (sx > 0 and "E" or "W"))
	end
	-- Sign board above the awning
	local sign = AB.block(Vector3.new(W - 2, 2.4, 0.4), CREAM,
		CFrame.new(0, H + 2.6, D / 2 - 1.4), m, "SignBoard")
	-- Sign text via BillboardGui
	local bb = AB.billboard(sign, title, Vector2.new(420, 80), 0)
	bb.StudsOffsetWorldSpace = Vector3.new(0, 0, 0.4)
	-- Neon accent under sign
	AB.neon(AB.block(Vector3.new(W - 2, 0.2, 0.2), NEON_RED,
		CFrame.new(0, H + 1.3, D / 2 - 1.2), m, "SignNeon"))
	return counter
end

local function addPrompt(parent: BasePart, actionText: string)
	local pp = Instance.new("ProximityPrompt")
	pp.ActionText  = actionText
	pp.ObjectText  = "Carnival Stall"
	pp.HoldDuration = 0
	pp.MaxActivationDistance = 12
	pp.RequiresLineOfSight   = false
	pp.Parent       = parent
end

-- ── Per-stall prop builders (props sit inside the stall behind the counter) ──

local function propsRingToss(m: Model)
	-- 6 bottle pegs in 2 rows
	for r = 1, 2 do
		for c = 1, 5 do
			local x = -W / 2 + 2 + (c - 1) * 2.6
			local z = -D / 2 + 3 + (r - 1) * 2.4
			AB.cylinder(0.9, 3.2, CREAM,
				CFrame.new(x, 2.4, z), m, "Bottle_" .. ((r - 1) * 5 + c))
			AB.cylinder(0.6, 0.6, GOLD,
				CFrame.new(x, 4.2, z), m, "BottleCap_" .. ((r - 1) * 5 + c))
		end
	end
	-- Ring rack on counter
	for i = 1, 4 do
		local x = -3 + (i - 1) * 2
		AB.neon(AB.cylinder(1.4, 0.3, NEON_RED,
			CFrame.new(x, 3.2, D / 2 - 1.0)
				* CFrame.Angles(math.rad(90), 0, 0), m, "Ring_" .. i))
	end
end

local function propsHighStriker(m: Model)
	-- Tall tower at center
	AB.block(Vector3.new(1.6, H + 4, 1.6), BURGUNDY,
		CFrame.new(0, (H + 4) / 2 + 0.6, -D / 2 + 2.5), m, "StrikerTower")
	-- Bell on top
	AB.sphere(2.2, BELL_BRZ,
		CFrame.new(0, H + 5, -D / 2 + 2.5), m, "Bell")
	-- Strike pad on floor
	AB.cylinder(3.5, 0.6, GOLD,
		CFrame.new(0, 1, D / 2 - 4), m, "StrikePad")
	-- Mallet on counter
	AB.block(Vector3.new(0.5, 0.5, 3.5), DARK_WOOD,
		CFrame.new(-3, 3.4, D / 2 - 1.5), m, "MalletHandle")
	AB.block(Vector3.new(1.8, 1.4, 1.8), DARK_WOOD,
		CFrame.new(-3, 3.4, D / 2 - 3.1), m, "MalletHead")
	-- Score zone neon ladder up the tower
	for i = 1, 6 do
		local hue = (i >= 5) and NEON_RED or NEON_GOLD
		AB.neon(AB.block(Vector3.new(0.4, 0.5, 0.3), hue,
			CFrame.new(0.95, 2 + i * 1.8, -D / 2 + 2.5), m, "ScoreMark_" .. i))
	end
end

local function propsDuckPond(m: Model)
	-- Pond basin
	AB.block(Vector3.new(W - 2, 0.4, D - 5), POND_TRIM,
		CFrame.new(0, 1, -1), m, "PondRim")
	AB.block(Vector3.new(W - 3, 0.5, D - 6), WATER,
		CFrame.new(0, 1.1, -1), m, "PondWater")
	-- 6 ducks bobbing
	for i = 1, 6 do
		local x = -5 + (i - 1) * 2
		local z = -1 + ((i % 2 == 0) and 1.2 or -1.2)
		AB.sphere(1.4, DUCK_YEL,
			CFrame.new(x, 1.9, z), m, "Duck_" .. i)
		AB.block(Vector3.new(0.5, 0.4, 0.6), DUCK_BILL,
			CFrame.new(x, 1.9, z + 0.8), m, "DuckBill_" .. i)
	end
	-- Fishing rod
	AB.block(Vector3.new(0.3, 0.3, 4.5), DARK_WOOD,
		CFrame.new(W / 2 - 2, 3.6, D / 2 - 2.5)
			* CFrame.Angles(math.rad(-20), 0, 0), m, "Rod")
end

local function propsBalloonDart(m: Model)
	-- Cork board back panel
	AB.block(Vector3.new(W - 2.5, H - 4, 0.5), CREAM,
		CFrame.new(0, (H - 4) / 2 + 1.4, -D / 2 + 0.7), m, "DartBoard")
	-- 18 balloons in 3 rows of 6
	local colors = { BALLOON_R, BALLOON_B, BALLOON_Y }
	for r = 1, 3 do
		for c = 1, 6 do
			local x = -5 + (c - 1) * 2
			local y = 3 + (r - 1) * 1.8
			local col = colors[((r + c) % 3) + 1]
			AB.sphere(1.4, col,
				CFrame.new(x, y, -D / 2 + 0.95), m, "Balloon_" .. ((r - 1) * 6 + c))
		end
	end
	-- Dart rack on counter
	for i = 1, 3 do
		local x = -2 + (i - 1) * 2
		AB.block(Vector3.new(0.2, 0.2, 1.6), GOLD,
			CFrame.new(x, 3.3, D / 2 - 1.4), m, "Dart_" .. i)
	end
end

local function propsSkeeBall(m: Model)
	-- Lane (sloped wood)
	AB.block(Vector3.new(4, 0.4, D - 4), DARK_WOOD,
		CFrame.new(0, 1.6, 0) * CFrame.Angles(math.rad(-8), 0, 0), m, "Lane")
	-- Lane gutters
	AB.block(Vector3.new(0.4, 1.2, D - 4), CREAM,
		CFrame.new( 2.2, 2.2, 0) * CFrame.Angles(math.rad(-8), 0, 0), m, "GutterE")
	AB.block(Vector3.new(0.4, 1.2, D - 4), CREAM,
		CFrame.new(-2.2, 2.2, 0) * CFrame.Angles(math.rad(-8), 0, 0), m, "GutterW")
	-- 5 scoring holes in a triangle at the back ramp
	local ringSpec = {
		{ 0, -D / 2 + 1.6, 5.6, NEON_RED  },  -- center jackpot
		{ -1.4, -D / 2 + 2.4, 5.1, NEON_GOLD },
		{  1.4, -D / 2 + 2.4, 5.1, NEON_GOLD },
		{ -1.8, -D / 2 + 3.4, 4.6, GOLD     },
		{  1.8, -D / 2 + 3.4, 4.6, GOLD     },
	}
	for i, s in ipairs(ringSpec) do
		local p = AB.cylinder(1.6, 0.2, s[4],
			CFrame.new(s[1], s[3], s[2])
				* CFrame.Angles(math.rad(82), 0, 0), m, "Hole_" .. i)
		if i <= 3 then AB.neon(p) end
	end
	-- 3 wooden balls on the counter
	for i = 1, 3 do
		AB.sphere(1.0, DARK_WOOD,
			CFrame.new(-2 + (i - 1) * 2, 3.4, D / 2 - 1.4), m, "Ball_" .. i)
	end
end

local PROP_BUILDERS = {
	RingToss    = propsRingToss,
	HighStriker = propsHighStriker,
	DuckPond    = propsDuckPond,
	BalloonDart = propsBalloonDart,
	SkeeBall    = propsSkeeBall,
}

local TITLES = {
	RingToss    = "RING TOSS",
	HighStriker = "HIGH STRIKER",
	DuckPond    = "DUCK POND",
	BalloonDart = "BALLOON DART",
	SkeeBall    = "SKEE-BALL",
}

local function rebuildOne(stallName: string)
	local m = workspace:FindFirstChild(stallName)
	if not m or not m:IsA("Model") then
		warn("[RideRebuildStalls] " .. stallName .. " not found; skipping")
		return 0
	end
	-- Strip trailing "_R" for canonical type
	local kind = stallName:gsub("^Stall_", ""):gsub("_R$", "")
	local builder = PROP_BUILDERS[kind]
	if not builder then
		warn("[RideRebuildStalls] no builder for " .. stallName); return 0
	end
	-- Snapshot pivot, backup, clear
	local pivot = m:GetPivot()
	local clone = m:Clone()
	clone.Name = stallName .. "_PreFood_20260603"
	clone.Parent = ServerStorage
	m:ClearAllChildren()
	m.PrimaryPart = nil
	-- Build at origin then pivot
	local counter = buildFacade(m, TITLES[kind])
	builder(m)
	m.PrimaryPart = counter
	addPrompt(counter, "Play " .. TITLES[kind])
	AB.weldAll(m)
	m:PivotTo(pivot)
	return #m:GetChildren()
end

local totals = {}
for _, name in ipairs(STALLS) do
	totals[name] = rebuildOne(name)
end

print(string.format(
	"[RideRebuildStalls] rebuilt RingToss=%d HighStriker=%d DuckPond=%d BalloonDart=%d SkeeBall=%d (variants: %d/%d/%d)",
	totals.Stall_RingToss or 0, totals.Stall_HighStriker or 0,
	totals.Stall_DuckPond or 0, totals.Stall_BalloonDart or 0,
	totals.Stall_SkeeBall or 0,
	totals.Stall_RingToss_R or 0, totals.Stall_BalloonDart_R or 0,
	totals.Stall_DuckPond_R or 0))
