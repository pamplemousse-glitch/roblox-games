-- Sugar Silo Tower — tall cylindrical silo painted white with a "SUGAR" label
-- and a conveyor-belt nozzle dispensing sugar into a pile at its base.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WHITE  = Color3.fromRGB(248, 245, 240)
local METAL  = Color3.fromRGB(180, 180, 185)
local DARK   = Color3.fromRGB(70, 70, 75)
local SUGAR  = Color3.fromRGB(255, 250, 245)
local ACCENT = Color3.fromRGB(212, 168, 82)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SugarSiloTower", parent)

	-- Concrete pad
	AB.block(Vector3.new(20, 0.6, 20), METAL,
		AB.offset(originCF, 0, 0.3, 0), model, "Pad")

	-- Main silo body — tall cylinder
	AB.cylinder(12, 32, WHITE,
		AB.offset(originCF, 0, 16, 0), model, "SiloBody")

	-- Metal rings around the silo
	for i = 1, 4 do
		AB.cylinder(12.4, 0.4, METAL,
			AB.offset(originCF, 0, 6 + i * 6, 0), model, "Ring_" .. i)
	end

	-- Conical cap
	AB.cylinder(12, 1, METAL,
		AB.offset(originCF, 0, 32.5, 0), model, "Cap")
	AB.cylinder(8, 1, METAL,
		AB.offset(originCF, 0, 33.5, 0), model, "Cap2")
	AB.cylinder(4, 1, METAL,
		AB.offset(originCF, 0, 34.3, 0), model, "Cap3")

	-- Ladder up the front
	for i = 0, 14 do
		AB.block(Vector3.new(1.6, 0.2, 0.2), DARK,
			AB.offset(originCF, 0, 2 + i * 2, 6.2), model, "LadderRung_" .. i)
	end
	for _, x in {-0.6, 0.6} do
		AB.block(Vector3.new(0.2, 30, 0.2), DARK,
			AB.offset(originCF, x, 17, 6.2), model, "LadderRail_" .. ((x > 0) and "R" or "L"))
	end

	-- "SUGAR" label — big dark block backing on the front
	local sign = AB.block(Vector3.new(9, 4, 0.4), DARK,
		AB.offset(originCF, 0, 22, 6.1), model, "SugarSignBack")
	AB.glow(sign, ACCENT, 1.5)
	-- Light letters strip across it
	AB.block(Vector3.new(8, 2.6, 0.5), ACCENT,
		AB.offset(originCF, 0, 22, 6.05), model, "SugarSignFace")

	-- Output nozzle at the base
	AB.cylinder(2, 4, METAL,
		AB.offset(originCF, 0, 2, 7), model, "Nozzle")

	-- Sugar pile below the nozzle
	AB.sphere(5, SUGAR, AB.offset(originCF, 0, 0.8, 9), model, "Pile1")
	AB.sphere(3, SUGAR, AB.offset(originCF, 1.5, 1.0, 11), model, "Pile2")
	AB.sphere(3, SUGAR, AB.offset(originCF, -1.5, 0.9, 10.5), model, "Pile3")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
