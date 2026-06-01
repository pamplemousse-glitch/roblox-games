-- VintageCadillacTeal — same shape as VintageCadillacRed but seafoam teal.
local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("VintageCadillacTeal", parent)
	local TEAL   = Color3.fromRGB(127, 202, 194)
	local CHROME = Color3.fromRGB(176, 176, 176)
	local WHITE  = Color3.fromRGB(245, 245, 240)
	local BLACK  = Color3.fromRGB(35, 35, 35)
	local SKY    = Color3.fromRGB(170, 220, 240)
	local RED_TAIL = Color3.fromRGB(220, 30, 40)

	local lower = AB.block(Vector3.new(18, 1.5, 5), TEAL, AB.offset(originCF, 0, 1.8, 0), model, "LowerBody")
	AB.block(Vector3.new(18.2, 0.4, 5.2), CHROME, AB.offset(originCF, 0, 1, 0), model, "Rocker")
	AB.block(Vector3.new(10, 2.5, 4.5), TEAL, AB.offset(originCF, -1, 4, 0), model, "UpperBody")
	local wind = AB.block(Vector3.new(2, 2.4, 4.4), SKY, AB.offset(originCF, 3.5, 4, 0) * CFrame.Angles(0, 0, math.rad(-25)), model, "Windshield")
	wind.Material = Enum.Material.Glass; wind.Transparency = 0.4
	local rear = AB.block(Vector3.new(2, 2.4, 4.4), SKY, AB.offset(originCF, -6, 4, 0) * CFrame.Angles(0, 0, math.rad(25)), model, "RearShield")
	rear.Material = Enum.Material.Glass; rear.Transparency = 0.4
	local sideL = AB.block(Vector3.new(8, 2, 0.2), SKY, AB.offset(originCF, -1, 4.5, 2.3), model, "SideWinL")
	sideL.Material = Enum.Material.Glass; sideL.Transparency = 0.4
	local sideR = AB.block(Vector3.new(8, 2, 0.2), SKY, AB.offset(originCF, -1, 4.5, -2.3), model, "SideWinR")
	sideR.Material = Enum.Material.Glass; sideR.Transparency = 0.4
	AB.block(Vector3.new(5, 0.5, 4.5), TEAL, AB.offset(originCF, 5.5, 2.85, 0), model, "Hood")
	AB.block(Vector3.new(5, 0.5, 4.5), TEAL, AB.offset(originCF, -7.5, 2.85, 0), model, "Trunk")
	AB.block(Vector3.new(8, 0.4, 4.4), TEAL, AB.offset(originCF, -1, 5.4, 0), model, "Roof")
	AB.wedge(Vector3.new(3, 2, 0.5), TEAL, AB.offset(originCF, -8.5, 4, 2.3) * CFrame.Angles(0, math.rad(-90), 0), model, "FinL")
	AB.wedge(Vector3.new(3, 2, 0.5), TEAL, AB.offset(originCF, -8.5, 4, -2.3) * CFrame.Angles(0, math.rad(90), 0), model, "FinR")
	local tailL = AB.sphere(0.5, RED_TAIL, AB.offset(originCF, -8.8, 3, 1.7), model, "TailL")
	AB.neon(tailL); AB.glow(tailL, RED_TAIL, 1.0)
	local tailR = AB.sphere(0.5, RED_TAIL, AB.offset(originCF, -8.8, 3, -1.7), model, "TailR")
	AB.neon(tailR); AB.glow(tailR, RED_TAIL, 1.0)
	for i = -3, 3 do
		AB.block(Vector3.new(0.4, 1, 3), CHROME, AB.offset(originCF, 8.6, 2, i * 0.55), model, "Tooth_" .. i)
	end
	AB.block(Vector3.new(0.3, 1.5, 4), CHROME, AB.offset(originCF, 8.7, 2.2, 0), model, "GrilleSurround")
	local headL = AB.sphere(0.7, WHITE, AB.offset(originCF, 8.7, 2.3, 1.7), model, "HeadL"); AB.neon(headL); AB.glow(headL, WHITE, 1.5)
	local headR = AB.sphere(0.7, WHITE, AB.offset(originCF, 8.7, 2.3, -1.7), model, "HeadR"); AB.neon(headR); AB.glow(headR, WHITE, 1.5)
	AB.block(Vector3.new(0.6, 0.8, 5), CHROME, AB.offset(originCF, 8.95, 1.4, 0), model, "FrontBumper")
	AB.block(Vector3.new(0.6, 0.8, 5), CHROME, AB.offset(originCF, -8.95, 1.4, 0), model, "RearBumper")
	AB.sphere(0.4, CHROME, AB.offset(originCF, 7.5, 3.25, 0), model, "HoodOrnament")
	for i, pos in {Vector3.new(6, 0.8, 2.6), Vector3.new(6, 0.8, -2.6), Vector3.new(-6, 0.8, 2.6), Vector3.new(-6, 0.8, -2.6)} do
		AB.cylinder(2.5, 0.8, BLACK, AB.offset(originCF, pos.X, pos.Y, pos.Z), model, "Tire_" .. i)
		AB.cylinder(2, 0.9, WHITE, AB.offset(originCF, pos.X, pos.Y, pos.Z), model, "Whitewall_" .. i)
		AB.cylinder(1.2, 1, CHROME, AB.offset(originCF, pos.X, pos.Y, pos.Z), model, "Hubcap_" .. i)
	end
	AB.block(Vector3.new(15, 0.3, 0.3), CHROME, AB.offset(originCF, 0, 2.5, 2.55), model, "SideTrimL")
	AB.block(Vector3.new(15, 0.3, 0.3), CHROME, AB.offset(originCF, 0, 2.5, -2.55), model, "SideTrimR")
	AB.sphere(0.5, CHROME, AB.offset(originCF, 3, 4.6, 2.5), model, "MirrorL")
	AB.cylinder(2, 0.6, BLACK, AB.offset(originCF, -9.5, 2.2, 0) * CFrame.Angles(0, math.rad(90), 0), model, "SpareTire")

	AB.pivot(model, lower)
	AB.weldAll(model)
	return model
end
