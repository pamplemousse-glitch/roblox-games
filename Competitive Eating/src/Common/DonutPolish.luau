-- DonutPolish: post-process pass run on every Donut Dynasty asset Model after
-- AssetSpawner instantiates it. Applies the five PBR MaterialVariants
-- (generated via MCP and parented under MaterialService) by part name, and
-- bumps lamp PointLights + adds SurfaceLights to neon candy signage so the
-- district reads as warm/pastel-glow at a glance.
--
-- Same architecture as TokyoPolish — see that file's header for the why.
-- This module mirrors its structure 1:1 so future polish modules
-- (e.g. PizzaPolish, BbqPolish) can be cloned from either.

local DonutPolish = {}

local CANDY_LAMP        = Color3.fromRGB(255, 180, 210)
local LAMP_RANGE        = 16
local LAMP_BRIGHT       = 5

local SIGN_LIGHT_BRIGHT = 4
local SIGN_LIGHT_RANGE  = 15
local SIGN_LIGHT_ANGLE  = 130

-- ── Material variant resolution ──────────────────────────────────────────────
-- Each entry: { variant = "name", base = Enum.Material.* }
local VARIANTS = {
	stucco   = { variant = "donut_pink_stucco",     base = Enum.Material.Plaster       },
	frosting = { variant = "donut_glazed_frosting", base = Enum.Material.SmoothPlastic },
	brick    = { variant = "donut_pastel_brick",    base = Enum.Material.Brick         },
	path     = { variant = "donut_sugar_path",      base = Enum.Material.Sand          },
	signage  = { variant = "donut_candy_signage",   base = Enum.Material.Foil          },
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
-- Order matters: glazed_frosting and candy_signage are checked first so that
-- "RoofIcing" doesn't get claimed by the "roof" rule and "CafeSign" doesn't
-- get claimed by the "front"/"wall" rules. Per-rule guards stay narrow so NPC
-- accessory names (Apron, BowL, Mustache, Tiara, Ribbon, Belt …) keep
-- returning nil — they must be left alone, the rigs colour themselves.
local function classify(part: BasePart): string?
	local lname = string.lower(part.Name)

	-- Glaze / icing / frosting ------------------------------------------------
	if lname:find("glaze")
	   or lname:find("icing")
	   or lname:find("frosting")
	   or lname:find("^roofdonut")
	   or lname:find("^donutring")
	   or lname:find("^donutpole")
	   or lname:find("^donutglow")
	   or lname:find("^dispdonut") then
		return "frosting"
	end

	-- Candy signage (foil/chrome trim around neon) ----------------------------
	if lname:find("sign")
	   or lname:find("sparkle")
	   or lname:find("cartouche") then
		return "signage"
	end

	-- Sugar path / plaza / foundation -----------------------------------------
	if lname:find("foundation")
	   or lname:find("pathbase")
	   or lname:find("plaza")
	   or lname:find("bridgeplank")
	   or lname:find("cobble")
	   or lname:find("baseplatform") then
		return "path"
	end

	-- Pastel brick — roofs, mansards, towers, domes, keeps --------------------
	-- Roof variants get filtered above (RoofIcing → frosting), so any remaining
	-- "roof" name is a brick-tiled roof.
	if lname:find("roof")
	   or lname:find("mansard")
	   or lname:find("dome")
	   or lname:find("^keep")
	   or lname:find("tower")
	   or lname:find("spire")
	   or lname:find("silobody") then
		return "brick"
	end

	-- Pink stucco — walls, facades, fronts, pilasters, parapets, wainscot ----
	if lname:find("wall")
	   or lname:find("facade")
	   or lname:find("^front")
	   or lname:find("pilaster")
	   or lname:find("parapet")
	   or lname:find("wainscot")
	   or lname == "chimney"
	   or lname == "house"
	   or lname == "balconyfloor" then
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
	-- Modern MeshContent API
	local ok, content = pcall(function() return mp.TextureContent end)
	if ok and content and content.Uri and content.Uri ~= "" then return true end
	return false
end

-- ── Lighting ─────────────────────────────────────────────────────────────────
-- Lamp bulbs (CandyCaneLampRow et al.) live as Neon-material cylinders whose
-- Name contains "bulb". Treat them like Tokyo's lantern bodies: warm pastel
-- glow with a non-trivial range.
local function isLampBody(part: BasePart): boolean
	if part.Material ~= Enum.Material.Neon then return false end
	local lname = string.lower(part.Name)
	-- "bulb" matches LampBulb_, SconceBulb_, SpotBulb_, Bulb_
	if not lname:find("bulb") then return false end
	-- BulbStripe_ are decorative wraps around the bulb body, not the bulb itself
	if lname:find("stripe") then return false end
	return true
end

-- Neon candy signage: pink/cream emissive panels behind glazed letterforms.
local function isNeonSignBody(part: BasePart): boolean
	if part.Material ~= Enum.Material.Neon then return false end
	local lname = string.lower(part.Name)
	-- Already covered as lamp -> skip
	if lname:find("bulb") then return false end
	return lname:find("neonsign")
	    or lname:find("cafesign")
	    or lname:find("sugarsign")
	    or lname:find("^sign")
	    or lname:find("signfront")
	    or lname:find("signface")
	    or lname:find("donutglow")
	    or lname:find("neon")
end

local function bumpLampPointLight(part: BasePart)
	for _, c in ipairs(part:GetChildren()) do
		if c:IsA("PointLight") then
			c.Color      = CANDY_LAMP
			c.Brightness = LAMP_BRIGHT
			c.Range      = LAMP_RANGE
			c.Shadows    = true
		end
	end
	-- If the module forgot to add one, add it.
	if not part:FindFirstChildOfClass("PointLight") then
		local p = Instance.new("PointLight")
		p.Color      = CANDY_LAMP
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
function DonutPolish.apply(model: Model)
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

return DonutPolish
