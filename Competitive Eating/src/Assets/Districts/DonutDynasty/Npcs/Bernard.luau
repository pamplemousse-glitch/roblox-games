-- Bernard — French boulanger NPC, white double-breasted chef coat, tall
-- toque, holding a freshly piped éclair.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN   = Color3.fromRGB(235, 200, 170)
local HAIR   = Color3.fromRGB(50,  35,  25)
local UNIFM  = Color3.fromRGB(255, 250, 245)
local PANTS  = Color3.fromRGB(70,  70,  80)
local SHOE   = Color3.fromRGB(35,  30,  25)
local BUTTON = Color3.fromRGB(180, 180, 185)
local CHOCO  = Color3.fromRGB(92,  57,  36)
local CREAM  = Color3.fromRGB(255, 240, 220)
local DOUGH  = Color3.fromRGB(225, 185, 130)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Bernard", parent)

	-- Legs
	AB.block(Vector3.new(0.9, 2.5, 1.0), PANTS,
		AB.offset(originCF, -0.55, 1.25, 0), model, "LegL")
	AB.block(Vector3.new(0.9, 2.5, 1.0), PANTS,
		AB.offset(originCF,  0.55, 1.25, 0), model, "LegR")
	AB.block(Vector3.new(1.0, 0.3, 1.3), SHOE,
		AB.offset(originCF, -0.55, 0.15, 0.15), model, "ShoeL")
	AB.block(Vector3.new(1.0, 0.3, 1.3), SHOE,
		AB.offset(originCF,  0.55, 0.15, 0.15), model, "ShoeR")

	-- Torso — chef coat (slightly bulkier than Marie)
	local torso = AB.block(Vector3.new(2.8, 2.8, 1.4), UNIFM,
		AB.offset(originCF, 0, 3.9, 0), model, "Torso")

	-- Double-breasted buttons (two columns)
	for i = 1, 4 do
		local y = 5.0 - (i - 1) * 0.55
		AB.sphere(0.18, BUTTON, AB.offset(originCF, -0.4, y, 0.75), model, "ButtonL_" .. i)
		AB.sphere(0.18, BUTTON, AB.offset(originCF,  0.4, y, 0.75), model, "ButtonR_" .. i)
	end

	-- Arms
	AB.block(Vector3.new(0.8, 2.3, 0.8), UNIFM,
		AB.offset(originCF, -1.8, 4.0, 0), model, "ArmL")
	AB.block(Vector3.new(0.8, 2.3, 0.8), UNIFM,
		AB.offset(originCF,  1.8, 4.0, 0.4), model, "ArmR")
	AB.sphere(0.7, SKIN, AB.offset(originCF, -1.8, 2.75, 0), model, "HandL")
	AB.sphere(0.7, SKIN, AB.offset(originCF,  1.8, 2.75, 0.8), model, "HandR")

	-- Head + hair (close-cropped) + mustache
	AB.sphere(1.7, SKIN, AB.offset(originCF, 0, 6.2, 0), model, "Head")
	AB.block(Vector3.new(1.8, 0.4, 1.7), HAIR,
		AB.offset(originCF, 0, 6.9, 0), model, "Hair")
	AB.block(Vector3.new(1.0, 0.2, 0.2), HAIR,
		AB.offset(originCF, 0, 5.85, 0.85), model, "Mustache")

	-- Tall toque (chef hat)
	AB.cylinder(1.9, 0.4, UNIFM,
		AB.offset(originCF, 0, 7.3, 0), model, "ToqueBand")
	AB.cylinder(1.7, 1.4, UNIFM,
		AB.offset(originCF, 0, 8.3, 0), model, "ToqueShaft")
	AB.sphere(2.2, UNIFM, AB.offset(originCF, 0, 9.4, 0), model, "ToquePuff")

	-- Éclair in right hand
	AB.part({
		size  = Vector3.new(1.8, 0.5, 0.5),
		color = DOUGH,
		cf    = AB.offset(originCF, 1.8, 2.2, 0.8) * CFrame.Angles(0, 0, math.rad(15)),
		shape = Enum.PartType.Cylinder,
		name  = "EclairBody",
	}, model)
	AB.block(Vector3.new(1.6, 0.15, 0.45), CHOCO,
		AB.offset(originCF, 1.8, 2.45, 0.8), model, "EclairTop")
	AB.block(Vector3.new(1.5, 0.1, 0.15), CREAM,
		AB.offset(originCF, 1.8, 2.2, 1.0), model, "EclairCream")

	AB.billboard(torso, "Bernard", nil, 5)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
