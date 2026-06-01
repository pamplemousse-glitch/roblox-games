-- Dried Corn Husk — a bundle of dried corn stalks tied at the top, leaned
-- against the ground (autumn-decor style).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local STALK_TAN  = Color3.fromRGB(195, 165, 100)
local STALK_DARK = Color3.fromRGB(150, 120, 70)
local LEAF       = Color3.fromRGB(170, 140, 80)
local LEAF_DARK  = Color3.fromRGB(130, 105, 60)
local TWINE      = Color3.fromRGB(120, 100, 70)
local CORN       = Color3.fromRGB(220, 180, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DriedCornHusk", parent)

	-- 6 stalks bundled, leaning slightly
	local stalkCount = 6
	local stalks = {}
	for i = 1, stalkCount do
		local angle = (i / stalkCount) * math.pi * 2
		local r = 0.35
		local x = math.cos(angle) * r
		local z = math.sin(angle) * r
		local lean = math.rad(8)
		local stalk = AB.block(Vector3.new(0.3, 7, 0.3), (i % 2 == 0) and STALK_TAN or STALK_DARK,
			AB.offset(originCF, x, 3.5, z),
			model, "Stalk_" .. i)
		stalk.CFrame = stalk.CFrame * CFrame.Angles(lean * math.cos(angle), 0, lean * math.sin(angle))
		table.insert(stalks, stalk)
	end

	-- Bundle twine near the top
	AB.block(Vector3.new(1.2, 0.3, 1.2), TWINE, AB.offset(originCF, 0, 5.8, 0), model, "Twine")

	-- Drooping leaves at mid-height
	for i = 1, 4 do
		local angle = (i / 4) * math.pi * 2
		local leaf = AB.block(Vector3.new(0.15, 2.2, 0.7), (i % 2 == 0) and LEAF or LEAF_DARK,
			AB.offset(originCF, math.cos(angle) * 0.7, 3.2, math.sin(angle) * 0.7),
			model, "Leaf_" .. i)
		leaf.CFrame = leaf.CFrame * CFrame.Angles(math.rad(35), -angle, 0)
	end

	-- Two ears of corn peeking out (yellow tubular blocks)
	for i, p in {Vector3.new(-0.5, 2.0, 0.4), Vector3.new(0.4, 1.7, -0.5)} do
		AB.block(Vector3.new(0.5, 1.4, 0.6), CORN, originCF * CFrame.new(p), model, "Ear_" .. i)
	end

	AB.pivot(model, stalks[1])
	AB.weldAll(model)
	return model
end
