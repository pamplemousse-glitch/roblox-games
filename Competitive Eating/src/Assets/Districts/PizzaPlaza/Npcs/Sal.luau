-- Sal — the calzone cart vendor. Stocky guy in a striped shirt, paper boat
-- hat, holding a stack of calzones in a basket.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local NAME    = "Sal"
local SKIN    = Color3.fromRGB(245, 215, 175)
local STRIPE_R= Color3.fromRGB(200, 40, 40)
local STRIPE_W= Color3.fromRGB(245, 240, 230)
local PANTS   = Color3.fromRGB(80, 50, 30)
local HAIR    = Color3.fromRGB(60, 40, 35)
local CALZONE = Color3.fromRGB(220, 180, 100)
local BASKET  = Color3.fromRGB(190, 140, 80)
local BANDANA = Color3.fromRGB(80, 140, 60)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model(NAME, parent)

	-- Torso (wider, stocky)
	local torso = AB.part({size=Vector3.new(3.2, 3, 1.6), color=STRIPE_W,
		cf=originCF, canCollide=false, name="Torso"}, model)
	-- Stripes (3 red horizontal)
	for i, y in {1, 0, -1} do
		AB.part({size=Vector3.new(3.25, 0.6, 1.65), color=STRIPE_R,
			cf=AB.offset(originCF, 0, y, 0), canCollide=false, name="Stripe_" .. i}, model)
	end
	-- Belt
	AB.part({size=Vector3.new(3.2, 0.3, 1.6), color=Color3.fromRGB(40, 30, 25),
		cf=AB.offset(originCF, 0, -1.65, 0), canCollide=false, name="Belt"}, model)
	-- Belt buckle (gold)
	AB.block(Vector3.new(0.6, 0.4, 0.1), Color3.fromRGB(220, 180, 60),
		AB.offset(originCF, 0, -1.65, 0.85), model, "Buckle")
	-- Pants
	AB.part({size=Vector3.new(3.2, 0.4, 1.6), color=PANTS,
		cf=AB.offset(originCF, 0, -1.95, 0), canCollide=false, name="Pants"}, model)

	-- Head
	local head = AB.part({size=Vector3.new(2, 2, 2), color=SKIN,
		cf=AB.offset(originCF, 0, 2.6, 0), shape=Enum.PartType.Ball, canCollide=false, name="Head"}, model)
	-- Five o'clock shadow / stubble
	AB.part({size=Vector3.new(1.6, 0.4, 0.4), color=Color3.fromRGB(80, 60, 50),
		cf=AB.offset(originCF, 0, 2, 0.85), canCollide=false, name="Stubble"}, model)
	-- Eyebrows (thick)
	AB.part({size=Vector3.new(0.45, 0.18, 0.1), color=HAIR,
		cf=AB.offset(originCF, -0.4, 2.95, 0.95), canCollide=false, name="BrowL"}, model)
	AB.part({size=Vector3.new(0.45, 0.18, 0.1), color=HAIR,
		cf=AB.offset(originCF, 0.4, 2.95, 0.95), canCollide=false, name="BrowR"}, model)
	-- Eyes
	AB.sphere(0.2, Color3.fromRGB(30, 25, 20), AB.offset(originCF, -0.4, 2.65, 0.95), model, "EyeL")
	AB.sphere(0.2, Color3.fromRGB(30, 25, 20), AB.offset(originCF, 0.4, 2.65, 0.95), model, "EyeR")
	-- Big toothy grin
	AB.block(Vector3.new(0.8, 0.2, 0.05), STRIPE_W, AB.offset(originCF, 0, 2.1, 0.96), model, "Grin")
	-- Cigar in mouth (small dark brown)
	AB.cylinder(0.12, 0.8, Color3.fromRGB(80, 50, 30),
		AB.offset(originCF, 0.4, 2.05, 1.1) * CFrame.Angles(0, math.rad(90), math.rad(90)), model, "Cigar")
	-- Cigar ember
	local ember = AB.sphere(0.12, Color3.fromRGB(255, 100, 30), AB.offset(originCF, 0.85, 2.05, 1.1), model, "Ember")
	AB.neon(ember)

	-- Paper boat hat (white wedge)
	AB.part({size=Vector3.new(2.4, 0.6, 1.8), color=STRIPE_W,
		cf=AB.offset(originCF, 0, 3.7, 0), canCollide=false, name="HatBrim"}, model)
	AB.wedge(Vector3.new(0.4, 1.4, 2.4), STRIPE_W,
		AB.offset(originCF, 0, 4.4, 0) * CFrame.Angles(0, math.rad(90), 0), model, "HatTop")
	AB.wedge(Vector3.new(0.4, 1.4, 2.4), STRIPE_W,
		AB.offset(originCF, 0, 4.4, 0) * CFrame.Angles(0, math.rad(-90), 0), model, "HatTop2")

	-- Arms
	AB.part({size=Vector3.new(1.1, 2.3, 1.1), color=STRIPE_W,
		cf=AB.offset(originCF, -2, 0, 0.2) * CFrame.Angles(math.rad(-50), 0, 0), canCollide=false, name="ArmL"}, model)
	AB.part({size=Vector3.new(1.1, 2.3, 1.1), color=STRIPE_W,
		cf=AB.offset(originCF, 2, 0, 0.2) * CFrame.Angles(math.rad(-50), 0, 0), canCollide=false, name="ArmR"}, model)
	-- Hand on arms (one stripe band)
	AB.part({size=Vector3.new(1.15, 0.4, 1.15), color=STRIPE_R,
		cf=AB.offset(originCF, -2, 0.5, -0.7), canCollide=false, name="ArmBandL"}, model)
	AB.part({size=Vector3.new(1.15, 0.4, 1.15), color=STRIPE_R,
		cf=AB.offset(originCF, 2, 0.5, -0.7), canCollide=false, name="ArmBandR"}, model)
	-- Hands
	AB.sphere(0.55, SKIN, AB.offset(originCF, -2, -1.1, 1.5), model, "HandL")
	AB.sphere(0.55, SKIN, AB.offset(originCF, 2, -1.1, 1.5), model, "HandR")

	-- Basket of calzones (held between hands)
	AB.block(Vector3.new(3, 1, 2), BASKET, AB.offset(originCF, 0, -1.2, 2.5), model, "Basket")
	AB.block(Vector3.new(3.2, 0.2, 2.2), Color3.fromRGB(130, 90, 50), AB.offset(originCF, 0, -0.7, 2.5), model, "BasketRim")
	-- Calzones (3 visible on top)
	AB.sphere(0.7, CALZONE, AB.offset(originCF, -0.8, -0.4, 2.5), model, "Calzone1")
	AB.sphere(0.7, CALZONE, AB.offset(originCF, 0, -0.4, 2.5), model, "Calzone2")
	AB.sphere(0.7, CALZONE, AB.offset(originCF, 0.8, -0.4, 2.5), model, "Calzone3")
	-- Browned tops
	AB.sphere(0.72, Color3.fromRGB(180, 130, 70), AB.offset(originCF, -0.8, -0.2, 2.5), model, "CalzCrust1")
	AB.sphere(0.72, Color3.fromRGB(180, 130, 70), AB.offset(originCF, 0, -0.2, 2.5), model, "CalzCrust2")
	-- Green bandana around basket
	AB.cylinder(1.5, 0.15, BANDANA,
		AB.offset(originCF, 0, -0.8, 2.5) * CFrame.Angles(0, 0, math.rad(90)), model, "Bandana")

	AB.billboard(head, NAME, Vector2.new(200, 36), 3)
	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
