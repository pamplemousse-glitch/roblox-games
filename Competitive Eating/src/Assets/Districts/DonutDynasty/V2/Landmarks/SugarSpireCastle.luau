-- SugarSpireCastle — fairy-tale castle landmark with cream walls,
-- pink conical turret roofs, gold trim, and a mint-glowing keep.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local PINK   = Color3.fromRGB(255, 200, 214)
local DEEP   = Color3.fromRGB(232, 130, 165)
local CREAM  = Color3.fromRGB(255, 240, 220)
local BROWN  = Color3.fromRGB(92,  57,  36)
local GOLD   = Color3.fromRGB(212, 168, 82)
local MINT   = Color3.fromRGB(180, 230, 200)
local NEONPK = Color3.fromRGB(255, 110, 170)
local GLASS  = Color3.fromRGB(210, 235, 250)

local function buildTurret(model: Model, originCF: CFrame, x: number, z: number, baseY: number, height: number, radius: number, roofColor: Color3, name: string)
	-- Tower body
	AB.cylinder(radius * 2, height, CREAM,
		AB.offset(originCF, x, baseY + height / 2, z), model, name .. "_Body")
	-- Stripe near top
	AB.cylinder(radius * 2 + 0.2, 0.6, GOLD,
		AB.offset(originCF, x, baseY + height - 0.5, z), model, name .. "_TrimTop")
	AB.cylinder(radius * 2 + 0.2, 0.6, GOLD,
		AB.offset(originCF, x, baseY + 0.5, z), model, name .. "_TrimBot")

	-- Windows around tower (4 cardinal)
	for i, dir in {{1, 0}, {-1, 0}, {0, 1}, {0, -1}} do
		local wx = x + dir[1] * radius
		local wz = z + dir[2] * radius
		local yawDeg = math.deg(math.atan2(-dir[1], dir[2]))
		local g = AB.block(Vector3.new(0.3, 1.8, 0.8), GLASS,
			AB.offset(originCF, wx, baseY + height * 0.55, wz, yawDeg), model, name .. "_Win_" .. i)
		g.Transparency = 0.4
		g.Material = Enum.Material.Glass
	end

	-- Conical roof (stacked cones via wedge X-cross trick)
	local coneSize = radius * 2.3
	AB.wedge(Vector3.new(coneSize, height * 0.6, coneSize),
		roofColor,
		AB.offset(originCF, x, baseY + height + (height * 0.6) / 2 - 0.5, z),
		model, name .. "_RoofA")
	AB.wedge(Vector3.new(coneSize, height * 0.6, coneSize),
		roofColor,
		AB.offset(originCF, x, baseY + height + (height * 0.6) / 2 - 0.5, z) * CFrame.Angles(0, math.rad(90), 0),
		model, name .. "_RoofB")
	AB.wedge(Vector3.new(coneSize, height * 0.6, coneSize),
		roofColor,
		AB.offset(originCF, x, baseY + height + (height * 0.6) / 2 - 0.5, z) * CFrame.Angles(0, math.rad(180), 0),
		model, name .. "_RoofC")
	AB.wedge(Vector3.new(coneSize, height * 0.6, coneSize),
		roofColor,
		AB.offset(originCF, x, baseY + height + (height * 0.6) / 2 - 0.5, z) * CFrame.Angles(0, math.rad(270), 0),
		model, name .. "_RoofD")

	-- Spire on top
	AB.cylinder(0.5, 3, GOLD,
		AB.offset(originCF, x, baseY + height + height * 0.6 + 1.5, z), model, name .. "_Spire")
	local finial = AB.sphere(1, NEONPK,
		AB.offset(originCF, x, baseY + height + height * 0.6 + 3.5, z), model, name .. "_Finial")
	AB.neon(finial)
	AB.glow(finial, NEONPK, 2.5)

	-- Banner flag
	AB.wedge(Vector3.new(0.15, 1.4, 1.5), DEEP,
		AB.offset(originCF, x + 0.6, baseY + height + height * 0.6 + 2.8, z) * CFrame.Angles(0, math.rad(90), 0),
		model, name .. "_Flag")
end

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("SugarSpireCastle", parent)

	-- Stone foundation (cobblestone effect via two-tone tiles)
	for i = 1, 6 do
		for j = 1, 6 do
			local x = -16 + (i - 1) * 6.5
			local z = -16 + (j - 1) * 6.5
			local col = ((i + j) % 2 == 0) and BROWN or Color3.fromRGB(140, 100, 80)
			AB.block(Vector3.new(6, 0.5, 6), col,
				AB.offset(originCF, x, 0.25, z), model, "Cobble_" .. i .. "_" .. j)
		end
	end

	-- Main keep (central tall block)
	AB.block(Vector3.new(16, 24, 16), CREAM,
		AB.offset(originCF, 0, 12.5, 0), model, "KeepBody")
	AB.block(Vector3.new(16.2, 0.8, 16.2), GOLD,
		AB.offset(originCF, 0, 24.5, 0), model, "KeepTopTrim")
	-- Crenellations on top of keep
	for i = 1, 5 do
		local x = -7 + (i - 1) * 3.5
		AB.block(Vector3.new(2, 2, 16.4), CREAM,
			AB.offset(originCF, x, 25.8, 0), model, "KeepCrenel_" .. i)
	end
	-- Side crenellations
	for i = 1, 5 do
		local z = -7 + (i - 1) * 3.5
		AB.block(Vector3.new(16.4, 2, 2), CREAM,
			AB.offset(originCF, 0, 25.8, z), model, "KeepCrenelZ_" .. i)
	end

	-- Mint-glowing windows on keep
	for floor = 1, 3 do
		local y = 8 + (floor - 1) * 6
		for i, x in {-5, 0, 5} do
			local g = AB.block(Vector3.new(1.6, 3, 0.3), MINT,
				AB.offset(originCF, x, y, 8.1), model, "KeepWin_" .. floor .. "_" .. i)
			AB.neon(g)
			g.Transparency = 0.3
		end
	end

	-- Main gate (arched dark wood) on front
	AB.block(Vector3.new(5, 7, 0.4), BROWN, AB.offset(originCF, 0, 4, 8.2), model, "Gate")
	AB.cylinder(5, 0.5, BROWN, AB.offset(originCF, 0, 7.5, 8.2) * CFrame.Angles(0, 0, 0), model, "GateArch")
	AB.sphere(0.4, GOLD, AB.offset(originCF, -1.6, 4, 8.4), model, "GateKnocker")

	-- Gold portcullis bars on gate
	for i = 1, 5 do
		local x = -2.2 + (i - 1) * 1.1
		AB.block(Vector3.new(0.15, 6.5, 0.15), GOLD, AB.offset(originCF, x, 4, 8.4), model, "GateBar_" .. i)
	end

	-- 4 corner turrets
	buildTurret(model, originCF, -13, -13, 1, 28, 3, PINK,   "TurretBL")
	buildTurret(model, originCF,  13, -13, 1, 28, 3, PINK,   "TurretBR")
	buildTurret(model, originCF, -13,  13, 1, 32, 3, DEEP,   "TurretFL")
	buildTurret(model, originCF,  13,  13, 1, 32, 3, DEEP,   "TurretFR")

	-- Central tallest spire turret directly on top of keep
	buildTurret(model, originCF, 0, 0, 28, 18, 4, NEONPK, "CentralSpire")

	-- Outer walls connecting turrets (sectioned)
	-- Back wall
	AB.block(Vector3.new(22, 8, 1.5), CREAM, AB.offset(originCF, 0, 5, -13.5), model, "WallBack")
	-- Side walls
	AB.block(Vector3.new(1.5, 8, 22), CREAM, AB.offset(originCF, -13.5, 5, 0), model, "WallLeft")
	AB.block(Vector3.new(1.5, 8, 22), CREAM, AB.offset(originCF, 13.5, 5, 0), model, "WallRight")
	-- Front wall split for gate
	AB.block(Vector3.new(7, 8, 1.5), CREAM, AB.offset(originCF, -7.5, 5, 13.5), model, "WallFrontL")
	AB.block(Vector3.new(7, 8, 1.5), CREAM, AB.offset(originCF, 7.5, 5, 13.5), model, "WallFrontR")
	-- Crenellations on outer walls (just along front)
	for i = 1, 14 do
		local x = -13 + (i - 1) * 2
		if math.abs(x) < 2.5 then continue end
		AB.block(Vector3.new(1, 1.4, 1.5), CREAM,
			AB.offset(originCF, x, 9.2, 13.5), model, "OuterCrenel_" .. i)
	end

	-- Drawbridge approach (planks)
	for i = 1, 5 do
		AB.block(Vector3.new(5, 0.3, 1.4), BROWN,
			AB.offset(originCF, 0, 0.6, 15 + (i - 1) * 1.5), model, "BridgePlank_" .. i)
	end

	-- Mint shrubs flanking gate
	for i, x in {-7, 7} do
		AB.block(Vector3.new(2.2, 1.2, 2.2), GOLD,
			AB.offset(originCF, x, 0.6, 15), model, "GateShrubPot_" .. i)
		AB.sphere(2.4, MINT, AB.offset(originCF, x, 2.4, 15), model, "GateShrub_" .. i)
	end

	AB.pivot(model)
	AB.weldAll(model)
	return model
end
