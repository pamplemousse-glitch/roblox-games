-- AssetSpawner: reads the asset manifest and instantiates every registered
-- asset at its world position on server start.
--
-- Asset module contract:
--   each module returns: function(parent: Instance, originCF: CFrame) -> Model
--
-- Manifest entries:
--   { module = "Assets.Districts.PizzaPlaza.Buildings.PizzaParlor", position = Vector3.new(2000, 0, 0), yaw = 0 }

local AssetSpawner = {}

local Common         = game:GetService("ReplicatedStorage").Common
local AssetsFolder   = game:GetService("ReplicatedStorage"):FindFirstChild("Assets")
local manifestModule = Common:FindFirstChild("AssetManifest")

-- Per-district polish modules. Each runs ::apply(model) on any Asset whose
-- manifest `module` path starts with the matching prefix. Order is cosmetic —
-- the prefixes are disjoint so at most one ever fires per asset.
local POLISH_REGISTRY = {
	{ name = "TokyoPolish",   module = Common:FindFirstChild("TokyoPolish"),   prefix = "Assets.Districts.TokyoTown."       },
	{ name = "DonutPolish",   module = Common:FindFirstChild("DonutPolish"),   prefix = "Assets.Districts.DonutDynasty."    },
	{ name = "PizzaPolish",   module = Common:FindFirstChild("PizzaPolish"),   prefix = "Assets.Districts.PizzaPlaza."      },
	{ name = "BurgerPolish",  module = Common:FindFirstChild("BurgerPolish"),  prefix = "Assets.Districts.BurgerBoulevard." },
	{ name = "BbqPolish",     module = Common:FindFirstChild("BbqPolish"),     prefix = "Assets.Districts.BbqHoller."       },
	{ name = "MercadoPolish", module = Common:FindFirstChild("MercadoPolish"), prefix = "Assets.Districts.MercadoDelSol."   },
}

local function findModuleByPath(rootName: string, path: string): ModuleScript?
	-- path like "Assets.Districts.PizzaPlaza.Buildings.PizzaParlor"
	local segments = path:split(".")
	-- skip the first segment (the root container)
	local current: Instance? = AssetsFolder or game:GetService("ReplicatedStorage"):FindFirstChild(rootName)
	if not current then return nil end
	for i = 2, #segments do
		if not current then return nil end
		current = current:FindFirstChild(segments[i])
	end
	return current and current:IsA("ModuleScript") and current or nil
end

function AssetSpawner.init()
	if not manifestModule then
		warn("[AssetSpawner] no AssetManifest module found")
		return
	end

	local manifest = require(manifestModule)
	if typeof(manifest) ~= "table" then
		warn("[AssetSpawner] manifest is not a table")
		return
	end

	local districtsFolder = workspace:FindFirstChild("Districts")
	if districtsFolder then districtsFolder:ClearAllChildren() end
	districtsFolder = districtsFolder or Instance.new("Folder")
	districtsFolder.Name   = "Districts"
	districtsFolder.Parent = workspace

	local ok, total, fail = pcall(function()
		local spawned, failed = 0, 0
		for _, entry in manifest do
			if typeof(entry) ~= "table" or not entry.module then continue end

			local mod = findModuleByPath("Assets", entry.module)
			if not mod then
				warn("[AssetSpawner] module not found: " .. entry.module)
				failed += 1
				continue
			end

			local pos  = entry.position or Vector3.new(0, 0, 0)
			local yaw  = entry.yaw or 0
			local cf   = CFrame.new(pos) * CFrame.Angles(0, math.rad(yaw), 0)

			local fnOk, builder = pcall(require, mod)
			if not fnOk or typeof(builder) ~= "function" then
				warn("[AssetSpawner] module did not return a function: " .. entry.module)
				failed += 1
				continue
			end

			local spawnOk, spawnResult = pcall(function()
				return builder(districtsFolder, cf)
			end)

			if spawnOk then
				spawned += 1
				-- ── Z-fight / shake suppression (Tokyo first; promote to others when verified) ──
				-- Every module currently spawns 50-300 anchored parts that overlap each other
				-- intentionally (wall sticks into foundation, shoji panel embedded in frame,
				-- etc.). Coplanar faces fight for the depth buffer every frame — looks like
				-- the building is "shaking." Two-step fix at spawn time:
				--   1) Only PrimaryPart keeps CanCollide=true. Every other part is decorative
				--      and shouldn't block players or the physics solver.
				--   2) Each non-primary part shrinks by 0.02 stud in each axis. Breaks coplanar
				--      faces with no visible appearance change.
				-- Gated on Tokyo until we verify the user perceives the shake stopping.
				if typeof(spawnResult) == "Instance" and spawnResult:IsA("Model")
				   and entry.module:sub(1, #"Assets.Districts.TokyoTown.") == "Assets.Districts.TokyoTown." then
					local primary = spawnResult.PrimaryPart
					for _, d in ipairs(spawnResult:GetDescendants()) do
						if not d:IsA("BasePart") then continue end
						if d == primary then continue end
						d.CanCollide = false
						d.Size = Vector3.new(
							math.max(0.05, d.Size.X - 0.02),
							math.max(0.05, d.Size.Y - 0.02),
							math.max(0.05, d.Size.Z - 0.02)
						)
					end
				end
				-- Per-district polish pass: PBR materials + lighting bumps. Each
				-- Polish module runs ::apply(model) on assets whose manifest path
				-- matches its prefix. AssetSpawner clears + respawns Districts on
				-- every server start, so the pass runs every session.
				if typeof(spawnResult) == "Instance" and spawnResult:IsA("Model") then
					for _, p in POLISH_REGISTRY do
						if not p.module then continue end
						if entry.module:sub(1, #p.prefix) ~= p.prefix then continue end
						local polishOk, polishErr = pcall(function()
							require(p.module).apply(spawnResult)
						end)
						if not polishOk then
							warn("[AssetSpawner] " .. p.name .. " failed for " .. entry.module .. ": " .. tostring(polishErr))
						end
						break
					end
				end
			else
				warn("[AssetSpawner] spawn failed for " .. entry.module .. ": " .. tostring(spawnResult))
				failed += 1
			end
		end
		return spawned, failed
	end)

	if ok then
		print(string.format("[AssetSpawner] spawned=%d failed=%d total=%d", total, fail or 0, #manifest))
	else
		warn("[AssetSpawner] manifest iteration crashed: " .. tostring(total))
	end

	-- ── Footprint audit ─────────────────────────────────────────────────────
	-- After every asset is spawned, compute each top-level Model's XZ AABB and
	-- warn about any pair whose AABBs intersect. Anchored colliding overlapping
	-- parts are the root cause of the building-shake bug: Roblox's physics
	-- solver tries to push them apart every frame. Catching them at startup
	-- means future layout drift fails loudly instead of silently.
	local OVERLAP_PAD = -0.5  -- negative pad: only flag genuine penetration, not edge-touching
	local Y_TOL       = 5     -- Y bands only flagged if they're roughly co-extensive
	local audited     = 0
	local overlaps    = {}
	local function modelAabb(m: Model): ({min: Vector3, max: Vector3}?)
		local minV: Vector3? = nil
		local maxV: Vector3? = nil
		for _, d in ipairs(m:GetDescendants()) do
			if not d:IsA("BasePart") then continue end
			if not d.Anchored then continue end
			if not d.CanCollide then continue end
			local cf, sz = d.CFrame, d.Size
			-- Conservative AABB: largest extent in any rotation is the half-size sum
			local hx = math.abs(sz.X) * 0.5 + math.abs(sz.Y) * 0.5 + math.abs(sz.Z) * 0.5
			local hy = hx
			local hz = hx
			local lo = cf.Position - Vector3.new(hx, hy, hz)
			local hi = cf.Position + Vector3.new(hx, hy, hz)
			if not minV then minV, maxV = lo, hi
			else
				minV = Vector3.new(math.min(minV.X, lo.X), math.min(minV.Y, lo.Y), math.min(minV.Z, lo.Z))
				maxV = Vector3.new(math.max(maxV.X, hi.X), math.max(maxV.Y, hi.Y), math.max(maxV.Z, hi.Z))
			end
		end
		if not minV then return nil end
		return { min = minV, max = maxV }
	end

	local boxes: { [string]: any } = {}
	for _, child in ipairs(districtsFolder:GetChildren()) do
		if not child:IsA("Model") then continue end
		local b = modelAabb(child)
		if not b then continue end
		boxes[child.Name] = b
	end
	for nameA, a in boxes do
		for nameB, b in boxes do
			if nameA >= nameB then continue end  -- each pair once
			-- XZ AABB overlap, Y co-extent check
			local xover = math.min(a.max.X, b.max.X) - math.max(a.min.X, b.min.X)
			local zover = math.min(a.max.Z, b.max.Z) - math.max(a.min.Z, b.min.Z)
			local yover = math.min(a.max.Y, b.max.Y) - math.max(a.min.Y, b.min.Y)
			if xover > OVERLAP_PAD and zover > OVERLAP_PAD and yover > Y_TOL then
				audited += 1
				table.insert(overlaps, string.format("%s ↔ %s (overlap XZ=%.1fx%.1f)", nameA, nameB, xover, zover))
			end
		end
	end
	if #overlaps > 0 then
		warn(string.format("[AssetSpawner] %d AABB overlap pair(s) detected:", #overlaps))
		for i = 1, math.min(#overlaps, 20) do
			warn("  • " .. overlaps[i])
		end
		if #overlaps > 20 then
			warn(string.format("  … and %d more (truncated)", #overlaps - 20))
		end
	else
		print("[AssetSpawner] footprint audit: 0 overlaps")
	end
end

return AssetSpawner
