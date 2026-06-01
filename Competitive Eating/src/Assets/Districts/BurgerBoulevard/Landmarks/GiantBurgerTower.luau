-- GiantBurgerTower — V2 upgrade of the v1 burger statue. Scaled up to 35 studs
-- tall, with a rotating chef-hat finial, a glowing pedestal plaque, and detailed
-- sesame buns + plump patty + dripping cheese.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GiantBurgerTower", parent)

	local CHROME    = Color3.fromRGB(176, 176, 176)
	local NEON_RED  = Color3.fromRGB(255, 48, 48)
	local CREAM     = Color3.fromRGB(255, 245, 232)
	local SESAME    = Color3.fromRGB(245, 230, 200)
	local WHITE     = Color3.fromRGB(245, 245, 240)
	local DARK      = Color3.fromRGB(50, 50, 55)

	-- Massive concrete pedestal
	local pedestal = AB.cylinder(28, 4, Color3.fromRGB(120, 120, 120), AB.offset(originCF, 0, 2, 0), model, "Pedestal")
	pedestal.Material = Enum.Material.Concrete
	-- Pedestal chamfer ring (decorative)
	AB.cylinder(28.4, 0.6, CHROME, AB.offset(originCF, 0, 4.1, 0), model, "PedestalRingTop")
	AB.cylinder(28.4, 0.6, CHROME, AB.offset(originCF, 0, 0.1, 0), model, "PedestalRingBot")

	-- Pedestal plaque (glowing neon)
	local plaque = AB.block(Vector3.new(8, 3, 0.5), CHROME, AB.offset(originCF, 0, 2.5, 14.05), model, "Plaque")
	plaque.Material = Enum.Material.Metal
	local plaqueNeon = AB.block(Vector3.new(7, 2, 0.6), NEON_RED, AB.offset(originCF, 0, 2.5, 14.2), model, "PlaqueNeon")
	AB.neon(plaqueNeon); AB.glow(plaqueNeon, NEON_RED, 2.5)
	AB.billboard(plaque, "BURGER BOULEVARD", Vector2.new(280, 60), 0)

	-- Decorative stars around pedestal (4 of them)
	for i = 0, 3 do
		local angle = (i / 4) * 2 * math.pi
		local star = AB.sphere(1.2, NEON_RED, AB.offset(originCF, math.cos(angle) * 13, 2.5, math.sin(angle) * 13), model, "Star_" .. i)
		AB.neon(star); AB.glow(star, NEON_RED, 1.5)
	end

	-- Burger stack — every layer scaled up vs v1
	-- Bottom bun (squat fat cylinder)
	AB.cylinder(24, 4, AB.colors.bunTan, AB.offset(originCF, 0, 6, 0), model, "BottomBun")
	-- Bottom bun textural ring
	AB.cylinder(24.4, 0.4, AB.colors.bunTan:Lerp(DARK, 0.2), AB.offset(originCF, 0, 8, 0), model, "BottomBunSeam")

	-- Patty (thicker, juicier)
	local patty = AB.cylinder(25, 3, AB.colors.burgerBrown, AB.offset(originCF, 0, 9.5, 0), model, "Patty")
	patty.Material = Enum.Material.SmoothPlastic
	-- Patty grill marks (4 lines)
	for i = 0, 3 do
		AB.block(Vector3.new(0.4, 0.2, 12), AB.colors.burgerBrown:Lerp(DARK, 0.4), AB.offset(originCF, -6 + i * 4, 11, 0), model, "GrillMark_" .. i)
	end

	-- Cheese (wider, with corner drips)
	AB.block(Vector3.new(25, 0.6, 25), AB.colors.cheese, AB.offset(originCF, 0, 11.5, 0), model, "Cheese")
	for i, pos in {
		Vector3.new( 11, 0,  11),
		Vector3.new(-11, 0,  11),
		Vector3.new( 11, 0, -11),
		Vector3.new(-11, 0, -11),
		Vector3.new(  0, 0,  12),
		Vector3.new(  0, 0, -12),
	} do
		AB.block(Vector3.new(3, 2, 3), AB.colors.cheese, AB.offset(originCF, pos.X, 10.8, pos.Z), model, "CheeseDrip_" .. i)
	end

	-- Lettuce ring (frilly approximation via 8 small wedges around the rim)
	for i = 0, 7 do
		local angle = (i / 8) * 2 * math.pi
		AB.wedge(Vector3.new(2, 1.5, 5), AB.colors.lettuce, AB.offset(originCF, math.cos(angle) * 12, 12.5, math.sin(angle) * 12) * CFrame.Angles(0, math.rad(math.deg(angle) + 90), 0), model, "LettuceFrill_" .. i)
	end

	-- Tomato slice (red disc)
	AB.cylinder(22, 0.8, Color3.fromRGB(220, 60, 50), AB.offset(originCF, 0, 13.5, 0), model, "Tomato")
	-- Tomato seeds visible (small yellow specks)
	for i = 0, 7 do
		local angle = (i / 8) * 2 * math.pi
		AB.sphere(0.4, Color3.fromRGB(245, 230, 100), AB.offset(originCF, math.cos(angle) * 8, 14, math.sin(angle) * 8), model, "TomatoSeed_" .. i)
	end

	-- Onion ring (translucent purple-white)
	local onion = AB.cylinder(20, 0.6, Color3.fromRGB(240, 220, 230), AB.offset(originCF, 0, 14.5, 0), model, "OnionRing")
	onion.Transparency = 0.3

	-- Top bun (massive dome)
	local topBun = AB.sphere(24, AB.colors.bunTan, AB.offset(originCF, 0, 20, 0), model, "TopBun")

	-- Sesame seeds (20 sprinkled on top)
	math.randomseed(42)
	for i = 1, 20 do
		local angle = math.random() * 2 * math.pi
		local radius = math.random() * 8
		local yJitter = math.random() * 0.5
		AB.sphere(1.4, SESAME, AB.offset(originCF, math.cos(angle) * radius, 27 + yJitter, math.sin(angle) * radius), model, "Seed_" .. i)
	end

	-- A giant chef-hat finial (cylindrical poofy hat)
	AB.cylinder(8, 4, WHITE, AB.offset(originCF, 0, 32, 0), model, "ChefHatBase")
	AB.sphere(7, WHITE, AB.offset(originCF, 0, 36, 0), model, "ChefHatPoof1")
	AB.sphere(5, WHITE, AB.offset(originCF, 2, 36, 0), model, "ChefHatPoof2")
	AB.sphere(4, WHITE, AB.offset(originCF, -2, 37, 0), model, "ChefHatPoof3")
	AB.sphere(3, WHITE, AB.offset(originCF, 0, 38, 1), model, "ChefHatPoof4")

	-- Spotlights at base aimed up
	for i = 0, 3 do
		local angle = (i / 4) * 2 * math.pi
		local sx = math.cos(angle) * 16
		local sz = math.sin(angle) * 16
		AB.cylinder(1.2, 1.5, CHROME, AB.offset(originCF, sx, 4.5, sz), model, "SpotBase_" .. i)
		local lamp = AB.sphere(0.8, Color3.fromRGB(255, 240, 200), AB.offset(originCF, sx, 5.5, sz), model, "SpotLamp_" .. i)
		AB.neon(lamp); AB.glow(lamp, Color3.fromRGB(255, 240, 200), 2.5)
	end

	AB.pivot(model, pedestal)
	AB.weldAll(model)
	return model
end
