-- Giant Maneki Neko — 30-stud-tall lucky cat statue.
--
-- TODO (Phase 3 followup): swap the primitive build below for a Meshy.ai
-- preview-mode mesh. The GLB is staged at:
--
--   Competitive Eating/assets/raw/maneki-neko-preview.glb
--
-- Meshy task: 019e85a0-e403-7930-8706-a9a1374d0d22 (preview, no textures —
-- refine pass not run; mesh is untextured grey clay).
-- Generated 2026-06-01 (Session A, branch feature/tokyo-hero-A).
--
-- To finish the swap:
--   1. In Studio: File → Import 3D → select the staged GLB above. Studio
--      auto-uploads to Roblox and gives the new MeshPart a real rbxassetid.
--   2. Copy the resulting MeshId.
--   3. Replace this module's body with the same AssetService:CreateMeshPartAsync
--      pattern used in TokyoTown.Buildings.DaikonRamen et al.
--   4. Position SIZE so the bell hangs at ~17 studs (current y reference).
--
-- Until then the primitive build below is the live landmark — works fine in
-- gameplay, just lower-fidelity than the planned Meshy hero.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WHITE_FUR   = Color3.fromRGB(248, 245, 235)
local CAT_DARK    = Color3.fromRGB(200, 195, 185)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local GOLD        = Color3.fromRGB(220, 180, 60)
local GOLD_BRIGHT = Color3.fromRGB(255, 220, 90)
local VERMILION   = Color3.fromRGB(200, 50, 40)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local STONE       = Color3.fromRGB(120, 115, 105)
local PINK_NOSE   = Color3.fromRGB(255, 130, 150)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GiantManekiNeko", parent)

	-- Stone pedestal base (8-sided look via two stacked rotated blocks)
	AB.block(Vector3.new(14, 1, 14), STONE,
		AB.offset(originCF, 0, 0.5, 0), model, "Pedestal")
	AB.block(Vector3.new(12, 1, 12), STONE,
		AB.offset(originCF, 0, 1.5, 0) * CFrame.Angles(0, math.rad(22.5), 0),
		model, "Pedestal2")
	-- Pedestal kanji plate
	local plate = AB.block(Vector3.new(5, 1.5, 0.4), VERMILION,
		AB.offset(originCF, 0, 1.6, 6.1), model, "PedestalPlate")
	AB.neon(plate)
	AB.glow(plate, VERMILION, 2)

	-- Cat body (large rounded white block)
	local body = AB.part({
		size  = Vector3.new(12, 14, 10),
		color = WHITE_FUR,
		cf    = AB.offset(originCF, 0, 11, 0),
		shape = Enum.PartType.Ball,
		name  = "Body",
	}, model)

	-- Tail (curled to the right, suggested by stacked spheres)
	for i, info in {
		{Vector3.new(2, 2, 2), Vector3.new(6.5, 9, 0)},
		{Vector3.new(1.8, 1.8, 1.8), Vector3.new(7.5, 10, 0.5)},
		{Vector3.new(1.6, 1.6, 1.6), Vector3.new(8, 11.5, 1)},
		{Vector3.new(1.4, 1.4, 1.4), Vector3.new(7.5, 13, 1.4)},
	} do
		AB.part({
			size  = info[1],
			color = WHITE_FUR,
			cf    = AB.offset(originCF, info[2].X, info[2].Y, info[2].Z),
			shape = Enum.PartType.Ball,
			name  = "Tail_" .. i,
		}, model)
	end

	-- Head (sphere on top of body)
	local head = AB.part({
		size  = Vector3.new(10, 10, 9),
		color = WHITE_FUR,
		cf    = AB.offset(originCF, 0, 22, 0),
		shape = Enum.PartType.Ball,
		name  = "Head",
	}, model)

	-- Ears (two pointed wedges on top of head)
	for i, x in {-3, 3} do
		AB.wedge(Vector3.new(2.5, 3.5, 2), WHITE_FUR,
			AB.offset(originCF, x, 26, 0) * CFrame.Angles(0, math.rad(x < 0 and 0 or 180), 0),
			model, "Ear_" .. i)
		-- Pink inner ear
		AB.block(Vector3.new(1, 0.4, 1.5), PINK_NOSE,
			AB.offset(originCF, x, 26.5, 0.5), model, "EarInner_" .. i)
	end

	-- Face features
	-- Eyes (big black ovals — flattened spheres)
	for i, x in {-2.2, 2.2} do
		AB.sphere(1.6, IRON_BLACK,
			AB.offset(originCF, x, 22.5, 4), model, "Eye_" .. i)
		-- White highlight
		AB.sphere(0.4, WHITE_FUR,
			AB.offset(originCF, x + 0.5, 23.0, 4.7), model, "EyeHighlight_" .. i)
	end

	-- Nose (small pink triangle = small wedge)
	AB.wedge(Vector3.new(1, 0.8, 1), PINK_NOSE,
		AB.offset(originCF, 0, 21, 4.4) * CFrame.Angles(math.rad(180), 0, 0),
		model, "Nose")

	-- Mouth (two angled small blocks)
	for i, x in {-0.6, 0.6} do
		AB.block(Vector3.new(1.2, 0.18, 0.4), IRON_BLACK,
			AB.offset(originCF, x, 20.2, 4.4) * CFrame.Angles(0, 0, math.rad(x > 0 and 25 or -25)),
			model, "Mouth_" .. i)
	end

	-- Whiskers (3 per side)
	for i, x in {-1, 1} do
		for j = 1, 3 do
			AB.block(Vector3.new(2.5, 0.05, 0.05), IRON_BLACK,
				AB.offset(originCF, x * 3, 21.2 - (j - 2) * 0.5, 4.2) * CFrame.Angles(0, 0, math.rad((j - 2) * 8 * x)),
				model, "Whisker_" .. i .. "_" .. j)
		end
	end

	-- Cat dark patch (one ear/eye region) — gives the calico look
	AB.cylinder(2.8, 0.15, CAT_DARK,
		AB.offset(originCF, -2.5, 25.5, 0.5), model, "CalicoSpot")

	-- Gold collar with bell
	AB.cylinder(8.5, 1, GOLD,
		AB.offset(originCF, 0, 17, 0) * CFrame.Angles(math.rad(90), 0, 0),
		model, "Collar")
	-- Red ribbon below collar
	AB.cylinder(8.5, 0.4, VERMILION,
		AB.offset(originCF, 0, 16.3, 0) * CFrame.Angles(math.rad(90), 0, 0),
		model, "Ribbon")
	-- Collar bell (gold sphere, glowing)
	local bell = AB.sphere(1.8, GOLD_BRIGHT,
		AB.offset(originCF, 0, 15.7, 4.5), model, "Bell")
	AB.neon(bell)
	AB.glow(bell, GOLD_BRIGHT, 3)

	-- Raised right paw (the iconic "calling" paw)
	AB.part({
		size  = Vector3.new(2.2, 4, 2.2),
		color = WHITE_FUR,
		cf    = AB.offset(originCF, 5.5, 17, 0) * CFrame.Angles(0, 0, math.rad(-30)),
		name  = "PawArmRaised",
	}, model)
	-- Paw mitt (rounded end)
	AB.sphere(2.4, WHITE_FUR,
		AB.offset(originCF, 7.5, 19, 0), model, "PawHand")
	-- Pink paw pads
	for i, offset in {
		Vector3.new(7.5, 19, 1.3),
		Vector3.new(7.1, 19.3, 1.2),
		Vector3.new(7.9, 19.3, 1.2),
	} do
		AB.sphere(0.5, PINK_NOSE,
			AB.offset(originCF, offset.X, offset.Y, offset.Z), model, "PawPad_" .. i)
	end

	-- Left paw resting in front
	AB.block(Vector3.new(2.4, 2, 2.4), WHITE_FUR,
		AB.offset(originCF, -3.5, 7, 4), model, "PawLeft")
	-- Pink pads
	AB.sphere(0.6, PINK_NOSE,
		AB.offset(originCF, -3.5, 7.6, 5), model, "PawLeftPad")

	-- Glowing gold KOBAN coin held in front of the cat (the lucky-money charm)
	local koban = AB.block(Vector3.new(5, 3, 0.6), GOLD_BRIGHT,
		AB.offset(originCF, 0, 13, 5.6) * CFrame.Angles(0, 0, math.rad(15)),
		model, "Koban")
	AB.neon(koban)
	AB.glow(koban, GOLD_BRIGHT, 4)
	-- Koban dark center kanji rectangle
	AB.block(Vector3.new(1.5, 1.5, 0.65), DARK_WOOD,
		AB.offset(originCF, 0, 13, 5.65) * CFrame.Angles(0, 0, math.rad(15)),
		model, "KobanCenter")
	-- Koban paper detail
	AB.block(Vector3.new(1.2, 1.2, 0.7), PAPER_WHITE,
		AB.offset(originCF, 0, 13, 5.66) * CFrame.Angles(0, 0, math.rad(15)),
		model, "KobanCenterPaper")

	-- Small dark belly stripe accent
	AB.block(Vector3.new(2, 3, 0.3), CAT_DARK,
		AB.offset(originCF, 0, 8, 5), model, "BellyStripe")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
