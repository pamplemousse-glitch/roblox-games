-- RideRebuildScreamerCoaster.server.luau
-- Frank's Fairground food-shape pass: ScreamerCoaster → Spaghetti Coaster.
--
-- HARD constraints (per docs/RIDE_REBUILD_PLAYBOOK.md §2):
--   * Preserve every waypoint part name + XYZ: ArcN0_2..ArcN15_2 (16),
--     RailA0_2..RailA49_2 (50), ArcF0_2..ArcF15_2 (16), RailB0_2..RailB49_2 (50)
--     → 132 parts total, read positionally by buildWaypoints() in RideController.
--   * ScreamerCart.Body stays as PrimaryPart of the cart model.
--   * ReplicatedStorage.Remotes.CoasterFade is untouched.
--
-- We can't use ClearAllChildren — it would nuke the 132 waypoints. Instead we
-- whitelist what to keep and Destroy the rest.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage     = game:GetService("ServerStorage")
local AB = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetBuilder"))

local PASTA_YELLOW   = Color3.fromRGB(245, 215, 120)
local TOMATO_RED     = AB.colors.tomato
local SAUCE_DARK     = Color3.fromRGB(150, 30, 25)
local PARMESAN       = Color3.fromRGB(245, 240, 215)
local PARMESAN_DARK  = Color3.fromRGB(215, 205, 165)
local MEATBALL_BROWN = Color3.fromRGB(110, 65, 40)
local BASIL          = Color3.fromRGB(85, 145, 70)
local STAMP          = "_PreFood_2026-06-03"

-- ── Waypoint helpers ────────────────────────────────────────────────────────

local function buildKeepSet(): { [string]: boolean }
	local set = {}
	for i = 0, 15 do set["ArcN"  .. i .. "_2"] = true end
	for i = 0, 49 do set["RailA" .. i .. "_2"] = true end
	for i = 0, 15 do set["ArcF"  .. i .. "_2"] = true end
	for i = 0, 49 do set["RailB" .. i .. "_2"] = true end
	return set
end

-- Traversal order matches RideController.buildWaypoints (RailB reversed).
local function collectOrdered(sc: Model): { BasePart }
	local out: { BasePart } = {}
	local function append(prefix: string, from: number, to: number, step: number)
		for i = from, to, step do
			local p = sc:FindFirstChild(prefix .. i .. "_2")
			if p and p:IsA("BasePart") then table.insert(out, p) end
		end
	end
	append("ArcN", 0, 15, 1)
	append("RailA", 0, 49, 1)
	append("ArcF", 0, 15, 1)
	append("RailB", 49, 0, -1)
	return out
end

local function basisAt(a: Vector3, b: Vector3): (Vector3, Vector3, number)
	local d = b - a
	local len = d.Magnitude
	if len < 0.05 then return Vector3.zAxis, Vector3.xAxis, 0 end
	local fwd = d.Unit
	local right = fwd:Cross(Vector3.yAxis)
	if right.Magnitude < 0.001 then right = Vector3.xAxis else right = right.Unit end
	return fwd, right, len
end

-- ── Decoration builders ─────────────────────────────────────────────────────

-- Two parallel pasta strands offset perpendicular to each waypoint segment.
local function buildSideRails(wps: { BasePart }, deco: Folder)
	local THICK, OFFSET = 0.9, 2.2
	for i = 1, #wps - 1 do
		local a, b = wps[i].Position, wps[i + 1].Position
		local fwd, right, len = basisAt(a, b)
		if len == 0 then continue end
		local mid = (a + b) / 2
		for sign = -1, 1, 2 do
			local center = mid + right * (OFFSET * sign)
			-- lookAt → -Z forward; +90° Y aligns +X with travel for the block.
			local cf = CFrame.lookAt(center, center + fwd) * CFrame.Angles(0, math.rad(90), 0)
			AB.part({
				size = Vector3.new(len + 0.2, THICK, THICK),
				color = PASTA_YELLOW, cf = cf, name = "PastaRail",
			}, deco).Reflectance = 0.05
		end
	end
end

-- Parmesan-block ties between rails every `stride`-th segment.
local function buildTies(wps: { BasePart }, deco: Folder, stride: number)
	for i = 1, #wps - 1, stride do
		local a, b = wps[i].Position, wps[i + 1].Position
		local fwd, right, len = basisAt(a, b)
		if len == 0 then continue end
		local mid = (a + b) / 2 + Vector3.new(0, -0.4, 0)
		local cf  = CFrame.lookAt(mid, mid + fwd)
		AB.part({
			size = Vector3.new(0.8, 0.5, 5.4),
			color = (i % (stride * 2) == 0) and PARMESAN or PARMESAN_DARK,
			cf = cf, name = "ParmesanTie",
		}, deco)
	end
end

-- Tomato-sauce ramp paint under the upper 45% of waypoint heights (lift hill).
local function buildLiftHillPaint(wps: { BasePart }, deco: Folder)
	local maxY, minY = -math.huge, math.huge
	for _, p in wps do
		local y = p.Position.Y
		if y > maxY then maxY = y end
		if y < minY then minY = y end
	end
	local threshold = minY + (maxY - minY) * 0.55
	for i = 1, #wps - 1 do
		local a, b = wps[i].Position, wps[i + 1].Position
		if (a.Y + b.Y) / 2 < threshold then continue end
		local fwd, _, len = basisAt(a, b)
		if len == 0 then continue end
		local mid = (a + b) / 2 + Vector3.new(0, -0.9, 0)
		AB.part({
			size = Vector3.new(0.6, 0.3, 6.2),
			color = TOMATO_RED, cf = CFrame.lookAt(mid, mid + fwd),
			name = "SaucePaint",
		}, deco)
	end
end

-- Station house at the boarding waypoint (wps[1]).
local function buildStation(wps: { BasePart }, deco: Folder)
	if #wps < 2 then return end
	local p0 = wps[1].Position
	local fwd, _, _ = basisAt(p0, wps[2].Position)
	local base = p0 - fwd * 6 + Vector3.new(0, -2, 0)
	local baseCF = CFrame.lookAt(base, base + fwd)
	AB.part({ size = Vector3.new(16, 0.6, 10), color = PARMESAN,
		cf = baseCF, name = "StationPlatform" }, deco)
	AB.part({ size = Vector3.new(16, 0.4, 10), color = TOMATO_RED,
		cf = baseCF * CFrame.new(0, 7, 0), name = "StationAwning" }, deco)
	for sx = -1, 1, 2 do
		for sz = -1, 1, 2 do
			AB.cylinder(0.8, 7, PASTA_YELLOW,
				baseCF * CFrame.new(7 * sx, 3.5, 4 * sz), deco, "ForkColumn")
		end
	end
	for i = -1, 1 do
		AB.sphere(2.2, BASIL, baseCF * CFrame.new(i * 5, 8.2, 0), deco, "BasilTuft")
	end
end

-- Meatball garnish scattered near the station.
local function buildMeatballGarnish(wps: { BasePart }, deco: Folder)
	if #wps < 2 then return end
	local p0 = wps[1].Position
	for i = 1, 5 do
		local theta = (i / 5) * math.pi * 2
		local r = 6 + (i % 2) * 2
		local pos = p0 + Vector3.new(math.cos(theta) * r, -1.7, math.sin(theta) * r - 4)
		AB.sphere(2.0 + (i % 3) * 0.4, MEATBALL_BROWN, CFrame.new(pos), deco, "MeatballGarnish")
	end
end

-- ── Cart re-skin ────────────────────────────────────────────────────────────

local function rebuildCart()
	local cart = workspace:FindFirstChild("ScreamerCart")
	if not (cart and cart:IsA("Model")) then
		warn("[RideRebuildScreamerCoaster] ScreamerCart missing — skipping cart re-skin.")
		return
	end
	local cartBackup = cart:Clone()
	cartBackup.Name = "ScreamerCart" .. STAMP
	cartBackup.Parent = ServerStorage

	local body = cart:FindFirstChild("Body")
	if not (body and body:IsA("BasePart")) then
		warn("[RideRebuildScreamerCoaster] ScreamerCart.Body missing — leaving cart untouched.")
		return
	end
	for _, c in cart:GetChildren() do
		if c ~= body then c:Destroy() end
	end
	cart.PrimaryPart = body

	-- Body becomes the meatball.
	body.Shape         = Enum.PartType.Ball
	local s            = math.max(body.Size.X, body.Size.Y, body.Size.Z, 3.5) * 1.4
	body.Size          = Vector3.new(s, s, s)
	body.Color         = MEATBALL_BROWN
	body.Material      = Enum.Material.Slate
	body.Anchored      = true
	body.CanCollide    = true
	body.TopSurface    = Enum.SurfaceType.Smooth
	body.BottomSurface = Enum.SurfaceType.Smooth

	local function weldTo(part: BasePart)
		part.Parent = cart
		local w = Instance.new("WeldConstraint")
		w.Part0 = body; w.Part1 = part; w.Parent = part
	end
	for i = 1, 8 do
		local theta = (i / 8) * math.pi * 2
		local y = (i % 2 == 0) and 0.6 or -0.4
		weldTo(AB.part({
			size = Vector3.new(0.6, 0.25, 0.6), color = PARMESAN,
			cf = body.CFrame * CFrame.new(math.cos(theta) * (s * 0.45), y, math.sin(theta) * (s * 0.45)),
			name = "Sprinkle" .. i,
		}))
	end
	local cap = AB.sphere(s * 0.85, SAUCE_DARK, body.CFrame * CFrame.new(0, s * 0.3, 0), nil, "SauceCap")
	weldTo(cap)
	weldTo(AB.sphere(1.3, BASIL, body.CFrame * CFrame.new(0, s * 0.55, 0), nil, "BasilSprig"))
end

-- ── Main rebuild ────────────────────────────────────────────────────────────

task.wait(1) -- let peer rebuild scripts settle

local sc = workspace:FindFirstChild("ScreamerCoaster")
if not (sc and sc:IsA("Model")) then
	warn("[RideRebuildScreamerCoaster] ScreamerCoaster missing — bailing.")
	return
end

local backup = sc:Clone(); backup.Name = "ScreamerCoaster" .. STAMP; backup.Parent = ServerStorage

local keep = buildKeepSet()
local kept, destroyed = 0, 0
for _, child in sc:GetChildren() do
	if keep[child.Name] then kept += 1 else child:Destroy(); destroyed += 1 end
end

local wps = collectOrdered(sc)
if #wps < 4 then
	warn(string.format("[RideRebuildScreamerCoaster] only %d waypoints — decoration skipped.", #wps))
	return
end

local deco = Instance.new("Folder")
deco.Name   = "FoodDecoration"
deco.Parent = sc

buildSideRails(wps, deco)
buildTies(wps, deco, 3)
buildLiftHillPaint(wps, deco)
buildStation(wps, deco)
buildMeatballGarnish(wps, deco)

-- NOTE: we deliberately do NOT touch sc.PrimaryPart or weldAll(sc). The
-- contract is name-based positional lookup of the 132 waypoint parts, and
-- RideController never reads sc.PrimaryPart.

rebuildCart()

print(string.format(
	"[RideRebuildScreamerCoaster] kept=%d waypoints, destroyed=%d old children, built=%d decoration parts.",
	kept, destroyed, #deco:GetChildren()
))
