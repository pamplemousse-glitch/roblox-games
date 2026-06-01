-- Bakery Arch Entry — gilded baroque arch in cream and gold, district gateway.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CREAM = Color3.fromRGB(255, 240, 220)
local GOLD  = Color3.fromRGB(212, 168, 82)
local DEEP  = Color3.fromRGB(160, 120, 50)
local PINK  = Color3.fromRGB(255, 200, 214)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BakeryArchEntry", parent)

	-- Base plinths (two)
	for i, x in {-12, 12} do
		AB.block(Vector3.new(6, 3, 6), GOLD,
			AB.offset(originCF, x, 1.5, 0), model, "Plinth_" .. i)
		AB.block(Vector3.new(5, 0.5, 5), DEEP,
			AB.offset(originCF, x, 3.25, 0), model, "PlinthTrim_" .. i)
	end

	-- Columns
	for i, x in {-12, 12} do
		AB.cylinder(3.6, 14, CREAM,
			AB.offset(originCF, x, 10.5, 0), model, "Column_" .. i)
		-- Spiral gold bands around each column
		for j = 1, 5 do
			AB.cylinder(3.9, 0.4, GOLD,
				AB.offset(originCF, x, 5 + j * 2.2, 0), model, "Band_" .. i .. "_" .. j)
		end
		-- Capital
		AB.block(Vector3.new(5, 1.6, 5), GOLD,
			AB.offset(originCF, x, 18, 0), model, "Capital_" .. i)
	end

	-- Horizontal entablature
	AB.block(Vector3.new(30, 2, 4), CREAM,
		AB.offset(originCF, 0, 19.5, 0), model, "Entablature")
	AB.block(Vector3.new(30, 0.4, 4.4), GOLD,
		AB.offset(originCF, 0, 20.5, 0), model, "EntablatureTrim")

	-- Arched span (3 stepped tiers approximating a curve)
	local arch = {
		{ w = 22, h = 1.4, y = 21.5 },
		{ w = 18, h = 1.2, y = 22.7 },
		{ w = 14, h = 1.0, y = 23.7 },
		{ w = 10, h = 0.8, y = 24.6 },
	}
	for i, a in arch do
		AB.block(Vector3.new(a.w, a.h, 4), CREAM,
			AB.offset(originCF, 0, a.y, 0), model, "Arch_" .. i)
	end

	-- Decorative gold donut keystone at the top center
	AB.circleArrange(AB.offset(originCF, 0, 26, 0), 1.8, 10, model, function(i, cf, _)
		return AB.sphere(1.6, GOLD, cf, model, "KeystoneRing_" .. i)
	end)
	AB.cylinder(1.2, 0.6, PINK,
		AB.offset(originCF, 0, 26, 0), model, "KeystoneCenter")

	-- "DONUT DYNASTY" cartouche
	local sign = AB.block(Vector3.new(16, 2.2, 0.6), DEEP,
		AB.offset(originCF, 0, 21, 2.2), model, "Cartouche")
	AB.glow(sign, GOLD, 2)

	AB.pivot(model, model:FindFirstChild("Plinth_1"))
	AB.weldAll(model)
	return model
end
