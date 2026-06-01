-- WeddingPhotoCouple — bride in cream dress and groom in brown tuxedo
-- standing close together, ready for a photo. Mounted on a single base.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN_B  = Color3.fromRGB(248, 218, 198)
local SKIN_G  = Color3.fromRGB(230, 195, 170)
local HAIR_B  = Color3.fromRGB(220, 200, 160)
local HAIR_G  = Color3.fromRGB(60, 40, 30)
local DRESS   = Color3.fromRGB(255, 240, 220)
local TUX     = Color3.fromRGB(60, 45, 35)
local TUX_TIE = Color3.fromRGB(255, 200, 214)
local PINK    = Color3.fromRGB(255, 200, 214)
local DEEP    = Color3.fromRGB(232, 130, 165)
local MINT    = Color3.fromRGB(180, 230, 200)
local SHOE    = Color3.fromRGB(40, 35, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WeddingPhotoCouple", parent)

	-- ===== BRIDE (left, -1.5 x) =====
	local bx = -1.5
	-- Dress cone (full skirt)
	AB.wedge(Vector3.new(3.4, 4, 3.4), DRESS,
		AB.offset(originCF, bx, 2, 0), model, "BrideSkirtA")
	AB.wedge(Vector3.new(3.4, 4, 3.4), DRESS,
		AB.offset(originCF, bx, 2, 0) * CFrame.Angles(0, math.rad(180), 0), model, "BrideSkirtB")
	-- Lace ruffles
	AB.cylinder(3.6, 0.3, DRESS, AB.offset(originCF, bx, 0.3, 0), model, "BrideRuffle1")
	AB.cylinder(2.8, 0.3, DRESS, AB.offset(originCF, bx, 0.9, 0), model, "BrideRuffle2")
	-- Bodice
	local brideTorso = AB.block(Vector3.new(1.8, 2, 1), DRESS,
		AB.offset(originCF, bx, 5, 0), model, "BrideTorso")
	-- Pearl belt
	AB.block(Vector3.new(1.85, 0.3, 1.05), PINK,
		AB.offset(originCF, bx, 4, 0), model, "BrideBelt")
	-- Arms (one holding bouquet)
	AB.block(Vector3.new(0.5, 2, 0.5), DRESS, AB.offset(originCF, bx - 1.1, 5.1, 0), model, "BrideArmL")
	AB.block(Vector3.new(0.5, 2, 0.5), DRESS,
		AB.offset(originCF, bx + 1.1, 4.8, 0.6) * CFrame.Angles(math.rad(-20), 0, 0), model, "BrideArmR")
	AB.sphere(0.45, SKIN_B, AB.offset(originCF, bx - 1.1, 3.9, 0), model, "BrideHandL")
	AB.sphere(0.45, SKIN_B, AB.offset(originCF, bx + 1.1, 4, 1.2), model, "BrideHandR")
	-- Head
	AB.sphere(1.4, SKIN_B, AB.offset(originCF, bx, 7, 0), model, "BrideHead")
	-- Hair (updo)
	AB.sphere(1.5, HAIR_B, AB.offset(originCF, bx, 7.5, -0.3), model, "BrideHair")
	AB.sphere(0.8, HAIR_B, AB.offset(originCF, bx, 8.2, -0.4), model, "BrideHairBun")
	-- Veil (cream cloth behind)
	AB.block(Vector3.new(2.4, 4, 0.2), DRESS, AB.offset(originCF, bx, 6, -0.5), model, "BrideVeil")
	-- Tiara
	AB.cylinder(1.4, 0.2, PINK, AB.offset(originCF, bx, 7.8, 0), model, "BrideTiara")
	-- Bouquet held in right hand
	AB.cylinder(0.8, 0.3, MINT, AB.offset(originCF, bx + 1.1, 4.6, 1.4), model, "BouquetStems")
	AB.sphere(0.7, PINK, AB.offset(originCF, bx + 0.9, 5, 1.5), model, "BouquetA")
	AB.sphere(0.7, DEEP, AB.offset(originCF, bx + 1.3, 5, 1.5), model, "BouquetB")
	AB.sphere(0.7, PINK, AB.offset(originCF, bx + 1.1, 5.4, 1.4), model, "BouquetC")
	AB.sphere(0.7, DEEP, AB.offset(originCF, bx + 1.1, 5.2, 1.8), model, "BouquetD")

	-- ===== GROOM (right, +1.5 x) =====
	local gx = 1.5
	-- Legs
	AB.block(Vector3.new(0.8, 2.6, 0.9), TUX, AB.offset(originCF, gx - 0.5, 1.3, 0), model, "GroomLegL")
	AB.block(Vector3.new(0.8, 2.6, 0.9), TUX, AB.offset(originCF, gx + 0.5, 1.3, 0), model, "GroomLegR")
	-- Shoes
	AB.block(Vector3.new(0.9, 0.3, 1.2), SHOE, AB.offset(originCF, gx - 0.5, 0.15, 0.15), model, "GroomShoeL")
	AB.block(Vector3.new(0.9, 0.3, 1.2), SHOE, AB.offset(originCF, gx + 0.5, 0.15, 0.15), model, "GroomShoeR")
	-- Torso (tux jacket)
	local groomTorso = AB.block(Vector3.new(2.2, 2.8, 1.2), TUX,
		AB.offset(originCF, gx, 4, 0), model, "GroomTorso")
	-- White shirt strip
	AB.block(Vector3.new(0.7, 2.6, 0.1), DRESS,
		AB.offset(originCF, gx, 4, 0.65), model, "GroomShirt")
	-- Pink bowtie
	AB.sphere(0.5, TUX_TIE, AB.offset(originCF, gx - 0.4, 5.1, 0.7), model, "GroomTieL")
	AB.sphere(0.5, TUX_TIE, AB.offset(originCF, gx + 0.4, 5.1, 0.7), model, "GroomTieR")
	AB.block(Vector3.new(0.3, 0.3, 0.2), TUX_TIE,
		AB.offset(originCF, gx, 5.1, 0.7), model, "GroomTieKnot")
	-- Lapels (wedges)
	AB.wedge(Vector3.new(0.4, 1.6, 0.6), TUX,
		AB.offset(originCF, gx - 0.6, 4.5, 0.65), model, "GroomLapelL")
	AB.wedge(Vector3.new(0.4, 1.6, 0.6), TUX,
		AB.offset(originCF, gx + 0.6, 4.5, 0.65) * CFrame.Angles(0, math.rad(180), 0), model, "GroomLapelR")
	-- Lapel pink flower
	AB.sphere(0.3, DEEP, AB.offset(originCF, gx - 0.6, 4.8, 0.75), model, "GroomLapelFlower")

	-- Arms — left arm around bride
	AB.block(Vector3.new(0.6, 2.4, 0.6), TUX,
		AB.offset(originCF, gx - 1.4, 4.2, 0) * CFrame.Angles(0, 0, math.rad(-20)), model, "GroomArmL")
	AB.block(Vector3.new(0.6, 2.4, 0.6), TUX, AB.offset(originCF, gx + 1.4, 4.2, 0), model, "GroomArmR")
	AB.sphere(0.55, SKIN_G, AB.offset(originCF, gx - 2.2, 3, 0), model, "GroomHandL")
	AB.sphere(0.55, SKIN_G, AB.offset(originCF, gx + 1.4, 2.9, 0), model, "GroomHandR")

	-- Head
	AB.sphere(1.5, SKIN_G, AB.offset(originCF, gx, 6.5, 0), model, "GroomHead")
	-- Hair
	AB.block(Vector3.new(1.6, 0.5, 1.4), HAIR_G, AB.offset(originCF, gx, 7.1, 0), model, "GroomHair")

	-- Couple base (decorative aisle runner)
	AB.block(Vector3.new(8, 0.2, 4), DRESS,
		AB.offset(originCF, 0, 0.1, 0), model, "Aisle")
	-- Petals scattered
	for i = 1, 10 do
		local rx = (math.random() - 0.5) * 7
		local rz = (math.random() - 0.5) * 3.5
		local col = (i % 2 == 0) and DEEP or PINK
		AB.block(Vector3.new(0.4, 0.05, 0.4), col,
			AB.offset(originCF, rx, 0.25, rz, math.random(0, 180)), model, "Petal_" .. i)
	end

	AB.billboard(brideTorso, "Wedding Couple", Vector2.new(220, 36), 6)
	AB.pivot(model, groomTorso)
	AB.weldAll(model)
	return model
end
