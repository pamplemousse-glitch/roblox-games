-- BurgerJoint — small fast-food building, golden + red.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local GOLDEN    = Color3.fromRGB(245, 195, 70)
local NEON_RED  = Color3.fromRGB(255, 48, 48)
local CREAM     = Color3.fromRGB(255, 245, 232)
local BRICK_RED = Color3.fromRGB(150, 60, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BurgerJoint", parent)

	-- Foundation
	local foundation = AB.block(
		Vector3.new(24, 0.5, 20),
		Color3.fromRGB(110, 110, 110),
		AB.offset(originCF, 0, 0.25, 0),
		model,
		"Foundation"
	)

	-- Lower walls (red brick)
	AB.block(Vector3.new(24, 6, 1),  BRICK_RED, AB.offset(originCF, 0, 3.5, -9.5),  model, "BackLower")
	AB.block(Vector3.new(1,  6, 20), BRICK_RED, AB.offset(originCF, -11.5, 3.5, 0), model, "LeftLower")
	AB.block(Vector3.new(1,  6, 20), BRICK_RED, AB.offset(originCF,  11.5, 3.5, 0), model, "RightLower")

	-- Front wall (with doorway gap)
	AB.block(Vector3.new(8, 6, 1), BRICK_RED, AB.offset(originCF, -8, 3.5, 9.5), model, "FrontLeft")
	AB.block(Vector3.new(8, 6, 1), BRICK_RED, AB.offset(originCF,  8, 3.5, 9.5), model, "FrontRight")
	AB.block(Vector3.new(8, 2, 1), BRICK_RED, AB.offset(originCF,  0, 5.5, 9.5), model, "FrontHeader")

	-- Upper walls (cream)
	AB.block(Vector3.new(24, 4, 1),  CREAM, AB.offset(originCF, 0, 8.5, -9.5),  model, "BackUpper")
	AB.block(Vector3.new(1,  4, 20), CREAM, AB.offset(originCF, -11.5, 8.5, 0), model, "LeftUpper")
	AB.block(Vector3.new(1,  4, 20), CREAM, AB.offset(originCF,  11.5, 8.5, 0), model, "RightUpper")
	AB.block(Vector3.new(24, 4, 1),  CREAM, AB.offset(originCF, 0, 8.5,  9.5),  model, "FrontUpper")

	-- Sloped roof (single peaked block, simplified)
	local roof = AB.block(
		Vector3.new(26, 1, 22),
		BRICK_RED,
		AB.offset(originCF, 0, 11, 0),
		model,
		"Roof"
	)
	roof.Material = Enum.Material.Slate

	-- Giant golden burger sign (a stylized burger icon as a sphere stack on top)
	AB.cylinder(6, 1.0, AB.colors.bunTan,     AB.offset(originCF, 0, 13.5, 0), model, "SignBunBottom")
	AB.cylinder(6, 0.6, AB.colors.burgerBrown, AB.offset(originCF, 0, 14.3, 0), model, "SignPatty")
	AB.cylinder(6, 0.2, AB.colors.cheese,      AB.offset(originCF, 0, 14.7, 0), model, "SignCheese")
	local signTop = AB.sphere(6, AB.colors.bunTan, AB.offset(originCF, 0, 15.6, 0), model, "SignBunTop")
	signTop.Material = Enum.Material.SmoothPlastic

	-- "OPEN" neon sign (small, glowing)
	local openSign = AB.block(
		Vector3.new(5, 1.5, 0.4),
		NEON_RED,
		AB.offset(originCF, 0, 7.5, 10.0),
		model,
		"OpenSign"
	)
	AB.neon(openSign)
	AB.glow(openSign, openSign.Color, 2.0)

	-- Yellow awning over the doorway
	AB.block(
		Vector3.new(8, 0.5, 3),
		GOLDEN,
		AB.offset(originCF, 0, 6.5, 11.0),
		model,
		"Awning"
	)

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
