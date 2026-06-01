-- Big Earl — barrel-chested pitmaster in a sauce-stained apron and red kerchief.
-- Tall, wide torso, smiley round head, white apron with brown sauce splotches.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN     = Color3.fromRGB(225, 180, 140)
local APRON    = Color3.fromRGB(240, 235, 215)
local SHIRT    = Color3.fromRGB(85, 65, 50)
local PANTS    = Color3.fromRGB(55, 40, 30)
local BOOT     = Color3.fromRGB(45, 28, 18)
local KERCHIEF = Color3.fromRGB(160, 40, 40)
local SAUCE    = Color3.fromRGB(110, 30, 25)
local HAIR     = Color3.fromRGB(35, 25, 20)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BigEarl", parent)

	-- Legs
	AB.block(Vector3.new(1.3, 3.5, 1.3), PANTS, AB.offset(originCF, -0.8, 1.75, 0), model, "LegL")
	AB.block(Vector3.new(1.3, 3.5, 1.3), PANTS, AB.offset(originCF,  0.8, 1.75, 0), model, "LegR")
	-- Boots
	AB.block(Vector3.new(1.5, 0.6, 1.6), BOOT, AB.offset(originCF, -0.8, 0.3, 0.1), model, "BootL")
	AB.block(Vector3.new(1.5, 0.6, 1.6), BOOT, AB.offset(originCF,  0.8, 0.3, 0.1), model, "BootR")

	-- Torso (wide, barrel-chested)
	local torso = AB.block(
		Vector3.new(4.5, 4, 2.2), SHIRT,
		AB.offset(originCF, 0, 5.5, 0),
		model, "Torso"
	)

	-- Apron over the front
	AB.block(Vector3.new(3.8, 4.2, 0.3), APRON, AB.offset(originCF, 0, 5.4, 1.15), model, "Apron")
	-- Apron neck loop
	AB.block(Vector3.new(0.3, 1.5, 0.3), APRON, AB.offset(originCF, -1.0, 7.6, 1.0), model, "ApronStrapL")
	AB.block(Vector3.new(0.3, 1.5, 0.3), APRON, AB.offset(originCF,  1.0, 7.6, 1.0), model, "ApronStrapR")

	-- Sauce splotches on the apron
	for i, p in {
		Vector3.new(-0.8, 5.0, 1.3),
		Vector3.new( 0.9, 4.2, 1.3),
		Vector3.new( 0.2, 6.2, 1.3),
	} do
		AB.sphere(0.6, SAUCE, originCF * CFrame.new(p), model, "Sauce_" .. i)
	end

	-- Arms (thick)
	AB.block(Vector3.new(1.5, 4, 1.5), SHIRT, AB.offset(originCF, -3.0, 5.5, 0), model, "ArmL")
	AB.block(Vector3.new(1.5, 4, 1.5), SHIRT, AB.offset(originCF,  3.0, 5.5, 0), model, "ArmR")
	AB.sphere(1.5, SKIN, AB.offset(originCF, -3.0, 3.5, 0), model, "HandL")
	AB.sphere(1.5, SKIN, AB.offset(originCF,  3.0, 3.5, 0), model, "HandR")

	-- Head (big round)
	AB.sphere(2.4, SKIN, AB.offset(originCF, 0, 8.7, 0), model, "Head")
	-- Hair fringe
	AB.block(Vector3.new(2.5, 0.4, 2.4), HAIR, AB.offset(originCF, 0, 9.7, 0), model, "Hair")
	-- Eyes
	AB.sphere(0.25, Color3.new(0, 0, 0), AB.offset(originCF, -0.55, 8.9, 1.1), model, "EyeL")
	AB.sphere(0.25, Color3.new(0, 0, 0), AB.offset(originCF,  0.55, 8.9, 1.1), model, "EyeR")
	-- Mustache (signature pitmaster look)
	AB.block(Vector3.new(1.8, 0.35, 0.3), HAIR, AB.offset(originCF, 0, 8.25, 1.2), model, "Mustache")

	-- Red kerchief around neck
	AB.block(Vector3.new(2.6, 0.6, 2.4), KERCHIEF, AB.offset(originCF, 0, 7.8, 0), model, "Kerchief")

	-- Nametag
	AB.billboard(model:FindFirstChild("Head") or torso, "Big Earl", Vector2.new(220, 40), 2.4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
