-- Brick Alley Wall — long brick wall with a hand-painted mural (faux Da Vinci /
-- pizza chef cartoon), trash piles, graffiti tags, and a single neon arrow.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BRICK     = Color3.fromRGB(150, 60, 50)
local DARK_BRK  = Color3.fromRGB(110, 45, 40)
local STUCCO    = Color3.fromRGB(240, 220, 180)
local CHEF_RED  = Color3.fromRGB(200, 40, 40)
local CHEF_SKIN = Color3.fromRGB(255, 220, 180)
local NEON_PNK  = Color3.fromRGB(255, 100, 200)
local NEON_YEL  = Color3.fromRGB(255, 230, 60)
local TRASH_BLK = Color3.fromRGB(40, 40, 40)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BrickAlleyWall", parent)

	-- Wall (long, ~40 studs)
	AB.block(Vector3.new(40, 18, 1), BRICK, AB.offset(originCF, 0, 9, 0), model, "Wall")
	-- Brick courses
	for i = 1, 4 do
		AB.block(Vector3.new(40.1, 0.4, 1.05), DARK_BRK, AB.offset(originCF, 0, i * 4, 0), model, "Course_" .. i)
	end

	-- Mural background (stucco oval area)
	AB.block(Vector3.new(14, 12, 0.4), STUCCO, AB.offset(originCF, -8, 9, 0.6), model, "MuralBack")
	-- Chef face (sphere) and hat
	AB.sphere(3.8, CHEF_SKIN, AB.offset(originCF, -8, 10, 0.9), model, "ChefHead")
	AB.block(Vector3.new(3.8, 2.5, 0.4), Color3.fromRGB(255, 255, 240), AB.offset(originCF, -8, 13, 0.95), model, "ChefHatBase")
	AB.sphere(3, Color3.fromRGB(255, 255, 240), AB.offset(originCF, -8, 14.5, 1), model, "ChefHatPuff")
	-- Mustache
	AB.block(Vector3.new(2.2, 0.4, 0.4), Color3.fromRGB(60, 40, 30), AB.offset(originCF, -8, 9.5, 1.1), model, "Mustache")
	-- Pizza in chef's hand (yellow disc + red sphere on top)
	AB.cylinder(2, 0.3, AB.colors.pizzaCrust,
		AB.offset(originCF, -3, 7, 1.1) * CFrame.Angles(0, 0, math.rad(90)), model, "MuralPie")
	AB.sphere(0.5, CHEF_RED, AB.offset(originCF, -3, 7.3, 1.2), model, "MuralPep1")
	AB.sphere(0.5, CHEF_RED, AB.offset(originCF, -3.8, 7.3, 1.2), model, "MuralPep2")

	-- "MANGIA!" graffiti tag (pink neon scribble)
	local tag = AB.block(Vector3.new(8, 1.4, 0.2), NEON_PNK, AB.offset(originCF, 8, 14, 0.6), model, "GraffitiMangia")
	AB.neon(tag)
	AB.glow(tag, tag.Color, 1.5)
	-- "VINNY ❤" scribble (yellow)
	local tag2 = AB.block(Vector3.new(5, 1, 0.2), NEON_YEL, AB.offset(originCF, 8, 10, 0.6), model, "GraffitiVinny")
	AB.neon(tag2)
	AB.glow(tag2, tag2.Color, 1.2)

	-- Neon arrow at end pointing right
	for i, off in {Vector3.new(0, 0, 0), Vector3.new(-0.7, 0.4, 0), Vector3.new(-0.7, -0.4, 0)} do
		local arr = AB.block(Vector3.new(1.4, 0.4, 0.2), Color3.fromRGB(80, 220, 255),
			AB.offset(originCF, 16 + off.X, 6 + off.Y, 0.6), model, "Arrow_" .. i)
		AB.neon(arr)
	end

	-- Trash bags pile on the ground
	for i = 1, 4 do
		AB.sphere(1 + math.random() * 0.4, TRASH_BLK,
			AB.offset(originCF, 12 + i * 1.2, 1 + math.random() * 0.5, 2 + math.random() * 0.5), model, "TrashBag_" .. i)
	end
	-- Knocked-over trash can
	AB.cylinder(2, 3, Color3.fromRGB(80, 80, 90),
		AB.offset(originCF, 14, 1.5, 3.5) * CFrame.Angles(0, math.rad(30), math.rad(70)), model, "FallenCan")

	-- Pipes running up the wall (steel cylinder)
	AB.cylinder(0.5, 17, Color3.fromRGB(120, 120, 130), AB.offset(originCF, -17, 9, 0.7), model, "DrainPipe")
	AB.cylinder(0.5, 3, Color3.fromRGB(120, 120, 130),
		AB.offset(originCF, -16, 1, 0.7) * CFrame.Angles(0, 0, math.rad(90)), model, "DrainElbow")

	-- Small dumpster
	AB.block(Vector3.new(4, 3, 2.5), Color3.fromRGB(60, 90, 60), AB.offset(originCF, 18, 2, 3), model, "Dumpster")
	AB.block(Vector3.new(4.2, 0.3, 2.6), Color3.fromRGB(40, 60, 40), AB.offset(originCF, 18, 3.6, 3), model, "DumpsterLid")
	-- Dumpster wheels
	AB.cylinder(0.8, 0.4, TRASH_BLK,
		AB.offset(originCF, 17, 0.6, 2.2) * CFrame.Angles(math.rad(90), 0, 0), model, "DumpWheel1")
	AB.cylinder(0.8, 0.4, TRASH_BLK,
		AB.offset(originCF, 19, 0.6, 2.2) * CFrame.Angles(math.rad(90), 0, 0), model, "DumpWheel2")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
