-- Accordion Busker — street musician with a big accordion strapped to his
-- chest, beret, scruffy beard.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Lorenzo"
local SKIN    = Color3.fromRGB(240, 210, 175)
local SHIRT   = Color3.fromRGB(245, 240, 230)
local VEST    = Color3.fromRGB(60, 35, 20)
local PANTS   = Color3.fromRGB(40, 40, 50)
local HAIR    = Color3.fromRGB(60, 40, 35)
local BERET   = Color3.fromRGB(110, 30, 40)
local ACC_RED = Color3.fromRGB(180, 30, 40)
local ACC_BLK = Color3.fromRGB(35, 30, 30)
local BRASS   = Color3.fromRGB(200, 160, 80)
local IVORY   = Color3.fromRGB(245, 240, 220)
local BELLOW  = Color3.fromRGB(80, 60, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (white shirt)
	local torso = AB.part({size=Vector3.new(2.6, 3, 1.3), color=SHIRT,
		cf=originCF, canCollide=false, name="Torso"}, model)
	-- Brown vest over shirt
	AB.part({size=Vector3.new(2.7, 2.4, 0.15), color=VEST,
		cf=AB.offset(originCF, 0, -0.2, 0.7), canCollide=false, name="VestFront"}, model)
	AB.part({size=Vector3.new(2.7, 2.4, 0.15), color=VEST,
		cf=AB.offset(originCF, 0, -0.2, -0.7), canCollide=false, name="VestBack"}, model)
	-- Vest buttons
	for i, y in {0.7, 0.1, -0.5, -1.1} do
		AB.sphere(0.1, BRASS, AB.offset(originCF, 0, y, 0.78), model, "Button_" .. i)
	end
	-- Pants
	AB.part({size=Vector3.new(2.6, 0.4, 1.3), color=PANTS,
		cf=AB.offset(originCF, 0, -1.6, 0), canCollide=false, name="Belt"}, model)
	AB.part({size=Vector3.new(2.6, 0.4, 1.3), color=PANTS,
		cf=AB.offset(originCF, 0, -1.9, 0), canCollide=false, name="Pants"}, model)

	-- Head
	local head = AB.part({size=Vector3.new(1.9, 1.9, 1.9), color=SKIN,
		cf=AB.offset(originCF, 0, 2.5, 0), shape=Enum.PartType.Ball, canCollide=false, name="Head"}, model)
	-- Beret (red)
	AB.sphere(1.4, BERET, AB.offset(originCF, 0, 3.3, -0.15), model, "Beret")
	-- Beret tail (small spike)
	AB.cylinder(0.15, 0.4, BERET, AB.offset(originCF, 0, 3.8, -0.15), model, "BeretTail")
	-- Scruffy beard
	AB.sphere(1, HAIR, AB.offset(originCF, 0, 1.8, 0.3), model, "Beard")
	-- Mustache
	AB.block(Vector3.new(1.3, 0.25, 0.4), HAIR, AB.offset(originCF, 0, 2.2, 0.85), model, "Mustache")
	-- Eyes (closed, into the music)
	AB.block(Vector3.new(0.35, 0.06, 0.1), Color3.fromRGB(60, 40, 35),
		AB.offset(originCF, -0.4, 2.7, 0.92), model, "EyeL")
	AB.block(Vector3.new(0.35, 0.06, 0.1), Color3.fromRGB(60, 40, 35),
		AB.offset(originCF, 0.4, 2.7, 0.92), model, "EyeR")

	-- Arms wrapping around accordion
	AB.part({size=Vector3.new(0.9, 2.2, 0.9), color=SHIRT,
		cf=AB.offset(originCF, -2.4, -0.5, 0.8) * CFrame.Angles(math.rad(-30), 0, math.rad(15)), canCollide=false, name="ArmL"}, model)
	AB.part({size=Vector3.new(0.9, 2.2, 0.9), color=SHIRT,
		cf=AB.offset(originCF, 2.4, -0.5, 0.8) * CFrame.Angles(math.rad(-30), 0, math.rad(-15)), canCollide=false, name="ArmR"}, model)
	-- Hands
	AB.sphere(0.45, SKIN, AB.offset(originCF, -2.4, -1.4, 2), model, "HandL")
	AB.sphere(0.45, SKIN, AB.offset(originCF, 2.4, -1.4, 2), model, "HandR")

	-- ACCORDION — big iconic prop on chest
	-- Left side (button board, red)
	AB.block(Vector3.new(1.5, 2.6, 1.4), ACC_RED, AB.offset(originCF, -2, -0.4, 1.6), model, "AccL")
	-- Right side (keyboard, red)
	AB.block(Vector3.new(1.5, 2.6, 1.4), ACC_RED, AB.offset(originCF, 2, -0.4, 1.6), model, "AccR")
	-- Bellows (folded/striped center)
	for i, x in {-1.3, -0.8, -0.3, 0.2, 0.7, 1.2} do
		AB.block(Vector3.new(0.4, 2.2, 1.2), BELLOW, AB.offset(originCF, x, -0.4, 1.6), model, "Bellow_" .. i)
	end
	-- Bellows hardware corners
	for k, sx in {-1, 1} do
		for j, sy in {-1, 1} do
			AB.sphere(0.18, BRASS,
				AB.offset(originCF, sx * 1.4, -0.4 + sy * 1.1, 2.1), model, "BellowCorner_" .. k .. j)
		end
	end
	-- Black accents on each side
	AB.block(Vector3.new(0.2, 2.6, 1.4), ACC_BLK, AB.offset(originCF, -1.3, -0.4, 1.6), model, "AccLEdge")
	AB.block(Vector3.new(0.2, 2.6, 1.4), ACC_BLK, AB.offset(originCF, 1.3, -0.4, 1.6), model, "AccREdge")
	-- Button board (small buttons on left side)
	for r = 1, 4 do
		for c = 1, 4 do
			AB.sphere(0.1, IVORY,
				AB.offset(originCF, -2 - 0.3 + c * 0.15, -0.4 + 0.8 - (r - 1) * 0.4, 2.3), model, "Btn_" .. r .. c)
		end
	end
	-- Keyboard (white keys on right)
	for k = 1, 6 do
		AB.block(Vector3.new(0.15, 0.4, 0.8), IVORY,
			AB.offset(originCF, 1.8 + (k - 1) * 0.18, -0.4 - 0.5, 2.3), model, "Key_" .. k)
	end
	-- Strap over shoulder
	AB.block(Vector3.new(0.2, 4, 0.2), ACC_BLK,
		AB.offset(originCF, -1, 1.5, 1) * CFrame.Angles(0, 0, math.rad(15)), model, "StrapL")
	AB.block(Vector3.new(0.2, 4, 0.2), ACC_BLK,
		AB.offset(originCF, 1, 1.5, 1) * CFrame.Angles(0, 0, math.rad(-15)), model, "StrapR")
	-- Brand badge (decorative)
	AB.block(Vector3.new(1, 0.5, 0.05), BRASS, AB.offset(originCF, 0, 0.5, 2.3), model, "Badge")

	-- Music notes floating around (small neon glyphs)
	for i, off in {Vector3.new(-3, 4, 0), Vector3.new(3, 5, 0.5), Vector3.new(0, 6, 1)} do
		local note = AB.sphere(0.25, Color3.fromRGB(255, 230, 100),
			AB.offset(originCF, off.X, off.Y, off.Z), model, "Note_" .. i)
		AB.neon(note)
		AB.cylinder(0.05, 0.6, Color3.fromRGB(255, 230, 100),
			AB.offset(originCF, off.X, off.Y + 0.35, off.Z), model, "NoteStem_" .. i)
	end

	AB.billboard(head, NAME, Vector2.new(200, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
