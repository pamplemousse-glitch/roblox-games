-- DonutDisplayRack — gold three-tier display rack holding donuts of
-- different glazes. Used for storefront window displays.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CREAM  = Color3.fromRGB(255, 240, 220)
local BROWN  = Color3.fromRGB(92,  57,  36)
local GOLD   = Color3.fromRGB(212, 168, 82)
local MINT   = Color3.fromRGB(180, 230, 200)
local DOUGH  = Color3.fromRGB(220, 170, 110)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DonutDisplayRack", parent)

	-- Base
	local base = AB.cylinder(4, 0.4, GOLD,
		AB.offset(originCF, 0, 0.2, 0), model, "Base")
	-- Central post
	AB.cylinder(0.5, 8, GOLD, AB.offset(originCF, 0, 4, 0), model, "Post")

	local glazes = {PINK, MINT, CREAM, DEEP, GOLD, BROWN}
	local tierData = {{r = 3.6, y = 2.4}, {r = 2.8, y = 5}, {r = 2.0, y = 7.4}}

	for tIdx, t in tierData do
		-- Tier plate
		AB.cylinder(t.r * 2, 0.3, GOLD,
			AB.offset(originCF, 0, t.y, 0), model, "Plate_" .. tIdx)
		-- Plate rim
		AB.cylinder(t.r * 2 + 0.2, 0.4, CREAM,
			AB.offset(originCF, 0, t.y - 0.1, 0), model, "PlateRim_" .. tIdx)

		-- Donuts arranged around tier
		local count = 6 - (tIdx - 1) * 2
		AB.circleArrange(AB.offset(originCF, 0, t.y + 0.5, 0), t.r - 0.6, count, model, function(i, cf, _)
			AB.cylinder(1.0, 0.5, DOUGH, cf, model, "Donut_" .. tIdx .. "_" .. i)
			-- Glaze on top
			local col = glazes[((tIdx + i) % #glazes) + 1]
			AB.cylinder(0.9, 0.2, col,
				cf * CFrame.new(0, 0.4, 0), model, "Glaze_" .. tIdx .. "_" .. i)
			-- Sprinkle dot
			return AB.sphere(0.15, BROWN, cf * CFrame.new(0, 0.6, 0), model, "Donut_" .. tIdx .. "_" .. i .. "_dot")
		end)
	end

	-- Top finial
	AB.sphere(0.7, DEEP, AB.offset(originCF, 0, 8.6, 0), model, "Finial")

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
