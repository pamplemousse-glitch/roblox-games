-- BicycleCruiser — 50s cruiser bike with white-walled tires + a basket.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BicycleCruiser", parent)
	local TEAL   = Color3.fromRGB(127, 202, 194)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local WHITE  = Color3.fromRGB(245, 245, 240)
	local DARK   = Color3.fromRGB(40, 40, 45)
	local WICKER = Color3.fromRGB(220, 180, 130)

	-- Wheels
	AB.cylinder(2.4, 0.4, DARK, AB.offset(originCF, -1.8, 1.2, 0) * CFrame.Angles(0, math.rad(90), 0), model, "WheelR")
	AB.cylinder(2.0, 0.5, WHITE, AB.offset(originCF, -1.8, 1.2, 0) * CFrame.Angles(0, math.rad(90), 0), model, "WhitewallR")
	AB.cylinder(0.6, 0.6, CHROME, AB.offset(originCF, -1.8, 1.2, 0) * CFrame.Angles(0, math.rad(90), 0), model, "HubR")
	AB.cylinder(2.4, 0.4, DARK, AB.offset(originCF, 1.8, 1.2, 0) * CFrame.Angles(0, math.rad(90), 0), model, "WheelF")
	AB.cylinder(2.0, 0.5, WHITE, AB.offset(originCF, 1.8, 1.2, 0) * CFrame.Angles(0, math.rad(90), 0), model, "WhitewallF")
	AB.cylinder(0.6, 0.6, CHROME, AB.offset(originCF, 1.8, 1.2, 0) * CFrame.Angles(0, math.rad(90), 0), model, "HubF")

	-- Spokes (8 thin lines per wheel)
	for i = 0, 7 do
		local angle = (i / 8) * 2 * math.pi
		AB.block(Vector3.new(2.2, 0.05, 0.05), CHROME, AB.offset(originCF, -1.8, 1.2, 0) * CFrame.Angles(0, math.rad(angle), 0) * CFrame.Angles(0, 0, math.rad(90)), model, "SpokeR_" .. i)
	end

	-- Frame top tube (teal)
	AB.cylinder(0.3, 4, TEAL, AB.offset(originCF, 0, 2.5, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "TopTube")
	-- Down tube
	AB.cylinder(0.3, 3.5, TEAL, AB.offset(originCF, 0, 1.8, 0) * CFrame.Angles(0, 0, math.rad(80)), model, "DownTube")
	-- Seat tube
	AB.cylinder(0.3, 2, TEAL, AB.offset(originCF, -1, 2.2, 0), model, "SeatTube")
	-- Saddle (white)
	AB.block(Vector3.new(1, 0.3, 0.5), WHITE, AB.offset(originCF, -1, 3.4, 0), model, "Saddle")
	-- Handlebars
	AB.cylinder(0.2, 2, CHROME, AB.offset(originCF, 1.8, 3.5, 0) * CFrame.Angles(0, math.rad(90), 0), model, "Handlebars")
	-- Stem
	AB.cylinder(0.3, 1.5, CHROME, AB.offset(originCF, 1.8, 3, 0), model, "Stem")
	-- Pedals/crank
	AB.cylinder(0.5, 0.3, CHROME, AB.offset(originCF, 0, 1.4, 0) * CFrame.Angles(0, math.rad(90), 0), model, "Crank")
	AB.block(Vector3.new(0.7, 0.2, 0.3), DARK, AB.offset(originCF, 0.3, 1.1, 0.3), model, "PedalR")
	AB.block(Vector3.new(0.7, 0.2, 0.3), DARK, AB.offset(originCF, -0.3, 1.1, -0.3), model, "PedalL")

	-- Wicker basket
	AB.block(Vector3.new(1.5, 1.2, 1.2), WICKER, AB.offset(originCF, 2.4, 3.5, 0), model, "Basket")
	AB.block(Vector3.new(1.6, 0.1, 1.3), DARK, AB.offset(originCF, 2.4, 2.95, 0), model, "BasketBottom")

	-- Bell on handlebars
	AB.sphere(0.3, CHROME, AB.offset(originCF, 1.4, 3.6, 0.6), model, "Bell")

	-- Front fender
	AB.block(Vector3.new(0.4, 0.3, 2), CHROME, AB.offset(originCF, 1.8, 2.5, 0) * CFrame.Angles(0, math.rad(90), 0), model, "FrontFender")
	-- Rear fender
	AB.block(Vector3.new(0.4, 0.3, 2), CHROME, AB.offset(originCF, -1.8, 2.5, 0) * CFrame.Angles(0, math.rad(90), 0), model, "RearFender")

	AB.pivot(model, model:FindFirstChild("TopTube"))
	AB.weldAll(model)
	return model
end
