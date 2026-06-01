-- Cheese Wheel Display — 4 stacked giant cheese wheels (parmesan, pecorino,
-- gorgonzola, provolone) on a wooden round, with a knife and tag.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WD       = Color3.fromRGB(110, 75, 45)
local PARMESAN = Color3.fromRGB(235, 215, 155)
local PECOR    = Color3.fromRGB(245, 230, 175)
local GORG     = Color3.fromRGB(220, 215, 180)
local GORG_BL  = Color3.fromRGB(80, 100, 130)
local PROV     = Color3.fromRGB(220, 200, 130)
local RIND     = Color3.fromRGB(180, 140, 80)
local STEEL    = Color3.fromRGB(200, 200, 210)
local DK_WD    = Color3.fromRGB(80, 50, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CheeseWheelDisplay", parent)

	-- Wooden round base
	AB.cylinder(5, 0.5, WD, AB.offset(originCF, 0, 0.25, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Round")
	-- Wood grain rings
	AB.cylinder(4.6, 0.05, DK_WD, AB.offset(originCF, 0, 0.55, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "GrainRing1")
	AB.cylinder(3, 0.05, DK_WD, AB.offset(originCF, 0, 0.56, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "GrainRing2")

	-- Wheel 1: Parmesan (largest, bottom)
	AB.cylinder(4, 1.5, PARMESAN, AB.offset(originCF, 0, 1.25, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Parmesan")
	AB.cylinder(4.1, 1.6, RIND, AB.offset(originCF, 0, 1.25, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "ParmesanRind")

	-- Wheel 2: Pecorino
	AB.cylinder(3.4, 1.2, PECOR, AB.offset(originCF, 0, 2.6, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Pecorino")
	AB.cylinder(3.5, 1.3, RIND, AB.offset(originCF, 0, 2.6, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "PecorinoRind")

	-- Wheel 3: Gorgonzola (with blue veins)
	AB.cylinder(2.8, 1.1, GORG, AB.offset(originCF, 0, 3.75, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Gorgonzola")
	AB.cylinder(2.9, 1.2, RIND, AB.offset(originCF, 0, 3.75, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "GorgRind")
	-- Blue veins (small dots)
	for i = 1, 8 do
		AB.sphere(0.18, GORG_BL,
			AB.offset(originCF, math.cos(i * 0.78) * 1.2, 3.75 + math.sin(i) * 0.3, math.sin(i * 0.78) * 1.2), model, "Vein_" .. i)
	end

	-- Wheel 4: Provolone (top, smallest)
	AB.cylinder(2.2, 0.9, PROV, AB.offset(originCF, 0, 4.75, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Provolone")
	AB.cylinder(2.3, 1, RIND, AB.offset(originCF, 0, 4.75, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "ProvRind")

	-- Cheese knife stuck in top wheel
	AB.block(Vector3.new(0.15, 0.4, 2), STEEL,
		AB.offset(originCF, 0, 5.3, 0.5) * CFrame.Angles(math.rad(-30), 0, 0), model, "KnifeBlade")
	AB.block(Vector3.new(0.3, 0.4, 1), DK_WD,
		AB.offset(originCF, 0, 5.7, 1.5) * CFrame.Angles(math.rad(-30), 0, 0), model, "KnifeHandle")
	-- Knife rivets
	AB.sphere(0.08, STEEL,
		AB.offset(originCF, 0.18, 5.55, 1.4) * CFrame.Angles(math.rad(-30), 0, 0), model, "KnifeRivet")

	-- "FORMAGGIO" tag on a stake
	AB.block(Vector3.new(0.1, 1, 0.1), DK_WD, AB.offset(originCF, 3, 1, 1.5), model, "TagStake")
	AB.block(Vector3.new(1.6, 0.8, 0.1), Color3.fromRGB(245, 230, 200), AB.offset(originCF, 3, 1.5, 1.5), model, "Tag")
	AB.block(Vector3.new(1, 0.2, 0.05), Color3.fromRGB(110, 30, 40), AB.offset(originCF, 3, 1.5, 1.55), model, "TagTxt")

	-- Wedge cut out of parmesan (small wedge piece on the side)
	AB.wedge(Vector3.new(1, 1.5, 1.5), PARMESAN,
		AB.offset(originCF, 4, 1.25, 0) * CFrame.Angles(0, math.rad(90), 0), model, "WedgePiece")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
