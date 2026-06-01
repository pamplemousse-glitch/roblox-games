-- Pigeon Perches — a small iron rail with three pigeons perched on it.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local IRON      = Color3.fromRGB(40, 40, 45)
local PIG_GRY   = Color3.fromRGB(150, 150, 160)
local PIG_DK    = Color3.fromRGB(90, 90, 100)
local PIG_WHT   = Color3.fromRGB(245, 240, 230)
local BEAK      = Color3.fromRGB(220, 180, 100)
local FOOT      = Color3.fromRGB(180, 100, 70)

local function pigeon(model, originCF, x, y, z, name)
	-- Body (ellipse via sphere)
	AB.sphere(1.1, PIG_GRY, AB.offset(originCF, x, y + 0.55, z), model, name .. "_Body")
	-- Neck
	AB.sphere(0.45, PIG_GRY, AB.offset(originCF, x, y + 1.1, z + 0.25), model, name .. "_Neck")
	-- Head
	AB.sphere(0.5, PIG_DK, AB.offset(originCF, x, y + 1.45, z + 0.5), model, name .. "_Head")
	-- Beak
	AB.block(Vector3.new(0.18, 0.18, 0.4), BEAK,
		AB.offset(originCF, x, y + 1.4, z + 0.9), model, name .. "_Beak")
	-- Eyes (tiny dots)
	AB.sphere(0.08, Color3.fromRGB(20, 20, 25), AB.offset(originCF, x - 0.18, y + 1.5, z + 0.7), model, name .. "_EyeL")
	AB.sphere(0.08, Color3.fromRGB(20, 20, 25), AB.offset(originCF, x + 0.18, y + 1.5, z + 0.7), model, name .. "_EyeR")
	-- Tail (wedge)
	AB.wedge(Vector3.new(0.6, 0.4, 0.6), PIG_GRY,
		AB.offset(originCF, x, y + 0.5, z - 0.9), model, name .. "_Tail")
	-- White belly patch
	AB.block(Vector3.new(0.5, 0.4, 0.8), PIG_WHT,
		AB.offset(originCF, x, y + 0.4, z + 0.1), model, name .. "_Belly")
	-- Feet (orange sticks)
	AB.block(Vector3.new(0.1, 0.4, 0.1), FOOT,
		AB.offset(originCF, x - 0.15, y - 0.05, z), model, name .. "_FootL")
	AB.block(Vector3.new(0.1, 0.4, 0.1), FOOT,
		AB.offset(originCF, x + 0.15, y - 0.05, z), model, name .. "_FootR")
end

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("PigeonPerches", parent)

	-- Iron rail (post + horizontal bar)
	AB.block(Vector3.new(0.5, 4, 0.5), IRON, AB.offset(originCF, -3, 2, 0), model, "PostL")
	AB.block(Vector3.new(0.5, 4, 0.5), IRON, AB.offset(originCF,  3, 2, 0), model, "PostR")
	-- Decorative finials
	AB.sphere(0.4, Color3.fromRGB(200, 160, 80), AB.offset(originCF, -3, 4.2, 0), model, "FinialL")
	AB.sphere(0.4, Color3.fromRGB(200, 160, 80), AB.offset(originCF,  3, 4.2, 0), model, "FinialR")
	-- Horizontal bar
	AB.cylinder(0.3, 7, IRON,
		AB.offset(originCF, 0, 3.8, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Bar")
	-- Lower decorative scroll
	AB.cylinder(0.25, 6, IRON,
		AB.offset(originCF, 0, 2.5, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "BarLower")
	-- Iron scroll connectors
	for i, sx in {-1, 1} do
		AB.sphere(0.4, IRON, AB.offset(originCF, sx * 2.6, 3.1, 0), model, "Scroll_" .. i)
	end

	-- Three pigeons on the bar
	pigeon(model, originCF, -2, 4.0, 0, "Pigeon1")
	pigeon(model, originCF,  0, 4.0, 0, "Pigeon2")
	pigeon(model, originCF,  2, 4.0, 0, "Pigeon3")

	-- Some scattered breadcrumbs on the ground
	for i = 1, 6 do
		AB.sphere(0.15, BEAK,
			AB.offset(originCF, (math.random() - 0.5) * 5, 0.1, (math.random() - 0.5) * 3), model, "Crumb_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
