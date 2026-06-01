-- Giant Pig Statue — fiberglass-style oversized pig on a concrete pedestal.
-- Roadside-attraction vibe. Pink body, smiling face, chef's hat.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PIG_PINK   = Color3.fromRGB(245, 175, 180)
local PIG_DEEP   = Color3.fromRGB(215, 145, 150)
local SNOUT      = Color3.fromRGB(195, 130, 140)
local HOOF       = Color3.fromRGB(45, 35, 30)
local HAT_WHITE  = Color3.fromRGB(245, 240, 230)
local CONCRETE   = Color3.fromRGB(180, 175, 168)
local CONCRETE_D = Color3.fromRGB(135, 130, 125)
local EYE        = Color3.fromRGB(35, 25, 25)
local STRAW      = Color3.fromRGB(232, 200, 112)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GiantPigStatue", parent)

	-- Concrete pedestal (tiered)
	local base = AB.block(Vector3.new(16, 2, 12), CONCRETE_D, AB.offset(originCF, 0, 1, 0), model, "BaseLow")
	AB.block(Vector3.new(13, 1.6, 10), CONCRETE, AB.offset(originCF, 0, 2.8, 0), model, "BaseHigh")

	-- Plaque on the front of the pedestal
	local plaque = AB.block(Vector3.new(7, 2, 0.2), STRAW, AB.offset(originCF, 0, 1.8, 6.1), model, "Plaque")
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.LightInfluence = 0
	gui.Parent = plaque
	local lbl = Instance.new("TextLabel")
	lbl.Size              = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Font              = Enum.Font.GothamBlack
	lbl.Text              = "PIGGY THE PITMASTER"
	lbl.TextColor3        = Color3.fromRGB(140, 80, 50)
	lbl.TextScaled        = true
	lbl.Parent            = gui

	-- Pig body (big rounded blob)
	AB.sphere(10, PIG_PINK, AB.offset(originCF, 0, 9.5, 0), model, "Body")
	-- Slight belly droop
	AB.sphere(7.5, PIG_DEEP, AB.offset(originCF, 0, 7.5, 0.5), model, "Belly")

	-- Head (front)
	AB.sphere(5.5, PIG_PINK, AB.offset(originCF, 0, 11.5, 6.0), model, "Head")
	-- Snout
	AB.cylinder(2.4, 1.6, SNOUT, AB.offset(originCF, 0, 11.0, 9), model, "Snout")
	-- Snout nostrils
	AB.sphere(0.4, PIG_DEEP, AB.offset(originCF, -0.6, 11.0, 9.7), model, "NostrilL")
	AB.sphere(0.4, PIG_DEEP, AB.offset(originCF,  0.6, 11.0, 9.7), model, "NostrilR")
	-- Eyes (closed-happy crescents — use small black spheres)
	AB.sphere(0.5, EYE, AB.offset(originCF, -1.6, 12.6, 8.5), model, "EyeL")
	AB.sphere(0.5, EYE, AB.offset(originCF,  1.6, 12.6, 8.5), model, "EyeR")
	-- Smiling mouth (curved dark stripe)
	AB.block(Vector3.new(2, 0.3, 0.3), EYE, AB.offset(originCF, 0, 10.0, 9.3), model, "Mouth")
	-- Ears (triangular wedges flopped down)
	local earL = AB.wedge(Vector3.new(0.6, 1.8, 1.6), PIG_DEEP, AB.offset(originCF, -2.2, 14.2, 5.6), model, "EarL")
	earL.CFrame = earL.CFrame * CFrame.Angles(math.rad(-30), math.rad(-30), 0)
	local earR = AB.wedge(Vector3.new(0.6, 1.8, 1.6), PIG_DEEP, AB.offset(originCF, 2.2, 14.2, 5.6), model, "EarR")
	earR.CFrame = earR.CFrame * CFrame.Angles(math.rad(-30), math.rad(30), 0)

	-- Chef's hat on top
	AB.cylinder(3, 1, HAT_WHITE, AB.offset(originCF, 0, 15.6, 5.6), model, "HatBand")
	AB.sphere(4, HAT_WHITE, AB.offset(originCF, 0, 17.5, 5.6), model, "HatPoof")

	-- 4 stubby legs / hooves under the body
	for i, p in {Vector3.new(-3.5, 4.5, 3), Vector3.new(3.5, 4.5, 3), Vector3.new(-3.5, 4.5, -3), Vector3.new(3.5, 4.5, -3)} do
		AB.block(Vector3.new(2, 1.8, 2), PIG_PINK, originCF * CFrame.new(p), model, "Leg_" .. i)
		AB.block(Vector3.new(2.2, 0.5, 2.2), HOOF, originCF * CFrame.new(p) * CFrame.new(0, -1.05, 0), model, "Hoof_" .. i)
	end

	-- Curly tail (cluster of small spheres)
	for i = 1, 4 do
		local angle = (i / 4) * math.pi * 2
		AB.sphere(0.5, PIG_DEEP,
			AB.offset(originCF, math.cos(angle) * 0.6, 9 + i * 0.2, -5.5 + math.sin(angle) * 0.6),
			model, "Tail_" .. i)
	end

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
