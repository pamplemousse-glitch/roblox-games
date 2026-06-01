-- Kid Eating Ribs — short kid in striped shirt and shorts, holding a rack
-- of ribs up to mouth, sauce around mouth and on shirt.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local SKIN      = Color3.fromRGB(245, 210, 175)
local STRIPE_R  = Color3.fromRGB(220, 60, 60)
local STRIPE_W  = Color3.fromRGB(240, 235, 225)
local SHORTS    = Color3.fromRGB(55, 70, 100)
local SHOE      = Color3.fromRGB(220, 220, 225)
local HAIR      = Color3.fromRGB(180, 130, 70)
local RIB_MEAT  = Color3.fromRGB(140, 70, 45)
local RIB_DARK  = Color3.fromRGB(95, 45, 30)
local SAUCE     = Color3.fromRGB(140, 35, 30)
local BONE      = Color3.fromRGB(235, 225, 200)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("KidEatingRibs", parent)

	-- Short legs
	AB.block(Vector3.new(0.9, 2.4, 0.9), SKIN, AB.offset(originCF, -0.5, 1.2, 0), model, "LegL")
	AB.block(Vector3.new(0.9, 2.4, 0.9), SKIN, AB.offset(originCF,  0.5, 1.2, 0), model, "LegR")
	-- Shorts
	AB.block(Vector3.new(2.4, 1.4, 1.4), SHORTS, AB.offset(originCF, 0, 2.5, 0), model, "Shorts")
	-- Sneakers
	AB.block(Vector3.new(1.1, 0.4, 1.4), SHOE, AB.offset(originCF, -0.5, 0.2, 0.1), model, "ShoeL")
	AB.block(Vector3.new(1.1, 0.4, 1.4), SHOE, AB.offset(originCF,  0.5, 0.2, 0.1), model, "ShoeR")

	-- Torso (striped shirt — alternating bands)
	local torso = AB.block(Vector3.new(2.6, 3, 1.4), STRIPE_R, AB.offset(originCF, 0, 4.7, 0), model, "TorsoBase")
	for i, y in {4.0, 4.5, 5.0, 5.5, 6.0} do
		AB.block(Vector3.new(2.65, 0.4, 1.45), (i % 2 == 0) and STRIPE_W or STRIPE_R, AB.offset(originCF, 0, y, 0), model, "Stripe_" .. i)
	end
	-- Sauce stains on shirt
	for i, p in {Vector3.new(-0.5, 4.5, 0.75), Vector3.new(0.6, 4.0, 0.75)} do
		AB.sphere(0.4, SAUCE, originCF * CFrame.new(p), model, "Stain_" .. i)
	end

	-- Arms (both raised holding ribs)
	local armL = AB.block(Vector3.new(0.85, 3, 0.85), SKIN, AB.offset(originCF, -1.8, 5.0, 0.4), model, "ArmL")
	armL.CFrame = armL.CFrame * CFrame.Angles(math.rad(-60), 0, 0)
	local armR = AB.block(Vector3.new(0.85, 3, 0.85), SKIN, AB.offset(originCF, 1.8, 5.0, 0.4), model, "ArmR")
	armR.CFrame = armR.CFrame * CFrame.Angles(math.rad(-60), 0, 0)
	-- Hands forward
	AB.sphere(0.65, SKIN, AB.offset(originCF, -1.5, 6.5, 1.6), model, "HandL")
	AB.sphere(0.65, SKIN, AB.offset(originCF,  1.5, 6.5, 1.6), model, "HandR")

	-- Rack of ribs (held between hands)
	local ribCF = AB.offset(originCF, 0, 6.7, 1.7)
	-- Main rack body
	AB.block(Vector3.new(3.2, 0.6, 1.4), RIB_MEAT, ribCF, model, "RibRack")
	-- Top sauce coat
	AB.block(Vector3.new(3.3, 0.15, 1.5), SAUCE, ribCF * CFrame.new(0, 0.35, 0), model, "RibSauce")
	-- Bones poking out one end
	for i = 1, 4 do
		local bx = -2.0 + i * 0.4
		AB.cylinder(0.25, 0.9, BONE, ribCF * CFrame.new(-1.8 + i * 0.12, -0.05, 0.4 + i * 0.1) * CFrame.Angles(0, 0, math.rad(90)), model, "Bone_" .. i)
	end
	-- Dark grill marks
	for i, x in {-1.0, 0, 1.0} do
		AB.block(Vector3.new(0.2, 0.62, 1.45), RIB_DARK, ribCF * CFrame.new(x, 0, 0), model, "Grill_" .. i)
	end

	-- Head (smaller for kid)
	AB.sphere(1.8, SKIN, AB.offset(originCF, 0, 7.8, 0), model, "Head")
	-- Messy hair
	AB.sphere(1.9, HAIR, AB.offset(originCF, 0, 8.5, -0.2), model, "Hair")
	-- Hair tuft
	AB.sphere(0.6, HAIR, AB.offset(originCF, 0.4, 9.2, 0), model, "HairTuft")

	-- Big happy eyes
	AB.sphere(0.32, Color3.new(0, 0, 0), AB.offset(originCF, -0.4, 8.0, 0.95), model, "EyeL")
	AB.sphere(0.32, Color3.new(0, 0, 0), AB.offset(originCF,  0.4, 8.0, 0.95), model, "EyeR")
	-- Eye sparkles
	AB.sphere(0.12, STRIPE_W, AB.offset(originCF, -0.35, 8.1, 1.1), model, "SparkL")
	AB.sphere(0.12, STRIPE_W, AB.offset(originCF,  0.45, 8.1, 1.1), model, "SparkR")

	-- Open mouth (chomping)
	AB.block(Vector3.new(1.0, 0.5, 0.2), Color3.new(0, 0, 0), AB.offset(originCF, 0, 7.3, 0.95), model, "MouthOpen")
	-- Sauce around mouth
	AB.sphere(0.25, SAUCE, AB.offset(originCF, -0.7, 7.2, 0.95), model, "MouthSauceL")
	AB.sphere(0.25, SAUCE, AB.offset(originCF,  0.7, 7.2, 0.95), model, "MouthSauceR")
	AB.sphere(0.25, SAUCE, AB.offset(originCF, 0, 6.9, 0.95), model, "MouthSauceChin")

	AB.billboard(model:FindFirstChild("Head") or torso, "Kid", Vector2.new(120, 32), 2.4)

	AB.pivot(model, torso)
	AB.weldAll(model)
	return model
end
