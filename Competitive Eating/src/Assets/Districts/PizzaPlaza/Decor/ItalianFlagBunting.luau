-- Italian Flag Bunting — strung triangular flags (green/white/red) draped
-- between two lampposts. Festive street ambience.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local GRN  = Color3.fromRGB(80, 140, 60)
local WHT  = Color3.fromRGB(245, 240, 230)
local RED  = Color3.fromRGB(200, 40, 40)
local WIRE = Color3.fromRGB(80, 50, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ItalianFlagBunting", parent)

	-- Two end posts (wire anchors)
	AB.cylinder(0.3, 4, WIRE, AB.offset(originCF, -8, 2, 0), model, "PostL")
	AB.cylinder(0.3, 4, WIRE, AB.offset(originCF,  8, 2, 0), model, "PostR")

	-- Main wire (gentle catenary curve via 5 segments)
	for s = 1, 5 do
		local t = (s - 0.5) / 5
		local x = -8 + t * 16
		local y = 4 - math.sin(t * math.pi) * 0.8
		AB.cylinder(0.08, 3.4, WIRE,
			AB.offset(originCF, x, y, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)),
			model, "WireSeg_" .. s)
	end

	-- 15 small triangular flags strung in Italian sequence
	for i = 1, 15 do
		local t = (i - 0.5) / 15
		local x = -8 + t * 16
		local y = 4 - math.sin(t * math.pi) * 0.8 - 0.5
		local color = ({GRN, WHT, RED})[((i - 1) % 3) + 1]
		AB.wedge(Vector3.new(0.1, 1, 0.8), color,
			AB.offset(originCF, x, y, 0) * CFrame.Angles(math.rad(180), math.rad(90), 0),
			model, "Flag_" .. i)
	end

	-- Decorative tassels at each post
	for k, sx in {-1, 1} do
		AB.sphere(0.4, RED, AB.offset(originCF, sx * 8, 3.6, 0), model, "Tassel_" .. k)
		for j = 1, 4 do
			AB.cylinder(0.06, 0.7, RED,
				AB.offset(originCF, sx * 8 + (j - 2.5) * 0.1, 3.1, 0), model, "TasselStrand_" .. k .. "_" .. j)
		end
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
