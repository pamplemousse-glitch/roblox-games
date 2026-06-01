-- JukeboxDancer — poodle skirt, ponytail, mid-twirl pose.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN    = Color3.fromRGB(245, 215, 185)
local SKIRT   = Color3.fromRGB(255, 200, 215)
local SWEATER = Color3.fromRGB(245, 245, 240)
local SOCK    = Color3.fromRGB(245, 245, 240)
local SHOE_B  = Color3.fromRGB(70, 50, 35)
local HAIR_AU = Color3.fromRGB(160, 80, 50)
local DARK    = Color3.fromRGB(30, 30, 35)
local PINK    = Color3.fromRGB(255, 130, 180)
local TEAL    = Color3.fromRGB(127, 202, 194)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("JukeboxDancer", parent)

	-- Saddle shoes (white + brown)
	AB.block(Vector3.new(0.7, 0.4, 1), SWEATER, AB.offset(originCF, -0.35, 0.2, 0.15) * CFrame.Angles(0, math.rad(15), 0), model, "ShoeL")
	AB.block(Vector3.new(0.4, 0.42, 0.5), SHOE_B, AB.offset(originCF, -0.35, 0.2, 0.15) * CFrame.Angles(0, math.rad(15), 0), model, "ShoeLSaddle")
	AB.block(Vector3.new(0.7, 0.4, 1), SWEATER, AB.offset(originCF,  0.45, 0.2, 0.25) * CFrame.Angles(0, math.rad(-15), 0), model, "ShoeR")
	AB.block(Vector3.new(0.4, 0.42, 0.5), SHOE_B, AB.offset(originCF, 0.45, 0.2, 0.25) * CFrame.Angles(0, math.rad(-15), 0), model, "ShoeRSaddle")
	-- White ankle socks (visible above shoes)
	AB.cylinder(0.7, 0.4, SOCK, AB.offset(originCF, -0.35, 0.6, 0.15), model, "SockL")
	AB.cylinder(0.7, 0.4, SOCK, AB.offset(originCF,  0.45, 0.6, 0.25), model, "SockR")
	-- Legs (skin)
	AB.block(Vector3.new(0.55, 1.8, 0.55), SKIN, AB.offset(originCF, -0.35, 1.7, 0), model, "LegL")
	AB.block(Vector3.new(0.55, 1.8, 0.55), SKIN, AB.offset(originCF,  0.45, 1.7, 0), model, "LegR")

	-- Skirt (flaring out — wider at bottom)
	AB.cylinder(3, 1.5, SKIRT, AB.offset(originCF, 0, 3.5, 0), model, "SkirtBot")
	AB.cylinder(2, 1, SKIRT, AB.offset(originCF, 0, 4.5, 0), model, "SkirtTop")
	-- Poodle applique (a small white poof on the skirt)
	AB.sphere(0.6, SWEATER, AB.offset(originCF, 0.4, 3.2, 1.5), model, "PoodleBody")
	AB.sphere(0.3, SWEATER, AB.offset(originCF, 0.8, 3.4, 1.5), model, "PoodleHead")
	-- Poodle ears + tail
	AB.sphere(0.15, SWEATER, AB.offset(originCF, 0.9, 3.6, 1.4), model, "PoodleEar")
	AB.sphere(0.2, SWEATER, AB.offset(originCF, 0.0, 3.3, 1.5), model, "PoodleTail")
	-- Leash (pink line connecting collar to skirt waist)
	AB.block(Vector3.new(0.05, 0.5, 0.05), PINK, AB.offset(originCF, 0.5, 3.9, 1.4) * CFrame.Angles(0, 0, math.rad(45)), model, "PoodleLeash")

	-- Torso (sweater)
	local torso = AB.block(Vector3.new(1.7, 2, 0.9), SWEATER, AB.offset(originCF, 0, 5.6, 0), model, "Torso")
	-- Letter "C" (varsity sweater)
	local letter = AB.block(Vector3.new(0.6, 0.6, 0.1), TEAL, AB.offset(originCF, 0, 5.8, 0.5), model, "VarsityC")
	AB.billboard(letter, "C", Vector2.new(40, 40), 0)
	-- Neckline (pink trim)
	AB.block(Vector3.new(1.4, 0.15, 0.95), PINK, AB.offset(originCF, 0, 6.5, 0), model, "NeckTrim")
	-- Cuffs (pink trim on sleeves)
	AB.block(Vector3.new(0.6, 0.15, 0.6), PINK, AB.offset(originCF, -1.15, 4.7, 0), model, "CuffL")
	AB.block(Vector3.new(0.6, 0.15, 0.6), PINK, AB.offset(originCF,  1.15, 4.7, 0), model, "CuffR")

	-- Arms (mid-twirl: one up, one out)
	AB.block(Vector3.new(0.55, 1.8, 0.55), SWEATER, AB.offset(originCF, -1.4, 6, 0) * CFrame.Angles(0, 0, math.rad(35)), model, "ArmL")
	AB.block(Vector3.new(0.55, 1.8, 0.55), SWEATER, AB.offset(originCF,  1.4, 5.4, 0) * CFrame.Angles(0, 0, math.rad(-50)), model, "ArmR")
	AB.sphere(0.5, SKIN, AB.offset(originCF, -1.9, 6.9, 0), model, "HandL")
	AB.sphere(0.5, SKIN, AB.offset(originCF, 2.2, 4.7, 0), model, "HandR")

	-- Head
	AB.sphere(1.3, SKIN, AB.offset(originCF, 0, 7.4, 0), model, "Head")
	-- Auburn ponytail (long sphere stack flying behind)
	AB.sphere(0.6, HAIR_AU, AB.offset(originCF, 0, 8, -0.5), model, "PonytailHi")
	AB.sphere(0.7, HAIR_AU, AB.offset(originCF, -0.2, 7.3, -1.4), model, "Ponytail1")
	AB.sphere(0.6, HAIR_AU, AB.offset(originCF, -0.4, 6.6, -2), model, "Ponytail2")
	AB.sphere(0.5, HAIR_AU, AB.offset(originCF, -0.5, 6.0, -2.6), model, "Ponytail3")
	-- Ponytail ribbon (pink)
	AB.block(Vector3.new(0.6, 0.3, 0.6), PINK, AB.offset(originCF, 0, 8.1, -0.5), model, "Ribbon")
	-- Hair on top
	AB.block(Vector3.new(1.4, 0.5, 0.3), HAIR_AU, AB.offset(originCF, 0, 8, 0.4), model, "HairFront")

	-- Eyes
	AB.sphere(0.15, DARK, AB.offset(originCF, -0.3, 7.5, 0.6), model, "EyeL")
	AB.sphere(0.15, DARK, AB.offset(originCF,  0.3, 7.5, 0.6), model, "EyeR")
	-- Smile
	AB.block(Vector3.new(0.5, 0.1, 0.08), PINK, AB.offset(originCF, 0, 7.0, 0.65), model, "Smile")

	AB.billboard(torso, "JukeboxDancer", Vector2.new(220, 36), 4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
