-- Broom and Dustpan — leaned against a small dirt-sweeping pile. Bamboo broom
-- handle, straw bristles, metal dustpan, and a small pile of dust+leaves.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local BAMBOO      = Color3.fromRGB(140, 180, 100)
local STRAW       = Color3.fromRGB(230, 200, 140)
local STRAW_DARK  = Color3.fromRGB(180, 150, 100)
local METAL_GREY  = Color3.fromRGB(110, 110, 120)
local DARK_METAL  = Color3.fromRGB(55, 55, 65)
local DUST        = Color3.fromRGB(120, 110, 90)
local LEAF_BROWN  = Color3.fromRGB(140, 90, 50)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("BroomAndDustpan", parent)

	-- Broom handle (bamboo, leaning at angle)
	AB.cylinder(0.25, 6, BAMBOO,
		AB.offset(originCF, 0.4, 3, 0) * CFrame.Angles(math.rad(15), 0, 0),
		model, "BroomHandle")
	-- Handle bamboo ring
	AB.cylinder(0.3, 0.15, STRAW_DARK,
		AB.offset(originCF, 0.4, 4.5, -0.4), model, "HandleRing")

	-- Broom binding (rope wrap)
	AB.cylinder(0.4, 0.35, STRAW_DARK,
		AB.offset(originCF, 0.4, 1.6, 0.55) * CFrame.Angles(math.rad(15), 0, 0),
		model, "Binding")

	-- Broom bristles (fan of 5 thin straws)
	for i = 1, 5 do
		local dx = (i - 3) * 0.18
		AB.block(Vector3.new(0.08, 1.4, 0.08), STRAW,
			AB.offset(originCF, 0.4 + dx, 0.9, 0.7) * CFrame.Angles(math.rad(15 + (i - 3) * 4), 0, 0),
			model, "Bristle_" .. i)
	end

	-- Dustpan (flat tray with raised back, leaning beside broom)
	AB.block(Vector3.new(1.6, 0.1, 1.4), METAL_GREY,
		AB.offset(originCF, -1.4, 0.2, 0), model, "DustpanFloor")
	AB.block(Vector3.new(1.6, 0.8, 0.1), DARK_METAL,
		AB.offset(originCF, -1.4, 0.6, -0.65), model, "DustpanBack")
	-- Dustpan handle
	AB.cylinder(0.15, 1.4, DARK_METAL,
		AB.offset(originCF, -1.4, 1.2, -0.65) * CFrame.Angles(math.rad(-30), 0, 0),
		model, "DustpanHandle")

	-- Small dust pile inside the dustpan
	AB.sphere(0.5, DUST, AB.offset(originCF, -1.4, 0.4, -0.1), model, "DustPile")

	-- Few leaves on the ground
	for i, offset in {
		Vector3.new(-0.5, 0.05, 1.2),
		Vector3.new(0.8, 0.05, -0.8),
		Vector3.new(-1.0, 0.05, 1.5),
		Vector3.new(0.2, 0.05, 1.8),
	} do
		AB.block(Vector3.new(0.4, 0.05, 0.3), LEAF_BROWN,
			AB.offset(originCF, offset.X, offset.Y, offset.Z),
			model, "Leaf_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
