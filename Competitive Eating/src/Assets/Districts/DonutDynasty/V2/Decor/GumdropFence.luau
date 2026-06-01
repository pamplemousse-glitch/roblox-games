-- GumdropFence — short decorative fence run made of alternating
-- gumdrop posts (pink, mint, cream) with cream rails.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CREAM  = Color3.fromRGB(255, 240, 220)
local MINT   = Color3.fromRGB(180, 230, 200)
local GOLD   = Color3.fromRGB(212, 168, 82)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("GumdropFence", parent)

	local count = 6
	local spacing = 4
	local colors = {DEEP, MINT, PINK, MINT, DEEP, CREAM}

	-- Rails (top and bottom)
	local rail1 = AB.block(Vector3.new(count * spacing, 0.3, 0.4), CREAM,
		AB.offset(originCF, (count * spacing) / 2 - spacing / 2, 0.8, 0), model, "BotRail")
	AB.block(Vector3.new(count * spacing, 0.3, 0.4), CREAM,
		AB.offset(originCF, (count * spacing) / 2 - spacing / 2, 2.4, 0), model, "TopRail")

	-- Posts with gumdrops on top
	for i = 1, count do
		local x = (i - 1) * spacing
		local col = colors[((i - 1) % #colors) + 1]
		-- Post (cream)
		AB.block(Vector3.new(0.5, 3, 0.5), CREAM,
			AB.offset(originCF, x, 1.5, 0), model, "Post_" .. i)
		-- Gumdrop topper
		AB.sphere(1.2, col, AB.offset(originCF, x, 3.4, 0), model, "Gumdrop_" .. i)
		AB.cylinder(1.2, 0.2, col, AB.offset(originCF, x, 3, 0), model, "GumdropBase_" .. i)
		-- Sugar speckle
		AB.sphere(0.15, CREAM, AB.offset(originCF, x + 0.3, 3.7, 0.3), model, "Speckle_" .. i)
	end

	-- End caps (gold)
	AB.sphere(0.7, GOLD, AB.offset(originCF, -0.5, 1.6, 0), model, "CapL")
	AB.sphere(0.7, GOLD, AB.offset(originCF, (count - 1) * spacing + 0.5, 1.6, 0), model, "CapR")

	AB.pivot(model, rail1)
	AB.weldAll(model)
	return model
end
