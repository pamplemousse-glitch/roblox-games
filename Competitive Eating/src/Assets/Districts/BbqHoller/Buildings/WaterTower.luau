-- Water Tower — wooden tank on tall splayed legs with cross-bracing,
-- conical roof, side ladder, "BBQ HOLLER" painted on the tank.

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local WOOD      = Color3.fromRGB(107, 68, 35)
local DARK_WOOD = Color3.fromRGB(70, 45, 22)
local ROOF      = Color3.fromRGB(50, 35, 25)
local STRAW     = Color3.fromRGB(232, 200, 112)
local STEEL     = Color3.fromRGB(120, 120, 125)

return function(parent: Instance, originCF: CFrame): Model
	local model = AB.model("WaterTower", parent)

	-- Foundation pad
	local foundation = AB.block(Vector3.new(12, 0.4, 12), DARK_WOOD, AB.offset(originCF, 0, 0.2, 0), model, "Foundation")

	-- 4 splayed legs (slight outward tilt)
	for i, p in {Vector3.new(-4.5, 12, 4.5), Vector3.new(4.5, 12, 4.5), Vector3.new(-4.5, 12, -4.5), Vector3.new(4.5, 12, -4.5)} do
		local leg = AB.block(Vector3.new(0.8, 24, 0.8), WOOD, originCF * CFrame.new(p), model, "Leg_" .. i)
		-- Splay each leg by tilting it slightly outward
		local sx = (p.X > 0) and -3 or 3
		local sz = (p.Z > 0) and -3 or 3
		leg.CFrame = leg.CFrame * CFrame.Angles(math.rad(sz), 0, math.rad(sx))
	end

	-- Cross-bracing (X between legs on each face)
	for i, face in {{-4.5, 4.5, 4.5, 4.5}, {-4.5, -4.5, 4.5, -4.5}, {-4.5, 4.5, -4.5, -4.5}, {4.5, -4.5, 4.5, 4.5}} do
		local cx = (face[1] + face[3]) / 2
		local cz = (face[2] + face[4]) / 2
		local b1 = AB.block(Vector3.new(0.4, 12, 0.4), DARK_WOOD, AB.offset(originCF, cx, 9, cz), model, "Brace1_" .. i)
		b1.CFrame = b1.CFrame * CFrame.Angles(0, 0, math.rad(35))
		local b2 = AB.block(Vector3.new(0.4, 12, 0.4), DARK_WOOD, AB.offset(originCF, cx, 9, cz), model, "Brace2_" .. i)
		b2.CFrame = b2.CFrame * CFrame.Angles(0, 0, math.rad(-35))
	end

	-- Tank platform
	AB.block(Vector3.new(13, 0.6, 13), DARK_WOOD, AB.offset(originCF, 0, 22, 0), model, "TankPlatform")

	-- Water tank (chunky cylinder built from a wide cylinder)
	local tank = AB.cylinder(11, 11, WOOD, AB.offset(originCF, 0, 28, 0), model, "Tank")
	-- Plank bands around the tank
	for i, y in {25, 28, 31} do
		AB.cylinder(11.2, 0.4, DARK_WOOD, AB.offset(originCF, 0, y, 0), model, "Band_" .. i)
	end

	-- Conical roof (steep wedges around)
	for i = 1, 8 do
		local angle = (i / 8) * math.pi * 2
		local wedge = AB.wedge(Vector3.new(7, 4, 7), ROOF,
			AB.offset(originCF, math.cos(angle) * 2.5, 35, math.sin(angle) * 2.5),
			model, "RoofPanel_" .. i)
		wedge.CFrame = wedge.CFrame * CFrame.Angles(0, -angle, 0)
	end
	-- Roof finial
	AB.block(Vector3.new(0.5, 3, 0.5), STEEL, AB.offset(originCF, 0, 38, 0), model, "RoofFinial")
	AB.sphere(1, STEEL, AB.offset(originCF, 0, 40, 0), model, "FinialBall")

	-- Side ladder
	local ladderX = 5.6
	AB.block(Vector3.new(0.3, 22, 0.3), STEEL, AB.offset(originCF, ladderX, 11, 5.6), model, "LadderRailL")
	AB.block(Vector3.new(0.3, 22, 0.3), STEEL, AB.offset(originCF, ladderX, 11, 4.6), model, "LadderRailR")
	for r = 1, 10 do
		AB.block(Vector3.new(0.4, 0.2, 1.2), STEEL, AB.offset(originCF, ladderX, 2 + (r - 1) * 2, 5.1), model, "LadderRung_" .. r)
	end

	-- Painted "BBQ HOLLER" sign on the front of the tank
	local sign = AB.block(Vector3.new(8, 3, 0.2), STRAW, AB.offset(originCF, 0, 28, 5.4), model, "TankSign")
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.LightInfluence = 0
	gui.Parent = sign
	local lbl = Instance.new("TextLabel")
	lbl.Size              = UDim2.fromScale(1, 1)
	lbl.BackgroundTransparency = 1
	lbl.Font              = Enum.Font.GothamBlack
	lbl.Text              = "BBQ HOLLER"
	lbl.TextColor3        = Color3.fromRGB(160, 40, 40)
	lbl.TextStrokeColor3  = Color3.new(0, 0, 0)
	lbl.TextStrokeTransparency = 0.4
	lbl.TextScaled        = true
	lbl.Parent            = gui

	AB.pivot(model, foundation)
	AB.weldAll(model)
	return model
end
