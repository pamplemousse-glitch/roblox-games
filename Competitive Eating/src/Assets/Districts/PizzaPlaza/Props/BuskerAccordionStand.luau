-- Busker Accordion Stand — A small busker's "stage": tip jar, music stand,
-- amp, accordion case open. (The performer is in NPCs.)

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CASE_BLK  = Color3.fromRGB(35, 30, 30)
local FELT_RED  = Color3.fromRGB(160, 30, 40)
local AMP_BLK   = Color3.fromRGB(40, 40, 45)
local AMP_SLV   = Color3.fromRGB(170, 170, 175)
local BRASS     = Color3.fromRGB(200, 160, 80)
local JAR_GLS   = Color3.fromRGB(220, 240, 255)
local COIN      = Color3.fromRGB(220, 180, 60)
local PAPER     = Color3.fromRGB(245, 240, 230)
local STAND_BLK = Color3.fromRGB(50, 50, 55)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BuskerAccordionStand", parent)

	-- Open accordion case on the ground (lid up)
	AB.block(Vector3.new(3.5, 0.4, 2.5), CASE_BLK, AB.offset(originCF, 0, 0.4, 0), model, "CaseBot")
	AB.block(Vector3.new(3.5, 0.3, 2.5), FELT_RED, AB.offset(originCF, 0, 0.6, 0), model, "CaseFelt")
	-- Lid (tilted up at back)
	AB.block(Vector3.new(3.5, 0.4, 2.5), CASE_BLK,
		AB.offset(originCF, 0, 1.5, -1.7) * CFrame.Angles(math.rad(-60), 0, 0), model, "CaseLid")
	-- Hinges
	AB.cylinder(0.2, 0.4, BRASS, AB.offset(originCF, -1.2, 0.7, -1.2), model, "Hinge1")
	AB.cylinder(0.2, 0.4, BRASS, AB.offset(originCF,  1.2, 0.7, -1.2), model, "Hinge2")
	-- Coins scattered in case
	for i = 1, 12 do
		local x = (math.random() - 0.5) * 3
		local z = (math.random() - 0.5) * 2
		AB.cylinder(0.4, 0.08, COIN,
			AB.offset(originCF, x, 0.85, z) * CFrame.Angles(0, 0, math.rad(90)), model, "Coin_" .. i)
	end
	-- A few dollar bills (paper rectangles)
	AB.block(Vector3.new(1.4, 0.05, 0.6), Color3.fromRGB(180, 220, 180),
		AB.offset(originCF, -0.5, 0.9, 0.5), model, "Bill1")
	AB.block(Vector3.new(1.4, 0.05, 0.6), Color3.fromRGB(220, 200, 150),
		AB.offset(originCF, 0.8, 0.9, -0.3) * CFrame.Angles(0, math.rad(15), 0), model, "Bill2")

	-- Tip jar (glass with coins)
	AB.cylinder(1.2, 2.5, JAR_GLS, AB.offset(originCF, 3.5, 1.5, 0), model, "TipJar")
	-- Coins inside (smaller cylinders)
	for i = 1, 4 do
		AB.cylinder(0.7, 0.2, COIN,
			AB.offset(originCF, 3.5 + (math.random() - 0.5) * 0.4, 1 + i * 0.3, 0) * CFrame.Angles(0, 0, math.rad(90)),
			model, "JarCoin_" .. i)
	end
	-- "TIPS €" label
	AB.block(Vector3.new(1.5, 0.6, 0.05), PAPER,
		AB.offset(originCF, 3.5, 2, 0.65), model, "JarLabel")
	AB.block(Vector3.new(1, 0.2, 0.03), Color3.fromRGB(110, 30, 40), AB.offset(originCF, 3.5, 2, 0.7), model, "JarLabelTxt")

	-- Music stand (black metal)
	AB.cylinder(0.3, 5, STAND_BLK, AB.offset(originCF, -3.5, 2.5, 0), model, "StandPole")
	AB.block(Vector3.new(2.5, 1.6, 0.2), STAND_BLK,
		AB.offset(originCF, -3.5, 5.2, 0) * CFrame.Angles(math.rad(-10), 0, 0), model, "StandBoard")
	-- Sheet music
	AB.block(Vector3.new(2.2, 1.4, 0.05), PAPER,
		AB.offset(originCF, -3.5, 5.3, 0.15) * CFrame.Angles(math.rad(-10), 0, 0), model, "SheetMusic")
	-- Music lines on the sheet
	for i = 1, 5 do
		AB.block(Vector3.new(2, 0.05, 0.02), Color3.fromRGB(30, 30, 30),
			AB.offset(originCF, -3.5, 5.6 - i * 0.15, 0.18) * CFrame.Angles(math.rad(-10), 0, 0), model, "Stave_" .. i)
	end

	-- Small amp (black box with silver mesh + brass logo)
	AB.block(Vector3.new(3, 3, 2), AMP_BLK, AB.offset(originCF, 5, 1.5, -2), model, "Amp")
	AB.block(Vector3.new(2.5, 1.8, 0.1), AMP_SLV, AB.offset(originCF, 5, 2.1, -1), model, "AmpMesh")
	-- Mesh grid (vertical bars)
	for i = -1, 1 do
		AB.block(Vector3.new(0.1, 1.8, 0.15), AMP_BLK, AB.offset(originCF, 5 + i * 0.6, 2.1, -0.95), model, "AmpBar_" .. (i + 2))
	end
	-- Brand badge
	AB.block(Vector3.new(1.4, 0.4, 0.1), BRASS, AB.offset(originCF, 5, 1, -0.95), model, "AmpBadge")
	-- Volume knob
	AB.cylinder(0.4, 0.3, AMP_SLV,
		AB.offset(originCF, 5.8, 2.6, -0.95) * CFrame.Angles(math.rad(90), 0, 0), model, "AmpKnob")

	-- Cable from amp to stand (slack arc)
	for i = 1, 4 do
		local t = i / 4
		local x = 5 - 8 * t
		local y = 1.5 - math.sin(t * math.pi) * 0.6
		AB.cylinder(0.15, 1.2, CASE_BLK, AB.offset(originCF, x, y + 0.4, -1.5), model, "Cable_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
