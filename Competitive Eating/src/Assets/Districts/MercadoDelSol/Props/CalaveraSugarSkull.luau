-- Calavera Sugar Skull — Día de Muertos decorative skull on a wooden pedestal.
-- Has flowered eye sockets, dotted forehead, tooth row, marigolds around base.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WOOD_DARK   = Color3.fromRGB(110, 75, 45)
local BONE_WHITE  = Color3.fromRGB(240, 235, 220)
local EYE_BLACK   = Color3.fromRGB(20, 18, 16)
local BOUG_PINK   = Color3.fromRGB(220, 80, 140)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL  = Color3.fromRGB(43, 140, 156)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CalaveraSugarSkull", parent)

	-- Wooden pedestal
	local pedestal = AB.block(Vector3.new(1.5, 0.5, 1.5), WOOD_DARK,
		AB.offset(originCF, 0, 0.25, 0), model, "Pedestal")
	-- Pedestal top trim
	AB.block(Vector3.new(1.7, 0.15, 1.7), Color3.fromRGB(150, 110, 70),
		AB.offset(originCF, 0, 0.55, 0), model, "PedestalTrim")

	-- Cranium
	AB.sphere(2, BONE_WHITE,
		AB.offset(originCF, 0, 1.8, 0), model, "Cranium")

	-- Eye sockets (inset black spheres)
	AB.sphere(0.55, EYE_BLACK, AB.offset(originCF, -0.45, 1.9, 0.85), model, "SocketL")
	AB.sphere(0.55, EYE_BLACK, AB.offset(originCF,  0.45, 1.9, 0.85), model, "SocketR")
	-- Flowers inside eye sockets
	AB.sphere(0.4, BOUG_PINK, AB.offset(originCF, -0.45, 1.9, 0.95), model, "EyeFlowerL")
	AB.sphere(0.4, BOUG_PINK, AB.offset(originCF,  0.45, 1.9, 0.95), model, "EyeFlowerR")

	-- Forehead dotted pattern (4 colorful dots in arc)
	local dotColors = {FIESTA_YEL, PAPEL_GREEN, AGAVE_TEAL, FIESTA_YEL}
	for i, color in dotColors do
		local x = -0.45 + (i - 1) * 0.3
		AB.sphere(0.18, color,
			AB.offset(originCF, x, 2.6, 0.9), model, "Dot_" .. i)
	end

	-- Neon flame accent on forehead crown
	local flame = AB.sphere(0.35, BOUG_PINK,
		AB.offset(originCF, 0, 2.95, 0.7), model, "FlameAccent")
	AB.neon(flame)
	AB.glow(flame, BOUG_PINK, 2)

	-- Nose hole (wedge)
	AB.wedge(Vector3.new(0.25, 0.4, 0.3), EYE_BLACK,
		AB.offset(originCF, 0, 1.5, 0.95), model, "NoseHole")

	-- Tooth row (6 small white teeth)
	for i = 1, 6 do
		local x = -0.5 + (i - 1) * 0.2
		AB.block(Vector3.new(0.15, 0.2, 0.15), BONE_WHITE,
			AB.offset(originCF, x, 1.05, 0.95), model, "Tooth_" .. i)
	end

	-- Marigold flowers around the base
	for i = 1, 4 do
		local a = (i - 1) * (math.pi / 2) + math.pi / 4
		local x = math.cos(a) * 1.1
		local z = math.sin(a) * 1.1
		AB.sphere(0.4, FIESTA_YEL,
			AB.offset(originCF, x, 0.7, z), model, "Marigold_" .. i)
	end

	AB.pivot(model, pedestal)
	AB.weldAll(model)
	return model
end
