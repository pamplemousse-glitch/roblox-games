-- Drying Pasta Rack — wooden frame with strands of fresh pasta hanging
-- to dry (spaghetti, fettuccine, linguine).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WD       = Color3.fromRGB(110, 75, 45)
local DK_WD    = Color3.fromRGB(80, 50, 30)
local PASTA_Y  = Color3.fromRGB(230, 200, 130)
local PASTA_C  = Color3.fromRGB(240, 220, 180)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DryingPastaRack", parent)

	-- Two vertical posts
	AB.block(Vector3.new(0.3, 5, 0.3), WD, AB.offset(originCF, -3, 2.5, 0), model, "PostL")
	AB.block(Vector3.new(0.3, 5, 0.3), WD, AB.offset(originCF,  3, 2.5, 0), model, "PostR")
	-- Top crossbar
	AB.cylinder(0.25, 6, DK_WD,
		AB.offset(originCF, 0, 4.5, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "CrossBar")
	-- 3 horizontal rods
	for i, y in {3.5, 2.5, 1.5} do
		AB.cylinder(0.2, 6, WD,
			AB.offset(originCF, 0, y, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Rod_" .. i)
	end

	-- Spaghetti strands hanging from top rod
	for i = 1, 16 do
		local x = -2.7 + (i - 0.5) / 16 * 5.4
		local len = 2.4 + math.random() * 0.4
		AB.cylinder(0.06, len, PASTA_Y,
			AB.offset(originCF, x, 4.5 - len / 2, 0.2), model, "Spag_" .. i)
	end
	-- Fettuccine on middle rod (flat strips)
	for i = 1, 8 do
		local x = -2.5 + (i - 0.5) / 8 * 5
		AB.block(Vector3.new(0.25, 2, 0.05), PASTA_Y,
			AB.offset(originCF, x, 2.5 - 1, -0.3), model, "Fett_" .. i)
	end
	-- Linguine on bottom rod (slightly thicker, cream)
	for i = 1, 10 do
		local x = -2.5 + (i - 0.5) / 10 * 5
		AB.cylinder(0.08, 1.6, PASTA_C,
			AB.offset(originCF, x, 1.5 - 0.8, 0.2), model, "Lin_" .. i)
	end

	-- Base feet
	AB.block(Vector3.new(0.8, 0.4, 0.8), DK_WD, AB.offset(originCF, -3, 0.2, 0), model, "FeetL")
	AB.block(Vector3.new(0.8, 0.4, 0.8), DK_WD, AB.offset(originCF,  3, 0.2, 0), model, "FeetR")

	-- "PASTA FRESCA" tag at top
	AB.block(Vector3.new(2, 0.5, 0.15), Color3.fromRGB(245, 230, 200),
		AB.offset(originCF, 0, 5.2, 0), model, "Tag")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
