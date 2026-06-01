-- SmashvilleDriveIn — flagship 50s diner. Chrome strip, red booths visible
-- through plate-glass windows, neon "SMASHVILLE" sign, peaked roof, parking awning.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local CHROME    = Color3.fromRGB(176, 176, 176)
local TEAL      = Color3.fromRGB(127, 202, 194)
local NEON_RED  = Color3.fromRGB(255, 48, 48)
local CREAM     = Color3.fromRGB(255, 245, 232)
local SKY       = Color3.fromRGB(135, 206, 235)
local DARK_RED  = Color3.fromRGB(150, 30, 30)
local BOOTH_RED = Color3.fromRGB(200, 50, 50)
local ASPHALT   = Color3.fromRGB(50, 50, 55)
local WHITE     = Color3.fromRGB(245, 245, 245)
local BLACK     = Color3.fromRGB(30, 30, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SmashvilleDriveIn", parent)

	-- Asphalt drive-in apron
	local apron = AB.block(Vector3.new(38, 0.4, 26), ASPHALT, AB.offset(originCF, 0, 0.2, 4), model, "Apron")
	apron.Material = Enum.Material.Asphalt

	-- Painted parking lines
	for i = -2, 2 do
		AB.block(Vector3.new(0.4, 0.45, 8), WHITE, AB.offset(originCF, i * 4, 0.42, 12), model, "ParkLine_" .. i)
	end

	-- Foundation
	local foundation = AB.block(Vector3.new(30, 1, 18), Color3.fromRGB(100, 100, 100), AB.offset(originCF, 0, 0.5, -5), model, "Foundation")
	foundation.Material = Enum.Material.Concrete

	-- Main walls (cream)
	AB.block(Vector3.new(30, 8, 1),  CREAM, AB.offset(originCF, 0, 5, -13.5), model, "BackWall")
	AB.block(Vector3.new(1,  8, 18), CREAM, AB.offset(originCF, -14.5, 5, -5), model, "LeftWall")
	AB.block(Vector3.new(1,  8, 18), CREAM, AB.offset(originCF,  14.5, 5, -5), model, "RightWall")

	-- Front: large plate-glass windows (transparent) with red booths visible inside
	-- Two glass panels flanking a central doorway
	local glassL = AB.block(Vector3.new(10, 6, 0.4), SKY, AB.offset(originCF, -7, 4, 3.5), model, "GlassLeft")
	glassL.Material = Enum.Material.Glass
	glassL.Transparency = 0.55
	glassL.Reflectance = 0.2
	local glassR = AB.block(Vector3.new(10, 6, 0.4), SKY, AB.offset(originCF,  7, 4, 3.5), model, "GlassRight")
	glassR.Material = Enum.Material.Glass
	glassR.Transparency = 0.55
	glassR.Reflectance = 0.2
	-- Window frame top + bottom + center
	AB.block(Vector3.new(30, 0.8, 0.6), CHROME, AB.offset(originCF, 0, 7.2, 3.5), model, "WindowFrameTop")
	AB.block(Vector3.new(30, 0.8, 0.6), CHROME, AB.offset(originCF, 0, 1.2, 3.5), model, "WindowFrameBot")
	AB.block(Vector3.new(0.6, 6, 0.6), CHROME, AB.offset(originCF, -2, 4, 3.5), model, "WindowMullionL")
	AB.block(Vector3.new(0.6, 6, 0.6), CHROME, AB.offset(originCF,  2, 4, 3.5), model, "WindowMullionR")

	-- Doorway frame
	AB.block(Vector3.new(4, 0.8, 0.6), CHROME, AB.offset(originCF, 0, 7.2, 3.5), model, "DoorHeader")
	AB.block(Vector3.new(0.6, 7.2, 0.6), CHROME, AB.offset(originCF, -2, 3.6, 3.5), model, "DoorJambL")
	AB.block(Vector3.new(0.6, 7.2, 0.6), CHROME, AB.offset(originCF,  2, 3.6, 3.5), model, "DoorJambR")

	-- Interior: red booths visible through glass (4 booths along back wall inside)
	for i = 1, 4 do
		local x = -10 + (i - 1) * 7
		AB.block(Vector3.new(5, 2, 1.5), BOOTH_RED, AB.offset(originCF, x, 2, -11.5), model, "Booth_" .. i .. "_Back")
		AB.block(Vector3.new(5, 0.8, 2.5), BOOTH_RED, AB.offset(originCF, x, 1, -10), model, "Booth_" .. i .. "_Seat")
		-- Little white table in front of booth
		AB.block(Vector3.new(3, 0.2, 1.5), WHITE, AB.offset(originCF, x, 2.6, -7.6), model, "Booth_" .. i .. "_Table")
	end

	-- Chrome horizontal strip (signature 50s detail) — wraps the whole upper band
	AB.block(Vector3.new(30, 0.8, 0.4), CHROME, AB.offset(originCF, 0, 9.5, -13.7), model, "ChromeStripBack")
	AB.block(Vector3.new(0.4, 0.8, 18), CHROME, AB.offset(originCF, -14.7, 9.5, -5), model, "ChromeStripLeft")
	AB.block(Vector3.new(0.4, 0.8, 18), CHROME, AB.offset(originCF,  14.7, 9.5, -5), model, "ChromeStripRight")
	AB.block(Vector3.new(30, 0.8, 0.4), CHROME, AB.offset(originCF, 0, 9.5,  3.7), model, "ChromeStripFront")

	-- Peaked roof — two angled wedges meeting at center, plus flat band
	AB.block(Vector3.new(31, 1, 19), DARK_RED, AB.offset(originCF, 0, 10.5, -5), model, "RoofBase").Material = Enum.Material.SmoothPlastic
	AB.wedge(Vector3.new(15.5, 3, 19), DARK_RED, AB.offset(originCF, -7.75, 12.5, -5) * CFrame.Angles(0, math.rad(90), 0), model, "RoofL")
	AB.wedge(Vector3.new(15.5, 3, 19), DARK_RED, AB.offset(originCF,  7.75, 12.5, -5) * CFrame.Angles(0, math.rad(-90), 0), model, "RoofR")

	-- Roof spine (chrome ridge)
	AB.block(Vector3.new(31, 0.4, 0.6), CHROME, AB.offset(originCF, 0, 13.6, -5), model, "RoofRidge")

	-- Neon "SMASHVILLE" sign — large rectangular marquee above front
	local marquee = AB.block(Vector3.new(20, 4, 1), CREAM, AB.offset(originCF, 0, 11, 4.2), model, "MarqueeBody")
	AB.block(Vector3.new(20.4, 0.6, 1.2), CHROME, AB.offset(originCF, 0, 13.3, 4.2), model, "MarqueeTrim")
	AB.block(Vector3.new(20.4, 0.6, 1.2), CHROME, AB.offset(originCF, 0, 8.7, 4.2), model, "MarqueeTrimBot")
	-- Neon text strip (red glow)
	local neonText = AB.block(Vector3.new(16, 2, 0.3), NEON_RED, AB.offset(originCF, 0, 11, 4.8), model, "NeonText")
	AB.neon(neonText)
	AB.glow(neonText, NEON_RED, 3.0)
	-- BillboardGui label on the marquee
	AB.billboard(marquee, "SMASHVILLE", Vector2.new(380, 80), 0)
	-- Lightbulb border around marquee (8 bulbs across, 2 down each side)
	for i = 0, 7 do
		local bulb = AB.sphere(0.6, CREAM, AB.offset(originCF, -9 + i * 18 / 7, 13.5, 4.5), model, "Bulb_T_" .. i)
		AB.neon(bulb); AB.glow(bulb, CREAM, 1.2)
	end
	for i = 0, 7 do
		local bulb = AB.sphere(0.6, CREAM, AB.offset(originCF, -9 + i * 18 / 7, 8.5, 4.5), model, "Bulb_B_" .. i)
		AB.neon(bulb); AB.glow(bulb, CREAM, 1.2)
	end

	-- Parking awning extending out over apron (carhop shelter on left side)
	AB.block(Vector3.new(12, 0.6, 14), TEAL, AB.offset(originCF, -19, 7, 10), model, "AwningRoof")
	-- Awning support poles
	for i = 1, 4 do
		AB.cylinder(0.6, 7, CHROME, AB.offset(originCF, -25 + (i - 1) * 4, 3.5, 17), model, "Pole_" .. i)
	end
	-- Red+white striped fascia on awning edge
	for i = 0, 11 do
		local stripeColor = (i % 2 == 0) and NEON_RED or WHITE
		AB.block(Vector3.new(1, 0.8, 0.4), stripeColor, AB.offset(originCF, -25 + i, 6.6, 17.2), model, "FasciaStripe_" .. i)
	end

	-- Side teal accent panel (vertical fin — classic googie architecture)
	local fin = AB.block(Vector3.new(0.5, 14, 6), TEAL, AB.offset(originCF, -14.7, 7, -4), model, "GoogieFinL")
	fin.Material = Enum.Material.SmoothPlastic
	AB.block(Vector3.new(0.5, 14, 6), TEAL, AB.offset(originCF,  14.7, 7, -4), model, "GoogieFinR")

	-- Arrow/star decoration on each fin
	local starL = AB.block(Vector3.new(0.6, 3, 3), NEON_RED, AB.offset(originCF, -14.7, 13, -4), model, "FinStarL")
	AB.neon(starL); AB.glow(starL, NEON_RED, 1.8)
	local starR = AB.block(Vector3.new(0.6, 3, 3), NEON_RED, AB.offset(originCF,  14.7, 13, -4), model, "FinStarR")
	AB.neon(starR); AB.glow(starR, NEON_RED, 1.8)

	-- Entry steps
	AB.block(Vector3.new(5, 0.4, 1.5), CHROME, AB.offset(originCF, 0, 1.2, 4.3), model, "Step1")
	AB.block(Vector3.new(5, 0.4, 1.5), CHROME, AB.offset(originCF, 0, 0.8, 4.9), model, "Step2")

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
