-- VinylRecordsHung — a cluster of vinyl records hanging on a wall by strings.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("VinylRecordsHung", parent)
	local BLACK  = Color3.fromRGB(35, 35, 40)
	local LABEL_R = Color3.fromRGB(220, 50, 50)
	local LABEL_T = Color3.fromRGB(127, 202, 194)
	local LABEL_Y = Color3.fromRGB(245, 195, 70)
	local LABEL_P = Color3.fromRGB(255, 200, 215)
	local CABLE  = Color3.fromRGB(30, 30, 30)

	-- Hidden anchor (for pivoting); we have no physical backing
	local anchor = AB.block(Vector3.new(0.2, 0.2, 0.2), BLACK, AB.offset(originCF, 0, 0, 0), model, "Anchor")
	anchor.Transparency = 1

	-- 5 records arranged in a loose cluster
	local placements = {
		{x = -2, y = 0,   z = 0, color = LABEL_R, len = 2},
		{x = -1, y = -2, z = 0, color = LABEL_T, len = 4},
		{x = 0,  y = 0.5, z = 0, color = LABEL_Y, len = 2.5},
		{x = 1,  y = -1.5, z = 0, color = LABEL_P, len = 3.5},
		{x = 2,  y = 1,   z = 0, color = LABEL_R, len = 2},
	}
	for i, p in placements do
		-- String above
		AB.block(Vector3.new(0.05, p.len, 0.05), CABLE, AB.offset(originCF, p.x, p.y + 1.5 + p.len / 2, p.z), model, "String_" .. i)
		-- Vinyl disc (cylinder on its face)
		AB.cylinder(2, 0.15, BLACK, AB.offset(originCF, p.x, p.y, p.z) * CFrame.Angles(0, math.rad(90), 0), model, "Disc_" .. i)
		-- Label
		AB.cylinder(0.7, 0.2, p.color, AB.offset(originCF, p.x, p.y, p.z + 0.05) * CFrame.Angles(0, math.rad(90), 0), model, "Label_" .. i)
		-- Center hole
		AB.cylinder(0.1, 0.25, CABLE, AB.offset(originCF, p.x, p.y, p.z) * CFrame.Angles(0, math.rad(90), 0), model, "Hole_" .. i)
	end

	AB.pivot(model, anchor)
	AB.weldAll(model)
	return model
end
