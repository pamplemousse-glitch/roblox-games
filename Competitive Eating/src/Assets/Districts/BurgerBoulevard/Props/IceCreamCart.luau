-- IceCreamCart — small white pushcart with pastel flavor signs and an umbrella.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("IceCreamCart", parent)
	local WHITE  = Color3.fromRGB(248, 248, 248)
	local PINK   = Color3.fromRGB(255, 200, 215)
	local YELLOW = Color3.fromRGB(255, 220, 130)
	local MINT   = Color3.fromRGB(180, 230, 200)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local DARK   = Color3.fromRGB(40, 40, 45)
	local RED    = Color3.fromRGB(220, 50, 50)
	local BROWN  = Color3.fromRGB(110, 60, 30)

	-- Cart body
	local body = AB.block(Vector3.new(4, 2.5, 2.5), WHITE, AB.offset(originCF, 0, 2.5, 0), model, "Body")
	body.Material = Enum.Material.SmoothPlastic
	-- Chrome rim around lid
	AB.block(Vector3.new(4.2, 0.3, 2.7), CHROME, AB.offset(originCF, 0, 3.85, 0), model, "RimTop")
	AB.block(Vector3.new(4.2, 0.3, 2.7), CHROME, AB.offset(originCF, 0, 1.4, 0), model, "RimBot")
	-- Flavor placard strip (3 pastel colors)
	AB.block(Vector3.new(1.3, 1.5, 0.2), PINK, AB.offset(originCF, -1.3, 2.5, 1.3), model, "PlaqueA")
	AB.block(Vector3.new(1.3, 1.5, 0.2), YELLOW, AB.offset(originCF, 0, 2.5, 1.3), model, "PlaqueB")
	AB.block(Vector3.new(1.3, 1.5, 0.2), MINT, AB.offset(originCF, 1.3, 2.5, 1.3), model, "PlaqueC")
	-- Open lid showing ice cream tubs
	for i = -1, 1 do
		AB.cylinder(0.9, 0.3, WHITE, AB.offset(originCF, i * 1.2, 3.95, 0), model, "Tub_" .. i)
		local scoopColor = (i == -1) and PINK or (i == 0) and YELLOW or BROWN
		AB.sphere(0.8, scoopColor, AB.offset(originCF, i * 1.2, 4.2, 0), model, "Scoop_" .. i)
	end

	-- Wheels
	AB.cylinder(1.4, 0.4, DARK, AB.offset(originCF, -1.5, 1, -1.5) * CFrame.Angles(0, math.rad(90), 0), model, "Wheel1")
	AB.cylinder(1.4, 0.4, DARK, AB.offset(originCF, -1.5, 1, 1.5) * CFrame.Angles(0, math.rad(90), 0), model, "Wheel2")
	AB.cylinder(1.4, 0.4, DARK, AB.offset(originCF, 1.5, 1, -1.5) * CFrame.Angles(0, math.rad(90), 0), model, "Wheel3")
	AB.cylinder(1.4, 0.4, DARK, AB.offset(originCF, 1.5, 1, 1.5) * CFrame.Angles(0, math.rad(90), 0), model, "Wheel4")

	-- Push handle
	AB.cylinder(0.2, 1.5, CHROME, AB.offset(originCF, -2.5, 4, 0), model, "Handle1")
	AB.cylinder(0.2, 2, CHROME, AB.offset(originCF, -3, 4.5, 0) * CFrame.Angles(0, 0, math.rad(60)), model, "Handle2")
	AB.cylinder(0.2, 2.4, CHROME, AB.offset(originCF, -3.5, 4, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "HandleBar")

	-- Umbrella pole
	AB.cylinder(0.2, 5, CHROME, AB.offset(originCF, 0, 6, 0), model, "UmbrellaPole")
	-- Umbrella (cone-shape via 4 wedges)
	local function umbrellaPanel(angle: number, color: Color3, idx: number)
		AB.wedge(Vector3.new(3, 1.5, 3), color, AB.offset(originCF, 0, 7.5, 0) * CFrame.Angles(0, math.rad(angle), 0) * CFrame.Angles(math.rad(-25), 0, 0), model, "Umb_" .. idx)
	end
	umbrellaPanel(0,   PINK, 1)
	umbrellaPanel(90,  WHITE, 2)
	umbrellaPanel(180, PINK, 3)
	umbrellaPanel(270, WHITE, 4)
	-- Umbrella top finial
	AB.sphere(0.4, RED, AB.offset(originCF, 0, 9, 0), model, "UmbrellaTop")
	-- Sign on side
	local sign = AB.block(Vector3.new(3, 0.6, 0.1), RED, AB.offset(originCF, 0, 1.5, 1.31), model, "Sign")
	AB.billboard(sign, "ICE CREAM", Vector2.new(140, 30), 0)

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
