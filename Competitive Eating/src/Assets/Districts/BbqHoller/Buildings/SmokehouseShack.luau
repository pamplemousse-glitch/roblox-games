-- Smokehouse Shack — small wood cabin with a brick smokestack belching smoke.
-- Stained plank walls, slanted roof, brick chimney with neon-grey smoke puffs.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SMOKED_WOOD = Color3.fromRGB(107, 68, 35)
local DARK_WOOD   = Color3.fromRGB(70, 45, 22)
local ROOF        = Color3.fromRGB(50, 32, 20)
local BRICK       = Color3.fromRGB(140, 60, 50)
local SMOKE       = Color3.fromRGB(200, 200, 205)
local EMBER       = Color3.fromRGB(255, 128, 48)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SmokehouseShack", parent)

	-- Foundation
	local foundation = AB.block(
		Vector3.new(22, 0.6, 18),
		DARK_WOOD,
		AB.offset(originCF, 0, 0.3, 0),
		model, "Foundation"
	)

	-- Walls (4 sides) — back, left, right; front has a door gap
	AB.block(Vector3.new(22, 12, 1), SMOKED_WOOD, AB.offset(originCF, 0, 6.6, -8.5),  model, "BackWall")
	AB.block(Vector3.new(1, 12, 18), SMOKED_WOOD, AB.offset(originCF, -10.5, 6.6, 0), model, "LeftWall")
	AB.block(Vector3.new(1, 12, 18), SMOKED_WOOD, AB.offset(originCF, 10.5, 6.6, 0),  model, "RightWall")
	AB.block(Vector3.new(7, 12, 1),  SMOKED_WOOD, AB.offset(originCF, -7.5, 6.6, 8.5), model, "FrontLeft")
	AB.block(Vector3.new(7, 12, 1),  SMOKED_WOOD, AB.offset(originCF,  7.5, 6.6, 8.5), model, "FrontRight")
	AB.block(Vector3.new(8, 3, 1),   SMOKED_WOOD, AB.offset(originCF, 0, 11.1, 8.5),  model, "FrontHeader")

	-- Door (dark wood)
	AB.block(Vector3.new(8, 9, 0.4), DARK_WOOD, AB.offset(originCF, 0, 5.1, 9.0), model, "Door")
	AB.sphere(0.3, EMBER, AB.offset(originCF, 2.5, 5.2, 9.3), model, "DoorKnob")

	-- Wood plank stripes (horizontal bands across the front walls)
	for i, y in {3.2, 6.2, 9.2} do
		AB.block(Vector3.new(7, 0.25, 0.6), DARK_WOOD, AB.offset(originCF, -7.5, y, 9.0), model, "PlankL_" .. i)
		AB.block(Vector3.new(7, 0.25, 0.6), DARK_WOOD, AB.offset(originCF,  7.5, y, 9.0), model, "PlankR_" .. i)
	end

	-- Sloped roof (two wedges meeting at a ridge)
	AB.wedge(Vector3.new(24, 4, 10),  ROOF, AB.offset(originCF, 0, 14.6,  5) * CFrame.Angles(0, math.rad(180), 0), model, "RoofFront")
	AB.wedge(Vector3.new(24, 4, 10),  ROOF, AB.offset(originCF, 0, 14.6, -5), model, "RoofBack")

	-- Brick smokestack on the back-right of the roof
	for layer = 1, 4 do
		AB.block(
			Vector3.new(3.4, 1.6, 3.4),
			BRICK,
			AB.offset(originCF, 7, 17.5 + (layer - 1) * 1.6, -3),
			model, "Chimney_" .. layer
		)
	end
	-- Chimney cap
	AB.block(Vector3.new(4, 0.5, 4), DARK_WOOD, AB.offset(originCF, 7, 24.0, -3), model, "ChimneyCap")

	-- Smoke puffs rising above the chimney (neon-tinted spheres for glow)
	for i = 1, 4 do
		local puff = AB.sphere(
			2.0 + i * 0.4, SMOKE,
			AB.offset(originCF, 7 + (i - 2) * 0.4, 25.5 + (i - 1) * 2.0, -3),
			model, "Smoke_" .. i
		)
		puff.Transparency = 0.2 + (i - 1) * 0.12
		puff.Material     = Enum.Material.Neon
	end

	-- A single ember glow near the door for ambience
	local ember = AB.sphere(0.7, EMBER, AB.offset(originCF, -3, 1.5, 9.5), model, "Ember")
	AB.neon(ember)
	AB.glow(ember, EMBER, 2.0)

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
