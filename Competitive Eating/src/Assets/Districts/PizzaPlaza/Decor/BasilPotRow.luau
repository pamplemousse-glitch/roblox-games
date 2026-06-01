-- Basil Pot Row — 5 terracotta pots of fresh basil lined up.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local POT    = Color3.fromRGB(180, 100, 70)
local DK_POT = Color3.fromRGB(140, 75, 50)
local SOIL   = Color3.fromRGB(70, 45, 25)
local BASIL  = Color3.fromRGB(80, 140, 60)
local LT_BSL = Color3.fromRGB(120, 180, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BasilPotRow", parent)

	-- 5 pots in a row
	for i = 1, 5 do
		local x = -4 + (i - 1) * 2
		-- Pot
		AB.cylinder(1.4, 1.8, POT, AB.offset(originCF, x, 1, 0), model, "Pot_" .. i)
		AB.cylinder(1.6, 0.2, DK_POT, AB.offset(originCF, x, 1.9, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "PotLip_" .. i)
		-- Soil
		AB.cylinder(1.3, 0.15, SOIL, AB.offset(originCF, x, 1.95, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Soil_" .. i)
		-- Basil clump (mound)
		AB.sphere(1, BASIL, AB.offset(originCF, x, 2.7, 0), model, "BasilMound_" .. i)
		-- Highlight leaves
		for k = 1, 4 do
			local angle = k / 4 * 2 * math.pi
			AB.sphere(0.5, LT_BSL,
				AB.offset(originCF, x + math.cos(angle) * 0.7, 2.5 + math.sin(angle) * 0.3, math.sin(angle) * 0.7),
				model, "Leaf_" .. i .. "_" .. k)
		end
		-- A few darker basil leaves
		AB.sphere(0.45, Color3.fromRGB(60, 100, 50), AB.offset(originCF, x, 2.9, 0), model, "TopLeaf_" .. i)
		AB.sphere(0.45, Color3.fromRGB(60, 100, 50), AB.offset(originCF, x + 0.4, 2.6, 0.3), model, "TopLeaf2_" .. i)
	end

	-- Wooden tray underneath all pots
	AB.block(Vector3.new(10, 0.2, 2.5), Color3.fromRGB(110, 75, 45),
		AB.offset(originCF, 0, 0.1, 0), model, "Tray")
	-- Tray border
	AB.block(Vector3.new(10.2, 0.25, 0.15), Color3.fromRGB(80, 50, 30),
		AB.offset(originCF, 0, 0.2, 1.2), model, "TrayBorderF")
	AB.block(Vector3.new(10.2, 0.25, 0.15), Color3.fromRGB(80, 50, 30),
		AB.offset(originCF, 0, 0.2, -1.2), model, "TrayBorderB")

	-- "BASILICO" tag at end
	AB.block(Vector3.new(1.8, 0.6, 0.1), Color3.fromRGB(245, 230, 200),
		AB.offset(originCF, 5.5, 2, 0), model, "Tag")
	AB.block(Vector3.new(0.1, 1.5, 0.1), Color3.fromRGB(80, 50, 30),
		AB.offset(originCF, 5.5, 1.2, 0), model, "TagStake")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
