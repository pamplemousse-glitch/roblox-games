-- FairyGodmother — sparkly pastel-pink dress, mint cape, glowing wand,
-- floats slightly above the ground (slight elevation).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN   = Color3.fromRGB(250, 220, 200)
local HAIR   = Color3.fromRGB(220, 220, 230)
local DRESS  = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CAPE   = Color3.fromRGB(180, 230, 200)
local CREAM  = Color3.fromRGB(255, 240, 220)
local GOLD   = Color3.fromRGB(212, 168, 82)
local NEONPK = Color3.fromRGB(255, 110, 170)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("FairyGodmother", parent)

	-- Slight float — start a bit off the ground
	local baseY = 0.5

	-- Dress (cone bottom)
	AB.wedge(Vector3.new(3.4, 4, 3.4), DRESS,
		AB.offset(originCF, 0, baseY + 2, 0), model, "DressA")
	AB.wedge(Vector3.new(3.4, 4, 3.4), DRESS,
		AB.offset(originCF, 0, baseY + 2, 0) * CFrame.Angles(0, math.rad(180), 0), model, "DressB")
	-- Dress ruffle layers
	AB.cylinder(3.6, 0.5, DEEP, AB.offset(originCF, 0, baseY + 0.3, 0), model, "DressRuffle1")
	AB.cylinder(2.8, 0.5, CREAM, AB.offset(originCF, 0, baseY + 0.9, 0), model, "DressRuffle2")
	AB.cylinder(2.4, 0.4, GOLD, AB.offset(originCF, 0, baseY + 1.4, 0), model, "DressTrim")

	-- Bodice
	local torso = AB.block(Vector3.new(2.2, 2.4, 1.2), DEEP,
		AB.offset(originCF, 0, baseY + 5.2, 0), model, "Torso")
	-- Bow on chest
	AB.sphere(0.7, CREAM, AB.offset(originCF, -0.5, baseY + 5.8, 0.65), model, "BowL")
	AB.sphere(0.7, CREAM, AB.offset(originCF, 0.5, baseY + 5.8, 0.65), model, "BowR")

	-- Cape
	AB.block(Vector3.new(2.8, 4, 0.3), CAPE,
		AB.offset(originCF, 0, baseY + 4, -0.8), model, "Cape")
	-- Cape collar (high)
	AB.block(Vector3.new(1.4, 1.2, 0.5), CAPE,
		AB.offset(originCF, 0, baseY + 6.6, -0.4), model, "CapeCollar")

	-- Arms
	AB.block(Vector3.new(0.6, 2.2, 0.6), DEEP, AB.offset(originCF, -1.4, baseY + 5.4, 0), model, "ArmL")
	AB.block(Vector3.new(0.6, 2.2, 0.6), DEEP, AB.offset(originCF, 1.4, baseY + 5.4, 0), model, "ArmR")
	AB.sphere(0.55, SKIN, AB.offset(originCF, -1.4, baseY + 4.1, 0), model, "HandL")
	AB.sphere(0.55, SKIN, AB.offset(originCF, 1.6, baseY + 4.5, 0.8), model, "HandR")

	-- Head
	AB.sphere(1.5, SKIN, AB.offset(originCF, 0, baseY + 7.3, 0), model, "Head")
	-- White-silver hair bun
	AB.sphere(1.7, HAIR, AB.offset(originCF, 0, baseY + 7.9, -0.4), model, "Hair")
	AB.sphere(1, HAIR, AB.offset(originCF, 0, baseY + 8.7, -0.5), model, "HairBun")

	-- Tiara
	AB.cylinder(1.6, 0.3, GOLD, AB.offset(originCF, 0, baseY + 8.2, 0), model, "TiaraBand")
	AB.sphere(0.4, NEONPK, AB.offset(originCF, 0, baseY + 8.6, 0.5), model, "TiaraGem")

	-- Wand
	AB.cylinder(0.2, 4, CREAM, AB.offset(originCF, 1.6, baseY + 6.5, 0.8), model, "Wand")
	-- Star tip (4 small wedges arranged)
	local star = AB.sphere(0.6, NEONPK, AB.offset(originCF, 1.6, baseY + 8.3, 0.8), model, "WandStar")
	AB.neon(star)
	AB.glow(star, NEONPK, 3)
	for i, ang in {0, 90, 45, 135} do
		AB.block(Vector3.new(1, 0.3, 0.3), NEONPK,
			AB.offset(originCF, 1.6, baseY + 8.3, 0.8) * CFrame.Angles(0, 0, math.rad(ang)),
			model, "WandRay_" .. i)
	end

	-- Glow trail (small dots near her)
	for i = 1, 5 do
		local d = AB.sphere(0.2, NEONPK,
			AB.offset(originCF, math.cos(i) * 1.5, baseY + 1 + i * 0.6, math.sin(i) * 1.5),
			model, "Sparkle_" .. i)
		AB.neon(d)
		AB.glow(d, NEONPK, 1)
	end

	AB.billboard(torso, "Fairy Godmother", nil, 6)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
