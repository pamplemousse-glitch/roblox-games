-- American Flag Bunting — three half-circle swags (red/white/blue panels)
-- strung between two short posts like 4th-of-July porch decoration.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local FLAG_RED   = Color3.fromRGB(180, 30, 40)
local FLAG_WHITE = Color3.fromRGB(240, 235, 225)
local FLAG_BLUE  = Color3.fromRGB(30, 50, 110)
local POST       = Color3.fromRGB(70, 45, 22)
local STAR       = Color3.fromRGB(245, 240, 220)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("AmericanFlagBunting", parent)

	-- Two end posts
	local postL = AB.block(Vector3.new(0.4, 6, 0.4), POST, AB.offset(originCF, -6, 3, 0), model, "PostL")
	AB.block(Vector3.new(0.4, 6, 0.4), POST, AB.offset(originCF,  6, 3, 0), model, "PostR")
	-- Top rail (horizontal)
	AB.block(Vector3.new(13, 0.3, 0.3), POST, AB.offset(originCF, 0, 5.9, 0), model, "TopRail")

	-- Three half-circle swag panels (color blue/white/red, left→right)
	local colors = {FLAG_BLUE, FLAG_WHITE, FLAG_RED}
	for s = 1, 3 do
		local cx = -4 + (s - 1) * 4
		local col = colors[s]
		-- Build a half-circle from 5 wedges around an arc
		for i = 1, 5 do
			local angle = (math.pi / 5) * (i - 0.5)
			local r = 1.4
			local x = cx + math.cos(angle - math.pi / 2) * r
			local y = 4.5 - math.sin(angle - math.pi / 2) * r
			local block = AB.block(Vector3.new(0.9, 0.9, 0.2), col, AB.offset(originCF, x, y, 0), model, "Swag_" .. s .. "_" .. i)
			block.CFrame = block.CFrame * CFrame.Angles(0, 0, math.pi / 2 - angle)
		end
		-- White stars on the blue panels (just dots)
		if col == FLAG_BLUE then
			for j, p in {Vector3.new(-0.5, 3.8, 0.15), Vector3.new(0.3, 3.6, 0.15), Vector3.new(-0.2, 4.2, 0.15)} do
				local star = AB.sphere(0.18, STAR, originCF * CFrame.new(p + Vector3.new(cx, 0, 0)), model, "Star_" .. s .. "_" .. j)
				star.Material = Enum.Material.Neon
			end
		end
	end

	AB.pivot(model, postL)
	AB.weldAll(model)
	return model
end
