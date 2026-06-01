-- Daruma Doll — squat rounded vermilion doll with a black mustache, white
-- face, painted golden eyes. The lucky-charm rolly-poly figurine.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local VERMILION   = Color3.fromRGB(200, 50, 40)
local VERMILION_D = Color3.fromRGB(150, 35, 30)
local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local GOLD        = Color3.fromRGB(220, 180, 60)
local DARK_WOOD   = Color3.fromRGB(80, 50, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DarumaDoll", parent)

	-- Small wooden pedestal
	AB.block(Vector3.new(2.5, 0.3, 2.5), DARK_WOOD,
		AB.offset(originCF, 0, 0.15, 0), model, "Pedestal")

	-- Body (large vermilion sphere — slightly squashed)
	local body = AB.part({
		size  = Vector3.new(3.4, 3, 3.4),
		color = VERMILION,
		cf    = AB.offset(originCF, 0, 2, 0),
		shape = Enum.PartType.Ball,
		name  = "Body",
	}, model)

	-- Bottom dark band (suggests weight)
	AB.cylinder(3.4, 0.4, VERMILION_D,
		AB.offset(originCF, 0, 0.6, 0), model, "BotBand")

	-- White face area (a flatter ellipsoid in front)
	AB.part({
		size  = Vector3.new(2.6, 1.6, 0.4),
		color = PAPER_WHITE,
		cf    = AB.offset(originCF, 0, 2.4, 1.5),
		name  = "FacePanel",
	}, model)

	-- Two big round black eyes (the iconic "make a wish, paint an eye" feature)
	for i, x in {-0.6, 0.6} do
		AB.sphere(0.55, IRON_BLACK, AB.offset(originCF, x, 2.6, 1.75), model, "Eye_" .. i)
		-- Gold painted iris in only the right eye (wish granted)
		if x > 0 then
			AB.sphere(0.2, GOLD, AB.offset(originCF, x, 2.6, 1.95), model, "EyeIris")
		end
	end

	-- Mustache (a thick dark moustache band)
	AB.block(Vector3.new(1.8, 0.3, 0.4), IRON_BLACK,
		AB.offset(originCF, 0, 2.1, 1.78), model, "Mustache")
	-- Mustache tips
	for i, x in {-1, 1} do
		AB.block(Vector3.new(0.2, 0.6, 0.4), IRON_BLACK,
			AB.offset(originCF, x, 1.85, 1.78) * CFrame.Angles(0, 0, math.rad(x * 30)),
			model, "MustacheTip_" .. i)
	end

	-- Mouth (small black line)
	AB.block(Vector3.new(0.6, 0.1, 0.4), IRON_BLACK,
		AB.offset(originCF, 0, 1.6, 1.78), model, "Mouth")

	-- Gold kanji emblem on belly (square)
	AB.block(Vector3.new(0.9, 0.9, 0.1), GOLD,
		AB.offset(originCF, 0, 1.0, 1.65), model, "BellyEmblem")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
