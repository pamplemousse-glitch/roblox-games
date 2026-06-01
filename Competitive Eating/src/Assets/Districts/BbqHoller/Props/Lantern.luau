-- Lantern — black wrought-iron pole lantern with a glowing ember flame inside.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local IRON      = Color3.fromRGB(35, 30, 28)
local GLASS     = Color3.fromRGB(180, 220, 230)
local EMBER     = Color3.fromRGB(255, 128, 48)
local STRAW     = Color3.fromRGB(232, 200, 112)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Lantern", parent)

	-- Base
	local base = AB.cylinder(1.4, 0.5, IRON, AB.offset(originCF, 0, 0.25, 0), model, "Base")
	-- Pole
	AB.block(Vector3.new(0.3, 8, 0.3), IRON, AB.offset(originCF, 0, 4.3, 0), model, "Pole")

	-- Lantern cage (glass + frame)
	-- Top cap
	AB.block(Vector3.new(1.6, 0.3, 1.6), IRON, AB.offset(originCF, 0, 10.0, 0), model, "TopCap")
	AB.wedge(Vector3.new(1.6, 0.6, 1.6), IRON, AB.offset(originCF, 0, 10.5, 0), model, "TopPyr")
	-- Glass box (transparent)
	local glass = AB.block(Vector3.new(1.3, 2, 1.3), GLASS, AB.offset(originCF, 0, 8.8, 0), model, "Glass")
	glass.Transparency = 0.5
	glass.Reflectance  = 0.15
	-- Bottom cap
	AB.block(Vector3.new(1.6, 0.3, 1.6), IRON, AB.offset(originCF, 0, 7.75, 0), model, "BotCap")
	-- Four corner posts of cage
	for i, p in {Vector3.new(0.65, 8.8, 0.65), Vector3.new(-0.65, 8.8, 0.65), Vector3.new(0.65, 8.8, -0.65), Vector3.new(-0.65, 8.8, -0.65)} do
		AB.block(Vector3.new(0.1, 2.4, 0.1), IRON, originCF * CFrame.new(p), model, "Post_" .. i)
	end

	-- Flame inside
	local flame = AB.sphere(0.7, EMBER, AB.offset(originCF, 0, 8.6, 0), model, "Flame")
	AB.neon(flame)
	AB.glow(flame, STRAW, 3)
	flame.Transparency = 0.1
	-- Small inner glow
	local glow = AB.sphere(0.3, STRAW, AB.offset(originCF, 0, 8.9, 0), model, "FlameCore")
	AB.neon(glow)

	-- Hanging hook above the cap (decorative arc)
	AB.block(Vector3.new(0.2, 1, 0.2), IRON, AB.offset(originCF, 0, 11.4, 0), model, "Hook")

	AB.pivot(model, base)
	AB.weldAll(model)
	return model
end
