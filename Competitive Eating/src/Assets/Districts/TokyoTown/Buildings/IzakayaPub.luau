-- Izakaya Pub — warm wood facade with a row of glowing red paper lanterns
-- and a pair of shoji sliding doors.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local LANTERN_RED = Color3.fromRGB(220, 70, 60)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("IzakayaPub", parent)

	-- Foundation
	AB.block(Vector3.new(28, 0.4, 20), Color3.fromRGB(100, 100, 100),
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")

	-- Walls (warm wood)
	AB.block(Vector3.new(28, 13, 1), WARM_WOOD, AB.offset(originCF, 0, 6.5, -9.5), model, "BackWall")
	AB.block(Vector3.new(1, 13, 20), WARM_WOOD, AB.offset(originCF, -13.5, 6.5, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 13, 20), WARM_WOOD, AB.offset(originCF,  13.5, 6.5, 0), model, "RightWall")

	-- Front with doorway gap (6 wide)
	AB.block(Vector3.new(11, 13, 1), WARM_WOOD, AB.offset(originCF, -8.5, 6.5, 9.5), model, "FrontLeft")
	AB.block(Vector3.new(11, 13, 1), WARM_WOOD, AB.offset(originCF,  8.5, 6.5, 9.5), model, "FrontRight")
	AB.block(Vector3.new(6, 4, 1),   WARM_WOOD, AB.offset(originCF, 0, 11, 9.5), model, "FrontHeader")

	-- Shoji sliding doors (two paper panels in the doorway)
	for i, x in {-1.6, 1.6} do
		AB.block(Vector3.new(3.0, 7, 0.4), PAPER_WHITE,
			AB.offset(originCF, x, 4.5, 9.7), model, "ShojiDoor_" .. i)
		-- Cross mullion
		AB.block(Vector3.new(3.0, 0.15, 0.5), DARK_WOOD,
			AB.offset(originCF, x, 4.5, 9.8), model, "ShojiCross_" .. i)
		AB.block(Vector3.new(0.15, 7, 0.5), DARK_WOOD,
			AB.offset(originCF, x, 4.5, 9.8), model, "ShojiVert_" .. i)
	end

	-- Row of 4 hanging red lanterns above the front
	for i = 1, 4 do
		local x = (i - 2.5) * 5.0
		local lantern = AB.cylinder(1.6, 2.2, LANTERN_RED,
			AB.offset(originCF, x, 12.8, 10.2), model, "Lantern_" .. i)
		AB.neon(lantern)
		AB.glow(lantern, LANTERN_Y, 1.8)
		-- Black caps top/bottom
		AB.cylinder(1.65, 0.2, DARK_WOOD, AB.offset(originCF, x, 13.95, 10.2), model, "LanternTopCap_" .. i)
		AB.cylinder(1.65, 0.2, DARK_WOOD, AB.offset(originCF, x, 11.65, 10.2), model, "LanternBotCap_" .. i)
		-- Rope
		AB.block(Vector3.new(0.1, 1, 0.1), DARK_WOOD,
			AB.offset(originCF, x, 14.5, 10.2), model, "Rope_" .. i)
	end

	-- Wood beam running across the lantern row
	AB.block(Vector3.new(28, 0.5, 0.5), DARK_WOOD,
		AB.offset(originCF, 0, 15.1, 10.2), model, "LanternBeam")

	-- Sloped tile-style roof
	AB.block(Vector3.new(30, 1, 22), DARK_WOOD,
		AB.offset(originCF, 0, 13.5, 0), model, "Roof")
	-- Decorative ridge cap
	AB.block(Vector3.new(30, 0.5, 1), LANTERN_RED,
		AB.offset(originCF, 0, 14.1, 0), model, "RoofRidge")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
