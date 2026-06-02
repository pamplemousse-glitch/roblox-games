-- TokyoPolish: post-process pass run on every Tokyo Town asset Model after
-- AssetSpawner instantiates it. Applies the five PBR MaterialVariants
-- (generated via MCP and parented under MaterialService) by part name, and
-- bumps lantern PointLights + adds SurfaceLights to neon signage so the
-- district reads as warm/evening at a glance.
--
-- Why run from a single pass instead of editing every Tokyo module:
-- - 30+ Tokyo modules already exist; touching each one is churn-heavy
-- - AssetSpawner clears + respawns Districts on every server start, so the
--   polish runs every time and persists across Play sessions
-- - Cube 3D hero meshes (DaikonRamen, SushiDaiko, IzakayaLantern, TakoyakiCart,
--   DaikonRamenSignboard) are skipped automatically: any MeshPart with a
--   TextureID is left untouched (rule from Session A/B handoff).

local TokyoPolish = {}

local WARM_LANTERN     = Color3.fromRGB(255, 165, 70)
local LANTERN_RANGE    = 18
local LANTERN_BRIGHT   = 6

local SIGN_LIGHT_BRIGHT = 4
local SIGN_LIGHT_RANGE  = 15
local SIGN_LIGHT_ANGLE  = 130

-- ── Material variant resolution ──────────────────────────────────────────────
-- Each entry: { variant = "name", base = Enum.Material.* }
local VARIANTS = {
	darkWood = { variant = "tokyo_weathered_dark_wood", base = Enum.Material.WoodPlanks },
	slate    = { variant = "tokyo_slate_roof_tile",     base = Enum.Material.Slate },
	washi    = { variant = "tokyo_washi_paper",         base = Enum.Material.Plaster },
	signage  = { variant = "tokyo_neon_signage",        base = Enum.Material.Foil },
	stone    = { variant = "tokyo_worn_stone_path",     base = Enum.Material.Cobblestone },
}

local function applyVariant(part: BasePart, key: string)
	local v = VARIANTS[key]
	if not v then return end
	part.Material = v.base
	part.MaterialVariant = v.variant
end

-- ── Classification ───────────────────────────────────────────────────────────
-- Decide which variant a Part should get based on its Name. Returns the
-- variant key, or nil to leave the Part alone.
local function classify(part: BasePart): string?
	local name = part.Name
	local lname = string.lower(name)

	-- Stone / path / foundation -----------------------------------------------
	if lname:find("foundation")
	   or lname:find("^step_")
	   or lname:find("stone")
	   or lname:find("^base_")
	   or lname:find("manhole")
	   or lname:find("koipond")
	   or lname:find("^path") then
		return "stone"
	end

	-- Roof (slate kawara) -----------------------------------------------------
	-- Keep ridges + glow strips as-is so they read as accent.
	if (lname:find("roof") and not lname:find("ridge") and not lname:find("glow") and not lname:find("crown"))
	   or lname:find("rooftile") then
		return "slate"
	end

	-- Washi paper / shoji -----------------------------------------------------
	if lname:find("shoji")
	   or lname:find("paper")
	   or lname:find("washi")
	   or lname:find("menuface")
	   or lname:find("^window")
	   or (lname:find("^pod_") and not lname:find("podtop") and not lname:find("podbot")) -- capsule window glass
	   or (lname:find("plaque") and not lname:find("border")) then
		return "washi"
	end

	-- Neon-signage backing ----------------------------------------------------
	-- Border/frames behind neon parts get the signage variant (chromed foil).
	if lname:find("plaqueborder")
	   or lname:find("signborder")
	   or lname:find("kanjiborder")
	   or lname:find("neonframe") then
		return "signage"
	end

	-- Dark wood (walls / facades / counters / beams / doors / pod frames) -----
	if lname:find("wall")
	   or lname:find("front")
	   or lname:find("facade")
	   or lname:find("counter")
	   or lname:find("backwall")
	   or lname:find("tower")
	   or lname:find("lobby")
	   or lname:find("divider")
	   or lname:find("eave")
	   or lname:find("beam")
	   or lname:find("^door")
	   or lname:find("header")
	   or lname:find("mullion")
	   or lname:find("crossbeam")
	   or lname:find("post_")
	   or lname:find("cedar")
	   or lname:find("cap")
	   or lname:find("rope")
	   or lname:find("rod")
	   or lname:find("podtop") or lname:find("podbot")
	   or lname:find("sidepod") then
		return "darkWood"
	end

	return nil
end

-- ── Mesh-with-texture guard ──────────────────────────────────────────────────
-- Cube 3D hero meshes have a TextureID or MeshContent set. Never override.
local function hasBakedMeshTexture(part: BasePart): boolean
	if not part:IsA("MeshPart") then return false end
	local mp = part :: MeshPart
	if mp.TextureID and mp.TextureID ~= "" then return true end
	-- Also guard against the new MeshContent API (modern Studio)
	local ok, content = pcall(function() return mp.TextureContent end)
	if ok and content and content.Uri and content.Uri ~= "" then return true end
	return false
end

-- ── Lighting ─────────────────────────────────────────────────────────────────
-- Lantern PointLights live as children of cylinder parts whose Name contains
-- "Lantern" and whose Material has been set to Neon by the original module.
local function isLanternBody(part: BasePart): boolean
	if part.Material ~= Enum.Material.Neon then return false end
	local lname = string.lower(part.Name)
	if not lname:find("lantern") then return false end
	-- Caps / ropes / beams are not the lantern body
	if lname:find("cap") or lname:find("rope") or lname:find("beam") or lname:find("stripe") then
		return false
	end
	return true
end

local function isNeonSignBody(part: BasePart): boolean
	if part.Material ~= Enum.Material.Neon then return false end
	local lname = string.lower(part.Name)
	-- Already covered as lantern -> skip
	if lname:find("lantern") then return false end
	return lname:find("kanji")
	    or lname:find("katakana")
	    or lname:find("plaque")
	    or lname:find("^sign")
	    or lname:find("neon")
	    or lname:find("kanjiplate")
	    or lname:find("pod_") -- capsule hotel windows
	    or lname:find("beacon")
	    or lname:find("roofglow")
end

local function bumpLanternPointLight(part: BasePart)
	for _, c in ipairs(part:GetChildren()) do
		if c:IsA("PointLight") then
			c.Color      = WARM_LANTERN
			c.Brightness = LANTERN_BRIGHT
			c.Range      = LANTERN_RANGE
			c.Shadows    = true
		end
	end
	-- If module forgot to add one, add it.
	if not part:FindFirstChildOfClass("PointLight") then
		local p = Instance.new("PointLight")
		p.Color      = WARM_LANTERN
		p.Brightness = LANTERN_BRIGHT
		p.Range      = LANTERN_RANGE
		p.Shadows    = true
		p.Parent     = part
	end
end

local function addSignSurfaceLight(part: BasePart)
	-- Don't double-add if already present
	if part:FindFirstChildOfClass("SurfaceLight") then return end
	local sl = Instance.new("SurfaceLight")
	sl.Color      = part.Color
	sl.Brightness = SIGN_LIGHT_BRIGHT
	sl.Range      = SIGN_LIGHT_RANGE
	sl.Angle      = SIGN_LIGHT_ANGLE
	sl.Face       = Enum.NormalId.Front
	sl.Shadows    = false
	sl.Parent     = part
end

-- ── Public API ───────────────────────────────────────────────────────────────
function TokyoPolish.apply(model: Model)
	if not model or not model:IsA("Model") then return end

	for _, d in ipairs(model:GetDescendants()) do
		if not d:IsA("BasePart") then continue end

		if hasBakedMeshTexture(d) then continue end

		-- Lighting pass (independent of material; can run on neon parts)
		if isLanternBody(d) then
			bumpLanternPointLight(d)
		elseif isNeonSignBody(d) then
			addSignSurfaceLight(d)
		end

		-- Material pass — skip Neon (let it stay emissive)
		if d.Material == Enum.Material.Neon then continue end

		local key = classify(d)
		if key then applyVariant(d, key) end
	end
end

return TokyoPolish
