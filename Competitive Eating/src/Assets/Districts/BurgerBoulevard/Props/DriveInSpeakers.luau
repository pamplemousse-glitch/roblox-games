-- DriveInSpeakers — a pair of drive-in movie speaker posts on cables, the kind
-- you hang from your car window. Two posts with hanging speakers.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("DriveInSpeakers", parent)

	local POLE_GRAY = Color3.fromRGB(120, 120, 125)
	local SPEAKER   = Color3.fromRGB(60, 60, 65)
	local CHROME    = Color3.fromRGB(176, 176, 176)
	local CABLE     = Color3.fromRGB(30, 30, 30)
	local NEON      = Color3.fromRGB(255, 220, 80)

	-- Concrete base pad
	AB.cylinder(2, 0.5, Color3.fromRGB(110, 110, 110), AB.offset(originCF, -2, 0.25, 0), model, "PadL").Material = Enum.Material.Concrete
	AB.cylinder(2, 0.5, Color3.fromRGB(110, 110, 110), AB.offset(originCF, 2, 0.25, 0), model, "PadR").Material = Enum.Material.Concrete

	-- Two posts (4 studs apart)
	local poleL = AB.cylinder(0.8, 6, POLE_GRAY, AB.offset(originCF, -2, 3.5, 0), model, "PostL")
	poleL.Material = Enum.Material.Metal
	local poleR = AB.cylinder(0.8, 6, POLE_GRAY, AB.offset(originCF, 2, 3.5, 0), model, "PostR")
	poleR.Material = Enum.Material.Metal

	-- Crossbar between posts
	AB.cylinder(0.4, 4.4, CHROME, AB.offset(originCF, 0, 6.5, 0) * CFrame.Angles(0, 0, math.rad(90)), model, "Crossbar")

	-- Hanging speaker bodies (one on each pole)
	-- Speaker housing
	AB.block(Vector3.new(2, 2.5, 1.5), SPEAKER, AB.offset(originCF, -2, 5, 0.5), model, "SpkL_Body")
	AB.block(Vector3.new(2, 2.5, 1.5), SPEAKER, AB.offset(originCF, 2, 5, 0.5), model, "SpkR_Body")
	-- Cones (round front face)
	AB.cylinder(1.6, 0.6, CHROME, AB.offset(originCF, -2, 5, 1.4) * CFrame.Angles(0, math.rad(90), 0), model, "SpkL_Cone")
	AB.cylinder(1.6, 0.6, CHROME, AB.offset(originCF, 2, 5, 1.4) * CFrame.Angles(0, math.rad(90), 0), model, "SpkR_Cone")
	-- Speaker dust caps
	AB.sphere(0.5, POLE_GRAY, AB.offset(originCF, -2, 5, 1.6), model, "SpkL_Dust")
	AB.sphere(0.5, POLE_GRAY, AB.offset(originCF, 2, 5, 1.6), model, "SpkR_Dust")

	-- Volume knob on each speaker
	AB.cylinder(0.4, 0.3, CHROME, AB.offset(originCF, -2.5, 4, 1.3) * CFrame.Angles(0, math.rad(90), 0), model, "SpkL_Knob")
	AB.cylinder(0.4, 0.3, CHROME, AB.offset(originCF, 2.5, 4, 1.3) * CFrame.Angles(0, math.rad(90), 0), model, "SpkR_Knob")

	-- Hanging hooks (chrome bracket)
	AB.block(Vector3.new(0.3, 1, 0.3), CHROME, AB.offset(originCF, -2, 6.5, 0.3), model, "SpkL_Hook")
	AB.block(Vector3.new(0.3, 1, 0.3), CHROME, AB.offset(originCF, 2, 6.5, 0.3), model, "SpkR_Hook")

	-- Number plate on each speaker (drive-in stall #)
	local plateL = AB.block(Vector3.new(1, 0.5, 0.2), NEON, AB.offset(originCF, -2, 5.8, 1.4), model, "PlateL")
	AB.neon(plateL); AB.glow(plateL, NEON, 0.8)
	AB.billboard(plateL, "12", Vector2.new(40, 30), 0)
	local plateR = AB.block(Vector3.new(1, 0.5, 0.2), NEON, AB.offset(originCF, 2, 5.8, 1.4), model, "PlateR")
	AB.neon(plateR); AB.glow(plateR, NEON, 0.8)
	AB.billboard(plateR, "13", Vector2.new(40, 30), 0)

	-- Cable hanging down (suggesting power line)
	AB.block(Vector3.new(0.15, 3, 0.15), CABLE, AB.offset(originCF, -2, 3, 0.8), model, "CableL")
	AB.block(Vector3.new(0.15, 3, 0.15), CABLE, AB.offset(originCF, 2, 3, 0.8), model, "CableR")

	AB.pivot(model, poleL)
	AB.weldAll(model)
	return model
end
