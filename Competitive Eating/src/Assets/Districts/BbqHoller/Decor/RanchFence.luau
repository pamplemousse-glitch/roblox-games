-- Ranch Fence — split-rail wooden fence section. 4 posts + 3 horizontal rails
-- spanning roughly 18 studs.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WOOD      = Color3.fromRGB(140, 100, 60)
local DARK_WOOD = Color3.fromRGB(95, 65, 38)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RanchFence", parent)

	-- 4 posts, 6 studs apart
	for i, x in {-9, -3, 3, 9} do
		AB.block(Vector3.new(0.6, 5, 0.6), DARK_WOOD, AB.offset(originCF, x, 2.5, 0), model, "Post_" .. i)
		-- Post caps (rounded tops)
		AB.sphere(0.8, DARK_WOOD, AB.offset(originCF, x, 5.1, 0), model, "PostCap_" .. i)
	end

	-- 3 rail rows
	for r = 1, 3 do
		local y = 1.3 + (r - 1) * 1.3
		-- Rails between consecutive posts (3 spans)
		for s, sx in {-6, 0, 6} do
			AB.block(Vector3.new(6, 0.35, 0.35), WOOD,
				AB.offset(originCF, sx, y, 0),
				model, "Rail_" .. r .. "_" .. s)
		end
	end

	-- Pivot
	AB.pivot(model, model:FindFirstChild("Post_1"))
	AB.weldAll(model)
	return model
end
