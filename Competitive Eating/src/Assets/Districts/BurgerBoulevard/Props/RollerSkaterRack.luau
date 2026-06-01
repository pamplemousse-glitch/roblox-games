-- RollerSkaterRack — display rack of roller-skates (the carhop waitress kind).
-- A wood + chrome cubby rack with 6 pairs of white-and-red skates on display.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("RollerSkaterRack", parent)

	local WOOD   = Color3.fromRGB(140, 90, 50)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local WHITE  = Color3.fromRGB(245, 245, 240)
	local RED    = Color3.fromRGB(255, 48, 48)
	local DARK   = Color3.fromRGB(40, 30, 25)
	local CREAM  = Color3.fromRGB(255, 245, 232)

	-- Rack cabinet
	local cabinet = AB.block(Vector3.new(6, 6, 1.5), WOOD, AB.offset(originCF, 0, 3, 0), model, "Cabinet")
	cabinet.Material = Enum.Material.WoodPlanks
	-- Back panel
	AB.block(Vector3.new(6, 6, 0.1), DARK, AB.offset(originCF, 0, 3, -0.7), model, "BackPanel")
	-- Cubby dividers (3 horizontal shelves × 2 vertical = 6 cubbies)
	for i = 1, 3 do
		AB.block(Vector3.new(6, 0.1, 1.4), WOOD, AB.offset(originCF, 0, i * 1.5, 0), model, "Shelf_" .. i)
	end
	AB.block(Vector3.new(0.1, 6, 1.4), WOOD, AB.offset(originCF, 0, 3, 0), model, "VertDivider")

	-- Each cubby has a pair of skates
	for row = 0, 2 do
		for col = 0, 1 do
			local x = col == 0 and -1.5 or 1.5
			local y = 0.75 + row * 1.5
			-- Skate body (boot)
			AB.block(Vector3.new(1, 0.8, 1), WHITE, AB.offset(originCF, x, y, 0.2), model, "SkateBoot_" .. row .. "_" .. col)
			-- Red top trim
			AB.block(Vector3.new(1.05, 0.2, 1.05), RED, AB.offset(originCF, x, y + 0.4, 0.2), model, "SkateTrim_" .. row .. "_" .. col)
			-- Skate wheels (4 tiny cylinders below)
			for w = 0, 3 do
				local wx = x + ((w % 2 == 0) and -0.3 or 0.3)
				local wz = 0.2 + ((w < 2) and -0.3 or 0.3)
				AB.cylinder(0.3, 0.2, DARK, AB.offset(originCF, wx, y - 0.6, wz) * CFrame.Angles(0, math.rad(90), 0), model, "SkateWheel_" .. row .. "_" .. col .. "_" .. w)
			end
			-- Laces (white line)
			AB.block(Vector3.new(0.05, 0.4, 0.4), CHROME, AB.offset(originCF, x, y + 0.1, 0.6), model, "SkateLace_" .. row .. "_" .. col)
		end
	end

	-- Topper / signage
	AB.block(Vector3.new(6.4, 1, 1.6), RED, AB.offset(originCF, 0, 6.5, 0), model, "Topper")
	local sign = AB.block(Vector3.new(5, 0.6, 0.3), CREAM, AB.offset(originCF, 0, 6.5, 0.8), model, "SignFace")
	AB.billboard(sign, "SKATES", Vector2.new(180, 40), 0)

	-- Chrome trim
	AB.block(Vector3.new(6.2, 0.3, 1.6), CHROME, AB.offset(originCF, 0, 5.85, 0), model, "CabTrimT")
	AB.block(Vector3.new(6.2, 0.3, 1.6), CHROME, AB.offset(originCF, 0, 0.15, 0), model, "CabTrimB")

	AB.pivot(model, cabinet)
	AB.weldAll(model)
	return model
end
