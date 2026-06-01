-- Espresso Cup Stack — short tower of stacked white espresso cups + saucers.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CUP    = Color3.fromRGB(245, 235, 220)
local SAUCER = Color3.fromRGB(240, 230, 215)
local SHADOW = Color3.fromRGB(180, 170, 155)
local HANDLE = Color3.fromRGB(245, 235, 220)
local BRASS  = Color3.fromRGB(200, 160, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("EspressoCupStack", parent)

	-- Stack 8 cups + saucers
	for i = 1, 8 do
		local y = (i - 0.5) * 0.6
		-- Saucer
		AB.cylinder(1.6, 0.1, SAUCER,
			AB.offset(originCF, 0, y, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Saucer_" .. i)
		-- Cup
		AB.cylinder(1, 0.4, CUP,
			AB.offset(originCF, 0, y + 0.3, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Cup_" .. i)
		-- Cup handle (small bump)
		AB.sphere(0.25, HANDLE, AB.offset(originCF, 0.6, y + 0.3, 0), model, "Handle_" .. i)
		-- Saucer shadow rim
		AB.cylinder(1.5, 0.02, SHADOW,
			AB.offset(originCF, 0, y + 0.06, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "SaucerShadow_" .. i)
	end

	-- A finished cup on top with crema
	AB.cylinder(0.85, 0.2, Color3.fromRGB(60, 35, 20),
		AB.offset(originCF, 0, 5.1, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "CremaTop")
	-- Brass spoon resting on saucer
	AB.cylinder(0.1, 0.04, BRASS, AB.offset(originCF, 0.8, 4.9, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "SpoonHead")
	AB.block(Vector3.new(0.08, 0.03, 0.8), BRASS, AB.offset(originCF, 1.2, 4.85, 0), model, "SpoonHandle")
	-- Sugar cube
	AB.block(Vector3.new(0.3, 0.3, 0.3), Color3.fromRGB(245, 240, 220), AB.offset(originCF, -0.5, 5, 0), model, "SugarCube")

	-- Base towel
	AB.block(Vector3.new(2.4, 0.1, 1.8), Color3.fromRGB(180, 90, 90), AB.offset(originCF, 0, 0.05, 0), model, "Towel")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
