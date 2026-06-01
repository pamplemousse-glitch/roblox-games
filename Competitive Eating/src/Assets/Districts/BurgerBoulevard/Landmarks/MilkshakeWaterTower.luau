-- MilkshakeWaterTower — small-town water tower painted as a giant milkshake glass
-- (pink + cream stripes, whipped-cream dome top, giant cherry).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("MilkshakeWaterTower", parent)

	local PINK     = Color3.fromRGB(255, 200, 214)
	local WHITE    = Color3.fromRGB(248, 248, 248)
	local CREAM    = Color3.fromRGB(255, 245, 232)
	local CHROME   = Color3.fromRGB(176, 176, 176)
	local CHERRY_R = Color3.fromRGB(220, 30, 50)
	local STEM_BR  = Color3.fromRGB(120, 70, 40)
	local DARK     = Color3.fromRGB(50, 50, 55)
	local NEON_RED = Color3.fromRGB(255, 48, 48)

	-- 4 support legs (long thin chrome)
	local function leg(x: number, z: number, name: string)
		AB.block(Vector3.new(1, 30, 1), CHROME, AB.offset(originCF, x, 15, z), model, name).Material = Enum.Material.Metal
	end
	leg(-6, -6, "LegFL")
	leg( 6, -6, "LegFR")
	leg(-6,  6, "LegBL")
	leg( 6,  6, "LegBR")
	-- Diagonal cross-braces (X shape between legs, 3 levels)
	for i, y in {6, 14, 22} do
		AB.block(Vector3.new(0.5, 0.5, 17), CHROME, AB.offset(originCF, -6, y, 0), model, "BraceL_" .. i)
		AB.block(Vector3.new(0.5, 0.5, 17), CHROME, AB.offset(originCF,  6, y, 0), model, "BraceR_" .. i)
		AB.block(Vector3.new(17, 0.5, 0.5), CHROME, AB.offset(originCF, 0, y, -6), model, "BraceF_" .. i)
		AB.block(Vector3.new(17, 0.5, 0.5), CHROME, AB.offset(originCF, 0, y,  6), model, "BraceB_" .. i)
		-- X diagonals
		AB.block(Vector3.new(17, 0.4, 0.4), CHROME, AB.offset(originCF, -6, y + 4, 0) * CFrame.Angles(math.rad(45), 0, 0), model, "XL_" .. i)
		AB.block(Vector3.new(17, 0.4, 0.4), CHROME, AB.offset(originCF,  6, y + 4, 0) * CFrame.Angles(math.rad(-45), 0, 0), model, "XR_" .. i)
	end

	-- Main tank (cylinder, painted to look like a giant milkshake glass)
	local tank = AB.cylinder(14, 18, PINK, AB.offset(originCF, 0, 35, 0), model, "Tank")
	tank.Material = Enum.Material.SmoothPlastic
	-- Vertical pink+white stripes (paint job)
	for i = 0, 7 do
		local angle = (i / 8) * 2 * math.pi
		local stripeColor = (i % 2 == 0) and WHITE or PINK
		AB.block(Vector3.new(2, 16, 0.3), stripeColor, AB.offset(originCF, math.cos(angle) * 7.2, 35, math.sin(angle) * 7.2) * CFrame.Angles(0, math.rad(-math.deg(angle)), 0), model, "Stripe_" .. i)
	end
	-- Decorative chrome bands at top and bottom of tank
	AB.cylinder(14.2, 0.6, CHROME, AB.offset(originCF, 0, 43.8, 0), model, "BandTop")
	AB.cylinder(14.2, 0.6, CHROME, AB.offset(originCF, 0, 26.2, 0), model, "BandBot")

	-- Whipped-cream dome (3 sphere stacks)
	AB.sphere(14, WHITE, AB.offset(originCF, 0, 47, 0), model, "WhipDome1")
	AB.sphere(11, WHITE, AB.offset(originCF, 1, 49, 0), model, "WhipDome2")
	AB.sphere(8, WHITE, AB.offset(originCF, -1, 51, 0), model, "WhipDome3")
	AB.sphere(5, WHITE, AB.offset(originCF, 0, 53, 0), model, "WhipDome4")

	-- Cherry on top
	local cherry = AB.sphere(3.5, CHERRY_R, AB.offset(originCF, 0, 55.5, 0), model, "Cherry")
	cherry.Material = Enum.Material.SmoothPlastic
	-- Cherry stem
	AB.cylinder(0.6, 5, STEM_BR, AB.offset(originCF, 0, 58, 0) * CFrame.Angles(0, 0, math.rad(15)), model, "CherryStem")
	AB.cylinder(0.6, 3, STEM_BR, AB.offset(originCF, 1, 60, 0) * CFrame.Angles(0, 0, math.rad(45)), model, "CherryStemTip")

	-- Giant straw piercing the dome
	AB.cylinder(1.4, 14, NEON_RED, AB.offset(originCF, 4, 50, 0) * CFrame.Angles(0, 0, math.rad(-10)), model, "Straw")

	-- "FRESH SHAKES" billboard on tank (front side)
	local bb = AB.block(Vector3.new(8, 2, 0.4), CREAM, AB.offset(originCF, 0, 35, 7.5), model, "TankSign")
	AB.billboard(bb, "FRESH SHAKES", Vector2.new(240, 60), 0)
	-- Neon underline
	local neon = AB.block(Vector3.new(7, 0.3, 0.5), NEON_RED, AB.offset(originCF, 0, 33.8, 7.6), model, "TankSignNeon")
	AB.neon(neon); AB.glow(neon, NEON_RED, 2.0)

	-- Service ladder up one of the legs
	for i = 0, 9 do
		AB.block(Vector3.new(1.5, 0.2, 0.2), CHROME, AB.offset(originCF, 6, 5 + i * 2, -7), model, "LadderRung_" .. i)
	end
	AB.block(Vector3.new(0.2, 22, 0.2), CHROME, AB.offset(originCF, 5.5, 14, -7), model, "LadderRailL")
	AB.block(Vector3.new(0.2, 22, 0.2), CHROME, AB.offset(originCF, 6.5, 14, -7), model, "LadderRailR")

	-- Ground footings
	for _, pos in {Vector3.new(-6, 0.5, -6), Vector3.new(6, 0.5, -6), Vector3.new(-6, 0.5, 6), Vector3.new(6, 0.5, 6)} do
		AB.block(Vector3.new(2, 1, 2), DARK, AB.offset(originCF, pos.X, pos.Y, pos.Z), model, "Footing_" .. pos.X .. "_" .. pos.Z)
	end

	-- Anchor for pivot
	AB.pivot(model, model:FindFirstChild("LegFL"))
	AB.weldAll(model)
	return model
end
