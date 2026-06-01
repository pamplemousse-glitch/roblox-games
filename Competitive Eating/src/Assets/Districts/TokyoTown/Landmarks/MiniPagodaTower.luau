-- Mini Pagoda Tower — 3-tier wooden pagoda with vermilion eaves, white walls
-- between tiers, dark wood corner posts, and a golden spire on top.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION   = Color3.fromRGB(200, 50, 40)
local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local GOLD        = Color3.fromRGB(220, 180, 60)
local STONE       = Color3.fromRGB(120, 115, 105)

-- Build a single tier centered at (0, baseY, 0) with given size + eave overhang
local function buildTier(model, originCF, baseY, wallW, wallH, eaveOverhang, tierName)
	-- Walls (paper-white)
	AB.block(Vector3.new(wallW, wallH, wallW), PAPER_WHITE,
		AB.offset(originCF, 0, baseY + wallH / 2, 0), model, tierName .. "_Walls")
	-- 4 dark-wood corner posts
	for i, offset in {
		Vector3.new(-wallW/2,  wallH / 2, -wallW/2),
		Vector3.new( wallW/2,  wallH / 2, -wallW/2),
		Vector3.new(-wallW/2,  wallH / 2,  wallW/2),
		Vector3.new( wallW/2,  wallH / 2,  wallW/2),
	} do
		AB.block(Vector3.new(0.6, wallH + 0.1, 0.6), DARK_WOOD,
			AB.offset(originCF, offset.X, baseY + offset.Y, offset.Z), model, tierName .. "_Post_" .. i)
	end
	-- Horizontal beams above wall
	AB.block(Vector3.new(wallW + 0.3, 0.5, 0.5), DARK_WOOD,
		AB.offset(originCF, 0, baseY + wallH + 0.25, -wallW/2 - 0.05), model, tierName .. "_BeamBack")
	AB.block(Vector3.new(wallW + 0.3, 0.5, 0.5), DARK_WOOD,
		AB.offset(originCF, 0, baseY + wallH + 0.25, wallW/2 + 0.05), model, tierName .. "_BeamFront")
	-- Eave roof slab (vermilion, oversized)
	local eaveW = wallW + eaveOverhang * 2
	AB.block(Vector3.new(eaveW, 1, eaveW), VERMILION,
		AB.offset(originCF, 0, baseY + wallH + 1, 0), model, tierName .. "_Eave")
	-- Eave underside (dark wood shadow)
	AB.block(Vector3.new(eaveW - 0.2, 0.3, eaveW - 0.2), DARK_WOOD,
		AB.offset(originCF, 0, baseY + wallH + 0.55, 0), model, tierName .. "_EaveUnder")
	-- Upturned corner flares (wedges at each corner)
	for i, offset in {
		Vector3.new(-eaveW/2 + 0.5, wallH + 1.4, -eaveW/2 + 0.5),
		Vector3.new( eaveW/2 - 0.5, wallH + 1.4, -eaveW/2 + 0.5),
		Vector3.new(-eaveW/2 + 0.5, wallH + 1.4,  eaveW/2 - 0.5),
		Vector3.new( eaveW/2 - 0.5, wallH + 1.4,  eaveW/2 - 0.5),
	} do
		AB.wedge(Vector3.new(2, 1.2, 1.5), VERMILION,
			AB.offset(originCF, offset.X, baseY + offset.Y, offset.Z) * CFrame.Angles(0, math.rad((i % 2 == 0) and 0 or 180), 0),
			model, tierName .. "_Flare_" .. i)
	end
	-- Vermilion ridge band on top of eave
	AB.block(Vector3.new(eaveW + 0.1, 0.3, 0.5), DARK_WOOD,
		AB.offset(originCF, 0, baseY + wallH + 1.6, 0), model, tierName .. "_Ridge")
end

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MiniPagodaTower", parent)

	-- Stone foundation
	AB.block(Vector3.new(18, 0.8, 18), STONE,
		AB.offset(originCF, 0, 0.4, 0), model, "Foundation")
	AB.block(Vector3.new(20, 0.4, 20), DARK_WOOD,
		AB.offset(originCF, 0, 0.1, 0), model, "FoundationLip")

	-- 3 tiers, shrinking in size as they go up
	buildTier(model, originCF, 0.8, 14, 8, 1.5, "Tier1")
	buildTier(model, originCF, 11.4, 11, 7, 1.3, "Tier2")
	buildTier(model, originCF, 21.0, 8, 6, 1.1, "Tier3")

	-- Decorative doorway at Tier1 front (a dark vermilion + dark wood)
	AB.block(Vector3.new(3.5, 5, 0.4), DARK_WOOD,
		AB.offset(originCF, 0, 3.3, 7.05), model, "Door")
	-- Doorway noren
	for i, x in {-1, 1} do
		AB.block(Vector3.new(1.4, 2, 0.15), VERMILION,
			AB.offset(originCF, x, 5.5, 7.18), model, "Noren_" .. i)
	end
	-- Door plaque above
	local plaque = AB.block(Vector3.new(2.5, 1, 0.3), VERMILION,
		AB.offset(originCF, 0, 7.5, 7.15), model, "DoorPlaque")
	AB.neon(plaque)
	AB.glow(plaque, VERMILION, 2)

	-- Round windows on each tier
	for tier, info in {
		{y = 5, r = 1.4, z = 0, faceZ = 7.1, w = 14},
		{y = 14, r = 1.2, z = 0, faceZ = 5.55, w = 11},
		{y = 23, r = 1, z = 0, faceZ = 4.05, w = 8},
	} do
		AB.cylinder(info.r * 2, 0.5, PAPER_WHITE,
			AB.offset(originCF, 0, info.y, info.faceZ) * CFrame.Angles(math.rad(90), 0, 0),
			model, "Window_" .. tier)
		-- Window frame
		AB.cylinder(info.r * 2 + 0.3, 0.55, DARK_WOOD,
			AB.offset(originCF, 0, info.y, info.faceZ - 0.05) * CFrame.Angles(math.rad(90), 0, 0),
			model, "WinFrame_" .. tier)
	end

	-- Golden spire on top
	-- Base ring
	AB.cylinder(2.5, 0.4, GOLD,
		AB.offset(originCF, 0, 30, 0), model, "SpireBaseRing")
	-- Tall pole
	AB.cylinder(0.5, 8, GOLD,
		AB.offset(originCF, 0, 34.5, 0), model, "SpirePole")
	-- 3 stacked gold rings (sorin disc style)
	for i, y in {31, 32, 33} do
		AB.cylinder(1.6 - (i - 1) * 0.3, 0.15, GOLD,
			AB.offset(originCF, 0, y, 0), model, "SorinRing_" .. i)
	end
	-- Top finial sphere (glowing yellow)
	local finial = AB.sphere(1.4, LANTERN_Y,
		AB.offset(originCF, 0, 39.5, 0), model, "Finial")
	AB.neon(finial)
	AB.glow(finial, LANTERN_Y, 4)
	-- Small top point
	AB.cylinder(0.2, 1.4, GOLD,
		AB.offset(originCF, 0, 40.7, 0), model, "FinialTip")

	-- Lanterns hanging from Tier1 eave corners
	for i, offset in {
		Vector3.new(-8.5, 9.5, 8.5),
		Vector3.new( 8.5, 9.5, 8.5),
		Vector3.new(-8.5, 9.5, -8.5),
		Vector3.new( 8.5, 9.5, -8.5),
	} do
		local lantern = AB.cylinder(1.2, 1.5, VERMILION,
			AB.offset(originCF, offset.X, offset.Y, offset.Z), model, "EaveLantern_" .. i)
		AB.neon(lantern)
		AB.glow(lantern, LANTERN_Y, 2)
		-- Rope to eave
		AB.block(Vector3.new(0.08, 0.8, 0.08), DARK_WOOD,
			AB.offset(originCF, offset.X, offset.Y + 1.1, offset.Z), model, "EaveLanternRope_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
