-- VintageCadillacRed — classic 50s land yacht in candy-apple red. Tail fins,
-- chrome bumper, whitewall tires, big grille.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local function buildCadillac(parent: Instance, originCF: CFrame, name: string, bodyColor: Color3): Model
	local model = AB.model(name, parent)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local WHITE  = Color3.fromRGB(245, 245, 240)
	local BLACK  = Color3.fromRGB(35, 35, 35)
	local SKY    = Color3.fromRGB(170, 220, 240)
	local INTERIOR = Color3.fromRGB(220, 50, 50)

	-- Main lower body (long)
	local lower = AB.block(Vector3.new(18, 1.5, 5), bodyColor, AB.offset(originCF, 0, 1.8, 0), model, "LowerBody")
	-- Rocker chrome strip
	AB.block(Vector3.new(18.2, 0.4, 5.2), CHROME, AB.offset(originCF, 0, 1, 0), model, "Rocker")
	-- Upper passenger compartment (shorter than lower)
	local upper = AB.block(Vector3.new(10, 2.5, 4.5), bodyColor, AB.offset(originCF, -1, 4, 0), model, "UpperBody")
	-- Windshield + rear window
	local windshield = AB.block(Vector3.new(2, 2.4, 4.4), SKY, AB.offset(originCF, 3.5, 4, 0) * CFrame.Angles(0, 0, math.rad(-25)), model, "Windshield")
	windshield.Material = Enum.Material.Glass; windshield.Transparency = 0.4
	local rearShield = AB.block(Vector3.new(2, 2.4, 4.4), SKY, AB.offset(originCF, -6, 4, 0) * CFrame.Angles(0, 0, math.rad(25)), model, "RearShield")
	rearShield.Material = Enum.Material.Glass; rearShield.Transparency = 0.4
	-- Side windows (smaller)
	local sideL = AB.block(Vector3.new(8, 2, 0.2), SKY, AB.offset(originCF, -1, 4.5, 2.3), model, "SideWinL")
	sideL.Material = Enum.Material.Glass; sideL.Transparency = 0.4
	local sideR = AB.block(Vector3.new(8, 2, 0.2), SKY, AB.offset(originCF, -1, 4.5, -2.3), model, "SideWinR")
	sideR.Material = Enum.Material.Glass; sideR.Transparency = 0.4

	-- Hood
	local hood = AB.block(Vector3.new(5, 0.5, 4.5), bodyColor, AB.offset(originCF, 5.5, 2.85, 0), model, "Hood")
	-- Trunk
	AB.block(Vector3.new(5, 0.5, 4.5), bodyColor, AB.offset(originCF, -7.5, 2.85, 0), model, "Trunk")
	-- Roof
	AB.block(Vector3.new(8, 0.4, 4.4), bodyColor, AB.offset(originCF, -1, 5.4, 0), model, "Roof")

	-- TAIL FINS (signature Cadillac)
	AB.wedge(Vector3.new(3, 2, 0.5), bodyColor, AB.offset(originCF, -8.5, 4, 2.3) * CFrame.Angles(0, math.rad(-90), 0), model, "FinL")
	AB.wedge(Vector3.new(3, 2, 0.5), bodyColor, AB.offset(originCF, -8.5, 4, -2.3) * CFrame.Angles(0, math.rad(90), 0), model, "FinR")
	-- Taillights (red, neon)
	local tailL = AB.sphere(0.5, INTERIOR, AB.offset(originCF, -8.8, 3, 1.7), model, "TailL")
	AB.neon(tailL); AB.glow(tailL, INTERIOR, 1.0)
	local tailR = AB.sphere(0.5, INTERIOR, AB.offset(originCF, -8.8, 3, -1.7), model, "TailR")
	AB.neon(tailR); AB.glow(tailR, INTERIOR, 1.0)

	-- Front grille (chrome teeth)
	for i = -3, 3 do
		AB.block(Vector3.new(0.4, 1, 3), CHROME, AB.offset(originCF, 8.6, 2, i * 0.55), model, "Tooth_" .. i)
	end
	AB.block(Vector3.new(0.3, 1.5, 4), CHROME, AB.offset(originCF, 8.7, 2.2, 0), model, "GrilleSurround")

	-- Headlights (cream neon)
	local headL = AB.sphere(0.7, WHITE, AB.offset(originCF, 8.7, 2.3, 1.7), model, "HeadL")
	AB.neon(headL); AB.glow(headL, WHITE, 1.5)
	local headR = AB.sphere(0.7, WHITE, AB.offset(originCF, 8.7, 2.3, -1.7), model, "HeadR")
	AB.neon(headR); AB.glow(headR, WHITE, 1.5)

	-- Front + rear chrome bumpers
	AB.block(Vector3.new(0.6, 0.8, 5), CHROME, AB.offset(originCF, 8.95, 1.4, 0), model, "FrontBumper")
	AB.block(Vector3.new(0.6, 0.8, 5), CHROME, AB.offset(originCF, -8.95, 1.4, 0), model, "RearBumper")

	-- Hood ornament
	AB.sphere(0.4, CHROME, AB.offset(originCF, 7.5, 3.25, 0), model, "HoodOrnament")
	AB.block(Vector3.new(0.2, 1, 0.6), CHROME, AB.offset(originCF, 7.5, 3.6, 0), model, "HoodFin")

	-- Wheels (4) — whitewalls
	for i, pos in {Vector3.new(6, 0.8, 2.6), Vector3.new(6, 0.8, -2.6), Vector3.new(-6, 0.8, 2.6), Vector3.new(-6, 0.8, -2.6)} do
		local tire = AB.cylinder(2.5, 0.8, BLACK, AB.offset(originCF, pos.X, pos.Y, pos.Z), model, "Tire_" .. i)
		-- Whitewall inner
		AB.cylinder(2, 0.9, WHITE, AB.offset(originCF, pos.X, pos.Y, pos.Z), model, "Whitewall_" .. i)
		-- Chrome hubcap
		AB.cylinder(1.2, 1, CHROME, AB.offset(originCF, pos.X, pos.Y, pos.Z), model, "Hubcap_" .. i)
	end

	-- Side chrome trim spear (down the body)
	AB.block(Vector3.new(15, 0.3, 0.3), CHROME, AB.offset(originCF, 0, 2.5, 2.55), model, "SideTrimL")
	AB.block(Vector3.new(15, 0.3, 0.3), CHROME, AB.offset(originCF, 0, 2.5, -2.55), model, "SideTrimR")

	-- Side mirror
	AB.sphere(0.5, CHROME, AB.offset(originCF, 3, 4.6, 2.5), model, "MirrorL")
	AB.cylinder(0.2, 1, CHROME, AB.offset(originCF, 3, 4.4, 2.3), model, "MirrorStemL")

	-- Continental kit (spare tire on rear) -- optional luxury touch
	AB.cylinder(2, 0.6, BLACK, AB.offset(originCF, -9.5, 2.2, 0) * CFrame.Angles(0, math.rad(90), 0), model, "SpareTire")

	AB.pivot(model, lower)
	AB.weldAll(model)
	return model
end

return function(parent: Instance, originCF: CFrame): Model
	return buildCadillac(parent, originCF, "VintageCadillacRed", Color3.fromRGB(180, 35, 40))
end
