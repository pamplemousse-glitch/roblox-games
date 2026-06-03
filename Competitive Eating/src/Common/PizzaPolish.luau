-- PizzaPolish: post-process pass run on every Pizza Plaza asset Model after
-- AssetSpawner instantiates it. Applies the five PBR MaterialVariants
-- (generated via MCP and parented under MaterialService) by part name, and
-- bumps lamp PointLights + adds SurfaceLights to basil-neon signage so the
-- district reads as warm Tuscan-sunset glow at a glance.
--
-- Same architecture as DonutPolish / TokyoPolish. This module mirrors their
-- structure 1:1 — only the variant names, lamp accent, and classifier rules
-- change. See DonutPolish.luau for the architectural why.

local PizzaPolish = {}

local AMBER_LAMP        = Color3.fromRGB(255, 200, 130)   -- Tuscan sunset amber
local LAMP_RANGE        = 18
local LAMP_BRIGHT       = 5

local SIGN_LIGHT_BRIGHT = 4
local SIGN_LIGHT_RANGE  = 15
local SIGN_LIGHT_ANGLE  = 130

-- ── Material variant resolution ──────────────────────────────────────────────
-- Each entry: { variant = "name", base = Enum.Material.* }
local VARIANTS = {
	stucco   = { variant = "pizza_pasta_cream",      base = Enum.Material.Plaster       },
	brick    = { variant = "pizza_brick_red",        base = Enum.Material.Brick         },
	basil    = { variant = "pizza_basil_stucco",     base = Enum.Material.Plaster       },
	path     = { variant = "pizza_terracotta_path",  base = Enum.Material.Cobblestone   },
	signage  = { variant = "pizza_neon_signage",     base = Enum.Material.Foil          },
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
-- Order matters: signage is checked first so a "PizzaSign" doesn't get
-- claimed by "pizza" looking like a wall token elsewhere. NPC accessory
-- names (Apron, Mustache, Eye, Smile, Bunting, Flag, Flower, Bulb …) are
-- excluded by the early skip set — those parts colour themselves.
local function classify(part: BasePart): string?
	local lname = string.lower(part.Name)

	-- Skip NPC accessory / decoration leftover names that must NOT be retinted.
	if lname:find("bulb")       -- lamp body — already Neon, leave it
	or lname:find("bunting")
	or lname:find("flag")
	or lname:find("flower")
	or lname:find("eye")
	or lname:find("smile") then
		return nil
	end

	-- Signage / neon (foil-trimmed letterforms + marquee panels) -------------
	if lname:find("sign")
	or lname:find("neon")
	or lname:find("cafesign")
	or lname:find("pizzasign")
	or lname:find("marquee") then
		return "signage"
	end

	-- Brick red — chimneys, pizza ovens, towers, brick roofs -----------------
	if lname:find("brickwall")
	or lname:find("chimney")
	or lname:find("pizzaoven")
	or lname:find("^oven")
	or lname:find("tower")
	or lname:find("roof") then
		return "brick"
	end

	-- Terracotta cobble / plaza / foundation / paths / bocce -----------------
	if lname:find("foundation")
	or lname:find("path")
	or lname:find("cobble")
	or lname:find("plaza")
	or lname:find("pavers")
	or lname:find("bocce")
	or lname:find("baseplatform") then
		return "path"
	end

	-- Basil-green stucco — trim, shutters, doors, vines, planters ------------
	if lname:find("stucco")
	or lname:find("trim")
	or lname:find("shutter")
	or lname:find("^door")
	or lname:find("vine")
	or lname:find("planter") then
		return "basil"
	end

	-- Pasta-cream — walls, facades, fronts, awnings, umbrellas, tablecloths --
	if lname:find("wall")
	or lname:find("facade")
	or lname:find("^front")
	or lname:find("awning")
	or lname:find("umbrella")
	or lname:find("tablecloth") then
		return "stucco"
	end

	return nil
end

-- ── Mesh-with-texture guard ──────────────────────────────────────────────────
-- Cube 3D / Meshy hero meshes have a TextureID or MeshContent set. Never override.
local function hasBakedMeshTexture(part: BasePart): boolean
	if not part:IsA("MeshPart") then return false end
	local mp = part :: MeshPart
	if mp.TextureID and mp.TextureID ~= "" then return true end
	local ok, content = pcall(function() return mp.TextureContent end)
	if ok and content and content.Uri and content.Uri ~= "" then return true end
	return false
end

-- ── Lighting ─────────────────────────────────────────────────────────────────
-- Lamp bulbs (Lamppost, RistoranteSignWall LampRow et al.) live as Neon-
-- material parts whose Name contains "bulb". Treat them like Donut/Tokyo
-- lantern bodies: warm Tuscan amber glow with a non-trivial range.
local function isLampBody(part: BasePart): boolean
	if part.Material ~= Enum.Material.Neon then return false end
	local lname = string.lower(part.Name)
	if not lname:find("bulb") then return false end
	if lname:find("stripe") then return false end
	return true
end

-- Neon café / pizza signage: emissive panels behind the letterforms.
local function isNeonSignBody(part: BasePart): boolean
	if part.Material ~= Enum.Material.Neon then return false end
	local lname = string.lower(part.Name)
	if lname:find("bulb") then return false end
	return lname:find("cafesign")
	    or lname:find("pizzasign")
	    or lname:find("neonsign")
	    or lname:find("marquee")
	    or lname:find("^sign")
	    or lname:find("signfront")
	    or lname:find("signface")
	    or lname:find("neon")
end

local function bumpLampPointLight(part: BasePart)
	for _, c in ipairs(part:GetChildren()) do
		if c:IsA("PointLight") then
			c.Color      = AMBER_LAMP
			c.Brightness = LAMP_BRIGHT
			c.Range      = LAMP_RANGE
			c.Shadows    = true
		end
	end
	if not part:FindFirstChildOfClass("PointLight") then
		local p = Instance.new("PointLight")
		p.Color      = AMBER_LAMP
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
function PizzaPolish.apply(model: Model)
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

return PizzaPolish
