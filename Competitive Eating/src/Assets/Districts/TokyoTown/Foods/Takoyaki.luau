-- Takoyaki — 6 octopus balls on a paper boat tray with sauce zigzag + bonito flakes.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PAPER_WHITE = Color3.fromRGB(245, 240, 230)
local BALL_BROWN  = Color3.fromRGB(190, 130, 70)
local SAUCE_DARK  = Color3.fromRGB(80, 40, 30)
local MAYO        = Color3.fromRGB(245, 240, 210)
local BONITO_PINK = Color3.fromRGB(230, 200, 170)
local AONORI      = Color3.fromRGB(80, 130, 80)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("Takoyaki", parent)

	-- Paper boat tray (white, slight upturn implied via raised lip)
	local tray = AB.block(
		Vector3.new(5.6, 0.2, 4.2),
		PAPER_WHITE,
		AB.offset(originCF, 0, 0.1, 0),
		model,
		"Tray"
	)
	-- Side lips for the boat feel
	for i, z in {-2.0, 2.0} do
		AB.block(
			Vector3.new(5.6, 0.4, 0.1),
			PAPER_WHITE,
			AB.offset(originCF, 0, 0.4, z),
			model,
			"Lip_" .. i
		)
	end

	-- 6 takoyaki balls in 2 rows × 3
	local idx = 0
	for row = 0, 1 do
		for col = 0, 2 do
			idx += 1
			local x = (col - 1) * 1.6
			local z = (row == 0) and -0.7 or 0.7
			AB.sphere(1.4, BALL_BROWN, AB.offset(originCF, x, 0.95, z), model, "Ball_" .. idx)

			-- Sauce dollop on top
			AB.sphere(0.55, SAUCE_DARK, AB.offset(originCF, x, 1.5, z), model, "Sauce_" .. idx)
		end
	end

	-- Mayo zigzag — three thin blocks across the tray
	for i, z in {-1.2, 0, 1.2} do
		AB.block(
			Vector3.new(4.6, 0.08, 0.18),
			MAYO,
			AB.offset(originCF, 0, 1.7, z, (i % 2 == 0) and 4 or -4),
			model,
			"Mayo_" .. i
		)
	end

	-- Bonito flakes & aonori sprinkle (small chip blocks)
	for i, offset in {
		Vector3.new(-1.5, 0.0,  0.0),
		Vector3.new( 0.5, 0.0, -0.3),
		Vector3.new( 1.8, 0.0,  0.4),
		Vector3.new(-0.4, 0.0,  0.6),
	} do
		AB.block(
			Vector3.new(0.5, 0.05, 0.25),
			BONITO_PINK,
			AB.offset(originCF, offset.X, 1.75, offset.Z, math.random(0, 60)),
			model,
			"Bonito_" .. i
		)
	end
	for i, offset in {Vector3.new(-1, 0, -0.5), Vector3.new(0.8, 0, 0.8)} do
		AB.block(
			Vector3.new(0.18, 0.04, 0.18),
			AONORI,
			AB.offset(originCF, offset.X, 1.74, offset.Z),
			model,
			"Aonori_" .. i
		)
	end

	AB.pivot(model, tray)
	AB.weldAll(model)
	return model
end
