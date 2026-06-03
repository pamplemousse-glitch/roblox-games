-- RideRebuildTiltAWhirl: rebuild workspace.TiltAWhirl as a Pancake Stack for
-- Frank's Fairground (food-shaped rides v1.0).
--
-- Contract (see docs/RIDE_REBUILD_PLAYBOOK.md §6):
--   - Spin ride; RideController SPIN_RIDES rps=0.75 stays unchanged.
--   - RideController scans direct Seat children of the model — must preserve.
--   - PrimaryPart set to `Body` (top pancake) so the model has a deterministic
--     anchor part for any post-merge tooling.
--   - 2x footprint vs the original (~80-stud pancake diameter at base).
--
-- Idempotent: backs up existing children to ServerStorage, then ClearAllChildren
-- so the Model instance is preserved and RideController can still FindFirstChild.

local ServerStorage   = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AB              = require(ReplicatedStorage.Common.AssetBuilder)

-- Let any other ride-rebuild scripts settle first so workspace doesn't get
-- thrashed by parallel ClearAllChildren calls on adjacent models.
task.wait(1)

local m = workspace:FindFirstChild("TiltAWhirl") :: Model?
if not m then
	warn("[RideRebuildTiltAWhirl] workspace.TiltAWhirl not found — skipping rebuild.")
	return
end

-- ── 1. Capture original pivot + back up old model ────────────────────────────
local originalPivot = m:GetPivot()

local backup = m:Clone()
backup.Name   = "TiltAWhirl_PreFood_2026-06-03"
backup.Parent = ServerStorage

m:ClearAllChildren()
m.PrimaryPart = nil

-- ── 2. Palette ───────────────────────────────────────────────────────────────
local PANCAKE_TAN     = Color3.fromRGB(225, 185, 130)  -- light golden batter
local PANCAKE_RIM     = Color3.fromRGB(170, 110, 60)   -- crispy edge
local BUTTER_YELLOW   = Color3.fromRGB(250, 220, 90)
local BUTTER_HIGHLIGHT= Color3.fromRGB(255, 235, 140)
local SYRUP_AMBER     = Color3.fromRGB(160, 85, 25)
local SYRUP_GLOSS     = Color3.fromRGB(210, 130, 50)

-- ── 3. Geometry constants (2× original footprint) ────────────────────────────
-- Original TiltAWhirl was ~28-stud diameter. 2× = 56. The previous 80-stud +
-- 5-layer stack was both too wide AND too tall (reads as a wedding cake tower
-- next to the spawn). Reduced to a single thick pancake at ~56 stud diameter.
local PLATFORM_DIAM   = 56        -- single pancake platform
local STACK_LAYERS    = 1         -- one thick pancake, not a stacked tower
local LAYER_HEIGHT    = 4
local LAYER_SHRINK    = 0
local CAR_COUNT       = 6         -- butter-pat cars
local CAR_RADIUS      = 18        -- distance from center to each butter pat

-- Work in local space; we PivotTo() to originalPivot at the end so we stay
-- exactly where the original ride was placed.
local originCF = CFrame.new(0, 0, 0)

-- ── 4. Pancake stack (rotating platform) ─────────────────────────────────────
-- Build bottom-up so the visually-largest pancake ends up on top.
-- Bottom Y for the lowest pancake sits at y=0; stack grows upward.
local pancakeParts: { BasePart } = {}

for i = 1, STACK_LAYERS do
	local fromBottom = i              -- 1 = bottom
	local fromTop    = STACK_LAYERS - i + 1
	-- Largest on top: top pancake has full PLATFORM_DIAM, each one below shrinks.
	local diameter   = PLATFORM_DIAM - (fromTop - 1) * LAYER_SHRINK
	local yCenter    = (fromBottom - 0.5) * LAYER_HEIGHT

	-- Pancake body (tan disc)
	local body = AB.cylinder(
		diameter, LAYER_HEIGHT,
		PANCAKE_TAN,
		originCF * CFrame.new(0, yCenter, 0),
		m,
		i == STACK_LAYERS and "Body" or ("Pancake_" .. i)
	)
	body.Material = Enum.Material.Sand  -- batter-ish flecking
	table.insert(pancakeParts, body)

	-- Golden-brown rim ring (thin torus-ish: a slightly-larger, shorter cylinder
	-- offset to align with the pancake's outer edge band).
	local rim = AB.cylinder(
		diameter + 1.2, LAYER_HEIGHT * 0.45,
		PANCAKE_RIM,
		originCF * CFrame.new(0, yCenter, 0),
		m,
		"PancakeRim_" .. i
	)
	rim.Material = Enum.Material.WoodPlanks  -- crisp griddled feel without neon
	table.insert(pancakeParts, rim)
end

-- The "Body" we want as PrimaryPart is the topmost pancake (the platform deck
-- the seats sit on). Locate it by name.
local topPancake = m:FindFirstChild("Body") :: BasePart?
assert(topPancake, "topmost pancake (Body) missing — build sequence wrong")

local topY = topPancake.Position.Y + LAYER_HEIGHT * 0.5   -- top surface of top pancake

-- ── 5. Syrup pour — a giant amber puddle on top of the stack ─────────────────
-- Sits flush on top of the deck so the platform "drips" syrup outward.
local syrupPuddle = AB.cylinder(
	PLATFORM_DIAM - 2, 0.6,
	SYRUP_AMBER,
	originCF * CFrame.new(0, topY + 0.3, 0),
	m,
	"SyrupPuddle"
)
syrupPuddle.Material   = Enum.Material.Glass
syrupPuddle.Reflectance = 0.15

-- ── 6. Syrup river — sloped amber channels draping over the platform edge ───
-- 8 wedge-like "drips" running tangentially around the rim.
local SYRUP_DRIP_COUNT = 8
for i = 1, SYRUP_DRIP_COUNT do
	local angleDeg = (i - 1) * (360 / SYRUP_DRIP_COUNT)
	local angRad   = math.rad(angleDeg)
	local rOuter   = PLATFORM_DIAM * 0.5
	local x        = math.cos(angRad) * rOuter
	local z        = math.sin(angRad) * rOuter

	-- Drip body: a tall sloped block hugging the rim, oozing down a few studs.
	local drip = AB.block(
		Vector3.new(10, 6, 3),
		SYRUP_AMBER,
		originCF
			* CFrame.new(x, topY - 2.5, z)
			* CFrame.Angles(0, -angRad + math.rad(90), math.rad(18)),
		m,
		"SyrupDrip_" .. i
	)
	drip.Material   = Enum.Material.Glass
	drip.Reflectance = 0.2

	-- Gloss highlight on each drip
	local gloss = AB.block(
		Vector3.new(8, 0.3, 0.8),
		SYRUP_GLOSS,
		originCF
			* CFrame.new(x * 0.96, topY - 1.2, z * 0.96)
			* CFrame.Angles(0, -angRad + math.rad(90), math.rad(18)),
		m,
		"SyrupGloss_" .. i
	)
	gloss.Material   = Enum.Material.Neon
	gloss.Reflectance = 0
end

-- ── 7. Butter-pat cars + Seats ───────────────────────────────────────────────
-- Yellow rounded blocks sitting on top of the syrup, each with a Seat the
-- RideController will pick up via getSeats(model).

for i = 1, CAR_COUNT do
	local angRad = ((i - 1) / CAR_COUNT) * 2 * math.pi
	local x      = math.cos(angRad) * CAR_RADIUS
	local z      = math.sin(angRad) * CAR_RADIUS

	-- Butter pat: a wide flat block with a slightly-narrower highlight on top
	-- so it reads as a pat of butter, not a brick.
	local patBase = AB.block(
		Vector3.new(7, 1.6, 7),
		BUTTER_YELLOW,
		originCF * CFrame.new(x, topY + 1.2, z) * CFrame.Angles(0, -angRad, 0),
		m,
		"ButterPat_" .. i
	)
	patBase.Material = Enum.Material.SmoothPlastic

	local patHi = AB.block(
		Vector3.new(5.5, 0.5, 5.5),
		BUTTER_HIGHLIGHT,
		originCF * CFrame.new(x, topY + 2.25, z) * CFrame.Angles(0, -angRad, 0),
		m,
		"ButterPatHi_" .. i
	)
	patHi.Material = Enum.Material.SmoothPlastic

	-- Subtle melt drips down each pat's leading edge.
	local meltX = x + math.cos(angRad) * 3.2
	local meltZ = z + math.sin(angRad) * 3.2
	AB.block(
		Vector3.new(1.4, 1.8, 1.4),
		BUTTER_HIGHLIGHT,
		originCF * CFrame.new(meltX, topY + 0.9, meltZ),
		m,
		"ButterMelt_" .. i
	)

	-- Seat for this car. Direct child of m (RideController.getSeats requires it).
	-- Seat sits ON TOP of the pat, facing inward (toward center) for that classic
	-- tilt-a-whirl carriage feel.
	local seat = Instance.new("Seat")
	seat.Name          = "Seat_" .. i
	seat.Size          = Vector3.new(3, 0.5, 2.5)
	seat.Color         = BUTTER_HIGHLIGHT
	seat.Material      = Enum.Material.SmoothPlastic
	seat.Anchored      = true
	seat.CanCollide    = true
	seat.TopSurface    = Enum.SurfaceType.Smooth
	seat.BottomSurface = Enum.SurfaceType.Smooth
	-- Face inward: build a local CFrame in originCF's frame (we PivotTo at end).
	local seatLocalPos = Vector3.new(x, topY + 2.7, z)
	-- Yaw the seat so its +Z (forward) points toward the center of the deck.
	-- Standard Roblox convention: lookAt(eye, target) makes -Z face the target,
	-- which is what Seat occupants visually sit on top of, so use it directly.
	seat.CFrame = originCF
		* CFrame.lookAt(seatLocalPos, Vector3.new(0, seatLocalPos.Y, 0))
	seat.Parent = m

	-- Tiny backrest behind the seat so it reads as a seat, not a stub.
	AB.block(
		Vector3.new(3, 1.8, 0.4),
		BUTTER_HIGHLIGHT,
		originCF * CFrame.new(
			seatPos.X + math.cos(angRad) * 1.2,
			seatPos.Y + 1.0,
			seatPos.Z + math.sin(angRad) * 1.2
		) * CFrame.Angles(0, -angRad, 0),
		m,
		"ButterBack_" .. i
	)
end

-- ── 8. Decorative: powdered-sugar dusting on the top pancake ─────────────────
-- A few tiny white discs scattered on the deck for visual interest. Optional.
for i = 1, 5 do
	local angRad = math.rad(i * 73)   -- 73° step → irregular pattern
	local r      = (PLATFORM_DIAM * 0.5 - 8) * (0.3 + (i % 3) * 0.2)
	AB.cylinder(
		1.8 + (i % 2) * 0.6, 0.2,
		Color3.fromRGB(245, 240, 230),
		originCF * CFrame.new(math.cos(angRad) * r, topY + 0.7, math.sin(angRad) * r),
		m,
		"SugarDust_" .. i
	)
end

-- ── 9. Finalize: PrimaryPart, weld, pivot to original location ───────────────
m.PrimaryPart = topPancake
AB.weldAll(m)
m:PivotTo(originalPivot)

print(("[RideRebuildTiltAWhirl] rebuilt — %d descendants (Pancake Stack, %d butter-pat cars)")
	:format(#m:GetDescendants(), CAR_COUNT))
