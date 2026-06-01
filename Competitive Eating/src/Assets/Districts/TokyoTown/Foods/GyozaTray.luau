-- Gyoza Tray — 4 crescent dumplings on a small black lacquer tray.
-- Dumplings are stylized as half-cylinders (using cylinder + crescent ridge).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TRAY_BLACK   = Color3.fromRGB(35, 30, 35)
local DUMPLING     = Color3.fromRGB(235, 220, 175)
local SEAR_BROWN   = Color3.fromRGB(170, 120, 70)
local DIP_SOY      = Color3.fromRGB(75, 45, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GyozaTray", parent)

	-- Lacquer tray
	local tray = AB.block(
		Vector3.new(5.5, 0.3, 3.6),
		TRAY_BLACK,
		AB.offset(originCF, 0, 0.15, 0),
		model,
		"Tray"
	)

	-- 4 gyoza in a row, slightly rotated for variety
	local offsets = { -1.7, -0.55, 0.6, 1.75 }
	for i, x in offsets do
		local yaw = (i % 2 == 0) and 15 or -10
		local baseCF = AB.offset(originCF, x, 0.55, 0, yaw)

		-- Body (squat half-cylinder approximated by short cylinder lying flat)
		AB.part({
			size  = Vector3.new(0.7, 1.0, 1.4),
			color = DUMPLING,
			cf    = baseCF,
			shape = Enum.PartType.Cylinder,
			name  = "Gyoza_" .. i,
		}, model)

		-- Seared bottom strip (a tan stripe along the base)
		AB.block(
			Vector3.new(1.4, 0.08, 0.6),
			SEAR_BROWN,
			AB.offset(originCF, x, 0.32, 0, yaw),
			model,
			"GyozaSear_" .. i
		)

		-- Pleated ridge across the top
		AB.block(
			Vector3.new(1.2, 0.18, 0.12),
			DUMPLING,
			AB.offset(originCF, x, 1.0, 0, yaw),
			model,
			"GyozaRidge_" .. i
		)
	end

	-- Small soy-dipping dish at the side
	local dish = AB.cylinder(1.4, 0.25, TRAY_BLACK, AB.offset(originCF, 0, 0.42, -1.4), model, "DipDish")
	AB.cylinder(1.1, 0.08, DIP_SOY, AB.offset(originCF, 0, 0.55, -1.4), model, "Soy")

	AB.pivot(model, tray)
	AB.weldAll(model)
	return model
end
