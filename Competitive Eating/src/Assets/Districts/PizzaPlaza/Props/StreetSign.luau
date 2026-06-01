-- Street Sign — "VIA TONY" crossroads sign with two perpendicular blades,
-- iron pole, and a little parking-meter style attachment.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local IRON      = Color3.fromRGB(35, 35, 40)
local GREEN_SGN = Color3.fromRGB(40, 90, 60)
local WHITE_TXT = Color3.fromRGB(245, 240, 230)
local YELLOW    = Color3.fromRGB(240, 200, 80)
local BRASS     = Color3.fromRGB(200, 160, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("StreetSign", parent)

	-- Square base
	AB.block(Vector3.new(1.4, 0.4, 1.4), IRON, AB.offset(originCF, 0, 0.2, 0), model, "Base")
	-- Pole
	AB.cylinder(0.5, 10, IRON, AB.offset(originCF, 0, 5, 0), model, "Pole")
	-- Pole top ball
	AB.sphere(0.6, BRASS, AB.offset(originCF, 0, 10.2, 0), model, "PoleBall")

	-- Sign blade 1: "VIA TONY" (along Z axis)
	AB.block(Vector3.new(5, 1.2, 0.2), GREEN_SGN, AB.offset(originCF, 0, 9, 0) * CFrame.Angles(0, math.rad(0), 0), model, "Blade1")
	AB.block(Vector3.new(5.1, 0.15, 0.25), WHITE_TXT, AB.offset(originCF, 0, 9.5, 0), model, "Blade1TopBorder")
	AB.block(Vector3.new(5.1, 0.15, 0.25), WHITE_TXT, AB.offset(originCF, 0, 8.5, 0), model, "Blade1BotBorder")
	-- Faux text bumps
	for i = -1, 1 do
		AB.block(Vector3.new(0.7, 0.5, 0.05), WHITE_TXT, AB.offset(originCF, i * 1, 9, 0.13), model, "Blade1Txt_" .. (i + 1))
	end

	-- Sign blade 2: "MAMMA CARMELA" (rotated 90°, along X axis)
	AB.block(Vector3.new(0.2, 1.2, 5), GREEN_SGN, AB.offset(originCF, 0, 7.8, 0), model, "Blade2")
	AB.block(Vector3.new(0.25, 0.15, 5.1), WHITE_TXT, AB.offset(originCF, 0, 8.3, 0), model, "Blade2TopBorder")
	AB.block(Vector3.new(0.25, 0.15, 5.1), WHITE_TXT, AB.offset(originCF, 0, 7.3, 0), model, "Blade2BotBorder")
	for i = -1, 1 do
		AB.block(Vector3.new(0.05, 0.5, 0.7), WHITE_TXT, AB.offset(originCF, 0.13, 7.8, i * 1), model, "Blade2Txt_" .. (i + 1))
	end

	-- Mounting plates (decorative)
	AB.cylinder(1, 0.3, IRON, AB.offset(originCF, 0, 9, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "MountTop")
	AB.cylinder(1, 0.3, IRON, AB.offset(originCF, 0, 7.8, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "MountMid")

	-- Parking meter (yellow box on pole, midway)
	AB.block(Vector3.new(0.8, 1.6, 0.6), YELLOW, AB.offset(originCF, 0, 4.5, 0.6), model, "MeterBox")
	AB.block(Vector3.new(0.9, 0.6, 0.4), IRON, AB.offset(originCF, 0, 5.1, 0.7), model, "MeterFace")
	AB.cylinder(0.2, 0.3, BRASS, AB.offset(originCF, 0, 4.8, 0.8), model, "MeterKnob")

	-- Crosswalk hint (one yellow stripe on ground)
	AB.block(Vector3.new(5, 0.2, 0.7), YELLOW, AB.offset(originCF, 0, 0.1, 2), model, "CrosswalkStripe")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
