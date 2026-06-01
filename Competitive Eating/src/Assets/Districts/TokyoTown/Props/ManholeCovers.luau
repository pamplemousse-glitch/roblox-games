-- Manhole Covers — a cluster of 3 ornate round manhole covers set into the
-- pavement (slightly raised disc + radial pattern via thin block spokes).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local DARK_METAL  = Color3.fromRGB(55, 55, 65)
local IRON_BLACK  = Color3.fromRGB(45, 40, 40)
local METAL_GREY  = Color3.fromRGB(110, 110, 120)
local STONE       = Color3.fromRGB(120, 115, 105)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ManholeCovers", parent)

	-- Underlying pavement patch (so it reads as a real ground feature)
	AB.block(Vector3.new(14, 0.2, 6), STONE,
		AB.offset(originCF, 0, 0.1, 0), model, "Pavement")

	for i, cx in {-5, 0, 5} do
		-- Outer ring (slightly raised flat disc)
		AB.cylinder(3.4, 0.3, DARK_METAL,
			AB.offset(originCF, cx, 0.3, 0), model, "MH_" .. i .. "_Outer")
		-- Inner disc
		AB.cylinder(3.0, 0.32, IRON_BLACK,
			AB.offset(originCF, cx, 0.31, 0), model, "MH_" .. i .. "_Inner")
		-- Center bolt
		AB.cylinder(0.5, 0.35, METAL_GREY,
			AB.offset(originCF, cx, 0.33, 0), model, "MH_" .. i .. "_Bolt")
		-- 8 radial spokes (thin blocks)
		for s = 0, 7 do
			local angle = s * (math.pi / 4)
			local sx = math.cos(angle) * 1.3
			local sz = math.sin(angle) * 1.3
			AB.block(Vector3.new(2.4, 0.05, 0.18), METAL_GREY,
				AB.offset(originCF, cx + sx, 0.34, sz) * CFrame.Angles(0, -angle, 0),
				model, "MH_" .. i .. "_Spoke_" .. s)
		end
		-- 6 outer-ring rivets
		for s = 0, 5 do
			local angle = s * (math.pi / 3)
			local sx = math.cos(angle) * 1.55
			local sz = math.sin(angle) * 1.55
			AB.cylinder(0.18, 0.1, METAL_GREY,
				AB.offset(originCF, cx + sx, 0.36, sz), model, "MH_" .. i .. "_Rivet_" .. s)
		end
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
