-- Olive Oil Jugs — 3 ceramic olive oil jugs of different sizes, classic
-- amphora-shape, with handwritten labels.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CER     = Color3.fromRGB(240, 220, 180)
local DK_CER  = Color3.fromRGB(190, 165, 120)
local DK_GRN  = Color3.fromRGB(40, 70, 45)
local LABEL   = Color3.fromRGB(245, 230, 200)
local TXT_GRN = Color3.fromRGB(80, 140, 60)
local CORK    = Color3.fromRGB(195, 165, 120)

local function jug(model, originCF, x, scale, name)
	-- Body (ellipsoid effect via 2 spheres)
	AB.sphere(2 * scale, CER, AB.offset(originCF, x, 1.6 * scale, 0), model, name .. "_Body")
	-- Top neck
	AB.cylinder(0.6 * scale, 1.2 * scale, CER,
		AB.offset(originCF, x, 2.9 * scale, 0), model, name .. "_Neck")
	-- Cork
	AB.cylinder(0.4 * scale, 0.4 * scale, CORK,
		AB.offset(originCF, x, 3.7 * scale, 0), model, name .. "_Cork")
	-- Handle
	AB.cylinder(0.2 * scale, 1 * scale, CER,
		AB.offset(originCF, x + 1.2 * scale, 2 * scale, 0), model, name .. "_Handle")
	AB.sphere(0.25 * scale, CER, AB.offset(originCF, x + 1.2 * scale, 1.5 * scale, 0), model, name .. "_HandleBot")
	AB.sphere(0.25 * scale, CER, AB.offset(originCF, x + 1.2 * scale, 2.5 * scale, 0), model, name .. "_HandleTop")
	-- Base ring
	AB.cylinder(1.4 * scale, 0.2 * scale, DK_CER,
		AB.offset(originCF, x, 0.2 * scale, 0) * CFrame.Angles(0, 0, math.rad(90)), model, name .. "_BaseRing")
	-- Label
	AB.block(Vector3.new(1.2 * scale, 0.8 * scale, 0.05), LABEL,
		AB.offset(originCF, x, 1.8 * scale, 1.8 * scale), model, name .. "_Label")
	AB.block(Vector3.new(0.8 * scale, 0.2 * scale, 0.04), TXT_GRN,
		AB.offset(originCF, x, 1.8 * scale, 1.83 * scale), model, name .. "_LabelTxt")
	-- Olive branch leaf
	AB.sphere(0.3 * scale, DK_GRN, AB.offset(originCF, x - 1.2 * scale, 1.5 * scale, 1.4 * scale), model, name .. "_OliveLeaf")
end

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("OliveOilJugs", parent)

	jug(model, originCF, -3.5, 1.2, "JugL")
	jug(model, originCF,  0,   1,   "JugM")
	jug(model, originCF,  3,   0.8, "JugR")

	-- Olives scattered on ground
	for i = 1, 6 do
		AB.sphere(0.2, DK_GRN,
			AB.offset(originCF, (math.random() - 0.5) * 7, 0.15, (math.random() - 0.5) * 1.5), model, "Olive_" .. i)
	end

	-- "OLIO" plaque on the front
	AB.block(Vector3.new(3, 0.6, 0.1), Color3.fromRGB(110, 30, 40), AB.offset(originCF, 0, 0.4, 1.5), model, "OlioPlaque")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
