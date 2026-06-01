-- Red Check Tablecloth — a round red-checkered cloth bundle (or draped on
-- a small side stand). Useful as ambient floor/table decor.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local RED  = Color3.fromRGB(200, 40, 40)
local WHT  = Color3.fromRGB(245, 240, 230)
local WD   = Color3.fromRGB(80, 50, 30)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RedCheckTableCloth", parent)

	-- Small wood stand (round)
	AB.cylinder(2.4, 0.4, WD, AB.offset(originCF, 0, 0.2, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Stand")
	AB.cylinder(0.4, 1.5, WD, AB.offset(originCF, 0, 1, 0), model, "StandPost")
	AB.cylinder(2, 0.3, WD, AB.offset(originCF, 0, 1.85, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "StandTop")

	-- Tablecloth (draped square on top, slightly tilted)
	AB.block(Vector3.new(4, 0.25, 4), RED, AB.offset(originCF, 0, 2.1, 0), model, "ClothBase")
	-- Check pattern
	for i = -1, 1 do
		for j = -1, 1 do
			if (i + j) % 2 == 0 then
				AB.block(Vector3.new(1.2, 0.27, 1.2), WHT,
					AB.offset(originCF, i * 1.3, 2.12, j * 1.3), model, "Check_" .. (i + 2) .. j)
			end
		end
	end
	-- Drape over edges (4 sides)
	for k, info in {
		{x = 0, z = 2, sx = 4, sz = 0.3},
		{x = 0, z = -2, sx = 4, sz = 0.3},
		{x = 2, z = 0, sx = 0.3, sz = 4},
		{x = -2, z = 0, sx = 0.3, sz = 4},
	} do
		AB.block(Vector3.new(info.sx, 0.7, info.sz), RED,
			AB.offset(originCF, info.x, 1.6, info.z), model, "Drape_" .. k)
	end

	-- A small basket of breadsticks on top
	AB.block(Vector3.new(1.4, 0.6, 1), Color3.fromRGB(190, 140, 80), AB.offset(originCF, 0.8, 2.55, 0.5), model, "BasketTop")
	-- Breadsticks (cylinders)
	for i = 1, 3 do
		AB.cylinder(0.12, 1.5, Color3.fromRGB(220, 190, 130),
			AB.offset(originCF, 0.8 + (i - 2) * 0.2, 3.1, 0.5) * CFrame.Angles(math.rad(20), 0, 0), model, "Breadstick_" .. i)
	end

	-- Salt + pepper (two small cylinders)
	AB.cylinder(0.3, 0.6, WHT, AB.offset(originCF, -0.7, 2.6, -0.5), model, "Salt")
	AB.cylinder(0.3, 0.6, Color3.fromRGB(40, 40, 40), AB.offset(originCF, -1.3, 2.6, -0.5), model, "Pepper")
	-- Caps
	AB.cylinder(0.32, 0.1, Color3.fromRGB(200, 200, 210),
		AB.offset(originCF, -0.7, 2.95, -0.5) * CFrame.Angles(0, 0, math.rad(90)), model, "SaltCap")
	AB.cylinder(0.32, 0.1, Color3.fromRGB(200, 200, 210),
		AB.offset(originCF, -1.3, 2.95, -0.5) * CFrame.Angles(0, 0, math.rad(90)), model, "PepperCap")

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
