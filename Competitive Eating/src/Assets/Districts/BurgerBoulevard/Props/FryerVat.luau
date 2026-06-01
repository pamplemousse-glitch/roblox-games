-- FryerVat — commercial deep-fryer station: chrome basin, basket, controls.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("FryerVat", parent)

	local CHROME = Color3.fromRGB(176, 176, 176)
	local OIL    = Color3.fromRGB(180, 150, 80)
	local DARK   = Color3.fromRGB(50, 50, 55)
	local CREAM  = Color3.fromRGB(255, 245, 232)
	local RED    = Color3.fromRGB(255, 48, 48)
	local STEAM  = Color3.fromRGB(220, 220, 220)

	-- Body (the cabinet under the fryer)
	local body = AB.block(Vector3.new(4, 4, 3), CHROME, AB.offset(originCF, 0, 2, 0), model, "FryerBody")
	body.Material = Enum.Material.Metal
	-- Toe-kick
	AB.block(Vector3.new(3.8, 0.6, 2.8), DARK, AB.offset(originCF, 0, 0.3, 0), model, "ToeKick")
	-- Top fryer rim / drip rail
	AB.block(Vector3.new(4.2, 0.3, 3.2), CHROME, AB.offset(originCF, 0, 4.05, 0), model, "Rim")

	-- Two oil vats (square recessed)
	local vatL = AB.block(Vector3.new(1.5, 0.3, 2.4), OIL, AB.offset(originCF, -0.9, 4.2, 0), model, "OilL")
	vatL.Material = Enum.Material.Plastic
	local vatR = AB.block(Vector3.new(1.5, 0.3, 2.4), OIL, AB.offset(originCF, 0.9, 4.2, 0), model, "OilR")
	vatR.Material = Enum.Material.Plastic

	-- Fryer basket handles (chrome bars sticking up out of each vat)
	AB.cylinder(0.2, 1.5, CHROME, AB.offset(originCF, -0.9, 5, 1), model, "HandleL")
	AB.block(Vector3.new(0.5, 0.2, 0.5), DARK, AB.offset(originCF, -0.9, 5.6, 1), model, "HandleLGrip")
	AB.cylinder(0.2, 1.5, CHROME, AB.offset(originCF, 0.9, 5, 1), model, "HandleR")
	AB.block(Vector3.new(0.5, 0.2, 0.5), DARK, AB.offset(originCF, 0.9, 5.6, 1), model, "HandleRGrip")

	-- Control panel (front face)
	AB.block(Vector3.new(3.5, 1.5, 0.2), CREAM, AB.offset(originCF, 0, 2.5, 1.55), model, "Panel")
	-- Two red dial knobs
	AB.cylinder(0.5, 0.3, RED, AB.offset(originCF, -1, 2.5, 1.7), model, "DialL")
	AB.cylinder(0.5, 0.3, RED, AB.offset(originCF, 1, 2.5, 1.7), model, "DialR")
	-- Small LED-like indicators
	local led1 = AB.sphere(0.2, Color3.fromRGB(80, 255, 100), AB.offset(originCF, 0, 2.9, 1.7), model, "LED1")
	AB.neon(led1); AB.glow(led1, Color3.fromRGB(80, 255, 100), 0.6)
	local led2 = AB.sphere(0.2, RED, AB.offset(originCF, 0, 2.5, 1.7), model, "LED2")
	AB.neon(led2); AB.glow(led2, RED, 0.6)

	-- "FRYER" small label
	local label = AB.block(Vector3.new(2, 0.4, 0.2), DARK, AB.offset(originCF, 0, 2.05, 1.7), model, "Label")
	AB.billboard(label, "FRYER", Vector2.new(80, 30), 0)

	-- Steam cylinder rising (visual hint, opaque sphere stack)
	for i = 1, 3 do
		local s = AB.sphere(0.8 + i * 0.2, STEAM, AB.offset(originCF, -0.9, 5.5 + i * 0.7, 0), model, "SteamL_" .. i)
		s.Material = Enum.Material.SmoothPlastic
		s.Transparency = 0.5 + i * 0.1
	end
	for i = 1, 3 do
		local s = AB.sphere(0.8 + i * 0.2, STEAM, AB.offset(originCF, 0.9, 5.5 + i * 0.7, 0), model, "SteamR_" .. i)
		s.Material = Enum.Material.SmoothPlastic
		s.Transparency = 0.5 + i * 0.1
	end

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
