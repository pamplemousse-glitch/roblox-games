-- Ceramic Pot — large hand-painted terracotta pot with a succulent growing out
-- the top. Belly + rim + base + painted accent ring around the equator.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA  = Color3.fromRGB(196, 95, 44)
local TERRA_DARK  = Color3.fromRGB(150, 70, 35)
local PAPEL_GREEN = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL  = Color3.fromRGB(43, 140, 156)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local SUCC_GREEN  = Color3.fromRGB(80, 140, 70)
local SOIL_BROWN  = Color3.fromRGB(70, 50, 30)

local ACCENT_COLORS = {PAPEL_GREEN, AGAVE_TEAL, FIESTA_YEL, PAPEL_GREEN, AGAVE_TEAL, FIESTA_YEL}

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CeramicPot", parent)

	-- Base
	local base = AB.cylinder(3.5, 0.4, TERRA_DARK,
		AB.offset(originCF, 0, 0.2, 0), model, "PotBase")

	-- Belly (main body)
	AB.cylinder(4, 3, TERRACOTTA,
		AB.offset(originCF, 0, 1.9, 0), model, "PotBelly")

	-- Painted accent ring around the equator
	for i, color in ACCENT_COLORS do
		local angle = (i - 1) * (2 * math.pi / #ACCENT_COLORS)
		local x = math.cos(angle) * 2.05
		local z = math.sin(angle) * 2.05
		AB.block(Vector3.new(0.5, 0.5, 0.3), color,
			AB.offset(originCF, x, 1.9, z) * CFrame.Angles(0, -angle, 0),
			model, "Accent_" .. i)
	end

	-- Rim (lip) at top
	AB.cylinder(3, 0.5, TERRA_DARK,
		AB.offset(originCF, 0, 3.65, 0), model, "PotRim")

	-- Soil layer just below the rim's inside
	AB.cylinder(2.6, 0.2, SOIL_BROWN,
		AB.offset(originCF, 0, 3.85, 0), model, "Soil")

	-- Succulent — 6 wedge leaves radiating outward like an aloe
	for i = 1, 6 do
		local angle = (i - 1) * (2 * math.pi / 6)
		local x = math.cos(angle) * 0.6
		local z = math.sin(angle) * 0.6
		AB.wedge(Vector3.new(0.5, 1.4, 0.6), SUCC_GREEN,
			AB.offset(originCF, x, 4.5, z) * CFrame.Angles(math.rad(-20), -angle, math.rad(15)),
			model, "Leaf_" .. i)
	end
	-- Central upright leaf
	AB.wedge(Vector3.new(0.4, 1.2, 0.5), SUCC_GREEN,
		AB.offset(originCF, 0, 4.7, 0), model, "LeafCenter")

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
