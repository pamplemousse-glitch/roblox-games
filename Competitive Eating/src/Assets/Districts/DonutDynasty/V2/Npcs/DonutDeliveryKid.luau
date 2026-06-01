-- DonutDeliveryKid — young delivery worker carrying a stack of pink
-- donut boxes. Mint-blue cap, cream uniform, brown shorts.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN  = Color3.fromRGB(232, 195, 168)
local HAIR  = Color3.fromRGB(140, 80, 40)
local SHIRT = Color3.fromRGB(255, 240, 220)
local SHORTS= Color3.fromRGB(92, 57, 36)
local CAP   = Color3.fromRGB(180, 230, 200)
local SHOE  = Color3.fromRGB(60, 50, 45)
local BOX   = Color3.fromRGB(255, 200, 214)
local DEEP  = Color3.fromRGB(232, 130, 165)
local GOLD  = Color3.fromRGB(212, 168, 82)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DonutDeliveryKid", parent)

	-- Shorter character — shorter legs
	AB.block(Vector3.new(0.7, 1.6, 0.8), SHORTS, AB.offset(originCF, -0.4, 0.8, 0), model, "LegL")
	AB.block(Vector3.new(0.7, 1.6, 0.8), SHORTS, AB.offset(originCF, 0.4, 0.8, 0), model, "LegR")
	-- Sock + shoe
	AB.block(Vector3.new(0.8, 0.7, 0.9), SHIRT, AB.offset(originCF, -0.4, 0.35, 0.1), model, "SockL")
	AB.block(Vector3.new(0.8, 0.7, 0.9), SHIRT, AB.offset(originCF, 0.4, 0.35, 0.1), model, "SockR")
	AB.block(Vector3.new(0.85, 0.3, 1.1), SHOE, AB.offset(originCF, -0.4, 0.15, 0.2), model, "ShoeL")
	AB.block(Vector3.new(0.85, 0.3, 1.1), SHOE, AB.offset(originCF, 0.4, 0.15, 0.2), model, "ShoeR")

	-- Torso (smaller)
	local torso = AB.block(Vector3.new(2, 2.2, 1), SHIRT,
		AB.offset(originCF, 0, 2.8, 0), model, "Torso")
	AB.block(Vector3.new(2.05, 0.4, 1.05), DEEP,
		AB.offset(originCF, 0, 1.8, 0), model, "Belt")

	-- Arms (forward, holding boxes)
	AB.block(Vector3.new(0.55, 2.2, 0.55), SHIRT,
		AB.offset(originCF, -1.3, 2.9, 0.6) * CFrame.Angles(math.rad(-30), 0, 0), model, "ArmL")
	AB.block(Vector3.new(0.55, 2.2, 0.55), SHIRT,
		AB.offset(originCF, 1.3, 2.9, 0.6) * CFrame.Angles(math.rad(-30), 0, 0), model, "ArmR")
	AB.sphere(0.5, SKIN, AB.offset(originCF, -1.3, 2.1, 1.3), model, "HandL")
	AB.sphere(0.5, SKIN, AB.offset(originCF, 1.3, 2.1, 1.3), model, "HandR")

	-- Head
	AB.sphere(1.4, SKIN, AB.offset(originCF, 0, 4.7, 0), model, "Head")
	-- Hair tuft
	AB.block(Vector3.new(1.4, 0.3, 1.2), HAIR, AB.offset(originCF, 0, 5.4, 0), model, "Hair")

	-- Mint cap (peaked baseball-style)
	AB.cylinder(1.6, 0.6, CAP, AB.offset(originCF, 0, 5.6, 0), model, "CapCrown")
	AB.block(Vector3.new(1.6, 0.2, 1.6), CAP, AB.offset(originCF, 0, 5.4, 0.6), model, "CapPeak")
	-- Logo on cap (pink donut)
	AB.cylinder(0.6, 0.1, BOX, AB.offset(originCF, 0, 5.7, 1.1), model, "CapLogo")

	-- Stack of 3 pink donut boxes in arms
	for i = 1, 3 do
		AB.block(Vector3.new(2.4, 0.5, 2.4), BOX,
			AB.offset(originCF, 0, 1.6 + (i - 1) * 0.55, 1.7), model, "Box_" .. i)
		AB.block(Vector3.new(2.4, 0.1, 0.4), DEEP,
			AB.offset(originCF, 0, 1.85 + (i - 1) * 0.55, 1.7), model, "BoxRibbon_" .. i)
		-- Tiny gold logo on each box
		AB.sphere(0.2, GOLD, AB.offset(originCF, 0.7, 1.9 + (i - 1) * 0.55, 1.7), model, "BoxLogo_" .. i)
	end
	-- Top box has the lid slightly open showing donut
	AB.cylinder(0.7, 0.3, BOX, AB.offset(originCF, 0, 2.7, 1.7), model, "PeekDonut")

	AB.billboard(torso, "Delivery Kid", nil, 4.5)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
