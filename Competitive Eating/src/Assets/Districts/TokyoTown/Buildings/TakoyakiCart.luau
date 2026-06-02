-- Takoyaki Cart — elaborate yatai (street food cart) with peaked red canvas
-- canopy, oversized griddle plate, paper-lantern pair, and a hanging menu sign.
-- Footprint ≈ 13w × 12h × 9d.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION  = Color3.fromRGB(200, 50, 40)
local DEEP_RED   = Color3.fromRGB(150, 30, 30)
local WARM_WOOD  = Color3.fromRGB(150, 100, 60)
local DARK_WOOD  = Color3.fromRGB(70, 45, 30)
local IRON_BLACK = Color3.fromRGB(40, 35, 35)
local LANTERN_Y  = Color3.fromRGB(255, 180, 70)
local BALL_BROWN = Color3.fromRGB(190, 130, 70)
local CREAM      = Color3.fromRGB(240, 232, 215)
local STEAM_GRAY = Color3.fromRGB(220, 220, 220)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("TakoyakiCart", parent)

	-- Cart base
	local body = AB.block(Vector3.new(12, 4.5, 7), WARM_WOOD,
		AB.offset(originCF, 0, 3.25, 0), model, "CartBody")
	AB.block(Vector3.new(12.1, 0.5, 7.1), DARK_WOOD,
		AB.offset(originCF, 0, 1.25, 0), model, "BodyTrim")
	-- Front panel (kanji-ready, vermilion)
	AB.block(Vector3.new(12, 2, 0.3), VERMILION,
		AB.offset(originCF, 0, 3.0, 3.6), model, "FrontPanel")
	AB.block(Vector3.new(12.2, 0.3, 0.4), DARK_WOOD,
		AB.offset(originCF, 0, 4.05, 3.65), model, "FrontPanelTop")
	AB.block(Vector3.new(12.2, 0.3, 0.4), DARK_WOOD,
		AB.offset(originCF, 0, 1.95, 3.65), model, "FrontPanelBot")

	-- Four cart wheels
	for i, pos in {
		Vector3.new(-5,  1.0, -2.3),
		Vector3.new( 5,  1.0, -2.3),
		Vector3.new(-5,  1.0,  2.3),
		Vector3.new( 5,  1.0,  2.3),
	} do
		AB.cylinder(2.0, 0.7, IRON_BLACK,
			AB.offset(originCF, pos.X, pos.Y, pos.Z) * CFrame.Angles(0, math.rad(90), 0),
			model, "Wheel_" .. i)
		AB.cylinder(0.5, 0.8, DARK_WOOD,
			AB.offset(originCF, pos.X, pos.Y, pos.Z) * CFrame.Angles(0, math.rad(90), 0),
			model, "WheelHub_" .. i)
	end

	-- Push-handle (rear)
	AB.block(Vector3.new(0.3, 0.3, 4), DARK_WOOD,
		AB.offset(originCF, -5.8, 4.0, -5.0), model, "HandleL")
	AB.block(Vector3.new(0.3, 0.3, 4), DARK_WOOD,
		AB.offset(originCF,  5.8, 4.0, -5.0), model, "HandleR")
	AB.block(Vector3.new(12, 0.3, 0.3), DARK_WOOD,
		AB.offset(originCF, 0, 4.0, -7.0), model, "HandleCross")

	-- Counter top + iron griddle plate
	AB.block(Vector3.new(12, 0.4, 7), DARK_WOOD,
		AB.offset(originCF, 0, 5.7, 0), model, "CounterTop")
	AB.block(Vector3.new(7, 0.4, 4.5), IRON_BLACK,
		AB.offset(originCF, 0, 5.95, 0), model, "GrillPlate")

	-- Griddle dimples — 4×6 grid of browning balls
	for row = 0, 3 do
		for col = 0, 5 do
			local x = (col - 2.5) * 1.0
			local z = (row - 1.5) * 1.0
			AB.sphere(0.65, BALL_BROWN,
				AB.offset(originCF, x, 6.2, z),
				model, "Ball_" .. row .. "_" .. col)
		end
	end
	-- Steam wisp (translucent ball)
	local steam = AB.sphere(2.0, STEAM_GRAY,
		AB.offset(originCF, 0, 7.5, 0), model, "Steam")
	steam.Transparency = 0.65
	steam.CanCollide = false

	-- Four canopy posts
	for i, pos in {
		Vector3.new(-5.8, 8.5, -3.0),
		Vector3.new( 5.8, 8.5, -3.0),
		Vector3.new(-5.8, 8.5,  3.0),
		Vector3.new( 5.8, 8.5,  3.0),
	} do
		AB.block(Vector3.new(0.4, 5.0, 0.4), DARK_WOOD,
			AB.offset(originCF, pos.X, pos.Y, pos.Z), model, "Post_" .. i)
	end

	-- Peaked canvas roof — two sloped wedges meeting at a ridge
	AB.wedge(Vector3.new(13, 1.5, 4.0), VERMILION,
		AB.offset(originCF, 0, 11.0, -1.8) * CFrame.Angles(0, math.rad(180), 0),
		model, "RoofBack")
	AB.wedge(Vector3.new(13, 1.5, 4.0), VERMILION,
		AB.offset(originCF, 0, 11.0,  1.8), model, "RoofFront")
	-- Ridge cap
	AB.block(Vector3.new(13.4, 0.4, 0.7), DARK_WOOD,
		AB.offset(originCF, 0, 12.4, 0), model, "RoofRidge")
	-- White scallop trim on front edge
	for i = 1, 5 do
		local x = (i - 3) * 2.4
		AB.sphere(0.9, CREAM, AB.offset(originCF, x, 10.4, 3.4), model, "Scallop_" .. i)
	end

	-- Two paper lanterns hanging from the front edge
	for i, x in {-3.8, 3.8} do
		local lantern = AB.cylinder(1.5, 2.0, LANTERN_Y,
			AB.offset(originCF, x, 9.0, 3.2), model, "Lantern_" .. i)
		AB.neon(lantern)
		AB.glow(lantern, lantern.Color, 2.0)
		AB.cylinder(1.55, 0.18, DARK_WOOD, AB.offset(originCF, x, 10.05, 3.2), model, "LantTop_" .. i)
		AB.cylinder(1.55, 0.18, DARK_WOOD, AB.offset(originCF, x, 7.95, 3.2), model, "LantBot_" .. i)
		AB.cylinder(1.55, 0.12, VERMILION, AB.offset(originCF, x, 9.0, 3.2), model, "LantBand_" .. i)
	end

	-- Hanging menu sign in the center (vertical kanji-ready slab)
	AB.block(Vector3.new(2.4, 4.5, 0.3), CREAM,
		AB.offset(originCF, 0, 9.0, 3.2), model, "MenuSign")
	AB.block(Vector3.new(2.6, 0.3, 0.4), DARK_WOOD,
		AB.offset(originCF, 0, 11.2, 3.2), model, "MenuSignTop")
	AB.block(Vector3.new(2.6, 0.3, 0.4), DARK_WOOD,
		AB.offset(originCF, 0,  6.8, 3.2), model, "MenuSignBot")
	AB.block(Vector3.new(2.4, 0.8, 0.32), DEEP_RED,
		AB.offset(originCF, 0, 10.4, 3.21), model, "MenuSignAccent")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
