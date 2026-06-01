-- GumdropPebble — small gumdrop-shaped decorative stone in jewel pink,
-- with a sugar-coated speckled top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DEEP   = Color3.fromRGB(232, 130, 165)
local PINK   = Color3.fromRGB(255, 200, 214)
local CREAM  = Color3.fromRGB(255, 240, 220)
local MINT   = Color3.fromRGB(180, 230, 200)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GumdropPebble", parent)

	-- Dome body
	local body = AB.sphere(3, DEEP, AB.offset(originCF, 0, 1.2, 0), model, "Body")
	body.Reflectance = 0.15
	-- Flat bottom (slight overlap to fake hemisphere)
	AB.cylinder(3, 0.4, DEEP, AB.offset(originCF, 0, 0.2, 0), model, "Base")

	-- Sugar speckles (tiny cream spheres)
	for i = 1, 12 do
		local angle = (i / 12) * math.pi * 2
		local r = 1.3
		AB.sphere(0.2, CREAM,
			AB.offset(originCF, math.cos(angle) * r, 2.2 + math.sin(i) * 0.3, math.sin(angle) * r),
			model, "Speckle_" .. i)
	end

	-- Mint dab on top
	AB.sphere(0.5, MINT, AB.offset(originCF, 0, 2.7, 0), model, "MintDab")

	-- Soft pink halo (small lighter sphere underneath)
	AB.sphere(2.8, PINK, AB.offset(originCF, 0, 1, 0), model, "InnerGlow").Transparency = 0.85

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
