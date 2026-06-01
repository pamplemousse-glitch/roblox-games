-- CandyCaneLampRow — a row of 6 oversized candy-cane streetlamps spaced
-- along the sidewalk. Each post is white with deep-pink spiral stripes
-- and a glowing peppermint bulb at the curl.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK    = Color3.fromRGB(255, 200, 214)
local DEEP    = Color3.fromRGB(232, 130, 165)
local CREAM   = Color3.fromRGB(255, 240, 220)
local BROWN   = Color3.fromRGB(92,  57,  36)
local GOLD    = Color3.fromRGB(212, 168, 82)
local MINT    = Color3.fromRGB(180, 230, 200)
local NEONPK  = Color3.fromRGB(255, 110, 170)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CandyCaneLampRow", parent)

	local count = 6
	local spacing = 12

	for i = 1, count do
		local x = -((count - 1) * spacing) / 2 + (i - 1) * spacing

		-- Brown base
		AB.block(Vector3.new(2, 1, 2), BROWN,
			AB.offset(originCF, x, 0.5, 0), model, "Base_" .. i)
		AB.block(Vector3.new(2.4, 0.4, 2.4), GOLD,
			AB.offset(originCF, x, 1.1, 0), model, "BaseTrim_" .. i)

		-- Main post (cream)
		AB.cylinder(1.2, 16, CREAM,
			AB.offset(originCF, x, 9, 0), model, "Post_" .. i)
		-- Spiral stripes (deep pink) — short cylinders rotated up the post
		for j = 1, 8 do
			local sy = 2.4 + (j - 1) * 1.8
			AB.cylinder(1.26, 0.6, DEEP,
				AB.offset(originCF, x, sy, 0, j * 35), model, "Stripe_" .. i .. "_" .. j)
		end

		-- Cane curl at top — 3 spheres arching forward
		AB.sphere(1.4, CREAM, AB.offset(originCF, x, 17.5, 0), model, "Curl1_" .. i)
		AB.sphere(1.4, CREAM, AB.offset(originCF, x, 18.5, 1.2), model, "Curl2_" .. i)
		AB.sphere(1.4, CREAM, AB.offset(originCF, x, 18.5, 2.6), model, "Curl3_" .. i)
		AB.sphere(1.4, DEEP, AB.offset(originCF, x, 17.7, 1.8), model, "CurlStripe_" .. i)

		-- Hanging peppermint bulb
		AB.block(Vector3.new(0.2, 1.2, 0.2), CREAM,
			AB.offset(originCF, x, 17.4, 3.0), model, "Wire_" .. i)
		local bulb = AB.sphere(1.6, CREAM,
			AB.offset(originCF, x, 16.0, 3.0), model, "Bulb_" .. i)
		AB.neon(bulb)
		AB.glow(bulb, NEONPK, 3)
		-- Bulb stripes
		AB.cylinder(1.7, 0.25, DEEP,
			AB.offset(originCF, x, 16, 3.0, 90), model, "BulbStripe1_" .. i)
		AB.cylinder(1.7, 0.25, DEEP,
			AB.offset(originCF, x, 16.5, 3.0, 90), model, "BulbStripe2_" .. i)

		-- Mint ribbon bow on post
		AB.sphere(1, MINT, AB.offset(originCF, x - 0.6, 6, 0.6), model, "BowL_" .. i)
		AB.sphere(1, MINT, AB.offset(originCF, x + 0.6, 6, 0.6), model, "BowR_" .. i)
		AB.block(Vector3.new(0.4, 0.4, 0.4), MINT,
			AB.offset(originCF, x, 6, 0.6), model, "BowKnot_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
