-- ParkingMeter — classic mechanical parking meter on a chrome pole.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("ParkingMeter", parent)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local DARK   = Color3.fromRGB(50, 50, 55)
	local YELLOW = Color3.fromRGB(245, 220, 80)
	local RED    = Color3.fromRGB(255, 60, 60)
	local GLASS  = Color3.fromRGB(200, 230, 250)

	-- Pole
	local pole = AB.cylinder(0.5, 5.5, CHROME, AB.offset(originCF, 0, 2.75, 0), model, "Pole")
	pole.Material = Enum.Material.Metal
	-- Head body
	AB.block(Vector3.new(1.8, 2.5, 1.4), CHROME, AB.offset(originCF, 0, 6.5, 0), model, "Head")
	-- Glass dome on top
	local glass = AB.sphere(1.8, GLASS, AB.offset(originCF, 0, 8, 0), model, "Dome")
	glass.Material = Enum.Material.Glass; glass.Transparency = 0.35
	-- Display dial inside
	AB.cylinder(1.4, 0.3, YELLOW, AB.offset(originCF, 0, 8, 0.1) * CFrame.Angles(0, math.rad(90), 0), model, "Dial")
	-- Time indicator needle
	AB.block(Vector3.new(0.1, 1, 0.1), RED, AB.offset(originCF, 0, 8.3, 0.2) * CFrame.Angles(0, 0, math.rad(20)), model, "Needle")
	-- "EXPIRED" flag (slot on side)
	AB.block(Vector3.new(0.3, 0.6, 0.6), RED, AB.offset(originCF, 1, 8, 0), model, "ExpFlag")
	-- Coin slot on head
	AB.block(Vector3.new(0.05, 0.3, 0.5), DARK, AB.offset(originCF, 0.95, 6.5, 0), model, "CoinSlot")
	-- Footing
	AB.cylinder(0.8, 0.4, DARK, AB.offset(originCF, 0, 0.2, 0), model, "Footing")

	AB.pivot(model, pole)
	AB.weldAll(model)
	return model
end
