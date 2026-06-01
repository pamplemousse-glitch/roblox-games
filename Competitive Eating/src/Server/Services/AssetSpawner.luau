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

	local districtsFolder = workspace:FindFirstChild("Districts") or Instance.new("Folder")
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

			local spawnOk, err = pcall(function()
				builder(districtsFolder, cf)
			end)

			if spawnOk then
				spawned += 1
			else
				warn("[AssetSpawner] spawn failed for " .. entry.module .. ": " .. tostring(err))
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
