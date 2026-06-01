-- SliderCombo — 3 small burgers on a tray. Bite-sized contest fare.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local function buildSlider(model: Model, originCF: CFrame, offX: number, idx: number)
	-- Bottom bun
	AB.cylinder(
		1.8, 0.3,
		AB.colors.bunTan,
		AB.offset(originCF, offX, 0.5, 0),
		model,
		"Slider" .. idx .. "_BottomBun"
	)
	-- Mini patty
	AB.cylinder(
		1.9, 0.22,
		AB.colors.burgerBrown,
		AB.offset(originCF, offX, 0.75, 0),
		model,
		"Slider" .. idx .. "_Patty"
	)
	-- Cheese square
	AB.block(
		Vector3.new(1.6, 0.06, 1.6),
		AB.colors.cheese,
		AB.offset(originCF, offX, 0.88, 0),
		model,
		"Slider" .. idx .. "_Cheese"
	)
	-- Top bun
	AB.sphere(
		1.85,
		AB.colors.bunTan,
		AB.offset(originCF, offX, 1.2, 0),
		model,
		"Slider" .. idx .. "_TopBun"
	)
end

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SliderCombo", parent)

	-- Silver tray (chrome)
	local tray = AB.block(
		Vector3.new(7.5, 0.2, 3.0),
		Color3.fromRGB(176, 176, 176),
		AB.offset(originCF, 0, 0.1, 0),
		model,
		"Tray"
	)
	tray.Material   = Enum.Material.Metal
	tray.Reflectance = 0.25

	-- Tray rim (slightly raised border)
	AB.block(
		Vector3.new(7.5, 0.1, 0.2),
		Color3.fromRGB(140, 140, 140),
		AB.offset(originCF, 0, 0.25, 1.4),
		model,
		"RimFront"
	)
	AB.block(
		Vector3.new(7.5, 0.1, 0.2),
		Color3.fromRGB(140, 140, 140),
		AB.offset(originCF, 0, 0.25, -1.4),
		model,
		"RimBack"
	)

	-- Three sliders
	buildSlider(model, originCF, -2.4, 1)
	buildSlider(model, originCF,  0.0, 2)
	buildSlider(model, originCF,  2.4, 3)

	AB.pivot(model, tray)
	AB.weldAll(model)
	return model
end
