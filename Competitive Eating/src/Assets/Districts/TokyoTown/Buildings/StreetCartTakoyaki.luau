-- Street Cart (Takoyaki) — small mobile yatai with cast-iron grill plate
-- (the dimpled takoyaki pan, simulated as a grid of small spheres) and a
-- vermilion awning + glowing yellow accent sign.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION   = Color3.fromRGB(200, 50, 40)
local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local BALL_BROWN  = Color3.fromRGB(190, 130, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("StreetCartTakoyaki", parent)

	-- Cart body (wood box on wheels)
	local body = AB.block(Vector3.new(10, 4, 5), WARM_WOOD,
		AB.offset(originCF, 0, 3, 0), model, "CartBody")

	-- Lower trim
	AB.block(Vector3.new(10, 0.4, 5.1), DARK_WOOD,
		AB.offset(originCF, 0, 1.2, 0), model, "BodyTrim")

	-- Two wheels (front/back)
	for i, z in {-1.6, 1.6} do
		AB.cylinder(2.2, 0.6, IRON_BLACK,
			AB.offset(originCF, -4.8, 1.1, z) * CFrame.Angles(0, math.rad(90), 0),
			model, "WheelL_" .. i)
		AB.cylinder(2.2, 0.6, IRON_BLACK,
			AB.offset(originCF,  4.8, 1.1, z) * CFrame.Angles(0, math.rad(90), 0),
			model, "WheelR_" .. i)
	end

	-- Top counter surface
	AB.block(Vector3.new(10.2, 0.4, 5.2), DARK_WOOD,
		AB.offset(originCF, 0, 5.2, 0), model, "CounterTop")

	-- Cast-iron takoyaki grill plate (recessed black square)
	AB.block(Vector3.new(5.0, 0.3, 3.0), IRON_BLACK,
		AB.offset(originCF, 0, 5.45, 0), model, "GrillPlate")

	-- Dimples on the grill — 3 × 5 grid of small brown spheres (cooking balls)
	for row = 0, 2 do
		for col = 0, 4 do
			local x = (col - 2) * 0.85
			local z = (row - 1) * 0.85
			AB.sphere(0.55, BALL_BROWN,
				AB.offset(originCF, x, 5.65, z),
				model, "Ball_" .. row .. "_" .. col)
		end
	end

	-- 4 awning support posts
	for i, offset in {
		Vector3.new(-4.6, 6.5, -2.2),
		Vector3.new( 4.6, 6.5, -2.2),
		Vector3.new(-4.6, 6.5,  2.2),
		Vector3.new( 4.6, 6.5,  2.2),
	} do
		AB.block(Vector3.new(0.3, 3.0, 0.3), DARK_WOOD,
			AB.offset(originCF, offset.X, offset.Y, offset.Z), model, "Post_" .. i)
	end

	-- Vermilion awning (a sloped slab above the cart)
	AB.block(Vector3.new(11, 0.4, 6), VERMILION,
		AB.offset(originCF, 0, 8.2, 0), model, "Awning")
	-- White stripe trim
	for i, z in {-2.5, 2.5} do
		AB.block(Vector3.new(11, 0.45, 0.4), Color3.fromRGB(245, 240, 230),
			AB.offset(originCF, 0, 8.2, z), model, "AwningTrim_" .. i)
	end

	-- Glowing yellow lantern hanging from the awning's front edge
	local lantern = AB.cylinder(1.6, 2.0, LANTERN_Y,
		AB.offset(originCF, -3.5, 7.0, 2.6), model, "Lantern")
	AB.neon(lantern)
	AB.glow(lantern, lantern.Color, 2.2)

	-- "たこ焼" style sign on the front of the awning
	local sign = AB.block(Vector3.new(4, 1.4, 0.3), VERMILION,
		AB.offset(originCF, 2.5, 8.6, 2.95), model, "Sign")
	AB.glow(sign, Color3.fromRGB(255, 230, 200), 1.5)

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
