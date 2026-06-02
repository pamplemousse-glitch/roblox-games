-- Sushi Daiko — sushi bar with dark cypress wood + cream shoji facade,
-- indigo noren curtain, glass display window showing nigiri silhouettes,
-- single-tier curved tile roof. Footprint ≈ 26w × 20h × 25d.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local INDIGO      = Color3.fromRGB(35, 50, 95)
local INDIGO_DEEP = Color3.fromRGB(25, 35, 70)
local CYPRESS     = Color3.fromRGB(130, 95, 65)
local DARK_WOOD   = Color3.fromRGB(60, 40, 25)
local CREAM       = Color3.fromRGB(240, 232, 215)
local SLATE       = Color3.fromRGB(50, 50, 55)
local GREY_STONE  = Color3.fromRGB(110, 110, 110)
local RICE_WHITE  = Color3.fromRGB(245, 245, 235)
local SALMON      = Color3.fromRGB(230, 130, 100)
local TUNA_RED    = Color3.fromRGB(180, 50, 55)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local NORI_BLACK  = Color3.fromRGB(25, 30, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SushiDaiko", parent)

	-- Foundation + stone step
	AB.block(Vector3.new(26, 0.4, 25), GREY_STONE,
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")
	AB.block(Vector3.new(12, 0.4, 2), GREY_STONE,
		AB.offset(originCF, 0, 0.5, 13.2), model, "Step")

	-- Walls (cypress wood)
	AB.block(Vector3.new(26, 13, 1), CYPRESS, AB.offset(originCF, 0, 6.9, -12), model, "BackWall")
	AB.block(Vector3.new(1, 13, 25), CYPRESS, AB.offset(originCF, -12.5, 6.9, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 13, 25), CYPRESS, AB.offset(originCF,  12.5, 6.9, 0), model, "RightWall")

	-- Front facade with 6-wide doorway
	AB.block(Vector3.new(10, 13, 1), CYPRESS, AB.offset(originCF, -8, 6.9, 12), model, "FrontLeft")
	AB.block(Vector3.new(10, 13, 1), CYPRESS, AB.offset(originCF,  8, 6.9, 12), model, "FrontRight")
	AB.block(Vector3.new(6, 3.5, 1), CYPRESS, AB.offset(originCF, 0, 11.65, 12), model, "FrontHeader")

	-- Dark wood plank trim (lower wainscot)
	AB.block(Vector3.new(26, 2.5, 0.3), DARK_WOOD,
		AB.offset(originCF, 0, 2.0, 12.2), model, "WainscotFront")
	for i, x in {-12.7, 12.7} do
		AB.block(Vector3.new(0.3, 2.5, 25), DARK_WOOD,
			AB.offset(originCF, x, 2.0, 0), model, "WainscotSide_" .. i)
	end

	-- Shoji sliding doors in doorway (two cream panels)
	for i, x in {-1.5, 1.5} do
		AB.block(Vector3.new(2.9, 7, 0.4), CREAM,
			AB.offset(originCF, x, 4.7, 12.3), model, "ShojiDoor_" .. i)
		AB.block(Vector3.new(2.9, 0.15, 0.5), DARK_WOOD,
			AB.offset(originCF, x, 6.3, 12.4), model, "ShojiCross_" .. i)
		AB.block(Vector3.new(0.15, 7, 0.5), DARK_WOOD,
			AB.offset(originCF, x, 4.7, 12.4), model, "ShojiVert_" .. i)
	end

	-- Glass display window (left side) with simulated nigiri inside
	AB.block(Vector3.new(7, 4, 0.4), Color3.fromRGB(180, 210, 220),
		AB.offset(originCF, -7.5, 5.5, 12.3), model, "DisplayGlass") :: BasePart
	-- Display platform
	AB.block(Vector3.new(7, 0.3, 1.8), DARK_WOOD,
		AB.offset(originCF, -7.5, 4.0, 11.8), model, "DisplayShelf")
	-- Nigiri pieces on shelf (rice block + topping)
	for i, dx in {-2.4, -1.0, 0.5, 1.8} do
		AB.block(Vector3.new(0.9, 0.5, 0.6), RICE_WHITE,
			AB.offset(originCF, -7.5 + dx, 4.4, 11.8), model, "Rice_" .. i)
		local topping
		if i % 2 == 0 then topping = SALMON else topping = TUNA_RED end
		AB.block(Vector3.new(1.0, 0.2, 0.7), topping,
			AB.offset(originCF, -7.5 + dx, 4.75, 11.8), model, "Topping_" .. i)
	end
	-- Nori band on one
	AB.block(Vector3.new(1.05, 0.6, 0.15), NORI_BLACK,
		AB.offset(originCF, -7.5 + 0.5, 4.55, 12.05), model, "NoriBand")

	-- Right-side wood lattice screen (decorative)
	for i = 1, 6 do
		AB.block(Vector3.new(0.2, 4, 0.4), DARK_WOOD,
			AB.offset(originCF, 5.0 + (i - 1) * 1.0, 5.5, 12.3), model, "Lattice_" .. i)
	end

	-- Indigo noren curtain (4 panels)
	for i, x in {-2.2, -0.7, 0.7, 2.2} do
		AB.block(Vector3.new(1.3, 3.5, 0.2), INDIGO,
			AB.offset(originCF, x, 7.8, 12.55), model, "Noren_" .. i)
		AB.block(Vector3.new(1.32, 0.7, 0.22), CREAM,
			AB.offset(originCF, x, 9.0, 12.57), model, "NorenStripe_" .. i)
	end
	AB.block(Vector3.new(7.5, 0.35, 0.4), DARK_WOOD,
		AB.offset(originCF, 0, 9.6, 12.55), model, "NorenRod")

	-- Two small white-paper square lanterns flanking the door
	for i, x in {-4.2, 4.2} do
		local box = AB.block(Vector3.new(1.4, 1.6, 1.4), CREAM,
			AB.offset(originCF, x, 11.3, 12.7), model, "SqLantern_" .. i)
		AB.neon(box)
		AB.glow(box, LANTERN_Y, 1.5)
		AB.block(Vector3.new(1.55, 0.15, 1.55), DARK_WOOD,
			AB.offset(originCF, x, 12.2, 12.7), model, "SqLanternTop_" .. i)
		AB.block(Vector3.new(1.55, 0.15, 1.55), DARK_WOOD,
			AB.offset(originCF, x, 10.4, 12.7), model, "SqLanternBot_" .. i)
	end

	-- Sloped tile roof + indigo ridge cap
	AB.block(Vector3.new(28, 1.0, 27), SLATE,
		AB.offset(originCF, 0, 14.0, 0), model, "Roof")
	AB.block(Vector3.new(28, 0.5, 1.2), INDIGO_DEEP,
		AB.offset(originCF, 0, 14.55, 0), model, "RoofRidge")
	-- Eave wedges (front corners)
	AB.wedge(Vector3.new(2, 1.2, 3.5), SLATE,
		AB.offset(originCF, -13.0, 14.2, 11.8) * CFrame.Angles(0, math.rad(180), 0), model, "EaveFL")
	AB.wedge(Vector3.new(2, 1.2, 3.5), SLATE,
		AB.offset(originCF,  13.0, 14.2, 11.8), model, "EaveFR")

	-- Vertical kanji sign banner (left of door)
	AB.block(Vector3.new(1.5, 8, 0.3), INDIGO_DEEP,
		AB.offset(originCF, -10.5, 7.5, 12.7), model, "VerticalSign")
	AB.block(Vector3.new(1.7, 0.25, 0.4), DARK_WOOD,
		AB.offset(originCF, -10.5, 11.4, 12.7), model, "VertSignTop")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
