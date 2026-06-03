-- MercadoPolish: post-process pass run on every Mercado del Sol asset Model
-- after AssetSpawner instantiates it. Applies the five PBR MaterialVariants
-- (generated via MCP and parented under MaterialService) by part name, and
-- bumps lamp PointLights + adds SurfaceLights to bougainvillea-pink neon
-- signage so the district reads as warm marigold-glow at a glance.
--
-- Same architecture as DonutPolish / TokyoPolish — see their headers for the
-- why. Mirrors DonutPolish 1:1 with district-specific palette + name routing.

local MercadoPolish = {}

local LAMP_FIESTA       = Color3.fromRGB(255, 184, 52)
local LAMP_RANGE        = 16
local LAMP_BRIGHT       = 5

local SIGN_LIGHT_BRIGHT = 4
local SIGN_LIGHT_RANGE  = 15
local SIGN_LIGHT_ANGLE  = 130

-- ── Material variant resolution ──────────────────────────────────────────────
-- Each entry: { variant = "name", base = Enum.Material.* }
local VARIANTS = {
	terracotta    = { variant = "mercado_terracotta",     base = Enum.Material.Slate         },
	adobe_stucco  = { variant = "mercado_adobe_stucco",   base = Enum.Material.Plaster       },
	painted_tile  = { variant = "mercado_painted_tile",   base = Enum.Material.SmoothPlastic },
	cobble_path   = { variant = "mercado_cobble_path",    base = Enum.Material.Cobblestone   },
	papel_signage = { variant = "mercado_papel_signage",  base = Enum.Material.Fabric        },
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
--
-- Order matters: narrow signage / painted-tile rules first so "RoofTile" gets
-- claimed by terracotta before "tile" hits painted_tile, and "BellTower" goes
-- to adobe_stucco (tower stucco) before falling through. Per-rule guards stay
-- narrow so NPC accessory names (Apron, Mustache, Bun, Sombrero, Pinata, basket,
-- skull, marigold, flower …) keep returning nil — they must be left alone, the
-- rigs / decor color themselves.
local function classify(part: BasePart): string?
	local lname = string.lower(part.Name)

	-- Skip NPC / decor pieces that own their colors. Marigold and pinata pieces
	-- are bright by design, sombreros / baskets / skulls / flowers are props.
	if lname:find("bulb")
	   or lname:find("flower")
	   or lname:find("marigold")
	   or lname:find("pinata")
	   or lname:find("sombrero")
	   or lname:find("basket")
	   or lname:find("skull") then
		return nil
	end

	-- Signage first — most specific, catches papel + neon trim around buildings.
	if lname:find("sign")
	   or lname:find("neon")
	   or lname:find("marquee")
	   or lname:find("signfront")
	   or lname:find("^papel")
	   or lname:find("banner") then
		return "papel_signage"
	end

	-- Terracotta roof tiles + chimneys. Checked before painted_tile so RoofTile
	-- doesn't get hijacked by the broader "tile" rule below.
	if lname:find("roof")
	   or lname:find("terracotta")
	   or lname:find("claytile")
	   or lname == "chimney" then
		return "terracotta"
	end

	-- Cobble plaza / foundation / courtyard path. Narrow names first.
	if lname:find("foundation")
	   or lname:find("^path")
	   or lname:find("plaza")
	   or lname:find("courtyard")
	   or lname:find("cobble")
	   or lname:find("pavers")
	   or lname:find("baseplatform") then
		return "cobble_path"
	end

	-- Adobe stucco — walls, facades, towers, bell tower stucco bodies.
	if lname:find("wall")
	   or lname:find("facade")
	   or lname:find("^front")
	   or lname:find("adobe")
	   or lname:find("hacienda")
	   or lname:find("^bell")
	   or lname:find("tower") then
		return "adobe_stucco"
	end

	-- Painted tile — murals, mosaics, panels, shutters, doors, frames. Broad
	-- last so RoofTile / cobble names already took precedence.
	if lname:find("tile")
	   or lname:find("mural")
	   or lname:find("mosaic")
	   or lname:find("panel")
	   or lname:find("shutter")
	   or lname:find("door")
	   or lname:find("frame") then
		return "painted_tile"
	end

	return nil
end

-- ── Mesh-with-texture guard ──────────────────────────────────────────────────
-- Cube 3D / Meshy hero meshes have a TextureID or MeshContent set. Never override.
local function hasBakedMeshTexture(part: BasePart): boolean
	if not part:IsA("MeshPart") then return false end
	local mp = part :: MeshPart
	if mp.TextureID and mp.TextureID ~= "" then return true end
	-- Modern MeshContent API
	local ok, content = pcall(function() return mp.TextureContent end)
	if ok and content and content.Uri and content.Uri ~= "" then return true end
	return false
end

-- ── Lighting ─────────────────────────────────────────────────────────────────
-- Lamp bulbs live as Neon-material cylinders whose Name contains "bulb". Treat
-- them like Donut's candy bulbs: fiesta-yellow glow with a non-trivial range.
local function isLampBody(part: BasePart): boolean
	if part.Material ~= Enum.Material.Neon then return false end
	local lname = string.lower(part.Name)
	if not lname:find("bulb") then return false end
	if lname:find("stripe") then return false end
	return true
end

-- Bougainvillea-pink neon signage: emissive panels behind painted letterforms.
local function isNeonSignBody(part: BasePart): boolean
	if part.Material ~= Enum.Material.Neon then return false end
	local lname = string.lower(part.Name)
	if lname:find("bulb") then return false end
	return lname:find("neonsign")
	    or lname:find("signfront")
	    or lname:find("signface")
	    or lname:find("^sign")
	    or lname:find("signletter")
	    or lname:find("neon")
end

local function bumpLampPointLight(part: BasePart)
	for _, c in ipairs(part:GetChildren()) do
		if c:IsA("PointLight") then
			c.Color      = LAMP_FIESTA
			c.Brightness = LAMP_BRIGHT
			c.Range      = LAMP_RANGE
			c.Shadows    = true
		end
	end
	if not part:FindFirstChildOfClass("PointLight") then
		local p = Instance.new("PointLight")
		p.Color      = LAMP_FIESTA
		p.Brightness = LAMP_BRIGHT
		p.Range      = LAMP_RANGE
		p.Shadows    = true
		p.Parent     = part
	end
end

local function addSignSurfaceLight(part: BasePart)
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
function MercadoPolish.apply(model: Model)
	if not model or not model:IsA("Model") then return end

	for _, d in ipairs(model:GetDescendants()) do
		if not d:IsA("BasePart") then continue end

		if hasBakedMeshTexture(d) then continue end

		-- Lighting pass (independent of material; can run on neon parts)
		if isLampBody(d) then
			bumpLampPointLight(d)
		elseif isNeonSignBody(d) then
			addSignSurfaceLight(d)
		end

		-- Material pass — skip Neon (let it stay emissive)
		if d.Material == Enum.Material.Neon then continue end

		local key = classify(d)
		if key then applyVariant(d, key) end
	end
end

return MercadoPolish
