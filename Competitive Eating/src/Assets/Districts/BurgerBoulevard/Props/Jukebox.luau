-- Jukebox — classic Wurlitzer-style jukebox. Arched top, glowing color tubes,
-- record selector window, speaker grille.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Jukebox", parent)

	local WOOD   = Color3.fromRGB(140, 80, 40)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local NEON_R = Color3.fromRGB(255, 50, 50)
	local NEON_Y = Color3.fromRGB(255, 220, 80)
	local NEON_G = Color3.fromRGB(80, 220, 100)
	local NEON_B = Color3.fromRGB(80, 160, 255)
	local CREAM  = Color3.fromRGB(255, 245, 232)
	local DARK   = Color3.fromRGB(40, 30, 25)
	local GLASS  = Color3.fromRGB(180, 220, 240)

	-- Base / body cabinet
	local body = AB.block(Vector3.new(4, 5, 3), WOOD, AB.offset(originCF, 0, 2.5, 0), model, "Body")
	body.Material = Enum.Material.WoodPlanks
	-- Chrome side trim
	AB.block(Vector3.new(0.3, 5, 3.1), CHROME, AB.offset(originCF, -2.05, 2.5, 0), model, "TrimL")
	AB.block(Vector3.new(0.3, 5, 3.1), CHROME, AB.offset(originCF, 2.05, 2.5, 0), model, "TrimR")
	-- Arched top (cylinder lying on side)
	local arch = AB.cylinder(4, 4.2, WOOD, AB.offset(originCF, 0, 5, 0) * CFrame.Angles(0, math.rad(90), 0), model, "Arch")
	arch.Material = Enum.Material.WoodPlanks
	-- Chrome ring around the arch
	AB.cylinder(4.2, 4.3, CHROME, AB.offset(originCF, 0, 5, 0) * CFrame.Angles(0, math.rad(90), 0), model, "ArchTrim")
	-- Glass record-selector window (center-top)
	local glass = AB.block(Vector3.new(3.2, 2.5, 0.3), GLASS, AB.offset(originCF, 0, 5.5, 1.55), model, "RecordWindow")
	glass.Material = Enum.Material.Glass; glass.Transparency = 0.3
	-- Record visible behind glass
	AB.cylinder(2, 0.2, DARK, AB.offset(originCF, 0, 5.5, 1.4) * CFrame.Angles(0, math.rad(90), 0), model, "Record")
	AB.cylinder(0.6, 0.3, NEON_R, AB.offset(originCF, 0, 5.5, 1.45) * CFrame.Angles(0, math.rad(90), 0), model, "RecordLabel")
	-- Speaker grille (front lower)
	AB.block(Vector3.new(3.5, 1.5, 0.3), DARK, AB.offset(originCF, 0, 1.5, 1.55), model, "SpeakerGrille")
	-- Speaker mesh lines (cosmetic)
	for i = 0, 6 do
		AB.block(Vector3.new(3.5, 0.1, 0.35), CHROME, AB.offset(originCF, 0, 0.85 + i * 0.2, 1.6), model, "GrilleLine_" .. i)
	end
	-- Selector keys (rows of buttons)
	for i = 0, 3 do
		for j = 0, 5 do
			AB.block(Vector3.new(0.3, 0.3, 0.2), CREAM, AB.offset(originCF, -1.5 + j * 0.55, 3.4 + i * 0.4, 1.55), model, "Key_" .. i .. "_" .. j)
		end
	end

	-- COLORFUL NEON TUBES (signature jukebox glow) — 4 vertical tubes flanking the body
	local function neonTube(x: number, color: Color3, name: string)
		local t = AB.block(Vector3.new(0.4, 4, 0.4), color, AB.offset(originCF, x, 3, 1.5), model, name)
		AB.neon(t); AB.glow(t, color, 1.8)
		return t
	end
	neonTube(-2.4, NEON_R, "TubeFL")
	neonTube( 2.4, NEON_Y, "TubeFR")
	neonTube(-2.4, NEON_G, "TubeBL"):PivotTo(AB.offset(originCF, -2.4, 3, -1.5))
	neonTube( 2.4, NEON_B, "TubeBR"):PivotTo(AB.offset(originCF, 2.4, 3, -1.5))

	-- Top decorative chrome dome
	AB.sphere(0.8, CHROME, AB.offset(originCF, 0, 7.1, 0), model, "TopDome")

	-- Coin slot (small cream block)
	AB.block(Vector3.new(0.6, 1, 0.2), CHROME, AB.offset(originCF, 1.2, 2.5, 1.6), model, "CoinSlot")

	-- "SELECT" plaque
	local plaque = AB.block(Vector3.new(2, 0.5, 0.2), CREAM, AB.offset(originCF, 0, 2.6, 1.6), model, "SelectPlaque")
	AB.billboard(plaque, "SELECT", Vector2.new(80, 30), 0)

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
