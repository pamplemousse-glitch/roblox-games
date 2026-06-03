-- FranksSkyAndRiver: cotton candy cloud layer + mustard river strip.
-- Pure primitive build. Parents under workspace.FranksSkyAndRiver so
-- AssetSpawner's `Districts:ClearAllChildren` pass doesn't wipe it.
--
-- Clouds: 24 pink Neon spheres (radius 8-15) at Y=80-100 across
--         X=-300..300, Z=-300..300, with white wisps around each.
-- River:  long yellow trench along X=280..320 Z=-200..200,
--         with darker yellow banks 1-stud-tall on either side.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AB                = require(ReplicatedStorage.Common.AssetBuilder)

local CC_PINK     = Color3.fromRGB(255, 200, 230)
local CC_MAGENTA  = Color3.fromRGB(245, 165, 210)
local CC_WHITE    = Color3.fromRGB(252, 248, 252)
local MUSTARD     = Color3.fromRGB(255, 200,  60)
local MUSTARD_DK  = Color3.fromRGB(200, 155,  35)
local MUSTARD_BNK = Color3.fromRGB(180, 135,  30)

-- Idempotent reset
local existing = workspace:FindFirstChild("FranksSkyAndRiver")
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name   = "FranksSkyAndRiver"
root.Parent = workspace

-- ── Cotton candy clouds ──────────────────────────────────────────────────────
local clouds = AB.model("CottonCandyClouds", root)

-- Deterministic-ish pattern: 24 clusters laid in a loose 6x4 grid with jitter.
math.randomseed(1729)
for i = 1, 24 do
	local jitterX = math.random(-30, 30)
	local jitterZ = math.random(-30, 30)
	local cellX   = -300 + ((i - 1) % 6) * 120
	local cellZ   = -300 + math.floor((i - 1) / 6) * 200
	local x       = cellX + jitterX
	local z       = cellZ + jitterZ
	local y       = 80 + math.random(0, 20)
	local r       = 8 + math.random(0, 7)
	local color   = (i % 2 == 0) and CC_PINK or CC_MAGENTA

	-- Core puff (Neon for glow)
	local core = AB.sphere(r * 2, color, CFrame.new(x, y, z), clouds, "CloudCore_" .. i)
	core.Material    = Enum.Material.Neon
	core.CanCollide  = false
	core.Transparency = 0.1

	-- Secondary lobes (2-3 puffs hugging the core)
	for j = 1, 3 do
		local ox = math.random(-r, r)
		local oy = math.random(-2, 2)
		local oz = math.random(-r, r)
		local lobe = AB.sphere(r * 1.4 + math.random(-2, 2), color,
			CFrame.new(x + ox, y + oy, z + oz), clouds, "CloudLobe_" .. i .. "_" .. j)
		lobe.Material   = Enum.Material.Neon
		lobe.CanCollide = false
		lobe.Transparency = 0.15
	end

	-- White wisps (4-6 smaller white spheres)
	for j = 1, 5 do
		local ox = math.random(-r - 4, r + 4)
		local oy = math.random(-3, 5)
		local oz = math.random(-r - 4, r + 4)
		local wisp = AB.sphere(4 + math.random(0, 2), CC_WHITE,
			CFrame.new(x + ox, y + oy, z + oz), clouds, "Wisp_" .. i .. "_" .. j)
		wisp.Material    = Enum.Material.Neon
		wisp.CanCollide  = false
		wisp.Transparency = 0.35
	end
end

-- ── Mustard river ────────────────────────────────────────────────────────────
local river = AB.model("MustardRiver", root)

local RIVER_X_CENTER = 300
local RIVER_Z_START  = -200
local RIVER_Z_END    =  200
local RIVER_LEN      = RIVER_Z_END - RIVER_Z_START -- 400
local RIVER_Z_CENTER = (RIVER_Z_START + RIVER_Z_END) / 2

-- Trench bed (bright mustard, 40-wide × 0.5 deep)
local bed = AB.block(
	Vector3.new(40, 0.5, RIVER_LEN),
	MUSTARD,
	CFrame.new(RIVER_X_CENTER, 0.25, RIVER_Z_CENTER),
	river, "RiverBed")
bed.Material = Enum.Material.SmoothPlastic
bed.CanCollide = true

-- Darker yellow under-shadow strip down the middle for depth
AB.block(
	Vector3.new(8, 0.55, RIVER_LEN - 2),
	MUSTARD_DK,
	CFrame.new(RIVER_X_CENTER, 0.3, RIVER_Z_CENTER),
	river, "RiverShadow")

-- Banks (1-stud-tall darker yellow on either side)
AB.block(
	Vector3.new(2, 1, RIVER_LEN),
	MUSTARD_BNK,
	CFrame.new(RIVER_X_CENTER - 20 - 1, 0.5, RIVER_Z_CENTER),
	river, "BankWest")
AB.block(
	Vector3.new(2, 1, RIVER_LEN),
	MUSTARD_BNK,
	CFrame.new(RIVER_X_CENTER + 20 + 1, 0.5, RIVER_Z_CENTER),
	river, "BankEast")

-- Endcap "blob" plugs so the river doesn't read as a hard rectangle
AB.sphere(14, MUSTARD,    CFrame.new(RIVER_X_CENTER, 0.5, RIVER_Z_START), river, "BlobSouth")
AB.sphere(14, MUSTARD,    CFrame.new(RIVER_X_CENTER, 0.5, RIVER_Z_END),   river, "BlobNorth")
AB.sphere( 6, MUSTARD_DK, CFrame.new(RIVER_X_CENTER, 0.4, RIVER_Z_START), river, "BlobShadowS")
AB.sphere( 6, MUSTARD_DK, CFrame.new(RIVER_X_CENTER, 0.4, RIVER_Z_END),   river, "BlobShadowN")

-- A few rippling "drips" along the length for surface texture
for i = 1, 8 do
	local z = RIVER_Z_START + (i / 9) * RIVER_LEN
	local x = RIVER_X_CENTER + math.random(-10, 10)
	AB.sphere(2.5, MUSTARD_DK, CFrame.new(x, 0.55, z), river, "Drip_" .. i)
end

-- Set primary parts so models can be moved as units
AB.pivot(clouds, clouds:FindFirstChildWhichIsA("BasePart"))
AB.pivot(river, bed)

print(string.format(
	"[FranksSkyAndRiver] spawned: 24 cloud clusters @ Y=80-100, mustard river X=%d Z=%d..%d (len=%d)",
	RIVER_X_CENTER, RIVER_Z_START, RIVER_Z_END, RIVER_LEN
))
