-- Schoolgirl Bento — sailor-uniform schoolgirl carrying a small bento box.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME       = "Schoolgirl"
local SKIN       = Color3.fromRGB(255, 220, 180)
local SAILOR_WHT = Color3.fromRGB(245, 240, 230)
local NAVY       = Color3.fromRGB(50, 60, 100)
local SKIRT_NAVY = Color3.fromRGB(35, 45, 80)
local TIE_RED    = Color3.fromRGB(200, 50, 50)
local HAIR_DARK  = Color3.fromRGB(40, 30, 30)
local BENTO_PINK = Color3.fromRGB(255, 180, 180)
local DARK_WOOD  = Color3.fromRGB(80, 50, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Sailor shirt torso (white with navy collar)
	local torso = AB.part({
		size = Vector3.new(2.4, 2, 1.1), color = SAILOR_WHT,
		cf = AB.offset(originCF, 0, 0.4, 0), canCollide = false, name = "Torso",
	}, model)
	-- Navy sailor collar (V-shape suggested by 3 parts)
	AB.part({
		size = Vector3.new(2.45, 0.4, 1.15), color = NAVY,
		cf = AB.offset(originCF, 0, 1.2, 0), canCollide = false, name = "Collar",
	}, model)
	for i, side in {-1, 1} do
		AB.block(Vector3.new(0.4, 1.4, 0.05), NAVY,
			AB.offset(originCF, side * 0.5, 0.7, 0.56) * CFrame.Angles(0, 0, math.rad(side * 15)),
			model, "CollarFlap_" .. i)
	end
	-- Red ribbon at chest
	AB.block(Vector3.new(0.8, 0.4, 0.1), TIE_RED,
		AB.offset(originCF, 0, 0.8, 0.6), model, "Ribbon")

	-- Pleated navy skirt
	AB.part({
		size = Vector3.new(2.6, 1.6, 1.3), color = SKIRT_NAVY,
		cf = AB.offset(originCF, 0, -1.4, 0), canCollide = false, name = "Skirt",
	}, model)
	-- Skirt pleats (vertical darker lines)
	for i = -3, 3 do
		AB.block(Vector3.new(0.08, 1.6, 1.35), Color3.fromRGB(25, 30, 60),
			AB.offset(originCF, i * 0.35, -1.4, 0), model, "Pleat_" .. (i + 4))
	end

	-- Head
	local head = AB.part({
		size = Vector3.new(1.8, 1.8, 1.8), color = SKIN,
		cf = AB.offset(originCF, 0, 2.7, 0), shape = Enum.PartType.Ball,
		canCollide = false, name = "Head",
	}, model)
	-- Hair (long, framing face)
	AB.part({
		size = Vector3.new(1.95, 1.4, 1.95), color = HAIR_DARK,
		cf = AB.offset(originCF, 0, 3.1, 0), canCollide = false, name = "Hair",
	}, model)
	-- Long hair down the back
	AB.block(Vector3.new(1.8, 2, 0.5), HAIR_DARK,
		AB.offset(originCF, 0, 2.0, -0.7), model, "HairLong")

	-- Arms held forward holding bento
	for _, side in {-1, 1} do
		AB.part({
			size = Vector3.new(0.7, 0.7, 2.2), color = SAILOR_WHT,
			cf = AB.offset(originCF, side * 1.4, 0.4, -1), canCollide = false,
			name = "Arm_" .. (side == -1 and "L" or "R"),
		}, model)
	end

	-- Bento box held in front
	AB.block(Vector3.new(2, 0.7, 1.2), BENTO_PINK,
		AB.offset(originCF, 0, 0.2, -2), model, "BentoBody")
	-- Bento lid
	AB.block(Vector3.new(2.1, 0.2, 1.25), Color3.fromRGB(230, 150, 150),
		AB.offset(originCF, 0, 0.6, -2), model, "BentoLid")
	-- Wrapping cloth knot on top
	AB.sphere(0.4, TIE_RED, AB.offset(originCF, 0, 0.85, -2), model, "FuroshikiKnot")
	-- Chopsticks rubber band on top
	AB.block(Vector3.new(1.4, 0.08, 0.15), DARK_WOOD,
		AB.offset(originCF, 0, 0.75, -2), model, "Chopsticks")

	AB.billboard(head, NAME, Vector2.new(220, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
