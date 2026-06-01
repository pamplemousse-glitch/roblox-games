-- Candle Holder Row — wrought-iron candelabra with 5 lit candles glowing.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local IRON   = Color3.fromRGB(35, 35, 40)
local BRASS  = Color3.fromRGB(200, 160, 80)
local WAX    = Color3.fromRGB(245, 240, 220)
local FLAME  = Color3.fromRGB(255, 180, 80)
local WICK   = Color3.fromRGB(40, 30, 25)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("CandleHolderRow", parent)

	-- Base (round iron platter)
	AB.cylinder(2.4, 0.3, IRON, AB.offset(originCF, 0, 0.15, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Base")
	-- Center pillar
	AB.cylinder(0.5, 4, IRON, AB.offset(originCF, 0, 2, 0), model, "Pillar")
	-- Brass ring on pillar
	AB.cylinder(0.7, 0.2, BRASS, AB.offset(originCF, 0, 2, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "PillarRing")
	-- Top platter
	AB.cylinder(2, 0.2, IRON, AB.offset(originCF, 0, 4.1, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "TopPlatter")

	-- 5 candle holders (4 in circle + 1 center)
	local positions = {{0, 0}, {1.2, 0}, {-1.2, 0}, {0, 1.2}, {0, -1.2}}
	for i, pos in positions do
		local x, z = pos[1], pos[2]
		-- Holder cup
		AB.cylinder(0.4, 0.4, BRASS, AB.offset(originCF, x, 4.4, z) * CFrame.Angles(0, 0, math.rad(90)), model, "Cup_" .. i)
		-- Candle (white wax)
		AB.cylinder(0.3, 2 + (i % 2) * 0.5, WAX, AB.offset(originCF, x, 5.5 + (i % 2) * 0.25, z), model, "Candle_" .. i)
		-- Drips down the sides
		AB.cylinder(0.05, 0.5, WAX, AB.offset(originCF, x + 0.25, 5.2, z), model, "Drip1_" .. i)
		AB.cylinder(0.05, 0.7, WAX, AB.offset(originCF, x - 0.2, 5.0, z), model, "Drip2_" .. i)
		-- Wick
		AB.block(Vector3.new(0.04, 0.3, 0.04), WICK,
			AB.offset(originCF, x, 6.5 + (i % 2) * 0.5, z), model, "Wick_" .. i)
		-- Flame (glowing teardrop)
		local f = AB.sphere(0.35, FLAME, AB.offset(originCF, x, 6.8 + (i % 2) * 0.5, z), model, "Flame_" .. i)
		AB.neon(f)
		AB.glow(f, f.Color, 2)
		-- Inner blue flame
		AB.sphere(0.15, Color3.fromRGB(100, 180, 255),
			AB.offset(originCF, x, 6.6 + (i % 2) * 0.5, z), model, "FlameCore_" .. i)
	end

	-- Decorative scroll arms (4 reaching out from pillar)
	for i = 0, 3 do
		local angle = i / 4 * 2 * math.pi
		AB.cylinder(0.15, 1.5, IRON,
			AB.offset(originCF, math.cos(angle) * 0.6, 3, math.sin(angle) * 0.6) * CFrame.Angles(0, -angle, math.rad(90)),
			model, "Arm_" .. i)
	end

	-- Drip tray scattered wax pools
	for i = 1, 4 do
		AB.cylinder(0.4, 0.05, WAX,
			AB.offset(originCF, math.cos(i) * 1.5, 4.25, math.sin(i) * 1.5) * CFrame.Angles(0, 0, math.rad(90)), model, "WaxPool_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
