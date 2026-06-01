-- Cookie — diner waitress NPC. Teal uniform, pink hair, notepad.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN     = Color3.fromRGB(240, 205, 175)
local UNIFORM  = Color3.fromRGB(127, 202, 194)
local APRON    = Color3.fromRGB(255, 245, 232)
local PINK     = Color3.fromRGB(240, 130, 170)
local SHOE     = Color3.fromRGB(40, 40, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Cookie", parent)

	-- Legs (tights — slightly lighter)
	AB.block(Vector3.new(0.6, 2.4, 0.6), Color3.fromRGB(230, 195, 165), AB.offset(originCF, -0.35, 1.2, 0), model, "LegL")
	AB.block(Vector3.new(0.6, 2.4, 0.6), Color3.fromRGB(230, 195, 165), AB.offset(originCF,  0.35, 1.2, 0), model, "LegR")

	-- Shoes
	AB.block(Vector3.new(0.75, 0.35, 1.0), SHOE, AB.offset(originCF, -0.35, 0.18, 0.2), model, "ShoeL")
	AB.block(Vector3.new(0.75, 0.35, 1.0), SHOE, AB.offset(originCF,  0.35, 0.18, 0.2), model, "ShoeR")

	-- Skirt (a wider block flaring out)
	AB.block(Vector3.new(2.2, 1.2, 1.4), UNIFORM, AB.offset(originCF, 0, 2.6, 0), model, "Skirt")

	-- Torso (uniform top)
	local torso = AB.block(
		Vector3.new(1.9, 2.0, 1.1),
		UNIFORM,
		AB.offset(originCF, 0, 4.0, 0),
		model,
		"Torso"
	)

	-- White apron over the front
	AB.block(
		Vector3.new(1.6, 2.5, 0.1),
		APRON,
		AB.offset(originCF, 0, 3.3, 0.6),
		model,
		"Apron"
	)

	-- Apron bow at the waist (a small pink heart-ish square)
	AB.block(Vector3.new(0.6, 0.3, 0.2), PINK, AB.offset(originCF, 0, 2.6, 0.7), model, "Bow")

	-- Arms (uniform sleeves end at shoulder for short-sleeve look)
	AB.block(Vector3.new(0.55, 0.6, 0.55), UNIFORM, AB.offset(originCF, -1.25, 4.5, 0), model, "SleeveL")
	AB.block(Vector3.new(0.55, 0.6, 0.55), UNIFORM, AB.offset(originCF,  1.25, 4.5, 0), model, "SleeveR")
	AB.block(Vector3.new(0.55, 1.6, 0.55), SKIN,    AB.offset(originCF, -1.25, 3.4, 0), model, "ArmL")
	AB.block(Vector3.new(0.55, 1.6, 0.55), SKIN,    AB.offset(originCF,  1.25, 3.4, 0), model, "ArmR")

	-- Hands
	AB.sphere(0.5, SKIN, AB.offset(originCF, -1.25, 2.4, 0), model, "HandL")
	AB.sphere(0.5, SKIN, AB.offset(originCF,  1.25, 2.4, 0.3), model, "HandR")

	-- Notepad in right hand
	AB.block(Vector3.new(0.6, 0.08, 0.8), APRON, AB.offset(originCF, 1.25, 2.6, 0.5), model, "Notepad")
	-- Pencil
	AB.cylinder(0.1, 0.7, Color3.fromRGB(220, 200, 80), AB.offset(originCF, 1.25, 2.65, 1.1) * CFrame.Angles(0, 0, math.rad(-90)), model, "Pencil")

	-- Head
	AB.sphere(1.35, SKIN, AB.offset(originCF, 0, 5.9, 0), model, "Head")

	-- Pink hair (a sphere slightly larger above)
	AB.sphere(1.55, PINK, AB.offset(originCF, 0, 6.2, -0.15), model, "Hair")

	-- Hair bangs (a flat strip in front)
	AB.block(Vector3.new(1.4, 0.5, 0.2), PINK, AB.offset(originCF, 0, 6.4, 0.65), model, "Bangs")

	-- Diner cap (small teal cap on top)
	AB.cylinder(1.2, 0.4, UNIFORM, AB.offset(originCF, 0, 7.0, 0), model, "Cap")

	-- Eyes (with eyelash bias — slightly bigger)
	AB.sphere(0.15, Color3.fromRGB(40, 30, 60), AB.offset(originCF, -0.3, 5.95, 0.65), model, "EyeL")
	AB.sphere(0.15, Color3.fromRGB(40, 30, 60), AB.offset(originCF,  0.3, 5.95, 0.65), model, "EyeR")

	-- Lips (small pink mark)
	AB.block(Vector3.new(0.3, 0.08, 0.05), PINK, AB.offset(originCF, 0, 5.5, 0.7), model, "Lips")

	-- Name tag
	AB.billboard(torso, "Cookie", Vector2.new(180, 36), 4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
