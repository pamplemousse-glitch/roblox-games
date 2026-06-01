-- Salsa Cart — small pushcart with 3 dispensers (green tomatillo / red /
-- brown mole) and a striped awning. Two big spoked wheels.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local TERRACOTTA  = Color3.fromRGB(196, 95, 44)
local FIESTA_YEL  = Color3.fromRGB(255, 184, 52)
local PAPEL_GREEN = Color3.fromRGB(93, 168, 85)
local AGAVE_TEAL  = Color3.fromRGB(43, 140, 156)
local WOOD_LIGHT  = Color3.fromRGB(190, 145, 90)
local WHEEL_DARK  = Color3.fromRGB(60, 40, 25)
local MOLE_BROWN  = Color3.fromRGB(85, 50, 30)
local SALSA_RED   = Color3.fromRGB(200, 55, 45)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SalsaCart", parent)

	-- Cart bed
	local body = AB.block(
		Vector3.new(8, 3, 4),
		WOOD_LIGHT,
		AB.offset(originCF, 0, 3.5, 0),
		model,
		"CartBody"
	)
	-- Painted side panel (terracotta band)
	AB.block(Vector3.new(8.05, 1.2, 4.05), TERRACOTTA,
		AB.offset(originCF, 0, 2.5, 0), model, "PaintBand")

	-- Top surface (counter)
	AB.block(Vector3.new(8.2, 0.3, 4.2), Color3.fromRGB(230, 210, 170),
		AB.offset(originCF, 0, 5.15, 0), model, "CounterTop")

	-- Three dispenser jugs on top (green / red / brown)
	for i, salsa in {
		{x = -2.5, color = PAPEL_GREEN, name = "Verde"},
		{x =  0.0, color = SALSA_RED,   name = "Rojo"},
		{x =  2.5, color = MOLE_BROWN,  name = "Mole"},
	} do
		-- Jug body
		AB.cylinder(1.8, 2.2, salsa.color,
			AB.offset(originCF, salsa.x, 6.3, 0), model, "Jug_" .. salsa.name)
		-- Lid
		AB.cylinder(2.0, 0.3, Color3.fromRGB(180, 180, 180),
			AB.offset(originCF, salsa.x, 7.5, 0), model, "Lid_" .. salsa.name)
		-- Spout
		AB.part({
			size  = Vector3.new(0.5, 0.5, 1.2),
			color = Color3.fromRGB(160, 160, 160),
			cf    = AB.offset(originCF, salsa.x, 6.3, 1.4),
			name  = "Spout_" .. salsa.name,
		}, model)
	end

	-- Striped awning above
	for i, x in {-3.6, -1.2, 1.2, 3.6} do
		AB.block(Vector3.new(2, 0.3, 5),
			(i % 2 == 0) and FIESTA_YEL or AGAVE_TEAL,
			AB.offset(originCF, x, 9, 0), model, "AwningStripe_" .. i)
	end
	-- Awning posts
	for i, pos in {
		Vector3.new(-3.8, 0, -1.8), Vector3.new( 3.8, 0, -1.8),
		Vector3.new(-3.8, 0,  1.8), Vector3.new( 3.8, 0,  1.8),
	} do
		AB.block(Vector3.new(0.3, 4, 0.3), WHEEL_DARK,
			AB.offset(originCF, pos.X, 7, pos.Z), model, "AwningPost_" .. i)
	end

	-- Two big spoked wheels on each side
	for i, x in {-3, 3} do
		AB.cylinder(3.4, 0.4, WHEEL_DARK,
			AB.offset(originCF, x, 1.7, -2.4), model, "Wheel_" .. i)
		-- Spokes (4 per wheel)
		for s = 1, 4 do
			local angle = (s - 1) * math.pi / 2
			AB.part({
				size  = Vector3.new(0.2, 3, 0.2),
				color = Color3.fromRGB(140, 100, 50),
				cf    = AB.offset(originCF, x, 1.7, -2.3) * CFrame.Angles(0, 0, angle),
				name  = string.format("Spoke_%d_%d", i, s),
			}, model)
		end
		-- Hub
		AB.sphere(0.6, Color3.fromRGB(120, 90, 50),
			AB.offset(originCF, x, 1.7, -2.2), model, "Hub_" .. i)
	end

	-- Push handle
	AB.block(Vector3.new(0.3, 0.3, 3), WOOD_LIGHT,
		AB.offset(originCF, 0, 5, -3.2), model, "Handle")
	AB.block(Vector3.new(2, 0.3, 0.3), WOOD_LIGHT,
		AB.offset(originCF, 0, 5, -4.5), model, "HandleGrip")

	AB.pivot(model, body)
	AB.weldAll(model)
	return model
end
