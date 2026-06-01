-- Shinto Arch Entry (Torii) — vermilion two-pillar gate with a curved-style
-- top crossbar (kasagi) and a straight lower bar (nuki). Black caps complete it.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION = Color3.fromRGB(200, 50, 40)
local DARK_WOOD = Color3.fromRGB(60, 40, 30)
local STONE     = Color3.fromRGB(120, 115, 105)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ShintoArchEntry", parent)

	-- Two stone base blocks under each pillar
	for i, x in {-7, 7} do
		AB.block(Vector3.new(3, 1.4, 3), STONE,
			AB.offset(originCF, x, 0.7, 0), model, "Base_" .. i)
	end

	-- Two pillars (cylinders, narrowing slightly with white-painted top)
	for i, x in {-7, 7} do
		AB.cylinder(2.2, 18, VERMILION,
			AB.offset(originCF, x, 10.4, 0), model, "Pillar_" .. i)
	end

	-- Lower crossbar (nuki) — between the pillars, just below the top
	AB.block(Vector3.new(17, 1.4, 1.4), VERMILION,
		AB.offset(originCF, 0, 16, 0), model, "Nuki")

	-- Center label plaque (small vermilion + black square)
	local plaque = AB.block(Vector3.new(2.4, 2.2, 0.6), DARK_WOOD,
		AB.offset(originCF, 0, 17.5, 0.4), model, "Plaque")
	AB.block(Vector3.new(2.0, 1.8, 0.7), VERMILION,
		AB.offset(originCF, 0, 17.5, 0.5), model, "PlaqueFace")

	-- Top crossbar (kasagi) — wider, slightly thicker, with curved feel via
	-- two stacked blocks (the second narrower to suggest taper)
	AB.block(Vector3.new(20, 1.6, 1.8), VERMILION,
		AB.offset(originCF, 0, 19.4, 0), model, "Kasagi")
	AB.block(Vector3.new(18, 0.6, 1.4), VERMILION,
		AB.offset(originCF, 0, 20.3, 0), model, "KasagiTop")

	-- Black end caps on the kasagi (the dark slants traditional toriis have)
	for i, x in {-10, 10} do
		AB.wedge(Vector3.new(1.6, 1.0, 1.0), DARK_WOOD,
			AB.offset(originCF, x, 19.4, 0) * CFrame.Angles(0, math.rad((x < 0) and 90 or -90), 0),
			model, "KasagiCap_" .. i)
	end

	-- Decorative bands around each pillar (a black ring near the top)
	for i, x in {-7, 7} do
		AB.cylinder(2.4, 0.4, DARK_WOOD,
			AB.offset(originCF, x, 17.8, 0), model, "PillarBand_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
