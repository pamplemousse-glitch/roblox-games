-- Pablo & Marco — two kids in mid-kick play, soccer ball between them.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN        = Color3.fromRGB(210, 165, 130)
local PAPEL_GREEN = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL  = Color3.fromRGB(43, 140, 156)
local HAIR_BLACK  = Color3.fromRGB(40, 30, 25)
local BLACK       = Color3.fromRGB(30, 25, 25)
local WHITE       = Color3.fromRGB(245, 240, 235)
local DUST_TAN    = Color3.fromRGB(220, 195, 160)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("KidsKickingBall", parent)

	-- ============================================================
	-- KID 1 — PABLO (green jersey, mid-kick at x = -2)
	-- ============================================================
	local p1X = -2

	-- Torso (small)
	local pabloTorso = AB.block(Vector3.new(2.0, 2.2, 1.0), PAPEL_GREEN,
		AB.offset(originCF, p1X, 1.1, 0), model, "Pablo_Torso")

	-- Head
	AB.sphere(1.4, SKIN,
		AB.offset(originCF, p1X, 2.9, 0), model, "Pablo_Head")
	-- Eyes
	for i, x in {-0.28, 0.28} do
		AB.sphere(0.15, BLACK,
			AB.offset(originCF, p1X + x, 3.0, 0.68), model, "Pablo_Eye_" .. i)
	end
	-- Open mouth (mid-yell)
	AB.block(Vector3.new(0.3, 0.18, 0.12), BLACK,
		AB.offset(originCF, p1X, 2.65, 0.7), model, "Pablo_Mouth")

	-- Hair
	AB.sphere(1.5, HAIR_BLACK,
		AB.offset(originCF, p1X, 3.1, -0.15), model, "Pablo_Hair")

	-- Arms (out for balance)
	AB.block(Vector3.new(0.7, 1.8, 0.7), PAPEL_GREEN,
		AB.offset(originCF, p1X - 1.4, 1.1, 0) * CFrame.Angles(0, 0, math.rad(20)),
		model, "Pablo_Arm_L")
	AB.sphere(0.55, SKIN,
		AB.offset(originCF, p1X - 1.7, 0.2, 0), model, "Pablo_Hand_L")
	AB.block(Vector3.new(0.7, 1.8, 0.7), PAPEL_GREEN,
		AB.offset(originCF, p1X + 1.4, 1.4, -0.2) * CFrame.Angles(math.rad(15), 0, math.rad(-15)),
		model, "Pablo_Arm_R")
	AB.sphere(0.55, SKIN,
		AB.offset(originCF, p1X + 1.7, 0.5, -0.5), model, "Pablo_Hand_R")

	-- Legs — left planted, right raised forward in kick (rotate 30° around X)
	-- Planted left leg (black shorts visible upper)
	AB.block(Vector3.new(0.7, 1.0, 0.8), BLACK,
		AB.offset(originCF, p1X - 0.5, -0.4, 0), model, "Pablo_ShortL")
	AB.block(Vector3.new(0.7, 1.0, 0.8), WHITE,
		AB.offset(originCF, p1X - 0.5, -1.4, 0), model, "Pablo_SockL")
	AB.block(Vector3.new(0.85, 0.35, 1.3), BLACK,
		AB.offset(originCF, p1X - 0.5, -2.0, 0.2), model, "Pablo_CleatL")

	-- Right leg: rotated 30° around X axis (raised forward)
	AB.block(Vector3.new(0.7, 1.0, 0.8), BLACK,
		AB.offset(originCF, p1X + 0.5, -0.2, 0.4) * CFrame.Angles(math.rad(30), 0, 0),
		model, "Pablo_ShortR")
	AB.block(Vector3.new(0.7, 1.0, 0.8), WHITE,
		AB.offset(originCF, p1X + 0.5, -1.0, 1.2) * CFrame.Angles(math.rad(30), 0, 0),
		model, "Pablo_SockR")
	AB.block(Vector3.new(0.85, 0.35, 1.3), BLACK,
		AB.offset(originCF, p1X + 0.5, -1.6, 1.8) * CFrame.Angles(math.rad(30), 0, 0),
		model, "Pablo_CleatR")

	-- ============================================================
	-- KID 2 — MARCO (teal jersey, leaning back at x = 2)
	-- ============================================================
	local m2X = 2

	-- Torso leaning back
	AB.block(Vector3.new(2.0, 2.2, 1.0), AGAVE_TEAL,
		AB.offset(originCF, m2X, 1.1, 0.2) * CFrame.Angles(math.rad(15), 0, 0),
		model, "Marco_Torso")

	-- Head
	AB.sphere(1.4, SKIN,
		AB.offset(originCF, m2X, 3.0, -0.3), model, "Marco_Head")
	-- Eyes
	for i, x in {-0.28, 0.28} do
		AB.sphere(0.15, BLACK,
			AB.offset(originCF, m2X + x, 3.1, 0.38), model, "Marco_Eye_" .. i)
	end
	-- Smile
	AB.block(Vector3.new(0.4, 0.12, 0.12), Color3.fromRGB(160, 80, 70),
		AB.offset(originCF, m2X, 2.7, 0.4), model, "Marco_Mouth")

	-- Hair
	AB.sphere(1.5, HAIR_BLACK,
		AB.offset(originCF, m2X, 3.2, -0.45), model, "Marco_Hair")

	-- Arms out wide for balance
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.7, 1.8, 0.7), AGAVE_TEAL,
			AB.offset(originCF, m2X + side * 1.6, 1.4, 0) * CFrame.Angles(0, 0, math.rad(side * -35)),
			model, "Marco_Arm_" .. (side == -1 and "L" or "R"))
		AB.sphere(0.55, SKIN,
			AB.offset(originCF, m2X + side * 2.3, 2.0, 0),
			model, "Marco_Hand_" .. (side == -1 and "L" or "R"))
	end

	-- Legs both planted, slight stride
	for _, side in {-1, 1} do
		AB.block(Vector3.new(0.7, 1.0, 0.8), BLACK,
			AB.offset(originCF, m2X + side * 0.5, -0.4, 0),
			model, "Marco_Short_" .. (side == -1 and "L" or "R"))
		AB.block(Vector3.new(0.7, 1.0, 0.8), WHITE,
			AB.offset(originCF, m2X + side * 0.5, -1.4, 0),
			model, "Marco_Sock_" .. (side == -1 and "L" or "R"))
		AB.block(Vector3.new(0.85, 0.35, 1.3), BLACK,
			AB.offset(originCF, m2X + side * 0.5, -2.0, 0.2),
			model, "Marco_Cleat_" .. (side == -1 and "L" or "R"))
	end

	-- ============================================================
	-- SOCCER BALL — between the kids at x=0, on ground
	-- ============================================================
	AB.sphere(0.8, WHITE,
		AB.offset(originCF, 0, 0.4, 0.5), model, "SoccerBall")
	-- Classic pentagon pattern (5+ black dots)
	local pentagonOffsets = {
		Vector3.new(0, 0.4, 0.85),    -- front
		Vector3.new(0.35, 0.6, 0.55),  -- upper right
		Vector3.new(-0.35, 0.6, 0.55), -- upper left
		Vector3.new(0.35, 0.2, 0.55),  -- lower right
		Vector3.new(-0.35, 0.2, 0.55), -- lower left
		Vector3.new(0, 0.7, 0.3),      -- top
	}
	for i, off in pentagonOffsets do
		AB.block(Vector3.new(0.2, 0.2, 0.05), BLACK,
			AB.offset(originCF, off.X, off.Y, off.Z),
			model, "BallPentagon_" .. i)
	end

	-- Dust kick effect near Pablo's kicking foot
	for i = 1, 3 do
		AB.sphere(0.25 - i * 0.05, DUST_TAN,
			AB.offset(originCF, p1X + 0.5 + i * 0.3, -1.8 + i * 0.15, 1.5 + i * 0.2),
			model, "Dust_" .. i)
	end

	-- Nametag (above the model center, place on Pablo's head)
	local pabloHead = model:FindFirstChild("Pablo_Head") :: BasePart
	if pabloHead then AB.billboard(pabloHead, "Pablo & Marco", Vector2.new(220, 36), 3.0) end

	AB.pivot(model, pabloTorso)
	AB.weldAll(model)
	return model
end
