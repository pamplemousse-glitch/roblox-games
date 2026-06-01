-- PastryChef — tall chef in cream uniform with pink piping bag.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN  = Color3.fromRGB(225, 195, 165)
local HAIR  = Color3.fromRGB(50, 30, 25)
local UNIFM = Color3.fromRGB(255, 240, 220)
local PIPE  = Color3.fromRGB(232, 130, 165)
local PANTS = Color3.fromRGB(80, 70, 80)
local SHOE  = Color3.fromRGB(40, 35, 30)
local GOLD  = Color3.fromRGB(212, 168, 82)
local CREAM = Color3.fromRGB(255, 240, 220)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PastryChef", parent)

	-- Legs and shoes
	AB.block(Vector3.new(0.8, 2.6, 0.9), PANTS, AB.offset(originCF, -0.5, 1.3, 0), model, "LegL")
	AB.block(Vector3.new(0.8, 2.6, 0.9), PANTS, AB.offset(originCF, 0.5, 1.3, 0), model, "LegR")
	AB.block(Vector3.new(0.9, 0.3, 1.2), SHOE, AB.offset(originCF, -0.5, 0.15, 0.15), model, "ShoeL")
	AB.block(Vector3.new(0.9, 0.3, 1.2), SHOE, AB.offset(originCF, 0.5, 0.15, 0.15), model, "ShoeR")

	-- Torso
	local torso = AB.block(Vector3.new(2.4, 2.8, 1.2), UNIFM,
		AB.offset(originCF, 0, 4, 0), model, "Torso")
	-- Double-breasted button rows
	for i = 1, 4 do
		AB.sphere(0.2, GOLD, AB.offset(originCF, -0.4, 5 - i * 0.6, 0.65), model, "ButtonL_" .. i)
		AB.sphere(0.2, GOLD, AB.offset(originCF, 0.4, 5 - i * 0.6, 0.65), model, "ButtonR_" .. i)
	end
	-- Chef's neckerchief (pink)
	AB.block(Vector3.new(2, 0.5, 0.4), PIPE, AB.offset(originCF, 0, 5.3, 0.5), model, "Kerchief")

	-- Arms
	AB.block(Vector3.new(0.7, 2.4, 0.7), UNIFM, AB.offset(originCF, -1.55, 4.2, 0), model, "ArmL")
	AB.block(Vector3.new(0.7, 2.4, 0.7), UNIFM, AB.offset(originCF, 1.55, 4.2, 0), model, "ArmR")
	AB.sphere(0.65, SKIN, AB.offset(originCF, -1.55, 2.9, 0), model, "HandL")
	AB.sphere(0.65, SKIN, AB.offset(originCF, 1.55, 2.9, 0.5), model, "HandR")

	-- Head
	AB.sphere(1.7, SKIN, AB.offset(originCF, 0, 6.4, 0), model, "Head")
	AB.block(Vector3.new(0.5, 0.3, 1.5), HAIR, AB.offset(originCF, 0, 7, 0.4), model, "Mustache")

	-- Tall chef hat
	AB.cylinder(1.7, 0.4, UNIFM, AB.offset(originCF, 0, 7.3, 0), model, "HatBand")
	AB.cylinder(2.2, 2.2, UNIFM, AB.offset(originCF, 0, 8.5, 0), model, "HatTall")
	AB.sphere(2.4, UNIFM, AB.offset(originCF, 0, 9.6, 0), model, "HatPuff")

	-- Piping bag in right hand (cream cone with pink filling)
	AB.wedge(Vector3.new(0.6, 1.6, 0.6), CREAM,
		AB.offset(originCF, 1.55, 2.1, 0.5) * CFrame.Angles(math.rad(180), 0, 0), model, "PipingBag")
	AB.sphere(0.5, PIPE, AB.offset(originCF, 1.55, 1.5, 0.7), model, "PipingDollop")

	AB.billboard(torso, "Pastry Chef", nil, 5)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
