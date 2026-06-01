-- PennantTriangleFlags — string of multicolored triangle pennants (8 of them).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PennantTriangleFlags", parent)
	local CABLE = Color3.fromRGB(40, 40, 40)
	local colors = {
		Color3.fromRGB(220, 50, 50),
		Color3.fromRGB(245, 195, 70),
		Color3.fromRGB(127, 202, 194),
		Color3.fromRGB(255, 200, 215),
		Color3.fromRGB(80, 160, 100),
		Color3.fromRGB(220, 50, 50),
		Color3.fromRGB(245, 195, 70),
		Color3.fromRGB(127, 202, 194),
	}

	-- String
	AB.cylinder(0.15, 16, CABLE, AB.offset(originCF, 0, 0, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "String")

	-- 8 triangle pennants hanging
	for i = 0, 7 do
		local x = -7 + i * 2
		local color = colors[i + 1]
		AB.wedge(Vector3.new(0.2, 2, 1.5), color, AB.offset(originCF, x, -1, 0) * CFrame.Angles(0, math.rad(90), math.rad(180)), model, "Pennant_" .. i)
	end

	AB.pivot(model, model:FindFirstChild("String"))
	AB.weldAll(model)
	return model
end
