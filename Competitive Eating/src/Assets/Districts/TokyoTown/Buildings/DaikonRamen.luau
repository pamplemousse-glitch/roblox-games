-- Daikon Ramen — flagship ramen shop. Two-tier pagoda-style tile roof,
-- vermilion beams, big red noren curtain, oversized paper lantern, kanji panel.
-- Footprint ≈ 30w × 22h × 27d.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION   = Color3.fromRGB(200, 50, 40)
local DEEP_RED    = Color3.fromRGB(150, 30, 30)
local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local DARK_WOOD   = Color3.fromRGB(70, 45, 30)
local SLATE       = Color3.fromRGB(45, 45, 55)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local GREY_STONE  = Color3.fromRGB(110, 110, 110)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DaikonRamen", parent)

	-- Foundation
	AB.block(Vector3.new(30, 0.4, 27), GREY_STONE,
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")
	-- Stone step at front
	AB.block(Vector3.new(14, 0.4, 2.5), GREY_STONE,
		AB.offset(originCF, 0, 0.5, 14.2), model, "Step")

	-- Back + side walls (warm wood)
	AB.block(Vector3.new(30, 14, 1), WARM_WOOD, AB.offset(originCF, 0, 7.4, -13), model, "BackWall")
	AB.block(Vector3.new(1, 14, 27), WARM_WOOD, AB.offset(originCF, -14.5, 7.4, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 14, 27), WARM_WOOD, AB.offset(originCF,  14.5, 7.4, 0), model, "RightWall")

	-- Front facade with 8-wide doorway gap
	AB.block(Vector3.new(11, 14, 1), WARM_WOOD, AB.offset(originCF, -9.5, 7.4, 13), model, "FrontLeft")
	AB.block(Vector3.new(11, 14, 1), WARM_WOOD, AB.offset(originCF,  9.5, 7.4, 13), model, "FrontRight")
	AB.block(Vector3.new(8, 3.5, 1), WARM_WOOD, AB.offset(originCF, 0, 12.65, 13), model, "FrontHeader")

	-- Vertical vermilion beams on the corners
	for i, x in {-14.5, 14.5} do
		AB.block(Vector3.new(0.8, 14, 0.8), VERMILION,
			AB.offset(originCF, x, 7.4, 13), model, "CornerBeam_" .. i)
	end
	-- Horizontal vermilion lintel above doorway
	AB.block(Vector3.new(30, 0.8, 0.8), VERMILION,
		AB.offset(originCF, 0, 11.0, 13.4), model, "Lintel")

	-- Shoji paper windows flanking the doorway
	for i, x in {-9.5, 9.5} do
		AB.block(Vector3.new(7, 6, 0.5), PAPER_WHITE,
			AB.offset(originCF, x, 6.5, 13.4), model, "Shoji_" .. i)
		-- Vertical mullions (3 per panel)
		for j, dx in {-2.2, 0, 2.2} do
			AB.block(Vector3.new(0.18, 6, 0.6), DARK_WOOD,
				AB.offset(originCF, x + dx, 6.5, 13.5), model, "ShojiV_" .. i .. "_" .. j)
		end
		-- Horizontal mullion
		AB.block(Vector3.new(7, 0.18, 0.6), DARK_WOOD,
			AB.offset(originCF, x, 6.5, 13.5), model, "ShojiH_" .. i)
	end

	-- Big red noren curtain across doorway (5 vertical panels with white kanji band feel)
	for i, x in {-3.2, -1.6, 0, 1.6, 3.2} do
		AB.block(Vector3.new(1.4, 4, 0.2), VERMILION,
			AB.offset(originCF, x, 8.5, 13.7), model, "Noren_" .. i)
		-- white stripe near top (where kanji would print)
		AB.block(Vector3.new(1.42, 1.0, 0.22), PAPER_WHITE,
			AB.offset(originCF, x, 9.8, 13.72), model, "NorenStripe_" .. i)
	end
	AB.block(Vector3.new(9, 0.4, 0.5), DARK_WOOD,
		AB.offset(originCF, 0, 10.6, 13.7), model, "NorenRod")

	-- Oversized hanging lantern above door
	local lantern = AB.cylinder(3.0, 4.2, LANTERN_Y,
		AB.offset(originCF, 0, 16.8, 13.7), model, "BigLantern")
	AB.neon(lantern)
	AB.glow(lantern, lantern.Color, 3.0)
	for i, y in {15.0, 18.6} do
		AB.cylinder(3.1, 0.35, DARK_WOOD,
			AB.offset(originCF, 0, y, 13.7), model, "LanternCap_" .. i)
	end
	AB.block(Vector3.new(0.15, 1.6, 0.15), DARK_WOOD,
		AB.offset(originCF, 0, 19.7, 13.7), model, "LanternRope")

	-- Lower roof tier (slate tiles), with vermilion ridge cap
	AB.block(Vector3.new(32, 0.9, 29), SLATE,
		AB.offset(originCF, 0, 14.7, 0), model, "RoofLower")
	AB.block(Vector3.new(32, 0.5, 1.2), VERMILION,
		AB.offset(originCF, 0, 15.2, 0), model, "RoofLowerRidge")
	-- Upturned eave wedges (pagoda hint)
	AB.wedge(Vector3.new(2.5, 1.5, 4), SLATE,
		AB.offset(originCF, -15.0, 15.0, -12.5) * CFrame.Angles(0, math.rad(180), 0), model, "EaveBL")
	AB.wedge(Vector3.new(2.5, 1.5, 4), SLATE,
		AB.offset(originCF,  15.0, 15.0, -12.5), model, "EaveBR")
	AB.wedge(Vector3.new(2.5, 1.5, 4), SLATE,
		AB.offset(originCF, -15.0, 15.0,  12.5) * CFrame.Angles(0, math.rad(180), 0), model, "EaveFL")
	AB.wedge(Vector3.new(2.5, 1.5, 4), SLATE,
		AB.offset(originCF,  15.0, 15.0,  12.5), model, "EaveFR")

	-- Upper pagoda tier
	AB.block(Vector3.new(18, 4, 14), WARM_WOOD,
		AB.offset(originCF, 0, 17.7, 0), model, "UpperBox")
	AB.block(Vector3.new(22, 0.8, 18), SLATE,
		AB.offset(originCF, 0, 20.0, 0), model, "RoofUpper")
	AB.block(Vector3.new(22, 0.4, 1), VERMILION,
		AB.offset(originCF, 0, 20.4, 0), model, "RoofUpperRidge")
	-- Finial spike on top
	AB.cylinder(0.5, 2.5, DEEP_RED,
		AB.offset(originCF, 0, 22.0, 0) * CFrame.Angles(0, 0, math.rad(90)),
		model, "Finial")

	-- Kanji sign panel on the upper box (front)
	AB.block(Vector3.new(10, 2.5, 0.4), DEEP_RED,
		AB.offset(originCF, 0, 18.0, 7.2), model, "SignPanel")
	AB.block(Vector3.new(10.4, 0.3, 0.5), DARK_WOOD,
		AB.offset(originCF, 0, 19.4, 7.25), model, "SignTop")
	AB.block(Vector3.new(10.4, 0.3, 0.5), DARK_WOOD,
		AB.offset(originCF, 0, 16.6, 7.25), model, "SignBot")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
