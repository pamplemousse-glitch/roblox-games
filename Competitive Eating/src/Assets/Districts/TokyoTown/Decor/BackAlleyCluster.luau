-- BackAlleyCluster — generic "Japanese back-alley" decor cluster placed
-- BEHIND a Cube 3D hero building to mask its plain back face. Sells the alley
-- look with AC unit + kitchen vent + sake barrels + trash bin + bike rack +
-- kanji-poster fly-post. originCF points OUTWARD from the building's back
-- (positive local Z = away from the wall the cluster is masking).

local AB = require(game:GetService("ReplicatedStorage").Common.AssetBuilder)

local COL = {
	ac        = Color3.fromRGB(200, 200, 200),
	acDark    = Color3.fromRGB(120, 120, 120),
	pipe      = Color3.fromRGB(140, 140, 140),
	vent      = Color3.fromRGB(70, 70, 70),
	barrelTan = Color3.fromRGB(160, 110, 70),
	barrelHoop= Color3.fromRGB(60, 40, 25),
	binBlue   = Color3.fromRGB(40, 70, 130),
	binLid    = Color3.fromRGB(30, 50, 90),
	bikeFrame = Color3.fromRGB(60, 60, 60),
	posterRed = Color3.fromRGB(180, 40, 40),
	posterCream = Color3.fromRGB(245, 235, 215),
	wallStain = Color3.fromRGB(80, 70, 60),
}

return function(parent: Instance, originCF: CFrame): Model
	local model = Instance.new("Model")
	model.Name = "BackAlleyCluster"

	-- Wall-mounted AC unit at ~6 studs up
	local ac = AB.block(Vector3.new(3.2, 2.2, 1.4), COL.ac, AB.offset(originCF, -4, 6, 0.5), model, "AC_Unit")
	AB.block(Vector3.new(2.6, 1.4, 0.4), COL.acDark, AB.offset(originCF, -4, 6, 1.3), model, "AC_Grille")

	-- Pipe descending from the AC to the ground
	AB.cylinder(0.6, 5.5, COL.pipe, AB.offset(originCF, -3.4, 3.0, 0.6), model, "AC_DripPipe")

	-- Kitchen exhaust vent (rooftop-style box near top of wall)
	AB.block(Vector3.new(2.4, 1.8, 2.4), COL.vent, AB.offset(originCF, 4, 7.5, 0.8), model, "Exhaust_Vent")
	AB.cylinder(1.2, 1.6, COL.pipe, AB.offset(originCF, 4, 9.2, 0.8, 0), model, "Exhaust_Stack")

	-- Sake barrel pair
	AB.cylinder(2.8, 2.6, COL.barrelTan, AB.offset(originCF, 2, 1.4, 1.8) * CFrame.Angles(0, 0, math.rad(90)), model, "SakeBarrel_A")
	AB.cylinder(2.8, 2.6, COL.barrelTan, AB.offset(originCF, 4.6, 1.4, 1.8) * CFrame.Angles(0, 0, math.rad(90)), model, "SakeBarrel_B")
	-- Barrel hoops (thin black bands)
	AB.cylinder(2.9, 0.25, COL.barrelHoop, AB.offset(originCF, 2, 0.7, 1.8) * CFrame.Angles(0, 0, math.rad(90)), model, "BarrelHoop_A1")
	AB.cylinder(2.9, 0.25, COL.barrelHoop, AB.offset(originCF, 2, 2.1, 1.8) * CFrame.Angles(0, 0, math.rad(90)), model, "BarrelHoop_A2")
	AB.cylinder(2.9, 0.25, COL.barrelHoop, AB.offset(originCF, 4.6, 0.7, 1.8) * CFrame.Angles(0, 0, math.rad(90)), model, "BarrelHoop_B1")
	AB.cylinder(2.9, 0.25, COL.barrelHoop, AB.offset(originCF, 4.6, 2.1, 1.8) * CFrame.Angles(0, 0, math.rad(90)), model, "BarrelHoop_B2")

	-- Trash bin (blue plastic, common in Tokyo alleys)
	AB.block(Vector3.new(1.8, 2.6, 1.8), COL.binBlue, AB.offset(originCF, -1.2, 1.3, 2.4), model, "TrashBin")
	AB.block(Vector3.new(2.0, 0.3, 2.0), COL.binLid, AB.offset(originCF, -1.2, 2.75, 2.4), model, "TrashBin_Lid")

	-- Bike leaning (frame + 2 wheels)
	local bikeCF = AB.offset(originCF, -6, 1.4, 2.8, 75)
	AB.block(Vector3.new(0.18, 2.5, 0.18), COL.bikeFrame, bikeCF * CFrame.new(0, 0, 0), model, "BikeFrame_Down")
	AB.block(Vector3.new(0.18, 1.6, 0.18), COL.bikeFrame, bikeCF * CFrame.new(0.6, 0.4, 0) * CFrame.Angles(0, 0, math.rad(60)), model, "BikeFrame_Top")
	AB.cylinder(2.0, 0.25, COL.bikeFrame, bikeCF * CFrame.new(1.2, -1.0, 0) * CFrame.Angles(math.rad(90), 0, 0), model, "BikeWheel_Front")
	AB.cylinder(2.0, 0.25, COL.bikeFrame, bikeCF * CFrame.new(-1.2, -1.0, 0) * CFrame.Angles(math.rad(90), 0, 0), model, "BikeWheel_Rear")

	-- Kanji fly-post on the wall (cream paper, red border, kanji text)
	local poster = AB.block(Vector3.new(2.2, 3.0, 0.1), COL.posterCream, AB.offset(originCF, 7, 5.5, 0.1), model, "KanjiPoster")
	do
		local sgui = Instance.new("SurfaceGui")
		sgui.Face = Enum.NormalId.Front
		sgui.AlwaysOnTop = false
		sgui.PixelsPerStud = 50
		sgui.Parent = poster
		local frame = Instance.new("Frame")
		frame.Size = UDim2.fromScale(1, 1)
		frame.BackgroundColor3 = COL.posterCream
		frame.BorderSizePixel = 0
		frame.Parent = sgui
		local stripe = Instance.new("Frame")
		stripe.Size = UDim2.new(1, 0, 0, 8)
		stripe.Position = UDim2.fromScale(0, 0)
		stripe.BackgroundColor3 = COL.posterRed
		stripe.BorderSizePixel = 0
		stripe.Parent = frame
		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.Text = "営業中"  -- "open for business"
		label.Font = Enum.Font.GothamBold
		label.TextScaled = true
		label.TextColor3 = Color3.fromRGB(50, 30, 30)
		label.Parent = frame
	end

	model.Parent = parent
	return model
end
