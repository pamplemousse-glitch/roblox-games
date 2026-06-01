-- Ribs — a rack of 5 connected ribs, brown meat with red glaze.
-- Each rib = cylinder body + glaze block on top. Connected by a thin bone strip.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SMOKED_WOOD = Color3.fromRGB(107, 68, 35)
local RIB_MEAT    = Color3.fromRGB(135, 55, 30)
local GLAZE       = Color3.fromRGB(180, 35, 30)
local BONE        = Color3.fromRGB(240, 230, 200)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Ribs", parent)

	-- Cutting board base
	local board = AB.block(
		Vector3.new(7, 0.4, 5.5),
		SMOKED_WOOD,
		AB.offset(originCF, 0, 0.2, 0),
		model,
		"Board"
	)

	-- Connective bone strip running along the back of the rack
	AB.block(
		Vector3.new(5.5, 0.45, 0.8),
		BONE,
		AB.offset(originCF, 0, 0.75, -1.8),
		model,
		"BoneStrip"
	)

	-- 5 ribs running parallel along the X axis
	for i = 1, 5 do
		local x = -2.4 + (i - 1) * 1.2

		-- Rib body — a horizontal cylinder
		AB.part({
			size  = Vector3.new(0.9, 5.0, 0.9),
			color = RIB_MEAT,
			cf    = AB.offset(originCF, x, 1.0, 0) * CFrame.Angles(math.rad(90), 0, 0),
			shape = Enum.PartType.Cylinder,
			name  = "Rib_" .. i,
		}, model)

		-- Glaze blob — slight red sheen on top of each rib
		AB.part({
			size  = Vector3.new(0.85, 0.18, 4.8),
			color = GLAZE,
			cf    = AB.offset(originCF, x, 1.45, 0),
			name  = "Glaze_" .. i,
		}, model)

		-- Bone tip poking out at one end
		AB.part({
			size  = Vector3.new(0.4, 0.4, 0.4),
			color = BONE,
			cf    = AB.offset(originCF, x, 1.0, 2.7),
			shape = Enum.PartType.Ball,
			name  = "BoneTip_" .. i,
		}, model)
	end

	AB.pivot(model, board)
	AB.weldAll(model)
	return model
end
