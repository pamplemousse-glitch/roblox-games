-- RainbowSprinklePath — a section of walking path made from a cream
-- "icing" stripe with rainbow sprinkles embedded.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CREAM  = Color3.fromRGB(255, 240, 220)
local GOLD   = Color3.fromRGB(212, 168, 82)
local MINT   = Color3.fromRGB(180, 230, 200)
local NEONPK = Color3.fromRGB(255, 110, 170)
local PURPLE = Color3.fromRGB(195, 165, 230)
local BLUE   = Color3.fromRGB(180, 210, 245)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RainbowSprinklePath", parent)

	local len = 18  -- studs
	local width = 6

	-- Base path (icing cream)
	local base = AB.block(Vector3.new(width, 0.4, len), CREAM,
		AB.offset(originCF, 0, 0.2, 0), model, "PathBase")

	-- Pink edging
	AB.block(Vector3.new(0.6, 0.5, len), PINK,
		AB.offset(originCF, -width/2 + 0.3, 0.25, 0), model, "EdgeL")
	AB.block(Vector3.new(0.6, 0.5, len), PINK,
		AB.offset(originCF, width/2 - 0.3, 0.25, 0), model, "EdgeR")

	-- Sprinkles scattered across the surface
	local sprinkleColors = {NEONPK, MINT, GOLD, PURPLE, BLUE, DEEP, PINK}
	math.randomseed(424242)
	for i = 1, 60 do
		local sx = (math.random() - 0.5) * (width - 1)
		local sz = (math.random() - 0.5) * (len - 1)
		local rot = math.random() * 180
		local col = sprinkleColors[((i - 1) % #sprinkleColors) + 1]
		AB.block(Vector3.new(0.25, 0.2, 0.8), col,
			AB.offset(originCF, sx, 0.5, sz, rot), model, "Sprinkle_" .. i)
	end

	-- Couple of cream "swirl" dots for whimsy
	for i = 1, 6 do
		local sz = -len/2 + 1.5 + (i - 1) * (len - 3) / 5
		AB.sphere(0.5, GOLD, AB.offset(originCF, 0, 0.55, sz), model, "Dot_" .. i)
	end

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
