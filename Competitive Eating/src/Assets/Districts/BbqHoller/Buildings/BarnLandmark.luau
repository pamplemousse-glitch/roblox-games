-- Barn Landmark — classic red barn with white trim and a hayloft door up top.
-- Gambrel-style roof (two-pitched), hayloft on the front gable, big barn doors.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BARN_RED = Color3.fromRGB(160, 40, 40)
local TRIM     = Color3.fromRGB(245, 240, 230)
local DARK_RED = Color3.fromRGB(110, 25, 25)
local DARK_WOOD = Color3.fromRGB(70, 45, 22)
local STRAW    = Color3.fromRGB(232, 200, 112)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BarnLandmark", parent)

	-- Foundation (stone-look)
	local foundation = AB.block(
		Vector3.new(34, 1, 26),
		Color3.fromRGB(140, 130, 115),
		AB.offset(originCF, 0, 0.5, 0),
		model, "Foundation"
	)

	-- Main barn body — back, left, right
	AB.block(Vector3.new(34, 16, 1), BARN_RED, AB.offset(originCF, 0, 9, -12.5), model, "BackWall")
	AB.block(Vector3.new(1, 16, 26), BARN_RED, AB.offset(originCF, -16.5, 9, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 16, 26), BARN_RED, AB.offset(originCF,  16.5, 9, 0), model, "RightWall")

	-- Front gable wall (a tall trapezoid via stacked blocks)
	AB.block(Vector3.new(12, 16, 1), BARN_RED, AB.offset(originCF, -11, 9, 12.5), model, "FrontLeft")
	AB.block(Vector3.new(12, 16, 1), BARN_RED, AB.offset(originCF,  11, 9, 12.5), model, "FrontRight")
	AB.block(Vector3.new(10, 5, 1),  BARN_RED, AB.offset(originCF, 0, 14.5, 12.5), model, "FrontHeader")
	-- Gable triangle (use 2 wedges for the peak)
	AB.wedge(Vector3.new(1, 6, 17),  BARN_RED, AB.offset(originCF, -8.5, 20, 12.5) * CFrame.Angles(math.rad(90), math.rad(90), 0), model, "GableL")
	AB.wedge(Vector3.new(1, 6, 17),  BARN_RED, AB.offset(originCF,  8.5, 20, 12.5) * CFrame.Angles(math.rad(90), math.rad(-90), 0), model, "GableR")

	-- White trim — corner boards and door surround
	AB.block(Vector3.new(0.6, 17, 0.6), TRIM, AB.offset(originCF, -16.5, 9.5,  12.5), model, "CornerTrimFL")
	AB.block(Vector3.new(0.6, 17, 0.6), TRIM, AB.offset(originCF,  16.5, 9.5,  12.5), model, "CornerTrimFR")
	AB.block(Vector3.new(0.6, 17, 0.6), TRIM, AB.offset(originCF, -16.5, 9.5, -12.5), model, "CornerTrimBL")
	AB.block(Vector3.new(0.6, 17, 0.6), TRIM, AB.offset(originCF,  16.5, 9.5, -12.5), model, "CornerTrimBR")

	-- Big barn doors — two leaves with X-cross pattern
	for i, x in {[1] = -2.5, [2] = 2.5} do
		AB.block(Vector3.new(5, 12, 0.4), DARK_RED, AB.offset(originCF, x, 7.0, 13.0), model, "BarnDoor_" .. i)
		-- X-cross trim
		AB.block(
			Vector3.new(5.6, 0.4, 0.5), TRIM,
			AB.offset(originCF, x, 7.0, 13.1) * CFrame.Angles(0, 0, math.rad(50)),
			model, "DoorX1_" .. i
		)
		AB.block(
			Vector3.new(5.6, 0.4, 0.5), TRIM,
			AB.offset(originCF, x, 7.0, 13.1) * CFrame.Angles(0, 0, math.rad(-50)),
			model, "DoorX2_" .. i
		)
	end

	-- Hayloft door (small white-trimmed opening above the main doors)
	AB.block(Vector3.new(4, 4, 0.4), DARK_WOOD, AB.offset(originCF, 0, 18, 13.0), model, "HayloftDoor")
	AB.block(Vector3.new(4.5, 0.3, 0.5), TRIM, AB.offset(originCF, 0, 20.0, 13.05), model, "HayloftTop")
	AB.block(Vector3.new(4.5, 0.3, 0.5), TRIM, AB.offset(originCF, 0, 16.0, 13.05), model, "HayloftBot")
	-- Hay sticking out of the loft
	AB.block(Vector3.new(2.5, 0.6, 1.5), STRAW, AB.offset(originCF, 0, 18, 13.5), model, "HayPoke")

	-- Roof — gambrel: 4 sloped wedges (2 upper + 2 lower per side, but we'll
	-- simplify to 2 big wedges meeting at the ridge for silhouette).
	AB.wedge(Vector3.new(36, 7, 14), BARN_RED, AB.offset(originCF, 0, 20.5,  7) * CFrame.Angles(0, math.rad(180), 0), model, "RoofFront")
	AB.wedge(Vector3.new(36, 7, 14), BARN_RED, AB.offset(originCF, 0, 20.5, -7), model, "RoofBack")
	-- Ridge cap
	AB.block(Vector3.new(36, 0.5, 1.2), DARK_RED, AB.offset(originCF, 0, 24.2, 0), model, "RidgeCap")

	-- Weathervane on top
	AB.block(Vector3.new(0.3, 3, 0.3), DARK_WOOD, AB.offset(originCF, 0, 26, 0), model, "VaneRod")
	AB.block(Vector3.new(3, 0.4, 0.3), DARK_WOOD, AB.offset(originCF, 0, 27.5, 0), model, "VaneArrow")

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
