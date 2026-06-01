-- PhoneBoothBubble — bubble-style phone booth: a glass dome over a small platform
-- with a wall-mounted phone and chrome trim.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PhoneBoothBubble", parent)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local CREAM  = Color3.fromRGB(255, 245, 232)
	local GLASS  = Color3.fromRGB(200, 230, 250)
	local DARK   = Color3.fromRGB(40, 40, 45)
	local RED    = Color3.fromRGB(220, 50, 50)
	local YELLOW = Color3.fromRGB(245, 220, 80)
	local TEAL   = Color3.fromRGB(127, 202, 194)

	-- Floor pad
	AB.cylinder(3, 0.4, DARK, AB.offset(originCF, 0, 0.2, 0), model, "FloorPad")
	-- Back panel (where the phone mounts)
	local back = AB.block(Vector3.new(2.5, 6, 0.4), CREAM, AB.offset(originCF, 0, 3.4, -1.4), model, "BackPanel")
	-- Phone box
	AB.block(Vector3.new(1.6, 1.8, 0.6), DARK, AB.offset(originCF, 0, 3.5, -1.1), model, "PhoneBody")
	-- Handset
	AB.cylinder(0.25, 1.4, DARK, AB.offset(originCF, 0, 4.5, -0.8) * CFrame.Angles(0, 0, math.rad(90)), model, "Handset")
	-- Cord (coiled)
	AB.block(Vector3.new(0.15, 0.8, 0.15), DARK, AB.offset(originCF, 0, 3.8, -0.85), model, "Cord")
	-- Coin slot
	AB.block(Vector3.new(0.4, 0.15, 0.1), CHROME, AB.offset(originCF, 0.5, 3.5, -1.05), model, "CoinSlot")
	-- Dial face
	AB.cylinder(0.7, 0.2, CHROME, AB.offset(originCF, 0, 3.3, -0.8) * CFrame.Angles(0, math.rad(90), 0), model, "Dial")
	-- Phone book / directory
	AB.block(Vector3.new(1.2, 0.2, 0.6), YELLOW, AB.offset(originCF, 0, 2.5, -1.1), model, "PhoneBook")

	-- Bubble glass dome (transparent half-sphere effect via large sphere with low transparency)
	local dome = AB.sphere(5, GLASS, AB.offset(originCF, 0, 4, 0.5), model, "Dome")
	dome.Material = Enum.Material.Glass
	dome.Transparency = 0.55
	dome.Reflectance = 0.2

	-- Dome chrome rim
	AB.cylinder(5, 0.4, CHROME, AB.offset(originCF, 0, 1.5, 0) * CFrame.Angles(0, math.rad(90), 0), model, "DomeRim")

	-- Roof support (chrome arc visible)
	AB.block(Vector3.new(0.4, 6, 0.4), CHROME, AB.offset(originCF, -2.2, 3.4, -1), model, "ArchL")
	AB.block(Vector3.new(0.4, 6, 0.4), CHROME, AB.offset(originCF,  2.2, 3.4, -1), model, "ArchR")

	-- "TELEPHONE" sign on top
	local sign = AB.block(Vector3.new(3, 0.8, 0.3), CHROME, AB.offset(originCF, 0, 6.6, 0), model, "TopSign")
	local signNeon = AB.block(Vector3.new(2.6, 0.5, 0.4), TEAL, AB.offset(originCF, 0, 6.6, 0.1), model, "TopSignNeon")
	AB.neon(signNeon); AB.glow(signNeon, TEAL, 1.5)
	AB.billboard(sign, "TELEPHONE", Vector2.new(140, 30), 0)

	AB.pivot(model, model:FindFirstChild("FloorPad"))
	AB.weldAll(model)
	return model
end
