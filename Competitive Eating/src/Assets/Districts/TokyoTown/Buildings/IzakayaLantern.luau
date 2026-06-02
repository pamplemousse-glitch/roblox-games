-- Izakaya Lantern — back-alley pub fronted by a dense wall of glowing red
-- paper lanterns at two heights, indigo noren, dark wood + hanging vertical
-- sign panels. Footprint ≈ 24w × 22h × 23d.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local LANTERN_RED = Color3.fromRGB(220, 70, 60)
local DEEP_RED    = Color3.fromRGB(140, 30, 30)
local DARK_WOOD   = Color3.fromRGB(55, 35, 25)
local MID_WOOD    = Color3.fromRGB(110, 75, 50)
local INDIGO      = Color3.fromRGB(30, 40, 80)
local CREAM       = Color3.fromRGB(240, 232, 215)
local SLATE       = Color3.fromRGB(40, 40, 50)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local GREY_STONE  = Color3.fromRGB(100, 100, 100)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("IzakayaLantern", parent)

	-- Foundation + step
	AB.block(Vector3.new(24, 0.4, 23), GREY_STONE,
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")
	AB.block(Vector3.new(10, 0.4, 1.8), GREY_STONE,
		AB.offset(originCF, 0, 0.5, 12.2), model, "Step")

	-- Walls (dark wood for moody bar vibe)
	AB.block(Vector3.new(24, 13, 1), DARK_WOOD, AB.offset(originCF, 0, 6.9, -11), model, "BackWall")
	AB.block(Vector3.new(1, 13, 23), DARK_WOOD, AB.offset(originCF, -11.5, 6.9, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 13, 23), DARK_WOOD, AB.offset(originCF,  11.5, 6.9, 0), model, "RightWall")

	-- Front facade with 5-wide doorway
	AB.block(Vector3.new(9.5, 13, 1), DARK_WOOD, AB.offset(originCF, -7.25, 6.9, 11), model, "FrontLeft")
	AB.block(Vector3.new(9.5, 13, 1), DARK_WOOD, AB.offset(originCF,  7.25, 6.9, 11), model, "FrontRight")
	AB.block(Vector3.new(5, 4, 1),   DARK_WOOD, AB.offset(originCF, 0, 11.4, 11), model, "FrontHeader")

	-- Mid-wood plank highlights on front (horizontal beams)
	for i, y in {3.5, 7.5, 10.0} do
		AB.block(Vector3.new(24, 0.4, 0.2), MID_WOOD,
			AB.offset(originCF, 0, y, 11.55), model, "PlankBeam_" .. i)
	end

	-- Indigo noren curtain (4 panels) across doorway
	for i, x in {-1.8, -0.6, 0.6, 1.8} do
		AB.block(Vector3.new(1.0, 3.5, 0.2), INDIGO,
			AB.offset(originCF, x, 7.8, 11.6), model, "Noren_" .. i)
		AB.block(Vector3.new(1.02, 0.7, 0.22), CREAM,
			AB.offset(originCF, x, 9.0, 11.62), model, "NorenStripe_" .. i)
	end
	AB.block(Vector3.new(5.5, 0.35, 0.4), MID_WOOD,
		AB.offset(originCF, 0, 9.55, 11.6), model, "NorenRod")

	-- Wood beam across full front (lantern beam, lower)
	AB.block(Vector3.new(24, 0.6, 0.5), MID_WOOD,
		AB.offset(originCF, 0, 12.0, 11.7), model, "LanternBeamLow")
	-- Upper lantern beam
	AB.block(Vector3.new(24, 0.6, 0.5), MID_WOOD,
		AB.offset(originCF, 0, 15.5, 11.7), model, "LanternBeamHigh")

	-- LOWER row of lanterns (4 red, between header and roof)
	for i = 1, 4 do
		local x = (i - 2.5) * 5.0
		local lantern = AB.cylinder(1.5, 2.0, LANTERN_RED,
			AB.offset(originCF, x, 13.2, 11.9), model, "LanternLo_" .. i)
		AB.neon(lantern)
		AB.glow(lantern, LANTERN_Y, 1.6)
		AB.cylinder(1.55, 0.18, DARK_WOOD, AB.offset(originCF, x, 14.25, 11.9), model, "LoTop_" .. i)
		AB.cylinder(1.55, 0.18, DARK_WOOD, AB.offset(originCF, x, 12.15, 11.9), model, "LoBot_" .. i)
		AB.block(Vector3.new(0.1, 0.8, 0.1), DARK_WOOD,
			AB.offset(originCF, x, 12.55, 11.9), model, "LoRope_" .. i)
	end

	-- UPPER row of lanterns (5 smaller red, higher)
	for i = 1, 5 do
		local x = (i - 3) * 4.2
		local lantern = AB.cylinder(1.1, 1.6, LANTERN_RED,
			AB.offset(originCF, x, 16.6, 11.9), model, "LanternHi_" .. i)
		AB.neon(lantern)
		AB.glow(lantern, LANTERN_Y, 1.4)
		AB.cylinder(1.15, 0.15, DARK_WOOD, AB.offset(originCF, x, 17.45, 11.9), model, "HiTop_" .. i)
		AB.cylinder(1.15, 0.15, DARK_WOOD, AB.offset(originCF, x, 15.75, 11.9), model, "HiBot_" .. i)
		AB.block(Vector3.new(0.1, 0.6, 0.1), DARK_WOOD,
			AB.offset(originCF, x, 16.1, 11.9), model, "HiRope_" .. i)
	end

	-- Vertical kanji sign panels hanging on either side of door
	for i, x in {-5.5, 5.5} do
		AB.block(Vector3.new(1.4, 6, 0.3), DEEP_RED,
			AB.offset(originCF, x, 6.5, 11.65), model, "VertSign_" .. i)
		AB.block(Vector3.new(1.6, 0.25, 0.4), DARK_WOOD,
			AB.offset(originCF, x, 9.4, 11.65), model, "VertSignTop_" .. i)
		AB.block(Vector3.new(1.6, 0.25, 0.4), DARK_WOOD,
			AB.offset(originCF, x, 3.6, 11.65), model, "VertSignBot_" .. i)
	end

	-- Sloped tile roof
	AB.block(Vector3.new(26, 1.0, 25), SLATE,
		AB.offset(originCF, 0, 18.3, 0), model, "Roof")
	AB.block(Vector3.new(26, 0.5, 1.2), DEEP_RED,
		AB.offset(originCF, 0, 18.85, 0), model, "RoofRidge")
	-- Front eaves (wedges)
	AB.wedge(Vector3.new(2, 1.2, 3), SLATE,
		AB.offset(originCF, -12.0, 18.5, 10.5) * CFrame.Angles(0, math.rad(180), 0), model, "EaveFL")
	AB.wedge(Vector3.new(2, 1.2, 3), SLATE,
		AB.offset(originCF,  12.0, 18.5, 10.5), model, "EaveFR")

	-- Stovepipe chimney on side
	AB.cylinder(1.2, 4.5, Color3.fromRGB(60, 50, 45),
		AB.offset(originCF, -9, 20.5, -5) * CFrame.Angles(0, 0, math.rad(90)),
		model, "Chimney")
	AB.cylinder(1.4, 0.4, DARK_WOOD,
		AB.offset(originCF, -9, 22.6, -5) * CFrame.Angles(0, 0, math.rad(90)),
		model, "ChimneyCap")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
