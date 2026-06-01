-- Churro — sugared fried dough stick with vertical ridges along its length.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local FRIED  = Color3.fromRGB(220, 165, 95)
local SUGAR  = Color3.fromRGB(255, 240, 200)
local RIDGE  = Color3.fromRGB(190, 130, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Churro", parent)

	-- Core: a horizontal cylinder lying on its side
	local core = AB.part({
		size  = Vector3.new(6, 1.2, 1.2),
		color = FRIED,
		cf    = AB.offset(originCF, 0, 1.0, 0),
		shape = Enum.PartType.Cylinder,
		name  = "Core",
	}, model)

	-- Vertical ridges: 6 thin slats around the cylinder length-wise
	local ridgeCount = 6
	for i = 1, ridgeCount do
		local angle = (i / ridgeCount) * math.pi * 2
		local y     = math.cos(angle) * 0.55
		local z     = math.sin(angle) * 0.55
		AB.block(
			Vector3.new(5.6, 0.12, 0.25),
			RIDGE,
			AB.offset(originCF, 0, 1.0 + y, z) * CFrame.Angles(math.rad(-math.deg(angle)), 0, 0),
			model,
			"Ridge_" .. i
		)
	end

	-- Sugar dusting: small light specks scattered along the top
	for i = 1, 10 do
		local x = -2.5 + (i - 1) * (5 / 9)
		AB.block(
			Vector3.new(0.3, 0.1, 0.3),
			SUGAR,
			AB.offset(originCF, x, 1.65, ((i % 2) - 0.5) * 0.6),
			model,
			"Sugar_" .. i
		)
	end

	AB.pivot(model, core)
	AB.weldAll(model)
	return model
end
