-- Pachinko Player — middle-aged guy in a tracksuit, chain-smoking-style with
-- a cigarette, hat on, holding a small bucket of pachinko balls.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "Player"
local SKIN       = Color3.fromRGB(255, 220, 180)
local TRACK_NAVY = Color3.fromRGB(45, 55, 90)
local TRACK_WHT  = Color3.fromRGB(245, 240, 230)
local HAIR_GREY  = Color3.fromRGB(140, 135, 130)
local CAP_DARK   = Color3.fromRGB(60, 55, 60)
local CIG_WHITE  = Color3.fromRGB(245, 240, 230)
local CIG_EMBER  = Color3.fromRGB(255, 130, 60)
local BUCKET_YEL = Color3.fromRGB(240, 200, 60)
local SILVER     = Color3.fromRGB(200, 200, 210)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (tracksuit jacket)
	local torso = AB.part({
		size = Vector3.new(2.8, 3, 1.4), color = TRACK_NAVY,
		cf = originCF, canCollide = false, name = "Torso",
	}, model)
	-- White stripe down center
	AB.part({
		size = Vector3.new(0.4, 3.05, 1.45), color = TRACK_WHT,
		cf = AB.offset(originCF, 0, 0, 0.005), canCollide = false, name = "TrackStripe",
	}, model)
	-- Side stripes (left+right)
	for i, x in {-1.2, 1.2} do
		AB.part({
			size = Vector3.new(0.2, 3.05, 1.45), color = TRACK_WHT,
			cf = AB.offset(originCF, x, 0, 0), canCollide = false, name = "SideStripe_" .. i,
		}, model)
	end
	-- Track pants
	AB.part({
		size = Vector3.new(2.8, 0.8, 1.4), color = TRACK_NAVY,
		cf = AB.offset(originCF, 0, -1.7, 0), canCollide = false, name = "Pants",
	}, model)

	-- Head
	local head = AB.part({
		size = Vector3.new(1.8, 1.8, 1.8), color = SKIN,
		cf = AB.offset(originCF, 0, 2.2, 0), shape = Enum.PartType.Ball,
		canCollide = false, name = "Head",
	}, model)
	-- Grey hair
	AB.part({
		size = Vector3.new(1.85, 0.5, 1.85), color = HAIR_GREY,
		cf = AB.offset(originCF, 0, 2.85, 0), canCollide = false, name = "Hair",
	}, model)
	-- Dark baseball cap
	AB.part({
		size = Vector3.new(1.95, 0.6, 1.95), color = CAP_DARK,
		cf = AB.offset(originCF, 0, 3.05, 0), canCollide = false, name = "Cap",
	}, model)
	-- Cap brim (wedge forward)
	AB.wedge(Vector3.new(1.95, 0.3, 1.2), CAP_DARK,
		AB.offset(originCF, 0, 2.9, 0.95) * CFrame.Angles(0, math.rad(180), 0),
		model, "CapBrim")

	-- Cigarette in mouth
	AB.cylinder(0.12, 0.7, CIG_WHITE,
		AB.offset(originCF, 0.5, 1.7, 0.85) * CFrame.Angles(0, 0, math.rad(90)),
		model, "Cigarette")
	-- Ember tip (glowing orange)
	local ember = AB.sphere(0.15, CIG_EMBER,
		AB.offset(originCF, 0.95, 1.7, 0.85), model, "CigEmber")
	AB.neon(ember)
	AB.glow(ember, CIG_EMBER, 2)
	-- Small smoke puff above cigarette
	local smoke = AB.sphere(0.5, Color3.fromRGB(220, 215, 210),
		AB.offset(originCF, 1.3, 2.2, 0.9), model, "Smoke")
	smoke.Transparency = 0.6
	smoke.Material = Enum.Material.Neon

	-- Arms held forward holding bucket
	for _, side in {-1, 1} do
		AB.part({
			size = Vector3.new(0.9, 0.9, 2.3), color = TRACK_NAVY,
			cf = AB.offset(originCF, side * 1.6, 0.2, -1.1), canCollide = false,
			name = "Arm_" .. (side == -1 and "L" or "R"),
		}, model)
	end

	-- Pachinko ball bucket in front
	AB.cylinder(2, 1.5, BUCKET_YEL,
		AB.offset(originCF, 0, 0, -2.3), model, "Bucket")
	-- Bucket handle
	AB.cylinder(0.1, 2.4, Color3.fromRGB(60, 50, 50),
		AB.offset(originCF, 0, 0.9, -2.3) * CFrame.Angles(math.rad(90), 0, 0),
		model, "BucketHandle")
	-- Silver balls inside bucket
	for i = 1, 6 do
		local angle = (i - 1) * (math.pi / 3)
		AB.sphere(0.35, SILVER,
			AB.offset(originCF, math.cos(angle) * 0.5, 0.6, -2.3 + math.sin(angle) * 0.5),
			model, "Ball_" .. i)
	end
	-- One more ball on top center
	AB.sphere(0.35, SILVER, AB.offset(originCF, 0, 0.8, -2.3), model, "BallTop")

	AB.billboard(head, NAME, Vector2.new(220, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
