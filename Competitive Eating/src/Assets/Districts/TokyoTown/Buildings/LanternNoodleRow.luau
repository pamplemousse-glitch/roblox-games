-- Lantern Noodle Row — a long backdrop strip of 3 packed noodle counters
-- (yatai-style attached shops). Continuous lantern string above, exposed
-- wooden beams, steam puffs from each shop, hanging menu plaques.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION   = Color3.fromRGB(200, 50, 40)
local WARM_WOOD   = Color3.fromRGB(150, 100, 60)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local LANTERN_Y   = Color3.fromRGB(255, 180, 70)
local LANTERN_RED = Color3.fromRGB(220, 70, 60)
local STEAM_WHITE = Color3.fromRGB(230, 230, 240)
local STONE       = Color3.fromRGB(120, 115, 105)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local BROTH       = Color3.fromRGB(200, 150, 70)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("LanternNoodleRow", parent)

	-- Foundation strip
	AB.block(Vector3.new(36, 0.4, 12), STONE,
		AB.offset(originCF, 0, 0.2, 0), model, "Foundation")

	-- Continuous back wall
	AB.block(Vector3.new(36, 12, 1), WARM_WOOD,
		AB.offset(originCF, 0, 6, -5.5), model, "BackWall")
	-- Side walls
	AB.block(Vector3.new(1, 12, 12), WARM_WOOD, AB.offset(originCF, -17.5, 6, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 12, 12), WARM_WOOD, AB.offset(originCF,  17.5, 6, 0), model, "RightWall")

	-- 3 shop slots (12 studs wide each)
	for i = 1, 3 do
		local cx = (i - 2) * 12

		-- Dividing post between shops
		if i < 3 then
			AB.block(Vector3.new(0.6, 12, 12), DARK_WOOD,
				AB.offset(originCF, cx + 6, 6, 0), model, "Divider_" .. i)
		end

		-- Counter (the half-wall front of each shop)
		AB.block(Vector3.new(11, 3.5, 0.5), DARK_WOOD,
			AB.offset(originCF, cx, 1.75, 5.5), model, "Counter_" .. i)
		-- Counter top (lighter wood)
		AB.block(Vector3.new(11, 0.3, 1.6), WARM_WOOD,
			AB.offset(originCF, cx, 3.6, 5.0), model, "CounterTop_" .. i)

		-- Two stools at each counter
		for j, dx in {-3, 3} do
			AB.cylinder(0.4, 2.5, IRON_BLACK,
				AB.offset(originCF, cx + dx, 1.25, 6.4), model, "StoolLeg_" .. i .. "_" .. j)
			AB.cylinder(1.2, 0.3, DARK_WOOD,
				AB.offset(originCF, cx + dx, 2.55, 6.4), model, "StoolSeat_" .. i .. "_" .. j)
		end

		-- Steaming pot of broth on counter
		AB.cylinder(2, 1.6, IRON_BLACK,
			AB.offset(originCF, cx, 4.5, 4.5), model, "Pot_" .. i)
		AB.cylinder(1.7, 0.15, BROTH,
			AB.offset(originCF, cx, 5.3, 4.5), model, "PotBroth_" .. i)
		-- Steam puffs
		for j, offset in {
			Vector3.new(0, 6.2, 0),
			Vector3.new(0.6, 6.8, -0.2),
			Vector3.new(-0.4, 7.4, 0.3),
		} do
			local puff = AB.sphere(0.9 + j * 0.2, STEAM_WHITE,
				AB.offset(originCF, cx + offset.X, offset.Y, 4.5 + offset.Z),
				model, "Steam_" .. i .. "_" .. j)
			puff.Transparency = 0.55
			puff.Material     = Enum.Material.Neon
		end

		-- Hanging menu plaque (vertical wood with paper face)
		AB.block(Vector3.new(1.6, 2.2, 0.3), DARK_WOOD,
			AB.offset(originCF, cx, 9, 5.6), model, "Menu_" .. i)
		AB.block(Vector3.new(1.3, 1.9, 0.35), PAPER_WHITE,
			AB.offset(originCF, cx, 9, 5.65), model, "MenuFace_" .. i)
	end

	-- Continuous lantern string above (10 lanterns, alternating red/yellow)
	for i = 1, 10 do
		local x = (i - 5.5) * 3.4
		local color = (i % 2 == 0) and LANTERN_Y or LANTERN_RED
		local lantern = AB.cylinder(1.4, 1.8, color,
			AB.offset(originCF, x, 10.5, 6), model, "Lantern_" .. i)
		AB.neon(lantern)
		AB.glow(lantern, color, 1.8)
		-- Caps
		AB.cylinder(1.45, 0.18, DARK_WOOD, AB.offset(originCF, x, 11.45, 6), model, "LCapT_" .. i)
		AB.cylinder(1.45, 0.18, DARK_WOOD, AB.offset(originCF, x, 9.55, 6), model, "LCapB_" .. i)
		-- Rope
		AB.block(Vector3.new(0.1, 0.7, 0.1), DARK_WOOD,
			AB.offset(originCF, x, 11.9, 6), model, "LRope_" .. i)
	end

	-- Long exposed beam carrying the lantern string
	AB.block(Vector3.new(36, 0.5, 0.5), DARK_WOOD,
		AB.offset(originCF, 0, 12.2, 6), model, "LanternBeam")
	-- Beam supports (vertical posts from facade to beam)
	for i, x in {-15, -5, 5, 15} do
		AB.cylinder(0.3, 1.5, DARK_WOOD,
			AB.offset(originCF, x, 11.5, 6), model, "BeamSupport_" .. i)
	end

	-- Sloped tile-style roof
	AB.block(Vector3.new(38, 1, 14), DARK_WOOD,
		AB.offset(originCF, 0, 12.6, 0), model, "Roof")
	AB.block(Vector3.new(38, 0.3, 1), VERMILION,
		AB.offset(originCF, 0, 13.15, 0), model, "RoofRidge")
	-- Roof tile lines
	for i = -3, 3 do
		AB.block(Vector3.new(0.15, 0.3, 14.1), Color3.fromRGB(50, 35, 25),
			AB.offset(originCF, i * 5, 13.15, 0), model, "RoofTileLine_" .. (i + 4))
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
