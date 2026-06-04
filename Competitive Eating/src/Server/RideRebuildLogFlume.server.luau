-- RideRebuildLogFlume: rebuild workspace.LogFlume as a Belle-Époque
-- Classic Wooden Water Flume.
--
-- HARD CONSTRAINT: the flume boat is built programmatically by
-- RideController.buildLogFlume. Its `wps` waypoint table (RideController.luau
-- lines 349-360, X=235, Z=-445→-295, Y=23.5→0.5) is hardcoded.
-- workspace.LogFlume children are PURELY visual scenery — the boat does NOT
-- read this model. We rebuild channel decoration only.
--
-- Theme (BELLE_EPOQUE_RIDE_PLAYBOOK.md §10):
--   • Water: clear blue/teal (NOT mustard).
--   • Channel: deep_wood + wood_plank trough with antique_gold rivet plates.
--   • Lift hill: stained wood ramp with wrought_iron rails.
--   • Channel ~2× wider than the original (~12 studs vs ~6).
--
-- PivotAnchor pattern (mandatory): invisible 0.1³ identity-rotation part is
-- PrimaryPart so :PivotTo doesn't bake any rotated-cylinder Z spin.

local ServerStorage     = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AB = require(ReplicatedStorage.Common.AssetBuilder)

task.wait(1)  -- let peer scripts settle

local m = workspace:FindFirstChild("LogFlume") :: Model?
if not m then
	warn("[RideRebuildLogFlume] workspace.LogFlume not found — skipping")
	return
end

-- ── Backup ───────────────────────────────────────────────────────────────────
local backup = m:Clone()
backup.Name = "LogFlume_PreBelleEpoque_2026-06-03"
backup.Parent = ServerStorage

local originalPivot: CFrame
do
	local ok, cf = pcall(function() return m:GetPivot() end)
	originalPivot = ok and cf or CFrame.new(235, 12, -370)
end

m:ClearAllChildren()
m.PrimaryPart = nil

-- ── PivotAnchor (mandatory) ──────────────────────────────────────────────────
local pivotAnchor = AB.part({
	size         = Vector3.new(0.1, 0.1, 0.1),
	color        = Color3.new(1, 1, 1),
	cf           = originalPivot,
	canCollide   = false,
	transparency = 1,
	name         = "PivotAnchor",
}, m)
m.PrimaryPart = pivotAnchor

-- ── Belle-Époque palette ─────────────────────────────────────────────────────
local DEEP_WOOD    = Color3.fromRGB(110,  75,  45)
local WOOD_PLANK   = Color3.fromRGB(160, 110,  70)
local ANTIQUE_GOLD = Color3.fromRGB(200, 160,  80)
local WROUGHT_IRON = Color3.fromRGB( 40,  35,  40)
local IVORY        = Color3.fromRGB(245, 235, 205)
local BURGUNDY     = Color3.fromRGB(130,  30,  50)
local WATER_TEAL   = Color3.fromRGB( 80, 165, 195)  -- clear blue/teal (NOT mustard)
local WATER_FOAM   = Color3.fromRGB(220, 240, 245)

-- ── Constants ────────────────────────────────────────────────────────────────
local WPS: { Vector3 } = {
	Vector3.new(235, 23.5, -445), Vector3.new(235, 21.0, -440),
	Vector3.new(235, 18.5, -435), Vector3.new(235, 15.0, -425),
	Vector3.new(235, 11.5, -415), Vector3.new(235,  8.0, -405),
	Vector3.new(235,  4.5, -395), Vector3.new(235,  1.5, -385),
	Vector3.new(235,  1.0, -375), Vector3.new(235,  1.0, -363),
	Vector3.new(235,  1.0, -351), Vector3.new(235,  1.0, -339),
	Vector3.new(235,  1.0, -327), Vector3.new(235,  1.0, -315),
	Vector3.new(235,  0.5, -295),
}

local CHANNEL_WIDTH      = 12   -- 2× original (~6)
local CHANNEL_FLOOR_THK  = 2
local BANK_HEIGHT        = 3
local BANK_WIDTH         = 2.5
local WATER_THK          = 0.6

-- ── Helper: configure a part with material + collisions in one call ──────────
local function dress(p: BasePart, mat: Enum.Material, canCollide: boolean, structural: boolean?): BasePart
	p.Material   = mat
	p.CanCollide = canCollide
	if structural then p:SetAttribute("Structural", true) end
	return p
end

-- ── Channel segment (wooden trough + clear teal water + gold rivet plates) ──
local function buildSegment(i: number, a: Vector3, b: Vector3)
	local mid = (a + b) * 0.5
	local len = (b - a).Magnitude
	-- Water surface sits ~0.5 below wp centerline (boat hull is 1.8 tall).
	local lookCF = CFrame.lookAt(mid + Vector3.new(0, -1.3, 0), b + Vector3.new(0, -1.3, 0))

	-- deep_wood trough floor (structural).
	dress(AB.block(
		Vector3.new(CHANNEL_WIDTH, CHANNEL_FLOOR_THK, len), DEEP_WOOD,
		lookCF * CFrame.new(0, -CHANNEL_FLOOR_THK * 0.5 - WATER_THK * 0.5, 0),
		m, string.format("ChannelFloor_%02d", i)), Enum.Material.Wood, true)

	-- Clear teal water surface — semi-transparent glass with slight sheen.
	local water = AB.block(Vector3.new(CHANNEL_WIDTH - 0.4, WATER_THK, len),
		WATER_TEAL, lookCF, m, string.format("Water_%02d", i))
	water.Material     = Enum.Material.Glass
	water.Transparency = 0.35
	water.Reflectance  = 0.25
	water.CanCollide   = false

	-- Wood_plank banks + antique_gold rivet plate caps.
	local bankOff = (CHANNEL_WIDTH + BANK_WIDTH) * 0.5
	local bankY   = BANK_HEIGHT * 0.5 - CHANNEL_FLOOR_THK * 0.5 - WATER_THK * 0.5
	for _, side in ipairs({ -1, 1 }) do
		local tag = side < 0 and "L" or "R"
		dress(AB.block(Vector3.new(BANK_WIDTH, BANK_HEIGHT, len), WOOD_PLANK,
			lookCF * CFrame.new(side * bankOff, bankY, 0), m,
			string.format("Bank_%s_%02d", tag, i)), Enum.Material.Wood, false)
		dress(AB.block(Vector3.new(BANK_WIDTH * 0.6, 0.25, len), ANTIQUE_GOLD,
			lookCF * CFrame.new(side * bankOff, BANK_HEIGHT - CHANNEL_FLOOR_THK * 0.5 - WATER_THK * 0.5 + 0.1, 0),
			m, string.format("RivetPlate_%s_%02d", tag, i)), Enum.Material.Metal, false, true)
	end
end

for i = 1, #WPS - 1 do buildSegment(i, WPS[i], WPS[i + 1]) end

-- ── Lift hill: stained wood ramp with wrought-iron rails ─────────────────────
-- Iron rails + balusters along the steep portion (wps 1..8); loading arbor on
-- top. Visual only — boat ignores it.
do
	local railOff = CHANNEL_WIDTH * 0.5 + BANK_WIDTH + 0.5
	for i = 1, 7 do
		local a, b = WPS[i], WPS[i + 1]
		local mid, len = (a + b) * 0.5, (b - a).Magnitude
		local lookCF = CFrame.lookAt(mid, b)
		for _, side in ipairs({ -1, 1 }) do
			dress(AB.block(Vector3.new(0.3, 0.3, len), WROUGHT_IRON,
				lookCF * CFrame.new(side * railOff, BANK_HEIGHT + 1.2, 0), m,
				string.format("Rail_%s_%02d", side < 0 and "L" or "R", i)),
				Enum.Material.Metal, false, true)
		end
	end
	for i = 1, 8 do
		local wp = WPS[i]
		for _, side in ipairs({ -1, 1 }) do
			dress(AB.block(Vector3.new(0.35, BANK_HEIGHT + 1.2, 0.35), WROUGHT_IRON,
				CFrame.new(wp.X + side * railOff, wp.Y - 1.3 + (BANK_HEIGHT + 1.2) * 0.5, wp.Z), m,
				string.format("RailPost_%s_%02d", side < 0 and "L" or "R", i)),
				Enum.Material.Metal, false)
		end
	end

	-- Loading arbor over the top waypoint: stained wood + gold crest + pennant.
	local arborCF = CFrame.new(WPS[1] + Vector3.new(0, 6, 6))
	for _, side in ipairs({ -1, 1 }) do
		dress(AB.block(Vector3.new(0.8, 8, 0.8), DEEP_WOOD,
			arborCF * CFrame.new(side * 5, -4, 0), m,
			string.format("ArborPost_%s", side < 0 and "L" or "R")),
			Enum.Material.Wood, false, true)
	end
	dress(AB.block(Vector3.new(12, 0.6, 6), WOOD_PLANK, arborCF, m, "ArborRoof"),
		Enum.Material.Wood, false, true)
	dress(AB.block(Vector3.new(12.4, 0.4, 0.6), ANTIQUE_GOLD,
		arborCF * CFrame.new(0, 0.5, -3), m, "ArborCrest"),
		Enum.Material.Metal, false)
	dress(AB.block(Vector3.new(1.5, 1.2, 0.1), BURGUNDY,
		arborCF * CFrame.new(0, 1.5, 0), m, "ArborPennant"),
		Enum.Material.Fabric, false)
	dress(AB.block(Vector3.new(1.5, 0.4, 0.11), IVORY,
		arborCF * CFrame.new(0, 1.5, 0), m, "ArborPennantStripe"),
		Enum.Material.Fabric, false)
end

-- ── Splash pool at the bottom of the flume ───────────────────────────────────
do
	local endPt = WPS[#WPS]
	dress(AB.block(Vector3.new(24, 1.5, 16), DEEP_WOOD,
		CFrame.new(endPt + Vector3.new(0, -1.1, 8)), m, "SplashPoolBasin"),
		Enum.Material.Wood, true)
	local pool = AB.block(Vector3.new(23, WATER_THK, 15), WATER_TEAL,
		CFrame.new(endPt + Vector3.new(0, -0.3, 8)), m, "SplashPool")
	pool.Material     = Enum.Material.Glass
	pool.Transparency = 0.3
	pool.Reflectance  = 0.25
	pool.CanCollide   = false
	local foam = AB.block(Vector3.new(20, 0.2, 1.2), WATER_FOAM,
		CFrame.new(endPt + Vector3.new(0, -0.1, 2)), m, "SplashFoam")
	foam.Material     = Enum.Material.Neon
	foam.Transparency = 0.4
	foam.CanCollide   = false

	for _, side in ipairs({ -1, 1 }) do
		local tag = side < 0 and "L" or "R"
		dress(AB.block(Vector3.new(BANK_WIDTH, BANK_HEIGHT + 1, 16), WOOD_PLANK,
			CFrame.new(endPt + Vector3.new(side * (CHANNEL_WIDTH + BANK_WIDTH) * 0.5, 0.5, 8)),
			m, "PoolRim_" .. tag), Enum.Material.Wood, false)
		dress(AB.block(Vector3.new(BANK_WIDTH * 0.7, 0.25, 16), ANTIQUE_GOLD,
			CFrame.new(endPt + Vector3.new(side * (CHANNEL_WIDTH + BANK_WIDTH) * 0.5, BANK_HEIGHT + 1 + 0.1, 8)),
			m, "PoolRimCap_" .. tag), Enum.Material.Metal, false, true)
	end
	dress(AB.block(Vector3.new(CHANNEL_WIDTH + BANK_WIDTH * 2, BANK_HEIGHT + 1, BANK_WIDTH),
		WOOD_PLANK, CFrame.new(endPt + Vector3.new(0, 0.5, 16)), m, "PoolBackWall"),
		Enum.Material.Wood, false, true)
end

-- ── Decorative stained-wood support pylons with gold rivet bands ─────────────
for i = 3, #WPS - 2, 4 do
	local wp = WPS[i]
	if wp.Y > 4 then
		local h = wp.Y - 0.5
		for _, side in ipairs({ -1, 1 }) do
			local tag = side < 0 and "L" or "R"
			local px  = wp.X + side * (CHANNEL_WIDTH * 0.5 + BANK_WIDTH + 1.5)
			dress(AB.block(Vector3.new(1.6, h, 1.6), DEEP_WOOD,
				CFrame.new(px, h * 0.5, wp.Z), m,
				string.format("WoodPylon_%s_%02d", tag, i)),
				Enum.Material.Wood, false, true)
			dress(AB.block(Vector3.new(1.8, 0.3, 1.8), ANTIQUE_GOLD,
				CFrame.new(px, h - 0.4, wp.Z), m,
				string.format("PylonBand_%s_%02d", tag, i)),
				Enum.Material.Metal, false)
		end
	end
end

-- ── Weld + restore pivot ─────────────────────────────────────────────────────
AB.weldAll(m)
pcall(function() m:PivotTo(originalPivot) end)

print(string.format(
	"[RideRebuildLogFlume] Rebuilt LogFlume as Belle-Époque Water Flume — %d parts",
	#m:GetDescendants()
))
