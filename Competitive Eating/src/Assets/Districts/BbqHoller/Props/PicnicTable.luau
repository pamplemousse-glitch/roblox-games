-- Picnic Table — classic A-frame redwood picnic table with attached benches.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PLANK     = Color3.fromRGB(140, 90, 55)
local DARK_WOOD = Color3.fromRGB(85, 55, 35)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PicnicTable", parent)

	-- Table top (3 planks)
	for i, z in {-1, 0, 1} do
		AB.block(Vector3.new(8, 0.3, 1.1), (i % 2 == 0) and PLANK or DARK_WOOD, AB.offset(originCF, 0, 3.1, z * 1.2), model, "TopPlank_" .. i)
	end
	-- Top cross-supports (under the planks)
	AB.block(Vector3.new(0.4, 0.4, 3.8), DARK_WOOD, AB.offset(originCF, -3, 2.85, 0), model, "TopBraceL")
	AB.block(Vector3.new(0.4, 0.4, 3.8), DARK_WOOD, AB.offset(originCF,  3, 2.85, 0), model, "TopBraceR")

	-- A-frame legs (4 angled legs)
	for i, p in {{-3, 0,  2.5, 1}, {3, 0,  2.5, 1}, {-3, 0, -2.5, -1}, {3, 0, -2.5, -1}} do
		local leg = AB.block(Vector3.new(0.5, 3.6, 0.5), DARK_WOOD, AB.offset(originCF, p[1], 1.8, p[3]), model, "Leg_" .. i)
		leg.CFrame = leg.CFrame * CFrame.Angles(math.rad(p[4] * 12), 0, 0)
	end

	-- Benches (2, attached, one on each side)
	for side, z in {1, -1} do
		AB.block(Vector3.new(8, 0.3, 1.4), PLANK, AB.offset(originCF, 0, 1.6, z * 2.8), model, "Bench_" .. side)
		-- Bench supports under
		AB.block(Vector3.new(0.4, 0.4, 1.4), DARK_WOOD, AB.offset(originCF, -3, 1.45, z * 2.8), model, "BenchSupL_" .. side)
		AB.block(Vector3.new(0.4, 0.4, 1.4), DARK_WOOD, AB.offset(originCF,  3, 1.45, z * 2.8), model, "BenchSupR_" .. side)
	end

	-- Use the table top as pivot
	AB.pivot(model, model:FindFirstChild("TopPlank_2"))
	AB.weldAll(model)
	return model
end
