-- RedWhiteCheckeredBanner — a wide cloth banner with a red+white checker pattern.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RedWhiteCheckeredBanner", parent)
	local RED   = Color3.fromRGB(220, 50, 50)
	local WHITE = Color3.fromRGB(245, 245, 240)
	local CHROME = Color3.fromRGB(176, 176, 176)

	-- Pole left + right
	AB.cylinder(0.2, 5, CHROME, AB.offset(originCF, -6, 2.5, 0), model, "PoleL")
	AB.cylinder(0.2, 5, CHROME, AB.offset(originCF,  6, 2.5, 0), model, "PoleR")

	-- Banner backing (12 wide × 3 tall) — solid white
	local backing = AB.block(Vector3.new(12, 3, 0.1), WHITE, AB.offset(originCF, 0, 4, 0), model, "Backing")

	-- Checker squares (4 cols × 3 rows = 12 squares total, alternating)
	for r = 0, 2 do
		for c = 0, 5 do
			-- Alternate
			if (r + c) % 2 == 0 then
				AB.block(Vector3.new(2, 1, 0.2), RED, AB.offset(originCF, -5 + c * 2, 3 + r * 1, 0.05), model, "Sq_" .. r .. "_" .. c)
			end
		end
	end

	-- Top rope
	AB.block(Vector3.new(12.4, 0.1, 0.1), CHROME, AB.offset(originCF, 0, 5.55, 0), model, "TopRope")

	AB.pivot(model, backing)
	AB.weldAll(model)
	return model
end
