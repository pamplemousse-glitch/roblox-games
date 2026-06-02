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
local polishModule       = Common:FindFirstChild("TokyoPolish")
local donutPolishModule  = Common:FindFirstChild("DonutPolish")

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
				-- Tokyo polish: PBR materials + lantern/sign lighting on every
				-- Tokyo Town asset after it spawns. AssetSpawner clears + respawns
				-- Districts each server start, so the pass runs every session.
				if polishModule and entry.module:sub(1, 28) == "Assets.Districts.TokyoTown." then
					if typeof(spawnResult) == "Instance" and spawnResult:IsA("Model") then
						local polishOk, polishErr = pcall(function()
							require(polishModule).apply(spawnResult)
						end)
						if not polishOk then
							warn("[AssetSpawner] TokyoPolish failed for " .. entry.module .. ": " .. tostring(polishErr))
						end
					end
				end
				-- Donut polish: same pattern, gated on the Donut Dynasty path prefix.
				if donutPolishModule and entry.module:sub(1, 30) == "Assets.Districts.DonutDynasty." then
					if typeof(spawnResult) == "Instance" and spawnResult:IsA("Model") then
						local polishOk, polishErr = pcall(function()
							require(donutPolishModule).apply(spawnResult)
						end)
						if not polishOk then
							warn("[AssetSpawner] DonutPolish failed for " .. entry.module .. ": " .. tostring(polishErr))
						end
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
end

return AssetSpawner
