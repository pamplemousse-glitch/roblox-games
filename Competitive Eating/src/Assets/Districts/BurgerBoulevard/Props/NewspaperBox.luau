-- NewspaperBox — coin-operated newspaper vending box, painted red with a glass front.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("NewspaperBox", parent)
	local RED    = Color3.fromRGB(255, 48, 48)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local CREAM  = Color3.fromRGB(255, 245, 232)
	local DARK   = Color3.fromRGB(40, 40, 45)
	local GLASS  = Color3.fromRGB(180, 220, 240)

	-- Legs
	AB.cylinder(0.4, 2.5, CHROME, AB.offset(originCF, -1, 1.25, -0.6), model, "LegFL")
	AB.cylinder(0.4, 2.5, CHROME, AB.offset(originCF,  1, 1.25, -0.6), model, "LegFR")
	AB.cylinder(0.4, 2.5, CHROME, AB.offset(originCF, -1, 1.25,  0.6), model, "LegBL")
	AB.cylinder(0.4, 2.5, CHROME, AB.offset(originCF,  1, 1.25,  0.6), model, "LegBR")
	-- Body (red box)
	local body = AB.block(Vector3.new(2.5, 3, 2), RED, AB.offset(originCF, 0, 3.5, 0), model, "Body")
	-- Glass front
	local glass = AB.block(Vector3.new(2, 1.5, 0.15), GLASS, AB.offset(originCF, 0, 3.5, 1.05), model, "GlassFront")
	glass.Material = Enum.Material.Glass; glass.Transparency = 0.35
	-- Newspaper inside (cream block)
	AB.block(Vector3.new(1.5, 1.2, 0.4), CREAM, AB.offset(originCF, 0, 3.5, 0.7), model, "Paper")
	AB.block(Vector3.new(1.5, 0.3, 0.45), DARK, AB.offset(originCF, 0, 4, 0.7), model, "PaperHeadline")
	-- Coin slot
	AB.block(Vector3.new(0.5, 0.1, 0.1), CHROME, AB.offset(originCF, 0, 2.6, 1.05), model, "CoinSlot")
	-- Handle
	AB.cylinder(0.2, 1, CHROME, AB.offset(originCF, 0, 2.2, 1.1) * CFrame.Angles(0, 0, math.rad(90)), model, "Handle")
	-- Top sign
	local sign = AB.block(Vector3.new(2.5, 0.6, 0.3), CREAM, AB.offset(originCF, 0, 5.3, 0), model, "TopSign")
	AB.billboard(sign, "DAILY 5¢", Vector2.new(80, 30), 0)
	-- Body trim
	AB.block(Vector3.new(2.6, 0.2, 2.1), CHROME, AB.offset(originCF, 0, 4.9, 0), model, "TrimTop")
	AB.block(Vector3.new(2.6, 0.2, 2.1), CHROME, AB.offset(originCF, 0, 2.2, 0), model, "TrimBot")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
