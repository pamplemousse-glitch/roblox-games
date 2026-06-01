-- CakeStandTable — small round cafe table with a single decorative
-- cake stand under a glass dome, two flanking pastries, and chairs
-- suggested by a pair of cream cushions.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CREAM  = Color3.fromRGB(255, 240, 220)
local BROWN  = Color3.fromRGB(92,  57,  36)
local GOLD   = Color3.fromRGB(212, 168, 82)
local MINT   = Color3.fromRGB(180, 230, 200)
local STRAW  = Color3.fromRGB(245, 80, 120)
local GLASS  = Color3.fromRGB(210, 235, 250)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CakeStandTable", parent)

	-- Table top
	local top = AB.cylinder(5.5, 0.4, CREAM,
		AB.offset(originCF, 0, 3.2, 0), model, "TableTop")
	AB.cylinder(5.5, 0.2, GOLD,
		AB.offset(originCF, 0, 3.45, 0), model, "TableEdge")

	-- Center pedestal leg + base
	AB.cylinder(0.8, 3, GOLD, AB.offset(originCF, 0, 1.6, 0), model, "Leg")
	AB.cylinder(2.8, 0.5, GOLD, AB.offset(originCF, 0, 0.25, 0), model, "LegBase")

	-- Cake stand
	AB.cylinder(0.6, 1.6, GOLD, AB.offset(originCF, 0, 4.3, 0), model, "StandStem")
	AB.cylinder(2.2, 0.3, GOLD, AB.offset(originCF, 0, 5.2, 0), model, "StandPlate")

	-- Cake on stand
	AB.cylinder(1.8, 1.2, PINK,  AB.offset(originCF, 0, 6, 0), model, "CakeBody")
	AB.cylinder(1.6, 0.4, CREAM, AB.offset(originCF, 0, 6.8, 0), model, "CakeIcing")
	AB.sphere(0.5, STRAW, AB.offset(originCF, 0, 7.2, 0), model, "CakeBerry")

	-- Glass dome over cake
	local dome = AB.sphere(3, GLASS, AB.offset(originCF, 0, 6.2, 0), model, "GlassDome")
	dome.Transparency = 0.6
	dome.Material = Enum.Material.Glass
	AB.sphere(0.4, GOLD, AB.offset(originCF, 0, 7.8, 0), model, "DomeKnob")

	-- Side pastries on table
	AB.cylinder(0.9, 0.4, CREAM,
		AB.offset(originCF, -2, 3.6, 1.5), model, "PastryL")
	AB.sphere(0.5, MINT, AB.offset(originCF, -2, 3.9, 1.5), model, "PastryLTop")
	AB.cylinder(0.9, 0.4, CREAM,
		AB.offset(originCF, 2, 3.6, -1.5), model, "PastryR")
	AB.sphere(0.5, DEEP, AB.offset(originCF, 2, 3.9, -1.5), model, "PastryRTop")

	-- Two cream cushion stools (round)
	for i, x in {-5.5, 5.5} do
		AB.cylinder(2.4, 0.4, GOLD, AB.offset(originCF, x, 2, 0), model, "StoolPlate_" .. i)
		AB.cylinder(2.6, 0.8, CREAM, AB.offset(originCF, x, 2.6, 0), model, "StoolCushion_" .. i)
		AB.cylinder(0.6, 2, BROWN, AB.offset(originCF, x, 1, 0), model, "StoolLeg_" .. i)
	end

	AB.pivot(model, top)
	AB.weldAll(model)
	return model
end
