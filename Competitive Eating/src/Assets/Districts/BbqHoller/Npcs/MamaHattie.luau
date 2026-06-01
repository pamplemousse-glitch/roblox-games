-- Mama Hattie — matriarch of the holler, headscarf and gingham dress.
-- Wide gingham/checkered apron, hair tied up in a scarf, kind smile.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN     = Color3.fromRGB(165, 110, 75)
local DRESS    = Color3.fromRGB(140, 35, 35)
local CHECK    = Color3.fromRGB(245, 240, 225)
local APRON    = Color3.fromRGB(232, 200, 112)
local SCARF    = Color3.fromRGB(160, 40, 40)
local SHOE     = Color3.fromRGB(50, 32, 22)
local HAIR     = Color3.fromRGB(40, 30, 25)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MamaHattie", parent)

	-- Long dress (no separate legs — single wide skirt block)
	AB.block(Vector3.new(3.6, 4.2, 2.4), DRESS, AB.offset(originCF, 0, 2.1, 0), model, "Skirt")
	-- Gingham checker accents (a few light squares scattered on the skirt)
	for i, p in {
		Vector3.new(-1.0, 2.0, 1.25),
		Vector3.new( 1.0, 3.2, 1.25),
		Vector3.new(-1.0, 3.6, 1.25),
		Vector3.new( 0.0, 1.4, 1.25),
	} do
		AB.block(Vector3.new(0.7, 0.7, 0.05), CHECK, originCF * CFrame.new(p), model, "Check_" .. i)
	end
	-- Shoes peeking from the bottom
	AB.block(Vector3.new(1.0, 0.5, 1.4), SHOE, AB.offset(originCF, -0.8, 0.25, 0), model, "ShoeL")
	AB.block(Vector3.new(1.0, 0.5, 1.4), SHOE, AB.offset(originCF,  0.8, 0.25, 0), model, "ShoeR")

	-- Torso (slightly narrower)
	local torso = AB.block(
		Vector3.new(3.6, 3, 2.0), DRESS,
		AB.offset(originCF, 0, 5.7, 0),
		model, "Torso"
	)

	-- Yellow straw-colored apron over the front
	AB.block(Vector3.new(3.0, 3.5, 0.3), APRON, AB.offset(originCF, 0, 5.4, 1.05), model, "Apron")
	-- Apron straps over shoulders
	AB.block(Vector3.new(0.3, 1.2, 0.3), APRON, AB.offset(originCF, -0.9, 7.4, 0.9), model, "ApronStrapL")
	AB.block(Vector3.new(0.3, 1.2, 0.3), APRON, AB.offset(originCF,  0.9, 7.4, 0.9), model, "ApronStrapR")

	-- Arms (a little softer / no shirt — same dress)
	AB.block(Vector3.new(1.2, 3.2, 1.2), DRESS, AB.offset(originCF, -2.4, 5.5, 0), model, "ArmL")
	AB.block(Vector3.new(1.2, 3.2, 1.2), DRESS, AB.offset(originCF,  2.4, 5.5, 0), model, "ArmR")
	AB.sphere(1.3, SKIN, AB.offset(originCF, -2.4, 3.6, 0), model, "HandL")
	AB.sphere(1.3, SKIN, AB.offset(originCF,  2.4, 3.6, 0), model, "HandR")

	-- Head
	AB.sphere(2.2, SKIN, AB.offset(originCF, 0, 8.3, 0), model, "Head")
	-- Hair bun peeking out
	AB.sphere(1.4, HAIR, AB.offset(originCF, 0, 9.7, -0.6), model, "Bun")
	-- Red headscarf
	AB.block(Vector3.new(2.6, 1.0, 2.6), SCARF, AB.offset(originCF, 0, 9.4, 0), model, "Scarf")
	-- Eyes
	AB.sphere(0.22, Color3.new(0, 0, 0), AB.offset(originCF, -0.5, 8.45, 1.0), model, "EyeL")
	AB.sphere(0.22, Color3.new(0, 0, 0), AB.offset(originCF,  0.5, 8.45, 1.0), model, "EyeR")
	-- Warm smile (a curved-ish red bar)
	AB.block(Vector3.new(1.0, 0.2, 0.2), Color3.fromRGB(160, 60, 60), AB.offset(originCF, 0, 7.9, 1.1), model, "Smile")

	-- Wooden spoon in right hand
	AB.block(Vector3.new(0.3, 2.2, 0.3), Color3.fromRGB(180, 130, 70), AB.offset(originCF, 2.4, 2.5, 0.8), model, "SpoonHandle")
	AB.sphere(0.9, Color3.fromRGB(180, 130, 70), AB.offset(originCF, 2.4, 1.4, 0.8), model, "SpoonBowl")

	AB.billboard(model:FindFirstChild("Head") or torso, "Mama Hattie", Vector2.new(240, 40), 2.4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
