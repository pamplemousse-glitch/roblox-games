-- TEMPLATE — copy this when writing a new asset module.
--
-- CONTRACT: every asset module exports exactly this function signature.
--   (parent: Instance, originCF: CFrame) -> Model
--
-- - `parent`   is where the Model gets parented (usually Workspace.Districts)
-- - `originCF` is the world-space CFrame at which to place the Model's origin
--
-- Use Common.AssetBuilder helpers. Keep modules under 150 lines. If you need
-- more geometry, split into multiple modules and register each in AssetManifest.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ASSET_NAME_HERE", parent)

	-- Example: a 4-stud-wide red cube on a 8-stud-wide yellow base
	local base = AB.block(
		Vector3.new(8, 1, 8),
		Color3.fromRGB(220, 175, 50),
		AB.offset(originCF, 0, 0.5, 0),
		model,
		"Base"
	)

	local cube = AB.block(
		Vector3.new(4, 4, 4),
		Color3.fromRGB(200, 50, 50),
		AB.offset(originCF, 0, 3, 0),
		model,
		"Cube"
	)

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
