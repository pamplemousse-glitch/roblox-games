-- Izakaya Lantern — narrow alley izakaya defined by a dense string of red
-- paper lanterns hanging above the entrance. Sake bottle shelf visible
-- through the front window, dark wood facade.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local LANTERN_RED = Color3.fromRGB(220, 70, 60)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local VERMILION   = Color3.fromRGB(200, 50, 40)
local SAKE_GREEN  = Color3.fromRGB(80, 110, 80)
local STONE       = Color3.fromRGB(120, 115, 105)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("IzakayaLantern", parent)

	-- Foundation
	AB.block(Vector3.new(20, 0.4, 18), STONE,
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")

	-- Dark wood facade walls
	AB.block(Vector3.new(20, 14, 1), DARK_WOOD, AB.offset(originCF, 0, 7, -8.5), model, "BackWall")
	AB.block(Vector3.new(1, 14, 18), DARK_WOOD, AB.offset(originCF, -9.5, 7, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 14, 18), DARK_WOOD, AB.offset(originCF,  9.5, 7, 0), model, "RightWall")

	-- Front facade with central narrow doorway (4 wide)
	AB.block(Vector3.new(8, 14, 1), DARK_WOOD, AB.offset(originCF, -6, 7, 8.5), model, "FrontLeft")
	AB.block(Vector3.new(8, 14, 1), DARK_WOOD, AB.offset(originCF,  6, 7, 8.5), model, "FrontRight")
	AB.block(Vector3.new(4, 4, 1),  DARK_WOOD, AB.offset(originCF, 0, 12, 8.5), model, "FrontHeader")

	-- Warm-wood vertical slat trim along the front
	for i = -8, 8, 2 do
		AB.block(Vector3.new(0.25, 13, 1.05), WARM_WOOD,
			AB.offset(originCF, i, 7, 8.55), model, "Slat_" .. (i + 8))
	end

	-- Front window (left of door) — backlit sake bottle shelf
	AB.block(Vector3.new(4, 4, 0.6), PAPER_WHITE,
		AB.offset(originCF, -6, 6, 8.8), model, "Window")
	AB.block(Vector3.new(0.15, 4, 0.7), DARK_WOOD, AB.offset(originCF, -6, 6, 8.9), model, "WinMullV")
	AB.block(Vector3.new(4, 0.15, 0.7), DARK_WOOD, AB.offset(originCF, -6, 6, 8.9), model, "WinMullH")
	for i, x in {-7.2, -6.4, -5.6, -4.8} do
		AB.cylinder(0.5, 1.6, SAKE_GREEN,
			AB.offset(originCF, x, 5.5, 8.85), model, "SakeBottle_" .. i)
		AB.cylinder(0.25, 0.3, DARK_WOOD,
			AB.offset(originCF, x, 6.4, 8.85), model, "SakeCap_" .. i)
	end

	-- Right window — shop name plaque
	local plaque = AB.block(Vector3.new(4, 4, 0.4), VERMILION,
		AB.offset(originCF, 6, 6, 8.7), model, "Plaque")
	AB.neon(plaque)
	AB.glow(plaque, VERMILION, 2)
	AB.block(Vector3.new(4.4, 4.4, 0.5), DARK_WOOD,
		AB.offset(originCF, 6, 6, 8.7), model, "PlaqueBorder")

	-- Noren curtain over doorway
	for i, x in {-1, 1} do
		AB.block(Vector3.new(1.8, 2.2, 0.2), VERMILION,
			AB.offset(originCF, x, 11, 8.85), model, "Noren_" .. i)
	end
	AB.block(Vector3.new(4.2, 0.3, 0.4), DARK_WOOD,
		AB.offset(originCF, 0, 12.1, 8.85), model, "NorenRod")

	-- Dense hanging lantern string above front — 7 red paper lanterns
	for i = 1, 7 do
		local x = (i - 4) * 2.7
		local lantern = AB.cylinder(1.5, 2.0, LANTERN_RED,
			AB.offset(originCF, x, 13.5, 9.4), model, "Lantern_" .. i)
		AB.neon(lantern)
		AB.glow(lantern, LANTERN_Y, 2)
		AB.cylinder(1.55, 0.2, DARK_WOOD, AB.offset(originCF, x, 14.6, 9.4), model, "LanCapT_" .. i)
		AB.cylinder(1.55, 0.2, DARK_WOOD, AB.offset(originCF, x, 12.4, 9.4), model, "LanCapB_" .. i)
		AB.block(Vector3.new(0.1, 1, 0.1), DARK_WOOD,
			AB.offset(originCF, x, 15.2, 9.4), model, "LanRope_" .. i)
	end

	-- Horizontal wood beam carrying the lantern string
	AB.block(Vector3.new(22, 0.5, 0.5), DARK_WOOD,
		AB.offset(originCF, 0, 15.8, 9.4), model, "LanternBeam")
	for i, x in {-11, 11} do
		AB.block(Vector3.new(0.8, 0.8, 0.8), DARK_WOOD,
			AB.offset(originCF, x, 15.8, 9.4), model, "BeamCap_" .. i)
	end

	-- Sloped roof — dark wood with red ridge
	AB.block(Vector3.new(22, 1, 20), DARK_WOOD,
		AB.offset(originCF, 0, 14.5, 0), model, "Roof")
	AB.block(Vector3.new(22, 0.4, 1), LANTERN_RED,
		AB.offset(originCF, 0, 15.1, 0), model, "RoofRidge")
	for i = -3, 3 do
		AB.block(Vector3.new(0.15, 0.3, 20.1), Color3.fromRGB(50, 35, 25),
			AB.offset(originCF, i * 3, 15.1, 0), model, "RoofTileLine_" .. (i + 4))
	end

	-- Two stone lanterns flanking the entry stoop
	for i, x in {-6.5, 6.5} do
		AB.block(Vector3.new(1.2, 0.4, 1.2), STONE,
			AB.offset(originCF, x, 0.6, 11), model, "EntryLanternBase_" .. i)
		AB.block(Vector3.new(0.8, 1.4, 0.8), STONE,
			AB.offset(originCF, x, 1.5, 11), model, "EntryLanternPost_" .. i)
		local cap = AB.block(Vector3.new(1.4, 0.4, 1.4), LANTERN_Y,
			AB.offset(originCF, x, 2.4, 11), model, "EntryLanternCap_" .. i)
		AB.neon(cap)
		AB.glow(cap, LANTERN_Y, 1.5)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
