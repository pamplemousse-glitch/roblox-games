-- LeGlacePastry — elegant French-style patisserie with cream facade,
-- gold trim, a curved bay display window, neon "LE GLACÉ" sign, and a
-- mansard roof topped with a pink dome.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK    = Color3.fromRGB(255, 200, 214)
local CREAM   = Color3.fromRGB(255, 240, 220)
local BROWN   = Color3.fromRGB(92,  57,  36)
local GOLD    = Color3.fromRGB(212, 168, 82)
local MINT    = Color3.fromRGB(180, 230, 200)
local NEONPK  = Color3.fromRGB(255, 110, 170)
local GLASS   = Color3.fromRGB(210, 235, 250)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("LeGlacePastry", parent)

	-- Foundation
	AB.block(Vector3.new(34, 0.5, 24), Color3.fromRGB(110, 100, 95),
		AB.offset(originCF, 0, 0.25, 0), model, "Foundation")

	-- Cream walls
	AB.block(Vector3.new(34, 16, 1),  CREAM, AB.offset(originCF, 0,    8, -11.5), model, "BackWall")
	AB.block(Vector3.new(1,  16, 24), CREAM, AB.offset(originCF, -16.5, 8,  0),   model, "LeftWall")
	AB.block(Vector3.new(1,  16, 24), CREAM, AB.offset(originCF,  16.5, 8,  0),   model, "RightWall")
	AB.block(Vector3.new(10, 16, 1),  CREAM, AB.offset(originCF, -12,  8,  11.5), model, "FrontLeft")
	AB.block(Vector3.new(10, 16, 1),  CREAM, AB.offset(originCF,  12,  8,  11.5), model, "FrontRight")
	AB.block(Vector3.new(14, 5,  1),  CREAM, AB.offset(originCF,  0,   13.5, 11.5), model, "FrontHeader")

	-- Gold trim: horizontal band along the facade top
	AB.block(Vector3.new(34, 0.6, 1.1), GOLD, AB.offset(originCF, 0, 11, 11.6), model, "TrimMid")
	AB.block(Vector3.new(34, 0.6, 1.1), GOLD, AB.offset(originCF, 0, 16, 11.6), model, "TrimTop")
	AB.block(Vector3.new(36, 0.6, 1.1), GOLD, AB.offset(originCF, 0, 0.7, 11.6), model, "TrimBase")

	-- Gold pilasters flanking the door
	AB.block(Vector3.new(0.8, 11, 0.8), GOLD, AB.offset(originCF, -7.5, 5.5, 12), model, "PilasterL")
	AB.block(Vector3.new(0.8, 11, 0.8), GOLD, AB.offset(originCF,  7.5, 5.5, 12), model, "PilasterR")

	-- Curved bay display window (3 angled glass panes)
	local function bayPane(name: string, x: number, yaw: number)
		local p = AB.block(Vector3.new(5, 6, 0.3), GLASS,
			AB.offset(originCF, x, 4.5, 13.5, yaw), model, name)
		p.Transparency = 0.45
		p.Material = Enum.Material.Glass
	end
	bayPane("BayPaneL", -4.2, 18)
	bayPane("BayPaneC",  0,   0)
	bayPane("BayPaneR",  4.2, -18)
	-- Window frame (gold)
	AB.block(Vector3.new(12, 0.4, 1.2), GOLD, AB.offset(originCF, 0, 7.7, 13.4), model, "BayFrameTop")
	AB.block(Vector3.new(12, 0.4, 1.2), GOLD, AB.offset(originCF, 0, 1.6, 13.4), model, "BayFrameBot")

	-- Pastry display: 3 cake stands behind the bay glass
	for i, x in {-3.5, 0, 3.5} do
		AB.cylinder(1.6, 0.2, GOLD, AB.offset(originCF, x, 2.6, 13.0), model, "Stand_" .. i)
		AB.cylinder(1.2, 1.4, PINK, AB.offset(originCF, x, 3.4, 13.0), model, "Cake_" .. i)
		AB.sphere(0.45, MINT, AB.offset(originCF, x, 4.2, 13.0), model, "CakeTop_" .. i)
	end

	-- Neon "LE GLACÉ" sign
	local sign = AB.block(Vector3.new(18, 2.4, 0.4), NEONPK,
		AB.offset(originCF, 0, 14, 12), model, "NeonSign")
	AB.neon(sign)
	AB.glow(sign, sign.Color, 3)
	-- Sign backing plate
	AB.block(Vector3.new(20, 3.2, 0.3), BROWN,
		AB.offset(originCF, 0, 14, 11.9), model, "SignBacking")
	-- Gold sign brackets
	for i, x in {-9.5, 9.5} do
		AB.block(Vector3.new(0.6, 3.4, 0.6), GOLD,
			AB.offset(originCF, x, 14, 11.7), model, "SignBracket_" .. i)
	end

	-- Mansard roof slope (4 wedge panels)
	AB.wedge(Vector3.new(36, 3, 4), BROWN,
		AB.offset(originCF, 0, 18, 11.5) * CFrame.Angles(math.rad(-45), 0, 0), model, "MansardFront")
	AB.wedge(Vector3.new(36, 3, 4), BROWN,
		AB.offset(originCF, 0, 18, -11.5) * CFrame.Angles(math.rad(45), math.rad(180), 0), model, "MansardBack")

	-- Roof flat top
	AB.block(Vector3.new(30, 0.8, 18), BROWN, AB.offset(originCF, 0, 20, 0), model, "RoofTop")

	-- Pink dome cupola center-back
	AB.sphere(5, PINK, AB.offset(originCF, 0, 22.5, -3), model, "DomeBase")
	AB.cylinder(0.6, 3, GOLD, AB.offset(originCF, 0, 26, -3), model, "DomeSpike")
	AB.sphere(0.9, GOLD, AB.offset(originCF, 0, 27.8, -3), model, "DomeFinial")

	-- Roof dormer windows (3 small)
	for i, x in {-10, 0, 10} do
		AB.block(Vector3.new(2.2, 2, 1.4), CREAM,
			AB.offset(originCF, x, 19, 9), model, "Dormer_" .. i)
		local dwin = AB.block(Vector3.new(1.4, 1.2, 0.2), GLASS,
			AB.offset(originCF, x, 19, 9.7), model, "DormerGlass_" .. i)
		dwin.Transparency = 0.5
		dwin.Material = Enum.Material.Glass
	end

	-- Awning over door (mint stripes on cream)
	AB.block(Vector3.new(10, 0.6, 3.5), CREAM,
		AB.offset(originCF, 0, 10.6, 13.5), model, "Awning")
	for i, x in {-3.5, -1.2, 1.2, 3.5} do
		AB.block(Vector3.new(1, 0.65, 3.5), MINT,
			AB.offset(originCF, x, 10.6, 13.5), model, "AwningStripe_" .. i)
	end
	-- Awning fringe
	for i = 1, 9 do
		local x = -4 + (i - 1) * 1
		AB.block(Vector3.new(0.7, 0.5, 0.1), CREAM,
			AB.offset(originCF, x, 10.2, 15.15), model, "AwningFringe_" .. i)
	end

	-- Sidewalk planters with mint shrubs
	for i, x in {-13, 13} do
		AB.block(Vector3.new(2, 1.4, 2), GOLD,
			AB.offset(originCF, x, 0.7, 13.5), model, "PlanterBase_" .. i)
		AB.sphere(2.2, MINT,
			AB.offset(originCF, x, 2.5, 13.5), model, "Shrub_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
