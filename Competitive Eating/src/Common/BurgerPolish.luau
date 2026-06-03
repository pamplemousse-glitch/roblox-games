-- BurgerPolish: post-process pass run on every Burger Boulevard asset Model after
-- AssetSpawner instantiates it. Applies the five PBR MaterialVariants
-- (generated via MCP and parented under MaterialService) by part name, and
-- bumps lamp PointLights + adds SurfaceLights to neon signage so the
-- district reads as a sunset 50s diner strip at a glance.
--
-- Same architecture as DonutPolish / TokyoPolish — see those file headers for
-- the why. This module mirrors their structure 1:1 so future polish modules
-- can be cloned from any of the three.

local BurgerPolish = {}

local HOT_PINK_LAMP  = Color3.fromRGB(255, 100, 200)
local LAMP_RANGE     = 16
local LAMP_BRIGHT    = 5

local SIGN_LIGHT_BRIGHT = 4
local SIGN_LIGHT_RANGE  = 15
local SIGN_LIGHT_ANGLE  = 130

-- ── Material variant resolution ──────────────────────────────────────────────
-- Each entry: { variant = "name", base = Enum.Material.* }
local VARIANTS = {
	chrome       = { variant = "burger_chrome",        base = Enum.Material.Metal        },
	teal_paint   = { variant = "burger_teal_paint",    base = Enum.Material.SmoothPlastic },
	cream_stucco = { variant = "burger_cream_stucco",  base = Enum.Material.Plaster      },
	asphalt      = { variant = "burger_asphalt",       base = Enum.Material.Concrete     },
	neon_signage = { variant = "burger_neon_signage",  base = Enum.Material.Foil         },
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
-- Order matters: signage and asphalt are checked before stucco/teal so that
-- "DinerSign" and "ParkingLotBase" don't get claimed by broader rules. Skip
-- bulbs/flags/records/plates so existing Cadillac + decoration colors stay.
local function classify(part: BasePart): string?
	local lname = string.lower(part.Name)

	-- Skip list — preserves Cadillac chrome accents, jukebox records, license
	-- plates, drive-in flag stripes that already have their own intentional
	-- color and shouldn't be overridden.
	if lname:find("bulb")
	   or lname:find("flag")
	   or lname:find("record")
	   or lname:find("plate") then
		return nil
	end

	-- Neon-signage / marquee letterforms — checked first so "DinerSign" wins
	-- over the broader "diner" rule and "MarqueeArrow" stays signage.
	if lname:find("sign")
	   or lname:find("neon")
	   or lname:find("marquee")
	   or lname:find("arrow")
	   or lname:find("vacancy") then
		return "neon_signage"
	end

	-- Asphalt path / parking lot / drive-in pad / foundations -----------------
	if lname:find("foundation")
	   or lname:find("^path")
	   or lname:find("road")
	   or lname:find("lot")
	   or lname:find("pad")
	   or lname:find("baseplatform") then
		return "asphalt"
	end

	-- Cream stucco motel siding / garage / gas-pump body ----------------------
	if lname:find("stucco")
	   or lname:find("motel")
	   or lname:find("siding")
	   or lname:find("garage")
	   or lname:find("pump") then
		return "cream_stucco"
	end

	-- 50s teal paint — wall facades, awnings, booth/bench upholstery ---------
	if lname:find("wall")
	   or lname:find("facade")
	   or lname:find("^front")
	   or lname:find("awning")
	   or lname:find("booth")
	   or lname:find("bench") then
		return "teal_paint"
	end

	-- Chrome — trim, bumpers, bars, stools, mixers, appliances ----------------
	-- Checked last so the broader "chrome"/"trim" terms don't claim e.g.
	-- BoothTrim (which we want as teal upholstery accent, not chrome). Use
	-- explicit substring matches to keep the rule narrow.
	if lname:find("chrome")
	   or lname:find("trim")
	   or lname:find("bumper")
	   or lname:find("^bar")
	   or lname:find("stool")
	   or lname:find("mixer")
	   or lname:find("appliance") then
		return "chrome"
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
-- Lamp bulbs (Lamppost50s) live as Neon-material cylinders whose Name contains
-- "bulb". Treat them as hot-pink neon glow with non-trivial range.
local function isLampBody(part: BasePart): boolean
	if part.Material ~= Enum.Material.Neon then return false end
	local lname = string.lower(part.Name)
	if not lname:find("bulb") then return false end
	if lname:find("stripe") then return false end
	return true
end

-- Neon diner signage: marquee, arrow, vacancy, generic Sign.
local function isNeonSignBody(part: BasePart): boolean
	if part.Material ~= Enum.Material.Neon then return false end
	local lname = string.lower(part.Name)
	if lname:find("bulb") then return false end
	return lname:find("sign")
	    or lname:find("marquee")
	    or lname:find("arrow")
	    or lname:find("vacancy")
	    or lname:find("neon")
end

local function bumpLampPointLight(part: BasePart)
	for _, c in ipairs(part:GetChildren()) do
		if c:IsA("PointLight") then
			c.Color      = HOT_PINK_LAMP
			c.Brightness = LAMP_BRIGHT
			c.Range      = LAMP_RANGE
			c.Shadows    = true
		end
	end
	-- If the module forgot to add one, add it.
	if not part:FindFirstChildOfClass("PointLight") then
		local p = Instance.new("PointLight")
		p.Color      = HOT_PINK_LAMP
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
function BurgerPolish.apply(model: Model)
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

return BurgerPolish
