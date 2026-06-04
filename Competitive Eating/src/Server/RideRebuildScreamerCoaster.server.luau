-- RideRebuildScreamerCoaster.server.luau
-- Belle-Époque rebuild: ScreamerCoaster → Wooden Cyclone-style Coaster.
-- Reference: Coney Island Cyclone (1927). Ivory truss columns, deep_wood ties,
-- antique_gold rivet plates, burgundy lift-hill paint, burgundy car w/ ivory + gold.
-- HARD constraints (docs/BELLE_EPOQUE_RIDE_PLAYBOOK.md §2): preserve all 132
-- named waypoints (ArcN0..15_2, RailA0..49_2, ArcF0..15_2, RailB0..49_2) at their
-- exact XYZ — buildWaypoints() in RideController reads them positionally.
-- ScreamerCart.Body stays as cart PrimaryPart. CoasterFade remote untouched.
-- PivotAnchor mandatory on the coaster (universal §5). Whitelist + Destroy (no
-- :ClearAllChildren — would nuke waypoints).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage     = game:GetService("ServerStorage")
local AB = require(ReplicatedStorage:WaitForChild("Common"):WaitForChild("AssetBuilder"))

-- Belle-Époque palette (playbook §26).
local BURGUNDY     = AB.colors.burgundy            -- (110, 30, 40)
local IVORY        = AB.colors.ivory               -- (230, 220, 195)
local DEEP_WOOD    = AB.colors.deepWood            -- ( 80, 50, 30)
local WOOD_PLANK   = Color3.fromRGB(160, 110, 70)
local ANTIQUE_GOLD = Color3.fromRGB(200, 160, 80)
local WROUGHT_IRON = Color3.fromRGB( 40,  35, 40)
local CRIMSON_GLOW = Color3.fromRGB(220,  60, 70)
local STAMP        = "_PreBelleEpoque_2026-06-03"

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

-- Twin deep_wood rails + antique_gold rivet plates at each segment join.
local function buildTrackRails(wps, deco)
	local THICK, OFFSET = 1.2, 2.4
	for i = 1, #wps - 1 do
		local a, b = wps[i].Position, wps[i + 1].Position
		local fwd, right, len = basisAt(a, b); if len == 0 then continue end
		local mid = (a + b) / 2
		for sign = -1, 1, 2 do
			local c = mid + right * (OFFSET * sign)
			local cf = CFrame.lookAt(c, c + fwd) * CFrame.Angles(0, math.rad(90), 0)
			AB.part({ size=Vector3.new(len + 0.2, THICK, THICK), color=DEEP_WOOD,
				material=Enum.Material.Wood, cf=cf, name="TrackRail" }, deco)
			local pp = c - fwd * (len * 0.5)
			AB.part({ size=Vector3.new(0.4, THICK + 0.3, THICK + 0.3), color=ANTIQUE_GOLD,
				material=Enum.Material.Metal, reflectance=0.15, name="RivetPlate",
				cf=CFrame.lookAt(pp, pp + fwd) * CFrame.Angles(0, math.rad(90), 0) }, deco)
		end
	end
end

-- Deep-wood ties spanning between rails every Nth segment.
local function buildTies(wps, deco, stride)
	for i = 1, #wps - 1, stride do
		local a, b = wps[i].Position, wps[i + 1].Position
		local fwd, _, len = basisAt(a, b); if len == 0 then continue end
		local mid = (a + b) / 2 + Vector3.new(0, -0.6, 0)
		AB.part({ size=Vector3.new(0.9, 0.5, 6.2),
			color=(i % (stride * 2) == 0) and DEEP_WOOD or WOOD_PLANK,
			material=Enum.Material.Wood, cf=CFrame.lookAt(mid, mid + fwd), name="Tie" }, deco)
	end
end

-- Ivory lattice columns dropping from elevated waypoints to ground.
local function buildTrussColumns(wps, deco)
	local minY = math.huge
	for _, p in wps do if p.Position.Y < minY then minY = p.Position.Y end end
	local groundY = minY - 6
	for i = 1, #wps, 5 do
		local p = wps[i]; local h = p.Position.Y - groundY
		if h < 4 then continue end
		local baseY = (p.Position.Y + groundY) / 2
		local cx, cz = p.Position.X, p.Position.Z
		for sx = -1, 1, 2 do for sz = -1, 1, 2 do
			AB.part({ size=Vector3.new(0.8, h, 0.8), color=IVORY, material=Enum.Material.Wood,
				name="TrussLeg", cf=CFrame.new(cx + sx * 1.6, baseY, cz + sz * 1.6) }, deco)
		end end
		for lvl = 1, 3 do
			local y = groundY + h * (lvl / 4)
			for face = 0, 3 do
				local ang = face * math.pi / 2
				local nx, nz = math.cos(ang), math.sin(ang)
				local fcx, fcz = cx + nx * 1.6, cz + nz * 1.6
				local bCF = CFrame.lookAt(Vector3.new(fcx, y, fcz), Vector3.new(fcx - nz, y, fcz + nx))
				for diag = -1, 1, 2 do
					AB.part({ size=Vector3.new(0.35, 0.35, 4.5), color=IVORY, material=Enum.Material.Wood,
						name="TrussBrace", cf=bCF * CFrame.Angles(0, 0, math.rad(diag * 35)) }, deco)
				end
			end
		end
		AB.part({ size=Vector3.new(3.6, 0.4, 3.6), color=ANTIQUE_GOLD, material=Enum.Material.Metal,
			reflectance=0.15, name="ColumnCap", cf=CFrame.new(cx, p.Position.Y - 0.3, cz) }, deco)
	end
end

-- Burgundy lift-hill paint stripe on the upper 45% of the run.
local function buildLiftHillPaint(wps, deco)
	local maxY, minY = -math.huge, math.huge
	for _, p in wps do
		if p.Position.Y > maxY then maxY = p.Position.Y end
		if p.Position.Y < minY then minY = p.Position.Y end
	end
	local threshold = minY + (maxY - minY) * 0.55
	for i = 1, #wps - 1 do
		local a, b = wps[i].Position, wps[i + 1].Position
		if (a.Y + b.Y) / 2 < threshold then continue end
		local fwd, _, len = basisAt(a, b)
		if len == 0 then continue end
		local mid = (a + b) / 2 + Vector3.new(0, -1.3, 0)
		AB.part({ size=Vector3.new(0.7, 0.4, 7.0), color=BURGUNDY,
			material=Enum.Material.Wood, name="LiftHillStripe",
			cf=CFrame.lookAt(mid, mid + fwd) }, deco)
	end
end

-- Wrought-iron handrails along the catwalk.
local function buildHandrails(wps, deco)
	for i = 1, #wps - 1, 2 do
		local a, b = wps[i].Position, wps[i + 1].Position
		local fwd, right, len = basisAt(a, b)
		if len == 0 then continue end
		local mid = (a + b) / 2 + Vector3.new(0, 1.6, 0)
		for sign = -1, 1, 2 do
			local c = mid + right * (3.2 * sign)
			AB.part({ size=Vector3.new(0.2, 0.2, len + 0.2), color=WROUGHT_IRON,
				material=Enum.Material.Metal, name="Handrail",
				cf=CFrame.lookAt(c, c + fwd) }, deco)
		end
	end
end

-- Classic wooden Cyclone station house at waypoint 1.
local function buildStation(wps, deco)
	if #wps < 2 then return end
	local p0 = wps[1].Position
	local fwd, _, _ = basisAt(p0, wps[2].Position)
	local baseCF = CFrame.lookAt(p0 - fwd * 8 + Vector3.new(0, -2.4, 0), p0 - fwd * 7)
	AB.part({ size=Vector3.new(20, 0.6, 12), color=WOOD_PLANK, material=Enum.Material.Wood, cf=baseCF, name="StationPlatform" }, deco)
	for stripe = -2, 2 do
		AB.part({ size=Vector3.new(20, 0.35, 2.2), color=(stripe % 2 == 0) and BURGUNDY or IVORY,
			material=Enum.Material.Fabric, name="AwningStripe", cf=baseCF * CFrame.new(0, 8.2, stripe * 2.2) }, deco)
	end
	for sx = -1, 1, 2 do for sz = -1, 1, 2 do
		AB.part({ size=Vector3.new(0.9, 8, 0.9), color=DEEP_WOOD, material=Enum.Material.Wood,
			name="StationPost", cf=baseCF * CFrame.new(sx * 9, 4, sz * 5) }, deco)
	end end
	AB.part({ size=Vector3.new(20.4, 0.3, 12.4), color=ANTIQUE_GOLD, material=Enum.Material.Metal,
		reflectance=0.1, name="AwningTrim", cf=baseCF * CFrame.new(0, 7.8, 0) }, deco)
	AB.part({ size=Vector3.new(14, 2.6, 0.4), color=BURGUNDY, material=Enum.Material.Wood,
		name="StationSign", cf=baseCF * CFrame.new(0, 11, -6) }, deco)
	AB.part({ size=Vector3.new(13.6, 0.3, 0.5), color=CRIMSON_GLOW, material=Enum.Material.Neon,
		name="SignGlow", cf=baseCF * CFrame.new(0, 9.5, -6) }, deco)
end

-- ── Cart re-skin ────────────────────────────────────────────────────────────
-- Body stays as cart PrimaryPart (axis-aligned block, no PivotAnchor needed).

local function rebuildCart()
	local cart = workspace:FindFirstChild("ScreamerCart")
	if not (cart and cart:IsA("Model")) then
		warn("[RideRebuildScreamerCoaster] ScreamerCart missing — skipping cart re-skin."); return
	end
	local cartBackup = cart:Clone(); cartBackup.Name = "ScreamerCart" .. STAMP; cartBackup.Parent = ServerStorage
	local body = cart:FindFirstChild("Body")
	if not (body and body:IsA("BasePart")) then
		warn("[RideRebuildScreamerCoaster] ScreamerCart.Body missing — leaving cart untouched."); return
	end
	for _, c in cart:GetChildren() do if c ~= body then c:Destroy() end end
	cart.PrimaryPart = body
	-- Classic wooden coaster car: burgundy body + ivory trim + antique-gold rivets.
	body.Shape = Enum.PartType.Block
	local baseS = math.max(body.Size.X, body.Size.Y, body.Size.Z, 3.0)
	local L, W, H = baseS * 1.82, baseS * 1.30, baseS * 0.91
	body.Size, body.Color, body.Material = Vector3.new(L, H, W), BURGUNDY, Enum.Material.Wood
	body.Anchored, body.CanCollide = true, true
	body.TopSurface, body.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
	local function weldTo(part)
		part.Parent = cart
		local w = Instance.new("WeldConstraint"); w.Part0 = body; w.Part1 = part; w.Parent = part
	end

	weldTo(AB.part({ size=Vector3.new(L + 0.05, 0.35, W + 0.05), color=IVORY, material=Enum.Material.Wood,
		name="TrimStripe", cf=body.CFrame * CFrame.new(0, H * 0.4, 0) }))
	for sz = -1, 1, 2 do for i = -2, 2 do
		weldTo(AB.part({ size=Vector3.new(0.4, 0.4, 0.4), color=ANTIQUE_GOLD, material=Enum.Material.Metal,
			reflectance=0.2, name="Rivet" .. (sz > 0 and "R" or "L") .. (i + 3),
			cf=body.CFrame * CFrame.new(i * (L * 0.18), H * 0.1, sz * (W * 0.55)) }))
	end end
	weldTo(AB.part({ size=Vector3.new(0.6, H * 1.3, W * 0.9), color=DEEP_WOOD, material=Enum.Material.Wood,
		name="Backrest", cf=body.CFrame * CFrame.new(-L * 0.42, H * 0.55, 0) }))
	weldTo(AB.part({ size=Vector3.new(0.6, H * 0.7, W * 0.95), color=IVORY, material=Enum.Material.Wood,
		name="NosePanel", cf=body.CFrame * CFrame.new(L * 0.5, 0, 0) }))
	for sx = -1, 1, 2 do
		weldTo(AB.part({ size=Vector3.new(0.4, 0.4, W + 0.6), color=WROUGHT_IRON, material=Enum.Material.Metal,
			name="Axle" .. (sx > 0 and "F" or "R"), cf=body.CFrame * CFrame.new(sx * L * 0.32, -H * 0.5, 0) }))
	end
end

-- ── Main rebuild ────────────────────────────────────────────────────────────

task.wait(1)

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

-- PivotAnchor (universal §5): mandatory invisible identity-rotation marker.
-- RideController never reads sc.PrimaryPart (positional waypoint lookup), so
-- this is hygiene only, but the playbook requires it on every Belle-Époque rebuild.
local pivotAnchor = AB.part({ size=Vector3.new(0.1, 0.1, 0.1), color=Color3.new(1, 1, 1),
	cf=sc:GetPivot(), canCollide=false, transparency=1, name="PivotAnchor" }, sc)
sc.PrimaryPart = pivotAnchor

local deco = Instance.new("Folder"); deco.Name = "BelleEpoqueDecoration"; deco.Parent = sc

buildTrackRails(wps, deco)
buildTies(wps, deco, 3)
buildTrussColumns(wps, deco)
buildLiftHillPaint(wps, deco)
buildHandrails(wps, deco)
buildStation(wps, deco)

-- NOTE: do NOT weldAll(sc). Waypoint parts must stay independent (positional
-- lookup by name); decoration parts are anchored so welding is unnecessary.
rebuildCart()

print(string.format(
	"[RideRebuildScreamerCoaster] kept=%d waypoints, destroyed=%d old children, built=%d decoration parts.",
	kept, destroyed, #deco:GetChildren()
))
