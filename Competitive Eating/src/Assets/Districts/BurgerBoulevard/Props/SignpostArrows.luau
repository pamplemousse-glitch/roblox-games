-- SignpostArrows — wooden signpost with 4 arrow-shaped directional signs in different
-- colors, pointing in different directions.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SignpostArrows", parent)
	local WOOD   = Color3.fromRGB(110, 70, 50)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local TEAL   = Color3.fromRGB(127, 202, 194)
	local RED    = Color3.fromRGB(255, 48, 48)
	local CREAM  = Color3.fromRGB(255, 245, 232)
	local YELLOW = Color3.fromRGB(245, 195, 70)

	-- Pole base
	AB.block(Vector3.new(1.5, 0.6, 1.5), CHROME, AB.offset(originCF, 0, 0.3, 0), model, "PoleBase")
	-- Pole
	local pole = AB.cylinder(0.5, 10, WOOD, AB.offset(originCF, 0, 5.3, 0), model, "Pole")
	pole.Material = Enum.Material.WoodPlanks

	-- 4 arrow signs at different heights pointing different directions
	local function arrow(y: number, yawDeg: number, color: Color3, label: string, name: string)
		local cf = AB.offset(originCF, 0, y, 0, yawDeg)
		-- Main rectangle
		AB.block(Vector3.new(4, 0.8, 0.2), color, cf * CFrame.new(2, 0, 0), model, name .. "_Body")
		-- Arrow point (wedge)
		AB.wedge(Vector3.new(1, 0.8, 0.2), color, cf * CFrame.new(4, 0, 0) * CFrame.Angles(0, math.rad(90), 0), model, name .. "_Tip")
		-- Trim
		AB.block(Vector3.new(4, 0.1, 0.3), CHROME, cf * CFrame.new(2, 0.4, 0), model, name .. "_TrimT")
		AB.block(Vector3.new(4, 0.1, 0.3), CHROME, cf * CFrame.new(2, -0.4, 0), model, name .. "_TrimB")
		-- Label
		local plate = AB.block(Vector3.new(0.1, 0.6, 0.1), color, cf * CFrame.new(2, 0, 0.15), model, name .. "_Label")
		plate.Transparency = 1
		AB.billboard(plate, label, Vector2.new(150, 30), 0)
	end

	arrow(8.5, 0,   TEAL,   "DINER", "Arrow1")
	arrow(7,   90,  RED,    "DRIVE-IN", "Arrow2")
	arrow(5.5, 180, YELLOW, "GAS",   "Arrow3")
	arrow(4,   270, CREAM,  "MOTEL", "Arrow4")

	-- Finial
	AB.sphere(0.6, CHROME, AB.offset(originCF, 0, 10.6, 0), model, "Finial")

	AB.pivot(model, pole)
	AB.weldAll(model)
	return model
end
