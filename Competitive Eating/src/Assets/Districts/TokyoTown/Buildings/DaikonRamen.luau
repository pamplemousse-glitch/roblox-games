-- Daikon Ramen — flagship ramen shop. Vermilion noren entry, exposed warm-wood
-- beams, paper shoji screens flanking the door, glowing "RAMEN" neon sign,
-- stacked giant lantern on the roof, chimney with steam, hanging menu boards.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION   = Color3.fromRGB(200, 50, 40)
local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local BAMBOO      = Color3.fromRGB(140, 180, 100)
local STEAM_WHITE = Color3.fromRGB(230, 230, 240)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local STONE       = Color3.fromRGB(120, 115, 105)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DaikonRamen", parent)

	-- Stone step foundation (deep + wide for hero presence)
	AB.block(Vector3.new(34, 0.8, 26), STONE,
		AB.offset(originCF, 0, 0.4, 0), model, "Foundation")
	AB.block(Vector3.new(36, 0.4, 28), DARK_WOOD,
		AB.offset(originCF, 0, 0.1, 0), model, "FoundationLip")

	-- Body — warm wood with exposed dark beam frame
	AB.block(Vector3.new(34, 15, 1), WARM_WOOD,
		AB.offset(originCF, 0, 8, -12.5), model, "BackWall")
	AB.block(Vector3.new(1, 15, 26), WARM_WOOD, AB.offset(originCF, -16.5, 8, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 15, 26), WARM_WOOD, AB.offset(originCF,  16.5, 8, 0), model, "RightWall")

	-- Exposed dark-wood corner posts
	for i, offset in {
		Vector3.new(-16.5, 8, -12.5),
		Vector3.new( 16.5, 8, -12.5),
		Vector3.new(-16.5, 8,  12.5),
		Vector3.new( 16.5, 8,  12.5),
	} do
		AB.block(Vector3.new(1.4, 15.2, 1.4), DARK_WOOD,
			AB.offset(originCF, offset.X, offset.Y, offset.Z), model, "Post_" .. i)
	end

	-- Horizontal beam band
	AB.block(Vector3.new(34.2, 0.6, 0.6), DARK_WOOD,
		AB.offset(originCF, 0, 8, 12.6), model, "FrontBeamMid")
	AB.block(Vector3.new(34.2, 0.6, 0.6), DARK_WOOD,
		AB.offset(originCF, 0, 13.5, 12.6), model, "FrontBeamHigh")

	-- Front facade — central doorway gap (10 wide)
	AB.block(Vector3.new(12, 15, 1), WARM_WOOD, AB.offset(originCF, -11, 8, 12.5), model, "FrontLeft")
	AB.block(Vector3.new(12, 15, 1), WARM_WOOD, AB.offset(originCF,  11, 8, 12.5), model, "FrontRight")
	AB.block(Vector3.new(10, 4, 1),  WARM_WOOD, AB.offset(originCF, 0, 13.5, 12.5), model, "FrontHeader")

	-- Two paper shoji windows flanking the door
	for i, x in {-11, 11} do
		AB.block(Vector3.new(6, 6, 0.6), PAPER_WHITE,
			AB.offset(originCF, x, 7, 12.8), model, "Shoji_" .. i)
		for j, dx in {-2, 0, 2} do
			AB.block(Vector3.new(0.18, 6, 0.7), DARK_WOOD,
				AB.offset(originCF, x + dx, 7, 12.9), model, "ShojiV_" .. i .. "_" .. j)
		end
		for j, dy in {-1.5, 1.5} do
			AB.block(Vector3.new(6, 0.18, 0.7), DARK_WOOD,
				AB.offset(originCF, x, 7 + dy, 12.9), model, "ShojiH_" .. i .. "_" .. j)
		end
		AB.block(Vector3.new(6.4, 0.3, 0.8), DARK_WOOD, AB.offset(originCF, x, 10.1, 12.9), model, "ShojiFrameT_" .. i)
		AB.block(Vector3.new(6.4, 0.3, 0.8), DARK_WOOD, AB.offset(originCF, x,  3.9, 12.9), model, "ShojiFrameB_" .. i)
	end

	-- Noren curtain across the doorway (5 vertical vermilion panels)
	for i, x in {-3.6, -1.8, 0, 1.8, 3.6} do
		AB.block(Vector3.new(1.6, 4, 0.2), VERMILION,
			AB.offset(originCF, x, 11, 13.1), model, "Noren_" .. i)
	end
	AB.block(Vector3.new(11, 0.4, 0.5), DARK_WOOD,
		AB.offset(originCF, 0, 13.1, 13.1), model, "NorenRod")
	AB.block(Vector3.new(10, 0.5, 0.25), PAPER_WHITE,
		AB.offset(originCF, 0, 12.7, 13.2), model, "NorenTrim")

	-- "RAMEN" Neon sign — large glowing yellow plate above the noren
	local sign = AB.block(Vector3.new(12, 2.8, 0.5), LANTERN_Y,
		AB.offset(originCF, 0, 16, 13.1), model, "RamenSign")
	AB.neon(sign)
	AB.glow(sign, LANTERN_Y, 3)
	AB.block(Vector3.new(12.6, 0.4, 0.6), DARK_WOOD, AB.offset(originCF, 0, 17.6, 13.1), model, "SignTop")
	AB.block(Vector3.new(12.6, 0.4, 0.6), DARK_WOOD, AB.offset(originCF, 0, 14.4, 13.1), model, "SignBot")
	local stripe = AB.block(Vector3.new(12, 0.4, 0.55), VERMILION,
		AB.offset(originCF, 0, 15.2, 13.2), model, "SignStripe")
	AB.neon(stripe)

	-- Hanging menu boards (3 wood plaques left of door, vertical)
	for i = 1, 3 do
		local y = 11 - (i - 1) * 2.2
		AB.block(Vector3.new(1.4, 1.8, 0.3), DARK_WOOD,
			AB.offset(originCF, -14, y, 13.0), model, "MenuBoard_" .. i)
		AB.block(Vector3.new(1.1, 1.5, 0.35), PAPER_WHITE,
			AB.offset(originCF, -14, y, 13.05), model, "MenuFace_" .. i)
	end

	-- Pitched vermilion tile-style roof
	AB.block(Vector3.new(38, 1.2, 30), VERMILION,
		AB.offset(originCF, 0, 16.5, 0), model, "Roof")
	AB.block(Vector3.new(36, 0.4, 28), DARK_WOOD,
		AB.offset(originCF, 0, 16.0, 0), model, "RoofUnderside")
	AB.block(Vector3.new(38.2, 0.5, 1.2), DARK_WOOD,
		AB.offset(originCF, 0, 17.2, 0), model, "RoofRidge")
	for i, z in {-15, 15} do
		AB.wedge(Vector3.new(38, 1, 2), VERMILION,
			AB.offset(originCF, 0, 16.7, z) * CFrame.Angles(0, math.rad(z > 0 and 180 or 0), 0),
			model, "EaveFlare_" .. i)
	end

	-- Giant rooftop hanging lantern (the iconic ramen lantern, scaled up)
	local bigLantern = AB.cylinder(5, 6, VERMILION,
		AB.offset(originCF, 0, 21, 8), model, "RoofLantern")
	AB.neon(bigLantern)
	AB.glow(bigLantern, LANTERN_Y, 4)
	for i, y in {18.5, 21, 23.5} do
		AB.cylinder(5.05, 0.3, DARK_WOOD,
			AB.offset(originCF, 0, y, 8), model, "RoofLanternStripe_" .. i)
	end
	AB.cylinder(5.1, 0.5, DARK_WOOD, AB.offset(originCF, 0, 24.2, 8), model, "RoofLanternTop")
	AB.cylinder(5.1, 0.5, DARK_WOOD, AB.offset(originCF, 0, 17.8, 8), model, "RoofLanternBot")
	AB.block(Vector3.new(0.2, 1.8, 0.2), DARK_WOOD,
		AB.offset(originCF, 0, 25.4, 8), model, "RoofLanternRope")

	-- Chimney pipe with steam puff
	AB.cylinder(1.4, 4, IRON_BLACK,
		AB.offset(originCF, -12, 19, -8), model, "Chimney")
	AB.cylinder(1.6, 0.4, DARK_WOOD,
		AB.offset(originCF, -12, 21.2, -8), model, "ChimneyCap")
	for i, offset in {
		Vector3.new(-12, 22.5, -8),
		Vector3.new(-12.8, 23.4, -7.6),
		Vector3.new(-11.4, 24.1, -8.3),
	} do
		local puff = AB.sphere(2 + i * 0.3, STEAM_WHITE,
			AB.offset(originCF, offset.X, offset.Y, offset.Z),
			model, "Steam_" .. i)
		puff.Transparency = 0.55
		puff.Material     = Enum.Material.Neon
	end

	-- Two bamboo accent stalks bordering the entry walkway
	for i, x in {-7, 7} do
		AB.cylinder(0.5, 8, BAMBOO,
			AB.offset(originCF, x, 4, 14.5), model, "Bamboo_" .. i)
		for j, y in {1.5, 3.5, 5.5, 7.5} do
			AB.cylinder(0.55, 0.18, DARK_WOOD,
				AB.offset(originCF, x, y, 14.5), model, "BambooRing_" .. i .. "_" .. j)
		end
	end

	-- Two stone step planters at the entrance
	for i, x in {-8, 8} do
		AB.block(Vector3.new(2.2, 1.4, 2.2), STONE,
			AB.offset(originCF, x, 1.5, 13.6), model, "EntryStone_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
