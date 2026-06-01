-- VintageGasStation — 2 pumps under a flat canopy, small attendant booth,
-- chrome trim, neon "GAS" sign.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TEAL     = Color3.fromRGB(127, 202, 194)
local CHROME   = Color3.fromRGB(176, 176, 176)
local NEON_RED = Color3.fromRGB(255, 48, 48)
local CREAM    = Color3.fromRGB(255, 245, 232)
local SKY      = Color3.fromRGB(135, 206, 235)
local YELLOW   = Color3.fromRGB(245, 195, 70)
local BLACK    = Color3.fromRGB(30, 30, 30)
local DARK     = Color3.fromRGB(60, 60, 60)
local OIL_GRAY = Color3.fromRGB(80, 80, 85)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("VintageGasStation", parent)

	-- Concrete forecourt
	local court = AB.block(Vector3.new(30, 0.6, 22), OIL_GRAY, AB.offset(originCF, 0, 0.3, 0), model, "Forecourt")
	court.Material = Enum.Material.Concrete

	-- White-painted lines on forecourt
	AB.block(Vector3.new(28, 0.65, 0.3), CREAM, AB.offset(originCF, 0, 0.65, -2), model, "Line1")
	AB.block(Vector3.new(28, 0.65, 0.3), CREAM, AB.offset(originCF, 0, 0.65,  2), model, "Line2")

	-- Attendant booth (small office)
	local booth = AB.block(Vector3.new(10, 7, 8), CREAM, AB.offset(originCF, -10, 4.1, -7), model, "BoothBody")
	-- Booth windows (3 panels of glass on the front of booth)
	for i = -1, 1 do
		local win = AB.block(Vector3.new(2.5, 4, 0.3), SKY, AB.offset(originCF, -10 + i * 3, 5, -3.1), model, "BoothWin_" .. i)
		win.Material = Enum.Material.Glass; win.Transparency = 0.4
	end
	-- Booth flat roof + teal trim
	AB.block(Vector3.new(11, 0.5, 9), TEAL, AB.offset(originCF, -10, 7.85, -7), model, "BoothRoof")
	AB.block(Vector3.new(11.4, 0.4, 0.6), NEON_RED, AB.offset(originCF, -10, 8.1, -2.7), model, "BoothTrim")

	-- Canopy (flat slab) covering the pump area
	AB.block(Vector3.new(22, 0.8, 14), TEAL, AB.offset(originCF, 5, 11, 0), model, "Canopy")
	-- Canopy support pillars
	AB.cylinder(1.2, 11, CHROME, AB.offset(originCF, -3, 5.5, -6), model, "Pillar1")
	AB.cylinder(1.2, 11, CHROME, AB.offset(originCF, -3, 5.5,  6), model, "Pillar2")
	AB.cylinder(1.2, 11, CHROME, AB.offset(originCF, 14, 5.5, -6), model, "Pillar3")
	AB.cylinder(1.2, 11, CHROME, AB.offset(originCF, 14, 5.5,  6), model, "Pillar4")
	-- Canopy fascia (red + white striped)
	for i = 0, 10 do
		local color = (i % 2 == 0) and NEON_RED or CREAM
		AB.block(Vector3.new(2, 0.8, 0.3), color, AB.offset(originCF, -5 + i * 2, 10.5, 6.95), model, "FasciaF_" .. i)
	end

	-- Two gas pumps (under the canopy)
	for i = 1, 2 do
		local z = -3 + (i - 1) * 6
		local pumpBase = AB.block(Vector3.new(2, 1, 2), DARK, AB.offset(originCF, 5, 1, z), model, "Pump" .. i .. "_Base")
		local pumpBody = AB.block(Vector3.new(1.8, 5, 1.8), NEON_RED, AB.offset(originCF, 5, 3.6, z), model, "Pump" .. i .. "_Body")
		AB.block(Vector3.new(1.5, 1.5, 1.5), CREAM, AB.offset(originCF, 5, 6.5, z), model, "Pump" .. i .. "_Display")
		-- Glass globe on top
		local globe = AB.sphere(1.8, CREAM, AB.offset(originCF, 5, 8, z), model, "Pump" .. i .. "_Globe")
		globe.Material = Enum.Material.Neon
		AB.glow(globe, Color3.fromRGB(255, 220, 180), 1.5)
		-- Hose hanger
		AB.cylinder(0.3, 2.5, BLACK, AB.offset(originCF, 5.8, 4, z) * CFrame.Angles(0, 0, math.rad(45)), model, "Pump" .. i .. "_Hose")
		AB.billboard(pumpBody, "ETHYL\n23¢", Vector2.new(80, 80), 1)
	end

	-- Pylon sign at curb edge — round "GAS" sign on a pole
	AB.cylinder(0.8, 14, CHROME, AB.offset(originCF, 14, 7, 11), model, "PylonPole")
	local disc = AB.cylinder(7, 1, CREAM, AB.offset(originCF, 14, 14, 11) * CFrame.Angles(0, math.rad(90), 0), model, "PylonDisc")
	-- Pylon ring border (red)
	local ring = AB.cylinder(7.4, 1.2, NEON_RED, AB.offset(originCF, 14, 14, 10.7) * CFrame.Angles(0, math.rad(90), 0), model, "PylonRing")
	disc.Material = Enum.Material.SmoothPlastic
	AB.billboard(disc, "GAS\n23¢", Vector2.new(180, 180), 0)

	-- Vintage Coke-style cooler outside booth
	AB.block(Vector3.new(2.5, 3.5, 1.8), NEON_RED, AB.offset(originCF, -6, 2.35, -3.5), model, "ColaCooler")
	AB.block(Vector3.new(2.6, 0.4, 1.9), CREAM, AB.offset(originCF, -6, 4.1, -3.5), model, "ColaCoolerLid")

	-- Air pump (yellow)
	AB.block(Vector3.new(1.5, 3, 1.5), YELLOW, AB.offset(originCF, -2, 2.1, 9), model, "AirPump")

	-- Oil drum collection on side
	for i = 0, 2 do
		AB.cylinder(2, 3.5, YELLOW, AB.offset(originCF, -15 + i * 0.2, 2.35, 5 + i * 2.4), model, "OilDrum_" .. i)
	end

	-- Neon "GAS" pylon underglow
	local underglow = AB.cylinder(7.2, 1.2, NEON_RED, AB.offset(originCF, 14, 13.5, 11) * CFrame.Angles(0, math.rad(90), 0), model, "PylonUnderglow")
	AB.neon(underglow); AB.glow(underglow, NEON_RED, 2.5)

	AB.pivot(model, court)
	AB.weldAll(model)
	return model
end
