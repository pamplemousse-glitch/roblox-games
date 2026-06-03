-- BbqPolish: post-process pass run on every BBQ Holler asset Model after
-- AssetSpawner instantiates it. Applies the five PBR MaterialVariants
-- (generated via MCP and parented under MaterialService) by part name, and
-- bumps lamp PointLights + adds SurfaceLights to ember signage so the
-- district reads as a warm smoky golden-hour holler at a glance.
--
-- Same architecture as DonutPolish / TokyoPolish — see those files for the
-- why. Variant strings are referenced by name only; the MaterialVariants
-- themselves are generated in a separate MCP pass under MaterialService.

local BbqPolish = {}

local EMBER_LAMP        = Color3.fromRGB(255, 130, 60)
local LAMP_RANGE        = 18
local LAMP_BRIGHT       = 5

local SIGN_LIGHT_BRIGHT = 4
local SIGN_LIGHT_RANGE  = 15
local SIGN_LIGHT_ANGLE  = 130

-- ── Material variant resolution ──────────────────────────────────────────────
local VARIANTS = {
	smoked_wood       = { variant = "bbq_smoked_wood",       base = Enum.Material.Wood          },
	barn_red          = { variant = "bbq_barn_red",          base = Enum.Material.WoodPlanks    },
	corrugated_metal  = { variant = "bbq_corrugated_metal",  base = Enum.Material.CorrodedMetal },
	dirt_path         = { variant = "bbq_dirt_path",         base = Enum.Material.Ground        },
	ember_signage     = { variant = "bbq_ember_signage",     base = Enum.Material.Foil          },
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
-- Order matters: narrow ember-signage / corrugated-metal rules run before the
-- broader smoked-wood / barn-red rules so e.g. "SignFront" doesn't get
-- claimed by the "front" rule and "SmokerChimney" doesn't get claimed by
-- "chimney" alone. NPC accessory names (Apron, Hat, Bandana, …) keep
-- returning nil so the rigs colour themselves.
local function classify(part: BasePart): string?
	local lname = string.lower(part.Name)

	-- NPC + decorative skip list ---------------------------------------------
	-- Lamp bulbs stay Neon (handled by the lighting pass below). Hay is
	-- already its own cream/straw color. Apron/hat are NPC accessories.
	if lname:find("bulb")
	   or lname:find("hay")
	   or lname:find("apron")
	   or lname:find("hat") then
		return nil
	end

	-- Ember signage (foil/chrome trim around neon) ---------------------------
	if lname:find("sign")
	   or lname:find("neon")
	   or lname:find("marquee")
	   or lname:find("signfront") then
		return "ember_signage"
	end

	-- Dirt path / foundation / gravel ----------------------------------------
	if lname:find("foundation")
	   or lname:find("path")
	   or lname:find("ground")
	   or lname:find("dirt")
	   or lname:find("cobble")
	   or lname:find("baseplatform")
	   or lname:find("gravel") then
		return "dirt_path"
	end

	-- Corrugated metal — roofs, sheets, smokers, chimneys, tanks, silos -----
	if lname:find("roof")
	   or lname:find("metal")
	   or lname:find("sheet")
	   or lname:find("pump")
	   or lname:find("chimney")
	   or lname:find("silo")
	   or lname:find("smoker")
	   or lname:find("tank") then
		return "corrugated_metal"
	end

	-- Barn red — walls, facades, fronts, barns, sheds, body wood -------------
	if lname:find("wall")
	   or lname:find("facade")
	   or lname:find("^front")
	   or lname:find("barn")
	   or lname:find("shed")
	   or lname:find("bodywood") then
		return "barn_red"
	end

	-- Smoked wood — planks, beams, posts, columns, cabins, porches, doors --
	if lname:find("plank")
	   or lname:find("beam")
	   or lname:find("post")
	   or lname:find("column")
	   or lname:find("cabin")
	   or lname:find("porch")
	   or lname:find("door")
	   or lname:find("shutter")
	   or lname:find("frame") then
		return "smoked_wood"
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
local function isLampBody(part: BasePart): boolean
	if part.Material ~= Enum.Material.Neon then return false end
	local lname = string.lower(part.Name)
	if not lname:find("bulb") then return false end
	if lname:find("stripe") then return false end
	return true
end

local function isNeonSignBody(part: BasePart): boolean
	if part.Material ~= Enum.Material.Neon then return false end
	local lname = string.lower(part.Name)
	if lname:find("bulb") then return false end
	return lname:find("neonsign")
	    or lname:find("emberglow")
	    or lname:find("bbqsign")
	    or lname:find("^sign")
	    or lname:find("signfront")
	    or lname:find("signface")
	    or lname:find("marquee")
	    or lname:find("neon")
end

local function bumpLampPointLight(part: BasePart)
	for _, c in ipairs(part:GetChildren()) do
		if c:IsA("PointLight") then
			c.Color      = EMBER_LAMP
			c.Brightness = LAMP_BRIGHT
			c.Range      = LAMP_RANGE
			c.Shadows    = true
		end
	end
	if not part:FindFirstChildOfClass("PointLight") then
		local p = Instance.new("PointLight")
		p.Color      = EMBER_LAMP
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
function BbqPolish.apply(model: Model)
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

return BbqPolish
