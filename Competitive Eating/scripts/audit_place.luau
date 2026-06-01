-- Pre-flight place file audit. Run from Studio command bar:
--   loadstring(game.HttpService:GetAsync("file://" .. workspace:GetAttribute("ProjectRoot") .. "/scripts/audit_place.luau"))()
-- Or just copy-paste the body into the command bar.
--
-- Reports any instance in ReplicatedStorage / ServerScriptService / StarterPlayer /
-- StarterGui / Lighting whose name isn't in the expected allowlist below.
-- Foreign content (leaked from templates, accidental imports, etc.) shows up as warnings.

local EXPECTED = {
	ReplicatedStorage = {
		Remotes         = true,  -- created at runtime by Main.server
		Common          = true,  -- src/Common
		Packages        = true,  -- Wally
		DefaultCamera   = true,
		FoodProps       = true,  -- legit asset folder for food models
		AnimationGraphEditor = true,  -- Studio plugin artifact, ignore
	},
	ServerScriptService = {
		Services = true,  -- src/Server/Services
		Main     = true,  -- src/Server/Main.server.luau
	},
	StarterPlayer = {
		StarterPlayerScripts    = true,
		StarterCharacterScripts = true,
		StarterCharacter        = true,
	},
	StarterPlayerScripts = {
		Controllers = true,
		Main        = true,
	},
	StarterGui = {},  -- everything created at runtime
	Lighting = {
		Sky = true, Atmosphere = true, Bloom = true,
		SunRays = true, DepthOfField = true, Clouds = true,
	},
}

local foreign = {}
local function check(serviceName)
	local exp = EXPECTED[serviceName] or {}
	local service = game:GetService(serviceName) or game:FindFirstChild(serviceName)
	if not service then return end
	for _, c in service:GetChildren() do
		if not exp[c.Name] then
			table.insert(foreign, {
				path = c:GetFullName(),
				class = c.ClassName,
				childCount = #c:GetChildren(),
			})
		end
	end
end

check("ReplicatedStorage")
check("ServerScriptService")
check("StarterPlayer")
-- StarterPlayerScripts is nested
local sps = game.StarterPlayer:FindFirstChild("StarterPlayerScripts")
if sps then
	for _, c in sps:GetChildren() do
		if not EXPECTED.StarterPlayerScripts[c.Name] then
			table.insert(foreign, {path = c:GetFullName(), class = c.ClassName, childCount = #c:GetChildren()})
		end
	end
end
check("StarterGui")
check("Lighting")

if #foreign == 0 then
	print("[audit_place] CLEAN — no foreign content detected")
	return
end

warn(string.format("[audit_place] %d foreign instance(s) found:", #foreign))
for _, f in foreign do
	warn(string.format("  %s (%s, %d children)", f.path, f.class, f.childCount))
end
warn("[audit_place] Inspect each one. If genuinely foreign, :Destroy() it and Cmd+S to persist.")
